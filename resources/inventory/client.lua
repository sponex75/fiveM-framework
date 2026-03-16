-- Inventory System Client
-- Client-side inventory management

local PlayerInventory = nil
local InventoryOpen = false

RegisterNetEvent("inventory:update")
AddEventHandler("inventory:update", function(inventory)
    PlayerInventory = inventory
    SendNUIMessage({
        action = "updateInventory",
        inventory = inventory
    })
end)

-- Open inventory
RegisterCommand("inventory", function(source, args, rawCommand)
    if PlayerInventory then
        OpenMenu("inventory", PlayerInventory)
        InventoryOpen = true
    end
end, false)

-- Close inventory
RegisterCommand("closeinventory", function(source, args, rawCommand)
    CloseMenu()
    InventoryOpen = false
end, false)

-- Use item
RegisterNetEvent("inventory:useItem")
AddEventHandler("inventory:useItem", function(itemName)
    TriggerServerEvent("inventory:itemUsed", itemName)
end)

-- Get player inventory
function GetPlayerInventory()
    return PlayerInventory
end

-- Request inventory from server
function RequestInventory()
    TriggerServerEvent("inventory:request")
end

-- Initialize on spawn
RegisterNetEvent("framework:clientReady")
AddEventHandler("framework:clientReady", function()
    RequestInventory()
end)
