Config = {}

Config.CheckInterval = 500
Config.PermissionCacheMs = 3000

Config.VehicleRestrictions = true
Config.WeaponRestrictions = true
Config.PedRestrictions = true

Config.Vehicle = {
    DeleteOnRestrict = false,
    Message = 'You are not authorized to use this vehicle.'
}

Config.Weapon = {
    RemoveOnRestrict = true,
    Message = 'You are not authorized to use this weapon.'
}

Config.Ped = {
    -- The player is changed back to this model when using a restricted ped.
    FallbackModel = 'mp_m_freemode_01',
    Message = 'You are not authorized to use this ped.'
}
