-- Base Server Script
-- Core server-side framework initialization

local Players = {}
local FrameworkReady = false

-- Initialize Framework
function InitializeFramework()
    Shared.Log("BaseServer", "INFO", "Initializing FiveM Framework...")
    
    -- Initialize database connection
    if Config.Server.Database then
        Shared.Log("BaseServer", "INFO", "Connecting to database...")
        -- Database initialization logic here
    end
    
    FrameworkReady = true
    Shared.Log("BaseServer", "INFO", "Framework initialized successfully!")
    TriggerEvent("framework:serverReady")
end

-- Player joined event
AddEventHandler("playerConnecting", function(name, setReason, deferrals)
    deferrals.defer()
    
    local playerId = source
    Shared.Log("BaseServer", "INFO", "Player " .. name .. " (" .. playerId .. ") connecting...")
    
    deferreds.update("Checking player data...")
    
    Wait(500) -- Simulate data loading
    
    Shared.Log("BaseServer", "INFO", "Player " .. name .. " loaded successfully")
    deferrals.done()
end)

-- Player spawned
AddEventHandler("playerSpawned", function()
    local playerId = source
    Shared.Log("BaseServer", "INFO", "Player " .. playerId .. " spawned")
    
    Players[playerId] = {
        id = playerId,
        name = GetPlayerName(playerId),
        joinedAt = os.time()
    }
    
    TriggerClientEvent("framework:playerSpawned", playerId)
end)

-- Player dropped
AddEventHandler("playerDropped", function()
    local playerId = source
    Shared.Log("BaseServer", "INFO", "Player " .. playerId .. " dropped")
    
    Players[playerId] = nil
    TriggerEvent("framework:playerDropped", playerId)
end)

-- Get player data
function GetPlayerData(playerId)
    return Players[playerId]
end

-- Update player data
function UpdatePlayerData(playerId, data)
    if Players[playerId] then
        Players[playerId] = Shared.TableMerge(Players[playerId], data)
    end
end

-- Get all players
function GetAllPlayers()
    return Players
end

-- Server ready check
exports("isFrameworkReady", function()
    return FrameworkReady
end)

-- Commands
RegisterCommand("status", function(source, args, rawCommand)
    local players = GetAllPlayers()
    TriggerClientEvent("framework:notify", source, {
        title = "Server Status",
        message = "Players online: " .. #players,
        type = "info"
    })
    Shared.Log("BaseServer", "INFO", "Status requested by player " .. source)
end, false)

-- Initialize on server start
TriggerEvent("onServerResourceStart", GetCurrentResourceName())
InitializeFramework()

Citizen.CreateThread(function()
    Wait(0)
    Shared.Log("BaseServer", "INFO", "Base resource loaded")
end)
