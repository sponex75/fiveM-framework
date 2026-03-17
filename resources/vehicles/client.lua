-- Vehicle System Client
-- Client-side vehicle management

local PlayerVehicles = {}
local CurrentVehicle = nil
local VehicleGarage = {}

RegisterNetEvent("vehicles:spawn")
AddEventHandler("vehicles:spawn", function(vehicleData)
    local model = GetHashKey(vehicleData.model)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    local veh = CreateVehicle(model, vehicleData.x, vehicleData.y, vehicleData.z, vehicleData.heading, true, false)
    SetVehicleNumberPlateText(veh, vehicleData.plate)
    SetVehicleEngineHealth(veh, vehicleData.engineHealth)
    SetVehicleFuelLevel(veh, vehicleData.fuel)
    
    CurrentVehicle = veh
    SendNotification("Vehicle Spawned", vehicleData.model .. " - " .. vehicleData.plate, "success", 3000)
end)

RegisterNetEvent("vehicles:delete")
AddEventHandler("vehicles:delete", function(vehicleId)
    if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
        DeleteEntity(CurrentVehicle)
        CurrentVehicle = nil
    end
end)

RegisterNetEvent("vehicles:garage")
AddEventHandler("vehicles:garage", function(vehicles)
    VehicleGarage = vehicles
    OpenMenu("garage", {vehicles = vehicles})
end)

-- Get player's current vehicle
function GetCurrentVehicle()
    return CurrentVehicle
end

-- Commands
RegisterCommand("engine", function(source, args, rawCommand)
    if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
        if GetVehicleEngineHealth(CurrentVehicle) > 0 then
            if GetIsVehicleEngineRunning(CurrentVehicle) then
                SetVehicleEngineHealth(CurrentVehicle, 0)
                SendNotification("Engine", "Off", "info", 2000)
            else
                SetVehicleDeformationFixed(CurrentVehicle)
                SendNotification("Engine", "On", "info", 2000)
            end
        end
    end
end, false)

RegisterCommand("lockvehicle", function(source, args, rawCommand)
    if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
        local locked = GetVehicleDoorLockStatus(CurrentVehicle)
        if locked == 0 then
            SmashVehicleWindow(CurrentVehicle, 0)
            SmashVehicleWindow(CurrentVehicle, 1)
            SmashVehicleWindow(CurrentVehicle, 2)
            SmashVehicleWindow(CurrentVehicle, 3)
            SetVehicleDoorsShut(CurrentVehicle, false)
        else
            SetVehicleDoorsShut(CurrentVehicle, true)
        end
    end
end, false)

-- Store vehicle on exit
RegisterCommand("storevehicle", function(source, args, rawCommand)
    if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
        local engineHealth = GetVehicleEngineHealth(CurrentVehicle)
        local fuel = GetVehicleFuelLevel(CurrentVehicle)
        
        TriggerServerEvent("vehicles:store", "current_vehicle", {
            engineHealth = engineHealth,
            fuel = fuel
        })
        
        SendNotification("Vehicle Stored", "Garage updated", "success", 3000)
    end
end, false)
