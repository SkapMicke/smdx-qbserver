local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function CraftItem(craftedItem, requiredItems, amountToCraft, xpEarned, xpType)
    QBCore.Functions.TriggerCallback('crafting:getPlayerInventory', function(inventory)
        local hasAllMaterials = true
        for _, reqItem in pairs(requiredItems) do
            local itemAmount = 0
            for _, invItem in pairs(inventory) do
                if invItem.name == reqItem.item then
                    itemAmount = invItem.amount
                    break
                end
            end
            if itemAmount < reqItem.amount then
                hasAllMaterials = false
                QBCore.Functions.Notify(string.format(Lang:t('notifications.notenoughMaterials')) .. amountToCraft .. 'x ' .. QBCore.Shared.Items[craftedItem].label, 'error')
                break
            end
        end
        if hasAllMaterials then
            if Config.EnableSkillCheck then
                local success = exports['qb-minigames']:Skillbar('easy', '12345') -- difficulty and words to enter 
                if success then
                    QBCore.Functions.Progressbar('crafting_item', 'Crafting ' .. QBCore.Shared.Items[craftedItem].label, (math.random(2000, 5000) * amountToCraft), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = 'mini@repair',
                        anim = 'fixing_a_player',
                        flags = 16,
                    }, {}, {}, function()
                        TriggerServerEvent('qb-crafting:server:receiveItem', craftedItem, requiredItems, amountToCraft, xpEarned, xpType)
                    end)
                else
                    -- Remove a random number of required materials from the player's inventory
                    local randomItem = requiredItems[math.random(#requiredItems)]
                    local randomAmount = math.random(1, randomItem.amount)
                    TriggerServerEvent('qb-crafting:server:removeMaterials', randomItem.item, randomAmount)
                    QBCore.Functions.Notify('Crafting failed, some materials have been lost!', 'error')
                end
            else
                QBCore.Functions.Progressbar('crafting_item', 'Crafting ' .. QBCore.Shared.Items[craftedItem].label, (math.random(2000, 5000) * amountToCraft), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = 'mini@repair',
                    anim = 'fixing_a_player',
                    flags = 16,
                }, {}, {}, function()
                    TriggerServerEvent('qb-crafting:server:receiveItem', craftedItem, requiredItems, amountToCraft, xpEarned, xpType)
                end)
            end
        else
            QBCore.Functions.Notify(string.format(Lang:t('notifications.notenoughMaterials')), 'error')
        end
    end)
end

local function CraftAmount(craftedItem, requiredItems, xpGain, xpType)
    local dialog = exports['qb-input']:ShowInput({
        header = string.format(Lang:t('menus.entercraftAmount')),
        submitText = 'Confirm',
        inputs = {
            {
                type = 'number',
                name = 'amount',
                label = 'Amount',
                text = 'Enter Amount',
                isRequired = true
            },
        },
    })
    if dialog and tonumber(dialog.amount) then
        local amount = tonumber(dialog.amount)
        if amount > 0 then
            local multipliedItems = {}
            for _, reqItem in ipairs(requiredItems) do
                multipliedItems[#multipliedItems + 1] = {
                    item = reqItem.item,
                    amount = reqItem.amount * amount
                }
            end
            CraftItem(craftedItem, multipliedItems, amount, xpGain, xpType)
        else
            QBCore.Functions.Notify(string.format(Lang:t('notifications.invalidAmount')), 'error')
        end
    else
        QBCore.Functions.Notify(string.format(Lang:t('notifications.invalidInput')), 'error')
    end
end

local function OpenCraftingMenu(benchType)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local xpType = benchType == 'item_bench' and Config.item_bench.xpType or Config.attachment_bench.xpType
    local recipes = benchType == 'item_bench' and Config.item_bench.recipes or Config.attachment_bench.recipes
    local currentXP = PlayerData.metadata[xpType]

    QBCore.Functions.TriggerCallback('crafting:getPlayerInventory', function(inventory)
        local craftableItems = {}
        local nonCraftableItems = {}
        for _, recipe in pairs(recipes) do
            if currentXP >= recipe.xpRequired then
                local canCraft = true
                local itemsText = ''
                for _, reqItem in pairs(recipe.requiredItems) do
                    local hasItem = false
                    for _, invItem in pairs(inventory) do
                        if invItem.name == reqItem.item and invItem.amount >= reqItem.amount then
                            hasItem = true
                            break
                        end
                    end
                    local itemLabel = QBCore.Shared.Items[reqItem.item].label
                    itemsText = itemsText .. ' x' .. tostring(reqItem.amount) .. ' ' .. itemLabel .. '<br>'
                    if not hasItem then
                        canCraft = false
                    end
                end
                itemsText = string.sub(itemsText, 1, -5)
                local menuItem = {
                    header = QBCore.Shared.Items[recipe.item].label,
                    txt = itemsText,
                    icon = Config.ImageBasePath .. QBCore.Shared.Items[recipe.item].image,
                    params = {
                        isAction = true,
                        event = function()
                            CraftAmount(recipe.item, recipe.requiredItems, recipe.xpGain, xpType)
                        end,
                        args = {}
                    },
                    disabled = not canCraft
                }
                if canCraft then
                    craftableItems[#craftableItems + 1] = menuItem
                else
                    nonCraftableItems[#nonCraftableItems + 1] = menuItem
                end
            end
        end
        local menuItems = {
            {
                header = string.format(Lang:t('menus.header')),
                icon = 'fas fa-drafting-compass',
                isMenuHeader = true,
            }
        }
        for _, item in ipairs(craftableItems) do
            menuItems[#menuItems + 1] = item
        end
        for _, item in ipairs(nonCraftableItems) do
            menuItems[#menuItems + 1] = item
        end
        exports['qb-menu']:openMenu(menuItems)
    end)
end

local function PickupBench(benchType)
    local playerPed = PlayerPedId()
    local propHash = Config[benchType].object
    local entity = GetClosestObjectOfType(GetEntityCoords(playerPed), 3.0, propHash, false, false, false)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        TriggerServerEvent('qb-crafting:server:addCraftingTable', benchType)
        QBCore.Functions.Notify(string.format(Lang:t('notifications.pickupBench')), 'success')
    end
end

-- Events

RegisterNetEvent('qb-crafting:client:useCraftingTable', function(benchType)
    local playerPed = PlayerPedId()
    local coordsP = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 1.0)
    local playerHeading = GetEntityHeading(PlayerPedId())
    local itemHeading = playerHeading - 90
    local workbench = CreateObject(Config[benchType].object, coordsP, true, true, true)
    if itemHeading < 0 then itemHeading = 360 + itemHeading end
    SetEntityHeading(workbench, itemHeading)
    PlaceObjectOnGroundProperly(workbench)
    TriggerServerEvent('qb-crafting:server:removeCraftingTable', benchType)
    exports['qb-target']:AddTargetEntity(Config[benchType].object, {
        options = {
            {
                icon = 'fas fa-tools',
                label = string.format(Lang:t('menus.header')),
                action = function()
                    OpenCraftingMenu(benchType)
                end
            },
            {
                event = 'crafting:pickupWorkbench',
                icon = 'fas fa-hand-rock',
                label = string.format(Lang:t('menus.pickupworkBench')),
                action = function()
                    PickupBench(benchType)
                end,
            }
        },
        distance = 2.5
    })
end)
