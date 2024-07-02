-- Events

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'AddItem', function(item, amount, slot, info)
		return AddItem(Player.PlayerData.source, item, amount, slot, info)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'RemoveItem', function(item, amount, slot)
		return RemoveItem(Player.PlayerData.source, item, amount, slot)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemBySlot', function(slot)
		return GetItemBySlot(Player.PlayerData.source, slot)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemByName', function(item)
		return GetItemByName(Player.PlayerData.source, item)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemsByName', function(item)
		return GetItemsByName(Player.PlayerData.source, item)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'ClearInventory', function(filterItems)
		ClearInventory(Player.PlayerData.source, filterItems)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'SetInventory', function(items)
		SetInventory(Player.PlayerData.source, items)
	end)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName ~= GetCurrentResourceName() then return end
	local Players = QBCore.Functions.GetQBPlayers()
	for k in pairs(Players) do
		QBCore.Functions.AddPlayerMethod(k, 'AddItem', function(item, amount, slot, info)
			return AddItem(k, item, amount, slot, info)
		end)

		QBCore.Functions.AddPlayerMethod(k, 'RemoveItem', function(item, amount, slot)
			return RemoveItem(k, item, amount, slot)
		end)

		QBCore.Functions.AddPlayerMethod(k, 'GetItemBySlot', function(slot)
			return GetItemBySlot(k, slot)
		end)

		QBCore.Functions.AddPlayerMethod(k, 'GetItemByName', function(item)
			return GetItemByName(k, item)
		end)

		QBCore.Functions.AddPlayerMethod(k, 'GetItemsByName', function(item)
			return GetItemsByName(k, item)
		end)

		QBCore.Functions.AddPlayerMethod(k, 'ClearInventory', function(filterItems)
			ClearInventory(k, filterItems)
		end)

		QBCore.Functions.AddPlayerMethod(k, 'SetInventory', function(items)
			SetInventory(k, items)
		end)
	end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local inventories = {Stashes, Trunks, Gloveboxes, Drops}
    for _, inventory in pairs(inventories) do
        for _, inv in pairs(inventory) do
            if inv.isOpen == src then
                inv.isOpen = false
            end
        end
    end
end)

RegisterNetEvent('QBCore:Server:UpdateObject', function()
    if source ~= '' then return end
	QBCore = exports['qb-core']:GetCoreObject()
end)

RegisterNetEvent('inventory:server:addTrunkItems', function(plate, items)
	Trunks[plate] = {}
	Trunks[plate].items = items
end)

RegisterNetEvent('inventory:server:addTrunkItems', function(plate, items)
	addTrunkItems(plate, items)
end)

RegisterNetEvent('inventory:server:addGloveboxItems', function(plate, items)
	addGloveboxItems(plate, items)
end)

RegisterNetEvent('inventory:server:combineItem', function(item, fromItem, toItem)
	local src = source

	if fromItem == nil  then return end
	if toItem == nil then return end

	fromItem = GetItemByName(src, fromItem)
	toItem = GetItemByName(src, toItem)

	if fromItem == nil  then return end
	if toItem == nil then return end

	local recipe = QBCore.Shared.Items[toItem.name].combinable

	if recipe and recipe.reward ~= item then return end
	if not recipeContains(recipe, fromItem) then return end

	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
	AddItem(src, item, 1)
	RemoveItem(src, fromItem.name, 1)
	RemoveItem(src, toItem.name, 1)
end)

RegisterNetEvent('inventory:server:SetIsOpenState', function(IsOpen, type, id)
	if IsOpen then return end

	if type == 'stash' then
		Stashes[id].isOpen = false
	elseif type == 'trunk' then
		Trunks[id].isOpen = false
	elseif type == 'glovebox' then
		Gloveboxes[id].isOpen = false
	elseif type == 'drop' then
		Drops[id].isOpen = false
	end
end)

RegisterNetEvent('inventory:server:OpenInventory', function(name, id, other)
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
end)

RegisterNetEvent('inventory:server:SaveInventory', function(type, id)
	if type == 'trunk' then
		if IsVehicleOwned(id) then
			SaveOwnedVehicleItems(id, Trunks[id].items, false)
		else
			Trunks[id].isOpen = false
		end
	elseif type == 'glovebox' then
		if (IsVehicleOwned(id)) then
			SaveOwnedGloveboxItems(id, Gloveboxes[id].items, false)
		else
			Gloveboxes[id].isOpen = false
		end
	elseif type == 'stash' then
		SaveStashItems(id, Stashes[id].items, false)
	elseif type == 'drop' then
		if Drops[id] then
			Drops[id].isOpen = false
			if Drops[id].items == nil or next(Drops[id].items) == nil then
				Drops[id] = nil
				TriggerClientEvent('inventory:client:RemoveDropItem', -1, id)
			end
		end
	end
end)

RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source
	local itemData = GetItemBySlot(src, slot)
	if not itemData then return end
	local itemInfo = QBCore.Shared.Items[itemData.name]
	if itemData.type == 'weapon' then
		TriggerClientEvent('inventory:client:UseWeapon', src, itemData, itemData.info.quality and itemData.info.quality > 0)
		TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, 'use')
	elseif itemData.useable then
		if itemData.info and itemData.info.quality and itemData.info.quality > 0 then
			UseItem(itemData.name, src, itemData)
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, 'use')
		else
			lib.notify(src, {
				title = 'Inventory',
				description = 'You can\'t use this item',
				type = 'error',
			})
		end
	end
end)

RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
	local src = source
	if inventory ~= 'player' and inventory ~= 'hotbar' then return end
	local itemData = GetItemBySlot(src, item.slot)
	if not itemData then return end
	local itemInfo = QBCore.Shared.Items[itemData.name]
	if itemData.type == 'weapon' then
		TriggerClientEvent('inventory:client:UseWeapon', src, itemData, itemData.info.quality and itemData.info.quality > 0)
		TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, 'use')
	else
		if itemData.info and itemData.info.quality and itemData.info.quality > 0 then
			UseItem(itemData.name, src, itemData)
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, 'use')
		else
			lib.notify(src, {
				title = 'Inventory',
				description = 'You can\'t use this item!',
				type = 'error',
			})
		end
	end
end)

RegisterNetEvent('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	fromSlot = tonumber(fromSlot)
	toSlot = tonumber(toSlot)

	if (fromInventory == 'player' or fromInventory == 'hotbar') and (QBCore.Shared.SplitStr(toInventory, '-')[1] == 'itemshop') then
		return
	end

	if fromInventory == 'player' or fromInventory == 'hotbar' then
		local fromItemData = GetItemBySlot(src, fromSlot)
		fromAmount = tonumber(fromAmount) or fromItemData.amount
		if fromItemData and fromItemData.amount >= fromAmount then
			if toInventory == 'player' or toInventory == 'hotbar' then
				local toItemData = GetItemBySlot(src, toSlot)
				RemoveItem(src, fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent('inventory:client:CheckWeapon', src)
				if toItemData then
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name or toItemData.unique then
						RemoveItem(src, toItemData.name, toAmount, toSlot)
						AddItem(src, toItemData.name, toAmount, fromSlot, toItemData.info)
					end
				end
                AddItem(src, fromItemData.name, fromAmount, toSlot, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, '-')[1] == 'otherplayer' then
				local playerId = tonumber(QBCore.Shared.SplitStr(toInventory, '-')[2])
				local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				RemoveItem(src, fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent('inventory:client:CheckWeapon', src)
                if toItemData then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveItem(playerId, itemInfo['name'], toAmount, fromSlot)
						AddItem(src, toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'robbing', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | *'..src..'*) swapped item; name: **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** with name: **' .. fromItemData.name .. '**, amount: **' .. fromAmount.. '** with player: **'.. GetPlayerName(OtherPlayer.PlayerData.source) .. '** (citizenid: *'..OtherPlayer.PlayerData.citizenid..'* | id: *'..OtherPlayer.PlayerData.source..'*)')
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					TriggerEvent('qb-log:server:CreateLog', 'robbing', 'Dropped Item', 'red', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | *'..src..'*) dropped new item; name: **'..itemInfo['name']..'**, amount: **' .. fromAmount .. '** to player: **'.. GetPlayerName(OtherPlayer.PlayerData.source) .. '** (citizenid: *'..OtherPlayer.PlayerData.citizenid..'* | id: *'..OtherPlayer.PlayerData.source..'*)')
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddItem(playerId, itemInfo['name'], fromAmount, toSlot, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, '-')[1] == 'trunk' then
				local plate = QBCore.Shared.SplitStr(toInventory, '-')[2]
				local toItemData = Trunks[plate].items[toSlot]
				RemoveItem(src, fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent('inventory:client:CheckWeapon', src)
                if toItemData then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromTrunk(plate, fromSlot, itemInfo['name'], toAmount)
						AddItem(src, toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'trunk', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** with name: **' .. fromItemData.name .. '**, amount: **' .. fromAmount .. '** - plate: *' .. plate .. '*')
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					TriggerEvent('qb-log:server:CreateLog', 'trunk', 'Dropped Item', 'red', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) dropped new item; name: **'..itemInfo['name']..'**, amount: **' .. fromAmount .. '** - plate: *' .. plate .. '*')
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddToTrunk(plate, toSlot, fromSlot, itemInfo['name'], fromAmount, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, '-')[1] == 'glovebox' then
				local plate = QBCore.Shared.SplitStr(toInventory, '-')[2]
				local toItemData = Gloveboxes[plate].items[toSlot]
				RemoveItem(src, fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent('inventory:client:CheckWeapon', src)
                if toItemData then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromGlovebox(plate, fromSlot, itemInfo['name'], toAmount)
						AddItem(src, toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'glovebox', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** with name: **' .. fromItemData.name .. '**, amount: **' .. fromAmount .. '** - plate: *' .. plate .. '*')
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					TriggerEvent('qb-log:server:CreateLog', 'glovebox', 'Dropped Item', 'red', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) dropped new item; name: **'..itemInfo['name']..'**, amount: **' .. fromAmount .. '** - plate: *' .. plate .. '*')
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddToGlovebox(plate, toSlot, fromSlot, itemInfo['name'], fromAmount, fromItemData.info)
			elseif QBCore.Shared.SplitStr(toInventory, '-')[1] == 'stash' then
				local stashId = QBCore.Shared.SplitStr(toInventory, '-')[2]
				local toItemData = Stashes[stashId].items[toSlot]
				RemoveItem(src, fromItemData.name, fromAmount, fromSlot)
				TriggerClientEvent('inventory:client:CheckWeapon', src)
                if toItemData then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveFromStash(stashId, toSlot, itemInfo['name'], toAmount)
						AddItem(src, toItemData.name, toAmount, fromSlot, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'stash', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** with name: **' .. fromItemData.name .. '**, amount: **' .. fromAmount .. '** - stash: *' .. stashId .. '*')
					end
				else
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					TriggerEvent('qb-log:server:CreateLog', 'stash', 'Dropped Item', 'red', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) dropped new item; name: **'..itemInfo['name']..'**, amount: **' .. fromAmount .. '** - stash: *' .. stashId .. '*')
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddToStash(stashId, toSlot, fromSlot, itemInfo['name'], fromAmount, fromItemData.info)
			else
				-- drop
				toInventory = tonumber(toInventory)
				if toInventory == nil or toInventory == 0 then
					CreateNewDrop(src, fromSlot, toSlot, fromAmount)
				else
					local toItemData = Drops[toInventory].items[toSlot]
					RemoveItem(src, fromItemData.name, fromAmount, fromSlot)
					TriggerClientEvent('inventory:client:CheckWeapon', src)
                    if toItemData then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						toAmount = tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							AddItem(src, toItemData.name, toAmount, fromSlot, toItemData.info)
							RemoveFromDrop(toInventory, fromSlot, itemInfo['name'], toAmount)
							TriggerEvent('qb-log:server:CreateLog', 'drop', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** with name: **' .. fromItemData.name .. '**, amount: **' .. fromAmount .. '** - dropid: *' .. toInventory .. '*')
						end
					else
						local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
						TriggerEvent('qb-log:server:CreateLog', 'drop', 'Dropped Item', 'red', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) dropped new item; name: **'..itemInfo['name']..'**, amount: **' .. fromAmount .. '** - dropid: *' .. toInventory .. '*')
					end
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                    AddToDrop(toInventory, toSlot, itemInfo['name'], fromAmount, fromItemData.info)
					if itemInfo['name'] == 'radio' then
						TriggerClientEvent('Radio.Set', src, false)
					end
				end
			end
		else
			lib.notify(source, {
				title = 'Inventory',
				description = 'You don\'t have this item anymore!',
				type = 'error',
			})
		end
	elseif QBCore.Shared.SplitStr(fromInventory, '-')[1] == 'otherplayer' then
		local playerId = tonumber(QBCore.Shared.SplitStr(fromInventory, '-')[2])
		local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
		local fromItemData = OtherPlayer.PlayerData.items[fromSlot]
		fromAmount = tonumber(fromAmount) or fromItemData.amount
		if fromItemData and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == 'player' or toInventory == 'hotbar' then
				local toItemData = GetItemBySlot(src, toSlot)
				RemoveItem(playerId, itemInfo['name'], fromAmount, fromSlot)
				TriggerClientEvent('inventory:client:CheckWeapon', OtherPlayer.PlayerData.source)
				if toItemData then
					itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveItem(src, toItemData.name, toAmount, toSlot)
						AddItem(playerId, itemInfo['name'], toAmount, fromSlot, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'robbing', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** with item; **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** from player: **'.. GetPlayerName(OtherPlayer.PlayerData.source) .. '** (citizenid: *'..OtherPlayer.PlayerData.citizenid..'* | *'..OtherPlayer.PlayerData.source..'*)')
					end
				else
					TriggerEvent('qb-log:server:CreateLog', 'robbing', 'Retrieved Item', 'green', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) took item; name: **'..fromItemData.name..'**, amount: **' .. fromAmount .. '** from player: **'.. GetPlayerName(OtherPlayer.PlayerData.source) .. '** (citizenid: *'..OtherPlayer.PlayerData.citizenid..'* | *'..OtherPlayer.PlayerData.source..'*)')
				end
                AddItem(src, fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = OtherPlayer.PlayerData.items[toSlot]
				RemoveItem(playerId, itemInfo['name'], fromAmount, fromSlot)
                if toItemData then
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveItem(playerId, itemInfo['name'], toAmount, toSlot)
						AddItem(playerId, itemInfo['name'], toAmount, fromSlot, toItemData.info)
					end
				end
				itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddItem(playerId, itemInfo['name'], fromAmount, toSlot, fromItemData.info)
			end
		else
			lib.notify(source, {
				title = 'Inventory',
				description = 'Item doesn\'t exist!',
				type = 'error',
			})
		end
	elseif QBCore.Shared.SplitStr(fromInventory, '-')[1] == 'trunk' then
		local plate = QBCore.Shared.SplitStr(fromInventory, '-')[2]
		local fromItemData = Trunks[plate].items[fromSlot]
		fromAmount = tonumber(fromAmount) or fromItemData.amount
		if fromItemData and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == 'player' or toInventory == 'hotbar' then
				local toItemData = GetItemBySlot(src, toSlot)
				RemoveFromTrunk(plate, fromSlot, itemInfo['name'], fromAmount)
				if toItemData then
					itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveItem(src, toItemData.name, toAmount, toSlot)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo['name'], toAmount, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'trunk', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** with item; name: **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** plate: *' .. plate .. '*')
					else
						TriggerEvent('qb-log:server:CreateLog', 'trunk', 'Stacked Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) stacked item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** from plate: *' .. plate .. '*')
					end
				else
					TriggerEvent('qb-log:server:CreateLog', 'trunk', 'Received Item', 'green', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) received item; name: **'..fromItemData.name..'**, amount: **' .. fromAmount.. '** plate: *' .. plate .. '*')
				end
                AddItem(src, fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Trunks[plate].items[toSlot]
				RemoveFromTrunk(plate, fromSlot, itemInfo['name'], fromAmount)
				if toItemData then
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromTrunk(plate, toSlot, itemInfo['name'], toAmount)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo['name'], toAmount, toItemData.info)
					end
				end
				itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddToTrunk(plate, toSlot, fromSlot, itemInfo['name'], fromAmount, fromItemData.info)
			end
		else
			lib.notify(source, {
				title = 'Inventory',
				description = 'Item doesn\'t exist!',
				type = 'error',
			})
		end
	elseif QBCore.Shared.SplitStr(fromInventory, '-')[1] == 'glovebox' then
		local plate = QBCore.Shared.SplitStr(fromInventory, '-')[2]
		local fromItemData = Gloveboxes[plate].items[fromSlot]
		fromAmount = tonumber(fromAmount) or fromItemData.amount
		if fromItemData and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == 'player' or toInventory == 'hotbar' then
				local toItemData = GetItemBySlot(src, toSlot)
				RemoveFromGlovebox(plate, fromSlot, itemInfo['name'], fromAmount)
				if toItemData then
					itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveItem(src, toItemData.name, toAmount, toSlot)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo['name'], toAmount, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'glovebox', 'Swapped', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..')* swapped item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** with item; name: **'..itemInfo['name']..'**, amount: **' .. toAmount .. '** plate: *' .. plate .. '*')
					else
						TriggerEvent('qb-log:server:CreateLog', 'glovebox', 'Stacked Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) stacked item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** from plate: *' .. plate .. '*')
					end
                else
					TriggerEvent('qb-log:server:CreateLog', 'glovebox', 'Received Item', 'green', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) received item; name: **'..fromItemData.name..'**, amount: **' .. fromAmount.. '** plate: *' .. plate .. '*')
				end
                AddItem(src, fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Gloveboxes[plate].items[toSlot]
				RemoveFromGlovebox(plate, fromSlot, itemInfo['name'], fromAmount)
                if toItemData then
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromGlovebox(plate, toSlot, itemInfo['name'], toAmount)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo['name'], toAmount, toItemData.info)
					end
				end
				itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddToGlovebox(plate, toSlot, fromSlot, itemInfo['name'], fromAmount, fromItemData.info)
			end
		else
			lib.notify(source, {
				title = 'Inventory',
				description = 'Item doesn\'t exist!',
				type = 'error',
			})
		end
	elseif QBCore.Shared.SplitStr(fromInventory, '-')[1] == 'stash' then
		local stashId = QBCore.Shared.SplitStr(fromInventory, '-')[2]
		local fromItemData = Stashes[stashId].items[fromSlot]
		fromAmount = tonumber(fromAmount) or fromItemData.amount
		if fromItemData and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == 'player' or toInventory == 'hotbar' then
				local toItemData = GetItemBySlot(src, toSlot)
				RemoveFromStash(stashId, fromSlot, itemInfo['name'], fromAmount)
				if toItemData then
					itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						RemoveItem(src, toItemData.name, toAmount, toSlot)
						AddToStash(stashId, fromSlot, toSlot, itemInfo['name'], toAmount, toItemData.info)
						TriggerEvent('qb-log:server:CreateLog', 'stash', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** with item; name: **'..fromItemData.name..'**, amount: **' .. fromAmount .. '** stash: *' .. stashId .. '*')
					else
						TriggerEvent('qb-log:server:CreateLog', 'stash', 'Stacked Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) stacked item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** from stash: *' .. stashId .. '*')
					end
                else
					TriggerEvent('qb-log:server:CreateLog', 'stash', 'Received Item', 'green', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) received item; name: **'..fromItemData.name..'**, amount: **' .. fromAmount.. '** stash: *' .. stashId .. '*')
				end
				SaveStashItems(stashId, Stashes[stashId].items, true)
                AddItem(src, fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Stashes[stashId].items[toSlot]
				RemoveFromStash(stashId, fromSlot, itemInfo['name'], fromAmount)
				if toItemData then
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromStash(stashId, toSlot, itemInfo['name'], toAmount)
						AddToStash(stashId, fromSlot, toSlot, itemInfo['name'], toAmount, toItemData.info)
					end
				end
				itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
                AddToStash(stashId, toSlot, fromSlot, itemInfo['name'], fromAmount, fromItemData.info)
			end
		else
			lib.notify(source, {
				title = 'Inventory',
				description = 'Item doesn\'t exist!',
				type = 'error',
			})
		end
	elseif QBCore.Shared.SplitStr(fromInventory, '-')[1] == 'itemshop' then
		local shopType = QBCore.Shared.SplitStr(fromInventory, '-')[2]
		local itemData = ShopItems[shopType].items[fromSlot]
		local itemInfo = QBCore.Shared.Items[itemData.name:lower()]
		local bankBalance = Player.PlayerData.money['bank']
		local price = tonumber((itemData.price*fromAmount))

		if QBCore.Shared.SplitStr(shopType, '_')[1] == 'Itemshop' then
            if Player.Functions.RemoveMoney('cash', price, 'itemshop-bought-item') then
                if QBCore.Shared.SplitStr(itemData.name, '_')[1] == 'weapon' then
                    itemData.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                    itemData.info.quality = 100
                end
                local serial = itemData.info.serie
				local resourceName = GetCurrentResourceName()
				local imageurl = ('https://cfx-nui-%s/html/images/%s.png'):format(resourceName, itemData.name)
                local notes = 'Purchased at Ammunation'
                local owner = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
                local weapClass = 1
                local weapModel = QBCore.Shared.Items[itemData.name].label
                AddItem(src, itemData.name, fromAmount, toSlot, itemData.info)
                TriggerClientEvent('qb-shops:client:UpdateShop', src, QBCore.Shared.SplitStr(shopType, '_')[2], itemData, fromAmount)
				lib.notify(source, {
					title = 'Inventory',
					description = 'You have bought '..fromAmount..' '..itemInfo['label'],
					type = 'success',
				})
                exports[Shared.CreateWeaponInfo]:CreateWeaponInfo(serial, imageurl, notes, owner, weapClass, weapModel)
                TriggerEvent('qb-log:server:CreateLog', 'shops', 'Shop item bought', 'green', '**'..GetPlayerName(src) .. '** bought a ' .. itemInfo['label'] .. ' for $'..price)
        elseif bankBalance >= price then
                Player.Functions.RemoveMoney('bank', price, 'itemshop-bought-item')
                if QBCore.Shared.SplitStr(itemData.name, '_')[1] == 'weapon' then
                    itemData.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                    itemData.info.quality = 100
                end
                local serial = itemData.info.serie
				local resourceName = GetCurrentResourceName()
				local imageurl = ('https://cfx-nui-%s/html/images/%s.png'):format(resourceName, itemData.name)
                local notes = 'Purchased at Ammunation'
                local owner = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
                local weapClass = 1
                local weapModel = QBCore.Shared.Items[itemData.name].label
                AddItem(src, itemData.name, fromAmount, toSlot, itemData.info)
                TriggerClientEvent('qb-shops:client:UpdateShop', src, QBCore.Shared.SplitStr(shopType, '_')[2], itemData, fromAmount)
				lib.notify(source, {
					title = 'Inventory',
					description = 'You have bought '..fromAmount..' '..itemInfo['label'],
					type = 'success',
				})
				exports[Shared.CreateWeaponInfo]:CreateWeaponInfo(serial, imageurl, notes, owner, weapClass, weapModel)
                TriggerEvent('qb-log:server:CreateLog', 'shops', 'Shop item bought', 'green', '**'..GetPlayerName(src) .. '** bought a ' .. itemInfo['label'] .. ' for $'..price)
            else
				lib.notify(source, {
					title = 'Inventory',
					description = 'You don\'t have enough cash on you...',
					type = 'error',
				})
            end
		else
			if Player.Functions.RemoveMoney('cash', price, 'unkown-itemshop-bought-item') then
				AddItem(src, itemData.name, fromAmount, toSlot, itemData.info)
				lib.notify(source, {
					title = 'Inventory',
					description = 'You have bought '..fromAmount..' '..itemInfo['label'],
					type = 'success',
				})
				TriggerEvent('qb-log:server:CreateLog', 'shops', 'Shop item bought', 'green', '**'..GetPlayerName(src) .. '** bought a ' .. itemInfo['label'] .. ' for $'..price)
			elseif bankBalance >= price then
				Player.Functions.RemoveMoney('bank', price, 'unkown-itemshop-bought-item')
				AddItem(src, itemData.name, fromAmount, toSlot, itemData.info)
				lib.notify(source, {
					title = 'Inventory',
					description = 'You have bought '..fromAmount..' '..itemInfo['label'],
					type = 'success',
				})
				TriggerEvent('qb-log:server:CreateLog', 'shops', 'Shop item bought', 'green', '**'..GetPlayerName(src) .. '** bought a ' .. itemInfo['label'] .. ' for $'..price)
			else
				lib.notify(source, {
					title = 'Inventory',
					description = 'You don\'t have enough cash on you...',
					type = 'error',
				})
			end
		end
	else
		-- drop
		fromInventory = tonumber(fromInventory)
		local fromItemData = Drops[fromInventory].items[fromSlot]
		fromAmount = tonumber(fromAmount) or fromItemData.amount
		if fromItemData and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == 'player' or toInventory == 'hotbar' then
				local toItemData = GetItemBySlot(src, toSlot)
				RemoveFromDrop(fromInventory, fromSlot, itemInfo['name'], fromAmount)
				if toItemData then
					toAmount = tonumber(toAmount) and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveItem(src, toItemData.name, toAmount, toSlot)
						AddToDrop(fromInventory, toSlot, itemInfo['name'], toAmount, toItemData.info)
						if itemInfo['name'] == 'radio' then
							TriggerClientEvent('Radio.Set', src, false)
						end
						TriggerEvent('qb-log:server:CreateLog', 'drop', 'Swapped Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) swapped item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** with item; name: **'..fromItemData.name..'**, amount: **' .. fromAmount .. '** - dropid: *' .. fromInventory .. '*')
					else
						TriggerEvent('qb-log:server:CreateLog', 'drop', 'Stacked Item', 'orange', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) stacked item; name: **'..toItemData.name..'**, amount: **' .. toAmount .. '** - from dropid: *' .. fromInventory .. '*')
					end
				else
					TriggerEvent('qb-log:server:CreateLog', 'drop', 'Received Item', 'green', '**'.. GetPlayerName(src) .. '** (citizenid: *'..Player.PlayerData.citizenid..'* | id: *'..src..'*) received item; name: **'..fromItemData.name..'**, amount: **' .. fromAmount.. '** -  dropid: *' .. fromInventory .. '*')
				end
				AddItem(src, fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				toInventory = tonumber(toInventory)
				local toItemData = Drops[toInventory].items[toSlot]
				RemoveFromDrop(fromInventory, fromSlot, itemInfo['name'], fromAmount)
				if toItemData then
					toAmount = tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromDrop(toInventory, toSlot, itemInfo['name'], toAmount)
						AddToDrop(fromInventory, fromSlot, itemInfo['name'], toAmount, toItemData.info)
						if itemInfo['name'] == 'radio' then
							TriggerClientEvent('Radio.Set', src, false)
						end
					end
				end
				itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToDrop(toInventory, toSlot, itemInfo['name'], fromAmount, fromItemData.info)
				if itemInfo['name'] == 'radio' then
					TriggerClientEvent('Radio.Set', src, false)
				end
			end
		else
			lib.notify(source, {
				title = 'Inventory',
				description = 'Drop inventory dosen\'t exist!',
				type = 'error',
			})
		end
	end
end)

RegisterNetEvent('inventory:server:SaveStashItems', function(stashId, items)
    MySQL.Async.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
        ['stash'] = stashId,
        ['items'] = json.encode(items)
    })
end)

RegisterNetEvent('inventory:server:updateDecayStash', function(inventoryType, uniqueId, data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if inventoryType == 'trunk' then
		Trunks[uniqueId].items = data.inventory
		TriggerClientEvent('inventory:client:UpdateOtherInventory', Player.PlayerData.source, data, false)
	elseif inventoryType == 'glovebox' then
		Gloveboxes[uniqueId].items = data.inventory
		TriggerClientEvent('inventory:client:UpdateOtherInventory', Player.PlayerData.source, data, false)
	elseif inventoryType == 'stash' then
		Stashes[uniqueId].items = data.inventory
		TriggerClientEvent('inventory:client:UpdateOtherInventory', Player.PlayerData.source, data, false)
	end
end)

RegisterNetEvent('inventory:server:updateDecayInventory', function(inventory)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.SetInventory(inventory)
    TriggerClientEvent('inventory:client:UpdatePlayerInventory', Player.PlayerData.source, false)
end)

RegisterServerEvent('inventory:server:GiveItem', function(target, name, amount, slot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	target = tonumber(target)
    local OtherPlayer = QBCore.Functions.GetPlayer(target)
    local dist = #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target)))
	if Player == OtherPlayer then return
		lib.notify(src, {
			title = 'Inventory',
			description = 'You can\'t give items to yourself!',
			type = 'error',
		})
	end
	if dist > 2.5 then return
		lib.notify(src, {
			title = 'Inventory',
			description = 'You are too far away to give items!',
			type = 'error',
		})
	end

	local item = GetItemBySlot(src, slot)
	if not item then return
		lib.notify(src, {
			title = 'Inventory',
			description = 'You can\'t give items that dosen\'t exist!',
			type = 'error',
		})
	end

	if item.name ~= name then return
		lib.notify(src, {
			title = 'Inventory',
			description = 'Incorrect item found, Try again!',
			type = 'error',
		})
	end

	if amount <= item.amount then
		if amount == 0 then
			amount = item.amount
		end
		if RemoveItem(src, item.name, amount, item.slot) then
			if AddItem(target, item.name, amount, false, item.info) then
				TriggerClientEvent('inventory:client:ItemBox',target, QBCore.Shared.Items[item.name], 'add')
				lib.notify(target, {
					title = 'Inventory',
					description = 'You Received '..amount..' '..item.label..' From ID '..src,
					type = 'success',
				})
				TriggerClientEvent('inventory:client:UpdatePlayerInventory', target, true)
				TriggerClientEvent('inventory:client:ItemBox',src, QBCore.Shared.Items[item.name], 'remove')
				lib.notify(src, {
					title = 'Inventory',
					description = 'You gave '..amount..' '..item.label..' To ID '..target,
					type = 'success',
				})
				TriggerClientEvent('inventory:client:UpdatePlayerInventory', src, true)
				TriggerClientEvent('inventory:client:giveAnim', src)
				TriggerClientEvent('inventory:client:giveAnim', target)
			else
				AddItem(src, item.name, amount, item.slot, item.info)
				lib.notify(src, {
					title = 'Inventory',
					description = 'The other player\'s inventory is full!',
					type = 'error',
				})
				lib.notify(target, {
					title = 'Inventory',
					description = 'The other player\'s inventory is full!',
					type = 'error',
				})
				TriggerClientEvent('inventory:client:UpdatePlayerInventory', src, false)
				TriggerClientEvent('inventory:client:UpdatePlayerInventory', target, false)
			end
		else
			lib.notify(source, {
				title = 'Inventory',
				description = 'You do not have enough of the item',
				type = 'error',
			})
		end
	else
		lib.notify(source, {
			title = 'Inventory',
			description = 'You do not have enough items to transfer',
			type = 'error',
		})
	end
end)

-- Callbacks

QBCore.Functions.CreateCallback('inventory:server:GetStashItems', function(_, cb, stashId)
	cb(GetStashItems(stashId))
end)

QBCore.Functions.CreateCallback('inventory:server:GetCurrentDrops', function(_, cb)
	cb(Drops)
end)

-- Thread

CreateThread(function()
	while true do
		for k, v in pairs(Drops) do
			if v and (v.createdTime + Shared.CleanupDropTime < os.time()) and not Drops[k].isOpen then
				Drops[k] = nil
				TriggerClientEvent('inventory:client:RemoveDropItem', -1, k)
			end
		end
		Wait(60 * 1000)
	end
end)