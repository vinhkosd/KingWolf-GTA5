local Framework = nil
local isInWarZone = false
local Reviving = false
local isLoggedIn = false
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

-- x 4773.20
-- y -4969.59
-- z -0.4155
-- radius 1257
-- useZ = false
-- diameter = radius * 2.0
-- DrawMarker(1, center.x, center.y, -200.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, diameter, diameter, 400.0, r, g, b, 96, false, false, 2, nil, nil, false)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if isLoggedIn then
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

			local WarZoneDistance = GetDistanceBetweenCoords(plyCoords, Config.Locations["WarZone"]["x"], Config.Locations["WarZone"]["y"], Config.Locations["WarZone"]["z"])

			if WarZoneDistance < Config.Radius then
				isInWarZone = true
				local diameter = Config.Radius * 2.0
				local r = 255
				local g = 0
				local b = 0
				DrawMarker(1, Config.Locations["WarZone"]["x"], Config.Locations["WarZone"]["y"], -200.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, diameter, diameter, 400.0, r, g, b, 96, false, false, 2, nil, nil, false)
			else
				if isInWarZone then
					isInWarZone = false
					SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
					RemoveAllPedWeapons(GetPlayerPed(-1), true)
					TriggerEvent('pepe-weapons:client:set:current:weapon', nil)
					Framework.Functions.Notify("Bạn vừa rời khỏi vùng chiến đấu")
					TriggerServerEvent('kingwolf-warzone:server:RemoveInventory')
					if IsPedInAnyVehicle(GetPlayerPed(-1)) then
						Framework.Functions.Notify("Phương tiện trong WarZone không thể mang ra ngoài")
						Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
					end
				end
			end

			local tableCoords = Config.Locations["GoToWarZone"]
			local WarZoneDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["GoToWarZone"]["x"], Config.Locations["GoToWarZone"]["y"], Config.Locations["GoToWarZone"]["z"])

			if WarZoneDist < 10 then
				DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
			end

			if WarZoneDist < 1.5 then
				inRange = true
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"] - 0.97, "~g~[E]~w~ WarZone")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(5000)
					Citizen.Wait(5000)
					
					SetEntityCoords(GetPlayerPed(-1), Config.Locations["GoBack"]["x"], Config.Locations["GoBack"]["y"], Config.Locations["GoBack"]["z"] + 0.5 , 1, 0, 0, 1)
					DoScreenFadeIn(250)
				end
			end

			local tableCoords = Config.Locations["GoBack"]
			local GoBackDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["GoBack"]["x"], Config.Locations["GoBack"]["y"], Config.Locations["GoBack"]["z"])

			if GoBackDist < 10 then
				DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"] - 0.97, "~g~[E]~w~ Mất hết đồ trong người khi quay về thành phố")
			end

			if GoBackDist < 1.5 then
				inRange = true
				
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(5000)
					Citizen.Wait(5000)
					SetEntityCoords(GetPlayerPed(-1), Config.Locations["GoToWarZone"]["x"], Config.Locations["GoToWarZone"]["y"], Config.Locations["GoToWarZone"]["z"] + 0.5 , 1, 0, 0, 1)
					DoScreenFadeIn(250)
				end
			end

			local tableCoords = Config.Locations["Stash"]
			local StashDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"])

			if StashDist < 10 then
				DrawMarker(2, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
			end

			if StashDist < 1.5 then
				inRange = true
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Kho lưu trữ")
				if IsControlJustReleased(0, Keys["E"]) then
					Other = {maxweight = 4000000, slots = 50}
					TriggerEvent("pepe-inventory:client:SetCurrentStash", "warzone_"..Framework.Functions.GetPlayerData().metadata['appartment-data'].Id)
					TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "warzone_"..Framework.Functions.GetPlayerData().metadata['appartment-data'].Id, Other)
					TriggerEvent("pepe-sound:client:play", "stash-open", 0.4)
				end
			end
			
			local tableCoords = Config.Locations["Stashsky"]
			local Stashskylocal = GetDistanceBetweenCoords(plyCoords, Config.Locations["Stashsky"]["x"], Config.Locations["Stashsky"]["y"], Config.Locations["Stashsky"]["z"])

			if Stashskylocal < 10 then
				DrawMarker(2, Config.Locations["Stashsky"]["x"], Config.Locations["Stashsky"]["y"], Config.Locations["Stashsky"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
			end

			if Stashskylocal < 1.5 then
				inRange = true
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Tủ lưu trữ")
				if IsControlJustReleased(0, Keys["E"]) then
					Other = {maxweight = 500000, slots = 30}
					TriggerEvent("pepe-inventory:client:SetCurrentStash", "skylocal_"..Framework.Functions.GetPlayerData().metadata['appartment-data'].Id)
					TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "skylocal_"..Framework.Functions.GetPlayerData().metadata['appartment-data'].Id, Other)
					TriggerEvent("pepe-sound:client:play", "stash-open", 0.4)
				end
			end

			local tableCoords = Config.Locations["WeaponShop"]
			local WeaponShopDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["WeaponShop"]["x"], Config.Locations["WeaponShop"]["y"], Config.Locations["WeaponShop"]["z"])

			if WeaponShopDist < 50.0 then
				DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Cửa hàng vũ khí")
			end

			if WeaponShopDist < 1.5 then
				inRange = true
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerServerEvent("pepe-inventory:server:OpenInventory", "shop", "warzone", Config.Items)
				end
			end

			local tableCoords = Config.Locations["RentCar"]
			local RentCarDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["RentCar"]["x"], Config.Locations["RentCar"]["y"], Config.Locations["RentCar"]["z"])

			if RentCarDist < 10 then
				DrawMarker(2, Config.Locations["RentCar"]["x"], Config.Locations["RentCar"]["y"], Config.Locations["RentCar"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Thuê xe 1000$")
			end

			if RentCarDist < 1.5 then
				inRange = true
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerServerEvent("kingwolf-warzone:server:CheckRental")
				end
			end

			local tableCoords = Config.Locations["UnRent"]
			local UnRentDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["UnRent"]["x"], Config.Locations["UnRent"]["y"], Config.Locations["UnRent"]["z"])
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				if UnRentDist < 50.0 then
					DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
					Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Trả xe")
				end

				if UnRentDist < 1.5 then
					inRange = true
					if IsControlJustReleased(0, Keys["E"]) then
						Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
					end
				end
			end

			
			local tableCoords = Config.Locations["RentCar2"]
			local RentCarDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["RentCar2"]["x"], Config.Locations["RentCar2"]["y"], Config.Locations["RentCar2"]["z"])

			if RentCarDist < 10 then
				DrawMarker(2, Config.Locations["RentCar2"]["x"], Config.Locations["RentCar2"]["y"], Config.Locations["RentCar2"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Thuê xe Halftrack 50000$")
			end

			if RentCarDist < 1.5 then
				inRange = true
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerServerEvent("kingwolf-warzone:server:CheckRental2")
				end
			end

			local tableCoords = Config.Locations["UnRent2"]
			local UnRentDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["UnRent2"]["x"], Config.Locations["UnRent2"]["y"], Config.Locations["UnRent2"]["z"])
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				if UnRentDist < 50.0 then
					DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
					Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Trả xe Halftrack")
				end

				if UnRentDist < 1.5 then
					inRange = true
					if IsControlJustReleased(0, Keys["E"]) then
						Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
					end
				end
			end

			local tableCoords = Config.Locations["Renttank"]
			local RentCarDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["Renttank"]["x"], Config.Locations["Renttank"]["y"], Config.Locations["Renttank"]["z"])

			if RentCarDist < 10 then
				DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
				Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Xe Tank 500.000$")
			end

			if RentCarDist < 1.5 then
				inRange = true
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerServerEvent("kingwolf-warzone:server:CheckRental3")
				end
			end

			local tableCoords = Config.Locations["UnRentank"]
			local UnRentDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["UnRentank"]["x"], Config.Locations["UnRentank"]["y"], Config.Locations["UnRentank"]["z"])
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				if UnRentDist < 50.0 then
					DrawMarker(1, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 0, 0, 200, 0, 0, 0, 0)
					Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"], "~g~[E]~w~ Hủy Xe Tank")
				end

				if UnRentDist < 1.5 then
					inRange = true
					if IsControlJustReleased(0, Keys["E"]) then
						Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if isLoggedIn then
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

			local WarZoneDistance = GetDistanceBetweenCoords(plyCoords, Config.Locations["WarZone"]["x"], Config.Locations["WarZone"]["y"], Config.Locations["WarZone"]["z"])

			if WarZoneDistance < Config.Radius then
				if exports['pepe-hospital']:GetDeathStatus() then
					if Config.Timer > 0 then
						DrawTxt(0.76, 1.35, 1.0,1.0,0.6, "TỰ ĐỘNG HỒI SINH SAU: ~r~" .. math.ceil(Config.Timer) .. "~w~ GIÂY", 255, 255, 255, 255)
					elseif not Reviving then
						Reviving = true
						Config.Timer = 3
						StartTimer()
					end
				else
					Citizen.Wait(450)
				end
			end
		end
    end
end)

function StartTimer()
	Citizen.CreateThread(function()
		while Config.Timer > 0 do
			Citizen.Wait(1000)
			Config.Timer = Config.Timer - 1
			if Config.Timer == 0 then
				Reviving = false
				TriggerEvent('pepe-hospital:client:revive')
				SetEntityCoords(GetPlayerPed(-1), Config.Locations["Revive"]["x"], Config.Locations["Revive"]["y"], Config.Locations["Revive"]["z"] + 0.5 , 1, 0, 0, 1)
			end
		end
	end)
end

RegisterNetEvent('kingwolf-warzone:client:spawn:vehicle')
AddEventHandler('kingwolf-warzone:client:spawn:vehicle', function()
	local isSpawnPointClear = false
	for i = 1, #Config.Locations['Spawns'] do
		if isSpawnPointClear then
			break
		end
		local spawnCoords = Config.Locations['Spawns'][i]
		local CoordTable = {x = spawnCoords['x'], y = spawnCoords['y'], z = spawnCoords['z'], a = spawnCoords['h']}    
		if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
			isSpawnPointClear = true
			
			Framework.Functions.SpawnVehicle("winky", function(Vehicle)
				local plateText = "WZ"..math.random(100000, 999999)
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


RegisterNetEvent('kingwolf-warzone:client:spawn:vehicle2')
AddEventHandler('kingwolf-warzone:client:spawn:vehicle2', function()
	local isSpawnPointClear = false
	for i = 1, #Config.Locations['Spawns2'] do
		if isSpawnPointClear then
			break
		end
		local spawnCoords = Config.Locations['Spawns2'][i]
		local CoordTable = {x = spawnCoords['x'], y = spawnCoords['y'], z = spawnCoords['z'], a = spawnCoords['h']}    
		if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
			isSpawnPointClear = true
			
			Framework.Functions.SpawnVehicle("Halftrack", function(Vehicle)
				local plateText = "WZ"..math.random(100000, 999999)
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

RegisterNetEvent('kingwolf-warzone:client:spawn:vehicle3')
AddEventHandler('kingwolf-warzone:client:spawn:vehicle3', function()
	local isSpawnPointClear = false
	for i = 1, #Config.Locations['Spawnstank'] do
		if isSpawnPointClear then
			break
		end
		local spawnCoords = Config.Locations['Spawnstank'][i]
		local CoordTable = {x = spawnCoords['x'], y = spawnCoords['y'], z = spawnCoords['z'], a = spawnCoords['h']}    
		if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
			isSpawnPointClear = true
			
			Framework.Functions.SpawnVehicle("Rhino", function(Vehicle)
				local plateText = "WZ"..math.random(100000, 999999)
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
	blips = AddBlipForCoord(Config.Locations["WarZone"]["x"], Config.Locations["WarZone"]["y"], Config.Locations["WarZone"]["z"])
	SetBlipSprite(blips, 390)
	SetBlipDisplay(blips, 4)
	SetBlipScale(blips, 0.8)
	SetBlipColour(blips, 2)
	SetBlipAsShortRange(blips, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Vùng chiến đấu")
	EndTextCommandSetBlipName(blips)
	blipareas(Config.Locations["WarZone"]["x"], Config.Locations["WarZone"]["y"], Config.Locations["WarZone"]["z"], Config.Radius, 1)

	blips = AddBlipForCoord(Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"])
	SetBlipSprite(blips, 40)
	SetBlipDisplay(blips, 4)
	SetBlipScale(blips, 0.8)
	SetBlipColour(blips, 2)
	SetBlipAsShortRange(blips, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Kho lưu trữ")
	EndTextCommandSetBlipName(blips)

	blips = AddBlipForCoord(Config.Locations["Stashsky"]["x"], Config.Locations["Stashsky"]["y"], Config.Locations["Stashsky"]["z"])
	SetBlipSprite(blips, 40)
	SetBlipDisplay(blips, 4)
	SetBlipScale(blips, 0.8)
	SetBlipColour(blips, 2)
	SetBlipAsShortRange(blips, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Tủ lưu trữ")
	EndTextCommandSetBlipName(blips)
end)

function blipareas(x,y,z,radius,idcolor)
	local blip = AddBlipForRadius(x, y, z ,radius) 
		  SetBlipColour(blip,idcolor)
		  SetBlipAlpha(blip,80)
		  SetBlipSprite(blip,9)
	return blip
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