fx_version 'cerulean'
game 'gta5'

author 'KruigerLabs'
name 'KruigerRestrictions'
description 'Standalone ACE-based vehicle, weapon, and ped restrictions for FiveM.'
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
