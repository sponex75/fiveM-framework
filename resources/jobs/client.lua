-- Job System Client
-- Displays and manages job info on client

local PlayerJob = nil

RegisterNetEvent("framework:setJob")
AddEventHandler("framework:setJob", function(jobData)
    PlayerJob = jobData
    SendNotification("Job Updated", "You are now a " .. jobData.gradeLabel, "info", 5000)
    UpdatePlayerData("job", jobData)
end)

-- Get player's job
function GetPlayerJob()
    return PlayerJob
end

-- Job menu command
RegisterCommand("jobinfo", function(source, args, rawCommand)
    if PlayerJob then
        SendNotification("Job Info", 
            "Job: " .. PlayerJob.label .. 
            "\nGrade: " .. PlayerJob.gradeLabel ..
            "\nSalary: $" .. PlayerJob.salary, 
            "info", 5000)
    else
        SendNotification("No Job", "You don't have a job", "error", 3000)
    end
end, false)

-- Job clock in/out
RegisterCommand("jobclock", function(source, args, rawCommand)
    if PlayerJob then
        if args[1] == "in" then
            TriggerServerEvent("jobs:clockIn")
            SendNotification("Clock In", "You have clocked in", "success", 3000)
        elseif args[1] == "out" then
            TriggerServerEvent("jobs:clockOut")
            SendNotification("Clock Out", "You have clocked out", "success", 3000)
        end
    else
        SendNotification("No Job", "You don't have a job", "error", 3000)
    end
end, false)
