-- Police System Server
-- Manages police features, warrants, arrests

local ActiveWarrants = {}
local Arrests = {}
local Wanted = {}

-- Issue warrant
function IssueWarrant(targetPlayer, reason, level)
    local warrant = {
        id = "warrant_" .. os.time(),
        targetPlayer = targetPlayer,
        issuedBy = tonumber(targetPlayer),
        reason = reason,
        level = level or 1,
        issuedAt = os.date("%Y-%m-%d %H:%M:%S"),
        active = true
    }
    
    ActiveWarrants[warrant.id] = warrant
    Wanted[targetPlayer] = level or 1
    
    TriggerClientEvent("framework:notify", targetPlayer, {
        title = "Warrant Issued",
        message = "Reason: " .. reason,
        type = "error"
    })
    
    Shared.Log("PoliceServer", "INFO", "Warrant issued for player " .. targetPlayer)
    return warrant
end

-- Arrest player
function ArrestPlayer(targetPlayer, officer, charges)
    local arrest = {
        id = "arrest_" .. os.time(),
        targetPlayer = targetPlayer,
        officer = officer,
        charges = charges or "Unknown",
        bail = 1000,
        arrestTime = os.date("%Y-%m-%d %H:%M:%S"),
        jailTime = 60 -- in seconds
    }
    
    Arrests[arrest.id] = arrest
    Wanted[targetPlayer] = nil
    
    -- Teleport to jail
    TriggerClientEvent("police:arrestPlayer", targetPlayer, {
        x = 242.0,
        y = -952.0,
        z = 24.0,
        jailTime = arrest.jailTime
    })
    
    TriggerClientEvent("framework:notify", officer, {
        title = "Arrest",
        message = "Player arrested for: " .. charges,
        type = "success"
    })
    
    Shared.Log("PoliceServer", "INFO", "Player " .. targetPlayer .. " arrested by " .. officer)
    return arrest
end

-- Remove warrant
function RemoveWarrant(targetPlayer)
    for warrantId, warrant in pairs(ActiveWarrants) do
        if warrant.targetPlayer == targetPlayer then
            warrant.active = false
        end
    end
    Wanted[targetPlayer] = nil
end

-- Is wanted
function IsPlayerWanted(playerId)
    return Wanted[playerId] or false
end

-- Get wanted level
function GetWantedLevel(playerId)
    return Wanted[playerId] or 0
end

-- Set wanted level
function SetWantedLevel(playerId, level)
    if level > 0 then
        Wanted[playerId] = level
    else
        Wanted[playerId] = nil
    end
    
    TriggerClientEvent("police:setWanted", playerId, level)
end

-- Commands
RegisterCommand("arrest", function(source, args, rawCommand)
    if args[1] and args[2] then
        local targetId = tonumber(args[1])
        local charges = args[2]
        
        local playerJob = GetPlayerJob(source)
        if playerJob and playerJob.name == "police" then
            ArrestPlayer(targetId, source, charges)
        else
            TriggerClientEvent("framework:notify", source, {
                title = "Error",
                message = "You must be a police officer",
                type = "error"
            })
        end
    end
end, false)

RegisterCommand("warrant", function(source, args, rawCommand)
    if args[1] and args[2] then
        local targetId = tonumber(args[1])
        local reason = args[2]
        
        local playerJob = GetPlayerJob(source)
        if playerJob and playerJob.name == "police" then
            IssueWarrant(targetId, reason, 2)
        end
    end
end, false)

RegisterCommand("removewanted", function(source, args, rawCommand)
    if args[1] then
        local targetId = tonumber(args[1])
        RemoveWarrant(targetId)
        TriggerClientEvent("framework:notify", source, {
            title = "Warrant Removed",
            message = "Player " .. targetId .. " is now clear",
            type = "success"
        })
    end
end, false)

RegisterCommand("wantedlevel", function(source, args, rawCommand)
    if args[1] and args[2] then
        local targetId = tonumber(args[1])
        local level = tonumber(args[2])
        SetWantedLevel(targetId, level)
    end
end, false)

Shared.Log("PoliceServer", "INFO", "Police system initialized")
