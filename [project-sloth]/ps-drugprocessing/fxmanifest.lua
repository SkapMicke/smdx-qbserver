fx_version 'cerulean'

games { 'gta5' }

'

description 'QB Drug Trafficing by Project Sloth'

version '1.4.0'

shared_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
	'@qb-core/shared/locale.lua',
	'config.lua',
	'locales/en.lua'
}

server_scripts {
	'server/coke.lua',
	'server/lsd.lua',
	'server/meth.lua',
	'server/weed.lua',
	'server/heroin.lua',
	'server/chemicals.lua',
	'server/lisenceshop.lua',
	'server/moneywash.lua',
	'server/versioncheck.lua'
}

client_scripts {
	'client/weed.lua',
	'client/meth.lua',
	'client/coke.lua',
	'client/lsd.lua',
	'client/heroin.lua',
	'client/chemicals.lua',
	'client/hydrochloricacid.lua',
	'client/sodiumhydroxide.lua',
	'client/sulfuricacid.lua',
	'client/target.lua',
}

files {
	'stream/mw_props.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/mw_props.ytyp'

escrow_ignore {
	'config.lua',
	'client/chemicals.lua',
	'cöient/coke.lua',
	'client/heroin.lua',
	'client/hydrochloricacid.lua',
	'client/lsd.lua',
	'client/meth.lua',
	'client/sodiumhydroxide.lua',
	'client/sulfuricacid.lua',
	'client/target.lua',
	'client/weed.lua',
	'server/versioncheck.lua',
	'server/chemicals.lua',
	'server/coke.lua',
	'server/heroin.lua',
	'server/hydrochloricacid.lua',
	'server/lsd.lua',
	'server/meth.lua',
	'server/sodiumhydroxide.lua',
	'server/sulfuricacid.lua',
	'server/target.lua',
	'server/weed.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/es.lua',
	'locales/fr.lua',
	'locales/nl.lua',
	'locales/pl.lua',
	'locales/tr.lua',
}
