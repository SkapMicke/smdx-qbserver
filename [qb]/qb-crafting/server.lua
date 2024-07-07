local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function IncreasePlayerXP(source, xpGain, xpType)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local currentXP = Player.Functions.GetRep(xpType)
        local newXP = currentXP + xpGain
        Player.Functions.AddRep(xpType, newXP)
        TriggerClientEvent('QBCore:Notify', source, string.format(Lang:t('notifications.xpGain'), xpGain, xpType), 'success')
    end
end

-- Callbacks

QBCore.Functions.CreateCallback('crafting:getPlayerInventory', function(source, cb)
    local player = QBCore.Functions.GetPlayer(source)
    if player then
        cb(player.PlayerData.items)
    else
        cb({})
    end
end)

-- Events
RegisterServerEvent('qb-crafting:server:removeMaterials', function(itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        exports['qb-inventory']:RemoveItem(src, itemName, amount, false, 'qb-crafting:server:removeMaterials')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
    end
end)

RegisterNetEvent('qb-crafting:server:removeCraftingTable', function(benchType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    exports['qb-inventory']:RemoveItem(src, benchType, 1, false, 'qb-crafting:server:removeCraftingTable')
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[benchType], 'remove')
    TriggerClientEvent('QBCore:Notify', src, Lang:t('notifications.tablePlace'), 'success')
end)

RegisterNetEvent('qb-crafting:server:addCraftingTable', function(benchType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not exports['qb-inventory']:AddItem(src, benchType, 1, false, false, 'qb-crafting:server:addCraftingTable') then return end
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[benchType], 'add')
end)

RegisterNetEvent('qb-crafting:server:receiveItem', function(craftedItem, requiredItems, amountToCraft, xpGain, xpType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local canGive = true
    for _, requiredItem in ipairs(requiredItems) do
        if not exports['qb-inventory']:RemoveItem(src, requiredItem.item, requiredItem.amount, false, 'qb-crafting:server:receiveItem') then
            canGive = false
            return
        end
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[requiredItem.item], 'remove')
    end
    if canGive then
        if not exports['qb-inventory']:AddItem(src, craftedItem, amountToCraft, false, false, 'qb-crafting:server:receiveItem') then return end
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[craftedItem], 'add')
        TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t('notifications.craftMessage'), QBCore.Shared.Items[craftedItem].label), 'success')
        IncreasePlayerXP(src, xpGain, xpType)
    end
end)

-- Items

for benchType, _ in pairs(Config) do
    QBCore.Functions.CreateUseableItem(benchType, function(source)
        TriggerClientEvent('qb-crafting:client:useCraftingTable', source, benchType)
    end)
end
