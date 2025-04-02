fx_version 'cerulean'
game 'gta5'
version '1.0.0'

author 'Lims'
description 'This is a vehicle rental script using NUI'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/img/default.png',
}
client_scripts {
    'client/client.lua',
    'config.lua'
}

server_scripts {
    'server/server.lua'
}