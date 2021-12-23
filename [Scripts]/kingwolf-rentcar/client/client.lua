Framework = nil

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
	local addBlip = AddBlipForCoord(Config.Locations["Rent"]["x"], Config.Locations["Rent"]["y"], Config.Locations["Rent"]["z"])

	SetBlipSprite (addBlip, 85)

	SetBlipDisplay(addBlip, 4)

	SetBlipScale  (addBlip, 0.7)

	SetBlipColour (addBlip, 5)

	SetBlipAsShortRange(addBlip, true)

	BeginTextCommandSetBlipName("STRING")

	AddTextComponentString('Thuê xe hàng')

	EndTextCommandSetBlipName(addBlip)
end)

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)

		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		if isLoggedIn then
			local RentDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["Rent"]["x"], Config.Locations["Rent"]["y"], Config.Locations["Rent"]["z"])

			if RentDist < 20.0 then
				DrawMarker(2, Config.Locations["Rent"]["x"], Config.Locations["Rent"]["y"], Config.Locations["Rent"]["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, true, 2, false, false, false, false)
			end
			if RentDist < 1.0 then
				Framework.Functions.DrawText3D(Config.Locations["Rent"]["x"], Config.Locations["Rent"]["y"], Config.Locations["Rent"]["z"] + 0.15, "~g~[E]~w~ Thuê xe đi làm")
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerServerEvent("kingwolf-rentcar:server:CheckRental")
				end
			end

			local UnRentDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["UnRent"]["x"], Config.Locations["UnRent"]["y"], Config.Locations["UnRent"]["z"])
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local vehModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)))

				-- DrawMarker(2, Config.Locations["UnRent"]["x"], Config.Locations["UnRent"]["y"], Config.Locations["UnRent"]["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, true, 2, false, false, false, false)
				if vehModel:lower() == Config.CarModel then
					if UnRentDist < 20.0 then
					DrawMarker(2, Config.Locations["UnRent"]["x"], Config.Locations["UnRent"]["y"], Config.Locations["UnRent"]["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, true, 2, false, false, false, false)
					end

					if UnRentDist < 1.0 then
						Framework.Functions.DrawText3D(Config.Locations["UnRent"]["x"], Config.Locations["UnRent"]["y"], Config.Locations["UnRent"]["z"] + 0.15, "~g~[E]~w~ Trả xe thuê")
						if IsControlJustReleased(0, Keys["E"]) then
							local damage = 0
							damage = GetVehicleBodyHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 10
							local vehiclePlateText = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
							print(damage)
							TriggerServerEvent("kingwolf-rentcar:server:ReturnPay", vehiclePlateText, damage)
						end
					end
				end
				
			end
		end
	end
end)

RegisterNetEvent('kingwolf-rentcar:client:spawn:vehicle')
AddEventHandler('kingwolf-rentcar:client:spawn:vehicle', function()
	local isSpawnPointClear = false
	for i = 1, #Config.Locations['Spawns'] do
		if isSpawnPointClear then
			break
		end
		local spawnCoords = Config.Locations['Spawns'][i]
		local CoordTable = {x = spawnCoords['x'], y = spawnCoords['y'], z = spawnCoords['z'], a = spawnCoords['h']}    
		if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
			isSpawnPointClear = true
			Framework.Functions.TriggerCallback('kingwolf-rentcar:server:registerPlate', function(plateText)
				if plateText == nil then
					Framework.Functions.Notify("Không thể đăng ký thông tin biển số xe..")
				else
					Framework.Functions.SpawnVehicle(Config.CarModel, function(Vehicle)
						Framework.Functions.TriggerCallback('pepe-inventory:server:registerWeight', function(result)
							if not result then
							  Framework.Functions.Notify('Không thể đăng ký thông tin cốp xe, vui lòng cất xe vào thử lại.', 'error')
							end
						  end, plateText, Config.CarModel)
						TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
						SetVehicleNumberPlateText(Vehicle, plateText)
						TriggerEvent('persistent-vehicles/register-vehicle', Vehicle)
						Framework.Functions.TriggerCallback('kingwolf-common:server:registerPlate', function(canReg)
							if not canReg then
								Framework.Functions.Notify("Không thể đăng ký thông tin biển số xe.")
							end
						end, plateText)
						Citizen.Wait(25)
						
						exports['pepe-vehiclekeys']:SetVehicleKey(plateText, true)
						exports['pepe-fuel']:SetFuelLevel(Vehicle, plateText, 100, false)
						Framework.Functions.Notify("Xe thuê của bạn đang ở chỗ đậu", 'info')
					end, CoordTable, true, false)
				end
			end)
		end
	end

	if isSpawnPointClear == false then
		Framework.Functions.Notify('Khu vực lấy xe bị chặn.', 'error')
	end
end)

RegisterNetEvent('kingwolf-rentcar:client:despawn:vehicle')
AddEventHandler('kingwolf-rentcar:client:despawn:vehicle', function()
	Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end)