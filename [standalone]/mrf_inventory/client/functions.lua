-- Variables

QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData()
inInventory = false
currentWeapon = nil
currentOtherInventory = nil
Drops = {}
CurrentDrop = nil
DropsNear = {}
CurrentVehicle = nil
CurrentGlovebox = nil
CurrentStash = nil
isHotbar = false
isModifiedSpeed = nil
LastModifiedSpeed = nil
isPlayerLand = false
showBlur = Shared.Blur

-- Functions
function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function openAnim()
    LoadAnimDict('pickup_object')
    TaskPlayAnim(cache.ped, 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
end

function OpenTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    LoadAnimDict('amb@prop_human_bum_bin@idle_b')
    TaskPlayAnim(cache.ped, 'amb@prop_human_bum_bin@idle_b', 'idle_d', 4.0, 4.0, -1, 50, 0, false, false, false)
    if IsBackEngine(GetEntityModel(vehicle)) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    LoadAnimDict('amb@prop_human_bum_bin@idle_b')
    TaskPlayAnim(cache.ped, 'amb@prop_human_bum_bin@idle_b', 'exit', 4.0, 4.0, -1, 50, 0, false, false, false)
    if IsBackEngine(GetEntityModel(vehicle)) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function closeInventory()
    SendNUIMessage({
        action = 'close'
    })
end

function IsBackEngine(vehModel)
    return BackEngineVehicles[vehModel]
end

function GetTrunkSize(vehicleClass)
    local trunkSize = VehicleInventories.classes[vehicleClass] or VehicleInventories.default
    return trunkSize.maxWeight, trunkSize.slots
end exports('GetTrunkSize', GetTrunkSize)

function FormatWeaponAttachments(itemdata)
    if not itemdata.info or not itemdata.info.attachments or #itemdata.info.attachments == 0 then
        return {}
    end
    local attachments = {}
    local weaponName = itemdata.name
    local WeaponAttachments = getConfigWeaponAttachments()
    if not WeaponAttachments then return {} end
    for attachmentType, weapons in pairs(WeaponAttachments) do
        local componentHash = weapons[weaponName]
        if componentHash then
            for _, attachmentData in pairs(itemdata.info.attachments) do
                if attachmentData.component == componentHash then
                    local label = QBCore.Shared.Items[attachmentType] and QBCore.Shared.Items[attachmentType].label or 'Unknown'
                    attachments[#attachments + 1] = {
                        attachment = attachmentType,
                        label = label
                    }
                end
            end
        end
    end
    return attachments
end

function HasItem(items, amount)
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
    for _, itemData in pairs(PlayerData.items) do
        if isTable then
            for k, v in pairs(items) do
                local itemKV = {k, v}
                if itemData and itemData.name == itemKV[kvIndex] and ((amount and itemData.amount >= amount) or (not isArray and itemData.amount >= v) or (not amount and isArray)) then
                    count += 1
                end
            end
            if count == totalItems then
                return true
            end
        else
            if itemData and itemData.name == items and (not amount or (itemData and amount and itemData.amount >= amount)) then
                return true
            end
        end
    end
    return false
end exports('HasItem', HasItem)

function DecayInventory(primaryInventory, secondaryInventory, currentTimestamp)
    local function applyDecay(item, timestamp, isSlowDecay)
        local lowerName = item.name:lower()
        local itemDetails = QBCore.Shared.Items[lowerName]
        if itemDetails['decay'] and itemDetails['decay'] ~= 0 and itemDetails['type'] ~= 'weapon' then
            item.info.created = item.info.created or timestamp
            local elapsedHours = (timestamp - item.info.created) / 3600
            local decayFactor = elapsedHours / itemDetails['decay']
            -- print(string.format("Item: %s, Original decay factor: %.2f", lowerName, decayFactor))
            if isSlowDecay then
                decayFactor = decayFactor * 0.2
                -- print(string.format("Item: %s, Slow decay factor applied: %.2f", lowerName, decayFactor))
            end
            item.info.quality = item.info.quality or 100
            local newQuality = item.info.quality > 0 and (item.info.quality - (decayFactor * 100)) or 0
            item.info.quality = math.max(math.floor(newQuality * 100 + 0.5) / 100, 0)
            item.info.created = timestamp
            -- print(string.format("Item: %s, New quality: %.2f", lowerName, item.info.quality))
        end
    end

    for _, primaryItem in pairs(primaryInventory) do
        applyDecay(primaryItem, currentTimestamp, false)
    end

    TriggerServerEvent('inventory:server:updateDecayInventory', primaryInventory)

    if secondaryInventory then
        local inventoryType, uniqueId = table.unpack(QBCore.Shared.SplitStr(secondaryInventory.name, '-'))
        for _, secondaryItem in pairs(secondaryInventory.inventory) do
            local isSlowDecay = uniqueId and type(uniqueId) == 'string' and string.find(uniqueId, ':slowdecay')
            applyDecay(secondaryItem, currentTimestamp, isSlowDecay)
        end
        TriggerServerEvent('inventory:server:updateDecayStash', inventoryType, uniqueId, secondaryInventory)
    end

    return primaryInventory, secondaryInventory
end

function InventoryOpen()
    local ped = cache.ped
    local curVeh = nil

    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        CurrentGlovebox = QBCore.Functions.GetPlate(vehicle)
        curVeh = vehicle
        CurrentVehicle = nil
    else
        local vehicle = QBCore.Functions.GetClosestVehicle()
        if vehicle ~= 0 and vehicle ~= nil then
            local pos = GetEntityCoords(ped)
            local dimensionMin, dimensionMax = GetModelDimensions(GetEntityModel(vehicle))
            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMin.y), 0.0)
            if (IsBackEngine(GetEntityModel(vehicle))) then
                trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMax.y), 0.0)
            end
            if #(pos - trunkpos) < 1.5 and not IsPedInAnyVehicle(ped) then
                if GetVehicleDoorLockStatus(vehicle) < 2 then
                    CurrentVehicle = QBCore.Functions.GetPlate(vehicle)
                    curVeh = vehicle
                    CurrentGlovebox = nil
                else
                    lib.notify({
                        title = 'Inventory',
                        description = 'The vehicle is locked!',
                        type = 'error'
                    })
                    return
                end
            else
                CurrentVehicle = nil
            end
        else
            CurrentVehicle = nil
        end
    end

    if CurrentVehicle then
        local vehicleModel = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(curVeh)))
        local vehicleClass = GetVehicleClass(curVeh)
        local maxweight
        local slots

        if VehicleInventories.vehicles[vehicleModel] then
            maxweight = VehicleInventories.vehicles[vehicleModel].maxWeight
            slots = VehicleInventories.vehicles[vehicleModel].slots
        elseif VehicleInventories.classes[vehicleClass] then
            maxweight = VehicleInventories.classes[vehicleClass].maxWeight
            slots = VehicleInventories.classes[vehicleClass].slots
        else
            maxweight = VehicleInventories.default.maxWeight
            slots = VehicleInventories.default.slots
        end

        local other = {
            maxweight = maxweight,
            slots = slots
        }

        TriggerServerEvent('inventory:server:OpenInventory', 'trunk', CurrentVehicle, other)
        OpenTrunk()
    elseif CurrentGlovebox then
        TriggerServerEvent('inventory:server:OpenInventory', 'glovebox', CurrentGlovebox)
    elseif CurrentDrop ~= 0 then
        TriggerServerEvent('inventory:server:OpenInventory', 'drop', CurrentDrop)
    else
        openAnim()
        TriggerServerEvent('inventory:server:OpenInventory')
    end
end

function GetHotbarItems(items)
    local PlayerItems = items or QBCore.Functions.GetPlayerData().items
    return {
        [1] =  PlayerItems[1],
        [2] =  PlayerItems[2],
        [3] =  PlayerItems[3],
        [4] =  PlayerItems[4],
        [5] =  PlayerItems[5],
        [41] = PlayerItems[41],
    }
end

function ToggleHotbar(toggle)
    if toggle then
        isHotbar = true
        SendNUIMessage({
            action = 'toggleHotbar',
            open = true,
            items = GetHotbarItems()
        })
    else
        isHotbar = false
        SendNUIMessage({
            action = 'toggleHotbar',
            open = false,
        })
    end
end

function GetClosestWeightIndex(weight)
    local Weightindex = nil
    for i = 1, #Shared.WeightEffects, 1 do
        if weight >= Shared.WeightEffects[i].weight then
            Weightindex = i
        else
            break
        end
    end
    return Weightindex
end

function GetSpeedFromWeightIndex(index)
    if index == nil then return 1.0 end
    local speed = 1.0
    if Shared.WeightEffects[index].slow > 9 then speed -= tonumber('0.'..Shared.WeightEffects[index].slow) else speed -= tonumber('0.0'..Shared.WeightEffects[index].slow) end
    if speed <= 0.0 then speed = 0.01 end

    return speed
end

function GetPlayerSpeedPercentLoseFromWeight()
    local weight = 0
    if PlayerData == nil then return 1.0 end
    local items = PlayerData.items
    if items == nil then return 1.0 end
    for _, v in pairs(items) do
        if v.weight then
            weight += v.weight * v.amount
        end
    end
    local weight_index = GetClosestWeightIndex(weight)
    local speed = GetSpeedFromWeightIndex(weight_index)
    return speed
end

function MakePlayerMoveSlower(PlayerPed, speed)
    if LastModifiedSpeed == speed then return end
    LastModifiedSpeed = speed
    CreateThread(function()
        while isModifiedSpeed == speed do
            if Shared.SprintOnly == true and (IsPedSprinting(PlayerPed) or IsPedRunning(PlayerPed)) or Shared.SprintOnly == false then
                SetPedMoveRateOverride(PlayerPed, isModifiedSpeed);
                DisableControlAction(0, 22, true)
            end
            Wait(2)
        end
    end)
end

function RemoveNearbyDrop(index)
    if not DropsNear[index] then return end

    local dropItem = DropsNear[index].object
    if DoesEntityExist(dropItem) then
        DeleteEntity(dropItem)
    end

    DropsNear[index] = nil

    if not Drops[index] then return end

    Drops[index].object = nil
    Drops[index].isDropShowing = nil
end

function RemoveAllNearbyDrops()
    for k in pairs(DropsNear) do
        RemoveNearbyDrop(k)
    end
end

function CreateItemDrop(index)
    local dropItem = CreateObject(Shared.ItemDropObject, DropsNear[index].coords.x, DropsNear[index].coords.y, DropsNear[index].coords.z, false, false, false)
    DropsNear[index].object = dropItem
    DropsNear[index].isDropShowing = true
    PlaceObjectOnGroundProperly(dropItem)
    FreezeEntityPosition(dropItem, true)
	if Shared.UseInteract == 'target' then
		exports['qb-target']:AddTargetEntity(dropItem, {
			options = {
				{
					label = 'Open Box',
                    icon = 'fa-solid fa-bag-shopping',
					action = function()
						TriggerServerEvent('inventory:server:OpenInventory', 'drop', index)
					end
				}
			},
			distance = 1.5
		})
    elseif Shared.UseInteract == 'interact' then
        exports.interact:AddLocalEntityInteraction({
            entity = dropItem,
            name = 'drop',
            id = 'droppedItems',
            distance = 5.0,
            interactDst = 1.5,
            ignoreLos = true,
            options = {
                {
                    label = 'Open Box',
                    action = function()
                        TriggerServerEvent('inventory:server:OpenInventory', 'drop', index)
                    end
                }
            }
        })
    else
        return
    end
end

function Throwable(weaponName)
    return ThrowableWeapons[weaponName] or false
end