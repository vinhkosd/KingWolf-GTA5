-- UI
ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/imgs/dice.png",
	"ui/imgs/img.png",
	'ui/imgs/roll1.gif',
	'io/socket.io.js'
}

dependency 'yarn'
--server_only 'yes'
server_script 'index.js'