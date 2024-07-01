Config = {
    Debug = false, -- Enable to add debug boxes and message.
    img = "ps-inventory/html/images/", -- Set this to your inventory
    MaxSlots = 41, -- Set this to your player inventory slot count, this is default "41"
    MaxWeight = 120000, -- Max weight a player can carry (default 120kg, written in grams)
    Measurement = "kg", -- Custom Weight measurement
    RandomLocation = true, -- Set to true if you want random location. False = create for each location a blackmarket
    RandomItem = true, -- Set to true if you want a random item. False = show all items
    RandomItemAmount = 3, -- Amount of random items
    RemoveItem = false, -- Do you want to remove the item after purchasing something from black market
    UseDirtyMoney = true, -- Do you want to use dirty money like blackmoney / crypto. Set to false if you want pay with normal money
    Payment = "blackmoney", -- Choose between blackmoney / crypto (default q-bit crypto)
    BlackMoneyName = "markedbills", -- If the option above is blackmoney then set the name of the black money item
    BlackMoneyMultiplier = 1.2, -- Where 1 is 100% and 2 is 200% etc, 1.2 if 120%
    UseTimer = false, -- Use a timer to change the blackmarket location
    ChangeLocationTime = 30, -- Time in minutes to change the location of the black market.
    EnableHacking = true, -- Enable hacking minigames for tapping phone connections to find the location of the blackmarket
    Stock = true, -- Do you want to keep a stock of items until server restart ?
}

Config.PhoneModels = {
    "prop_phonebox_04",
    "prop_phonebox_01a"
}

-- Options : keyminigame (default qb-keyminigame) / howdys (https://github.com/HiHowdy/howdy-hackminigame)
Config.Minigame = "keyminigame"
Config.Dispatch = "qbcore"

Config.Products = {
    ["blackmarket"] = {
        [1] = { name = "weapon_knuckle", price = 900, crypto = 0, amount = 1 },
        [2] = { name = "pistol_suppressor", price = 850, crypto = 2, amount = 1 },
        [3] = { name = "weapon_knife", price = 550, crypto = 1, amount = 5 },
        [3] = { name = "weapon_crowbar", price = 550, crypto = 1, amount = 5 },
        [3] = { name = "weapon_hammer", price = 550, crypto = 1, amount = 5 },

    },
}

Config.Locations = {
    ["blackmarket"] = {
        ["label"] = "Black Market",
        --["openwith"] = "", -- Type here the name of the item you want to open the shop with
        --["gang"] = "", -- The gang name that can open the shop
        ["model"] = {
            [1] = `mp_f_weed_01`,
            [2] = `MP_M_Weed_01`,
            [3] = `A_M_Y_MethHead_01`,
            [4] = `A_F_Y_RurMeth_01`,
            [5] = `A_M_M_RurMeth_01`,
            [6] = `MP_F_Meth_01`,
            [7] = `MP_M_Meth_01`,
        },
        ["coords"] = {
            [1] = vector4(776.24, 4184.08, 41.8, 92.12),
            -- [2] = vector4(2482.51, 3722.28, 43.92, 39.98),
            -- [3] = vector4(462.67, -1789.16, 28.59, 317.53),
            -- [4] = vector4(-115.15, 6369.07, 31.52, 232.08),
            -- [5] = vector4(752.52, -3198.33, 6.07, 301.72)
            },
        ["products"] = Config.Products["blackmarket"],
        ["hideblip"] = true,
    },
}
