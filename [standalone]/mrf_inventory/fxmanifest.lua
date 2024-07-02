fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Inventory for QBCore V1.2.5 or Below'
version '1.9.9'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/functions.lua',
    'server/weapons.lua',
    'server/main.lua',
    'server/commands.lua'
}

client_scripts {
	'client/functions.lua',
	'client/nui.lua',
    'client/weapons.lua',
	'client/main.lua',
    'client/binds.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
	'html/images/*.png',
	'html/ammo_images/*.png',
    'html/attachment_images/*.png',
	'html/sounds/*.mp3',
	'weaponsnspistol.meta'
}

data_file 'WEAPONINFO_FILE_PATCH' 'weaponsnspistol.meta'