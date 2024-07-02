-- Variables

QBCore = exports['qb-core']:GetCoreObject()
Drops = {}
Trunks = {}
Gloveboxes = {}
Stashes = {}
ShopItems = {}

-- Functions

function LoadInventory(source, citizenid)
    local inventory = MySQL.prepare.await('SELECT inventory FROM players WHERE citizenid = ?', { citizenid })
	local loadedInventory = {}
    local missingItems = {}

    if not inventory then return loadedInventory end

	inventory = json.decode(inventory)
	if table.type(inventory) == 'empty' then return loadedInventory end

	for _, item in pairs(inventory) do
		if item then
			local itemInfo = QBCore.Shared.Items[item.name:lower()]
			if itemInfo then
				loadedInventory[item.slot] = {
					name = itemInfo['name'],
					amount = item.amount,
					info = item.info or '',
					label = itemInfo['label'],
					description = itemInfo['description'] or '',
					weight = itemInfo['weight'],
					type = itemInfo['type'],
					unique = itemInfo['unique'],
					useable = itemInfo['useable'],
					image = itemInfo['image'],
					shouldClose = itemInfo['shouldClose'],
					slot = item.slot,
					combinable = itemInfo['combinable'],
					created = item.created,
				}
			else
				missingItems[#missingItems + 1] = item.name:lower()
			end
		end
	end

    if #missingItems > 0 then
        print(('The following items were removed for player %s as they no longer exist'):format(GetPlayerName(source)))
		QBCore.Debug(missingItems)
    end

    return loadedInventory
end exports('LoadInventory', LoadInventory)

function SaveInventory(source, offline)
	local PlayerData
	if not offline then
		local Player = QBCore.Functions.GetPlayer(source)

		if not Player then return end

		PlayerData = Player.PlayerData
	else
		PlayerData = source
	end

    local items = PlayerData.items
    local ItemsJson = {}
    if items and table.type(items) ~= 'empty' then
        for slot, item in pairs(items) do
            if items[slot] then
                ItemsJson[#ItemsJson+1] = {
                    name = item.name,
                    amount = item.amount,
                    info = item.info,
                    type = item.type,
                    slot = slot,
					created = item.created
                }
            end
        end
        MySQL.prepare('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode(ItemsJson), PlayerData.citizenid })
    else
        MySQL.prepare('UPDATE players SET inventory = ? WHERE citizenid = ?', { '[]', PlayerData.citizenid })
    end
end exports('SaveInventory', SaveInventory)

function GetTotalWeight(items)
	local weight = 0
    if not items then return 0 end
    for _, item in pairs(items) do
        weight += item.weight * item.amount
    end
    return tonumber(weight)
end exports('GetTotalWeight', GetTotalWeight)

function GetSlotsByItem(items, itemName)
    local slotsFound = {}
    if not items then return slotsFound end
    for slot, item in pairs(items) do
        if item.name:lower() == itemName:lower() then
            slotsFound[#slotsFound+1] = slot
        end
    end
    return slotsFound
end exports('GetSlotsByItem', GetSlotsByItem)

function GetFirstSlotByItem(items, itemName)
    if not items then return nil end
    for slot, item in pairs(items) do
        if item.name:lower() == itemName:lower() then
            return tonumber(slot)
        end
    end
    return nil
end exports('GetFirstSlotByItem', GetFirstSlotByItem)

function AddItem(source, item, amount, slot, info)
	local Player = QBCore.Functions.GetPlayer(source)

	if not Player then return false end

	local totalWeight = GetTotalWeight(Player.PlayerData.items)
	local itemInfo = QBCore.Shared.Items[item:lower()]
	if not itemInfo and not Player.Offline then
		lib.notify(source, {
			title = 'Inventory',
			description = 'Item does not exist',
			type = 'error',
		})
		return false
	end

	amount = tonumber(amount) or 1
	slot = tonumber(slot) or GetFirstSlotByItem(Player.PlayerData.items, item)
	info = info or {}
	info.created = info.created or os.time()
	info.quality = info.quality or 100

	if amount < 0 then
		return false
	end
	if slot and Shared.MaxInventorySlots < slot then
		return false
	end
	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
	end
	if (totalWeight + (itemInfo['weight'] * amount)) <= Shared.MaxInventoryWeight then
		if item == 'phone' then
			TriggerClientEvent('lb-phone:itemAdded', source)
		end
		if (slot and Player.PlayerData.items[slot]) and (Player.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo['type'] == 'item' and not itemInfo['unique']) then
			if Player.PlayerData.items[slot].info.quality >= (info.quality - 1) then
				if Player.PlayerData.items[slot].amount < 0 then
					return false
				end
				Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount + amount
				Player.Functions.SetPlayerData('items', Player.PlayerData.items)
				if Player.Offline then return true end

				TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
				return true
			else
				for i = 1, Shared.MaxInventorySlots, 1 do
					if Player.PlayerData.items[i] and Player.PlayerData.items[i].name:lower() == item:lower() and Player.PlayerData.items[i].info.quality >= (info.quality - 1) then
						if Player.PlayerData.items[i].amount < 0 then
							return false
						end
						Player.PlayerData.items[i].amount = Player.PlayerData.items[i].amount + amount
						Player.Functions.SetPlayerData('items', Player.PlayerData.items)
						if Player.Offline then return true end

						TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
						return true
					end
					if Player.PlayerData.items[i] == nil then
						Player.PlayerData.items[i] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = i, combinable = itemInfo['combinable'] }
						Player.Functions.SetPlayerData('items', Player.PlayerData.items)
						if Player.Offline then return true end

						TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
						return true
					end
				end
			end
		elseif not itemInfo['unique'] and slot or slot and Player.PlayerData.items[slot] == nil then
			Player.PlayerData.items[slot] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = slot, combinable = itemInfo['combinable'] }
			Player.Functions.SetPlayerData('items', Player.PlayerData.items)

			if Player.Offline then return true end

			TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
			return true
		elseif itemInfo['unique'] or (not slot or slot == nil) or itemInfo['type'] == 'weapon' then
			for i = 1, Shared.MaxInventorySlots, 1 do
				if Player.PlayerData.items[i] == nil then
					Player.PlayerData.items[i] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = i, combinable = itemInfo['combinable'] }
					Player.Functions.SetPlayerData('items', Player.PlayerData.items)

					if Player.Offline then return true end
					TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. i .. '], itemname: ' .. Player.PlayerData.items[i].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[i].amount)
					return true
				end
			end
		end
	elseif not Player.Offline then
		lib.notify(source, {
			title = 'Inventory',
            description = 'You can\'t carry more items!',
            type = 'error',
        })
	end
	return false
end exports('AddItem', AddItem)

function RemoveItem(source, item, amount, slot)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if not Player then return false end

	amount = tonumber(amount) or 1
	slot = tonumber(slot)

	if item == 'phone' then
		TriggerClientEvent('lb-phone:itemRemoved', src)
	end

	if slot then
		if not Player.PlayerData.items[slot] then
			local playerName = GetPlayerName(src)
			DropPlayer(src, 'Failed to remove item, Cheating')
			TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'Cheating', 'red', '**' .. playerName .. '** (citizenid: ' .. Player.PlayerData.citizenid .. ') attempted to remove item from invalid slot. Reason: most likely cheating.')
			return false
		end

		if Player.PlayerData.items[slot].amount > amount then
			Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount - amount
			Player.Functions.SetPlayerData('items', Player.PlayerData.items)

			if not Player.Offline then
				TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', removed amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
			end

			return true
		elseif Player.PlayerData.items[slot].amount == amount then
			Player.PlayerData.items[slot] = nil
			Player.Functions.SetPlayerData('items', Player.PlayerData.items)

			if Player.Offline then return true end

			TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. item .. ', removed amount: ' .. amount .. ', item removed')

			return true
		end
	else
		local slots = GetSlotsByItem(Player.PlayerData.items, item)
		local amountToRemove = amount

		if not slots then return false end

		for _, _slot in pairs(slots) do
			if not Player.PlayerData.items[_slot] then
				local playerName = GetPlayerName(src)
				DropPlayer(src, 'Failed to remove item, Cheating')
				TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'Cheating', 'red', '**' .. playerName .. '** (citizenid: ' .. Player.PlayerData.citizenid .. ') attempted to remove item from invalid slot. Reason: most likely cheating.')
				return false
			end

			if Player.PlayerData.items[_slot].amount > amountToRemove then
				Player.PlayerData.items[_slot].amount = Player.PlayerData.items[_slot].amount - amountToRemove
				Player.Functions.SetPlayerData('items', Player.PlayerData.items)

				if not Player.Offline then
					TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. _slot .. '], itemname: ' .. Player.PlayerData.items[_slot].name .. ', removed amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[_slot].amount)
				end

				return true
			elseif Player.PlayerData.items[_slot].amount == amountToRemove then
				Player.PlayerData.items[_slot] = nil
				Player.Functions.SetPlayerData('items', Player.PlayerData.items)

				if Player.Offline then return true end

				TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. _slot .. '], itemname: ' .. item .. ', removed amount: ' .. amount .. ', item removed')

				return true
			end
		end
	end
	return false
end exports('RemoveItem', RemoveItem)

function GetItemBySlot(source, slot)
	local Player = QBCore.Functions.GetPlayer(source)
	slot = tonumber(slot)
	return Player.PlayerData.items[slot]
end exports('GetItemBySlot', GetItemBySlot)

function GetItemByName(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	item = tostring(item):lower()
	local slot = GetFirstSlotByItem(Player.PlayerData.items, item)
	return Player.PlayerData.items[slot]
end exports('GetItemByName', GetItemByName)

function GetItemsByName(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	item = tostring(item):lower()
	local items = {}
	local slots = GetSlotsByItem(Player.PlayerData.items, item)
	for _, slot in pairs(slots) do
		if slot then
			items[#items+1] = Player.PlayerData.items[slot]
		end
	end
	return items
end exports('GetItemsByName', GetItemsByName)

function ClearInventory(source, filterItems)
	local Player = QBCore.Functions.GetPlayer(source)
	local savedItemData = {}

	if filterItems then
		local filterItemsType = type(filterItems)
		if filterItemsType == 'string' then
			local item = GetItemByName(source, filterItems)

			if item then
				savedItemData[item.slot] = item
			end
		elseif filterItemsType == 'table' and table.type(filterItems) == 'array' then
			for i = 1, #filterItems do
				local item = GetItemByName(source, filterItems[i])

				if item then
					savedItemData[item.slot] = item
				end
			end
		end
	end

	Player.Functions.SetPlayerData('items', savedItemData)

	if Player.Offline then return end

	TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'ClearInventory', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** inventory cleared')
end exports('ClearInventory', ClearInventory)

function SetInventory(source, items)
	local Player = QBCore.Functions.GetPlayer(source)

	Player.Functions.SetPlayerData('items', items)

	if Player.Offline then return end

	TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'SetInventory', 'blue', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** items set: ' .. json.encode(items))
end exports('SetInventory', SetInventory)

function SetItemData(source, itemName, key, val)
	if not itemName or not key then return false end

	local Player = QBCore.Functions.GetPlayer(source)

	if not Player then return end

	local item = GetItemByName(source, itemName)

	if not item then return false end

	item[key] = val
	Player.PlayerData.items[item.slot] = item
	Player.Functions.SetPlayerData('items', Player.PlayerData.items)

	return true
end exports('SetItemData', SetItemData)

function HasItem(source, items, amount, list, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local isTable = type(items) == 'table'
    local isArray = isTable and table.type(items) == 'array' or false
    local totalItems = #items
    local count = 0
    local kvIndex = 2

    if isTable and not isArray then
        totalItems = 0
        for _ in pairs(items) do totalItems += 1 end
        kvIndex = 1
    end
    if isTable then
        for k, v in pairs(items) do
            local itemKV = {k, v}
            local item = GetItemByName(source, itemKV[kvIndex])
            if item and ((amount and item.amount >= amount) or (not isArray and item.amount >= v) or (not amount and isArray)) then
                count += 1
            end
        end
        if count == totalItems then
            return true
        end
    else -- Single item as string
        local item = GetItemByName(source, items)
        if item and (not amount or (item and amount and item.amount >= amount)) then
            return true
        end
    end
	if list then
		for i = 1, #list do

    	    if item == list[i] then
    	        return true
    	    end
    	end
	end
    return false
end exports('HasItem', HasItem)

function CreateUsableItem(itemName, data)
	QBCore.Functions.CreateUseableItem(itemName, data)
end exports('CreateUsableItem', CreateUsableItem)

function GetUsableItem(itemName)
	return QBCore.Functions.CanUseItem(itemName)
end exports('GetUsableItem', GetUsableItem)

function UseItem(itemName, ...)
	local itemData = GetUsableItem(itemName)
	local callback = type(itemData) == 'table' and (rawget(itemData, '__cfx_functionReference') and itemData or itemData.cb or itemData.callback) or type(itemData) == 'function' and itemData
	if not callback then return end
	callback(...)
end exports('UseItem', UseItem)

function recipeContains(recipe, fromItem)
	for _, v in pairs(recipe.accept) do
		if v == fromItem.name then
			return true
		end
	end

	return false
end

function IsVehicleOwned(plate)
    local result = MySQL.scalar.await('SELECT 1 from player_vehicles WHERE plate = ?', {plate})
    return result
end

function SetupShopItems(shopItems)
	local items = {}
	if shopItems and next(shopItems) then
		for _, item in pairs(shopItems) do
			local itemInfo = QBCore.Shared.Items[item.name:lower()]
			if itemInfo then
				items[item.slot] = {
					name = itemInfo['name'],
					amount = tonumber(item.amount),
					info = item.info or '',
					label = itemInfo['label'],
					description = itemInfo['description'] or '',
					weight = itemInfo['weight'],
					type = itemInfo['type'],
					unique = itemInfo['unique'],
					useable = itemInfo['useable'],
					price = item.price,
					image = itemInfo['image'],
					slot = item.slot,
				}
			end
		end
	end
	return items
end

function GetStashItems(stashId)
	local items = {}
	local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', {stashId})
	if not result then return items end

	local stashItems = json.decode(result)
	if not stashItems then return items end

	for _, item in pairs(stashItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo['name'],
				amount = tonumber(item.amount),
				info = item.info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = item.created,
				slot = item.slot,
			}
		end
	end
	return items
end exports('GetStashItems', GetStashItems)

function SaveStashItems(stashId, items, isclosed)
	if Stashes[stashId].label == 'Stash-None' or not items then return end

	for _, item in pairs(items) do
		item.description = nil
	end

	MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['stash'] = stashId,
		['items'] = json.encode(items)
	})

	Stashes[stashId].isOpen = isclosed
end

function AddToStash(stashId, slot, otherslot, itemName, amount, info, created)
	amount = tonumber(amount) or 1
	local ItemData = QBCore.Shared.Items[itemName]
	if not ItemData.unique then
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = slot,
			}
		end
	else
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Stashes[stashId].items[otherslot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = otherslot,
			}
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = slot,
			}
		end
	end

	SaveStashItems(stashId, Stashes[stashId].items, true)
end

function RemoveFromStash(stashId, slot, itemName, amount)
	amount = tonumber(amount) or 1
	if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
		if Stashes[stashId].items[slot].amount > amount then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount - amount
		else
			Stashes[stashId].items[slot] = nil
		end
	else
		Stashes[stashId].items[slot] = nil
		if Stashes[stashId].items == nil then
			Stashes[stashId].items[slot] = nil
		end
	end
end

function GetOwnedVehicleItems(plate)
	local items = {}
	local result = MySQL.scalar.await('SELECT items FROM trunkitems WHERE plate = ?', {plate})
	if not result then return items end

	local trunkItems = json.decode(result)
	if not trunkItems then return items end

	for _, item in pairs(trunkItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo['name'],
				amount = tonumber(item.amount),
				info = item.info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = item.created,
				slot = item.slot,
			}
		end
	end
	return items
end

function SaveOwnedVehicleItems(plate, items, isclosed)
	if Trunks[plate].label == 'Trunk-None' or not items then return end

	for _, item in pairs(items) do
		item.description = nil
	end

	MySQL.insert('INSERT INTO trunkitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['plate'] = plate,
		['items'] = json.encode(items)
	})

	Trunks[plate].isOpen = isclosed
end

function AddToTrunk(plate, slot, otherslot, itemName, amount, info, created)
	amount = tonumber(amount) or 1
	local ItemData = QBCore.Shared.Items[itemName]

	if not ItemData.unique then
		if Trunks[plate].items[slot] and Trunks[plate].items[slot].name == itemName then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = slot,
			}
		end
	else
		if Trunks[plate].items[slot] and Trunks[plate].items[slot].name == itemName then
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Trunks[plate].items[otherslot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = otherslot,
			}
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = slot,
			}
		end
	end

	if IsVehicleOwned(plate) then
		SaveOwnedVehicleItems(plate, Trunks[plate].items, true)
	end
end

function RemoveFromTrunk(plate, slot, itemName, amount)
	amount = tonumber(amount) or 1
	if Trunks[plate].items[slot] and Trunks[plate].items[slot].name == itemName then
		if Trunks[plate].items[slot].amount > amount then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount - amount
		else
			Trunks[plate].items[slot] = nil
		end
	else
		Trunks[plate].items[slot] = nil
		if Trunks[plate].items == nil then
			Trunks[plate].items[slot] = nil
		end
	end
	if IsVehicleOwned(plate) then
		SaveOwnedVehicleItems(plate, Trunks[plate].items, true)
	end
end

function GetOwnedVehicleGloveboxItems(plate)
	local items = {}
	local result = MySQL.scalar.await('SELECT items FROM gloveboxitems WHERE plate = ?', {plate})
	if not result then return items end

	local gloveboxItems = json.decode(result)
	if not gloveboxItems then return items end

	for _, item in pairs(gloveboxItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo['name'],
				amount = tonumber(item.amount),
				info = item.info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = item.created,
				slot = item.slot,
			}
		end
	end
	return items
end

function SaveOwnedGloveboxItems(plate, items, isclosed)
	if Gloveboxes[plate].label == 'Glovebox-None' or not items then return end

	for _, item in pairs(items) do
		item.description = nil
	end

	MySQL.insert('INSERT INTO gloveboxitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['plate'] = plate,
		['items'] = json.encode(items)
	})

	Gloveboxes[plate].isOpen = isclosed
end

function AddToGlovebox(plate, slot, otherslot, itemName, amount, info, created)
	amount = tonumber(amount) or 1
	local ItemData = QBCore.Shared.Items[itemName]

	if not ItemData.unique then
		if Gloveboxes[plate].items[slot] and Gloveboxes[plate].items[slot].name == itemName then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount + amount
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = slot,
			}
		end
	else
		if Gloveboxes[plate].items[slot] and Gloveboxes[plate].items[slot].name == itemName then
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[otherslot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = otherslot,
			}
		else
			local itemInfo = QBCore.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo['name'],
				amount = amount,
				info = info or '',
				label = itemInfo['label'],
				description = itemInfo['description'] or '',
				weight = itemInfo['weight'],
				type = itemInfo['type'],
				unique = itemInfo['unique'],
				useable = itemInfo['useable'],
				image = itemInfo['image'],
				created = created,
				slot = slot,
			}
		end
	end
	if IsVehicleOwned(plate) then
		SaveOwnedGloveboxItems(plate, Gloveboxes[plate].items, true)
	end
end

function RemoveFromGlovebox(plate, slot, itemName, amount)
	amount = tonumber(amount) or 1
	if Gloveboxes[plate].items[slot] and Gloveboxes[plate].items[slot].name == itemName then
		if Gloveboxes[plate].items[slot].amount > amount then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount - amount
		else
			Gloveboxes[plate].items[slot] = nil
		end
	else
		Gloveboxes[plate].items[slot] = nil
		if Gloveboxes[plate].items == nil then
			Gloveboxes[plate].items[slot] = nil
		end
	end
	if IsVehicleOwned(plate) then
		SaveOwnedGloveboxItems(plate, Gloveboxes[plate].items, true)
	end
end

function AddToDrop(dropId, slot, itemName, amount, info)
	amount = tonumber(amount) or 1
	Drops[dropId].createdTime = os.time()
	if Drops[dropId].items[slot] and Drops[dropId].items[slot].name == itemName then
		Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount + amount
	else
		local itemInfo = QBCore.Shared.Items[itemName:lower()]
		Drops[dropId].items[slot] = {
			name = itemInfo['name'],
			amount = amount,
			info = info or '',
			label = itemInfo['label'],
			description = itemInfo['description'] or '',
			weight = itemInfo['weight'],
			type = itemInfo['type'],
			unique = itemInfo['unique'],
			useable = itemInfo['useable'],
			image = itemInfo['image'],
			slot = slot,
			id = dropId,
		}
	end
end

function RemoveFromDrop(dropId, slot, itemName, amount)
	amount = tonumber(amount) or 1
	Drops[dropId].createdTime = os.time()
	if Drops[dropId].items[slot] and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].amount > amount then
			Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount - amount
		else
			Drops[dropId].items[slot] = nil
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
		end
	end
end

function CreateDropId()
    local id
    repeat
        id = math.random(10000, 99999)
    until not Drops or not Drops[id]
    return id
end
function CreateNewDrop(source, fromSlot, toSlot, itemAmount)
	itemAmount = tonumber(itemAmount) or 1
	local Player = QBCore.Functions.GetPlayer(source)
	local itemData = GetItemBySlot(source, fromSlot)

	if not itemData then return end

	local coords = GetEntityCoords(GetPlayerPed(source))
	if RemoveItem(source, itemData.name, itemAmount, itemData.slot) then
		TriggerClientEvent('inventory:client:CheckWeapon', source)
		local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].coords = coords
		Drops[dropId].createdTime = os.time()

		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo['name'],
			amount = itemAmount,
			info = itemData.info or '',
			label = itemInfo['label'],
			description = itemInfo['description'] or '',
			weight = itemInfo['weight'],
			type = itemInfo['type'],
			unique = itemInfo['unique'],
			useable = itemInfo['useable'],
			image = itemInfo['image'],
			slot = toSlot,
			id = dropId,
		}
		TriggerEvent('qb-log:server:CreateLog', 'drop', 'New Item Drop', 'red', '**'.. GetPlayerName(source) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..source..'*) dropped new item; name: **'..itemData.name..'**, amount: **' .. itemAmount .. '**')
		TriggerClientEvent('inventory:client:DropItemAnim', source)
		TriggerClientEvent('inventory:client:AddDropItem', -1, dropId, source, coords)
		if itemData.name:lower() == 'radio' then
			TriggerClientEvent('Radio.Set', source, false)
		end
	else
		lib.notify(source, {
			title = 'Inventory',
			description = 'You don\'t have this item!',
			type = 'error',
		})
		return
	end
end

function addTrunkItems(plate, items)
	Trunks[plate] = {}
	Trunks[plate].items = items
end exports('addTrunkItems', addTrunkItems)

function getTrunkItems(plate)
	if not Trunks[plate] then return end
	return Trunks[plate].items
end exports('getTrunkItems', getTrunkItems)

function addGloveboxItems(plate, items)
	Gloveboxes[plate] = {}
	Gloveboxes[plate].items = items
end exports('addGloveboxItems', addGloveboxItems)

function OpenInventory(name, id, other)
	local src = source
	local ply = Player(src)
	local Player = QBCore.Functions.GetPlayer(src)
	if ply.state.inv_busy then
		return lib.notify(src, { title = 'Inventory', description = 'You can\'t open the inventory right now.', type = 'error' })
	end
	if name and id then
		local secondInv = {}
		if name == 'stash' then
			if Stashes[id] then
				if Stashes[id].isOpen then
					local Target = QBCore.Functions.GetPlayer(Stashes[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
					else
						Stashes[id].isOpen = false
					end
				end
			end
			local maxweight = 1000000
			local slots = 50
			if other then
				maxweight = other.maxweight or 1000000
				slots = other.slots or 50
			end
			secondInv.name = 'stash-'..id
			secondInv.label = 'Stash-'..id
			secondInv.maxweight = maxweight
			secondInv.inventory = {}
			secondInv.slots = slots
			if Stashes[id] and Stashes[id].isOpen then
				secondInv.name = 'none-inv'
				secondInv.label = 'Stash-None'
				secondInv.maxweight = 1000000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local stashItems = GetStashItems(id)
				if next(stashItems) then
					secondInv.inventory = stashItems
					Stashes[id] = {}
					Stashes[id].items = stashItems
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				else
					Stashes[id] = {}
					Stashes[id].items = {}
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				end
			end
		elseif name == 'trunk' then
			if Trunks[id] then
				if Trunks[id].isOpen then
					local Target = QBCore.Functions.GetPlayer(Trunks[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
					else
						Trunks[id].isOpen = false
					end
				end
			end
			secondInv.name = 'trunk-'..id
			secondInv.label = 'Trunk-'..id
			secondInv.maxweight = other.maxweight or 60000
			secondInv.inventory = {}
			secondInv.slots = other.slots or 50
			if (Trunks[id] and Trunks[id].isOpen) or (QBCore.Shared.SplitStr(id, 'PLZI')[2] and (Player.PlayerData.job.name ~= 'police' or Player.PlayerData.job.name ~= 'sheriff')) then
				secondInv.name = 'none-inv'
				secondInv.label = 'Trunk-None'
				secondInv.maxweight = other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				if id then
					local ownedItems = GetOwnedVehicleItems(id)
					if Trunks[id] and not Trunks[id].isOpen then
						secondInv.inventory = Trunks[id].items
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					elseif IsVehicleOwned(id) and next(ownedItems) then
						secondInv.inventory = ownedItems
						Trunks[id] = {}
						Trunks[id].items = ownedItems
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					else
						Trunks[id] = {}
						Trunks[id].items = {}
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					end
				end
			end
		elseif name == 'glovebox' then
			if Gloveboxes[id] then
				if Gloveboxes[id].isOpen then
					local Target = QBCore.Functions.GetPlayer(Gloveboxes[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
					else
						Gloveboxes[id].isOpen = false
					end
				end
			end
			secondInv.name = 'glovebox-'..id
			secondInv.label = 'Glovebox-'..id
			secondInv.maxweight = 20000
			secondInv.inventory = {}
			secondInv.slots = 12
			if Gloveboxes[id] and Gloveboxes[id].isOpen then
				secondInv.name = 'none-inv'
				secondInv.label = 'Glovebox-None'
				secondInv.maxweight = 20000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local ownedItems = GetOwnedVehicleGloveboxItems(id)
				if Gloveboxes[id] and not Gloveboxes[id].isOpen then
					secondInv.inventory = Gloveboxes[id].items
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				elseif IsVehicleOwned(id) and next(ownedItems) then
					secondInv.inventory = ownedItems
					Gloveboxes[id] = {}
					Gloveboxes[id].items = ownedItems
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				else
					Gloveboxes[id] = {}
					Gloveboxes[id].items = {}
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				end
			end
		elseif name == 'shop' then
			secondInv.name = 'itemshop-'..id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = SetupShopItems(other.items)
			ShopItems[id] = {}
			ShopItems[id].items = other.items
			secondInv.slots = #other.items
		elseif name == 'otherplayer' then
			local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(id))
			if OtherPlayer then
				secondInv.name = 'otherplayer-'..id
				secondInv.label = 'Player-'..id
				secondInv.maxweight = Shared.MaxInventoryWeight
				secondInv.inventory = OtherPlayer.PlayerData.items
				secondInv.slots = Shared.MaxInventorySlots
				Wait(250)
			end
		else
			if Drops[id] then
				if Drops[id].isOpen then
					local Target = QBCore.Functions.GetPlayer(Drops[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Drops[id].isOpen, name, id, Drops[id].label)
					else
						Drops[id].isOpen = false
					end
				end
			end
			if Drops[id] and not Drops[id].isOpen then
				secondInv.coords = Drops[id].coords
				secondInv.name = id
				secondInv.label = 'Dropped-'..tostring(id)
				secondInv.maxweight = 100000
				secondInv.inventory = Drops[id].items
				secondInv.slots = 40
				Drops[id].isOpen = src
				Drops[id].label = secondInv.label
				Drops[id].createdTime = os.time()
			else
				secondInv.name = 'none-inv'
				secondInv.label = 'Dropped-None'
				secondInv.maxweight = 100000
				secondInv.inventory = {}
				secondInv.slots = 0
			end
		end
		TriggerClientEvent('inventory:client:closeinv', id)
		TriggerClientEvent('inventory:client:OpenInventory', src, {}, Player.PlayerData.items, secondInv, os.time())
	else
		TriggerClientEvent('inventory:client:OpenInventory', src, {}, Player.PlayerData.items, nil, os.time())
	end
end exports('OpenInventory', OpenInventory)