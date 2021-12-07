-- SCRIPT DEVELOPED BY OSMIUM | OSMFX | DISCORD.IO/OSMFX --

Framework = nil
isLoggedIn = false
isSpawnSellNPC = false
local menuOpen = false
local wasOpen = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local spawnedCorns = 0
local cornPlants = {}
local isPickingUp, isProcessing = false, false

local f = false
local b = 0
local water = false

local rented = false
local track = false
local trackspots = {}
local counttracks = 0
local oranges = nil 
local rices = nil 
local cowmilking = false
local cowobjects = {}

local hasbox = false

local rentveh = nil 

Citizen.CreateThread(function()
	for _, info in pairs(Config.Blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, info.scale)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end) 

local sleep = 1000

Citizen.CreateThread(function()
	-- local g = false
	while true do
		-- Citizen.Wait(5)
		Citizen.Wait(sleep)
		if not f then
			local h = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.CircleZones.FarmCoords.coords, true)
			if h < 100 and not track then
				CreateTrackSpots()
				track = true
			else
				track = false
			end
			local cowdis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.CircleZones.CowFarm.coords, true)
			if cowdis < 100 and not cowmilking then
				CreateCows()
				cowmilking = true
			else
				cowmilking = false
			end
			if not cowmilking or not track and not oranges then 
				for i = 1, #Config.OrangeFarm do		
					local orangedis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.OrangeFarm[i], true)
					
					if orangedis < 1.5 then 
						Draw3DText(Config.OrangeFarm[i].x, Config.OrangeFarm[i].y, Config.OrangeFarm[i].z, '[E] - Hái cam', 4, 0.08, 0.08, Config.SecondaryColor)
						if IsControlJustReleased(0, 38) and not oranges then
							if (Framework.Functions.GetPlayerData().metadata["currentrank"] == nil or Framework.Functions.GetPlayerData().metadata["currentrank"] < 2) then
								Framework.Functions.Notify("Bạn chưa đủ điều kiện để farm khu vực này (Yêu cầu: Level 2)", "error")
							else
								oranges = true
								PickOrange()
							end
						elseif IsControlJustReleased(0, 38) and oranges then
							Framework.Functions.Notify('Thao tác quá nhanh, vui lòng chờ cam chín!')
						end
					elseif orangedis < 10 then 
						DrawMarker(2, Config.OrangeFarm[i].x, Config.OrangeFarm[i].y, Config.OrangeFarm[i].z , 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.15, 209, 41, 242, 200, 0, 0, 0, 0)
					end
				end
				sleep = 5
			else
				sleep = 1000
			end
		else
			Citizen.Wait(sleep)
		end
	end
end)

Citizen.CreateThread(function()
	-- local g = false
	while true do
		-- Citizen.Wait(5)
		Citizen.Wait(sleep)
		if not cowmilking or not track and not rices then 
			for i = 1, #Config.RiceFarm do		
				local orangedis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.RiceFarm[i], true)
				
				if orangedis < 1.5 then 
					Draw3DText(Config.RiceFarm[i].x, Config.RiceFarm[i].y, Config.RiceFarm[i].z, '[E] - Gặt lúa', 4, 0.08, 0.08, Config.SecondaryColor)
					if IsControlJustReleased(0, 38) and not rices then
						rices = true
						GatLua()
					elseif IsControlJustReleased(0, 38) and rices then
						Framework.Functions.Notify('Thao tác quá nhanh, vui lòng chờ lúa mì chín!')
					end
				elseif orangedis < 10 then 
					DrawMarker(2, Config.RiceFarm[i].x, Config.RiceFarm[i].y, Config.RiceFarm[i].z , 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.15, 209, 41, 242, 200, 0, 0, 0, 0)
				end
			end
			sleep = 5
		else
			sleep = 1000
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CornProcessing.coords, true) < 3 then
			DrawMarker(27, Config.CircleZones.CornProcessing.coords.x, Config.CircleZones.CornProcessing.coords.y, Config.CircleZones.CornProcessing.coords.z - 1 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)

			if GetDistanceBetweenCoords(coords, Config.CircleZones.CornProcessing.coords, true) < 1.0 then
				if not isProcessing then
					Draw3DText(Config.CircleZones.CornProcessing.coords.x, Config.CircleZones.CornProcessing.coords.y, Config.CircleZones.CornProcessing.coords.z, '[E] - Đóng gói ngô', 4, 0.08, 0.08, Config.SecondaryColor)
				end

				if IsControlJustReleased(0, 38) and not isProcessing then
					ProcessCorn()
				end
			end

		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.Boxes.coords, true) < 3 then
			local nowcoords = Config.CircleZones.Boxes.coords
			DrawMarker(27, nowcoords.x, nowcoords.y, nowcoords.z - 1 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(coords, Config.CircleZones.Boxes.coords, true) < 1.0 then
				if not isProcessing then
					Draw3DText(nowcoords.x, nowcoords.y,nowcoords.z, '[E] - Lấy hộp đóng gói', 4, 0.08, 0.08, Config.SecondaryColor)
				end
				if IsControlJustReleased(0, 38) and not isProcessing then
					Framework.Functions.TriggerCallback('Framework:HasItem', function(result)
						if result then
							Framework.Functions.Notify('Bạn đã có hộp đóng gói!')
						else 
							TriggerServerEvent('pepe-farming:GivePlayerBox')
						end
					end, 'box')
				end
			end

		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.OrangePack.coords, true) < 3 then
			local nowcoords = Config.CircleZones.OrangePack.coords
			DrawMarker(27, nowcoords.x, nowcoords.y, nowcoords.z - 1 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(coords, Config.CircleZones.OrangePack.coords, true) < 1.0 then
				if not isProcessing then
					Draw3DText(nowcoords.x, nowcoords.y,nowcoords.z, '[E] - Đóng gói cam', 4, 0.08, 0.08, Config.SecondaryColor)
				end
				if IsControlJustReleased(0, 38) and not isProcessing then
					ProcessOranges()
				end
			end
		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.MilkPack.coords, true) < 3 then
			local nowcoords = Config.CircleZones.MilkPack.coords
			DrawMarker(27, nowcoords.x, nowcoords.y, nowcoords.z - 1 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(coords, Config.CircleZones.MilkPack.coords, true) < 1.0 then
				if not isProcessing then
					Draw3DText(nowcoords.x, nowcoords.y,nowcoords.z, '[E] - Chế biến sữa', 4, 0.08, 0.08, Config.SecondaryColor)
				end
				if IsControlJustReleased(0, 38) and not isProcessing then
					ProcessMilk()
				end
			end
		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.RiceProcessing.coords, true) < 3 then
			local nowcoords = Config.CircleZones.RiceProcessing.coords
			DrawMarker(27, nowcoords.x, nowcoords.y, nowcoords.z - 1 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(coords, Config.CircleZones.RiceProcessing.coords, true) < 1.0 then
				if not isProcessing then
					Draw3DText(nowcoords.x, nowcoords.y,nowcoords.z, '[E] - Xay lúa', 4, 0.08, 0.08, Config.SecondaryColor)
				end
				if IsControlJustReleased(0, 38) and not isProcessing then
					XayLua()
				end
			end
		elseif GetDistanceBetweenCoords(coords, Config.TractorCoords, true) < 3 then
			if not rented then
				Draw3DText(Config.TractorCoords.x, Config.TractorCoords.y, Config.TractorCoords.z, '[E] - Thuê xe kéo', 4, 0.08, 0.08, Config.SecondaryColor)
			end
			if rented then 
				Draw3DText(Config.TractorCoords.x, Config.TractorCoords.y, Config.TractorCoords.z, '[E] - Trả xe kéo', 4, 0.08, 0.08, Config.SecondaryColor)
			end

			if IsControlJustReleased(0, 38) and not rented then
				if (Framework.Functions.GetPlayerData().metadata["currentrank"] == nil or Framework.Functions.GetPlayerData().metadata["currentrank"] < 3) then
					Framework.Functions.Notify("Bạn chưa đủ điều kiện để farm khu vực này (Yêu cầu: Level 3)", "error")
				else
					if Framework.Functions.IsSpawnPointClear(Config.TractorSpawn, 3.0) then
						Framework.Functions.Notify('Bạn đã thuê máy kéo!', 'success', 5000) -- [text] = message, [type] = primary | error | success, [length] = time till fadeout.
						TriggerServerEvent('pepe-farming:server:SpawnTractor')
					else
						Framework.Functions.Notify("Khu vực lấy xe đã đầy.", "error")
					end
				end
				
			end
			if IsControlJustReleased(0, 38) and rented then
				Framework.Functions.Notify('Bạn đã trả máy kéo', 'success', 5000) -- [text] = message, [type] = primary | error | success, [length] = time till fadeout.
				TriggerServerEvent('Server:UnRentTractor')
			end
		else
			Citizen.Wait(500)
		end

		if GetDistanceBetweenCoords(coords, Config.CircleZones.RicePack.coords, true) < 3 then
			local nowcoords = Config.CircleZones.RicePack.coords
			DrawMarker(27, nowcoords.x, nowcoords.y, nowcoords.z - 1 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(coords, Config.CircleZones.RicePack.coords, true) < 1.0 then
				if not isProcessing then
					Draw3DText(nowcoords.x, nowcoords.y,nowcoords.z, '[E] - Đóng gói lúa', 4, 0.08, 0.08, Config.SecondaryColor)
				end
				if IsControlJustReleased(0, 38) and not isProcessing then
					DongGoiLua()
				end
			end
		end
	end
end)

local sellItemsSet = false
local sellPrice = 0
local sellHardwareItemsSet = false
local sellHardwarePrice = 0

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local inRange = false
		
		local pos = GetEntityCoords(GetPlayerPed(-1))
		-- if not isSpawnSellNPC then
		-- 	if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z, true) < 5.0 then
		-- 		Framework.Functions.TriggerCallback('pepe-farming:server:isSpawnedNPC', function(result)
		-- 			if not result then
		-- 				TriggerServerEvent('pepe-farming:server:spawnNPC')
		-- 				isSpawnSellNPC = true
		-- 			end
		-- 		end)
		-- 		Wait(1)			
		-- 	else 
		-- 		isSpawnSellNPC = false
		-- 	end
		-- end
		if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z, true) < 5.0 then
			inRange = true
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z, true) < 1.5 then
					if not sellItemsSet then 
						sellPrice = GetSellingPrice()
						sellItemsSet = true
					elseif sellItemsSet and sellPrice ~= 0 then
						DrawText3D(Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z, "~g~E~w~ - Bán nông sản ($"..sellPrice..")")
						if IsControlJustReleased(0, 38) then
							TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
                            Framework.Functions.Progressbar("sell_pawn_items", "Đang bán hàng..", math.random(15000, 25000), false, true, {}, {}, {}, {}, function() -- Done
                                ClearPedTasks(GetPlayerPed(-1))
								TriggerServerEvent("pepe-farming:server:SellFarmingItems")
								sellItemsSet = false
								sellPrice = 0
                            end, function() -- Cancel
								ClearPedTasks(GetPlayerPed(-1))
								Framework.Functions.Notify("Đã hủy bỏ..", "error")
							end)
						end
					else
						DrawText3D(Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z, "Bạn không có gì để bán..")
					end
			end
		end
		if not inRange then
			sellPrice = 0
			sellItemsSet = false
			Citizen.Wait(2500)
		end
	end
end)

RegisterNetEvent('SpawnTractor')
AddEventHandler('SpawnTractor', function()
	SetNewWaypoint(Config.TractorSpawn.x, Config.TractorSpawn.y)
	Framework.Functions.SpawnVehicle(Config.Tractor, function(veh)
		-- TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
		local plateText = "CORN"..tostring(math.random(1000, 9999))
		SetVehicleNumberPlateText(veh, plateText)
		exports['pepe-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
		SetEntityHeading(veh, Config.TractorSpawnHeading)
		SetEntityAsMissionEntity(veh, true, true)
		exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
		TriggerServerEvent("vehicletuning:server:SaveVehicleProps", Framework.Functions.GetVehicleProperties(veh))
		-- TriggerServerEvent("pepe-carrentals:server:sql", num, plate, veh)
		SetEntityAsMissionEntity(veh, true, true)
		rentveh = veh
		rented = true
		Framework.Functions.TriggerCallback('kingwolf-common:server:registerPlate', function(canReg)
			if not canReg then
				Framework.Functions.Notify("Không thể đăng ký thông tin biển số xe.")
			end
		end, plateText)
	end, Config.TractorSpawn, false)
		
	-- end
end)

RegisterNetEvent('UnRentTractor')
AddEventHandler('UnRentTractor', function()
	DeleteEntity(rentveh)
	rented = false
end)

-- RegisterNetEvent('pepe-farming:client:spawnNPC')
-- AddEventHandler('pepe-farming:client:spawnNPC', function()
-- 	RequestModel(GetHashKey('a_m_m_fatlatin_01'))

-- 	while not HasModelLoaded(GetHashKey('a_m_m_fatlatin_01')) do

-- 	Wait(1)

-- 	end

-- 	local fatPed = CreatePed(4, "a_m_m_fatlatin_01", Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z, Config.SellLocation.h, true, true)
-- 	FreezeEntityPosition(fatPed, true)
-- end)

function GetSellingPrice()
	local price = 0
	Framework.Functions.TriggerCallback('pepe-farming:server:GetSellingPrice', function(result)
		price = result
	end)
	Citizen.Wait(500)
	return price
end

function ProcessCorn()
	isProcessing = true
	local playerPed = PlayerPedId()

	
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	-- exports['progressBars']:startUI(15000, "Processing..")

	Framework.Functions.Progressbar("search_register", "Đang đóng gói..", Config.Delays.CornProcessing, false, true, {--15000
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('pepe-farming:ProcessCorn')
		-- local timeLeft = Config.Delays.CornProcessing / 1000

		-- while timeLeft > 0 do
		-- 	Citizen.Wait(1000)
		-- 	timeLeft = timeLeft - 1

		-- 	if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CornProcessing.coords, false) > 4 then
		-- 		TriggerServerEvent('pepe-farming:cancelProcessing')
		-- 		break
		-- 	end
		-- end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel
		
	
	isProcessing = false
end

function ProcessMilk()
	isProcessing = true
	local playerPed = PlayerPedId()

	
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	-- exports['progressBars']:startUI(15000, "Processing..")

	Framework.Functions.Progressbar("search_register", "Đang đóng gói..", Config.Delays.CornProcessing, false, true, {--15000
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('pepe-farming:ProcessMilk')
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel
		
	
	isProcessing = false
end

function ProcessOranges()
	isProcessing = true
	local playerPed = PlayerPedId()

	
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	-- exports['progressBars']:startUI(15000, "Processing..")

	Framework.Functions.Progressbar("search_register", "Đang đóng gói..", Config.Delays.CornProcessing, false, true, {--15000
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('pepe-farming:ProcessOranges')
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel
		
	
	isProcessing = false
end

function XayLua()
	local ad = "anim@mp_player_intupperair_shagging"
	local anim = "idle_a"
	local player = PlayerPedId()

	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 8 ) ) then
			TaskPlayAnim( player, ad, "exit", 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
			ClearPedSecondaryTask(player)
		else
			Citizen.Wait(50)
			TaskPlayAnim( player, ad, anim, 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
		end
    end
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		Framework.Functions.Progressbar("search_register", "Đang xay lúa..", 7000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-farming:XayLua')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(250)
			isProcessing = false
		end, function()
			Citizen.Wait(250)
			isProcessing = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		isProcessing = false
	end
end

function DongGoiLua()
	local ad = "anim@mp_player_intupperair_shagging"
	local anim = "idle_a"
	local player = PlayerPedId()

	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 8 ) ) then
			TaskPlayAnim( player, ad, "exit", 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
			ClearPedSecondaryTask(player)
		else
			Citizen.Wait(50)
			TaskPlayAnim( player, ad, anim, 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
		end
    end
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		Framework.Functions.Progressbar("search_register", "Đang đóng gói lúa..", 7000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-farming:DongGoiLua')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(250)
			isProcessing = false
		end, function()
			Citizen.Wait(250)
			isProcessing = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		isProcessing = false
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		local nearbySpot, spotID

		for i=1, #cornPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(cornPlants[i]), false) < 1 then
				nearbyObject, nearbyID = cornPlants[i], i
			end
		end
		for i=1, #trackspots, 1 do 
			if GetDistanceBetweenCoords(coords, GetEntityCoords(trackspots[i]), false) < 3 then
				nearbySpot, spotID = trackspots[i], i
			end
		end
		local playerVehicle = GetVehiclePedIsIn(playerPed, false)

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				-- DrawText2D(0.4, 0.8, '~w~Press ~g~[E]~w~ to Pickup Corn')
				local coord1 = GetEntityCoords(nearbyObject)
				Draw3DText(coord1.x, coord1.y, coord1.z + 1.5, '[E] - Thu hoạch ngô', 4, 0.08, 0.08, Config.SecondaryColor)
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if not exports['pepe-progressbar']:GetTaskBarStatus() then
					isPickingUp = true
					TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

					-- Framework.Functions.Notify("Picking up Corn Kernel!", "error", 10000)
					-- exports['progressBars']:startUI(5000, "Picking up Corn Kernel!")
					Framework.Functions.Progressbar("search_register", "Đang thu hoạch!", 15000, false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {}, {}, {}, function() -- Done
						ClearPedTasks(PlayerPedId())
						DeleteObject(nearbyObject)

						table.remove(cornPlants, nearbyID)
						spawnedCorns = spawnedCorns - 1

						if #cornPlants == 0 then 
							track = false
						end
		
						TriggerServerEvent('pepe-farming:pickedUpCannabis')
						isPickingUp = false
					end, function()
						ClearPedTasks(PlayerPedId())
						isPickingUp = false
					end) -- Cancel
				end
			end

		elseif nearbySpot and GetEntityModel(playerVehicle) == `tractor3` then

			if not isPickingUp then
				local coord = GetEntityCoords(trackspots[spotID])
				Draw3DText(coord.x, coord.y, coord.z + 1.5, '[E] - Làm ruộng', 4, 0.2, 0.2, Config.SecondaryColor)
			end

			if IsControlJustReleased(0, 38) then
				if (Framework.Functions.GetPlayerData().metadata["currentrank"] == nil or Framework.Functions.GetPlayerData().metadata["currentrank"] < 3) then
					Framework.Functions.Notify("Bạn chưa đủ điều kiện để farm khu vực này (Yêu cầu: Level 3)", "error")
				else
					FreezeEntityPosition(GetPlayerPed(-1), true)
					isPickingUp = true
					Framework.Functions.Progressbar("track-corn", "Đang cày ruộng..", 10000, false, true, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {}, {}, {}, function() -- Done
						counttracks = counttracks - 1
						ClearPedTasks(PlayerPedId())
						DeleteObject(nearbySpot)
						table.remove(trackspots, spotID)

						if counttracks == 0 then 
							water = true
							Framework.Functions.Notify("Đã cày ruộng xong! Hãy bơm nước cho ruộng ngô!", "success", 10000)
							Citizen.Wait(100) -- For Variable Defining Delay
							WaterStart()
						end
						isPickingUp = false
						ClearPedTasks(PlayerPedId())
						FreezeEntityPosition(GetPlayerPed(-1), false)
					end, function()
						isPickingUp = false
						ClearPedTasks(PlayerPedId())
						FreezeEntityPosition(GetPlayerPed(-1), false)
					end) -- Cancel					
						-- spawnedCorns = spawnedCorns - 1
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbycow, cowid

		for i=1, #cowobjects, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(cowobjects[i]), false) < 2 then
				nearbycow, cowid = cowobjects[i], i
			end
		end

		if nearbycow and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				local coord1 = GetEntityCoords(nearbycow)
				Draw3DText(coord1.x, coord1.y, coord1.z + 1.5, '[E] - Vắt sữa bò', 4, 0.07, 0.07, Config.SecondaryColor)
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if (Framework.Functions.GetPlayerData().metadata["currentrank"] == nil or Framework.Functions.GetPlayerData().metadata["currentrank"] < 2) then
					Framework.Functions.Notify("Bạn chưa đủ điều kiện để farm khu vực này (Yêu cầu: Level 2)", "error")
				else
					Citizen.Wait(5)
					if math.random(1,10) > 4 and not isPickingUp then 
						FreezeEntityPosition(nearbycow, true)
						TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
						MilkCow(nearbycow)
					else
						Framework.Functions.Notify('Bạn không lấy được Sữa Bò! Hãy thử lại!')
					end
				end
				
			end
		else
			Citizen.Wait(500)
		end

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		if #cowobjects ~= nil or #cowobjects ~= 0 then
			for k, v in pairs(cowobjects) do
				TaskPedSlideToCoord(v, 2540.9519042969,4788.830078125,33.564464569092, 50, 10)
			end
			Citizen.Wait(60000)
			for k, v in pairs(cowobjects) do
				TaskPedSlideToCoord(v, 2463.6857910156,4734.30078125,34.303768157959, 50, 10)
			end
			Citizen.Wait(60000)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(cornPlants) do
			DeleteObject(v)
		end
		for k, v in pairs(trackspots) do
			DeleteObject(v)
		end
		for k, v in pairs(cowobjects) do
			DeleteObject(v)
		end
	end
end)

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,color)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local UI = {
    x =  0.000 ,	-- Base Screen Coords 	+ 	 x
    y = -0.001 ,	-- Base Screen Coords 	+ 	-y
}

local prog = 0 

function MilkCow(nearbycow)
	Citizen.Wait(100)
	if not isPickingUp then
		if not exports['pepe-progressbar']:GetTaskBarStatus() then
			isPickingUp = true
			Citizen.SetTimeout(500, function()
				Framework.Functions.Progressbar("milk-cow", "Vắt sữa bò..", 10000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function() -- Done
					TriggerServerEvent('pepe-farming:CowMilked')
					isPickingUp = false
					ClearPedTasks(PlayerPedId())
					FreezeEntityPosition(nearbycow, false)
				end, function()
					isPickingUp = false
					ClearPedTasks(PlayerPedId())
					FreezeEntityPosition(nearbycow, false)
				end) -- Cancel
			end)
		end
	end
end

-- RegisterNetEvent('pepe-farming:internal:CowProgress')
-- AddEventHandler('pepe-farming:internal:CowProgress', function()
-- 	print(prog)
-- 	while prog < 101 do 
-- 		print(prog)
-- 		prog = prog + 1
-- 		Citizen.Wait(100)
-- 		if prog == 101 then 
-- 			prog = 0
-- 			break
-- 		end
-- 	end
-- end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
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

function SpawnCornPlants()
	math.randomseed(GetGameTimer())
    local random = math.random(30, 40)
	local hash = GetHashKey(Config.CornPlant)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(1)
    end
    while b < random do
		Citizen.Wait(1)
		local D = GenerateWeedCoords(Config.CircleZones.FarmCoords.coords)
		-- print(D)

        local E = CreateObject(hash, D.x, D.y, D.z, false, false, true)
        PlaceObjectOnGroundProperly(E)
        FreezeEntityPosition(E, true)
        table.insert(cornPlants, E)
        b = b + 1
    end
end

function PickOrange()
	local ad = "amb@prop_human_movie_bulb@base"
	local anim = "base"
	local player = PlayerPedId()

	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 8 ) ) then
			TaskPlayAnim( player, ad, "exit", 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
			ClearPedSecondaryTask(player)
		else
			Citizen.Wait(50)
			TaskPlayAnim( player, ad, anim, 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
		end
    end
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		Framework.Functions.Progressbar("search_register", "Đang hái cam..", 15000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-farming:GiveOranges')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(5000)
			oranges = false
		end, function()
			Citizen.Wait(5000)
			oranges = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		oranges = false
	end
end

function GatLua()
	local ad = "switch@trevor@mocks_lapdance"
	local anim = "001443_01_trvs_28_idle_stripper"
	local player = PlayerPedId()

	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 8 ) ) then
			TaskPlayAnim( player, ad, "exit", 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
			ClearPedSecondaryTask(player)
		else
			Citizen.Wait(50)
			TaskPlayAnim( player, ad, anim, 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
		end
    end
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		Framework.Functions.Progressbar("search_register", "Đang gặt lúa..", 7000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-farming:GatLua')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(5000)
			rices = false
		end, function()
			Citizen.Wait(5000)
			rices = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		rices = false
	end
end

function WaterStart()
	while true do 
		Citizen.Wait(5)
		local h = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.CircleZones.Water.coords, true)
		if water then 
			if h < 5 then
					Draw3DText(Config.CircleZones.Water.coords.x, Config.CircleZones.Water.coords.y, Config.CircleZones.Water.coords.z, '[E] - Bơm nước', 4, 0.08, 0.08, Config.SecondaryColor)
				if IsControlJustReleased(0, 38) then
					if not exports['pepe-progressbar']:GetTaskBarStatus() then
						TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
						Framework.Functions.Progressbar("search_register", "Đang bơm nước!", 30000, false, true, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {}, {}, {}, function() -- Done
							SpawnCornPlants()
							Framework.Functions.Notify('Bơm nước thành công, ngô đang phát triển!', 'success', 6000)
							water = false
						end, function()
							ClearPedTasks(PlayerPedId())
						end) -- Cancel
					end
				end
			else
				Citizen.Wait(500)
			end
		else 
			break
		end
	end
end

local c = 0
function CreateTrackSpots()
	-- counttracks = 0
	math.randomseed(GetGameTimer())
    local random = math.random(5, 10)
	local hash = GetHashKey(Config.MowProp)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(1)
    end
    while c < random do
		Citizen.Wait(1)
		local DE = GenerateWeedCoords(Config.CircleZones.FarmCoords.coords)
        local EE = CreateObject(hash, DE.x, DE.y, DE.z, false, false, true)
        PlaceObjectOnGroundProperly(EE)
        FreezeEntityPosition(EE, true)
		counttracks = counttracks + 1
        table.insert(trackspots, EE)
        c = c + 1
    end
end

local cd = 0

function CreateCows()

	math.randomseed(GetGameTimer())
    local random = math.random(5, 10)
	local hash2 = GetHashKey(Config.CowProp)
    RequestModel(hash2)
    while not HasModelLoaded(hash2) do
        Citizen.Wait(1)
    end
    while cd < random do
		Citizen.Wait(1)
		local DEF = GenerateWeedCoords(Config.CircleZones.CowFarm.coords)
		-- print(DEF)
		-- local EEF = CreateObject(hash2, DEF.x, DEF.y, DEF.z + 3, false, false, true)
		local EEF =  CreatePed(4, hash2, DEF.x, DEF.y, DEF.z, -149.404, false, true)
		SetEntityInvincible(EEF, true)
        PlaceObjectOnGroundProperly(EEF)
		-- TaskReactAndFleePed(EEF, PlayerPedId())
		Citizen.Wait(1000)
        table.insert(cowobjects, EEF)
		-- print(cd)
        cd = cd + 1
    end
end

function ValidateWeedCoord(plantCoord)
	if spawnedCorns > 0 then
		local validate = true

		for k, v in pairs(cornPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.FarmCoords.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords(data)
	while true do
		Citizen.Wait(1)

		local cornCoordX, cornCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-30,30)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-30, 30)

		cornCoordX = data.x + modX
		cornCoordY = data.y + modY

		local coordZ = GetCoordZ(cornCoordX, cornCoordY)
		local coord = vector3(cornCoordX, cornCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			-- print('cord', coord)
			return coord
		end
	end
end

function GetCoordZ(x, y)
    --local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0 }
	local groundCheckHeights = { 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0 }
    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, 900.0, 1)
		-- print('za', z)
        if foundGround then
			-- print('z', z)
            return z
        end
    end

    return 31.0
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
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
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
