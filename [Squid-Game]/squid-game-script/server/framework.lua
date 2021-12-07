Framework = {}

function Framework.takeMoney(playerId, amount)
    playerId = tonumber(playerId)
    
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local money = xPlayer.getMoney()
        if money >= amount then
            xPlayer.removeMoney(amount)
            return true
        end
        return false
    elseif Config.Framework == "QB" then
		local Ply = QBCore.Functions.GetPlayer(playerId)
		if Ply.PlayerData.money["cash"] >= amount then
            return Ply.Functions.RemoveMoney("cash", amount, "squid-game-level-1")
		else
            return false
        end
    elseif Config.Framework == "vRP" then
        local userId = vRP.getUserId({playerId})
        if vRP.tryPayment({userId, amount}) then
            return true
        else
            return false
        end	
    elseif Config.Framework == "pepe" then
        -- TODO:
        -- error("TODO: Check if player has money", 2)
        -- error("TODO: Take money from player", 2)
        local Ply = FrameworkObj.Functions.GetPlayer(playerId)
		if Ply.PlayerData.money["cash"] >= amount then
            return Ply.Functions.RemoveMoney("cash", amount, "squid-game-level-1")
		else
            return false
        end
    else
        Framework.showNotification(playerId, _U('removed_money', amount))
        return true
    end
end

function Framework.giveMoney(playerId, amount)
    playerId = tonumber(playerId)
    amount = math.floor(amount * 0.9)
    
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        xPlayer.addMoney(amount)
        return true
    elseif Config.Framework == "QB" then
		local Ply = QBCore.Functions.GetPlayer(playerId)
        return Ply.Functions.AddMoney("cash", amount, "squid-game-level-1")
    elseif Config.Framework == "vRP" then
        local userId = vRP.getUserId({playerId})
        vRP.giveMoney({userId, amount})
        return true
    elseif Config.Framework == "pepe" then
        -- TODO:
        
        local Ply = FrameworkObj.Functions.GetPlayer(playerId)
        return Ply.Functions.AddMoney("cash", amount, "squid-game-level-1")
    else
        Framework.showNotification(playerId, _U('received_money', amount))
        return true
    end
end

function Framework.showNotification(playerId, message)
    if Config.Framework == "ESX" then
        TriggerClientEvent("esx:showNotification", playerId, message)
    elseif Config.Framework == "QB" then
        TriggerClientEvent('QBCore:Notify', playerId, message)
    elseif Config.Framework == "vRP" then
        local vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())
        vRPclient.notify(playerId, {message})
    elseif Config.Framework == "pepe" then
        -- TODO: Add your notifications
        -- error("TODO: Add your notifications", 2)
        TriggerClientEvent('Framework:Notify', playerId, message)
        return true
    else
        TriggerClientEvent("squidgame:notification", playerId, message)
        return true
    end
end

function Framework.showWinnerMessage(toWhomId, winnerId, rewardAmount)
    local winnerName = GetPlayerName(winnerId)

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(winnerId)
        if xPlayer then
            winnerName = xPlayer.getName()
        end
        TriggerClientEvent('chat:addMessage', toWhomId, {
            color = { 255, 0, 0},
            multiline = true,
            args = {Config.GameName or "Đèn xanh - Đèn đỏ", _U("player_%s_won_%s", winnerName, rewardAmount)}
        })
    elseif Config.Framework == "QB" then
        local Ply = QBCore.Functions.GetPlayer(winnerId)
        if Ply then
            winnerName = Ply.PlayerData.charinfo.firstname .. " " .. Ply.charinfo.PlayerData.lastname
        end
        TriggerClientEvent('chat:addMessage', toWhomId, {
            color = { 255, 0, 0},
            multiline = true,
            args = {Config.GameName or "Đèn xanh - Đèn đỏ", _U("player_%s_won_%s", winnerName, rewardAmount)}
        })
    elseif Config.Framework == "vRP" then
        local winnerName = GetPlayerName(winnerId)
        local userId = vRP.getUserId({toWhomId})
        vRP.getUserIdentity({userId, function(identity)
            if identity then
                winnerName = identity.firstname .. " " .. identity.name
            end
            TriggerClientEvent('chat:addMessage', toWhomId, {
                color = { 255, 0, 0},
                multiline = true,
                args = {Config.GameName or "Đèn xanh - Đèn đỏ", _U("player_%s_won_%s", winnerName, rewardAmount)}
            })
        end})
    elseif Config.Framework == "pepe" then
        TriggerClientEvent('chat:addMessage', toWhomId, {
            color = { 255, 0, 0},
            multiline = true,
            args = {Config.GameName or "Đèn xanh - Đèn đỏ", _U("player_%s_won_%s", winnerName, rewardAmount)}
        })
    end
end