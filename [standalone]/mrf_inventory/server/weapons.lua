-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local globalTime = 0
local isCountingDown = false

-- Functions

local function Notify(src, message, type)
    lib.notify(src, {
        title = 'Weapons',
        description = message,
        type = type
    })
end

local function StartCountdown(time)
    globalTime = time
    isCountingDown = true
    CreateThread(function()
        while globalTime > 0 do
            Wait(1000)
            globalTime = globalTime - 1000
        end
        isCountingDown = false
        globalTime = 0
    end)
end

local function FormatTime(milliseconds)
    local totalSeconds = milliseconds / 1000
    local minutes = math.floor(totalSeconds / 60)
    local seconds = math.floor(totalSeconds % 60)
    local formattedTime = ''
    if minutes > 0 then
        formattedTime = minutes .. ' minutes '
    end
    formattedTime = formattedTime .. seconds .. ' seconds'
    return formattedTime
end

local function IsWeaponBlocked(WeaponName)
    local retval = false
    for _, name in pairs(DurabilityBlockedWeapons) do
        if name == WeaponName then
            retval = true
            break
        end
    end
    return retval
end

local function GetWeaponSlotByName(items, weaponName)
    for index, item in pairs(items) do
        if item.name == weaponName then
            return item, index
        end
    end
    return nil, nil
end

local function HasAttachment(component, attachments)
    for k, v in pairs(attachments) do
        if v.component == component then
            return true, k
        end
    end
    return false, nil
end

local function DoesWeaponTakeWeaponComponent(item, weaponName)
    if WeaponAttachments[item] and WeaponAttachments[item][weaponName] then
        return WeaponAttachments[item][weaponName]
    end
    return false
end

local function EquipWeaponAttachment(src, item)
    local shouldRemove = false
    local ped = GetPlayerPed(src)
    local selectedWeaponHash = GetSelectedPedWeapon(ped)
    if selectedWeaponHash == `WEAPON_UNARMED` then
        Notify(src, 'You need to have a weapon on hand', 'error')
        return
    end
    local weaponName = QBCore.Shared.Weapons[selectedWeaponHash].name
    if not weaponName then return end
    local attachmentComponent = DoesWeaponTakeWeaponComponent(item, weaponName)
    if not attachmentComponent then
        Notify(src, 'This attachment is not valid for the selected weapon.', 'error')
        return
    end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local weaponSlot, weaponSlotIndex = GetWeaponSlotByName(Player.PlayerData.items, weaponName)
    if not weaponSlot then return end
    weaponSlot.info.attachments = weaponSlot.info.attachments or {}
    local hasAttach, attachIndex = HasAttachment(attachmentComponent, weaponSlot.info.attachments)
    if hasAttach then
        RemoveWeaponComponentFromPed(ped, selectedWeaponHash, attachmentComponent)
        table.remove(weaponSlot.info.attachments, attachIndex)
    else
        weaponSlot.info.attachments[#weaponSlot.info.attachments + 1] = {
            component = attachmentComponent,
        }
        GiveWeaponComponentToPed(ped, selectedWeaponHash, attachmentComponent)
        shouldRemove = true
    end
    Player.PlayerData.items[weaponSlotIndex] = weaponSlot
    Player.Functions.SetInventory(Player.PlayerData.items, true)
    if shouldRemove then
        Player.Functions.RemoveItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', 1)
    end
end

-- Events

RegisterServerEvent('weapon:repairTime', function()
    local src = source
    local formattedTime = FormatTime(globalTime)
    Notify(src, 'This will take ' .. formattedTime, 'info')
end)

RegisterNetEvent('weapons:server:TakeBackWeapon', function(k)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemdata = RepairPoints[k].RepairingData.WeaponData
    itemdata.info.quality = 100
    Player.Functions.AddItem(itemdata.name, 1, false, itemdata.info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemdata.name], 'add', 1)
    RepairPoints[k].IsRepairing = false
    RepairPoints[k].RepairingData = {}
    TriggerClientEvent('weapons:client:SyncRepairShops', -1, RepairPoints[k], k)
end)

RegisterNetEvent('weapons:server:UpdateWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    amount = tonumber(amount)
    if CurrentWeaponData then
        if Player.PlayerData.items[CurrentWeaponData.slot] then
            Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.Functions.SetInventory(Player.PlayerData.items, true)
    end
end)

RegisterNetEvent('weapons:server:SetWeaponQuality', function(data, hp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local WeaponSlot = Player.PlayerData.items[data.slot]
    WeaponSlot.info.quality = hp
    Player.Functions.SetInventory(Player.PlayerData.items, true)
end)

RegisterNetEvent('weapons:server:UpdateWeaponQuality', function(data, RepeatAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local WeaponData = QBCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = DurabilityMultiplier[data.name] or 0.15
    if WeaponSlot then
        if not IsWeaponBlocked(WeaponData.name) then
            if WeaponSlot.info.quality then
                for _ = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data, false)
                        Notify(src, 'This weapon is broken and can not be used.', 'error')
                        break
                    end
                end
            else
                WeaponSlot.info.quality = 100
                for _ = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data, false)
                        Notify(src, 'This weapon is broken and can not be used.', 'error')
                        break
                    end
                end
            end
        end
    end
    Player.Functions.SetInventory(Player.PlayerData.items, true)
end)

RegisterNetEvent('weapons:server:removeWeaponAmmoItem', function(item)
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player or type(item) ~= 'table' or not item.name or not item.slot then return end

    Player.Functions.RemoveItem(item.name, 1, item.slot)
end)

-- Commands

QBCore.Commands.Add('repairweapon', 'Repair Weapon (God Only)', { { name = 'hp', help = 'Durability of your weapon' } },
    true, function(source, args)
    TriggerClientEvent('weapons:client:SetWeaponQuality', source, tonumber(args[1]))
end, 'god')

-- AMMO

local AmmoTypes = {
    pistol_ammo = { ammoType = 'AMMO_PISTOL', amount = 30 },
    rifle_ammo = { ammoType = 'AMMO_RIFLE', amount = 30 },
    hunting_ammo = { ammoType = 'AMMO_HUNTING', amount = 30 },
    smg_ammo = { ammoType = 'AMMO_SMG', amount = 30 },
    shotgun_ammo = { ammoType = 'AMMO_SHOTGUN', amount = 10 },
    mg_ammo = { ammoType = 'AMMO_MG', amount = 30 },
    snp_ammo = { ammoType = 'AMMO_SNIPER', amount = 10 },
    emp_ammo = { ammoType = 'AMMO_EMPLAUNCHER', amount = 10 },
    smoke_ammo = { ammoType = 'AMMO_GRENADELAUNCHER', amount = 10 }
}

for ammoItem, properties in pairs(AmmoTypes) do
    QBCore.Functions.CreateUseableItem(ammoItem, function(source, item)
        TriggerClientEvent('weapons:client:AddAmmo', source, properties.ammoType, properties.amount, item)
    end)
end

-- Attachments

for attachmentItem in pairs(WeaponAttachments) do
    QBCore.Functions.CreateUseableItem(attachmentItem, function(source, item)
        EquipWeaponAttachment(source, item.name)
    end)
end

-- Callback

QBCore.Functions.CreateCallback('weapons:server:GetConfig', function(_, cb)
    cb(RepairPoints)
end)

QBCore.Functions.CreateCallback('weapons:server:RepairWeapon', function(source, cb, RepairPoint, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local minute = 60 * 1000
    local WeaponData = QBCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponClass = (QBCore.Shared.SplitStr(WeaponData.ammotype, '_')[2]):lower()

    if Player.PlayerData.items[data.slot] then
        if Player.PlayerData.items[data.slot].info.quality then
            if Player.PlayerData.items[data.slot].info.quality ~= 100 then
                if RepairPoints[RepairPoint].repairCosts[WeaponClass] then
                    globalTime = RepairPoints[RepairPoint].repairCosts[WeaponClass].time * minute
                    if Player.Functions.RemoveMoney('cash', RepairPoints[RepairPoint].repairCosts[WeaponClass].cost, 'weapon-repair') then
                        RepairPoints[RepairPoint].IsRepairing = true
                        RepairPoints[RepairPoint].RepairingData = {
                            CitizenId = Player.PlayerData.citizenid,
                            WeaponData = Player.PlayerData.items[data.slot],
                            Ready = false,
                        }
                        Player.Functions.RemoveItem(data.name, 1, data.slot)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.name], 'remove', 1)
                        TriggerClientEvent('inventory:client:CheckWeapon', src, data.name)
                        TriggerClientEvent('weapons:client:SyncRepairShops', -1, RepairPoints[RepairPoint], RepairPoint)

                        SetTimeout(globalTime, function()
                            RepairPoints[RepairPoint].IsRepairing = false
                            RepairPoints[RepairPoint].RepairingData.Ready = true
                            TriggerClientEvent('weapons:client:SyncRepairShops', -1, RepairPoints[RepairPoint],
                                RepairPoint)
                            TriggerEvent('qb-phone:server:sendNewMailToOffline', Player.PlayerData.citizenid, {
                                sender = 'MARFY',
                                subject = 'Weapon Repair',
                                message = 'Your ' ..
                                WeaponData.label .. ' is repaired. You can pick it up at the location.'
                            })
                            if RepairPoints[RepairPoint].tableTimeout ~= false then
                                SetTimeout(RepairPoints[RepairPoint].tableTimeout * minute, function()
                                    if RepairPoints[RepairPoint].RepairingData.Ready then
                                        RepairPoints[RepairPoint].RepairingData.CitizenId = nil
                                        TriggerClientEvent('weapons:client:SyncRepairShops', -1,
                                            RepairPoints[RepairPoint], RepairPoint)
                                    end
                                end)
                            end
                        end)
                        if not isCountingDown then
                            StartCountdown(globalTime)
                        end
                        cb(true)
                    else
                        Notify(src, 'Not enough cash!', 'error')
                        Notify(src, 'Repair Cost $' .. RepairPoints[RepairPoint].repairCosts[WeaponClass].cost, 'info')
                        cb(false)
                    end
                else
                    Notify(src, 'This weapon cannot be repaired at this point.', 'error')
                    cb(false)
                end
            else
                Notify(src, 'This weapon is not damaged.', 'error')
                cb(false)
            end
        else
            Notify(src, 'This weapon is not damaged.', 'error')
            cb(false)
        end
    else
        Notify(src, 'You don\'t have a weapon in your hand.', 'error')
        TriggerClientEvent('weapons:client:SetCurrentWeapon', src, {}, false)
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('weapon:server:GetWeaponAmmo', function(source, cb, WeaponData)
    local Player = QBCore.Functions.GetPlayer(source)
    local retval = 0
    if WeaponData then
        if Player then
            local ItemData = Player.Functions.GetItemBySlot(WeaponData.slot)
            if ItemData then
                retval = ItemData.info.ammo and ItemData.info.ammo or 0
            end
        end
    end
    cb(retval, WeaponData.name)
end)

QBCore.Functions.CreateCallback('prison:server:checkThrowable', function(source, cb, weapon)
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return cb(false) end
    local throwable = false
    for _, v in pairs(Throwables) do
        if QBCore.Shared.Weapons[weapon].name == 'weapon_' .. v then
            Player.Functions.RemoveItem('weapon_' .. v, 1)
            throwable = true
            break
        end
    end
    cb(throwable)
end)

QBCore.Functions.CreateCallback('weapons:server:RemoveAttachment', function(source, cb, AttachmentData, WeaponData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local allAttachments = WeaponAttachments
    local AttachmentComponent = allAttachments[AttachmentData.attachment][WeaponData.name]

    if Inventory[WeaponData.slot] then
        if Inventory[WeaponData.slot].info.attachments and next(Inventory[WeaponData.slot].info.attachments) then
            local HasAttach, key = HasAttachment(AttachmentComponent, Inventory[WeaponData.slot].info.attachments)
            if HasAttach then
                table.remove(Inventory[WeaponData.slot].info.attachments, key)
                Player.Functions.SetInventory(Player.PlayerData.items, true)
                Player.Functions.AddItem(AttachmentData.attachment, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[AttachmentData.attachment], 'add',
                    1)
                cb(Inventory[WeaponData.slot].info.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)
