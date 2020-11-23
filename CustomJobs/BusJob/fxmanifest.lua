--Metadata
fx_version 'bodacious'
games {'gta5'}

author 'William'
description 'ESX Bus Baan'
version '1.0.0'

client_scripts { 
    '@es_extended/locale.lua',
    'config.lua',
    'locales/en.lua',
    'locales/tr.lua',
    'client/main.lua'
}


server_scripts {
    '@es_extended/locale.lua',
    'config.lua',
	'@mysql-async/lib/MySQL.lua',
    'locales/en.lua',
    'locales/tr.lua',
    'server/server.lua'
}