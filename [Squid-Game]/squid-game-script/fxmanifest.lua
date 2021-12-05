fx_version 'cerulean'
games { 'gta5' }
author 'draobrehtom'

shared_scripts {
    "@qb-core/import.lua",
    "@es_extended/imports.lua",
    "@extendedmode/imports.lua",
    "@vrp/lib/utils.lua",


    "config.lua",
    "locale.lua",
    "locales/*.lua",
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',

    'client/framework.lua',
    'client/main.lua',
    'client/countdown.lua',
    'client/startPoint.lua',
    'client/drawSprite.lua',
    'client/skin.lua',
}

server_scripts {
    "server/framework.lua",
    "server/main.lua",
}

files {
    'ui/*.js',
    'ui/*.css',
    'ui/*.html',
    'ui/*.mp3',
}
ui_page 'ui/index.html'

dependencies {
    'PolyZone'
}