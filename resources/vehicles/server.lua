-- Vehicle System Server
-- Manages player vehicles, garages, and spawning

local PlayerVehicles = {}
local SpawnedVehicles = {}

-- Register vehicle to player
function RegisterVehicle(playerId, vehicleData)
    if not PlayerVehicles[playerId] then
        PlayerVehicles[playerId] = {}
    end
    
    if #PlayerVehicles[playerId] >= Config.Vehicles.GarageLimits then
        Shared.Log("VehiclesServer", "WARNING", "Player " .. playerId .. " garage full")
        return false
    end
    
    local vehicleId = "vehicle_" .. playerId .. "_" .. os.time()
    PlayerVehicles[playerId][vehicleId] = {
        id = vehicleId,
        model = vehicleData.model,
        plate = vehicleData.plate or vehicleId,
        fuel = 100,
        engineHealth = 1000,
        bodyHealth = 1000,
        mods = {},
        position = vehicleData.position,
        heading = vehicleData.heading or 0.0,
        registeredAt = os.date("%Y-%m-%d %H:%M:%S")
    }
    
    Shared.Log("VehiclesServer", "INFO", "Vehicle registered for player " .. playerId .. ": " .. vehicleData.model)
    return PlayerVehicles[playerId][vehicleId]
end

-- Spawn vehicle
function SpawnVehicle(playerId, vehicleId, coords, heading)
    if not PlayerVehicles[playerId] or not PlayerVehicles[playerId][vehicleId] then
        return false
    end
    
    local vehData = PlayerVehicles[playerId][vehicleId]
    
    TriggerClientEvent("vehicles:spawn", playerId, {
        model = vehData.model,
        plate = vehData.plate,
        x = coords.x,
        y = coords.y,
        z = coords.z,
        heading = heading or 0.0,
        fuel = vehData.fuel,
        engineHealth = vehData.engineHealth
    })
    
    Shared.Log("VehiclesServer", "INFO", "Vehicle spawned for player " .. playerId)
    return true
end

-- Delete vehicle
function DeleteVehicle(playerId, vehicleId)
    TriggerClientEvent("vehicles:delete", playerId, vehicleId)
end

-- Store vehicle (return to garage)
function StoreVehicle(playerId, vehicleId, state)
    if PlayerVehicles[playerId] and PlayerVehicles[playerId][vehicleId] then
        PlayerVehicles[playerId][vehicleId].fuel = state.fuel or 100
        PlayerVehicles[playerId][vehicleId].engineHealth = state.engineHealth or 1000
        Shared.Log("VehiclesServer", "INFO", "Vehicle stored for player " .. playerId)
        return true
    end
    return false
end

-- Get player vehicles
function GetPlayerVehicles(playerId)
    return PlayerVehicles[playerId] or {}
end

-- Commands
RegisterCommand("garage", function(source, args, rawCommand)
    local vehicles = GetPlayerVehicles(source)
    TriggerClientEvent("vehicles:garage", source, vehicles)
end, false)

RegisterCommand("spawnvehicle", function(source, args, rawCommand)
    if args[1] then
        local model = args[1]
        local plate = args[2] or ("FWVEH" .. math.random(1000, 9999))
        
        local veh = RegisterVehicle(source, {
            model = model,
            plate = plate,
            position = {x = 425.0, y = -979.0, z = 29.0}
        })
        
        if veh then
            SpawnVehicle(source, veh.id, vector3(425.0, -979.0, 29.0), 0.0)
            TriggerClientEvent("framework:notify", source, {
                title = "Vehicle Spawned",
                message = model .. " - " .. plate,
                type = "success"
            })
        end
    end
end, false)

RegisterCommand("deletevehicle", function(source, args, rawCommand)
    if args[1] then
        DeleteVehicle(source, args[1])
    end
end, false)

-- Events
RegisterNetEvent("vehicles:store")
AddEventHandler("vehicles:store", function(vehicleId, state)
    StoreVehicle(source, vehicleId, state)
end)

Shared.Log("VehiclesServer", "INFO", "Vehicle system initialized")
