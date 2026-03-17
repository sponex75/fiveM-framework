-- UI System Client
-- Handles all UI interactions

RegisterNuiCallbackType("menuCallback")
RegisterNuiCallback("menuCallback", function(data, cb)
    if data.action == "closeMenu" then
        CloseMenu()
    end
    cb("ok")
end)

-- Send notification to UI
function SendNotification(title, message, type, duration)
    SendNUIMessage({
        action = "notify",
        title = title,
        message = message,
        type = type or "info",
        duration = duration or 3000
    })
end

-- Open menu via UI
function OpenMenu(menuName, data)
    SendNUIMessage({
        action = "openMenu",
        menu = menuName,
        data = data or {}
    })
    SetNuiFocus(true, true)
end

-- Close menu
function CloseMenu()
    SendNUIMessage({
        action = "closeMenu"
    })
    SetNuiFocus(false, false)
end

-- Update inventory display
function UpdateInventoryUI(inventory)
    SendNUIMessage({
        action = "updateInventory",
        inventory = inventory
    })
end

-- Update job display
function UpdateJobUI(job)
    SendNUIMessage({
        action = "updateJob",
        job = job
    })
end

-- Update bank display
function UpdateBankUI(bank)
    SendNUIMessage({
        action = "updateBank",
        bank = bank
    })
end

-- Update character display
function UpdateCharacterUI(character)
    SendNUIMessage({
        action = "updateCharacter",
        character = character
    })
end

Shared.Log("UIClient", "INFO", "UI system initialized")
