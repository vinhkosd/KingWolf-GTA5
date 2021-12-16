local BedData = nil
local BedCam = nil
local onDuty = false
local CurrentGarage = nil
local DutyBlips = {}
isLoggedIn = false

Framework = nil  

doctorCount = 0

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
    TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
      Framework.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] then
         SetState('death', true)
        else
         SetEntityHealth(PlayerPedId(), PlayerData.metadata["health"])
        end
         isLoggedIn = true
         PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
         TriggerServerEvent("pepe-hospital:server:UpdateBlips")
		 TriggerServerEvent("pepe-hospital:server:SetDoctor")
     end)
    end) 
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
 TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
 isLoggedIn = false
 if PlayerJob.name == 'ambulance' then
    TriggerServerEvent("Framework:ToggleDuty", false)
    if DutyBlips ~= nil then 
      for k, v in pairs(DutyBlips) do
          RemoveBlip(v)
      end
      DutyBlips = {}
    end
  end
 onDuty = PlayerData.job.onduty
end)

RegisterNetEvent('Framework:Client:SetDuty')
AddEventHandler('Framework:Client:SetDuty', function(Onduty)
    TriggerServerEvent("pepe-hospital:server:UpdateBlips")
    onDuty = Onduty
    TriggerServerEvent("pepe-hospital:server:SetDoctor")
    if not Onduty then
        if PlayerJob ~= nil then
            if PlayerJob.name == 'ambulance' then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
            DutyBlips = {}
            end
        end
    end
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob, onDuty = JobInfo, JobInfo.onduty
    TriggerServerEvent("pepe-hospital:server:SetDoctor")
    TriggerServerEvent("pepe-hospital:server:UpdateBlips")
    if (PlayerJob ~= nil) and PlayerJob.name ~= 'ambulance' then
        if DutyBlips ~= nil then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('pepe-hospital:client:UpdateBlips')
AddEventHandler('pepe-hospital:client:UpdateBlips', function(players)
    if PlayerJob ~= nil and PlayerJob.name == 'ambulance' and onDuty then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if players ~= nil then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                    CreateDutyBlips(id, data.label, data.job)
                end
            end
        end
	end
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            Citizen.Wait(20000)
            TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearSomething = false

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'], true) < 1.5) then
                if (Framework.Functions.GetPlayerData().job.name == "ambulance") then
                  DrawMarker(2, Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  NearSomething = true
                  if not onDuty then
                    Framework.Functions.DrawText3D(Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'] + 0.15, _U("induty"))
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("Framework:ToggleDuty", true)
                    end
                else
                    Framework.Functions.DrawText3D(Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'] + 0.15, _U("outduty"))
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("Framework:ToggleDuty", false)
                    end
                end
                end
            end

            if onDuty then

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'], true) < 1.5) then
                 if (Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
                   Framework.Functions.DrawText3D(Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'] + 0.15, _U("emscloset"))
                   DrawMarker(2, Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                   NearSomething = true
                   if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("pepe-inventory:server:OpenInventory", "shop", "hospital", Config.Items)
                   end
                 end
             end

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'], true) < 1.5) then
                if (Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
                  Framework.Functions.DrawText3D(Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'] + 0.15, _U("emsstash"))
                  DrawMarker(2, Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  NearSomething = true
                  if IsControlJustReleased(0, 38) then
                    local Other = {maxweight = 2000000, slots = 200}
                    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "hospital", Other)
                    TriggerEvent("pepe-inventory:client:SetCurrentStash", "hospital")
                  end
                end
             end
 
             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Boss"][1]['X'], Config.Locations["Boss"][1]['Y'], Config.Locations["Boss"][1]['Z'], true) < 1.5) then
                if (Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
                  Framework.Functions.DrawText3D(Config.Locations["Boss"][1]['X'], Config.Locations["Boss"][1]['Y'], Config.Locations["Boss"][1]['Z'] + 0.15, _U("ebossmenu"))
                  DrawMarker(2, Config.Locations["Boss"][1]['X'], Config.Locations["Boss"][1]['Y'], Config.Locations["Boss"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  NearSomething = true
                  if IsControlJustReleased(0, 38) then

                    TriggerServerEvent("pepe-bossmenu:server:openMenu")
                  end
                end
             end
                         
            end

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'], true) < 1.5) then
                if doctorCount >= Config.MinimalDoctors then
                    Framework.Functions.DrawText3D(Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'] + 0.15, _U("roepdokter"))
                    DrawMarker(2, Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                else
                    Framework.Functions.DrawText3D(Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'] + 0.15, _U("checkin"))
                    DrawMarker(2, Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                end    
             NearSomething = true
             if IsControlJustReleased(0, 38) then
                if doctorCount >= Config.MinimalDoctors then
                    TriggerServerEvent("pepe-hospital:server:SendDoctorAlert")
                    Framework.Functions.Notify('Xin vui lòng chờ, ai đó sẽ đi cùng', 'success')
                    Citizen.Wait(10000)
                else        
                    local BedSomething = GetAvailableBed()
                    if BedSomething ~= nil or BedSomething ~= false then
                        TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
                        Framework.Functions.Progressbar("lockpick-door", _U("checkinprogres"), 2500, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            TriggerEvent('pepe-hospital:client:send:to:bed', BedSomething)
						    TriggerServerEvent("pepe-hospital:server:hospital:respawn")
                        end, function() -- Cancel
                            Framework.Functions.Notify(_U("cancel"), "error")
                        end)
                    else
                        Framework.Functions.Notify(_U("allbedstaken"), 'error')
                    end
                end    
     end
    end

            -- if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], true) < 1.5) then
            --     Framework.Functions.DrawText3D(Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'] + 0.15, _U("upstairs"))
            --     DrawMarker(2, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            --     NearSomething = true
            --     if IsControlJustReleased(0, 38) then
            --         DoScreenFadeOut(450)
            --         Citizen.Wait(450)
            --         TriggerEvent("pepe-sound:client:play", "hospital-elevator", 0.25)
            --         SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'])
            --         Citizen.Wait(250)
            --         DoScreenFadeIn(450)
            --     end
            -- end

            -- if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], true) < 1.5) then
            --     Framework.Functions.DrawText3D(Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'] + 0.15, _U("downstairs"))
            --     DrawMarker(2, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            --     NearSomething = true
            --     if IsControlJustReleased(0, 38) then
            --         DoScreenFadeOut(450)
            --         Citizen.Wait(450)
            --         TriggerEvent("pepe-sound:client:play", "hospital-elevator", 0.25)
            --         SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'])
            --         Citizen.Wait(250)
            --         DoScreenFadeIn(450)
            --     end
            -- end

            -- if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], true) < 1.5) then
            --     Framework.Functions.DrawText3D(Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'] + 0.15, _U("upstairs"))
            --     DrawMarker(2, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            --     NearSomething = true
            --     if IsControlJustReleased(0, 38) then
            --         DoScreenFadeOut(450)
            --         Citizen.Wait(450)
            --         TriggerEvent("pepe-sound:client:play", "hospital-elevator", 0.25)
            --         SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'])
            --         Citizen.Wait(250)
            --         DoScreenFadeIn(450)
            --     end
            -- end
            
            -- if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], true) < 1.5) then
            --     Framework.Functions.DrawText3D(Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'] + 0.15, _U("downstairs"))
            --     DrawMarker(2, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            --     NearSomething = true
            --     if IsControlJustReleased(0, 38) then
            --         DoScreenFadeOut(450)
            --         Citizen.Wait(450)
            --         TriggerEvent("pepe-sound:client:play", "hospital-elevator", 0.25)
            --         SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'])
            --         Citizen.Wait(250)
            --         DoScreenFadeIn(450)
            --     end
            -- end

            if not NearSomething then
                Citizen.Wait(1500)
            end

        end
    end
end)


RegisterNetEvent('pepe-hospital:client:SendAlert')
AddEventHandler('pepe-hospital:client:SendAlert', function(msg)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent("chatMessage", "PAGER", "error", msg)
end)

RegisterNetEvent('pepe-hospital:client:SendBillEmail')
AddEventHandler('pepe-hospital:client:SendBillEmail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "nam"
        if Framework.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "nữ"
        end
        local charinfo = Framework.Functions.GetPlayerData().charinfo
        TriggerServerEvent('pepe-phone:server:sendNewMail', {
            sender = "Bệnh viện",
            subject = "Chi phí bệnh viện",
            message = "Chào bạn " .. gender .. " " .. charinfo.lastname .. ",<br /><br />Bạn sẽ nhận được một e-mail với chi phí của chuyến thăm bệnh viện cuối cùng.<br />Các chi phí cuối cùng : <strong>$"..amount.."</strong><br /><br />Lời chúc tốt nhất!",
            button = {}
        })
    end)
end)


-- // Events \\ --

RegisterNetEvent('pepe-hospital:client:SetDoctorCount')
AddEventHandler('pepe-hospital:client:SetDoctorCount', function(amount)
    doctorCount = amount
end)

RegisterNetEvent('pepe-hospital:SetDoctorsCount')
AddEventHandler('pepe-hospital:SetDoctorsCount', function(Amount)
    doctorCount = Amount
end)

RegisterNetEvent('pepe-hospital:client:revive')
AddEventHandler('pepe-hospital:client:revive', function(UseAnim, IsAdmin)
    if Config.IsDeath then
      SetState('death', false)
      SetEntityInvincible(PlayerPedId(), false)
      NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId(), true), true, true, false)   
    end
    ResetBodyHp()
    ResetScreenAndWalk()
    ClearPedTasks(PlayerPedId())
    SetEntityHealth(PlayerPedId(), 200)
    ClearPedBloodDamage(PlayerPedId())
    SetPlayerSprint(PlayerId(), true)
    if UseAnim then
     TriggerEvent('pepe-hospital:client:revive:anim')
    end
     TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + 85)
     TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + 85)  

    TriggerServerEvent('pepe-hud:server:remove:stress', 100)
    TriggerEvent('pepe-police:client:set:escort:status:false')
    Framework.Functions.Notify("Bạn đã được hồi sinh", 'success')
end)

RegisterNetEvent('pepe-hospital:client:heal:closest')
AddEventHandler('pepe-hospital:client:heal:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 4.5 then
        if not IsTargetDead(GetPlayerServerId(Player)) then
           HealAnim(RandomTime)
           Framework.Functions.Progressbar("healing-citizen", _U("healcitizen"), RandomTime, false, true, {
               disableMovement = true,
               disableCarMovement = true,
               disableMouse = false,
               disableCombat = true,
           }, {}, {}, {}, function() -- Done
               TriggerServerEvent('pepe-hospital:server:heal:player', GetPlayerServerId(Player))
               Framework.Functions.Notify(_U("healciti"), "success")
           end, function() -- Cancel
               Framework.Functions.Notify(_U("cancel"), "error")
           end)
        else
            Framework.Functions.Notify(_U("citizenc"), "error")
        end
    end
end)

RegisterNetEvent('pepe-hospital:client:revive:closest')
AddEventHandler('pepe-hospital:client:revive:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 2.5 then
      if IsTargetDead(GetPlayerServerId(Player)) then
         Framework.Functions.Progressbar("hospital_revive", _U("healcitizen"), RandomTime, false, true, {
             disableMovement = false,
             disableCarMovement = false,
             disableMouse = false,
             disableCombat = true,
         }, {
             animDict = 'mini@cpr@char_a@cpr_str',
             anim = 'cpr_pumpchest',
             flags = 8,
         }, {}, {}, function() -- Done
             TriggerServerEvent('pepe-hospital:server:revive:player', GetPlayerServerId(Player))
             StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
             Framework.Functions.Notify(_U("citizenc"))
         end, function() -- Cancel
             StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
             Framework.Functions.Notify(_U("failed"), "error")
         end)
        else
            Framework.Functions.Notify(_U("citizenc"), "error")
        end
    end
end)

RegisterNetEvent('pepe-hospital:client:bring:ped:closest')
AddEventHandler('pepe-hospital:client:bring:ped:closest', function()
    Framework.Functions.TriggerCallback('pepe-hospital:server:get:cooldown', function(cooldown)
        if cooldown > 0 then
            local remainingseconds = (cooldown) / 1000
            local hoursRemaining = math.floor(remainingseconds/3600)
            local minutesRemaining = math.floor((remainingseconds - hoursRemaining * 3600)/60)
            local secondsRemaining = math.floor((remainingseconds - hoursRemaining * 3600 - minutesRemaining * 60))
            
            local remainingTimeText = hoursRemaining.." giờ, "..minutesRemaining.." phút, "..secondsRemaining.." giây"
            Framework.Functions.Notify("Vui lòng chờ thêm 5 phút (còn "..remainingTimeText.." )", "error")
            return
        end

        coords = GetEntityCoords(GetPlayerPed(-1))
        local playersInRange = Framework.Functions.GetPlayersFromCoords(coords, 100.0)
        local countDeathPlayer = 0
        for i=1, #playersInRange, 1 do
            if countDeathPlayer >= 3 then
                break
            end
            if playersInRange[i] ~= PlayerId() and playersInRange[i] ~= -1 then
                local pos = GetEntityCoords(GetPlayerPed(playersInRange[i]))

                if IsTargetDead(GetPlayerServerId(playersInRange[i])) then
                    countDeathPlayer = countDeathPlayer + 1
                    local closestPlayer = playersInRange[i]
                    TriggerServerEvent('pepe-admin:server:bringTp', GetPlayerServerId(playersInRange[i]), coords)
                    -- TriggerEvent("pepe-police:client:get:escorted", GetPlayerServerId(PlayerId()))
                end
            end
        end
        if countDeathPlayer == 0 then
            Framework.Functions.Notify("Không tìm thấy xác người chơi nào", "info")
        else
            TriggerServerEvent('pepe-hospital:server:create:cooldown')
            Framework.Functions.Notify("Đã kéo xác "..countDeathPlayer.." người chơi tới vị trí của bạn", "success")
        end
        
    end)
end)

RegisterNetEvent('pepe-hospital:client:bring:ped')
AddEventHandler('pepe-hospital:client:bring:ped', function(targetId)
    coords = GetEntityCoords(GetPlayerPed(-1))
    local countDeathPlayer = 0
    if IsTargetDead(targetId) then
        countDeathPlayer = countDeathPlayer + 1
        local pos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(targetId)))
        local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)
        if distance > 100.0 then
            Framework.Functions.Notify("Khoảng cách quá xa để kéo người chơi!", "info")
            return
        else
            TriggerServerEvent('pepe-hospital:server:create:cooldown')
            TriggerServerEvent('pepe-admin:server:bringTp', targetId, coords)
            -- TriggerEvent("pepe-police:client:get:escorted", GetPlayerServerId(PlayerId()))
        end
        
    else
        Framework.Functions.Notify("Không thấy người chơi bị chết!", "info")
        return
    end

    if countDeathPlayer == 0 then
        Framework.Functions.Notify("Không tìm thấy xác người chơi", "info")
    else
        Framework.Functions.Notify("Đã kéo xác "..countDeathPlayer.." người chơi tới vị trí của bạn", "success")
    end
end)

RegisterNetEvent('pepe-hospital:client:lagxac')
AddEventHandler('pepe-hospital:client:lagxac', function()
  if Framework.Functions.GetPlayerData().metadata["isdead"] then
    -- print("lagxac")
    -- local x, y, z = table.unpack( GetEntityCoords( playerPed, false ) )
    -- curLocation = { x = x, y = y, z = z }
    -- SetEntityCoords(GetPlayerPed(-1), curLocation.x, curLocation.y, curLocation.z + 0.5)
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GUARD_STAND", 0, true)
    Citizen.Wait(50)
    ClearPedTasksImmediately(GetPlayerPed(-1))
  end
end)

RegisterNetEvent('pepe-hospital:client:take:blood:closest')
AddEventHandler('pepe-hospital:client:take:blood:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local RandomTime = math.random(7500, 10500)
    if Player ~= -1 and Distance < 1.5 then
      HealAnim(RandomTime)
      Framework.Functions.Progressbar("healing-citizen", _U("takebsample"), RandomTime, false, true, {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      }, {}, {}, {}, function() -- Done
          TriggerServerEvent('pepe-hospital:server:take:blood:player', GetPlayerServerId(Player))
          Framework.Functions.Notify(_U("samplerecieved"), "success")
      end, function() -- Cancel
          Framework.Functions.Notify(_U("cancel"), "error")
      end)
    end
end)

RegisterNetEvent('pepe-hospital:client:heal')
AddEventHandler('pepe-hospital:client:heal', function()
    local CurrentHealth = GetEntityHealth(PlayerPedId())
    local NewHealth = CurrentHealth + 15.0
    if CurrentHealth + 15.0 > 100.0 then
        NewHealth = 100.0
    end
    ResetBodyHp()
    ClearPedTasks(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
    SetEntityHealth(PlayerPedId(), NewHealth)
end)

RegisterNetEvent('pepe-hospital:client:revive:anim')
AddEventHandler('pepe-hospital:client:revive:anim', function()
 exports['pepe-assets']:RequestAnimationDict("random@crash_rescue@help_victim_up")
 TaskPlayAnim(PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
 Citizen.Wait(1850)
 ClearPedSecondaryTask(PlayerPedId())
end)

RegisterNetEvent('pepe-hospital:client:set:bed:state')
AddEventHandler('pepe-hospital:client:set:bed:state', function(BedData, bool)
  Config.Beds[BedData]['Busy'] = bool
end)

RegisterNetEvent('pepe-hospital:client:send:to:bed')
AddEventHandler('pepe-hospital:client:send:to:bed', function(BedId)
    Citizen.SetTimeout(50, function()
        EnterBedCam(BedId)
        Framework.Functions.Notify(_U("recieving"), 'info')
        Citizen.Wait(25000)
        TriggerEvent('pepe-hospital:client:revive', false, false)
        LeaveBed()
    end)
end)

RegisterNetEvent('pepe-hospital:client:spawn:vehicle')
AddEventHandler('pepe-hospital:client:spawn:vehicle', function(VehicleName)
    print(VehicleName)
    if VehicleName ~= 'alifeliner' then
        local isSpawnPointClear = false
        for i = 1, #Config.Locations['Garage'][CurrentGarage]['Spawns'] do
            if isSpawnPointClear then
                break
            end
            local spawnCoords = Config.Locations['Garage'][CurrentGarage]['Spawns'][i]
            local CoordTable = {x = spawnCoords['X'], y = spawnCoords['Y'], z = spawnCoords['Z'], a = spawnCoords['H']}    
            if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
                isSpawnPointClear = true
                Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
                    Framework.Functions.TriggerCallback('kingwolf-common:server:registerPlate', function(canReg)
                        if not canReg then
                            Framework.Functions.Notify("Không thể đăng ký thông tin biển số xe.")
                        end
                    end, GetVehicleNumberPlateText(Vehicle))
                    print(GetVehicleNumberPlateText(Vehicle))
                    Citizen.Wait(25)
                    
                    exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
                    exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
                    exports['pepe-emergencylights']:SetupEmergencyVehicle(Vehicle)
                    Framework.Functions.Notify(_U("dutyparked"), 'info')
                    CurrentGarage = nil
                 end, CoordTable, true, false)
            end
        end

        if isSpawnPointClear == false then
            Framework.Functions.Notify('Khu vực lấy xe bị chặn.', 'error')
        end
      else
        --   local CoordTable = {x = 352.1589, y = -588.5424, z = 74.161727, a = 271.88894}
        -- local CoordTable = {x = 350.96, y = -587.61, z = 74.16, a = 262.49}
        local CoordTable = { x = -448.0578, y = -310.5629, z = 78.168098, a = 30.527843 }
        if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
            Framework.Functions.SpawnVehicle('alifeliner', function(Vehicle)
                --   Framework.Functions.SpawnVehicle('alifeliner', function(Vehicle)
                Framework.Functions.TriggerCallback('kingwolf-common:server:registerPlate', function(canReg)
                    if not canReg then
                        Framework.Functions.Notify("Không thể đăng ký thông tin biển số xe.")
                    end
                end, GetVehicleNumberPlateText(Vehicle))
                Citizen.Wait(25)
                exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
                exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
                Framework.Functions.Notify(_U("helilanded"), 'info')
                CurrentGarage = nil
                
                end, CoordTable, true, false)
        end
      end
end)

-- // Functions \\ --

function NearGarage()
  for k, v in pairs(Config.Locations['Garage']) do
      local PlayerCoords = GetEntityCoords(PlayerPedId())
      if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true) < 10.0) then
          CurrentGarage = k
          return true
      end
  end
end

function EnterBedCam(BedId)
    Config.IsInBed = true
    BedData = BedId
    TriggerServerEvent('pepe-hospital:server:set:bed:state', BedData, true)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end
    BedObject = GetClosestObjectOfType(Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'], 1.0, Config.Beds[BedData]['Hash'], false, false, false)
    SetEntityCoords(PlayerPedId(), Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'] + 0.02)
    Citizen.Wait(500)
    FreezeEntityPosition(PlayerPedId(), true)
    exports['pepe-assets']:RequestAnimationDict("misslamar1dead_body")
    TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(PlayerPedId(), Config.Beds[BedData]['H'])
    BedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(BedCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(BedCam, PlayerPedId(), 31085, 0, 1.0, 1.0 , true)
    SetCamFov(BedCam, 100.0)
    SetCamRot(BedCam, -45.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)
    DoScreenFadeIn(1000)
end

function LeaveBed()
    exports['pepe-assets']:RequestAnimationDict('switch@franklin@bed')
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityHeading(PlayerPedId(), Config.Beds[BedData]['H'] + 90)
    TaskPlayAnim(PlayerPedId(), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(PlayerPedId())
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(BedCam, false)
    TriggerServerEvent('pepe-hospital:server:set:bed:state', BedData, false)
    Config.IsInBed = false
end

function HealAnim(time)
  time = time / 1000
  exports['pepe-assets']:RequestAnimationDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
  TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor" ,3.0, 3.0, -1, 16, 0, false, false, false)
  Healing = true
  Citizen.CreateThread(function()
      while Healing do
          TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
          Citizen.Wait(2000)
          time = time - 2
          if time <= 0 then
              Healing = false
              StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
          end
      end
  end)
end

function ResetScreenAndWalk() 
    Citizen.SetTimeout(1500, function()
        SetFlash(false, false, 450, 3000, 450)
        Citizen.Wait(350)
        ClearTimecycleModifier()
        ResetPedMovementClipset(PlayerPedId(), 0)
    end)
end

function GetAvailableBed()
    for k, v in pairs(Config.Beds) do
        if not v['Busy'] then
            return k
        end
    end
end

function IsTargetDead(playerId)
 local IsDead = false
 local triggerSuccess = false
  Framework.Functions.TriggerCallback('pepe-police:server:is:player:dead', function(result)
    IsDead = result
    triggerSuccess = true
  end, playerId)
  
  while not triggerSuccess do
    Citizen.Wait(100)
  end

  return IsDead
end

function CreateDutyBlips(playerId, playerLabel, playerJob)
	local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 480)
        SetBlipScale(blip, 1.0)
        if playerJob == "police" then
            SetBlipColour(blip, 38)
        else
            SetBlipColour(blip, 35)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
		table.insert(DutyBlips, blip)
	end
end