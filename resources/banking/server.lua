-- Banking System Server
-- Manages player bank accounts and transactions

local BankAccounts = {}

-- Initialize bank account
function InitializeBankAccount(playerId, playerName)
    BankAccounts[playerId] = {
        id = playerId,
        owner = playerName,
        balance = Config.Banking.StartingBalance,
        transactions = {},
        createdAt = os.date("%Y-%m-%d %H:%M:%S")
    }
    
    Shared.Log("BankingServer", "INFO", "Bank account created for player " .. playerId)
end

-- Deposit money
function DepositMoney(playerId, amount)
    if not BankAccounts[playerId] then
        Shared.Log("BankingServer", "ERROR", "No bank account for player " .. playerId)
        return false
    end
    
    if amount <= 0 or amount > Config.Banking.TransactionLimit then
        return false
    end
    
    -- Remove cash inventory item
    TriggerEvent("inventory:removeItem", playerId, "money", amount)
    
    BankAccounts[playerId].balance = BankAccounts[playerId].balance + amount
    LogTransaction(playerId, "DEPOSIT", amount)
    
    TriggerClientEvent("framework:notify", playerId, {
        title = "Deposit",
        message = "You deposited $" .. amount,
        type = "success"
    })
    
    Shared.Log("BankingServer", "INFO", "Player " .. playerId .. " deposited $" .. amount)
    return true
end

-- Withdraw money
function WithdrawMoney(playerId, amount)
    if not BankAccounts[playerId] then
        Shared.Log("BankingServer", "ERROR", "No bank account for player " .. playerId)
        return false
    end
    
    if amount <= 0 or amount > Config.Banking.TransactionLimit then
        return false
    end
    
    if BankAccounts[playerId].balance < amount then
        TriggerClientEvent("framework:notify", playerId, {
            title = "Insufficient Funds",
            message = "You don't have enough money",
            type = "error"
        })
        return false
    end
    
    BankAccounts[playerId].balance = BankAccounts[playerId].balance - amount
    TriggerEvent("inventory:addItem", playerId, "money", amount)
    LogTransaction(playerId, "WITHDRAWAL", amount)
    
    TriggerClientEvent("framework:notify", playerId, {
        title = "Withdrawal",
        message = "You withdrew $" .. amount,
        type = "success"
    })
    
    Shared.Log("BankingServer", "INFO", "Player " .. playerId .. " withdrew $" .. amount)
    return true
end

-- Transfer money
function TransferMoney(fromPlayer, toPlayer, amount)
    if not BankAccounts[fromPlayer] or not BankAccounts[toPlayer] then
        return false
    end
    
    if BankAccounts[fromPlayer].balance < amount then
        return false
    end
    
    BankAccounts[fromPlayer].balance = BankAccounts[fromPlayer].balance - amount
    BankAccounts[toPlayer].balance = BankAccounts[toPlayer].balance + amount
    
    LogTransaction(fromPlayer, "TRANSFER_OUT", amount, toPlayer)
    LogTransaction(toPlayer, "TRANSFER_IN", amount, fromPlayer)
    
    TriggerClientEvent("framework:notify", fromPlayer, {
        title = "Transfer",
        message = "Transferred $" .. amount .. " to player",
        type = "success"
    })
    
    TriggerClientEvent("framework:notify", toPlayer, {
        title = "Transfer Received",
        message = "Received $" .. amount,
        type = "success"
    })
    
    return true
end

-- Get balance
function GetBalance(playerId)
    if BankAccounts[playerId] then
        return BankAccounts[playerId].balance
    end
    return 0
end

-- Log transaction
function LogTransaction(playerId, type, amount, otherPlayer)
    if not BankAccounts[playerId] then return end
    
    table.insert(BankAccounts[playerId].transactions, {
        type = type,
        amount = amount,
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        balance = BankAccounts[playerId].balance,
        otherPlayer = otherPlayer or nil
    })
end

-- Add money (from salary, etc)
RegisterNetEvent("banking:addMoney")
AddEventHandler("banking:addMoney", function(playerId, amount)
    if BankAccounts[playerId] then
        BankAccounts[playerId].balance = BankAccounts[playerId].balance + amount
        LogTransaction(playerId, "CREDIT", amount)
    end
end)

-- Commands
RegisterCommand("balance", function(source, args, rawCommand)
    local balance = GetBalance(source)
    TriggerClientEvent("framework:notify", source, {
        title = "Bank Balance",
        message = "$" .. balance,
        type = "info"
    })
end, false)

RegisterCommand("deposit", function(source, args, rawCommand)
    if args[1] then
        local amount = tonumber(args[1])
        DepositMoney(source, amount)
    end
end, false)

RegisterCommand("withdraw", function(source, args, rawCommand)
    if args[1] then
        local amount = tonumber(args[1])
        WithdrawMoney(source, amount)
    end
end, false)

Shared.Log("BankingServer", "INFO", "Banking system initialized")
