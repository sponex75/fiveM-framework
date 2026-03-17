-- Shared Utilities
-- Functions accessible from both client and server

Shared = {}

-- Logging function
function Shared.Log(source, level, message)
    local prefix = ""
    
    if level == "DEBUG" then
        prefix = "^5[DEBUG]^7"
    elseif level == "INFO" then
        prefix = "^2[INFO]^7"
    elseif level == "WARNING" then
        prefix = "^3[WARNING]^7"
    elseif level == "ERROR" then
        prefix = "^1[ERROR]^7"
    end
    
    print(prefix .. " [" .. source .. "]: " .. message)
end

-- Notify function (client-side)
function Shared.Notify(title, message, type, duration)
    TriggerEvent("framework:notify", {
        title = title,
        message = message,
        type = type or "info",
        duration = duration or 3000
    })
end

-- Check if player has permission (placeholder)
function Shared.HasPermission(source, permission)
    return true -- Replace with actual permission logic
end

-- Table utility functions
function Shared.TableMerge(table1, table2)
    for k, v in pairs(table2) do
        if type(v) == "table" and type(table1[k]) == "table" then
            Shared.TableMerge(table1[k], v)
        else
            table1[k] = v
        end
    end
    return table1
end

-- String utilities
function Shared.StringTrim(str)
    return string.match(str, "^%s*(.-)%s*$")
end

function Shared.StringSplit(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end
