fx_version 'adamant'

game 'gta5'

author 'SkapMicke'
description 'Notification script for QBCore'
version '1.1'


ui_page 'html/ui.html'

export {
	'sm_alert',
	'AdvancedAlert',
	'sm_SendNotify',
	'sm_advanced'
}

client_scripts {
	'client.lua',
}

files {
	'html/*.*'
}