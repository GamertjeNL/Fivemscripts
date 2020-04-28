fx_version 'bodacious'

games {"gta5"}

author "William"
description "Discord bot run on fivem server"
version "1.0.0"

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'client/main.lua',
    'config.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'server/main.lua',
    'config.lua'
}