fx_version 'adamant'
games {'gta5'}

author 'william#9596'
version '1.2'
description 'FiveM Ingame Console'


client_scripts {
    'client.lua'
}
server_scripts {
    'server.lua'
}

ui_page "public/index.html"
files {
    'public/*',
    'public/static/js/*',
    'public/static/css/*'
}