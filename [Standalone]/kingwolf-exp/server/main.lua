Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

function GetOnlinePlayers(playerId, players)
    local Active = {}

    return Active 
end

------
-- UpdatePlayer
--
-- @param playerId          - The player's id
-- @param xp                - The player's current XP
-- @param rank              - The player's current rank
--
-- Fetches active players and initialises for current player
------
function FetchActivePlayers(playerId, xp, rank)
    
end

------
-- UpdatePlayer
--
-- @param playerId          - The player's id
-- @param xp                - The XP value to set
--
-- Updates the given user's XP
------
function UpdatePlayer(playerId, xp)
    local src = source
	local Player = Framework.Functions.GetPlayer(playerId)
    -- local xPlayer = ESX.GetPlayerFromId(playerId)

    if xp == nil or not IsInt(xp) then
        TriggerClientEvent("kingwolf-exp:print", playerId, _("err_type_check", "XP", "integer"))

        return
    end

    -- if xPlayer ~= nil then
    --     local goalXP = LimitXP(tonumber(xp))
    --     local goalRank = GetRankFromXP(goalXP)

    --     MySQL.Async.execute('UPDATE users SET rp_xp = @xp, rp_rank = @rank WHERE identifier = @identifier', {
    --         ['@identifier'] = xPlayer.identifier,
    --         ['@xp'] = goalXP,
    --         ['@rank'] = goalRank
    --     }, function(result)
    --         xPlayer.set("xp", goalXP)
    --         xPlayer.set("rank", goalRank)

    --         -- Update the player's XP bar
    --         xPlayer.triggerEvent("kingwolf-exp:update", goalXP, goalRank)
    --     end)
    -- end

    if Player ~= nil then
        CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0
        CurrentRank = Player.PlayerData.metadata["currentrank"]  ~= nil and Player.PlayerData.metadata["currentrank"] or 0
        local goalXP = LimitXP(tonumber(xp))
        local goalRank = GetRankFromXP(goalXP)
        if CurrentRank ~= goalRank then
            TriggerClientEvent('Framework:Notify', playerId, "Bạn vừa lên cấp, hãy sử dụng chứng chỉ nghề để mở ra nghề tiếp theo", "error") 
        end
        Player.Functions.SetMetaData("currentxp", goalXP)
        Player.Functions.SetMetaData("currentrank", goalRank)
        TriggerClientEvent("kingwolf-exp:update", playerId, goalXP, goalRank)
    end
end


------------------------------------------------------------
--                        EVENTS                          --
------------------------------------------------------------

RegisterNetEvent("kingwolf-exp:load")
AddEventHandler("kingwolf-exp:load", function()
    local src = source
	local Player = Framework.Functions.GetPlayer(src)

    if Player ~= nil then
        CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0
        CurrentRank = Player.PlayerData.metadata["currentrank"]  ~= nil and Player.PlayerData.metadata["currentrank"] or 0
        Player.Functions.SetMetaData("currentxp", CurrentXP)
        Player.Functions.SetMetaData("currentrank", CurrentRank)
        TriggerClientEvent("kingwolf-exp:init", src, CurrentXP, CurrentRank, false)
    end
end)

-- Set the current player XP
RegisterNetEvent("kingwolf-exp:setXP")
AddEventHandler("kingwolf-exp:setXP", function(xp)
    UpdatePlayer(source, xp)
end)

-- Fetch Players Data
RegisterNetEvent("kingwolf-exp:getPlayerData")
AddEventHandler("kingwolf-exp:getPlayerData", function()
    local _source = source
    TriggerClientEvent("kingwolf-exp:setPlayerData", _source, GetOnlinePlayers(_source, {}))
end)

RegisterNetEvent("kingwolf-exp:setInitial")
AddEventHandler("kingwolf-exp:setInitial", function(playerId, XPInit)
    if IsInt(XPInit) then
        UpdatePlayer(playerId, XPInit)
    end
end)

RegisterNetEvent("kingwolf-exp:addXP")
AddEventHandler("kingwolf-exp:addXP", function(playerId, XPAdd)
    local src = source
	local Player = Framework.Functions.GetPlayer(playerId)

    if Player ~= nil then
        CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0
        if IsInt(XPAdd) then
            local NewXP = tonumber(CurrentXP) + XPAdd
            UpdatePlayer(playerId, NewXP)
        end
    end
    -- local xPlayer = ESX.GetPlayerFromId(playerId)

    -- if xPlayer ~= nil then
    --     if IsInt(XPAdd) then
    --         local NewXP = tonumber(xPlayer.get("xp")) + XPAdd
    --         UpdatePlayer(playerId, NewXP)
    --     end
    -- end
end)

RegisterNetEvent("kingwolf-exp:removeXP")
AddEventHandler("kingwolf-exp:removeXP", function(playerId, XPRemove)
    local src = source
	local Player = Framework.Functions.GetPlayer(playerId)

    if Player ~= nil then
        CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0
        CurrentRank = Player.PlayerData.metadata["currentrank"]  ~= nil and Player.PlayerData.metadata["currentrank"] or 0
        if IsInt(XPRemove) then
            local NewXP = tonumber(CurrentXP) - XPRemove
            UpdatePlayer(playerId, NewXP)
        end
    end
    -- local xPlayer = ESX.GetPlayerFromId(playerId)

    -- if xPlayer ~= nil then
    --     if IsInt(XPRemove) then
    --         local NewXP = tonumber(xPlayer.get("xp")) - XPRemove
    --         UpdatePlayer(playerId, NewXP)
    --     end
    -- end
end)

RegisterNetEvent("kingwolf-exp:setRank")
AddEventHandler("kingwolf-exp:setRank", function(playerId, Rank)
    local GoalRank = tonumber(Rank)

    if not GoalRank then
        --
    else
        if Config.Ranks[GoalRank] ~= nil then
            UpdatePlayer(playerId, tonumber(Config.Ranks[GoalRank].XP))
        end
    end
end)


------------------------------------------------------------
--                    ADMIN COMMANDS                      --
------------------------------------------------------------

function DisplayError(playerId, message)
    TriggerClientEvent('chat:addMessage', playerId, {
        color = { 255, 0, 0 },
        args = { "kingwolf-exp", message }
    })    
end
 
Framework.Commands.Add("esxp_give", "Give EXP cho người chơi", {{name="id", help="ID người chơi"}, {name="exp", help="EXP"}}, false, function(source, args)
    local playerId = tonumber(args[1])
	local Player = Framework.Functions.GetPlayer(playerId)
    
    if Player == nil then
        return DisplayError(source, _('err_invalid_player'))
    end

    CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0

    local xp = tonumber(args[2])

    if not xp then
        return DisplayError(source, _('err_invalid_type', "XP", 'integer'))
    end

    UpdatePlayer(playerId, tonumber(CurrentXP) + xp)
end, 'admin')

Framework.Commands.Add("esxp_take", "Xóa EXP cho người chơi", {{name="id", help="ID người chơi"}, {name="exp", help="EXP"}}, false, function(source, args)
    local playerId = tonumber(args[1])
    local Player = Framework.Functions.GetPlayer(playerId)
    
    if Player == nil then
        return DisplayError(source, _('err_invalid_player'))
    end

    CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0

    local xp = tonumber(args[2])

    if not xp then
        return DisplayError(source, _('err_invalid_type', "XP", 'integer'))
    end    
    
    UpdatePlayer(playerId, tonumber(CurrentXP) - xp)
end, 'admin')

Framework.Commands.Add("esxp_set", "Give EXP cho người chơi", {{name="id", help="ID người chơi"}, {name="exp", help="EXP"}}, false, function(source, args)
    local playerId = tonumber(args[1])
    local Player = Framework.Functions.GetPlayer(playerId)
    
    if Player == nil then
        return DisplayError(source, _('err_invalid_player'))
    end

    local xp = tonumber(args[2])

    if not xp then
        return DisplayError(source, _('err_invalid_type', "XP", 'integer'))
    end  

    UpdatePlayer(playerId, xp)
end, 'admin')

Framework.Commands.Add("esxp_rank", "Give EXP cho người chơi", {{name="id", help="ID người chơi"}, {name="rank", help="Cấp bậc"}}, false, function(source, args)
    local playerId = tonumber(args[1])
    local Player = Framework.Functions.GetPlayer(playerId)
    
    if Player == nil then
        return DisplayError(source, _('err_invalid_player'))
    end

    local goalRank = tonumber(args[2])

    if not goalRank then
        return DisplayError(source, _('err_invalid_type', "Rank", 'integer'))
    end

    if goalRank < 1 or goalRank > #Config.Ranks then
        return DisplayError(source, _('err_invalid_rank', #Config.Ranks))
    end

    local xp = Config.Ranks[goalRank].XP

    UpdatePlayer(playerId, xp)
end, 'admin')

-- RegisterCommand("esxp_give", function(source, args, rawCommand)
    -- local playerId = tonumber(args[1])
	-- local Player = Framework.Functions.GetPlayer(playerId)
    
    -- if Player == nil then
    --     return DisplayError(source, _('err_invalid_player'))
    -- end

    -- CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0

    -- local xp = tonumber(args[2])

    -- if not xp then
    --     return DisplayError(source, _('err_invalid_type', "XP", 'integer'))
    -- end

    -- UpdatePlayer(playerId, tonumber(CurrentXP) + xp)
-- end, true)

-- RegisterCommand("esxp_take", function(source, args, rawCommand)
--     local playerId = tonumber(args[1])
--     local Player = Framework.Functions.GetPlayer(playerId)
    
--     if Player == nil then
--         return DisplayError(source, _('err_invalid_player'))
--     end

--     CurrentXP = Player.PlayerData.metadata["currentxp"]  ~= nil and Player.PlayerData.metadata["currentxp"] or 0

--     local xp = tonumber(args[2])

--     if not xp then
--         return DisplayError(source, _('err_invalid_type', "XP", 'integer'))
--     end    
    
--     UpdatePlayer(playerId, tonumber(CurrentXP) - xp)
-- end, true) 

-- RegisterCommand("esxp_set", function(source, args, rawCommand)
--     local playerId = tonumber(args[1])
--     local Player = Framework.Functions.GetPlayer(playerId)
    
--     if Player == nil then
--         return DisplayError(source, _('err_invalid_player'))
--     end

--     local xp = tonumber(args[2])

--     if not xp then
--         return DisplayError(source, _('err_invalid_type', "XP", 'integer'))
--     end  

--     UpdatePlayer(playerId, xp)
-- end, true)

-- RegisterCommand("esxp_rank", function(source, args, rawCommand)
--     local playerId = tonumber(args[1])
--     local Player = Framework.Functions.GetPlayer(playerId)
    
--     if Player == nil then
--         return DisplayError(source, _('err_invalid_player'))
--     end

--     local goalRank = tonumber(args[2])

--     if not goalRank then
--         return DisplayError(source, _('err_invalid_type', "Rank", 'integer'))
--     end

--     if goalRank < 1 or goalRank > #Config.Ranks then
--         return DisplayError(source, _('err_invalid_rank', #Config.Ranks))
--     end

--     local xp = Config.Ranks[goalRank].XP

--     UpdatePlayer(playerId, xp)
-- end, true)