Framework = nil

local HasOwnTowVehicle = false
local HasVehicleSpawned = false
local PlayerJob = {}
local JobBlip = nil

local LoggedIn = false

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)  

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1000, function()
     TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
     Citizen.Wait(150)
     Framework.Functions.TriggerCallback("pepe-tow:server:get:config", function(config)
        Config = config
     end)
     PlayerJob = Framework.Functions.GetPlayerData().job
     LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then 
            if PlayerJob.name == 'mechanic' then
               NearAnything = false
               local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
               if Config.CurrentNpc ~= nil then
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations[Config.CurrentNpc]['Coords']['X'], Config.Locations[Config.CurrentNpc]['Coords']['Y'], Config.Locations[Config.CurrentNpc]['Coords']['Z'], true)
                if Distance <= 100.0 and not HasVehicleSpawned then
                   NearAnything = true
                   HasVehicleSpawned = true
                   SpawnTowVehicle(Config.Locations[Config.CurrentNpc]['Coords'], Config.Locations[Config.CurrentNpc]['Model'])
                end
               end
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['Laptop']['X'], Config.JobLocations['Laptop']['Y'], Config.JobLocations['Laptop']['Z'], true)
                if Config.JobData[Framework.Functions.GetPlayerData().citizenid] ~= nil then
                  if Distance <= 2.0 and Config.JobData[Framework.Functions.GetPlayerData().citizenid]['Payment'] > 0 then
                     NearAnything = true
                     DrawText3D(Config.JobLocations['Laptop']['X'], Config.JobLocations['Laptop']['Y'], Config.JobLocations['Laptop']['Z'], '~g~E~s~ - Get salary')
                     if IsControlJustReleased(0, 38) then
                         TriggerServerEvent('pepe-tow:server:recieve:payment')
                     end
                  end
                end
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'], true)
                  if Distance <= 6.0 then
                   NearAnything = true
                   DrawMarker(2, Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 207, 43, 37, 255, false, false, false, 1, false, false, false)
                   if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                     DrawText3D(Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'] + 0.2, '~g~E~s~ - Store vehicle')
                     if IsControlJustReleased(0, 38) then
                       if HasOwnTowVehicle then
                           if GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))) == GetHashKey(Config.TowVehicle) then
                               Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                               TriggerServerEvent('pepe-tow:server:return:bail:fee')
                           else
                                Framework.Functions.Notify('This is not a flatbed', 'error', 5500)
                           end
                       end
                     end
                   else
                     DrawText3D(Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'] + 0.2, '~g~E~s~ - Rent a vehicle')
                     if IsControlJustReleased(0, 38) then
                       Framework.Functions.TriggerCallback("pepe-tow:server:do:bail", function(DidBail)
                           if DidBail then
                               GetTowVehicle()
                           else
                             Framework.Functions.Notify('You dont have enough cash', 'error', 5500)
                           end
                        end)
                     end
                  end
                end
                if not NearAnything then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end 
    end
end)

RegisterNetEvent('pepe-tow:client:add:towed')
AddEventHandler('pepe-tow:client:add:towed', function(CitizenId, Payment, Type)
    if Type == 'Add' then
      if Config.JobData[CitizenId] ~= nil then
          Config.JobData[CitizenId]['Payment'] = Config.JobData[CitizenId]['Payment'] + Payment
      else
          Config.JobData[CitizenId] = {['Payment'] = 0 + Payment}
      end
    elseif Type == 'Set' then
      Config.JobData[CitizenId]['Payment'] = Payment
    end
end)

RegisterNetEvent('pepe-tow:client:toggle:npc')
AddEventHandler('pepe-tow:client:toggle:npc', function()
   if not Config.IsDoingNpc then
     Config.IsDoingNpc = true
     SetRandomPickupVehicle()
     Framework.Functions.Notify('You started with a pickup drive to the location to pick up the vehicle', 'success', 5500)
   else
    if Config.CurrentTowedVehicle ~= nil then
        Framework.Functions.Notify('You are still working on a vehicle', 'error', 5500)
    else
        -- DeleteWaypoint()
        RemoveBlip(JobBlip)
        ResetAll()
        Framework.Functions.Notify('You stopped your pickup assignment', 'error', 5500)
    end
   end
end)

RegisterNetEvent('pepe-tow:client:hook:car')
AddEventHandler('pepe-tow:client:hook:car', function()
    local TowVehicle = nil
    local rangeVehicles = Framework.Functions.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1), 1), 10.0)--xe đầu kéo
    for i = 1, #rangeVehicles do
        if(IsVehicleValid(rangeVehicles[i])) then
            TowVehicle = rangeVehicles[i]-- xe kéo
        end
    end
    
    if TowVehicle ~= nil and IsVehicleValid(TowVehicle) then
            local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)--xe được kéo
            if Config.CurrentTowedVehicle == nil then
                if Vehicle ~= 0 and Vehicle ~= nil then
                    if Vehicle ~= TowVehicle then
                        local distanceBetweenVehicles =
                        GetDistanceBetweenCoords(GetEntityCoords(Vehicle),
                            GetEntityCoords(TowVehicle), false)-- lấy kc toạ độ từ xe người chơi tới xe kéo
                        if not isThisVehicleBlacklisted(Vehicle) then
                            Framework.Functions.Progressbar("towing-vehicle", "Đang nâng phương tiện lên...", 5000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "mini@repair",
                                anim = "fixing_a_ped",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                Config.CurrentTowedVehicle = Vehicle
                                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                                AttachEntityToEntity(Vehicle, TowVehicle, GetEntityBoneIndexByName(TowVehicle, 'bodyshell'), 0.0, -1.5 + -0.85, 0.0 + 1.15, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                                Citizen.Wait(150)
                                -- RemoveBlip(JobBlip)
                                SetNewWaypoint(491.03, -1313.82)
                                FreezeEntityPosition(Vehicle, true)
                                TaskLeaveVehicle(PlayerPedId(), Vehicle, 16)
                                Framework.Functions.Notify("Đưa phương tiện lên xe kéo thành công", "success")
                            end, function() -- Cancel
                                Config.CurrentTowedVehicle = nil
                                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                                Framework.Functions.Notify("Đã huỷ bỏ!", "error")
                            end)
                        else
                                Framework.Functions.Notify('Xe này không được phép kéo...', 'error', 5500)
                        end
                    else
                        Framework.Functions.Notify('Không thể nâng xe kéo lên xe kéo!', 'error', 5500)
                    end
                else
                    Framework.Functions.Notify('Bạn vui lòng ngồi trong xe được kéo.', 'error', 5500)
                end
            else
                -- print("untowing_vehicle")
                Framework.Functions.Progressbar("untowing_vehicle", "Đang tháo dỡ phương tiện.", 5000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    FreezeEntityPosition(Config.CurrentTowedVehicle, false)
                    Citizen.Wait(250)
                    if DoesEntityExist(Config.CurrentTowedVehicle) then
                        for i = -1, GetVehicleMaxNumberOfPassengers(Config.CurrentTowedVehicle) do
                            if IsVehicleSeatFree(Config.CurrentTowedVehicle, i) then
                                SetPedIntoVehicle(PlayerPedId(), Config.CurrentTowedVehicle, i)
                                break
                            end
                        end
                    end
                    AttachEntityToEntity(Config.CurrentTowedVehicle, TowVehicle, 20, -0.0, -15.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                    DetachEntity(Config.CurrentTowedVehicle, true, true)
                    if exports['pepe-garages']:IsNearDepot() then
                        Framework.Functions.Notify("Đã trả xe kéo về ga-ra!", 'success')
                        Framework.Functions.DeleteVehicle(TowVehicle)
                        TriggerServerEvent('pepe-tow:server:add:towed', math.random(650, 850))
                        ResetAll()
                    end
                    
                    Config.CurrentTowedVehicle = nil
                    Framework.Functions.Notify("Tháo dỡ phương tiện!")
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                    Framework.Functions.Notify("Đã huỷ bỏ!", "error")
                end)
            end
        -- end
    else
        Framework.Functions.Notify('Không tìm thấy xe kéo, vui lòng để xe được kéo phía sau xe kéo', 'error', 5500)
    end
end)

function IsVehicleValid(TowVehicle)
    print(GetEntityModel(TowVehicle))
    print(GetHashKey(Config.TowVehicle))
    if GetEntityModel(TowVehicle) == GetHashKey(Config.TowVehicle) then
        return true
    else
        return false
    end
end

function SetRandomPickupVehicle()
local RandomVehicle = math.random(1, #Config.Locations)
CreateTowBlip(Config.Locations[RandomVehicle]['Coords'])
Config.CurrentNpc = RandomVehicle
end

function SpawnTowVehicle(Coords, Model)
    local CoordsTable = {x = Coords['X'], y = Coords['Y'], z = Coords['Z'], a = Coords['H']}
    Framework.Functions.SpawnVehicle(Model, function(Vehicle)
        Citizen.Wait(150)
        exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 0.0, false)
        DoCarDamage(Vehicle)
    end, CoordsTable, true, false)
end

function CreateTowBlip(Coords)
    local TowBlip = AddBlipForCoord(Coords['X'], Coords['Y'], Coords['Z'])
    SetBlipSprite(TowBlip, 595)
    SetBlipDisplay(TowBlip, 4)
    SetBlipScale(TowBlip, 0.48)
    SetBlipAsShortRange(TowBlip, true)
    SetBlipColour(TowBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Take-up vehicle')
    EndTextCommandSetBlipName(TowBlip)
    SetNewWaypoint(Coords['X'], Coords['Y'])
    JobBlip = TowBlip
end

function ResetAll()
  Config.CurrentNpc = nil
  Config.IsDoingNpc = false
  Config.CurrentTowedVehicle = nil
  HasVehicleSpawned = false
end

function GetTowVehicle()
  HasOwnTowVehicle = true
  Framework.Functions.SpawnVehicle(Config.TowVehicle, function(Vehicle)
    SetVehicleNumberPlateText(Vehicle, "TOWR"..tostring(math.random(1000, 9999)))
    exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
    Citizen.Wait(100)
    exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
  end, nil, true, true)
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.28, 0.28)
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

function DoCarDamage(Vehicle)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = 199.0
	local body = 149.0
	if engine < 200.0 then
		engine = 200.0
    end

    if engine  > 1000.0 then
        engine = 950.0
    end
	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end
	if body < 920.0 then
		damageOutside = true
	end
	if body < 920.0 then
		damageOutside2 = true
	end
    Citizen.Wait(100)
    SetVehicleEngineHealth(Vehicle, engine)
	if smash then
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
		SetVehicleBodyHealth(Vehicle, 985.1)
	end
end

function getVehicleInDirection(coordFrom, coordTo)
    
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z,10, PlayerPedId(), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    print(a, b, c, d, vehicle)
    return vehicle

end

function isThisAFlatbed(vehicle)
    local isValid = false
    for model, posOffset in pairs(Config.Flatbeds) do
       
        if IsVehicleModel(vehicle, model) then
            
            xoffset = posOffset.x
            yoffset = posOffset.y
            zoffset = posOffset.z
            isValid = true
            break
        end
    end
    return isValid
end

function isThisVehicleBlacklisted(vehicle)
    local isBlacklisted = false
    for model in pairs(Config.TowBlacklist) do
        if GetHashKey(model) == GetHashKey(vehicle) then
            isBlacklisted = true
            break
        end
    end
    return isBlacklisted
end