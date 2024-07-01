fx_version 'cerulean'

game "gta5"

author "Project Sloth & OK1ez"
version '1.1.6'
description 'Admin Menu'
repository 'https://github.com/Project-Sloth/ps-adminmenu'

'

ui_page 'html/index.html'
-- ui_page 'http://localhost:5173/' --for dev

client_script {
  'client/**',
}

server_script {
  "server/**",
  "@oxmysql/lib/MySQL.lua",
}

escrow_ignore {
  'config.lua', 
  'README.md', 
  'locales/*.lua', 
  'client/main.lua',  
  'client/chat.lua', 
  'client/data.lua', 
  'client/inventory.lua', 
  'client/misc.lua', 
  'client/noclip.lua', 
  'client/players.lua', 
  'client/spectate.lua', 
  'client/teleport.lua', 
  'client/toggle_laser.lua', 
  'client/troll.lua', 
  'client/utils.lua', 
  'client/vehicles.lua', 
  'client/world.lua', 
  'server/main.lua',  
  'server/chat.lua', 
  'server/data.lua', 
  'server/inventory.lua', 
  'server/misc.lua', 
  'server/noclip.lua', 
  'server/players.lua', 
  'server/spectate.lua', 
  'server/teleport.lua', 
  'server/toggle_laser.lua', 
  'server/troll.lua', 
  'server/utils.lua', 
  'server/vehicles.lua', 
  'server/world.lua',
  'data/object.lua',
  'data/ped.lua',
  'html/index.css',
  'html/index.html',
  'index.js',
  'locales/de.json',
  'locales/en.json',
  'locales/es.json',
  'locales/fr.json',
  'locales/id.json',
  'locales/it.json', 
  'locales/nl.json',
  'locales/it.json',
  'locales/nl.json',
  'locales/no.json', 
  'locales/pt-br.json', 
  'locales/tr.json'
}

shared_script {
  '@ox_lib/init.lua',
  "shared/**",
}

files {
  'html/**',
  'data/ped.lua',
  'data/object.lua',
  'locales/*.json',
}

ox_lib 'locale' -- v3.8.0 or above