local isLoggedIn = false
local ActiveParticles = {}
Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
	 Citizen.Wait(250)
     isLoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('pepe-carwash:client:sync:water')
AddEventHandler('pepe-carwash:client:sync:water', function(WaterId)
    StartWashParticle(WaterId)
end)

RegisterNetEvent('pepe-carwash:client:stop:water')
AddEventHandler('pepe-carwash:client:stop:water', function(WaterId)
    StopWashParticle(WaterId)
end)

-- Code

-- // Event \\ --

RegisterNetEvent('pepe-carwash:client:set:busy')
AddEventHandler('pepe-carwash:client:set:busy', function(CarWashId, bool)
 Config.CarWashLocations[CarWashId]['Busy'] = bool
end)

RegisterNetEvent('pepe-carwash:client:sync:wash')
AddEventHandler('pepe-carwash:client:sync:wash', function(Vehicle)
    SetVehicleDirtLevel(Vehicle, 0.0)
end)


-- // Loops \\ --

Citizen.CreateThread(function()
    Citizen.Wait(1500)
    while true do   
        Citizen.Wait(0)
        if isLoggedIn then
            for k, v in pairs(Config.CarWashLocations) do
              local Positie = GetEntityCoords(GetPlayerPed(-1))
			  local Gebied = GetDistanceBetweenCoords(Positie.x, Positie.y, Positie.z, Config.CarWashLocations[k]['Coords']['Marker']['X'], Config.CarWashLocations[k]['Coords']['Marker']['Y'], Config.CarWashLocations[k]['Coords']['Marker']['Z'], true)
              if Gebied <= 2.5 then   
                 if Gebied <= 1.5 then
                     DrawText3D(Config.CarWashLocations[k]['Coords']['Marker']['X'], Config.CarWashLocations[k]['Coords']['Marker']['Y'], Config.CarWashLocations[k]['Coords']['Marker']['Z'], '~g~G~w~ - Rửa xe €'..Config.CarWashLocations[k]['Price'])
                     if IsControlJustReleased(0, Config.Keys['G']) then
                        if not Config.CarWashLocations[k]['Busy'] then
                            Framework.Functions.TriggerCallback("pepe-carwash:server:can:wash", function(CanWash)
                            if CanWash then
                             StartCarWashing(k, GetVehiclePedIsIn(GetPlayerPed(-1), false))
                            else
                             Framework.Functions.Notify('Bạn không đủ tiền rửa xe..', 'error')
                            end
                        end, Config.CarWashLocations[k]['Price'])
                        else
                         Framework.Functions.Notify('Vui lòng chờ tới lượt!..', 'error')
                        end
                     end
                    elseif Gebied <= 2.0 then
                     DrawText3D(Config.CarWashLocations[k]['Coords']['Marker']['X'], Config.CarWashLocations[k]['Coords']['Marker']['Y'], Config.CarWashLocations[k]['Coords']['Marker']['Z'], 'Rửa xe')
                 end
                   DrawMarker(2, Config.CarWashLocations[k]['Coords']['Marker']['X'], Config.CarWashLocations[k]['Coords']['Marker']['Y'], Config.CarWashLocations[k]['Coords']['Marker']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)    
                else
                    Citizen.Wait(350)
                end
            end
        end
    end
end)

-- // Functions \\ --

function StartCarWashing(CarWashId, Vehicle)
 SetVehicleDirtLevel(Vehicle, 10.0)
 TriggerServerEvent('pepe-carwash:server:set:busy', CarWashId, true) 
 SetEveryoneIgnorePlayer(PlayerPedId(), true)
 SetPlayerControl(PlayerPedId(), false)
 Wait(250)
 TriggerServerEvent('pepe-carwash:server:sync:water', Config.CarWashLocations[CarWashId]['Particle'])
 TaskVehicleDriveToCoord(PlayerPedId(), Vehicle, Config.CarWashLocations[CarWashId]['Coords']['GoTo']['X'], Config.CarWashLocations[CarWashId]['Coords']['GoTo']['Y'], Config.CarWashLocations[CarWashId]['Coords']['GoTo']['Z'], 5.0, 0.0, GetEntityModel(Vehicle), 262144, 1.0, 1000.0)
 Citizen.Wait(Config.CarWashLocations[CarWashId]['Wait'] / 2)
 TriggerServerEvent('pepe-carwash:server:sync:wash', Vehicle)
 SetVehicleDirtLevel(Vehicle, 0.0)
 Wait(100)
 TriggerServerEvent("pepe-carwash:server:SaveVehicleProps", Framework.Functions.GetVehicleProperties(Vehicle))
 Citizen.Wait(Config.CarWashLocations[CarWashId]['Wait'] / 2)
 TriggerServerEvent('pepe-carwash:server:stop:water', Config.CarWashLocations[CarWashId]['Particle'])
 SetPlayerControl(PlayerPedId(), true)
 TriggerServerEvent('pepe-carwash:server:set:busy', CarWashId, false) 
end

function StartWashParticle(ParticleName)
 if Config.Particles[ParticleName] ~= nil then
     for k, v in pairs(Config.Particles[ParticleName]) do
      RequestNamedPtfxAsset("scr_carwash")
      UseParticleFxAssetNextCall("scr_carwash")
      while not HasNamedPtfxAssetLoaded("scr_carwash") do
          Wait(100)
      end
      local CarWashParticle = StartParticleFxLoopedAtCoord(Config.Particles[ParticleName][k]['particle'], Config.Particles[ParticleName][k]['X'], Config.Particles[ParticleName][k]['Y'], Config.Particles[ParticleName][k]['Z'], Config.Particles[ParticleName][k]['rotation'], 0.0, 0.0, 1.0, 0, 0, 0)
      table.insert(ActiveParticles, CarWashParticle)
     end
 end
end

function StopWashParticle(ParticleName)
 for k, v in ipairs(ActiveParticles) do
    StopParticleFxLooped(v, 0)
    RemoveParticleFx(v, 0)
    Citizen.Wait(150)
 end
end

function DrawText3D(x, y, z, text)
 SetTextScale(0.35, 0.35)
 SetTextFont(4)
 SetTextProportional(1)
 SetTextColour(255, 255, 255, 215)
 SetTextEntry("STRING")
 SetTextCentre(true)
 AddTextComponentString(text)
 SetDrawOrigin(x,y,z, 0)
 DrawText(0.0, 0.0)
 ClearDrawOrigin()
end