local pending = {}
local requestId = 0
local permissionCache = {}
local lastVehicle = 0
local lastWeapon = 0
local lastPedModel = 0

local function notify(message)
    TriggerEvent('chat:addMessage', {
        color = { 220, 60, 60 },
        args = { 'KruigerRestrictions', message }
    })
end

RegisterNetEvent('kruiger:restrictions:result', function(id, allowed)
    if pending[id] then
        pending[id](allowed == true)
        pending[id] = nil
    end
end)

local function permissionKey(permissions)
    local copy = {}
    for i = 1, #permissions do
        copy[i] = tostring(permissions[i])
    end
    table.sort(copy)
    return table.concat(copy, '|')
end

local function checkPermissions(permissions, callback)
    if type(permissions) ~= 'table' or #permissions == 0 then
        callback(false)
        return
    end

    local key = permissionKey(permissions)
    local cached = permissionCache[key]
    local now = GetGameTimer()

    if cached and now - cached.time < Config.PermissionCacheMs then
        callback(cached.allowed)
        return
    end

    requestId = requestId + 1
    if requestId > 1000000 then requestId = 1 end

    local id = requestId
    pending[id] = function(allowed)
        permissionCache[key] = {
            allowed = allowed,
            time = GetGameTimer()
        }
        callback(allowed)
    end

    TriggerServerEvent('kruiger:restrictions:check', id, permissions)

    SetTimeout(5000, function()
        if pending[id] then
            pending[id] = nil
            callback(false)
        end
    end)
end

local function handleVehicle(ped)
    if not Config.VehicleRestrictions then return end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= ped then
        lastVehicle = 0
        return
    end

    if vehicle == lastVehicle then return end
    lastVehicle = vehicle

    local entry = RestrictedVehicles[GetEntityModel(vehicle)]
    if not entry then return end

    checkPermissions(entry.permissions, function(allowed)
        if allowed or not DoesEntityExist(vehicle) then return end

        notify(entry.message or Config.Vehicle.Message)

        if Config.Vehicle.DeleteOnRestrict then
            NetworkRequestControlOfEntity(vehicle)
            local timeout = GetGameTimer() + 1000
            while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() < timeout do
                Wait(0)
                NetworkRequestControlOfEntity(vehicle)
            end

            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
        else
            TaskLeaveVehicle(ped, vehicle, 16)
        end
    end)
end

local function handleWeapon(ped)
    if not Config.WeaponRestrictions then return end

    local weapon = GetSelectedPedWeapon(ped)
    if weapon == lastWeapon then return end
    lastWeapon = weapon

    local entry = RestrictedWeapons[weapon]
    if not entry then return end

    checkPermissions(entry.permissions, function(allowed)
        if allowed then return end

        notify(entry.message or Config.Weapon.Message)

        if Config.Weapon.RemoveOnRestrict then
            RemoveWeaponFromPed(ped, weapon)
        else
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        end
    end)
end

local function loadModel(model)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        return false
    end

    RequestModel(model)
    local timeout = GetGameTimer() + 5000

    while not HasModelLoaded(model) and GetGameTimer() < timeout do
        Wait(0)
    end

    return HasModelLoaded(model)
end

local function handlePed(ped)
    if not Config.PedRestrictions then return end

    local model = GetEntityModel(ped)
    if model == lastPedModel then return end
    lastPedModel = model

    local entry = RestrictedPeds[model]
    if not entry then return end

    checkPermissions(entry.permissions, function(allowed)
        if allowed then return end

        notify(entry.message or Config.Ped.Message)

        local fallback = joaat(Config.Ped.FallbackModel)
        if loadModel(fallback) then
            SetPlayerModel(PlayerId(), fallback)
            SetModelAsNoLongerNeeded(fallback)
            lastPedModel = fallback
        end
    end)
end

local clothingState = {}
local clothingBusy = {}

local function clothingGroup(ped)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then return RestrictedClothing.male end
    if model == `mp_f_freemode_01` then return RestrictedClothing.female end
    return nil
end

local function matchesTexture(required, actual)
    return required == nil or required == -1 or required == actual
end

local function handleClothing(ped)
    if not Config.ClothingRestrictions then return end

    local group = clothingGroup(ped)
    if not group then return end

    for index, entry in ipairs(group.components or {}) do
        local drawable = GetPedDrawableVariation(ped, entry.component)
        local texture = GetPedTextureVariation(ped, entry.component)
        local key = ('component:%s:%s'):format(entry.component, index)
        local matched = drawable == entry.drawable and matchesTexture(entry.texture, texture)

        if matched and clothingState[key] ~= (('%s:%s'):format(drawable, texture)) and not clothingBusy[key] then
            clothingBusy[key] = true
            checkPermissions(entry.permissions, function(allowed)
                clothingBusy[key] = nil
                if allowed then
                    clothingState[key] = ('%s:%s'):format(drawable, texture)
                    return
                end

                notify(entry.message or Config.Clothing.Message)
                -- Reset only the restricted component to the freemode default.
                SetPedComponentVariation(ped, entry.component, 0, 0, 0)
                clothingState[key] = nil
            end)
        elseif not matched then
            clothingState[key] = nil
        end
    end

    for index, entry in ipairs(group.props or {}) do
        local drawable = GetPedPropIndex(ped, entry.prop)
        local texture = GetPedPropTextureIndex(ped, entry.prop)
        local key = ('prop:%s:%s'):format(entry.prop, index)
        local matched = drawable == entry.drawable and matchesTexture(entry.texture, texture)

        if matched and clothingState[key] ~= (('%s:%s'):format(drawable, texture)) and not clothingBusy[key] then
            clothingBusy[key] = true
            checkPermissions(entry.permissions, function(allowed)
                clothingBusy[key] = nil
                if allowed then
                    clothingState[key] = ('%s:%s'):format(drawable, texture)
                    return
                end

                notify(entry.message or Config.Clothing.Message)
                ClearPedProp(ped, entry.prop)
                clothingState[key] = nil
            end)
        elseif not matched then
            clothingState[key] = nil
        end
    end
end

CreateThread(function()
    local lastClothingCheck = 0

    while true do
        local ped = PlayerPedId()

        handleVehicle(ped)
        handleWeapon(ped)
        handlePed(ped)

        local now = GetGameTimer()
        if now - lastClothingCheck >= (Config.Clothing.CheckInterval or 1000) then
            handleClothing(ped)
            lastClothingCheck = now
        end

        Wait(Config.CheckInterval)
    end
end)
