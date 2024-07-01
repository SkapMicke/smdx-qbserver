fx_version 'cerulean'
game 'gta5'
lua54 'yes'
shared_script {
	'config.lua',
	--'@qb-ambulancejob/config.lua'
}
client_script 'c.lua'
server_script 's.lua'
ui_page 'html/index.html'
files {
	'html/index.html',
	'html/style.css',
	'html/index.js',
    'html/files/*.png',
    'html/files/*.jpg',
	'html/fonts/*.otf',
	'html/fonts/*.ttf'
}



exports {
    'OpenDeathScreen',
    'RevivePlayer',
    'UpdateRespawnTimer'
}