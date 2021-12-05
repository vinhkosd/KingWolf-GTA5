local LoggedIn = true
local Framework = nil
local NearGarage = false
local IsMenuActive = false   

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)   

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     LoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    if LoggedIn then
        NearGarage = false
        for k, v in pairs(Config.GarageLocations) do
          local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], true) 
          if Distance < v['Distance'] then
           NearGarage = true
           Config.CurrentGarageData = {['GarageNumber'] = k, ['GarageName'] = v['Name']}
          end
        end
        if not NearGarage then
          Citizen.Wait(1500)
          Config.CurrentGarageData = {}
        end
    end
  end
end)

-- // Events \\ --

RegisterNetEvent('pepe-garages:client:check:owner')
AddEventHandler('pepe-garages:client:check:owner', function()
local Vehicle, VehDistance = Framework.Functions.GetClosestVehicle()
local Plate = GetVehicleNumberPlateText(Vehicle)
  if VehDistance < 2.3 then
     Framework.Functions.TriggerCallback("pepe-garage:server:is:vehicle:owner", function(IsOwner)
         if IsOwner then
          local haveOtherPedInVeh = false
          for i = -1, 5 do
            if haveOtherPedInVeh == true then
              break
            end

            if(GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), i) ~= 0) then
              if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), i) ~= PlayerPedId() then
                haveOtherPedInVeh = true
              end
              
            end
          end
          if not haveOtherPedInVeh then
            TriggerEvent('pepe-garages:client:set:vehicle:in:garage', Vehicle, Plate)
          else
            Framework.Functions.Notify('Tất cả người chơi vui lòng xuống xe trước cất vào garage', 'error')
          end
         else
          Framework.Functions.Notify('Đây không phải là chiếc xe của bạn', 'error')
         end
     end, Plate)
  else
    Framework.Functions.Notify('Không tìm thấy xe', 'error')
  end
end)

RegisterNetEvent('pepe-garages:client:set:vehicle:in:garage')
AddEventHandler('pepe-garages:client:set:vehicle:in:garage', function(Vehicle, Plate)
   local VehicleMeta = {Fuel = exports['pepe-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
   local GarageData = Config.CurrentGarageData['GarageName']
    TaskLeaveAnyVehicle(PlayerPedId())
    Citizen.SetTimeout(1650, function()
      TriggerServerEvent('pepe-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
      Framework.Functions.DeleteVehicle(Vehicle)
      TriggerServerEvent("pepe-garages:server:remove:vehicle:by:plate", Plate)
      Framework.Functions.Notify('Xe đã đỗ trong '..Config.CurrentGarageData['GarageName'], 'success')
    end)
end)

RegisterNetEvent('pepe-garages:client:set:vehicle:out:garage')
AddEventHandler('pepe-garages:client:set:vehicle:out:garage', function()
  OpenGarageMenu()
end)

RegisterNetEvent('pepe-garages:client:open:depot')
AddEventHandler('pepe-garages:client:open:depot', function()
  OpenDepotMenu()
end)

RegisterNetEvent('pepe-garages:client:remove:vehicle:by:plate')
AddEventHandler('pepe-garages:client:remove:vehicle:by:plate', function(PlateText)
  local vehModelOnMap = nil
  local vehicles = Framework.Functions.GetVehicles()

  for i=1, #vehicles, 1 do
    local plateVeh = GetVehicleNumberPlateText(vehicles[i])
    if plateVeh == PlateText then
      vehModelOnMap = vehicles[i]
      Framework.Functions.DeleteVehicle(vehModelOnMap)
    end
  end
end)

RegisterNetEvent('pepe-garages:client:spawn:vehicle')
AddEventHandler('pepe-garages:client:spawn:vehicle', function(Plate, VehicleName, Metadata)
  local isSpawnPointClear = false
    for i = 1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'] do
      if isSpawnPointClear then
          break
      end
      -- local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
      -- local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
      -- Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
      --   SetVehicleNumberPlateText(Vehicle, Plate)
      --   DoCarDamage(Vehicle, Metadata.Engine, Metadata.Body)
      --   Citizen.Wait(25)
      --   exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
      --   exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), Metadata.Fuel, false)
      --   Framework.Functions.Notify('Đã đậu xe.', 'success')
      -- end, CoordTable, true, false)
      TriggerServerEvent("pepe-garages:server:remove:vehicle:by:plate", Plate)
      local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][i]['Coords']
      local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}    
      if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
          isSpawnPointClear = true
          local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
          Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
            Framework.Functions.TriggerCallback('pepe-inventory:server:registerWeight', function(result)
              if not result then
                Framework.Functions.Notify('Không thể đăng ký thông tin cốp xe, vui lòng cất xe vào thử lại.', 'error')
              end
            end, Plate, VehicleName)

            SetVehicleNumberPlateText(Vehicle, Plate)
            DoCarDamage(Vehicle, Metadata.Engine, Metadata.Body)
            Citizen.Wait(25)
            exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
            exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), Metadata.Fuel, false)
            Framework.Functions.Notify('Đã đậu xe.', 'success')
          end, CoordTable, true, false)
      end
    end
    if isSpawnPointClear == false then
        Framework.Functions.Notify('Khu vực lấy xe bị chặn.', 'error')
    end

  -- local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
  
end)

RegisterNUICallback('Click', function()
  PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('CloseNui', function()
  SetNuiFocus(false, false)
end)

RegisterNUICallback('TakeOutVehicle', function(clientData)
  if IsNearGarage() then
    Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:data', function(data)
      if(data ~= nil) then
        local isSpawnPointClear = false

        for i = 1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'] do
          if isSpawnPointClear then
              break
          end
          TriggerServerEvent("pepe-garages:server:remove:vehicle:by:plate", data.Plate)
          local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][i]['Coords']
          local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}    
          if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
              isSpawnPointClear = true
              -- local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
              -- local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
              if data.State == 'in' then
                Framework.Functions.SpawnVehicle(data.Model, function(Vehicle)
                  Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:mods', function(Mods)
                    Framework.Functions.SetVehicleProperties(Vehicle, Mods)
                    SetVehicleNumberPlateText(Vehicle, data.Plate)
                    Citizen.Wait(25)
                    DoCarDamage(Vehicle, data.Engine, data.Body)
                    Citizen.Wait(25)
                    exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
                    exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
                    Framework.Functions.Notify('Xe của bạn đang chờ bạn', 'info')
                    TriggerServerEvent('pepe-garages:server:set:garage:state', data.Plate, 'out')
                  end, data.Plate)
                  Framework.Functions.TriggerCallback('pepe-inventory:server:registerWeight', function(result)
                    if not result then
                      Framework.Functions.Notify('Không thể đăng ký thông tin cốp xe, vui lòng cất xe vào thử lại.', 'error')
                    end
                  end, data.Plate, data.Model)
                end, CoordTable, true, false)
              else
                Framework.Functions.Notify("Xe của bạn đang ở trong kho", "info", 3500)
              end
          end
        end

        if isSpawnPointClear == false then
            Framework.Functions.Notify('Khu vực lấy xe đã đầy.', 'error')
        end
      else
        Framework.Functions.Notify("Đây không phải xe của bạn", "info", 3500)
      end
    end, clientData.Plate)
  elseif IsNearDepot() then
    Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:data', function(data)
      if(data ~= nil) then
        -- local vehicleOnMap = false
        -- local vehModelOnMap = nil
        -- local vehicles = Framework.Functions.GetVehicles()

        -- for i=1, #vehicles, 1 do
        --   local plateVeh = GetVehicleNumberPlateText(vehicles[i])
        --   if plateVeh == data.Plate then
        --     vehModelOnMap = vehicles[i]
        --     vehicleOnMap = true
        --   end
        -- end

        -- if vehicleOnMap == true then
        --   Framework.Functions.DeleteVehicle(vehModelOnMap)
        -- end
        TriggerServerEvent("pepe-garages:server:remove:vehicle:by:plate", data.Plate)
        Framework.Functions.TriggerCallback('pepe-garage:server:pay:depot', function(DidPayment)
          if DidPayment then
            local CoordTable = {x = 491.59, y = -1314.14, z = 29.25, a = 299.67}
            Framework.Functions.SpawnVehicle(data.Model, function(Vehicle)
              Framework.Functions.TriggerCallback('pepe-inventory:server:registerWeight', function(result)
                if not result then
                  Framework.Functions.Notify('Không thể đăng ký thông tin cốp xe, vui lòng cất xe vào thử lại.', 'error')
                end
              end, data.Plate, data.Model)
            Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:mods', function(Mods)
            Framework.Functions.SetVehicleProperties(Vehicle, Mods)
              SetVehicleNumberPlateText(Vehicle, data.Plate)
              Citizen.Wait(25)
              DoCarDamage1(Vehicle, data.Engine, data.Body)
              Citizen.Wait(25)
              TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
              exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
              exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
              Framework.Functions.Notify('Xe của bạn đã đỗ ở chỗ đỗ', 'success')
              TriggerServerEvent('pepe-garages:server:set:depot:price', data.Plate, 0)
              TriggerServerEvent('pepe-garages:server:set:garage:state', data.Plate, 'out')
              CloseMenuFull()
              end, data.Plate)
            end, CoordTable, true, false)
          end
        end, data.Price)
      else
        Framework.Functions.Notify("Đây không phải xe của bạn", "info", 3500)
      end
    end, clientData.Plate)
    
  elseif IsNearBoatDepot() then
    local data = clientData
    Framework.Functions.TriggerCallback('pepe-garage:server:pay:depot', function(DidPayment)
      if DidPayment then
        local CoordTable = {x = -799.87, y = -1488.97, z = 0.6260614, a = 299.67}
        Framework.Functions.SpawnVehicle(data.Model, function(Vehicle)
          Framework.Functions.TriggerCallback('pepe-inventory:server:registerWeight', function(result)
            if not result then
              Framework.Functions.Notify('Không thể đăng ký thông tin cốp xe, vui lòng cất xe vào thử lại.', 'error')
            end
          end, data.Plate, data.Model)
        Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:mods', function(Mods)
        Framework.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
          exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
          exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          Framework.Functions.Notify('Bạn đã nhận chìa khoá xe', 'success')
          TriggerServerEvent('pepe-garages:server:set:depot:price', data.Plate, 0)
          TriggerServerEvent('pepe-garages:server:set:garage:state', data.Plate, 'out')
          CloseMenuFull()
          end, data.Plate)
        end, CoordTable, true, false)
      end
    end, data.Price)
  elseif exports['pepe-housing']:NearHouseGarage() then
    Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:data', function(data)
      if(data ~= nil) then
        if data.State == 'in' then
          local VehicleSpawn = exports['pepe-housing']:GetGarageCoords()
          local CoordTable = {x = VehicleSpawn['X'], y = VehicleSpawn['Y'], z = VehicleSpawn['Z'], a = VehicleSpawn['H']}
          Framework.Functions.SpawnVehicle(data.Model, function(Vehicle)
            Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:mods', function(Mods)
                 Framework.Functions.SetVehicleProperties(Vehicle, Mods)
                 SetVehicleNumberPlateText(Vehicle, data.Plate)
                 Citizen.Wait(25)
                 DoCarDamage(Vehicle, data.Engine, data.Body)
                 Citizen.Wait(25)
                 TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
                 exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
                 exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
                 Framework.Functions.Notify('Bạn đã nhận chìa khoá xe', 'success')
                 TriggerServerEvent('pepe-garages:server:set:garage:state', data.Plate, 'out')
                 CloseMenuFull()
               end, data.Plate)
            end, CoordTable, true, false)
        else
          Framework.Functions.Notify("Xe của bạn đang ở trong kho", "info", 3500)
        end
      end
    end, clientData.Plate)
    
  end
end)

-- // Functions \\ --

function DoCarDamage(Vehicle, EngineHealth, BodyHealth)
	SmashWindows = false
	damageOutside = false
	damageOutside2 = false 
	local engine = EngineHealth + 0.0
	local body = BodyHealth + 0.0
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		SmashWindows = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end
	Citizen.Wait(100)
	SetVehicleEngineHealth(Vehicle, engine)
	if SmashWindows then
		SmashVehicleWindow(Vehicle, 0)
		SmashVehicleWindow(Vehicle, 1)
		SmashVehicleWindow(Vehicle, 2)
		SmashVehicleWindow(Vehicle, 3)
		SmashVehicleWindow(Vehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(Vehicle, 1, true)
		SetVehicleDoorBroken(Vehicle, 6, true)
		SetVehicleDoorBroken(Vehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(Vehicle, 1, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 2, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 3, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(Vehicle, 985.0)
  end
end


-- Edit độ khoẻ của xe khi lấy ra khỏi kho phương tiện
function DoCarDamage1(Vehicle, EngineHealth, BodyHealth)
	SmashWindows = false
	damageOutside = false
	damageOutside2 = false 
	local engine = EngineHealth + 0.0
	local body = BodyHealth + 0.0
	if engine <= 1000.0 then
		engine = 110.0
	end

	if body <= 1000.0 then
		body = 110.0
    damageOutside = true
    damageOutside2 = true
	end
	-- if body < 950.0 then
	-- 	SmashWindows = true
	-- end

	-- if body < 920.0 then
	-- 	damageOutside = true
	-- end

	-- if body < 920.0 then
	-- 	damageOutside2 = true
	-- end
	Citizen.Wait(100)
	SetVehicleEngineHealth(Vehicle, engine)
  SetVehicleBodyHealth(Vehicle, body)
	if SmashWindows then
		SmashVehicleWindow(Vehicle, 0)
		SmashVehicleWindow(Vehicle, 1)
		SmashVehicleWindow(Vehicle, 2)
		SmashVehicleWindow(Vehicle, 3)
		SmashVehicleWindow(Vehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(Vehicle, 1, true)
		SetVehicleDoorBroken(Vehicle, 6, true)
		SetVehicleDoorBroken(Vehicle, 4, true)
	end
	if damageOutside2 then
    SetVehicleTyreBurst(Vehicle, 0, true, 1000.0)
		SetVehicleTyreBurst(Vehicle, 1, true, 1000.0)
		SetVehicleTyreBurst(Vehicle, 2, true, 1000.0)
		SetVehicleTyreBurst(Vehicle, 3, true, 1000.0)
		SetVehicleTyreBurst(Vehicle, 4, true, 1000.0)
	end
	-- if body < 1000 then
	-- 	SetVehicleBodyHealth(Vehicle, 400.0)
  -- end
end

function IsNearGarage()
  return NearGarage
end

function IsNearDepot()
  local PlayerCoords = GetEntityCoords(PlayerPedId())
  local Distance = GetDistanceBetweenCoords(PlayerCoords, 491.03, -1313.82, 29.25, true) 
  if Distance < 10.0 then
    return true
  end
end

function IsNearBoatDepot()
  local PlayerCoords = GetEntityCoords(PlayerPedId())
  local DistanceBoat = GetDistanceBetweenCoords(PlayerCoords, -799.87, -1488.97, 0.6260614, true) 
  if DistanceBoat < 10.0 then
    return true
  end
end


function OpenGarageMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  Framework.Functions.TriggerCallback("pepe-garage:server:GetUserVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
             local Vehicle = {}
             local MetaData = json.decode(v.metadata)
             Vehicle = {
               ['Name'] = Framework.Shared.Vehicles[v.vehicle] ~= nil and Framework.Shared.Vehicles[v.vehicle]['name'] or v.vehicle,
               ['Model'] = v.vehicle,
               ['Plate'] = v.plate,
               ['Garage'] = v.garage,
               ['State'] = v.state, 
               ['Fuel'] = MetaData.Fuel, 
               ['Motor'] = math.ceil(MetaData.Engine), 
               ['Body'] = math.ceil(MetaData.Body)
              }
             table.insert(VehicleTable, Vehicle) 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        Framework.Functions.Notify("Bạn không có bất kỳ phương tiện hoặc thuyền trong nhà để xe này", "error", 5000)
      end
  end, Config.CurrentGarageData['GarageName'])
end

function OpenDepotMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  Framework.Functions.TriggerCallback("pepe-garage:server:GetDepotVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              if v.state == 'out' then
                local Vehicle = {}
                local MetaData = json.decode(v.metadata)
                Vehicle = {['Name'] = Framework.Shared.Vehicles[v.vehicle] ~= nil and Framework.Shared.Vehicles[v.vehicle]['name'] or v.vehicle, ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Price'] = v.depotprice, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
                table.insert(VehicleTable, Vehicle)
              end 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenDepot", depotvehicles = VehicleTable})
      else
        Framework.Functions.Notify("Không có xe hiện đang ở trong kho", "error", 5000)
      end
  end)
end

function OpenHouseGarage(HouseId)
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  Framework.Functions.TriggerCallback("pepe-garage:server:GetHouseVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              local Vehicle = {}
              local MetaData = json.decode(v.metadata)
              Vehicle = {['Name'] = Framework.Shared.Vehicles[v.vehicle] ~= nil and Framework.Shared.Vehicles[v.vehicle]['name'] or v.vehicle, ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
              table.insert(VehicleTable, Vehicle)
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        Framework.Functions.Notify("Bạn không có bất kỳ phương tiện hoặc thuyền trong nhà để xe này", "error", 5000)
      end
  end, HouseId)
end


function OpenImpoundGarage(Station)
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  Framework.Functions.TriggerCallback("pepe-garage:server:GetPoliceVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              local Vehicle = {}
              local MetaData = json.decode(v.metadata)
              Vehicle = {['Name'] = Framework.Shared.Vehicles[v.vehicle] ~= nil and Framework.Shared.Vehicles[v.vehicle]['name'] or v.vehicle, ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
              table.insert(VehicleTable, Vehicle)
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        Framework.Functions.Notify("Trống", "error", 5000)
      end
  end, Station)
end

function SetVehicleInHouseGarage(HouseId)
  local Vehicle = GetVehiclePedIsIn(PlayerPedId())
  local Plate = GetVehicleNumberPlateText(Vehicle)
  local VehicleMeta = {Fuel = exports['pepe-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
  local GarageData = HouseId
  TaskLeaveAnyVehicle(PlayerPedId())
  Citizen.SetTimeout(1650, function()
    TriggerServerEvent('pepe-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
    Framework.Functions.DeleteVehicle(Vehicle)
    Framework.Functions.Notify('Xe đã đỗ trong '..HouseId, 'success')
  end)
end