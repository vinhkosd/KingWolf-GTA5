Framework = nil

local IsSelling = false
local CurrentRadiusBlip = {}
local CurrentLocation = {
    ['Name'] = 'Fish1',
    ['Coords'] = {['X'] = 241.00, ['Y'] = 3993.00, ['Z'] = 30.40},
}

local CurrentBlip = {}
local LastLocation = nil  

local LoggedIn = true
local DoingSomething = false

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)   

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(750, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        SetRandomLocation()
        Citizen.Wait(250)
        LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          SetRandomLocation()
          Citizen.Wait(1000 * 60 * 35)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(15000)
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          NearFishArea = false
          local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CurrentLocation['Coords']['X'], CurrentLocation['Coords']['Y'], CurrentLocation['Coords']['Z'], true)
          if Distance <= 75.0 then
              NearFishArea = true
              Config.CanFish = true
          end
          if not NearFishArea then
              Citizen.Wait(1500)
              Config.CanFish = false
          end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false
        Citizen.Wait(4)
        if LoggedIn then
            NearArea = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], true)
            if Distance <= 2.0 then
                NearArea = true
                if not IsSelling then
                  DrawText3D(Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], '~g~E~s~ - Bán cá')
                  if IsControlJustReleased(0, 38) then
                      IsSelling = true
                      Framework.Functions.Notify('Đang bán..', 'info')
                      TriggerServerEvent('pepe-fishing:server:sell:items')
                      Citizen.SetTimeout(15000, function()
                          IsSelling = false
                      end)
                  end
                end
            end

            
            -- local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['RBoat']['X'], Config.Locations['RBoat']['Y'], Config.Locations['RBoat']['Z'], true)
           local VehicleDistance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["RBoat"]['X'], Config.Locations["RBoat"]['Y'], Config.Locations["RBoat"]['Z'], true)
           if VehicleDistance < 30 then
            NearArea = true
            DrawMarker(2, Config.Locations["RBoat"]['X'], Config.Locations["RBoat"]['Y'], Config.Locations["RBoat"]['Z'] + 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
            if VehicleDistance < 5 then
                local InVehicle = IsPedInAnyVehicle(PlayerPedId())
                local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))

                if InVehicle and vehicleModel:lower() == 'dinghy' then
                    DrawText3D(Config.Locations["RBoat"]['X'], Config.Locations["RBoat"]['Y'], Config.Locations["RBoat"]['Z'] + 0.20, '~g~E~w~ Trả thuyền')
                    if IsControlJustPressed(0, 38) then
                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                        -- Framework.Functions.TriggerCallback("pepe-fishing:server:return:pay", function(DidPay)
                        --     if DidPay then
                        --         -- Framework.Functions.Notify('Bạn đã nhận lại tiền thuê thuyền của bạn', 'success')
                        --         -- SpawnFishBoat()
                        --     end
                        -- end)
                    end
                else
                    
                    -- Menu.renderGUI()
                end
            end
        end
           
           
           

            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], true)
            if Distance <= 2.0 then
                NearArea = true
                DrawMarker(2, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                DrawText3D(Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'] + 0.15, '~g~E~s~ - Thuê thuyền ~g~$~s~ 150')
                if IsControlJustReleased(0, 38) then
                    Framework.Functions.TriggerCallback("pepe-fishing:server:can:pay", function(DidPay)
                        if DidPay then
                            SpawnFishBoat()
                        end
                    end)
                end
            end


            if not NearArea then
                Citizen.Wait(1500)
            end
        end
    end
end)

RegisterNetEvent('pepe-fishing:client:rod:anim')
AddEventHandler('pepe-fishing:client:rod:anim', function()
    exports['pepe-assets']:AddProp('FishingRod')
    exports['pepe-assets']:RequestAnimationDict('amb@world_human_stand_fishing@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('pepe-fishing:client:use:fishingrod')
AddEventHandler('pepe-fishing:client:use:fishingrod', function()
    if (Framework.Functions.GetPlayerData().metadata["currentrank"] == nil or Framework.Functions.GetPlayerData().metadata["currentrank"] < 3) then
        Framework.Functions.Notify("Bạn chưa đủ điều kiện để farm khu vực này (Yêu cầu: Level 3)", "error")
        return
    end
    if not Config.UsingRod then
        if Config.CanFish then
        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            if not IsEntityInWater(GetPlayerPed(-1)) then
                FreezeEntityPosition(GetPlayerPed(-1), true)
                if not exports['pepe-progressbar']:GetTaskBarStatus() then
                    if not DoingSomething then
                        DoingSomething = true
                        TriggerEvent('pepe-inventory:client:set:busy', true)
                         Citizen.SetTimeout(1000, function()
                            TriggerEvent('pepe-fishing:client:rod:anim')
                             Framework.Functions.Progressbar("drink", "Đang câu cá..", 5000, false, true, {
                                 disableMovement = true,
                                 disableCarMovement = false,
                                 disableMouse = false,
                                 disableCombat = true,
                             }, {}, {}, {}, function() -- Done
                                DoingSomething = false
                                TriggerEvent('pepe-inventory:client:set:busy', false)
                                CatchFish()
                             end, function()
                                DoingSomething = false
                                exports['pepe-assets']:RemoveProp()
                                TriggerEvent('pepe-inventory:client:set:busy', false)
                                Framework.Functions.Notify("Đã hủy bỏ..", "error")
                                FreezeEntityPosition(GetPlayerPed(-1), false)
                                StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
                             end)
                         end)
                    end
                end
            else
                Framework.Functions.Notify('Bạn đang bơi.', 'error')
				FreezeEntityPosition(GetPlayerPed(-1), false)
            end
        else
            Framework.Functions.Notify('Bạn đang ở trong một chiếc xe.', 'error')
			FreezeEntityPosition(GetPlayerPed(-1), false)
        end
        else
            Framework.Functions.Notify('Bạn không ở trong khu vực câu cá.', 'error')
			FreezeEntityPosition(GetPlayerPed(-1), false)
        end
    end

    
end)

function CatchFish() 
    if not Config.UsingRod then
        if Config.CanFish then
        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            if not IsEntityInWater(GetPlayerPed(-1)) then
                Config.UsingRod = true
                
                local Skillbar = exports['pepe-skillbar']:GetSkillbarObject()
                
                -- local NeededAttempts = math.random(2, 5)
                
                -- mặc định độ dễ nhất sẽ là 20,
                -- 2 lần sẽ là 40, nếu người chơi đạt chỉ số thấp nhất, 16 -> thì tỉ lệ ra đỒ cao hơn so với bình thường
                
                local durationAndWidthList = {
                    [1] = {
                        ['minDuration'] = 1000,
                        ['maxDuration'] = 1300,
                        ['minWidth'] = 13,
                        ['maxWidth'] = 20,
                    },
                    [2] = {
                        ['minDuration'] = 700,
                        ['maxDuration'] = 1000,
                        ['minWidth'] = 9,
                        ['maxWidth'] = 13,
                    },
                    [3] = {
                        ['minDuration'] = 600,
                        ['maxDuration'] = 700,
                        ['minWidth'] = 6,
                        ['maxWidth'] = 9,
                    },
                    [4] = {
                        ['minDuration'] = 500,
                        ['maxDuration'] = 600,
                        ['minWidth'] = 5,
                        ['maxWidth'] = 6,
                    },
                }

                Framework.Functions.TriggerCallback("pepe-fishing:server:get:attempt", function(NeededAttempts)
                    local SucceededAttempts = 0
                    -- print(NeededAttempts)
                    randomConfig = durationAndWidthList[SucceededAttempts + 1]
                    -- print(randomConfig['minDuration'])
                    -- print(randomConfig['maxDuration'])
                    -- print(randomConfig['minWidth'])
                    -- print(randomConfig['maxWidth'])
                    local addedDuration = 0
                    local addedWidth = 0
                    local durationRandomValue = math.random(tonumber(randomConfig['minDuration']), tonumber(randomConfig['maxDuration']))
                    local widthRandomValue = math.random(tonumber(randomConfig['minWidth']), tonumber(randomConfig['maxWidth']))
                    addedDuration = addedDuration + durationRandomValue
                    addedWidth = addedWidth + widthRandomValue
                    
                    Skillbar.Start({
                        duration = durationRandomValue,
                        pos = math.random(10, 30),
                        width = widthRandomValue,
                    }, function()
                        if SucceededAttempts + 1 >= NeededAttempts then
                            -- Finish
                        FreezeEntityPosition(GetPlayerPed(-1), false)
                        exports['pepe-assets']:RemoveProp()
                        Config.UsingRod = false
                        TriggerServerEvent('pepe-fishing:server:fish:reward', NeededAttempts, addedDuration, addedWidth)
                        SucceededAttempts = 0
                        StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
                        else
                            randomConfig = durationAndWidthList[SucceededAttempts + 1]

                            durationRandomValue = math.random(tonumber(randomConfig['minDuration']), tonumber(randomConfig['maxDuration']))
                            widthRandomValue = math.random(tonumber(randomConfig['minWidth']), tonumber(randomConfig['maxWidth']))
                            addedDuration = addedDuration + durationRandomValue
                            addedWidth = addedWidth + widthRandomValue
                            -- Repeat
                            Skillbar.Repeat({
                                duration = durationRandomValue,
                                pos = math.random(10, 40),
                                width = widthRandomValue,
                            })
                            SucceededAttempts = SucceededAttempts + 1
                        end
                    end, function()
                        -- Fail
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    exports['pepe-assets']:RemoveProp()
                    Config.UsingRod = false
                    Framework.Functions.Notify('Thất bại..', 'error')
                    SucceededAttempts = 0
                    StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
                    end)
                end)
            else
                FreezeEntityPosition(GetPlayerPed(-1), false)
                Framework.Functions.Notify('Bạn đang bơi.', 'error')
            end
        else
            FreezeEntityPosition(GetPlayerPed(-1), false)
            Framework.Functions.Notify('Bạn đang ở trong một chiếc xe.', 'error')
        end
        else
            FreezeEntityPosition(GetPlayerPed(-1), false)
            Framework.Functions.Notify('Bạn không ở trong khu vực câu cá.', 'error')
        end
    else
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
end

function SetRandomLocation()
    RandomLocation = Config.FishLocations[math.random(1, #Config.FishLocations)]
    if CurrentLocation['Name'] ~= RandomLocation['Name'] then
     if CurrentBlip ~= nil and CurrentRadiosBlip ~= nil then
      RemoveBlip(CurrentBlip)
      RemoveBlip(CurrentRadiosBlip)
     end
     Citizen.SetTimeout(250, function()
         CurrentRadiosBlip = AddBlipForRadius(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'], 75.0)        
         SetBlipRotation(CurrentRadiosBlip, 0)
         SetBlipColour(CurrentRadiosBlip, 19)
     
         CurrentBlip = AddBlipForCoord(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'])
         SetBlipSprite(CurrentBlip, 68)
         SetBlipDisplay(CurrentBlip, 4)
         SetBlipScale(CurrentBlip, 0.7)
         SetBlipColour(CurrentBlip, 0)
         SetBlipAsShortRange(CurrentBlip, true)
         BeginTextCommandSetBlipName('STRING')
         AddTextComponentSubstringPlayerName('Khu vực đánh cá')
         EndTextCommandSetBlipName(CurrentBlip)
         CurrentLocation = RandomLocation
     end)
    else
        SetRandomLocation()
    end
end

function SpawnFishBoat()
    local CoordTable = {x = 1517.25, y = 3836.86, z = 29.60, a = 37.31}
    Framework.Functions.SpawnVehicle('dinghy', function(vehicle)
     TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
     exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
     Citizen.Wait(100)
     exports['pepe-fuel']:SetFuelLevel(vehicle, GetVehicleNumberPlateText(vehicle), 100, true)
     Framework.Functions.Notify('Bạn đã nhận được thuyền của bạn', 'success')
     Framework.Functions.TriggerCallback('kingwolf-common:server:registerPlate', function(canReg)
        if not canReg then
            Framework.Functions.Notify("Không thể đăng ký thông tin biển số xe.")
        end
    end, GetVehicleNumberPlateText(vehicle))
    end, CoordTable, true, true)
end

-- // Functions \\ --

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