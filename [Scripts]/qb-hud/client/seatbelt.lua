local seatbeltOn = false
local harnessOn = false
local harnessHp = 20
local handbrake = 0
local sleep = 0
local harnessData = {}
local SpeedBuffer = {}
local vehVelocity = {x = 0.0, y = 0.0, z = 0.0}
local newvehicleBodyHealth = 0
local newvehicleEngineHealth = 0
local currentvehicleEngineHealth = 0
local currentvehicleBodyHealth = 0
local frameBodyChange = 0
local frameEngineChange = 0
local lastFrameVehiclespeed = 0
local lastFrameVehiclespeed2 = 0
local thisFrameVehicleSpeed = 0
local tick = 0
local damagedone = false
local modifierDensity = true

-- Register Key

-- RegisterCommand('toggleseatbelt', function()
--     if IsPedInAnyVehicle(PlayerPedId(), false) then
--         local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPedId()))
--         if class ~= 8 and class ~= 13 and class ~= 14 then
--             ToggleSeatbelt()
--         end
--     end
-- end, false)

-- RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', 'B')

-- Events

-- RegisterNetEvent('seatbelt:client:UseHarness') -- On Item Use (registered server side) 
-- AddEventHandler('seatbelt:client:UseHarness', function(ItemData)
--     local ped = PlayerPedId()
--     local inveh = IsPedInAnyVehicle(ped, false)
--     local class = GetVehicleClass(GetVehiclePedIsUsing(ped))
--     if inveh and class ~= 8 and class ~= 13 and class ~= 14 then
--         if not harnessOn then
--             LocalPlayer.state:set("inv_busy", true, true)
--             Framework.Functions.Progressbar("harness_equip", "Attaching Race Harness", 5000, false, true, {
--                 disableMovement = false,
--                 disableCarMovement = false,
--                 disableMouse = false,
--                 disableCombat = true,
--             }, {}, {}, {}, function()
--                 LocalPlayer.state:set("inv_busy", false, true)
--                 ToggleHarness()
--                 TriggerServerEvent('equip:harness', ItemData) 
--             end)
--             harnessHp = ItemData.info.uses
--             harnessData = ItemData
--         else
--             LocalPlayer.state:set("inv_busy", true, true)
--             Framework.Functions.Progressbar("harness_equip", "Removing Race Harness", 5000, false, true, {
--                 disableMovement = false,
--                 disableCarMovement = false,
--                 disableMouse = false,
--                 disableCombat = true,
--             }, {}, {}, {}, function()
--                 LocalPlayer.state:set("inv_busy", false, true)
--                 ToggleHarness()
--             end)
--         end
--     else
--         Framework.Functions.Notify('You\'re not in a car.', 'error')
--     end 
-- end)

-- -- Functions

-- function ToggleSeatbelt()
--     if seatbeltOn then
--         seatbeltOn = false
--         TriggerEvent("seatbelt:client:ToggleSeatbelt")
--         Framework.Functions.Notify('Seatbelt OFF', 'error')
--         TriggerEvent('LIFE_CL:Sound:PlayOnOne', 'seatbeltoff', 1.0)

--     else
--         seatbeltOn = true
--         TriggerEvent("seatbelt:client:ToggleSeatbelt")
--         Framework.Functions.Notify('Seatbelt ON', 'primary')
--         TriggerEvent('LIFE_CL:Sound:PlayOnOne', 'seatbelt', 1.0)
--     end
-- end

-- function ToggleHarness()
--     if harnessOn then
--         harnessOn = false
--     else
--         harnessOn = true
--         ToggleSeatbelt()
--     end
-- end

function ResetHandBrake()
    if handbrake > 0 then
        handbrake = handbrake - 1
    end
end

-- Export

function HasHarness()
    return harnessOn
end

-- Main Thread

CreateThread(function()
    while true do
        sleep = 1000
        if IsPedInAnyVehicle(PlayerPedId()) then
            sleep = 10
            if seatbeltOn or harnessOn then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end

            local prevSpeed = currSpeed
            currSpeed = GetEntitySpeed(vehicle)
            if poptires then
                local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                if vehIsMovingFwd  and vehAcc  then
                    PopTires()
                end
            end

            
        else
            
            seatbeltOn = false
            harnessOn = false

        end
        Wait(sleep)
    end
end)

-- CreateThread(function()
--     while true do
--         sleep = 1200
--         local playerPed = PlayerPedId()
--         local currentVehicle = GetVehiclePedIsIn(playerPed, false)
--         local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
        
--         if IsPedInAnyVehicle(playerPed) and driverPed then
--             if seatbeltOn or harnessOn then
--             else
--                 TriggerEvent('LIFE_CL:Sound:PlayOnOne', 'beltalarm', 0.5)
--             end
--         end
--         Wait(sleep)
--     end
-- end)

-- Ejection Logic

-- CreateThread(function()
--     while true do
--         Citizen.Wait(5)
--         local playerPed = PlayerPedId()
--         local currentVehicle = GetVehiclePedIsIn(playerPed, false)
--         local driverPed = GetPedInVehicleSeat(currentVehicle, -1) 
--         if currentVehicle ~= nil and currentVehicle ~= false and currentVehicle ~= 0 then
--             SetPedHelmet(playerPed, false)
--             lastVehicle = GetVehiclePedIsIn(playerPed, false)
--             if GetVehicleEngineHealth(currentVehicle) < 0.0 then
--                 SetVehicleEngineHealth(currentVehicle, 0.0)
--             end
--             if (GetVehicleHandbrake(currentVehicle) or (GetVehicleSteeringAngle(currentVehicle)) > 25.0 or (GetVehicleSteeringAngle(currentVehicle)) < -25.0) then
--                 if handbrake == 0 then
--                     handbrake = 100
--                     ResetHandBrake()
--                 else
--                     handbrake = 100
--                 end
--             end

--             thisFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
--             currentvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)
--             if currentvehicleBodyHealth == 1000 and frameBodyChange ~= 0 then
--                 frameBodyChange = 0
--             end
--             if frameBodyChange ~= 0 then
--                 if lastFrameVehiclespeed > 110 and thisFrameVehicleSpeed < (lastFrameVehiclespeed * 0.75) and not damagedone then
--                     if frameBodyChange > 18.0 then
--                         if not seatbeltOn and not IsThisModelABike(currentVehicle) then
--                             if math.random(math.ceil(lastFrameVehiclespeed)) > 60 then
--                                 if not harnessOn then
--                                     EjectFromVehicle()
--                                 else
--                                     harnessHp = harnessHp - 1
--                                     TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
--                                 end
--                             end
--                         elseif (seatbeltOn or harnessOn) and not IsThisModelABike(currentVehicle) then
--                             if lastFrameVehiclespeed > 150 then
--                                 if math.random(math.ceil(lastFrameVehiclespeed)) > 150 then
--                                     if not harnessOn then
--                                         EjectFromVehicle()
--                                     else
--                                         harnessHp = harnessHp - 1
--                                         TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
--                                     end                     
--                                 end
--                             end
--                         end
--                     else
--                         if not seatbeltOn and not IsThisModelABike(currentVehicle) then
--                             if math.random(math.ceil(lastFrameVehiclespeed)) > 60 then
--                                 if not harnessOn then
--                                     EjectFromVehicle()
--                                 else
--                                     harnessHp = harnessHp - 1
--                                     TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
--                                 end                        
--                             end
--                         elseif (seatbeltOn or harnessOn) and not IsThisModelABike(currentVehicle) then
--                             if lastFrameVehiclespeed > 120 then
--                                 if math.random(math.ceil(lastFrameVehiclespeed)) > 200 then
--                                     if not harnessOn then
--                                         EjectFromVehicle()
--                                     else
--                                         harnessHp = harnessHp - 1
--                                         TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
--                                     end                     
--                                 end
--                             end
--                         end
--                     end
--                     damagedone = true
--                     SetVehicleEngineOn(currentVehicle, false, true, true)
--                 end
--                 if currentvehicleBodyHealth < 350.0 and not damagedone then
--                     damagedone = true
--                     SetVehicleEngineOn(currentVehicle, false, true, true)
--                     Citizen.Wait(1000)
--                 end
--             end
--             if lastFrameVehiclespeed < 100 then
--                 Wait(100)
--                 tick = 0
--             end
--             frameBodyChange = newvehicleBodyHealth - currentvehicleBodyHealth
--             if tick > 0 then 
--                 tick = tick - 1
--                 if tick == 1 then
--                     lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6
--                 end
--             else
--                 if damagedone then
--                     damagedone = false
--                     frameBodyChange = 0
--                     lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6
--                 end
--                 lastFrameVehiclespeed2 = GetEntitySpeed(currentVehicle) * 3.6
--                 if lastFrameVehiclespeed2 > lastFrameVehiclespeed then
--                     lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6
--                 end
--                 if lastFrameVehiclespeed2 < lastFrameVehiclespeed then
--                     tick = 25
--                 end

--             end
--             vels = GetEntityVelocity(currentVehicle)
--             if tick < 0 then 
--                 tick = 0
--             end     
--             newvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)
--             if not modifierDensity then
--                 modifierDensity = true
--             end
--             veloc = GetEntityVelocity(currentVehicle)
--         else
--             if lastVehicle ~= nil then
--                 SetPedHelmet(playerPed, true)
--                 Citizen.Wait(200)
--                 newvehicleBodyHealth = GetVehicleBodyHealth(lastVehicle)
--                 if not damagedone and newvehicleBodyHealth < currentvehicleBodyHealth then
--                     damagedone = true
--                     SetVehicleEngineOn(lastVehicle, false, true, true)
--                     Citizen.Wait(1000)
--                 end
--                 lastVehicle = nil
--             end
--             lastFrameVehiclespeed2 = 0
--             lastFrameVehiclespeed = 0
--             newvehicleBodyHealth = 0
--             currentvehicleBodyHealth = 0
--             frameBodyChange = 0
--             Citizen.Wait(2000)
--         end
--     end
-- end)

function GetFwd(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 5.73, y = math.sin(hr) * 5.73 }
end

function EjectFromVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped,false)
    local coords = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 1.0)
    SetEntityCoords(ped,coords)
    Citizen.Wait(1)
    SetPedToRagdoll(ped, 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(ped, veloc.x*4,veloc.y*4,veloc.z*4)
    local ejectspeed = math.ceil(GetEntitySpeed(ped) * 8)
    if(GetEntityHealth(ped) - ejectspeed) > 0 then
        SetEntityHealth(ped, (GetEntityHealth(ped) - ejectspeed) )
    elseif GetEntityHealth(ped) ~= 0 then
        SetEntityHealth(ped, 0)
    end
end

function PopTires()
    local player = PlayerPedId()
    local veh = GetVehiclePedIsIn(player,false)
    SetVehicleTyreBurst(veh, 0, false, 0.001)
    SetVehicleTyreBurst(veh, 45, false, 0.001)
    SetVehicleTyreBurst(veh, 1, false, 0.001)
    SetVehicleTyreBurst(veh, 47, false, 0.001)
end