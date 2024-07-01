fx_version 'cerulean'

game "gta5"

author "Project Sloth & OK1ez"
version '2.1.7'

'

ui_page 'html/index.html'
-- ui_page 'http://localhost:5173/' --for dev

client_script {
  '@PolyZone/client.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/BoxZone.lua',
  'client/**',
}
server_script {
  "server/**",
}
shared_script {
  "shared/**",
  '@ox_lib/init.lua',
}

files {
  'html/**',
  'locales/*.json',
}

ox_lib 'locale' -- v3.8.0 or above

escrow_ignore {
  'shared/config.lua', 
  'README.md', 
  'locales/*.lua', 
  'client/alerts.lua',  
  'client/eventhanlders.lua', 
  'client/main.lua', 
  'client/utils.lua',
  'html/index.css',
  'html/index.html',
  'html/index.js',
  'locales/cs.json',
  'locales/de.json',
  'locales/en.json',
  'locales/es.json',
  'locales/fr.json',
  'locales/nl.json',
  'locales/pt-br.json',
  'locales/fr.json',
  'server/main.lua',
}

