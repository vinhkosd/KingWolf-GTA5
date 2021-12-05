CurrentXP = 0
CurrentRank = 0
Leaderboard = nil
Players = {}
Player = nil
UIActive = true
Ready = false

local Framework = nil

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)   

Citizen.CreateThread(function()

    -- if not Ready then
    --     TriggerServerEvent("kingwolf-exp:load")
    -- end
end)	

------------------------------------------------------------
--                        CONTROLS                        --
------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, Config.UIKey) then
            UIActive = not UIActive
            
            if UIActive then
                TriggerServerEvent("kingwolf-exp:getPlayerData")
                SendNUIMessage({
                    xpm_show = true,
                    xbm_lb = Config.Leaderboard
                })                 
            else
                SendNUIMessage({
                    xpm_hide = true
                })                
            end
        elseif IsControlJustPressed(0, 174) then
            if UIActive then
                SendNUIMessage({
                    xpm_lb_prev = true
                })
            end
        elseif IsControlJustPressed(0, 175) then
            if UIActive then
                SendNUIMessage({
                    xpm_lb_next = true
                })
            end
        end

        Citizen.Wait(1)
    end
end)


------------------------------------------------------------
--                        COMMANDS                        --
------------------------------------------------------------
TriggerEvent('chat:addSuggestion', '/exp', 'Xem thông tin kinh nghiêm')

RegisterCommand('exp', function(source, args)
    Citizen.CreateThread(function()
        local xpToNext = ESXP_GetXPToNextRank()

        -- SHOW THE XP BAR
        SendNUIMessage({ xpm_display = true })        

        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"SYSTEM", _('cmd_current_xp', CurrentXP)}
        })
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"SYSTEM", _('cmd_current_lvl', CurrentRank)}
        })
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"SYSTEM", _('cmd_next_lvl', xpToNext, CurrentRank + 1)}
        })                
    end)
end)