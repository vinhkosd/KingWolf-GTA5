------------------------------------------------------------
--                      MAIN EVENTS                       --
------------------------------------------------------------

-- CHECK RESOURCE IS READY
AddEventHandler('kingwolf-exp:isReady', function(cb)
    cb(Ready)
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     if not Ready then
        TriggerServerEvent("kingwolf-exp:load")
    end
     LoggedIn = true
 end)
end)

-- INITIALISE RESOURCE
RegisterNetEvent("kingwolf-exp:init")
AddEventHandler("kingwolf-exp:init", function(_xp, _rank, players)

    local Ranks = CheckRanks()

    -- All ranks are valid
    if #Ranks == 0 then
        CurrentXP = tonumber(_xp)
        CurrentRank = tonumber(_rank)

        local cfg = CloneTable(Config)
        
        
        for _, v in ipairs(cfg.Ranks) do
            v.Action = nil
        end

        local data = {
            xpm_init = true,
            xpm_config = cfg,
            currentID = GetPlayerServerId(PlayerId()),
            xp = CurrentXP
        }
    
        if Config.Leaderboard.Enabled and players then
            data.leaderboard = true
            data.players = players

            for k, v in pairs(players) do
                if v.current then
                    Player = v
                end
            end        
    
            Players = players                       
        end
    
        -- Update UI
        SendNUIMessage(data)

    
        -- Native stats
        StatSetInt("MPPLY_GLOBALXP", CurrentXP, 1)

        -- Resource is ready to be used
        Ready = true
    else
        TriggerEvent("kingwolf-exp:print", _('err_lvls_check', #Ranks, 'Config.Ranks'))
    end
end)

RegisterNetEvent("kingwolf-exp:update")
AddEventHandler("kingwolf-exp:update", function(_xp, _rank)

    local oldRank = CurrentRank
    local newRank = _rank
    local newXP = _xp

    SendNUIMessage({
        xpm_set = true,
        xp = newXP
    })

    CurrentXP = newXP
    CurrentRank = newRank
end)

if Config.Leaderboard.Enabled then
    RegisterNetEvent("kingwolf-exp:setPlayerData")
    AddEventHandler("kingwolf-exp:setPlayerData", function(players)

        -- Remove disconnected players
        for i=#Players,1,-1 do
            local active = PlayerIsActive(players, Players[i].id)

            if not Players[i].fake then
                if not active then
                    table.remove(Players, i)
                end
            end
        end

        -- Add new players
        for k, v in pairs(players) do
            local active = PlayerIsActive(Players, v.id)

            if not active then
                table.insert(Players, v)
            else
                Players[active] = v
            end

            if v.current then
                Player = v
            end            
        end

        -- Update leaderboard
        SendNUIMessage({
            xpm_updateleaderboard = true,
            xpm_players = Players
        })
    end)
end

-- UPDATE UI
RegisterNetEvent("kingwolf-exp:updateUI")
AddEventHandler("kingwolf-exp:updateUI", function(_xp)
    CurrentXP = tonumber(_xp)

    SendNUIMessage({
        xpm_set = true,
        xp = CurrentXP
    })
end)

-- SET INTITIAL XP
RegisterNetEvent("kingwolf-exp:SetInitial")
AddEventHandler('kingwolf-exp:SetInitial', ESXP_SetInitial)

-- ADD XP
RegisterNetEvent("kingwolf-exp:Add")
AddEventHandler('kingwolf-exp:Add', ESXP_Add)

-- REMOVE XP
RegisterNetEvent("kingwolf-exp:Remove")
AddEventHandler('kingwolf-exp:Remove', ESXP_Remove)

RegisterNetEvent("kingwolf-exp:SetRank")
AddEventHandler('kingwolf-exp:SetRank', ESXP_SetRank)

-- RANK CHANGE NUI CALLBACK
RegisterNUICallback('xpm_rankchange', function(data, cb)
    if data.rankUp then
        TriggerEvent("kingwolf-exp:rankUp", data.current, data.previous)
    else
        TriggerEvent("kingwolf-exp:rankDown", data.current, data.previous)      
    end
    
    local Rank = Config.Ranks[data.current]

    if Rank.Action ~= nil and type(Rank.Action) == "function" then
        Rank.Action(Framework.Functions.GetPlayerData(), data.rankUp, data.previous)
    end

    cb(data)
end)

-- UI CHANGE
RegisterNUICallback('xpm_uichange', function(data, cb)
    UIActive = false

    cb(data)
end)

-- Error Printing
RegisterNetEvent("kingwolf-exp:print")
AddEventHandler("kingwolf-exp:print", function(message)
    local s = string.rep("=", string.len(message))
    print(s)
    print(message)
    print(s)           
end)