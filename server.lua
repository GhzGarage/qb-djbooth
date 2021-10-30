local xSound = exports.xsound
local isPlaying = false

RegisterNetEvent('qb-djbooth:server:playMusic', function(song, zoneName)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local boothCoords = Config.Locations[zoneName].coords
    local dist = #(coords - boothCoords)
    if dist > 3 then return end
    xSound:PlayUrlPos(-1, zoneName, song, Config.DefaultVolume, coords)
    xSound:Distance(-1, zoneName, Config.Locations[zoneName].radius)
    isPlaying = true
end)

RegisterNetEvent('qb-djbooth:server:stopMusic', function(zoneName)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local boothCoords = Config.Locations[zoneName].coords
    local dist = #(coords - boothCoords)
    if dist > 3 then return end
    if isPlaying then
        isPlaying = false
        xSound:Destroy(-1, zoneName)
    end
    TriggerClientEvent('qb-djbooth:client:playMusic', src)
end)

RegisterNetEvent('qb-djbooth:server:pauseMusic', function(zoneName)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local boothCoords = Config.Locations[zoneName].coords
    local dist = #(coords - boothCoords)
    if dist > 3 then return end
    if isPlaying then
        isPlaying = false
        xSound:Pause(-1, zoneName)
    end
end)

RegisterNetEvent('qb-djbooth:server:resumeMusic', function(zoneName)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local boothCoords = Config.Locations[zoneName].coords
    local dist = #(coords - boothCoords)
    if dist > 3 then return end
    if not isPlaying then
        isPlaying = true
        xSound:Resume(-1, zoneName)
    end
end)

RegisterNetEvent('qb-djbooth:server:changeVolume', function(volume, zoneName)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local boothCoords = Config.Locations[zoneName].coords
    local volumesend = volume / 100
    local dist = #(coords - boothCoords)
    if dist > 3 then return end
    if not tonumber(volume) then return end
    if isPlaying then
        xSound:setVolume(-1, zoneName, volumesend)
    end
end)
