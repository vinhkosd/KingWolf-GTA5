local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint, DriveErrors = 0, 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil
local RemainingSeconds = 0
local IsTakenVehicle = false
local IsPassedTheory = false
Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	SendNUIMessage({
		openQuestion = true
	})

	SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)


end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
		Framework.Functions.Notify("Bạn đã vượt qua phần thi lý thuyết!", "success" , 5000)
		-- StartDriveTest()
		IsTakenVehicle = false
		IsPassedTheory = true
	else
		
		Framework.Functions.Notify("Bạn đã trượt phần thi lý thuyết", "error", 7000)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		TakeVehicle = { x = 241.00695, y = -1401.675, z = 30.580718-0.97 }
		if not IsTakenVehicle and IsPassedTheory then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local distance = GetDistanceBetweenCoords(coords, TakeVehicle.x, TakeVehicle.y, TakeVehicle.z, true)

			if distance <= 100.0 then
				DrawMarker(1, TakeVehicle.x, TakeVehicle.y, TakeVehicle.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 209, 41, 242, 100, false, true, 2, false, false, false, false)
			end
			if distance <= 1.5 then
				helpText('Nhấn ~g~E~s~ để bắt đầu thi thực hành')
				if IsControlJustReleased(0, 38) then
					StartDriveTest()
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function StartDriveTest()

	local coords = {
        x = 231.36,
        y = -1394.49,
        z = 30.5,
        h = 239.94,
    }
	if Framework.Functions.IsSpawnPointClear(coords, 3.0) then
		IsTakenVehicle = true
		IsPassedTheory = false
		Framework.Functions.SpawnVehicle('dominator', function(vehicle)
			RemainingSeconds = 400
			SetVehicleNumberPlateText(vehicle, "TEST"..tostring(math.random(1000, 9999)))
			SetEntityHeading(vehicle, coords.h)
			exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(vehicle), 100, false)
			Menu.hidden = true
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
			exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
			SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
			SetVehicleEngineOn(vehicle, true, true)
			SetVehicleDirtLevel(vehicle)
			SetVehicleUndriveable(vehicle, false)
			WashDecalsFromVehicle(vehicle, 1.0)
			CurrentTest       = 'drive'
			CurrentTestType   = 'drive_test'
			CurrentCheckPoint = 0
			LastCheckPoint    = -1
			CurrentZoneType   = 'residence'
			DriveErrors       = 0
			IsAboveSpeedLimit = false
			CurrentVehicle    = vehicle
			LastVehicleHealth = GetEntityHealth(vehicle)
		end, coords, true)
	else
		Framework.Functions.Notify("Khu vực lấy xe bị chặn", "error")
	end
end

-- table = { ['x'] = 241.92309, ['y'] = -1401.665, ['z'] = 30.58258, ['h'] = 108.49372 }

function StopDriveTest(success)
	if success then
		TriggerServerEvent('pepe-school:server:GetLicense')
		Framework.Functions.Notify("Bạn đã vượt qua phần thi thực hành!", "success")
	else
		Framework.Functions.Notify("Bạn đã bị trượt phần thi thực hành", "error")
	end

	CurrentTest     = nil
	CurrentTestType = nil
end

function StopDriveTestImmediately(vehicle)
	if DoesBlipExist(CurrentBlip) then
		RemoveBlip(CurrentBlip)
	end
	Framework.Functions.Notify("Bạn đã bị trượt phần thi thực hành", "error")
	local coords = {
        x = 231.36,
        y = -1394.49,
        z = 30.5,
        h = 239.94,
    }
	DeleteVehicle(vehicle)
	local ped = GetPlayerPed(-1)
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
	CurrentTest     = nil
	CurrentTestType = nil
	SetCurrentZoneType(nil)
	IsTakenVehicle = false
	IsPassedTheory = true
end

function SetCurrentZoneType(type)
CurrentZoneType = type
end

RegisterNUICallback('question', function(data, cb)
	Framework.Functions.TriggerCallback('pepe-school:server:pay', function(result)
		if result then
			SendNUIMessage({
				openSection = 'question'
			})
			Framework.Functions.Notify("Bạn không thể đóng màn hình này trừ khi bạn thi xong phần thi lý thuyết", "error")
		else
			CurrentTest = nil

			SendNUIMessage({
				openQuestion = false
			})

			SetNuiFocus(false)
			cb()
			Framework.Functions.Notify("Bạn không đủ tiền thi bằng lái!", "error")
		end
	end)

	cb()
end)

RegisterNUICallback('buyDriveCard', function(data, cb)
	Framework.Functions.TriggerCallback('Framework:HasItem', function(result1)
		if result1 then
			Framework.Functions.Notify("Bạn đã có giấy phép lái xe rồi!", "error")
		else
			Framework.Functions.TriggerCallback('pepe-school:server:buyLicense', function(result)
				if result then
					Framework.Functions.Notify("Bạn đã mua bằng thành công", "success")
				else
					Framework.Functions.Notify("Bạn không đủ tiền ngân hàng để mua bằng lái!", "error")
				end
			end)
		end
	end, 'drive-card')
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)
	
	cb()
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb()
end)

RegisterNUICallback('closePanel', function(data, cb)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)
	cb()
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb()
end)

AddEventHandler('pepe-school:hasEnteredMarker', function(zone)
	if zone == 'DMVSchool' then
		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = ('Nhấn ~g~E~s~ để bắt đầu thi giấy phép lái xe')
		CurrentActionData = {}
	end
end)

AddEventHandler('pepe-school:hasExitedMarker', function(zone)
	CurrentAction = nil
end)


-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

	SetBlipSprite (blip, 525)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.7)
	SetBlipColour (blip , 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Thi giấy phép lái xe')
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(100)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('pepe-school:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('pepe-school:hasExitedMarker', LastZone)
		end
	end
end)

-- Block UI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if CurrentTest == 'theory' then
			local playerPed = PlayerPedId()

			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			helpText(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then

				Framework.Functions.TriggerCallback('Framework:HasItem', function(result1)
					if result1 then
						Framework.Functions.Notify("Bạn đã có giấy phép lái xe rồi!", "error")
					else
						StartTheoryTest()
					end
				end, 'drive-card')

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)


-- Drive test
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentTest == 'drive' then
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				
				Framework.Functions.Notify("Đã thi bằng lái xe xong", "error")

				if DriveErrors < Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else

				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end

				if DriveErrors > Config.MaxErrors then
					StopDriveTestImmediately(CurrentVehicle)
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentTest == 'drive' then
			RemainingSeconds = RemainingSeconds - 1
			if RemainingSeconds < 0 then
				StopDriveTestImmediately()
			end
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if CurrentTest == 'drive' then
			DrawTxt(0.90, 1.37, 1.0,1.0,0.6, "TỐC ĐỘ CHO PHÉP: ~r~" .. Config.SpeedLimits[CurrentZoneType] .. "~w~ KM/H", 255, 255, 255, 255)
			DrawTxt(0.90, 1.44, 1.0,1.0,0.6, "THỜI GIAN CÒN LẠI: ~r~" .. RemainingSeconds .. "~w~ GIÂY", 255, 255, 255, 255)
			Citizen.Wait(5)
		else
			Citizen.Wait(0)
		end
	end
end)

-- Speed / Damage control
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentTest == 'drive' then

			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then

				local vehicle      = GetVehiclePedIsIn(playerPed, false)
				local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k,v in pairs(Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true

						if not IsAboveSpeedLimit then
							DriveErrors       = DriveErrors + 1
							IsAboveSpeedLimit = true

							Framework.Functions.Notify("Bạn đã vượt quá tốc độ cho phép!", "error")
							-- Framework.Functions.Notify(" "..v.." " ,"error")
							Framework.Functions.Notify("Lỗi - "..DriveErrors.." / "..Config.MaxErrors.." ","error")
						end
					end
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				local health = GetEntityHealth(vehicle)
				if health < LastVehicleHealth then

					DriveErrors = DriveErrors + 1

					
					Framework.Functions.Notify("Bạn đã làm xe bị hư hại", "error")
					Framework.Functions.Notify("Lỗi - "..DriveErrors.." / "..Config.MaxErrors.." ", "error")
					

					-- avoid stacking faults
					LastVehicleHealth = health
					Citizen.Wait(1500)
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(500)
		end
	end
end)

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
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