resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Chatarrero'

version '1.0'

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua',
	'versioncheck.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua',
}


dependency {
	'es_extended',
	'pNotify',
	'progressBars'
}
