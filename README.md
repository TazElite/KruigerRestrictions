# KruigerRestrictions

A standalone FiveM resource that provides ACE-based restrictions for vehicles, weapons, and player ped models.

## Features

- Vehicle model restrictions
- Weapon restrictions
- Ped model restrictions
- Standard FiveM ACE permissions
- Multiple allowed permissions per restricted item
- Custom denial messages
- Configurable vehicle ejection/deletion
- Configurable weapon removal
- Configurable fallback ped
- Server-side ACE permission checks
- No ESX or QBCore required
- No dependencies

A player only needs **one** of the permissions listed for a restricted item.

## Installation

1. Place `KruigerRestrictions` in your server's resources folder.
2. Add this to `server.cfg`:

```cfg
ensure KruigerRestrictions
```

3. Configure the restriction files in `config/`.
4. Grant the required ACE permissions.
5. Restart the resource/server.

## ACE Examples

```cfg
add_ace group.leo kruiger.vehicle.leo allow
add_ace group.leo kruiger.weapon.leo allow
add_ace group.leo kruiger.ped.leo allow

add_ace group.swat kruiger.weapon.rifle allow
add_ace group.swat kruiger.ped.swat allow

add_ace group.admin kruiger.vehicle.admin allow
add_ace group.admin kruiger.ped.admin allow
```

Any permission system that grants standard FiveM ACE permissions can be used.

## Vehicle Restrictions

Edit `config/vehicles.lua`:

```lua
[`police`] = {
    permissions = { 'kruiger.vehicle.leo' },
    message = 'This vehicle is restricted to authorized law enforcement.'
}
```

## Weapon Restrictions

Edit `config/weapons.lua`:

```lua
[`WEAPON_CARBINERIFLE`] = {
    permissions = { 'kruiger.weapon.rifle', 'kruiger.weapon.leo' },
    message = 'You are not authorized to use this rifle.'
}
```

## Ped Restrictions

Edit `config/peds.lua`:

```lua
[`s_m_y_cop_01`] = {
    permissions = { 'kruiger.ped.leo' },
    message = 'This ped is restricted to authorized law enforcement.'
}
```

## Configuration

The main settings are in `config/config.lua`.

You can enable/disable each restriction module independently and configure what happens when a player attempts to use a restricted vehicle, weapon, or ped.

## License

Released under the MIT License.

Copyright (c) 2026 KruigerLabs
