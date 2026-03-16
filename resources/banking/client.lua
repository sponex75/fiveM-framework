-- Banking System Client

RegisterCommand("atm", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Check if near ATM
    for _, atmLoc in ipairs(Config.Banking.ATMLocations) do
        local distance = #(coords - vector3(atmLoc.x, atmLoc.y, atmLoc.z))
        if distance < 2.0 then
            OpenMenu("atm", {
                balance = TriggerServerEvent("banking:getBalance")
            })
            return
        end
    end
    
    SendNotification("ATM", "You must be near an ATM", "error", 3000)
end, false)

RegisterCommand("balance", function(source, args, rawCommand)
    TriggerServerEvent("banking:getBalance", function(balance)
        SendNotification("Bank Balance", "$" .. balance, "info", 5000)
    end)
end, false)

-- ATM Blips (for GUI)
Citizen.CreateThread(function()
    for _, atmLoc in ipairs(Config.Banking.ATMLocations) do
        local blip = AddBlipForCoord(atmLoc.x, atmLoc.y, atmLoc.z)
        SetBlipSprite(blip, 227)
        SetBlipAsNoLongerNeeded(blip)
        AddTextComponentString("ATM")
        BeginTextCommandDisplayHelp("STRING")
        EndTextCommandDisplayHelp(0, false, true, -1)
    end
end)
