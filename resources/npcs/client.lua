-- NPC System Client
-- Client-side NPC interaction

local NPCs = {}
local InteractingNPC = nil

RegisterNetEvent("npcs:createNPC")
AddEventHandler("npcs:createNPC", function(npcData)
    NPCs[npcData.id] = npcData
    SpawnNPC(npcData)
end)

RegisterNetEvent("npcs:deleteNPC")
AddEventHandler("npcs:deleteNPC", function(npcId)
    if NPCs[npcId] then
        NPCs[npcId] = nil
    end
end)

RegisterNetEvent("npcs:interact")
AddEventHandler("npcs:interact", function(npcData)
    InteractingNPC = npcData
    OpenMenu("npcDialog", {
        npcName = npcData.name,
        dialogues = npcData.dialogues
    })
end)

-- Spawn NPC entity
function SpawnNPC(npcData)
    local model = GetHashKey(npcData.model)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    local npc = CreatePed(4, model, npcData.coords.x, npcData.coords.y, npcData.coords.z, npcData.heading, true, false)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    
    NPCs[npcData.id].handle = npc
end

-- Get nearby NPCs for interaction
function GetNearbyNPCs(maxDistance)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local nearbyNPCs = {}
    
    for npcId, npcData in pairs(NPCs) do
        if npcData.handle and DoesEntityExist(npcData.handle) then
            local distance = #(coords - vector3(npcData.coords.x, npcData.coords.y, npcData.coords.z))
            if distance < (maxDistance or 5.0) then
                table.insert(nearbyNPCs, npcData)
            end
        end
    end
    
    return nearbyNPCs
end

-- Interaction loop
Citizen.CreateThread(function()
    while true do
        Wait(300)
        
        local nearbyNPCs = GetNearbyNPCs(5.0)
        
        if #nearbyNPCs > 0 then
            for _, npc in ipairs(nearbyNPCs) do
                if npc.handle and DoesEntityExist(npc.handle) then
                    -- Draw marker above NPC
                    local coords = vector3(npc.coords.x, npc.coords.y, npc.coords.z + 1.0)
                    DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 128, 0, 100, false, true, 2, false, nil, nil, false)
                end
            end
            
            -- Check for E key press
            if IsControlJustReleased(0, 38) then -- E key
                if #nearbyNPCs > 0 then
                    TriggerServerEvent("npcs:interact", nearbyNPCs[1].id)
                end
            end
        end
    end
end)

-- Handle dialogue response
RegisterNuiCallbackType("npcDialogue")
RegisterNuiCallback("npcDialogue", function(data, cb)
    if InteractingNPC then
        TriggerServerEvent("npcs:dialogueResponse", InteractingNPC.id, data.index)
        CloseMenu()
    end
    cb("ok")
end)
