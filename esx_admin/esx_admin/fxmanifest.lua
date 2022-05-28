fx_version 'adamant'
game 'gta5'
description 'Zokus ESX Admin'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
	'client/client.lua',
	'client/events.lua'
}

server_scripts {
	'server/commands.lua'
}

dependency "es_extended"