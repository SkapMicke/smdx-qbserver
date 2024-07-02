lib.addKeybind({
    name = 'inventory',
    description = 'Open Inventory',
    defaultKey = Shared.KeyBinds.Inventory,
    onPressed = function()
        if IsNuiFocused() then return end
        if not inInventory then
            if not PlayerData.metadata.isdead and not PlayerData.metadata.inlaststand and not PlayerData.metadata.ishandcuffed and not IsPauseMenuActive() then
                InventoryOpen()
            end
        end
    end
})

lib.addKeybind({
    name = 'hotbar',
    description = 'Open Hotbar',
    defaultKey = Shared.KeyBinds.HotBar,
    onPressed = function()
        isHotbar = not isHotbar
        if not PlayerData.metadata.isdead and not PlayerData.metadata.inlaststand and not PlayerData.metadata.ishandcuffed and not IsPauseMenuActive() then
            ToggleHotbar(isHotbar)
        end
    end,
    onReleased = function()
        if isHotbar then
            ToggleHotbar(false)
        end
    end
})

for i = 1, 5 do
    lib.addKeybind({
        name = ('slot%s'):format(i),
        description = ('Uses the item %s~'):format(i),
        defaultKey = tostring(i),
        onPressed = function()
            if not PlayerData.metadata.isdead and not PlayerData.metadata.inlaststand and not PlayerData.metadata.ishandcuffed and not IsPauseMenuActive() and not LocalPlayer.state.inv_busy then
                if i == 6 then
                    i = Shared.MaxInventorySlots
                end
                TriggerServerEvent('inventory:server:UseItemSlot', i)
                closeInventory()
            end
        end
    })
end