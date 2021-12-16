PlayerData = {}

Framework = nil

local job = nil
local isMarketOpen = false
local blipsLoaded = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Framework.Functions.GetPlayerData(function(pData)
        PlayerData = pData
		job = pData.job
    end)
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
	job = JobInfo
end)

if not Config.UseBlipToAccessMarket then
	RegisterCommand(Config.MarketCommand, function()
		TriggerEvent('okokMarketplace:open')
	end, false)
else
	Citizen.CreateThread(function()
		if Config.ShowBlipsOnMap then
			Citizen.Wait(2000)
			for k,v in ipairs(Config.BlipCoords) do
				local blip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(blip, v.blipId)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, v.blipScale)
				SetBlipColour(blip, v.blipColor)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.blipText)
				EndTextCommandSetBlipName(blip)
			end
		end
	end)

	Citizen.CreateThread(function()
		if not blipsLoaded then
			blipsLoaded = true
			Citizen.Wait(2000)
			local playerPed = GetPlayerPed(-1)
			local waitMoreTime = true
			local playerExists = false
			while Config.ShowFloorBlips do
				Citizen.Wait(5)
				if not playerExists then
					if DoesEntityExist(playerPed) then
						playerExists = true
					else
						playerPed = GetPlayerPed(-1)
					end
				end

				if playerExists then
					local playerCoords = GetEntityCoords(PlayerPedId())

					if waitMoreTime then
						waitMoreTime = false
					end
					
					for k,v in pairs(Config.BlipCoords) do
						local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.x, v.y, v.z)
						if distance < v.showMarkerRadius then
							DrawMarker(v.MarkerID, v.x, v.y, v.z-0.0, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.75, 31, 94, 255, 155, 0, 0, 2, 1, 0, 0, 0)
						end
					end
				end

				if waitMoreTime then
					Citizen.Wait(1000)
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		local inZone = false
		local nearZone = false
		local enteredRange = false
		local inWideRange = false

		while true do
			Citizen.Wait(5)
			local playerCoords = GetEntityCoords(PlayerPedId())
			
			nearZone = false
			inZone = false

			for k,v in pairs(Config.BlipCoords) do
				local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.x, v.y, v.z)
			
				if distance < v.radius + 2 then
					local height = playerCoords.z - v.z
					nearZone = true
					if waitMore and not isMarketOpen then
						waitMore = false
					elseif not waitMore and isMarketOpen then
						waitMore = true
					end
					
					if distance < v.radius and height < 3 and height > -3 then
						inZone = true
						if not Config.UseOkokTextUI and not isMarketOpen then
							helpText('~INPUT_CONTEXT~ To open the marketplace')
						end

						if IsControlJustReleased(0, Config.OpenMarketKey) then
							if GetVehiclePedIsUsing(PlayerPedId()) == 0 then
								TriggerEvent('okokMarketplace:open')
							else
								exports['okokNotify']:Alert("THÔNG BÁO", "Bạn không thể truy cập chotot khi đang ở trong xe", 5000, 'error')
							end
						end
					end
				elseif not waitMore and not inWideRange then
					waitMore = true
				end
			end

			if nearZone and not enteredRange then
				enteredRange = true
				inWideRange = true
			elseif not nearZone and enteredRange then
				enteredRange = false
				inWideRange = false
			end

			if inZone and not hasEntered then
				if Config.UseOkokTextUI then
					exports['okokTextUI']:Open('[E] Chợ tốt', 'darkblue', 'left') 
				end
				hasEntered = true
			elseif not inZone and hasEntered then
				if Config.UseOkokTextUI then
					exports['okokTextUI']:Close()
				end
				hasEntered = false
			end 

			if waitMore then
				Citizen.Wait(1000)
			end
		end
	end)
end

RegisterNetEvent("okokMarketplace:open")
AddEventHandler("okokMarketplace:open", function()
	local vehiclesTable = {}
	local itemsTable = {}
	local blackmarketTable = {}
	local accessBlackmarket = false
	if not isMarketOpen then
		Framework.Functions.TriggerCallback("okokMarketplace:getItems", function(vehicles, items, loadout)
			
			for k,v in ipairs(vehicles) do
				local canAdd = true
				for k2,v2 in ipairs(Config.BlacklistVehicles) do
					if GetDisplayNameFromVehicleModel(v.vehicle.model) == v2 then
						canAdd = false
						break
					end
				end

				if canAdd then
					table.insert(vehiclesTable, {vehicle = v.vehicle, plate = v.plate, name = GetDisplayNameFromVehicleModel(v.vehicle.model)})
				end
			end

			for k, v in ipairs(items) do
				local canAdd = true
				local blackmarketItem = false

				if items[k] ~= nil and items[k].amount > 0 then
					
					for k2,v2 in ipairs(Config.BlacklistItems) do
						if items[k].name == v2 then
							canAdd = false
							break
						end
					end

					if canAdd then
						table.insert(itemsTable, {id = items[k].name, label = items[k].label, count = items[k].amount})
					else
						for k2,v2 in ipairs(Config.Blackmarket) do
							if items[k].name == v2[1] and not v2[2] then
								blackmarketItem = true
								break
							end
						end

						if blackmarketItem then
							table.insert(blackmarketTable, {id = items[k].name, label = items[k].label, count = items[k].amount, type = "item"})
						end
					end
				end
			end

			for k,v in ipairs(loadout) do
				for k2,v2 in ipairs(Config.Blackmarket) do
					if v.name == v2[1] and v2[2] then
						table.insert(blackmarketTable, {id = v.name, label = v.label, count = 1, type = "weapon"})
					end
				end
			end
			
			Framework.Functions.TriggerCallback("okokMarketplace:getAds", function(vehAds, itemsAds, blackmarketAds, identifier)
				local vehAds1 = {}
				local itemsAds1 = {}
				local blackmarketAds1 = {}
				local myAds = {}

				for k,v in ipairs(vehAds) do
					if v.author_identifier ~= identifier then
						if not v.sold then
							table.insert(vehAds1, v)
						end
					else
						table.insert(myAds, v)
					end
				end

				for k,v in ipairs(itemsAds) do
					if v.author_identifier ~= identifier then
						if not v.sold then
							table.insert(itemsAds1, v)
						end
					else
						table.insert(myAds, v)
					end
				end

				for k,v in ipairs(blackmarketAds) do
					if v.author_identifier ~= identifier then
						if not v.sold then
							table.insert(blackmarketAds1, v)
						end
					else
						table.insert(myAds, v)
					end
				end

				for k,v in ipairs(Config.BlackmarketAllowedJobs) do
					if v.job == job.name then
						if v.grade[1] == nil then
							accessBlackmarket = true
							break
						else
							for k2,v2 in ipairs(v.grade) do
								if v2 == job.grade_name then
									accessBlackmarket = true
									break
								end
							end
							break
						end
					end
				end
				isMarketOpen = true
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'openVehicleMarket',
					vehicles = vehiclesTable,
					vehAds = vehAds1,
					items = itemsTable,
					itemsAds = itemsAds1,
					blackmarket = blackmarketTable,
					blackmarketAds = blackmarketAds1,
					myAds = myAds,
					accessBlackmarket = accessBlackmarket,
				})	
			end)
		end)
	end
end)

RegisterNetEvent("okokMarketplace:updateVehicles")
AddEventHandler("okokMarketplace:updateVehicles", function()
	Citizen.Wait(100)
	Framework.Functions.TriggerCallback("okokMarketplace:getAds", function(vehAds, itemsAds, blackmarketAds, identifier)
		local vehAds1 = {}

		for k,v in ipairs(vehAds) do
			if v.author_identifier ~= identifier and not v.sold then
				table.insert(vehAds1, v)
			end
		end

		SendNUIMessage({
			action = 'updateVehicles',
			vehAds = vehAds1,
		})	
	end)
end)

RegisterNetEvent("okokMarketplace:updateItems")
AddEventHandler("okokMarketplace:updateItems", function()
	Citizen.Wait(100)
	Framework.Functions.TriggerCallback("okokMarketplace:getAds", function(vehAds, itemsAds, blackmarketAds, identifier)
		local itemsAds1 = {}

		for k,v in ipairs(itemsAds) do
			if v.author_identifier ~= identifier and not v.sold then
				table.insert(itemsAds1, v)
			end
		end

		SendNUIMessage({
			action = 'updateItems',
			itemsAds = itemsAds1,
		})	
	end)
end)

RegisterNetEvent("okokMarketplace:updateBlackmarket")
AddEventHandler("okokMarketplace:updateBlackmarket", function()
	Citizen.Wait(100)
	Framework.Functions.TriggerCallback("okokMarketplace:getAds", function(vehAds, itemsAds, blackmarketAds, identifier)
		local blackmarketAds1 = {}

		for k,v in ipairs(blackmarketAds) do
			if v.author_identifier ~= identifier and not v.sold then
				table.insert(blackmarketAds1, v)
			end
		end

		SendNUIMessage({
			action = 'updateBlackmarket',
			blackmarketAds = blackmarketAds1,
		})	
	end)
end)

RegisterNetEvent("okokMarketplace:updateMyAds")
AddEventHandler("okokMarketplace:updateMyAds", function()
	Citizen.Wait(100)
	Framework.Functions.TriggerCallback("okokMarketplace:getAds", function(vehAds, itemsAds, blackmarketAds, identifier)
		local myAds = {}

		for k,v in ipairs(vehAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		for k,v in ipairs(itemsAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		for k,v in ipairs(blackmarketAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		SendNUIMessage({
			action = 'updateMyAds',
			myAds = myAds,
		})	
	end)
end)

RegisterNetEvent("okokMarketplace:updateMyAdsTable")
AddEventHandler("okokMarketplace:updateMyAdsTable", function()
	Citizen.Wait(100)
	Framework.Functions.TriggerCallback("okokMarketplace:getAds", function(vehAds, itemsAds, blackmarketAds, identifier)
		local myAds = {}

		for k,v in ipairs(vehAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		for k,v in ipairs(itemsAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		for k,v in ipairs(blackmarketAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		SendNUIMessage({
			action = 'updateMyAdsTable',
			myAds = myAds,
		})	
	end)
end)

RegisterNetEvent("okokMarketplace:updateVehiclesDropdown")
AddEventHandler("okokMarketplace:updateVehiclesDropdown", function()
	Citizen.Wait(100)
	local vehiclesTable = {}
	Framework.Functions.TriggerCallback("okokMarketplace:getItems", function(vehicles, items, loadout)
		for k,v in ipairs(vehicles) do
			local canAdd = true
			for k2,v2 in ipairs(Config.BlacklistVehicles) do
				if GetDisplayNameFromVehicleModel(v.vehicle.model) == v2 then
					canAdd = false
					break
				end
			end

			if canAdd then
				table.insert(vehiclesTable, {vehicle = v.vehicle, plate = v.plate, name = GetDisplayNameFromVehicleModel(v.vehicle.model)})
			end
		end
		SendNUIMessage({
			action = 'updateVehiclesDropdown',
			vehicles = vehiclesTable,
		})
	end)
end)

RegisterNetEvent("okokMarketplace:updateItemsDropdown")
AddEventHandler("okokMarketplace:updateItemsDropdown", function()
	Citizen.Wait(100)
	local itemsTable = {}
	Framework.Functions.TriggerCallback("okokMarketplace:getItems", function(vehicles, items, loadout)
		for k,v in ipairs(items) do
			local canAdd = true
			if v.amount > 0 then
				for k2,v2 in ipairs(Config.BlacklistItems) do
					if v.name == v2 then
						canAdd = false
						break
					end
				end

				if canAdd then
					table.insert(itemsTable, {id = v.name, label = v.label, count = v.amount})
				end
			end
		end

		SendNUIMessage({
			action = 'updateItemsDropdown',
			items = itemsTable,
		})
	end)
end)

RegisterNetEvent("okokMarketplace:updateBlackmarketDropdown")
AddEventHandler("okokMarketplace:updateBlackmarketDropdown", function()
	Citizen.Wait(100)
	local blackmarketTable = {}
	Framework.Functions.TriggerCallback("okokMarketplace:getItems", function(vehicles, items, loadout)
		for k,v in ipairs(items) do
			local canAdd = true
			local blackmarketItem = false
			if v.amount > 0 then
				for k2,v2 in ipairs(Config.BlacklistItems) do
					if v.name == v2 then
						canAdd = false
						break
					end
				end

				if not canAdd then
					for k2,v2 in ipairs(Config.Blackmarket) do
						if v.name == v2[1] and not v2[2] then
							blackmarketItem = true
							break
						end
					end

					if blackmarketItem then
						table.insert(blackmarketTable, {id = v.name, label = v.label, count = v.amount, type = "item"})
					end
				end
			end
		end

		for k,v in ipairs(loadout) do
			for k2,v2 in ipairs(Config.Blackmarket) do
				if v.name == v2[1] and v2[2] then
					table.insert(blackmarketTable, {id = v.name, label = v.label, count = 1, type = "weapon"})
				end
			end
		end
		SendNUIMessage({
			action = 'updateBlackmarketDropdown',
			blackmarket = blackmarketTable,
		})
	end)
end)

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		isMarketOpen = false
		SetNuiFocus(false, false)
	elseif data.action == "placeAd" then
		if data.window == "vehicles" then
			Framework.Functions.TriggerCallback("okokMarketplace:phone", function(phone)
				if data.desc == "" then
					local desc = "Nothing to add"
					TriggerServerEvent('okokMarketplace:addVehicle', data.item, data.price, desc, phone)
				else
					TriggerServerEvent('okokMarketplace:addVehicle', data.item, data.price, data.desc, phone)
				end
			end)
		elseif data.window == "items" then
			Framework.Functions.TriggerCallback("okokMarketplace:phone", function(phone)
				if data.desc == "" then
					local desc = "Nothing to add"
					TriggerServerEvent('okokMarketplace:addItem', data.item, tonumber(data.amount), data.price, desc, phone)
				else
					TriggerServerEvent('okokMarketplace:addItem', data.item, tonumber(data.amount), data.price, data.desc, phone)
				end
			end)
		elseif data.window == "blackmarket" then
			Framework.Functions.TriggerCallback("okokMarketplace:phone", function(phone)
				if data.desc == "" then
					local desc = "Nothing to add"
					TriggerServerEvent('okokMarketplace:addBlackmarket', data.item, data.price, desc, phone, tonumber(data.amount))
				else
					TriggerServerEvent('okokMarketplace:addBlackmarket', data.item, data.price, data.desc, phone, tonumber(data.amount))
				end
			end)
		end
	elseif data.action == "missing" then
		exports['okokNotify']:Alert("THÔNG BÁO", "Vui lòng điền đầy đủ thông tin", 5000, 'error')
	elseif data.action == "missingSearch" then
		exports['okokNotify']:Alert("THÔNG BÁO", "Vui lòng nhập nội dung tìm kiếm", 5000, 'error')
	elseif data.action == "high" then
		exports['okokNotify']:Alert("THÔNG BÁO", "Bạn không đủ vật phẩm để bán", 5000, 'error')
	elseif data.action == "buyVehicle" then
		Framework.Functions.TriggerCallback("okokMarketplace:getVehicle", function(veh)
			TriggerServerEvent('okokMarketplace:buyVehicle', veh)
		end, data.id)
	elseif data.action == "buyItem" then
		Framework.Functions.TriggerCallback("okokMarketplace:getItem", function(item)
			TriggerServerEvent('okokMarketplace:buyItem', item)
		end, data.id, data.item)
	elseif data.action == "buyBlackmarket" then
		Framework.Functions.TriggerCallback("okokMarketplace:getBlackmarket", function(blackmarket)
			TriggerServerEvent('okokMarketplace:buyBlackmarket', blackmarket)
		end, data.id, data.blackmarket)
	elseif data.action == "myAd" then
		TriggerServerEvent('okokMarketplace:removeMyAd', data.item)
	elseif data.action == "refresh" then
		if data.window == "vehicles" then
			TriggerEvent('okokMarketplace:updateVehicles')
		elseif data.window == "items" then
			TriggerEvent('okokMarketplace:updateItems')
		elseif data.window == "blackmarket" then
			TriggerEvent('okokMarketplace:updateBlackmarket')
		end
	end
end)

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end