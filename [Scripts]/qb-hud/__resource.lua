resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"


shared_scripts {
	-- '@pepe-core/import.lua',
	'config.lua'
}

client_scripts {
	"client/*.lua",
}

server_script 'server/server.lua'

ui_page {
	'html/ui.html',	
}

files {
	'html/*.png',
	'html/*.svg',
	'html/*.html',
	'html/ui.html',
	"html/img/*.svg",
	'html/css/*.css',
	'html/css/pricedown_bl-webfont.ttf',
	'html/css/pricedown_bl-webfont.woff',
	'html/css/pricedown_bl-webfont.woff2',
	'html/css/gta-ui.ttf',
	'html/js/*.js',
	'html/css/pdown.ttf',
	'html/css/Pricedown.ttf',
	'html/css/*.css',
	'html/css/*.ttf',
	'html/css/*.woff',
	'html/css/*.woff2',
}