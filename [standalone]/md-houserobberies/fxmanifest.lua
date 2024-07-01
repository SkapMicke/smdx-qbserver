name "md-houserobberies v2"
author "Mustache Dom"
description "Steal Things From Houses"
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '2.5.0'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    '@ox_lib/init.lua',
   
}

client_script {
   'client/**.lua',
}
server_script {
'server/**.lua'
}


