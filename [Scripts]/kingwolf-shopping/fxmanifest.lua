fx_version 'adamant'

game 'gta5'

author 'vinhcacdai'
description 'KingWolf Shopping System'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/css/*.*',
	'web/js/*.*',
}

shared_script 'config.lua'

client_scripts {
	'alerts.lua',
	'client.lua',
}

server_scripts {
	-- '@mysql-async/lib/MySQL.lua',
	'server.lua'
}