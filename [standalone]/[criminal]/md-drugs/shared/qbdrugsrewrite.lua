QBConfig = {}
-----------  qb-drugs update built in here below
----------- Everything is now a target and not displaytext. Dealers are no longer just doors, they will spawn peds where you place your dealer. This is a literally qb-drugs with SLIGHT edits. mainly added peds for deliveries, made everything a target
------------ and changed the range a ped will walk up to you to be a bigger radius. 
QBConfig.SuccessChance = 50
QBConfig.ScamChance = 25
QBConfig.RobberyChance = 25
QBConfig.MinimumDrugSalePolice = 0

QBConfig.DrugsPrice = {
    ["weed_white-widow"] = { min = 15, max = 24 },
    ["weed_og-kush"] = {min = 15, max = 28},
    ["weed_skunk"] = {min = 15, max = 31 },
    ["weed_amnesia"] = {min = 18, max = 34},
    ["weed_purple-haze"] = {min = 18, max = 37},
    ["weed_ak47"] = {min = 18, max = 40},
    ["crack_baggy"] = {min = 18, max = 34},
    ["cokebaggy"] = {min = 18, max = 37},
    ["cokebaggystagetwo"] = {min = 18, max = 40},
	["cokebaggystagethree"] = {min = 18, max = 40},
	["heroin_ready"] = {min = 18, max = 40},
	["heroin_readystagetwo"] = {min = 18, max = 40},
	["heroin_readystagethree"] = {min = 18, max = 40},
	["baggedcracked"] = {min = 18, max = 40},
	["baggedcrackedstagetwo"] = {min = 18, max = 40},
	["baggedcrackedstagethree"] = {min = 18, max = 40},
	["white_playboys"] = {min = 18, max = 40},
	["white_playboys2"] = {min = 18, max = 40},
	["white_playboys3"] = {min = 18, max = 40},
	["white_playboys4"] = {min = 18, max = 40},
	["blue_playboys"] = {min = 18, max = 40},
	["blue_playboys2"] = {min = 18, max = 40},
	["blue_playboys3"] = {min = 18, max = 40},
	["blue_playboys4"] = {min = 18, max = 40},
	["red_playboys"] = {min = 18, max = 40},
	["red_playboys2"] = {min = 18, max = 40},
	["red_playboys3"] = {min = 18, max = 40},
	["red_playboys4"] = {min = 18, max = 40},
	["orange_playboys"] = {min = 18, max = 40},
	["orange_playboys2"] = {min = 18, max = 40},
	["orange_playboys3"] = {min = 18, max = 40},
	["orange_playboys4"] = {min = 18, max = 40},
	["white_aliens"] = {min = 18, max = 40},
	["white_aliens2"] = {min = 18, max = 40},
	["white_aliens3"] = {min = 18, max = 40},
	["white_aliens4"] = {min = 18, max = 40},
	["blue_aliens"] = {min = 18, max = 40},
	["blue_aliens2"] = {min = 18, max = 40},
	["blue_aliens3"] = {min = 18, max = 40},
	["blue_aliens4"] = {min = 18, max = 40},
	["red_aliens"] = {min = 18, max = 40},
	["red_aliens2"] = {min = 18, max = 40},
	["red_aliens3"] = {min = 18, max = 40},
	["red_aliens4"] = {min = 18, max = 40},
	["orange_aliens"] = {min = 18, max = 40},
	["orange_aliens2"] = {min = 18, max = 40},
	["orange_aliens3"] = {min = 18, max = 40},
	["orange_aliens4"] = {min = 18, max = 40},
	["white_pl"] = {min = 18, max = 40},
	["white_pl2"] = {min = 18, max = 40},
	["white_pl3"] = {min = 18, max = 40},
	["white_pl4"] = {min = 18, max = 40},
	["blue_pl"] = {min = 18, max = 40},
	["blue_pl2"] = {min = 18, max = 40},
	["blue_pl3"] = {min = 18, max = 40},
	["blue_pl4"] = {min = 18, max = 40},
	["red_pl"] = {min = 18, max = 40},
	["red_pl2"] = {min = 18, max = 40},
	["red_pl3"] = {min = 18, max = 40},
	["red_pl4"] = {min = 18, max = 40},
	["orange_pl"] = {min = 18, max = 40},
	["orange_pl2"] = {min = 18, max = 40},
	["orange_pl3"] = {min = 18, max = 40},
	["orange_pl4"] = {min = 18, max = 40},
	["white_trolls"] = {min = 18, max = 40},
	["white_trolls2"] = {min = 18, max = 40},
	["white_trolls3"] = {min = 18, max = 40},
	["white_trolls4"] = {min = 18, max = 40},
	["blue_trolls"] = {min = 18, max = 40},
	["blue_trolls2"] = {min = 18, max = 40},
	["blue_trolls3"] = {min = 18, max = 40},
	["blue_trolls4"] = {min = 18, max = 40},
	["red_trolls"] = {min = 18, max = 40},
	["red_trolls2"] = {min = 18, max = 40},
	["red_trolls3"] = {min = 18, max = 40},
	["red_trolls4"] = {min = 18, max = 40},
	["orange_trolls"] = {min = 18, max = 40},
	["orange_trolls2"] = {min = 18, max = 40},
	["orange_trolls3"] = {min = 18, max = 40},
	["orange_trolls4"] = {min = 18, max = 40},
	["white_cats"] = {min = 18, max = 40},
	["white_cats2"] = {min = 18, max = 40},
	["white_cats3"] = {min = 18, max = 40},
	["white_cats4"] = {min = 18, max = 40},
	["blue_cats"] = {min = 18, max = 40},
	["blue_cats2"] = {min = 18, max = 40},
	["blue_cats3"] = {min = 18, max = 40},
	["blue_cats4"] = {min = 18, max = 40},
	["red_cats"] = {min = 18, max = 40},
	["red_cats2"] = {min = 18, max = 40},
	["red_cats3"] = {min = 18, max = 40},
	["red_cats4"] = {min = 18, max = 40},
	["orange_cats"] = {min = 18, max = 40},
	["orange_cats2"] = {min = 18, max = 40},
	["orange_cats3"] = {min = 18, max = 40},
	["orange_cats4"] = {min = 18, max = 40},	
	["blunts"] = {min = 18, max = 40},
	["leanblunts"] = {min = 18, max = 40},
	["dextroblunts"] = {min = 18, max = 40},
	["chewyblunt"] = {min = 18, max = 40},
	["cupoflean"] = {min = 18, max = 40},
	["shatter"] = {min = 18, max = 40},
	["ciggie"] = {min = 18, max = 40},
	["methbags"] = {min = 18, max = 40},	
	["driedmescaline"] = {min = 18, max = 40},
	["specialchocolate"] = {min = 18, max = 40},
	["shrooms"] = {min = 18, max = 40},
	["gratefuldead_tabs"] = {min = 18, max = 40},
	["bart_tabs"] = {min = 18, max = 40},
	["pineapple_tabs"] = {min = 18, max = 40},
	["yinyang_tabs"] = {min = 18, max = 40},
	["wildcherry_tabs"] = {min = 18, max = 40},	
	["smiley_tabs"] = {min = 18, max = 40},
	
}

	Debug = false -- true / false - Currently prints the vector3 and label of locations when requesting a delivery
    NearbyDeliveries = false -- true / false - Do you want deliveries to be within a certain amount of units?
    DeliveryWithin = 2000 -- int (Default 2000) - How many units do you want the delivery location to be within from the player when making a delivery request?
    QBConfig.Dealers = {}
    --UseTarget =  GetConvar('UseTarget', 'false') == 'true', -- Use qb-target interactions (don't change this, go to your server.cfg and add setr UseTarget true)
    PoliceCallChance = 99 --in percentage (if 99, theres the 99% to call the police)

    -- Shop QBConfig
QBConfig.Products = {
        [1] = {name = "weed_white-widow_seed",  label = "White Widow Seed", price = 15, amount = 150, info = {}, type = "item", slot = 1, minrep = 0},
        [2] = {name = "weed_skunk_seed", 		label = "Skunk Seed",  		price = 15, amount = 150, info = {}, type = "item", slot = 2, minrep = 0},
        [3] = {name = "weed_purple-haze_seed",	label = "Purple Haze Seed", price = 15, amount = 150, info = {}, type = "item", slot = 3, minrep = 0},
		[4] = {name = "weed_og-kush_seed", 	    label = "OG Kush Seed",		price = 15, amount = 150, info = {}, type = "item", slot = 4, minrep = 0},
		[5] = {name = "weed_amnesia_seed", 		label = "Amnesia Seed",		price = 15, amount = 150, info = {}, type = "item", slot = 5, minrep = 0},
}

QBConfig.ProductsStupidNameRewrite = {
        [1] = {name = "weed_whitewidow_seed",  label = "White Widow Seed", price = 15, amount = 150, info = {}, type = "item", slot = 1, minrep = 0},
        [2] = {name = "weed_skunk_seed", 		label = "Skunk Seed",  		price = 15, amount = 150, info = {}, type = "item", slot = 2, minrep = 0},
        [3] = {name = "weed_purplehaze_seed",	label = "Purple Haze Seed", price = 15, amount = 150, info = {}, type = "item", slot = 3, minrep = 0},
		[4] = {name = "weed_ogkush_seed", 	    label = "OG Kush Seed",		price = 15, amount = 150, info = {}, type = "item", slot = 4, minrep = 0},
		[5] = {name = "weed_amnesia_seed", 		label = "Amnesia Seed",		price = 15, amount = 150, info = {}, type = "item", slot = 5, minrep = 0},
}

QBConfig.UseMarkedBills = false -- true for marked bills, false for cash
QBConfig.DeliveryRepGain = 1 -- amount of rep gained per delivery
QBConfig.DeliveryRepLoss = 1 -- amount of rep lost if delivery wrong or late
QBConfig.PoliceDeliveryModifier = 2 -- amount to multiply active cop count by
QBConfig.WrongAmountFee = 2 -- divide the payout by this value for wrong delivery amount
QBConfig.OverdueDeliveryFee = 4 -- divide the payout by this value for overdue delivery

QBConfig.DeliveryItems = {
   [1] = {
       ["item"] = "weed_brick",
       ["minrep"] = 0,
       ['payout'] = 1000
   },
   [2] = {
       ["item"] = "coke_brick",
       ["minrep"] = 0,
       ['payout'] = 1000
   },
}

QBConfig.DeliveryLocations = {
	[1] = {
        ["label"] = "Pork Factory",
        ["coords"] = vector3(-296.27, -1300.54, 31.31),
    },
    [2] = {
        ["label"] = "Forum Drive Deli",
        ["coords"] = vector3(-36.69, -1492.13, 31.22),
    },
    [3] = {
        ["label"] = "Hayes Autos South LS",
        ["coords"] = vector3(282.55, -1814.39, 27.1),
    },
    [4] = {
        ["label"] = "Grove Street",
        ["coords"] = vector3(54.55, -1873.15, 22.8),
    },
    [5] = {
        ["label"] = "Port1",
        ["coords"] = vector3(-269.4, -2437.15, 6.36),
    },
    [6] = {
        ["label"] = "Port2",
        ["coords"] = vector3(269.16, -3248.54, 5.79),
    },
    [7] = {
        ["label"] = "Port3",
        ["coords"] = vector3(632.9, -3015.42, 7.34),
    },
    [8] = {
        ["label"] = "Industrial1",
        ["coords"] = vector3(1049.52, -2427.96, 30.3),
    },
    [9] = {
        ["label"] = "Industrial2",
        ["coords"] = vector3(853.26, -2207.3, 30.68),
    },
    [10] = {
        ["label"] = "Industrial3",
        ["coords"] = vector3(903.02, -1721.94, 32.18),
    },
    [11] = {
        ["label"] = "EastLS1",
        ["coords"] = vector3(1289.33, -1710.47, 55.51),
    },
    [12] = {
        ["label"] = "EastLS2",
        ["coords"] = vector3(1411.94, -1490.54, 60.66),
    },
    [13] = {
        ["label"] = "Industrial4",
        ["coords"] = vector3(734.26, -1311.26, 27.01),
    },
    [14] = {
        ["label"] = "Industrial5",
        ["coords"] = vector3(1231.6, -1083.06, 38.53),
    },
    [15] = {
        ["label"] = "Mirror1",
        ["coords"] = vector3(1143.55, -1000.19, 45.32),
    },
    [16] = {
        ["label"] = "Mirror2",
        ["coords"] = vector3(1264.82, -702.87, 64.72),
    },
    [17] = {
        ["label"] = "Mirror3",
        ["coords"] = vector3(1119.65, -639.76, 56.81),
    },
    [18] = {
        ["label"] = "Mirror4",
        ["coords"] = vector3(1129.59, -462.59, 66.49),
    },
    [19] = {
        ["label"] = "City1",
        ["coords"] = vector3(42.8, -811.45, 31.43),
    },
    [20] = {
        ["label"] = "City2",
        ["coords"] = vector3(-509.48, -1001.66, 23.55),
    },
    [21] = {
        ["label"] = "City3",
        ["coords"] = vector3(-830.97, -862.41, 20.69),
    },
    [22] = {
        ["label"] = "Vesp1",
        ["coords"] = vector3(-1320.26, -1177.34, 4.89),
    },
    [23] = {
        ["label"] = "Vesp2",
        ["coords"] = vector3(-1097.63, -1673.24, 8.4),
    },
    [24] = {
        ["label"] = "Vesp3",
        ["coords"] = vector3(-1147.61, -1452.1, 4.6),
    },
    [25] = {
        ["label"] = "Vesp4",
        ["coords"] = vector3(-1241.69, -1208.39, 8.52),
    },
    [26] = {
        ["label"] = "Vesp5",
        ["coords"] = vector3(-1876.92, -584.44, 11.85),
    },
    [27] = {
        ["label"] = "City4",
        ["coords"] = vector3(-1303.94, -441.39, 35.22),
    },
    [28] = {
        ["label"] = "City5",
        ["coords"] = vector3(-1705.48, -433.46, 42.17),
    },
    [29] = {
        ["label"] = "City6",
        ["coords"] = vector3(-1305.99, 336.35, 65.5),
    },
    [30] = {
        ["label"] = "Vinewood1",
        ["coords"] = vector3(-741.8, 484.84, 109.47),
    },
    [31] = {
        ["label"] = "Vinewood2",
        ["coords"] = vector3(-409.57, 341.49, 108.91),
    },
    [32] = {
        ["label"] = "Vinewood3",
        ["coords"] = vector3(-126.44, 588.18, 204.71),
    },
    [33] = {
        ["label"] = "Vinewood4",
        ["coords"] = vector3(211.42, -101.42, 73.28),
    },
    [34] = {
        ["label"] = "Vinewood5",
        ["coords"] = vector3(490.61, -95.04, 66.44),
    },
    [35] = {
        ["label"] = "City7",
        ["coords"] = vector3(387.19, -993.59, 29.42),
    },
    [36] = {
        ["label"] = "City8",
        ["coords"] = vector3(-500.47, -712.37, 33.21),
    },
    [37] = {
        ["label"] = "EastHW",
        ["coords"] = vector3(2572.2, 479.97, 108.68),
    },
    [38] = {
        ["label"] = "Vinewood6",
        ["coords"] = vector3(-430.1, 1205.41, 325.76),
    },
    [39] = {
        ["label"] = "VinewoodHills1",
        ["coords"] = vector3(-126.06, 1896.58, 197.33),
    },
    [40] = {
        ["label"] = "VinewoodHills2",
        ["coords"] = vector3(-2521.08, 2310.31, 33.22),
    },
    [41] = {
        ["label"] = "RedwoodsCons",
        ["coords"] = vector3(1129.01, 2125.14, 55.55),
    },
    [42] = {
        ["label"] = "RedwoodsFarm",
        ["coords"] = vector3(1546.64, 2166.56, 78.72),
    },
    [43] = {
        ["label"] = "Harmony1",
        ["coords"] = vector3(404.34, 2584.54, 43.52),
    },
    [44] = {
        ["label"] = "Harmony2",
        ["coords"] = vector3(180.15, 2792.99, 45.66),
    },
    [45] = {
        ["label"] = "Harmony3",
        ["coords"] = vector3(287.67, 2843.89, 44.7),
    },
    [46] = {
        ["label"] = "Sandy1",
        ["coords"] = vector3(2030.23, 3184.42, 45.13),
    },
    [47] = {
        ["label"] = "Sandy2",
        ["coords"] = vector3(2175.33, 3321.92, 46.13),
    },
    [48] = {
        ["label"] = "Sandy3",
        ["coords"] = vector3(2389.61, 3340.98, 47.34),
    },
    [49] = {
        ["label"] = "Sandy4",
        ["coords"] = vector3(1716.25, 3295.08, 41.26),
    },
    [50] = {
        ["label"] = "Sandy5",
        ["coords"] = vector3(1779.38, 3640.83, 34.5),
    },
    [51] = {
        ["label"] = "Sandy6",
        ["coords"] = vector3(1894.59, 3715.34, 32.75),
    },
    [52] = {
        ["label"] = "Sandy7",
        ["coords"] = vector3(1861.9, 3857.15, 36.27),
    },
    [53] = {
        ["label"] = "Sandy8",
        ["coords"] = vector3(996.38, 3575.07, 34.61),
    },
    [54] = {
        ["label"] = "Sandy9",
        ["coords"] = vector3(387.45, 3584.73, 33.29),
    },
    [55] = {
        ["label"] = "Stab1",
        ["coords"] = vector3(68.08, 3693.22, 40.66),
    },
    [56] = {
        ["label"] = "Stab2",
        ["coords"] = vector3(15.55, 3688.7, 39.81),
    },
    [57] = {
        ["label"] = "Sandy10",
        ["coords"] = vector3(2566.59, 4283.34, 41.97),
    },
    [58] = {
        ["label"] = "Grape1",
        ["coords"] = vector3(2570.82, 4667.95, 34.08),
    },
    [59] = {
        ["label"] = "Grape2",
        ["coords"] = vector3(2882.05, 4511.72, 48.02),
    },
    [60] = {
        ["label"] = "Grape3",
        ["coords"] = vector3(2243.78, 5154.02, 57.89),
    },
    [61] = {
        ["label"] = "Grape4",
        ["coords"] = vector3(1642.91, 4846.08, 45.51),
    },
    [62] = {
        ["label"] = "Grape5",
        ["coords"] = vector3(1308.87, 4362.17, 41.55),
    },
    [63] = {
        ["label"] = "Paleto1",
        ["coords"] = vector3(-1090.27, 4940.57, 214.13),
    },
    [64] = {
        ["label"] = "Paleto2",
        ["coords"] = vector3(-552.37, 5348.37, 74.76),
    },
    [65] = {
        ["label"] = "Paleto3",
        ["coords"] = vector3(-679.02, 5834.27, 17.33),
    },
    [66] = {
        ["label"] = "Paleto4",
        ["coords"] = vector3(-481.97, 6276.93, 13.35),
    },
    [67] = {
        ["label"] = "Paleto5",
        ["coords"] = vector3(-24.92, 6472.6, 31.49),
    },
    [68] = {
        ["label"] = "Paleto6",
        ["coords"] = vector3(36.03, 6549.18, 31.43),
    },
    [69] = {
        ["label"] = "Paleto6",
        ["coords"] = vector3(406.08, 6526.43, 27.75),
    },
    [70] = {
        ["label"] = "Paleto7",
        ["coords"] = vector3(1522.39, 6329.23, 24.61),
    },
    [71] = {
        ["label"] = "Paleto8",
        ["coords"] = vector3(1741.39, 6419.62, 35.04),
    },
    [72] = {
        ["label"] = "Lighthouse",
        ["coords"] = vector3(3426.72, 5174.42, 7.4),
    },
    [73] = {
        ["label"] = "EastSandy",
        ["coords"] = vector3(2525.99, 2586.62, 38.94),
    },
    [74] = {
        ["label"] = "Power Station",
        ["coords"] = vector3(2696.29, 1664.44, 24.52),
    },
    [75] = {
        ["label"] = "Stripclub",
        ["coords"] = vector3(106.24, -1280.32, 29.24),
    },
    [76] = {
        ["label"] = "Vinewood Video",
        ["coords"] = vector3(223.98, 121.53, 102.76),
    },
    [77] = {
        ["label"] = "Taxi",
        ["coords"] = vector3(882.67, -160.26, 77.11),
    },
    [78] = {
        ["label"] = "Resort",
        ["coords"] = vector3(-1245.63, 376.21, 75.34),
    },
    [79] = {
        ["label"] = "Bahama Mamas",
        ["coords"] = vector3(-1383.1, -639.99, 28.67),
    },
 }

