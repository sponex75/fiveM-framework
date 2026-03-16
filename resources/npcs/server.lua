-- NPC System Server
-- Manages NPCs and interactions

local NPCs = {}
local ActiveInteractions = {}

-- Create NPC
function CreateNPC(model, coords, heading, name, dialogues)
    local npcId = "npc_" .. os.time() .. "_" .. math.random(1000, 9999)
    
    NPCs[npcId] = {
        id = npcId,
        model = model,
        coords = coords,
        heading = heading or 0.0,
        name = name or "NPC",
        dialogues = dialogues or {},
        active = true
    }
    
    TriggerClientEvent("npcs:createNPC", -1, NPCs[npcId])
    Shared.Log("NPCServer", "INFO", "NPC created: " .. name)
    
    return NPCs[npcId]
end

-- Get NPC
function GetNPC(npcId)
    return NPCs[npcId]
end

-- Get all NPCs
function GetAllNPCs()
    return NPCs
end

-- Start interaction
function StartInteraction(playerId, npcId)
    if NPCs[npcId] then
        ActiveInteractions[playerId] = {
            npcId = npcId,
            startTime = os.time()
        }
        
        TriggerClientEvent("npcs:interact", playerId, NPCs[npcId])
        Shared.Log("NPCServer", "INFO", "Player " .. playerId .. " started interaction with NPC " .. npcId)
        
        return true
    end
    
    return false
end

-- End interaction
function EndInteraction(playerId)
    ActiveInteractions[playerId] = nil
end

-- Handle dialogue response
RegisterNetEvent("npcs:dialogueResponse")
AddEventHandler("npcs:dialogueResponse", function(npcId, dialogueIndex)
    local playerId = source
    local npc = GetNPC(npcId)
    
    if npc and npc.dialogues[dialogueIndex] then
        local dialogue = npc.dialogues[dialogueIndex]
        
        if dialogue.action then
            TriggerEvent("npcs:action_" .. npc.name:lower(), playerId, dialogue.action)
        end
        
        Shared.Log("NPCServer", "INFO", "Dialogue action: " .. dialogue.action)
    end
end)

-- Initialize default NPCs
function InitializeNPCs()
    -- Taxi NPC
    CreateNPC("a_m_m_business_1", {x = 425.0, y = -979.0, z = 29.0}, 0.0, "Taxi Driver", {
        {text = "I can take you anywhere in the city", action = "taxi_offer"}
    })
    
    -- Bank NPC
    CreateNPC("a_m_m_business_2", {x = 150.0, y = -885.0, z = 31.0}, 0.0, "Bank Teller", {
        {text = "You can deposit or withdraw money here", action = "bank_service"}
    })
    
    -- Hospital NPC
    CreateNPC("a_f_m_business_1", {x = -1035.0, y = -414.0, z = 58.6}, 0.0, "Receptionist", {
        {text = "Welcome to Pillbox Medical Center", action = "hospital_service"}
    })
end

-- Commands
RegisterCommand("createnpc", function(source, args, rawCommand)
    if args[1] and args[2] and args[3] and args[4] then
        local model = args[1]
        local x, y, z = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
        local name = args[5] or "NPC"
        
        CreateNPC(model, {x = x, y = y, z = z}, 0.0, name, {})
    end
end, false)

RegisterCommand("deletenpc", function(source, args, rawCommand)
    if args[1] then
        NPCs[args[1]] = nil
        TriggerClientEvent("npcs:deleteNPC", -1, args[1])
    end
end, false)

-- Initialize NPCs on start
InitializeNPCs()
Shared.Log("NPCServer", "INFO", "NPC system initialized")
