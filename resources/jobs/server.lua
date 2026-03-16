-- Job System Server
-- Manages player jobs and salaries

local Jobs = {}
local PlayerJobs = {}

-- Initialize jobs from config
function InitializeJobs()
    for jobName, jobData in pairs(Config.Jobs.Jobs) do
        Jobs[jobName] = jobData
        Shared.Log("JobsServer", "INFO", "Loaded job: " .. jobName)
    end
end

-- Set player job
function SetPlayerJob(playerId, jobName, grade)
    if not Jobs[jobName] then
        Shared.Log("JobsServer", "ERROR", "Job " .. jobName .. " does not exist")
        return false
    end
    
    PlayerJobs[playerId] = {
        name = jobName,
        label = Jobs[jobName].label,
        grade = grade or 1,
        gradeLabel = Jobs[jobName].grade[grade or 1].label,
        salary = Jobs[jobName].grade[grade or 1].salary
    }
    
    TriggerClientEvent("framework:setJob", playerId, PlayerJobs[playerId])
    Shared.Log("JobsServer", "INFO", "Player " .. playerId .. " set to job: " .. jobName)
    
    return true
end

-- Get player job
function GetPlayerJob(playerId)
    return PlayerJobs[playerId]
end

-- Remove player job
function RemovePlayerJob(playerId)
    PlayerJobs[playerId] = nil
end

-- Get all jobs
function GetAllJobs()
    return Jobs
end

-- Pay player salary
Citizen.CreateThread(function()
    while true do
        Wait(60000) -- Every minute
        
        for playerId, jobData in pairs(PlayerJobs) do
            if jobData and jobData.salary then
                TriggerEvent("banking:addMoney", playerId, jobData.salary)
                TriggerClientEvent("framework:notify", playerId, {
                    title = "Salary",
                    message = "You earned $" .. jobData.salary,
                    type = "success"
                })
            end
        end
    end
end)

-- Commands
RegisterCommand("setjob", function(source, args, rawCommand)
    if args[1] and args[2] then
        local playerId = tonumber(args[1])
        local jobName = args[2]
        local grade = tonumber(args[3]) or 1
        
        SetPlayerJob(playerId, jobName, grade)
        TriggerClientEvent("framework:notify", source, {
            title = "Job Set",
            message = "Player " .. playerId .. " set to " .. jobName,
            type = "success"
        })
    end
end, false)

RegisterCommand("removejob", function(source, args, rawCommand)
    if args[1] then
        local playerId = tonumber(args[1])
        RemovePlayerJob(playerId)
        TriggerClientEvent("framework:notify", source, {
            title = "Job Removed",
            message = "Player " .. playerId .. " job removed",
            type = "success"
        })
    end
end, false)

RegisterCommand("jobs", function(source, args, rawCommand)
    local jobList = GetAllJobs()
    local message = "Available Jobs:\n"
    for jobName, _ in pairs(jobList) do
        message = message .. "- " .. jobName .. "\n"
    end
    TriggerClientEvent("framework:notify", source, {
        title = "Jobs List",
        message = message,
        type = "info"
    })
end, false)

-- Player dropped
RegisterNetEvent("framework:playerDropped")
AddEventHandler("framework:playerDropped", function(playerId)
    RemovePlayerJob(playerId)
end)

-- Initialize
InitializeJobs()
Shared.Log("JobsServer", "INFO", "Job system initialized")
