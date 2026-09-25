fx_version 'cerulean'
game 'gta5'

author 'Kruiger Labs LLC'
name 'KruigerRestrictions'
description 'Free standalone FiveM restrictions script for vehicles, weapons, peds, and clothing using ACE permissions.'
version '2.0.0'

shared_scripts {
    'config/config.lua',
    'config/vehicles.lua',
    'config/weapons.lua',
    'config/peds.lua',
    'config/clothing.lua'
}

client_script 'client.lua'
server_script 'server.lua'
