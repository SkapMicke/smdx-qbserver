Shared = {
    UseInteract = false, -- 'interact' or 'target' or false (interact = 'E' to open inventory, target = 'Target' to open inventory, false = no interact)
    MaxInventoryWeight = 150000, -- Max weight a player can carry (default 120kg, written in grams)
    MaxInventorySlots = 41, -- Max inventory slots for a player
    CleanupDropTime = 10 * 60, -- How many seconds it takes for drops to be untouched before being deleted
    MaxDropViewDistance = 10.0, -- The distance in GTA Units that a drop can be seen
    UseItemDrop = true, -- This will enable item object to spawn on drops instead of markers
    Blur = true, -- Enable blur when inventory is open
    ItemDropObject = `prop_cs_box_clothes`, -- if Shared.UseItemDrop is true, this will be the prop that spawns for the item
    CreateWeaponInfo = 'ps-mdt', -- Note: It will only work if you're using inventory shops
    SprintOnly = true, -- Should this only take effect when the player is sprinting/jogging?
    ReloadTime = 2500, -- 2.5 seconds
    DisableHeadShot = false, -- Disable headshot damage

    KeyBinds = { -- Keybinds for the inventory
        Inventory = 'TAB',
        HotBar = 'Z'
    },

    WeightEffects = {  -- I actually hard coded it to not go below 0.01 move speed. Slow can be 0 - 99.
        { weight = 130000, slow = 60 },
        { weight = 150000, slow = 80 }
    },

    Progressbar = { -- Progressbar settings
        Enable = true, -- True to Enable the progressbar while opening inventory
        Time = 300 -- Time for inventory to open
    }
}