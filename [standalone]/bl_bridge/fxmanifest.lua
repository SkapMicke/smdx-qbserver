fx_version "cerulean"
use_experimental_fxv2_oal 'yes'

game 'gta5'
lua54 'yes'
version '1.2.4'

dependencies {
  '/onesync',
}

shared_scripts {
  'require.lua',
  'init.lua',
}

files {
  'utils.lua',
  'client/**/*.lua',
  'imports/client.lua',
}