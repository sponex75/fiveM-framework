-- Character Management Server
-- Manages player character creation and selection

local Characters = {}

-- Create character
function CreateCharacter(playerId, characterData)
    local charId = playerId .. "_" .. os.time()
    
    Characters[charId] = {
        id = charId,
        playerId = playerId,
        firstName = characterData.firstName,
        lastName = characterData.lastName,
        dateOfBirth = characterData.dateOfBirth,
        gender = characterData.gender,
        skinTone = characterData.skinTone,
        createdAt = os.date("%Y-%m-%d %H:%M:%S"),
        level = 1,
        experience = 0,
        money = 5000,
        bankBalance = 5000
    }
    
    Shared.Log("CharactersServer", "INFO", "Character created: " .. characterData.firstName .. " " .. characterData.lastName)
    return Characters[charId]
end

-- Load character
function LoadCharacter(playerId, characterId)
    if Characters[characterId] and Characters[characterId].playerId == playerId then
        TriggerClientEvent("characters:loadCharacter", playerId, Characters[characterId])
        TriggerClientEvent("characters:spawn", playerId, Config.Characters.SpawnPoints[1])
        return true
    end
    return false
end

-- Get character
function GetCharacter(characterId)
    return Characters[characterId]
end

-- Get player characters
function GetPlayerCharacters(playerId)
    local playerChars = {}
    for charId, charData in pairs(Characters) do
        if charData.playerId == playerId then
            table.insert(playerChars, charData)
        end
    end
    return playerChars
end

-- Update character
function UpdateCharacter(characterId, updates)
    if Characters[characterId] then
        Characters[characterId] = Shared.TableMerge(Characters[characterId], updates)
        return true
    end
    return false
end

-- Delete character
function DeleteCharacter(characterId)
    Characters[characterId] = nil
end

-- Events
RegisterNetEvent("characters:create")
AddEventHandler("characters:create", function(characterData)
    local playerId = source
    local newChar = CreateCharacter(playerId, characterData)
    TriggerClientEvent("characters:created", playerId, newChar)
end)

RegisterNetEvent("characters:load")
AddEventHandler("characters:load", function(characterId)
    local playerId = source
    LoadCharacter(playerId, characterId)
end)

RegisterNetEvent("characters:list")
AddEventHandler("characters:list", function()
    local playerId = source
    local chars = GetPlayerCharacters(playerId)
    TriggerClientEvent("characters:listResponse", playerId, chars)
end)

-- Commands
RegisterCommand("createchar", function(source, args, rawCommand)
    if args[1] and args[2] then
        CreateCharacter(source, {
            firstName = args[1],
            lastName = args[2],
            gender = args[3] or "male",
            dateOfBirth = "01/01/1990"
        })
        TriggerClientEvent("framework:notify", source, {
            title = "Character Created",
            message = args[1] .. " " .. args[2],
            type = "success"
        })
    end
end, false)

RegisterCommand("delchar", function(source, args, rawCommand)
    if args[1] then
        DeleteCharacter(args[1])
        TriggerClientEvent("framework:notify", source, {
            title = "Character Deleted",
            message = "Character removed",
            type = "success"
        })
    end
end, false)

Shared.Log("CharactersServer", "INFO", "Character system initialized")
