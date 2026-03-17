-- Base Client Script
-- Core client-side framework initialization

local PlayerID = -1
local PlayerData = {}
local FrameworkReady = false

RegisterNetEvent("framework:playerSpawned")
AddEventHandler("framework:playerSpawned", function()
    PlayerID = PlayerId()
    FrameworkReady = true
    Shared.Log("BaseClient", "INFO", "Player framework initialized")
    TriggerEvent("framework:clientReady")
end)

RegisterNetEvent("framework:notify")
AddEventHandler("framework:notify", function(data)
    -- Notification system
    local title = data.title or "Notification"
    local message = data.message or ""
    local type = data.type or "info"
    local duration = data.duration or 3000
    
    -- Send to UI
    SendNotification(title, message, type, duration)
end)

-- Get player ID
function GetPlayerID()
    return PlayerID
end

-- Get player data
function GetPlayerData()
    return PlayerData
end

-- Update player data
function UpdatePlayerData(key, value)
    PlayerData[key] = value
end

-- Send notification to UI
function SendNotification(title, message, type, duration)
    SendNUIMessage({
        action = "notify",
        title = title,
        message = message,
        type = type,
        duration = duration
    })
end

-- Open menu (general purpose)
function OpenMenu(menuName, data)
    SendNUIMessage({
        action = "openMenu",
        menu = menuName,
        data = data or {}
    })
    SetNuiFocus(true, true)
end

-- Close menu
function CloseMenu()
    SendNUIMessage({
        action = "closeMenu"
    })
    SetNuiFocus(false, false)
end

-- NUI Callback
RegisterNuiCallbackType("menuCallback")
RegisterNuiCallback("menuCallback", function(data, cb)
    if data.action == "closeMenu" then
        CloseMenu()
    end
    cb("ok")
end)

-- Main thread
Citizen.CreateThread(function()
    while not FrameworkReady do
        Wait(100)
    end
    
    Shared.Log("BaseClient", "INFO", "Base client loaded and ready")
    
    -- Main update loop
    while true do
        Wait(0)
        
        -- Update player position for server
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        PlayerData.coords = coords
        PlayerData.heading = GetEntityHeading(playerPed)
    end
end)
