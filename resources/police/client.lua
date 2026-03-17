-- Police System Client
-- Client-side police features

local WantedLevel = 0
local IsWanted = false
local RadarActive = true

RegisterNetEvent("police:setWanted")
AddEventHandler("police:setWanted", function(level)
    WantedLevel = level
    IsWanted = level > 0
    
    if level > 0 then
        SetPlayerWantedLevel(PlayerPedId(), level)
        SendNotification("Wanted", "Wanted level: " .. level, "error", 3000)
    else
        SetPlayerWantedLevel(PlayerPedId(), 0)
        SendNotification("Wanted Level Removed", "You are no longer wanted", "success", 3000)
    end
end)

RegisterNetEvent("police:arrestPlayer")
AddEventHandler("police:arrestPlayer", function(jailData)
    local playerPed = PlayerPedId()
    
    -- Freeze player
    FreezeEntityPosition(playerPed, true)
    
    -- Teleport to jail
    SetEntityCoords(playerPed, jailData.x, jailData.y, jailData.z)
    
    SendNotification("Arrested", "You have been arrested!", "error", 3000)
    
    -- Release after jail time
    SetTimeout(jailData.jailTime * 1000, function()
        FreezeEntityPosition(playerPed, false)
        SendNotification("Released", "You have been released from jail", "success", 3000)
        
        -- Teleport out
        SetEntityCoords(playerPed, 425.0, -979.0, 29.0)
    end)
end)

-- Get wanted level
function GetWantedLevel()
    return WantedLevel
end

-- Get wanted status
function IsPlayerWanted()
    return IsWanted
end

-- Police radar toggle
RegisterCommand("radar", function(source, args, rawCommand)
    RadarActive = not RadarActive
    DisplayRadar(RadarActive)
    SendNotification("Radar", RadarActive and "On" or "Off", "info", 2000)
end, false)

-- Police scanning
RegisterCommand("scan", function(source, args, rawCommand)
    if args[1] then
        local playerId = tonumber(args[1])
        local src = GetPlayerFromServerId(playerId)
        if src then
            TriggerServerEvent("police:scan", playerId)
        end
    end
end, false)

RegisterNetEvent("police:scanResult")
AddEventHandler("police:scanResult", function(playerData)
    SendNotification("Scan Result", 
        "Name: " .. playerData.name ..
        "\nWanted: " .. (playerData.wanted and "Yes" or "No") ..
        "\nCriminal Record: " .. playerData.record,
        "info", 5000)
end)

-- Check wanted players nearby
Citizen.CreateThread(function()
    while true do
        Wait(5000)
        
        local playerPed = PlayerPedId()
        -- Job check will be handled via events
        
        -- Check if player is police
    end
end)
