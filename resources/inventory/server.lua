-- Inventory System Server
-- Manages player inventories and items

local PlayerInventories = {}

-- Initialize player inventory
function InitializeInventory(playerId)
    PlayerInventories[playerId] = {
        slots = {},
        totalWeight = 0,
        maxSlots = Config.Inventory.MaxSlots,
        maxWeight = Config.Inventory.MaxWeight
    }
    
    -- Add starting items
    AddItem(playerId, "money", 500)
    AddItem(playerId, "phone", 1)
    AddItem(playerId, "license", 1)
end

-- Add item to inventory
function AddItem(playerId, itemName, quantity, metadata)
    if not PlayerInventories[playerId] then
        InitializeInventory(playerId)
    end
    
    local inv = PlayerInventories[playerId]
    local itemData = Config.Inventory.Items[itemName] or {
        label = itemName,
        weight = 0,
        stackable = true
    }
    
    local itemWeight = itemData.weight * quantity
    
    if inv.totalWeight + itemWeight > inv.maxWeight then
        TriggerClientEvent("framework:notify", playerId, {
            title = "Inventory Full",
            message = "Not enough space",
            type = "error"
        })
        return false
    end
    
    -- Check if item exists and is stackable
    local added = false
    if itemData.stackable then
        for i, slot in ipairs(inv.slots) do
            if slot.name == itemName then
                slot.quantity = slot.quantity + quantity
                inv.totalWeight = inv.totalWeight + itemWeight
                added = true
                break
            end
        end
    end
    
    if not added then
        if #inv.slots >= inv.maxSlots then
            TriggerClientEvent("framework:notify", playerId, {
                title = "Inventory Full",
                message = "No more slots available",
                type = "error"
            })
            return false
        end
        
        table.insert(inv.slots, {
            name = itemName,
            label = itemData.label,
            quantity = quantity,
            weight = itemData.weight,
            metadata = metadata or {}
        })
        inv.totalWeight = inv.totalWeight + itemWeight
    end
    
    TriggerClientEvent("inventory:update", playerId, inv)
    Shared.Log("InventoryServer", "INFO", "Added " .. quantity .. "x " .. itemName .. " to player " .. playerId)
    return true
end

-- Remove item from inventory
function RemoveItem(playerId, itemName, quantity)
    if not PlayerInventories[playerId] then
        return false
    end
    
    local inv = PlayerInventories[playerId]
    
    for i, slot in ipairs(inv.slots) do
        if slot.name == itemName then
            if slot.quantity < quantity then
                Shared.Log("InventoryServer", "WARNING", "Not enough " .. itemName)
                return false
            end
            
            slot.quantity = slot.quantity - quantity
            inv.totalWeight = inv.totalWeight - (slot.weight * quantity)
            
            if slot.quantity <= 0 then
                table.remove(inv.slots, i)
            end
            
            TriggerClientEvent("inventory:update", playerId, inv)
            return true
        end
    end
    
    return false
end

-- Get inventory
function GetInventory(playerId)
    return PlayerInventories[playerId]
end

-- Check if player has item
function HasItem(playerId, itemName, quantity)
    if not PlayerInventories[playerId] then
        return false
    end
    
    local inv = PlayerInventories[playerId]
    for _, slot in ipairs(inv.slots) do
        if slot.name == itemName then
            return slot.quantity >= (quantity or 1)
        end
    end
    
    return false
end

-- Player dropped event
RegisterNetEvent("framework:playerDropped")
AddEventHandler("framework:playerDropped", function(playerId)
    PlayerInventories[playerId] = nil
end)

-- Commands
RegisterCommand("additem", function(source, args, rawCommand)
    if args[1] and args[2] and args[3] then
        local playerId = tonumber(args[1])
        local itemName = args[2]
        local quantity = tonumber(args[3])
        
        AddItem(playerId, itemName, quantity)
        TriggerClientEvent("framework:notify", source, {
            title = "Item Added",
            message = quantity .. "x " .. itemName,
            type = "success"
        })
    end
end, false)

RegisterCommand("removeitem", function(source, args, rawCommand)
    if args[1] and args[2] and args[3] then
        local playerId = tonumber(args[1])
        local itemName = args[2]
        local quantity = tonumber(args[3])
        
        RemoveItem(playerId, itemName, quantity)
    end
end, false)

Shared.Log("InventoryServer", "INFO", "Inventory system initialized")
