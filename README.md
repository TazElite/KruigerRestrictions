![KruigerRestrictions](assets/banner.png)

# KruigerRestrictions

A standalone FiveM resource providing configurable ACE-based restrictions for vehicles, weapons, player ped models, and clothing.

## v2.0.0

KruigerRestrictions v2 adds ACE-protected clothing restrictions for freemode male and female characters.

## Features

- Vehicle model restrictions
- Weapon restrictions
- Ped model restrictions
- Clothing component restrictions
- Clothing prop restrictions
- Separate male/female clothing configuration
- Restrict a specific texture or every texture for a drawable
- Standard FiveM ACE permissions
- Multiple allowed permissions per restricted item
- Custom denial messages
- Server-side ACE permission checks
- Independently enable/disable restriction modules
- No ESX or QBCore required
- No dependencies

A player only needs **one** permission listed on a restricted item.

## Installation

1. Place `KruigerRestrictions` in your server's resources folder.
2. Add `ensure KruigerRestrictions` to `server.cfg`.
3. Configure the files inside `config/`.
4. Add the required ACE permissions.
5. Restart the resource or server.

## ACE Examples

```cfg
add_ace group.leo kruiger.vehicle.leo allow
add_ace group.leo kruiger.weapon.leo allow
add_ace group.leo kruiger.ped.leo allow
add_ace group.leo kruiger.clothing.leo allow

add_ace group.swat kruiger.weapon.rifle allow
add_ace group.swat kruiger.ped.swat allow
add_ace group.swat kruiger.clothing.swat allow
```

## Clothing Restrictions

Configure clothing in `config/clothing.lua`.

Components and props are separated, with independent sections for `mp_m_freemode_01` and `mp_f_freemode_01`.

Example component:

```lua
{
    component = 9,
    drawable = 15,
    texture = -1,
    permissions = { 'kruiger.clothing.leo' },
    message = 'You are not authorized to use this vest.'
}
```

Example prop:

```lua
{
    prop = 0,
    drawable = 46,
    texture = -1,
    permissions = { 'kruiger.clothing.leo' }
}
```

Set `texture = -1` to restrict every texture for that drawable, or enter a texture ID to restrict only that variation.

Unauthorized restricted components are reset to their default component variation. Unauthorized restricted props are removed.

## Configuration Files

```text
config/config.lua
config/vehicles.lua
config/weapons.lua
config/peds.lua
config/clothing.lua
```

## License

Released under the MIT License.

Copyright (c) 2026 KruigerLabs

## 📚 Documentation

For complete installation, configuration, commands, permissions, usage, and troubleshooting, see the official Kruiger Labs documentation.

**📖 Full Documentation:**  
https://kruigerlabs.xyz/docs/free-scripts/kruigerrestrictions

**📚 Documentation Center:**  
https://kruigerlabs.xyz/docs/

**❓ FAQ:**  
https://kruigerlabs.xyz/docs/faq

> For the most up-to-date setup instructions, always refer to the Kruiger Labs Documentation Center.
