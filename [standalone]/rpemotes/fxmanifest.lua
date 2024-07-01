--- Maintained by TayMcKenzieNZ ---
--- Check for updates at https://github.com/TayMcKenzieNZ/rpemotes ---

fx_version 'cerulean'
game 'gta5'
version '1.1.7'
'

dependencies {
    '/server:5848',
    '/onesync',
}

-- Remove the following lines if you would like to use the SQL keybinds. Requires oxmysql.

--#region oxmysql

-- dependency 'oxmysql'
-- server_script '@oxmysql/lib/MySQL.lua'

--#endregion oxmysql

shared_scripts {
    'config.lua',
    'Translations.lua'
}

server_scripts {
    'printer.lua',
    'server/Server.lua',
    'server/Updates.lua',
    'server/frameworks/*.lua'
}

client_scripts {
    'NativeUI.lua',
    'client/AnimationList.lua',
    'client/AnimationListCustom.lua',
    'client/Crouch.lua',
    'client/Emote.lua',
    'client/EmoteMenu.lua',
    'client/Expressions.lua',
    'client/Keybinds.lua',
    'client/Pointing.lua',
    'client/Ragdoll.lua',
    'client/Syncing.lua',
    'client/Walk.lua',
    'client/frameworks/*.lua'
}


---- Loads all ytyp files for custom props to stream ---

data_file 'DLC_ITYP_REQUEST' 'stream/taymckenzienz_rpemotes.ytyp'

data_file 'DLC_ITYP_REQUEST' 'badge1.ytyp'

data_file 'DLC_ITYP_REQUEST' 'copbadge.ytyp'

data_file 'DLC_ITYP_REQUEST' 'bzzz_foodpack'

data_file 'DLC_ITYP_REQUEST' 'bzzz_prop_torch_fire001.ytyp'

data_file 'DLC_ITYP_REQUEST' 'natty_props_lollipops.ytyp'

data_file 'DLC_ITYP_REQUEST' 'apple_1.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_food_icecream_pack.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_food_dessert_a.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_give_gift.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/ultra_ringcase.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_food_xmas22.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/knjgh_pizzas.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/pata_christmasfood.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/pata_cake.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/pata_freevalentinesday.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_cake_love_001.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_cake_birthday_001.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_cake_baby_001.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_cake_casino001.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/brum_heart.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/brum_heartfrappe.ytyp'

data_file 'DLC_ITYP_REQUEST' 'stream/kaykaymods_props.ytyp'
