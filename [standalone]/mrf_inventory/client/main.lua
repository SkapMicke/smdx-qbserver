-- Events

RegisterNetEvent('QBCore:Player:SetPlayerData', function(PlayerData)
    if isHotbar then
        SendNUIMessage({
            action = 'toggleHotbar',
            open = true,
            items = GetHotbarItems(PlayerData.items)
        })
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set('inv_busy', false, true)
    PlayerData = QBCore.Functions.GetPlayerData()
    isPlayerLand = true
    QBCore.Functions.TriggerCallback('inventory:server:GetCurrentDrops', function(theDrops)
		Drops = theDrops
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('inv_busy', true, true)
    PlayerData = {}
    RemoveAllNearbyDrops()
    isPlayerLand = false
end)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
    QBCore = exports['qb-core']:GetCoreObject()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('inventory:client:closeinv', function()
    closeInventory()
end)

RegisterNetEvent('inventory:client:CheckOpenState', function(type, id, label)
    local name = QBCore.Shared.SplitStr(label, '-')[2]
    if type == 'stash' then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == 'trunk' then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == 'glovebox' then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == 'drop' then
        if name ~= CurrentDrop or CurrentDrop == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('inventory:client:ItemBox', function(itemData, type, amount)
    amount = amount or 1
    SendNUIMessage({
        action = 'itemBox',
        item = itemData,
        type = type,
        itemAmount = amount
    })
end)

RegisterNetEvent('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k in pairs(items) do
            itemTable[#itemTable+1] = {
                item = items[k].name,
                label = QBCore.Shared.Items[items[k].name]['label'],
                image = items[k].image,
            }
        end
    end

    SendNUIMessage({
        action = 'requiredItem',
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = 'RobMoney',
        TargetId = TargetId,
    })
end)

RegisterNetEvent('inventory:client:OpenInventory', function(PlayerAmmo, inventory, other, time)
    if IsEntityDead(cache.ped) then
        lib.notify({
            title = 'Inventory',
            description = 'You can\'t access while dead!',
            type = 'error'
        })
        return
    end

    local isInventory, isOther = DecayInventory(inventory, other, time)

    local function OpenInventory()
        ToggleHotbar(false)
        if showBlur then
            TriggerScreenblurFadeIn(1000)
        end
        SetNuiFocus(true, true)
        if other then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = 'open',
            inventory = isInventory,
            other = isOther,
            slots = Shared.MaxInventorySlots,
            maxweight = Shared.MaxInventoryWeight,
            Ammo = PlayerAmmo,
            Name = PlayerData.charinfo.firstname ..' '.. PlayerData.charinfo.lastname
        })
        inInventory = true
    end

    if Shared.Progressbar.Enable then
        QBCore.Functions.Progressbar('open_inventory', 'Opening Inventory...', Shared.Progressbar.Time, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }, {}, {}, {}, OpenInventory)
    else
        Wait(500)
        OpenInventory()
    end
end)

RegisterNetEvent('inventory:client:UpdateOtherInventory', function(items, isError)
    SendNUIMessage({
        action = 'update',
        inventory = items,
        maxweight = Shared.MaxInventoryWeight,
        slots = Shared.MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent('inventory:client:UpdatePlayerInventory', function(isError)
    SendNUIMessage({
        action = 'update',
        inventory = PlayerData.items,
        maxweight = Shared.MaxInventoryWeight,
        slots = Shared.MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent('inventory:client:UseWeapon', function(weaponData, shootbool)
    local ped = cache.ped
    local weaponName = tostring(weaponData.name)
    local weaponHash = joaat(weaponData.name)
    local weaponinhand = cache.weapon
    if currentWeapon == weaponName and weaponinhand then
        TriggerEvent('weapons:client:DrawWeapon', nil)
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(ped, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif Throwable(weaponName) then
        TriggerEvent('weapons:client:DrawWeapon', weaponName)
        GiveWeaponToPed(ped, weaponHash, 1, false, false)
        SetPedAmmo(ped, weaponHash, 1)
        SetCurrentPedWeapon(ped, weaponHash, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:DrawWeapon', weaponName)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        local ammo = tonumber(weaponData.info.ammo) or 0

        if weaponName == 'weapon_fireextinguisher' then
            ammo = 4000
        end

        GiveWeaponToPed(ped, weaponHash, ammo, false, false)
		SetCurrentPedWeapon(ped, weaponHash, true)
        local newweapon = GetSelectedPedWeapon(ped)
        if newweapon ~= joaat(weaponName) then
            return
        end
        SetPedAmmo(ped, weaponHash, ammo)

        if weaponData.info.attachments then
            for _, attachment in pairs(weaponData.info.attachments) do
                GiveWeaponComponentToPed(ped, weaponHash, joaat(attachment.component))
            end
        end

        currentWeapon = weaponName
    end
end)

RegisterNetEvent('inventory:client:CheckWeapon', function()
    local ped = cache.ped
    TriggerEvent('weapons:ResetHolster')
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    RemoveAllPedWeapons(ped, true)
    currentWeapon = nil
end)

RegisterNetEvent('inventory:client:AddDropItem', function(dropId, player, coords)
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
    local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('inventory:client:RemoveDropItem', function(dropId)
    Drops[dropId] = nil
    if Shared.UseItemDrop then
        RemoveNearbyDrop(dropId)
    else
        DropsNear[dropId] = nil
    end
end)

RegisterNetEvent('inventory:client:DropItemAnim', function()
    local ped = cache.ped
    SendNUIMessage({
        action = 'close',
    })
    LoadAnimDict('pickup_object')
    TaskPlayAnim(ped, 'pickup_object' ,'pickup_low' ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
end)

RegisterNetEvent('inventory:client:SetCurrentStash', function(stash)
    CurrentStash = stash
end)

RegisterNetEvent('inventory:client:giveAnim', function()
    if IsPedInAnyVehicle(cache.ped, false) then
        return
    else
        LoadAnimDict('mp_common')
        TaskPlayAnim(cache.ped, 'mp_common', 'givetake1_b', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    end
end)

AddEventHandler('onResourceStop', function(name)
    if name ~= GetCurrentResourceName() then return end
    if Shared.UseItemDrop then RemoveAllNearbyDrops() end
end)

-- Commands

RegisterCommand('closeinv', function()
    closeInventory()
end, false)

-- Threads

CreateThread(function()
    while true do
        isModifiedSpeed = GetPlayerSpeedPercentLoseFromWeight()
        if isModifiedSpeed ~= 1.0 then
            MakePlayerMoveSlower(cache.ped, isModifiedSpeed)
        else
            LastModifiedSpeed = 1.0
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        if hotbar then
            local HotbarItems = {
                [1] = QBCore.Functions.GetPlayerData().items[1],
                [2] = QBCore.Functions.GetPlayerData().items[2],
                [3] = QBCore.Functions.GetPlayerData().items[3],
                [4] = QBCore.Functions.GetPlayerData().items[4],
                [5] = QBCore.Functions.GetPlayerData().items[5],
            }
            SendNUIMessage({
                action = 'toggleHotbar',
                open = true,
                items = HotbarItems
            })
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 100
        if DropsNear ~= nil then
			local ped = cache.ped
			local closestDrop = nil
			local closestDistance = nil
            for k, v in pairs(DropsNear) do

                if DropsNear[k] ~= nil then
                    if Shared.UseItemDrop then
                        if not v.isDropShowing then
                            CreateItemDrop(k)
                        end
                    else
                        sleep = 0
                        DrawMarker(20, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                    end

					local coords = (v.object ~= nil and GetEntityCoords(v.object)) or vector3(v.coords.x, v.coords.y, v.coords.z)
					local distance = #(GetEntityCoords(ped) - coords)
					if distance < 3 and (not closestDistance or distance < closestDistance) then
						closestDrop = k
						closestDistance = distance
                        ClearDrawOrigin()
					end
                end
            end

			if not closestDrop then
				CurrentDrop = 0
			else
				CurrentDrop = closestDrop
			end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(cache.ped, true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < Shared.MaxDropViewDistance then
                        DropsNear[k] = v
                    else
                        if Shared.UseItemDrop and DropsNear[k] then
                            RemoveNearbyDrop(k)
                        else
                            DropsNear[k] = nil
                        end
                    end
                end
            end
        else
            DropsNear = {}
        end
        Wait(500)
    end
end)

CreateThread(function()
    while true do
        if isPlayerLand then
            if PlayerData.metadata.ishandcuffed or PlayerData.metadata.isdead or PlayerData.metadata.inlaststand then
                closeInventory()
                ToggleHotbar(false)
            end
        end
        Wait(100)
    end
end)