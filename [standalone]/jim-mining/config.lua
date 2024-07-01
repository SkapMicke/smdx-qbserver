print("^2Jim-Mining ^7v^4"..GetResourceMetadata(GetCurrentResourceName(), 'version', nil):gsub("%.", "^7.^4").."^7 - ^2Mining Script by ^1Jimathy^7")

Loc = {}

Config = {
	Debug = false, -- enable debug mode
	img = "ps-inventory/html/images/", --Set this to the image directory of your inventory script or "nil" if using newer qb-menu

	Lan = "sv", -- Pick your language here

	JimShops = false, 		-- Set this to true if using jim-shops

	Inv = "qb",				--"qb" or "ox"
	Menu = "qb",			--"qb" or "ox"
	ProgressBar = "qb",		--"qb" or "ox"
	Notify = "qb",			--"qb" or "ox"

	DrillSound = true,		-- disable drill sounds

	MultiCraft = true,		-- Enable multicraft
	MultiCraftAmounts = { [1], [5], [10] },

	K4MB1Prop = false, -- Enable this to make use of K4MB1's ore props provided with their Mining Cave MLO

	Timings = { -- Time it takes to do things
		["Cracking"] = math.random(8000, 11000),
		["Washing"] = math.random(13000, 16000),
		["Panning"] = math.random(25000, 30000),
		["Pickaxe"] = math.random(20000, 25000),
		["Mining"] = math.random(12000, 16000),
		["Laser"] = math.random(7000, 10000),
		["OreRespawn"] = math.random(55000, 75000),
		["Crafting"] = 5000,
	},

	CrackPool = { -- Rewards from cracking stone
		"carbon",
		"copperore",
		"ironore",
		"metalscrap",
	},

	WashPool = {	-- Rewards from washing stone
		"goldore",
		"uncut_ruby",
		"uncut_emerald",
		"uncut_diamond",
		"uncut_sapphire",
		"goldore",
	},

	PanPool = {		-- Rewards from panning
		"can",
		"goldore",
		"can",
		"goldore",
		"bottle",
		"stone",
		"goldore",
		"bottle",
		"can",
		"silverore",
		"can",
		"silverore",
		"bottle",
		"stone",
		"silverore",
		"bottle",
	},

------------------------------------------------------------
	OreSell = { -- List of ores you can sell to the buyer npc
		"goldingot",
		"silveringot",
		"copperore",
		"ironore",
		"goldore",
		"silverore",
		"carbon",
	},

	SellingPrices = { -- SellingPrices
    -- ['copperore'] = 10,
    -- ['goldore'] = 20,
    -- ['silverore'] = 15,
    -- ['ironore'] = 10,
    -- ['carbon'] = 5,

    -- ['goldingot'] = 40,
    -- ['silveringot'] = 65,

    -- ['uncut_emerald'] = 90,
    -- ['uncut_ruby'] = 80,
    -- ['uncut_diamond'] = 100,
    -- ['uncut_sapphire'] = 90,

    ['emerald'] = 150,
    ['ruby'] = 150,
    ['diamond'] = 160,
    ['sapphire'] = 170,

    ['diamond_ring'] = 225,
    ['emerald_ring'] = 225,
    ['ruby_ring'] = 250,
    ['sapphire_ring'] = 250,
    ['diamond_ring_silver'] = 300,
    ['emerald_ring_silver'] = 350,
    ['ruby_ring_silver'] = 300,
    ['sapphire_ring_silver'] = 350,

    ['diamond_necklace'] = 200,
    ['emerald_necklace'] = 250,
    ['ruby_necklace'] = 250,
    ['sapphire_necklace'] = 250,
    ['diamond_necklace_silver'] = 250,
    ['emerald_necklace_silver'] = 300,
    ['ruby_necklace_silver'] = 250,
    ['sapphire_necklace_silver'] = 300,

    ['diamond_earring'] = 200,
    ['emerald_earring'] = 225,
    ['ruby_earring'] = 230,
    ['sapphire_earring'] = 250,
    ['diamond_earring_silver'] = 350,
    ['emerald_earring_silver'] = 350,
    ['ruby_earring_silver'] = 400,
    ['sapphire_earring_silver'] = 400,

    ['gold_ring'] = 50,
    ['goldchain'] = 50,
    ['goldearring'] = 50,
    ['silver_ring'] = 100,
    ['silverchain'] = 100,
    ['silverearring'] = 100,
	},
	

------------------------------------------------------------
--Mining Store Items
	Items = {
		label = "Gruvaffär",  slots = 9,
		items = {
			{ name = "water_bottle", price = 15, amount = 100, info = {}, type = "item", slot = 1, },
			{ name = "sandwich", price = 15, amount = 250, info = {}, type = "item", slot = 2, },
			{ name = "bandage", price = 100, amount = 100, info = {}, type = "item", slot = 3, },
			{ name = "weapon_flashlight", price = 300, amount = 100, info = {}, type = "item", slot = 4, },
			{ name = "goldpan", price = 420, amount = 100, info = {}, type = "item", slot = 5, },
			{ name = "pickaxe",	price = 350, amount = 100, info = {}, type = "item", slot = 6, },
			{ name = "miningdrill",	price = 15000, amount = 50, info = {}, type = "item", slot = 7, },
			{ name = "mininglaser",	price = 60000, amount = 5, info = {}, type = "item", slot = 8, },
			{ name = "drillbit", price = 200, amount = 100, info = {}, type = "item", slot = 9, },
		},
	},
}
Crafting = {
	SmeltMenu = {
		{ ["copper"] = { ["copperore"] = 1 }, ['amount'] = 4 },
		{ ["goldingot"] = { ["goldore"] = 1 } },
		{ ["goldingot"] = { ["goldchain"] = 2 } },
		{ ["goldingot"] = { ["gold_ring"] = 4 } },
		{ ["silveringot"] = { ["silverore"] = 1 } },
		{ ["silveringot"] = { ["silverchain"] = 2 } },
		{ ["silveringot"] = { ["silver_ring"] = 4 } },
		{ ["iron"] = { ["ironore"] = 1 } },
		{ ["steel"] = { ["ironore"] = 1, ["carbon"] = 1 } },
		{ ["aluminum"] = { ["can"] = 2, }, ['amount'] = 3 },
		{ ["glass"] = { ["bottle"] = 2, }, ['amount'] = 2 },
	},
	GemCut = {
		{ ["emerald"] = { ["uncut_emerald"] = 1, } },
		{ ["diamond"] = { ["uncut_diamond"] = 1}, },
		{ ["ruby"] = { ["uncut_ruby"] = 1 }, },
		{ ["sapphire"] = { ["uncut_sapphire"] = 1 }, },
	},
	RingCut = {
		{ ["gold_ring"] = { ["goldingot"] = 1 }, ['amount'] = 3 },
		{ ["silver_ring"] = { ["silveringot"] = 1 }, ['amount'] = 3 },
		{ ["diamond_ring"] = { ["gold_ring"] = 1, ["diamond"] = 2 }, },
		{ ["emerald_ring"] = { ["gold_ring"] = 1, ["emerald"] = 2 }, },
		{ ["ruby_ring"] = { ["gold_ring"] = 1, ["ruby"] = 2 }, },
		{ ["sapphire_ring"] = { ["gold_ring"] = 1, ["sapphire"] = 2 }, },

		{ ["diamond_ring_silver"] = { ["silver_ring"] = 1, ["diamond"] = 2 }, },
		{ ["emerald_ring_silver"] = { ["silver_ring"] = 1, ["emerald"] = 2 }, },
		{ ["ruby_ring_silver"] = { ["silver_ring"] = 1, ["ruby"] = 2 }, },
		{ ["sapphire_ring_silver"] = { ["silver_ring"] = 1, ["sapphire"] = 2 }, },
	},
	NeckCut = {
		{ ["goldchain"] = { ["goldingot"] = 1 }, ['amount'] = 3  },
		{ ["silverchain"] = { ["silveringot"] = 1 }, ['amount'] = 3  },
		{ ["diamond_necklace"] = { ["goldchain"] = 1, ["diamond"] = 2 }, },
		{ ["ruby_necklace"] = { ["goldchain"] = 1, ["ruby"] = 2 }, },
		{ ["sapphire_necklace"] = { ["goldchain"] = 1, ["sapphire"] = 2 }, },
		{ ["emerald_necklace"] = { ["goldchain"] = 1, ["emerald"] = 2 }, },

		{ ["diamond_necklace_silver"] = { ["silverchain"] = 1, ["diamond"] = 2 }, },
		{ ["ruby_necklace_silver"] = { ["silverchain"] = 1, ["ruby"] = 2 }, },
		{ ["sapphire_necklace_silver"] = { ["silverchain"] = 1, ["sapphire"] = 2 }, },
		{ ["emerald_necklace_silver"] = { ["silverchain"] = 1, ["emerald"] = 2 }, },
	},
	EarCut = {
		{ ["goldearring"] = { ["goldingot"] = 1 }, ['amount'] = 3  },
		{ ["silverearring"] = { ["silveringot"] = 1 }, ['amount'] = 3  },
		{ ["diamond_earring"] = { ["goldearring"] = 1, ["diamond"] = 2 }, },
		{ ["ruby_earring"] = { ["goldearring"] = 1, ["ruby"] = 2 }, },
		{ ["sapphire_earring"] = { ["goldearring"] = 1, ["sapphire"] = 2 }, },
		{ ["emerald_earring"] = { ["goldearring"] = 1, ["emerald"] = 2 }, },

		{ ["diamond_earring_silver"] = { ["silverearring"] = 1, ["diamond"] = 2 }, },
		{ ["ruby_earring_silver"] = { ["silverearring"] = 1, ["ruby"] = 2 }, },
		{ ["sapphire_earring_silver"] = { ["silverearring"] = 1, ["sapphire"] = 2 }, },
		{ ["emerald_earring_silver"] = { ["silverearring"] = 1, ["emerald"] = 2 }, },
	},
}
