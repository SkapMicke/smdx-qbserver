-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local CurrentWeaponData, CanShoot, MultiplierAmount = {}, true, 0

-- Functions

local function Notify(message, type)
    lib.notify({
        title = 'Weapons',
        description = message,
        type = type
    })
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback('weapons:server:GetConfig', function(RepairPoints)
        for k, data in pairs(RepairPoints) do
            RepairPoints[k].IsRepairing = data.IsRepairing
            RepairPoints[k].RepairingData = data.RepairingData
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    for k in pairs(RepairPoints) do
        RepairPoints[k].IsRepairing = false
        RepairPoints[k].RepairingData = {}
    end
end)

RegisterNetEvent('weapons:client:SyncRepairShops', function(NewData, key)
    RepairPoints[key].IsRepairing = NewData.IsRepairing
    RepairPoints[key].RepairingData = NewData.RepairingData
end)

RegisterNetEvent('weapon:startRepair', function(data)
    if CurrentWeaponData and next(CurrentWeaponData) then
        QBCore.Functions.TriggerCallback('weapons:server:RepairWeapon', function(success)
            if success then
                Notify('Weapon Repair Started!', 'success')
                CurrentWeaponData = {}
            end
        end, data.id, CurrentWeaponData)
    else
        if RepairPoints[data.id].RepairingData.CitizenId == nil then
            Notify('You dont have a weapon in your hand.', 'error')
        end
    end
end)

RegisterNetEvent('weapon:completeRepair', function(data)
    if CurrentWeaponData and next(CurrentWeaponData) then
        if RepairPoints[data.id].RepairingData.CitizenId ~= PlayerData.citizenid then
            Notify('Someone else\'s weapon is here', 'info')
        else
            Notify('Took back weapon', 'success')
            TriggerServerEvent('weapons:server:TakeBackWeapon', data.id, data)
        end
    else
        if RepairPoints[data.id].RepairingData.CitizenId == PlayerData.citizenid then
            Notify('Took back weapon', 'success')
            TriggerServerEvent('weapons:server:TakeBackWeapon', data.id, data)
        end
        if RepairPoints[data.id].RepairingData.CitizenId == nil then
            Notify('Finders keepers...', 'success')
            TriggerServerEvent('weapons:server:TakeBackWeapon', data.id, data)
        end
    end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)

RegisterNetEvent('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData and next(CurrentWeaponData) then
        TriggerServerEvent('weapons:server:SetWeaponQuality', CurrentWeaponData, amount)
    end
end)

RegisterNetEvent('weapons:client:AddAmmo', function(type, amount, itemData)
    local ped = cache.ped
    local weapon = GetSelectedPedWeapon(ped)
    if CurrentWeaponData then
        if QBCore.Shared.Weapons[weapon]['name'] ~= 'weapon_unarmed' then
            if QBCore.Shared.Weapons[weapon]['ammotype'] == type:upper() then
                local total = GetAmmoInPedWeapon(ped, weapon)
                local _, maxAmmo = GetMaxAmmo(ped, weapon)
                if total < maxAmmo then
                    QBCore.Functions.Progressbar('loading_bullets', 'Loading Bullets', Shared.ReloadTime, false,
                        true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function()
                        local newweapon = GetSelectedPedWeapon(ped)
                        if QBCore.Shared.Weapons[weapon] and QBCore.Shared.Weapons[newweapon]['ammotype'] == type:upper() then
                            AddAmmoToPed(ped, weapon, amount)
                            TaskReloadWeapon(ped, false)
                            TriggerServerEvent('weapons:server:UpdateWeaponAmmo', CurrentWeaponData, total + amount)
                            TriggerServerEvent('weapons:server:removeWeaponAmmoItem', itemData)
                            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemData.name], 'remove')
                            Notify('Reloaded...', 'success')
                        end
                    end, function()
                        Notify('Canceled...', 'error')
                    end)
                else
                    Notify('Max Ammo Capacity', 'error')
                end
            else
                Notify('Your ammo type is wrong.', 'error')
            end
        else
            Notify('You need to have a weapon on hand.', 'error')
        end
    else
        Notify('You need to have a weapon on hand.', 'error')
    end
end)

-- Cache

lib.onCache('weapon', function(value)
    if value then
        local weapon = GetSelectedPedWeapon(cache.ped)
        local isthrowable = false
        local wepName = QBCore.Shared.Weapons[weapon] and QBCore.Shared.Weapons[weapon].name
        if wepName then
            for _, v in pairs(BypassBullet) do
                if 'weapon_' .. v == wepName then
                    isthrowable = true
                    return
                end
            end
        else
        end
        while IsPedArmed(cache.ped, 6) do
            local ped = cache.ped
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            if ammo <= 1 and not isthrowable then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true)
                DisablePlayerFiring(ped, true)
            end
            if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                TriggerServerEvent('weapons:server:UpdateWeaponAmmo', CurrentWeaponData, tonumber(ammo))
                if MultiplierAmount > 0 then
                    TriggerServerEvent('weapons:server:UpdateWeaponQuality', CurrentWeaponData, MultiplierAmount)
                    MultiplierAmount = 0
                end
            end
            Wait(0)
        end
    end
end)

lib.onCache('weapon', function(value)
    if value then
        while IsPedArmed(cache.ped, 6) do
            local ped = cache.ped
            if CurrentWeaponData and next(CurrentWeaponData) then
                if IsPedShooting(ped) or IsControlJustPressed(0, 24) then
                    local weapon = GetSelectedPedWeapon(ped)
                    if CanShoot then
                        if weapon and weapon ~= 0 and QBCore.Shared.Weapons[weapon] then
                            QBCore.Functions.TriggerCallback('prison:server:checkThrowable', function(result)
                                if result or GetAmmoInPedWeapon(ped, weapon) <= 0 then return end
                                MultiplierAmount += 1
                            end, weapon)
                            Wait(200)
                        end
                    else
                        if weapon ~= `WEAPON_UNARMED` then
                            TriggerEvent('inventory:client:CheckWeapon', QBCore.Shared.Weapons[weapon]['name'])
                            Notify('This weapon is broken and can not be used.', 'error')
                            MultiplierAmount = 0
                        end
                    end
                end
            end
            Wait(0)
        end
    end
end)

-- Threads

CreateThread(function()
    for k, v in pairs(RepairPoints) do
        local opt = {}
        if v.type == 'public' then
            opt = {
                {
                    type = 'client',
                    event = 'weapon:startRepair',
                    label = 'Start Weapon Repair',
                    icon = 'fas fa-gun',
                    id = k,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing or RepairPoints[k].RepairingData.Ready then
                            return false
                        else
                            return true
                        end
                    end
                },
                {
                    type = 'server',
                    event = 'weapon:repairTime',
                    label = 'Check Repair Time',
                    icon = 'fas fa-gun',
                    id = k,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing then
                            return true
                        else
                            return false
                        end
                    end
                },
                {
                    type = 'client',
                    event = 'weapon:completeRepair',
                    label = 'Collect Weapon',
                    icon = 'fas fa-gun',
                    id = k,
                    canInteract = function()
                        if RepairPoints[k].RepairingData.Ready then
                            return true
                        else
                            return false
                        end
                    end
                }
            }
        elseif v.type == 'private' then
            local temp = v.citizenids
            opt = {
                {
                    type = 'client',
                    event = 'weapon:startRepair',
                    label = 'Start Weapon Repair',
                    icon = 'fas fa-gun',
                    id = k,
                    citizenid = temp,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing or RepairPoints[k].RepairingData.Ready then
                            return false
                        else
                            return true
                        end
                    end
                },
                {
                    type = 'server',
                    event = 'weapon:repairTime',
                    label = 'Check Repair Time',
                    icon = 'fas fa-gun',
                    id = k,
                    citizenid = temp,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing then
                            return true
                        else
                            return false
                        end
                    end
                },
                {
                    type = 'client',
                    event = 'weapon:completeRepair',
                    label = 'Collect Weapon',
                    icon = 'fas fa-gun',
                    id = k,
                    citizenid = temp,
                    canInteract = function()
                        if RepairPoints[k].RepairingData.Ready then
                            return true
                        else
                            return false
                        end
                    end
                }
            }
        elseif v.type == 'job' then
            local temp = v.jobs
            opt = {
                {
                    type = 'client',
                    event = 'weapon:startRepair',
                    label = 'Start Weapon Repair',
                    icon = 'fas fa-gun',
                    id = k,
                    job = temp,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing or RepairPoints[k].RepairingData.Ready then
                            return false
                        else
                            return true
                        end
                    end
                },
                {
                    type = 'server',
                    event = 'weapon:repairTime',
                    label = 'Check Repair Time',
                    icon = 'fas fa-gun',
                    id = k,
                    job = temp,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing then
                            return true
                        else
                            return false
                        end
                    end
                },
                {
                    type = 'client',
                    event = 'weapon:completeRepair',
                    label = 'Collect Weapon',
                    icon = 'fas fa-gun',
                    id = k,
                    job = temp,
                    canInteract = function()
                        if RepairPoints[k].RepairingData.Ready then
                            return true
                        else
                            return false
                        end
                    end
                }
            }
        elseif v.type == 'gang' then
            local temp = v.gangs
            opt = {
                {
                    type = 'client',
                    event = 'weapon:startRepair',
                    label = 'Start Weapon Repair',
                    icon = 'fas fa-gun',
                    id = k,
                    gang = temp,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing or RepairPoints[k].RepairingData.Ready then
                            return false
                        else
                            return true
                        end
                    end
                },
                {
                    type = 'server',
                    event = 'weapon:repairTime',
                    label = 'Check Repair Time',
                    icon = 'fas fa-gun',
                    id = k,
                    gang = temp,
                    canInteract = function()
                        if RepairPoints[k].IsRepairing then
                            return true
                        else
                            return false
                        end
                    end
                },
                {
                    type = 'client',
                    event = 'weapon:completeRepair',
                    label = 'Collect Weapon',
                    icon = 'fas fa-gun',
                    id = k,
                    gang = temp,
                    canInteract = function()
                        if RepairPoints[k].RepairingData.Ready then
                            return true
                        else
                            return false
                        end
                    end
                }
            }
        end
        exports['qb-target']:AddBoxZone('weapon_repair' .. k, vector3(v.coords.x, v.coords.y, v.coords.z), 1.25, 1.5, {
            name = 'weapon_repair' .. k,
            heading = v.coords.w,
            debugPoly = v.debug,
            minZ = v.coords.z - 2,
            maxZ = v.coords.z + 2,
        }, {
            options = opt,
            distance = 2.5,
        })
    end
end)

CreateThread(function()
    SetWeaponsNoAutoswap(true)
end)

if Shared.DisableHeadShot then
    CreateThread(function()
        while true do
            SetPedSuffersCriticalHits(cache.ped, false)
            Wait(0)
        end
    end)
end