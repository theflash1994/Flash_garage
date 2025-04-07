fx_version 'cerulean'
game 'gta5'

lua54 'yes' 

author 'Flash'
description 'Garage System with NUI'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',  
    'config.lua'
}

client_scripts {
    'client/garage.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/garage.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/ui.html',
    'html/img/*.jpg',
    'html/img/*.png',
    'html/fonts/*.ttf'
}