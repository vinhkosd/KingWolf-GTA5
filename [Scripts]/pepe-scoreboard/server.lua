Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('pepe-scoreboard:server:GetActiveCops', function(source, cb)
    local retval = 0
    local playersOnline = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                retval = retval + 1
            end
            playersOnline = playersOnline + 1
        end
    end

    cb(retval, playersOnline)
end)

Framework.Functions.CreateCallback('pepe-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

RegisterServerEvent('pepe-scoreboard:server:SetActivityBusy')
AddEventHandler('pepe-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('pepe-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)