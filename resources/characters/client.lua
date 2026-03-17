-- Character Management Client
-- Character creation and selection

local CurrentCharacter = nil
local Characters = {}

RegisterNetEvent("characters:loadCharacter")
AddEventHandler("characters:loadCharacter", function(characterData)
    CurrentCharacter = characterData
    UpdatePlayerData("character", characterData)
    SendNotification("Character Loaded", characterData.firstName .. " " .. characterData.lastName, "success", 3000)
end)

RegisterNetEvent("characters:spawn")
AddEventHandler("characters:spawn", function(spawnPoint)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, spawnPoint.x, spawnPoint.y, spawnPoint.z)
    SetEntityHeading(playerPed, spawnPoint.heading)
    SendNotification("Spawned", "Welcome to " .. spawnPoint.label, "info", 3000)
end)

RegisterNetEvent("characters:listResponse")
AddEventHandler("characters:listResponse", function(chars)
    Characters = chars
    OpenMenu("characterSelect", {characters = chars})
end)

RegisterNetEvent("characters:created")
AddEventHandler("characters:created", function(charData)
    CurrentCharacter = charData
    SendNotification("Character Created", charData.firstName .. " " .. charData.lastName, "success", 5000)
end)

-- Get current character
function GetCurrentCharacter()
    return CurrentCharacter
end

-- Request character list
RegisterCommand("selectchar", function(source, args, rawCommand)
    TriggerServerEvent("characters:list")
end, false)

-- Create character command
RegisterCommand("newchar", function(source, args, rawCommand)
    if args[1] and args[2] then
        TriggerServerEvent("characters:create", {
            firstName = args[1],
            lastName = args[2],
            gender = args[3] or "male",
            dateOfBirth = "01/01/1990"
        })
    else
        SendNotification("Usage", "/newchar firstname lastname [gender]", "info", 3000)
    end
end, false)

-- Show spawn points when character menu opens
Citizen.CreateThread(function()
    for _, spawnPoint in ipairs(Config.Characters.SpawnPoints) do
        local blip = AddBlipForCoord(spawnPoint.x, spawnPoint.y, spawnPoint.z)
        SetBlipSprite(blip, 227)
        AddTextComponentString(spawnPoint.label)
        BeginTextCommandDisplayHelp("STRING")
        EndTextCommandDisplayHelp(0, false, true, -1)
    end
end)
