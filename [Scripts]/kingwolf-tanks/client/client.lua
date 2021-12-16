local Framework = nil

Citizen.CreateThread(function()
    while Framework == nil do

        TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

        Citizen.Wait(200)

    end
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)



local Keys = {

	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 

	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 

	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,

	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,

	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,

	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 

	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,

	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,

	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118

}



Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local tableCoords = Config.Locations["tanks"]
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local RentTankDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["tanks"]["x"], Config.Locations["tanks"]["y"], Config.Locations["tanks"]["z"])

		if RentTankDist < 10 then
			DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
			Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Thuê xe Tank 2500$")
		end

		if RentTankDist < 1.5 then
			inRange = true
			if IsControlJustReleased(0, Keys["E"]) then
				TriggerServerEvent("kingwolf-tanks:server:Checktank")
			end
		end

		local TankZoneDistance = GetDistanceBetweenCoords(plyCoords, Config.Locations["TankZone"]["x"], Config.Locations["TankZone"]["y"], Config.Locations["TankZone"]["z"])

		if TankZoneDistance < Config.Radius then
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local vehModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)))

				-- DrawMarker(1, Config.Locations["UnRent"]["x"], Config.Locations["UnRent"]["y"], Config.Locations["UnRent"]["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 209, 41, 242, 100, false, true, 2, false, false, false, false)
				if vehModel:lower() == Config.CarModel then
					bodyHealth = GetVehicleBodyHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 10
					engineHealth = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 10
					if bodyHealth < 10.0 or engineHealth < 10.0 then
						Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
						Framework.Functions.Notify('Bạn đã bị loại.', 'error')
						SetEntityCoords(GetPlayerPed(-1), Config.Locations["GoBack"]["x"], Config.Locations["GoBack"]["y"], Config.Locations["GoBack"]["z"] + 0.5 , 1, 0, 0, 1)
					end
				end
				
			end
		end
	end
end)



RegisterNetEvent('kingwolf-tanks:client:spawn:vehicle')
AddEventHandler('kingwolf-tanks:client:spawn:vehicle', function()
	local isSpawnPointClear = false
	for i = 1, #Config.Locations['Spawnstanks'] do
		if isSpawnPointClear then
			break
		end
		local spawnCoords = Config.Locations['Spawnstanks'][i]
		local CoordTable = {x = spawnCoords['x'], y = spawnCoords['y'], z = spawnCoords['z'], a = spawnCoords['h']}    
		if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
			isSpawnPointClear = true
			
			Framework.Functions.SpawnVehicle("rhino", function(Vehicle)
				local plateText = "TK"..math.random(100000, 999999)
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
				SetVehicleNumberPlateText(Vehicle, plateText)
				TriggerEvent('persistent-vehicles/register-vehicle', Vehicle)
				Citizen.Wait(25)
				
				exports['pepe-vehiclekeys']:SetVehicleKey(plateText, true)
				exports['pepe-fuel']:SetFuelLevel(Vehicle, plateText, 100, false)
			end, CoordTable, true, false)
				
		end
	end

	if isSpawnPointClear == false then
		Framework.Functions.Notify('Khu vực lấy xe bị chặn.', 'error')
	end
end)



Citizen.CreateThread(function()

	blips = AddBlipForCoord(Config.Locations["tanks"]["x"], Config.Locations["tanks"]["y"], Config.Locations["tanks"]["z"])
	SetBlipSprite(blips, 633)
	SetBlipDisplay(blips, 4)
	SetBlipScale(blips, 0.8)
	SetBlipColour(blips, 49)
	SetBlipAsShortRange(blips, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Tank chiến")
	EndTextCommandSetBlipName(blips)
end)
