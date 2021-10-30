-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local currentZone = nil
local PlayerData = {}

-- Handlers

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Static Header

local musicHeader = {
    {
        header = 'Play some music!',
        params = {
            event = 'qb-djbooth:client:playMusic'
        }
    }
}

-- Main Menu

local musicMenu = {
    {
        isHeader = true,
        header = '💿 | DJ Booth'
    },
    {
        header = '🎶 | Play a song',
        txt = 'Enter a youtube URL',
        params = {
            event = 'qb-djbooth:client:musicMenu',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '⏸️ | Pause Music',
        txt = 'Pause currently playing music',
        params = {
            isServer = true,
            event = 'qb-djbooth:server:pauseMusic',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '▶️ | Resume Music',
        txt = 'Resume playing paused music',
        params = {
            isServer = true,
            event = 'qb-djbooth:server:resumeMusic',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '🔈 | Change Volume',
        txt = 'Resume playing paused music',
        params = {
            event = 'qb-djbooth:client:changeVolume',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '❌ | Turn off music',
        txt = 'Stop the music & choose a new song',
        isServer = true,
        params = {
            isServer = true,
            event = 'qb-djbooth:server:stopMusic',
            args = {
                currentZone = currentZone
            }
        }
    }
}

-- DJ Booths

local vanilla = BoxZone:Create(Config.Locations['vanilla'].coords, 1, 1, {
    name="vanilla",
    heading=0
})

vanilla:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['vanilla'].job then
        currentZone = 'vanilla'
        exports['qb-menu']:showHeader(musicHeader)
    else
        currentZone = nil
        exports['qb-menu']:closeMenu()
    end
end)

local other = BoxZone:Create(Config.Locations['other'].coords, 1, 1, {
    name="other",
    heading=0
})

other:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['other'].job then
        currentZone = 'other'
        exports['qb-menu']:showHeader(musicHeader)
    else
        currentZone = nil
        exports['qb-menu']:closeMenu()
    end
end)

-- Events

RegisterNetEvent('qb-djbooth:client:playMusic', function()
    exports['qb-menu']:openMenu(musicMenu)
end)

RegisterNetEvent('qb-djbooth:client:musicMenu', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Song Selection',
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'song',
                text = 'YouTube URL'
            },
            {
                type = 'number', -- Give the client an option to set volume when starting music instead of ear raping them.
                isRequired = true,
                name = 'volume',
                text = 'Min: 1[Off] - Max: 100[Max]'
            }
        }
    })
    if dialog then
        if not dialog.song then return end
        TriggerServerEvent('qb-djbooth:server:playMusic', dialog.song, currentZone)
        SetTimeout(550, function() -- delayed pass to update volume after song start to ensure no errors.
            if not dialog.volume then return end
            TriggerServerEvent('dc-djbooth:server:changeVolume', dialog.volume, currentZone)
        end)
    end
end)

RegisterNetEvent('qb-djbooth:client:changeVolume', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Music Volume',
        submitText = "Submit",
        inputs = {
            {
                type = 'number', 
                isRequired = true,
                name = 'volume',
                text = 'Min: 1[Off] - Max: 100[Max]'
            }
        }
    })
    if dialog then
        if not dialog.volume then return end
        TriggerServerEvent('qb-djbooth:server:changeVolume', dialog.volume, currentZone)
    end
end)
