-- // Events \\ --
local CurrentDoctors = 0

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        if NetworkIsPlayerActive(PlayerId()) then      
            if IsEntityDead(PlayerPedId()) and not Config.IsDeath then
                SetState('death', true)
            else
                Citizen.Wait(100)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(4)
        if Config.IsDeath then
         DisableAllControlActions(0)
         EnableControlAction(0, 1, true)
         EnableControlAction(0, 2, true)
         DisableControlAction(0, 137, true)
         EnableControlAction(0, Config.Keys['T'], true)
         EnableControlAction(0, Config.Keys['E'], true)
         EnableControlAction(0, Config.Keys['ESC'], true)
         EnableControlAction(0, Config.Keys['F1'], true)
         EnableControlAction(0, Config.Keys['HOME'], true)
         EnableControlAction(0, Config.Keys['N'], true)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        if Config.IsDeath then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                exports['pepe-assets']:RequestAnimationDict("veh@low@front_ps@idle_duck")
                if not IsEntityPlayingAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 3) then
                    TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                else
                    Citizen.Wait(100)
                end
            else
                if Config.IsInBed then
                    if not IsEntityPlayingAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 3) then
                        exports['pepe-assets']:RequestAnimationDict("misslamar1dead_body")
                        TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    else
                        Citizen.Wait(100)
                    end
                else
                    if not IsEntityPlayingAnim(PlayerPedId(), "dead", "dead_a", 3) then
                        TaskPlayAnim(PlayerPedId(), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    else
                        Citizen.Wait(100)
                    end
                end
            end
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        else
            Citizen.Wait(2500)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
        if Config.IsDeath then
            if Config.Timer > 0 then
                DrawTxt(0.83, 1.44, 1.0,1.0,0.6, "HỒI SINH SAU: ~r~" .. math.ceil(Config.Timer) .. "~w~ GIÂY", 255, 255, 255, 255)
            elseif not Config.IsInBed then
                local textMatDo = CurrentDoctors == 0 and 'KHÔNG MẤT ĐỒ, KHÔNG CÓ BS ONLINE' or 'LƯU Ý MẤT ĐỒ SAU KHI NHẤN E'
                DrawTxt(0.76, 1.44, 1.0, 1.0, 0.6, "~w~ GIỮ ~r~[E] ("..Holding..")~w~ ĐỂ HỒI SINH ~r~($2000)~w~ ~r~("..textMatDo..")~s~", 255, 255, 255, 255)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- -- // Functions \\ --

function SetState(Type, bool)
 if Type ~= nil then
     if Type == 'death' then
         Config.IsDeath = bool
         Config.Timer = 5
         TriggerServerEvent("pepe-hospital:server:set:state", 'isdead', bool)
         if bool then
          DoDeathOnPlayer()
          StartTimer('death')
         end
     end
 end
end

function DoDeathOnPlayer()
    TriggerServerEvent("pepe-sound:server:play:source", "death", 0.1)
    TriggerEvent('pepe-inventory:client:close:inventory')
    TriggerEvent('pepe-radialmenu:client:force:close')
    while GetEntitySpeed(PlayerPedId()) > 0.5 or IsPedRagdoll(PlayerPedId()) do
        Citizen.Wait(10)
    end
    if Config.IsDeath then
      NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z + 0.5, GetEntityHeading(PlayerPedId()), true, false)
      SetEntityInvincible(PlayerPedId(), true)
      SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
      TriggerEvent('pepe-weapons:client:remove:dot')
      Citizen.Wait(450)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            exports['pepe-assets']:RequestAnimationDict("veh@low@front_ps@idle_duck")
            TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        else
            exports['pepe-assets']:RequestAnimationDict("dead")
            TaskPlayAnim(PlayerPedId(), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end
        TriggerEvent('pepe-hospital:call:ai')
    end
end

function StartTimer()
    Holding = 5
    while Config.IsDeath do
        Citizen.Wait(1000)
        Config.Timer = Config.Timer - 1
        if Config.Timer <= 0 then
            if IsControlPressed(0, Config.Keys["E"]) and Holding <= 0 and not Config.IsInBed then
                local BedSomething = GetAvailableBed()
                TriggerServerEvent('pepe-hospital:server:dead:respawn')
                TriggerEvent('pepe-hospital:client:send:to:bed', BedSomething)
                Holding = 5
            end
            if IsControlPressed(0, Config.Keys["E"]) then
                if Holding - 1 >= 0 then
                    Holding = Holding - 1
                else
                    Holding = 0
                end
            end
            if IsControlReleased(0, Config.Keys["E"]) then
                Holding = 5
            end
        end
    end
end

RegisterNetEvent('pepe-hospital:call:ai')
AddEventHandler('pepe-hospital:call:ai', function()
    local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end

    local closestPed, closestDistance = Framework.Functions.GetClosestPed(GetEntityCoords(PlayerPedId()), PlayerPeds)
    if closestDistance < 50.0 and closestPed ~= 0 then
        local rand = (math.random(6,9) / 100) + 0.3
        local rand2 = (math.random(6,9) / 100) + 0.3
        if math.random(10) > 5 then
            rand = 0.0 - rand
        end
        if math.random(10) > 5 then
            rand2 = 0.0 - rand2
        end
        local MoveTo = GetOffsetFromEntityInWorldCoords(PlayerPedId(), rand, rand2, 0.0)
        TaskGoStraightToCoord(closestPed, MoveTo, 2.5, -1, 0.0, 0.0)
        SetPedKeepTask(closestPed, true) 
        local dist = GetDistanceBetweenCoords(MoveTo, GetEntityCoords(closestPed), false)
        while dist > 3.5 and Config.IsDeath do
            TaskGoStraightToCoord(closestPed, MoveTo, 2.5, -1, 0.0, 0.0)
            dist = GetDistanceBetweenCoords(MoveTo, GetEntityCoords(closestPed), false)
            Citizen.Wait(100)
        end
        ClearPedTasksImmediately(closestPed)
        TaskLookAtEntity(closestPed, PlayerPedId(), 5500.0, 2048, 3)
        TaskTurnPedToFaceEntity(closestPed, PlayerPedId(), 5500)
        Citizen.Wait(3000)
        exports['pepe-assets']:RequestAnimationDict("cellphone@")
        TaskPlayAnim(closestPed, "cellphone@", "cellphone_call_listen_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
        SetPedKeepTask(closestPed, true) 
        Citizen.Wait(5000)

        TriggerServerEvent("pepe-police:server:send:alert:dead", GetEntityCoords(PlayerPedId()), Framework.Functions.GetStreetLabel())
        SetEntityAsNoLongerNeeded(closestPed)
        ClearPedTasks(closestPed)
    end
end)

function GetDeathStatus()
    return Config.IsDeath
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
 SetTextFont(4)
 SetTextProportional(0)
 SetTextScale(scale, scale)
 SetTextColour(r, g, b, a)
 SetTextDropShadow(0, 0, 0, 0,255)
 SetTextEdge(2, 0, 0, 0, 255)
 SetTextDropShadow()
 SetTextOutline()
 SetTextEntry("STRING")
 AddTextComponentString(text)
 DrawText(x - width/2, y - height/2 + 0.005)
end


RegisterNetEvent('pepe-hospital:SetDoctorsCount')
AddEventHandler('pepe-hospital:SetDoctorsCount', function(Amount)
    CurrentDoctors = Amount
end)