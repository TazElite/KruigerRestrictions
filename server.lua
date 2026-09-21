local function hasAnyPermission(source, permissions)
    if type(permissions) ~= 'table' or #permissions == 0 then
        return false
    end

    for _, permission in ipairs(permissions) do
        if type(permission) == 'string' and IsPlayerAceAllowed(tostring(source), permission) then
            return true
        end
    end

    return false
end

RegisterNetEvent('kruiger:restrictions:check', function(requestId, permissions)
    local source = source

    if type(requestId) ~= 'number' or type(permissions) ~= 'table' then
        return
    end

    -- Keep the request intentionally small.
    if #permissions > 20 then
        TriggerClientEvent('kruiger:restrictions:result', source, requestId, false)
        return
    end

    TriggerClientEvent(
        'kruiger:restrictions:result',
        source,
        requestId,
        hasAnyPermission(source, permissions)
    )
end)

print('[KruigerRestrictions] Loaded ACE-based vehicle, weapon, and ped restrictions.')
