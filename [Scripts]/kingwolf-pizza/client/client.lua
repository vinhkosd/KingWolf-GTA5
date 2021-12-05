Framework = nil
local isCooking = false
local onDuty = false
local isInRagdoll = false
local isDrugs = false
local DoingSomething = false
local isNearShop = false
local IDShopNearBy = 0
local PlayerJob = {}

Citizen.CreateThread(function()

    while Framework == nil do

        TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

        Citizen.Wait(200)

    end

end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Framework.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "pizza" then
                TriggerServerEvent("Framework:ToggleDuty", false)
            end
        end
    end)
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

local cooks = 0

Citizen.CreateThread(function()
	local addBlip = AddBlipForCoord(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"])

	SetBlipSprite (addBlip, 93)

	SetBlipDisplay(addBlip, 4)

	SetBlipScale  (addBlip, 0.7)

	SetBlipColour (addBlip, 27)

	SetBlipAsShortRange(addBlip, true)

	BeginTextCommandSetBlipName("STRING")

	AddTextComponentString('Pizza!')

	EndTextCommandSetBlipName(addBlip)
end)


RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('Framework:Client:SetDuty')
AddEventHandler('Framework:Client:SetDuty', function(duty)
    onDuty = duty
end)



Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)

		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		if isLoggedIn and PlayerJob.name == "pizza" then
			local DutyDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"])

			if DutyDist < 3 then
				inRange = true
				if DutyDist < 1.0 then
					DrawMarker(2, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
					if not onDuty then
						Framework.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, "~g~[E]~w~ Vào ca")
						if IsControlJustReleased(0, Keys["E"]) then
							TriggerServerEvent("Framework:ToggleDuty", true)
						end
					else
						Framework.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, "~g~[E]~w~ Ra ca")
						if IsControlJustReleased(0, Keys['E']) then
							TriggerServerEvent("Framework:ToggleDuty", false)
						end
					end
				end
			end

			local StashDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"])

			if StashDist < 3 and (PlayerJob.isboss or tonumber(PlayerJob.grade.level) >= 1) and onDuty then
				inRange = true

				DrawMarker(2, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, true, false, false, false)

				if StashDist < 1.0 then
						Framework.Functions.DrawText3D(Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"] + 0.3, "~g~[E]~w~ Tủ đồ")
						if IsControlJustReleased(0, Keys["E"]) then
							Other = {maxweight = 3000000, slots = 100}
							TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "tu_piz_za", Other)
							TriggerEvent("pepe-inventory:client:SetCurrentStash", "tu_piz_za")
						end
				end
			end

			local SellStashDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["SellStash"]["x"], Config.Locations["SellStash"]["y"], Config.Locations["SellStash"]["z"])

			if SellStashDist < 3 and (tonumber(PlayerJob.grade.level) == 0 or PlayerJob.isboss) and onDuty then
				inRange = true

				DrawMarker(2, Config.Locations["SellStash"]["x"], Config.Locations["SellStash"]["y"], Config.Locations["SellStash"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, true, false, false, false)

				if SellStashDist < 1.0 then
						Framework.Functions.DrawText3D(Config.Locations["SellStash"]["x"], Config.Locations["SellStash"]["y"], Config.Locations["SellStash"]["z"] + 0.3, "~g~[E]~w~ Quầy bán")
						if IsControlJustReleased(0, Keys["E"]) then
							Other = {maxweight = 100000, slots = 25}
							TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "quay_ban_piz_za", Other)
							TriggerEvent("pepe-inventory:client:SetCurrentStash", "quay_ban_piz_za")
						end
				end
			end

			local BossDistance = GetDistanceBetweenCoords(plyCoords, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"])

			if BossDistance < 10 and PlayerJob.isboss and onDuty then
				inRange = true
				DrawMarker(2, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)

				if BossDistance < 1.0 then
					Framework.Functions.DrawText3D(Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"], "~g~[E]~w~ Quản lý")
					if IsControlJustReleased(0, Keys["E"]) then
						TriggerServerEvent("pepe-bossmenu:server:openMenu")
					end
				end
			end
			local CraftDistance = GetDistanceBetweenCoords(plyCoords, Config.Locations["Craft"]["x"], Config.Locations["Craft"]["y"], Config.Locations["Craft"]["z"])

			if CraftDistance < 3.0 and ((tonumber(PlayerJob.grade.level) == 1) or PlayerJob.isboss) and onDuty then
				Framework.Functions.DrawText3D(Config.Locations["Craft"]["x"], Config.Locations["Craft"]["y"], Config.Locations["Craft"]["z"] + 1.0, "~g~[F]~w~ - Pha chế")
				if IsControlJustReleased(0, 23) and CraftDistance < 1.0 then
					ItemsToItemInfo()
					local Crating = {}
					Crating.label = "Pha chế"
					Crating.items = Config.CraftingItems
					TriggerServerEvent('pepe-inventory:server:set:inventory:disabled', true)
					TriggerServerEvent("pepe-inventory:server:OpenInventory", "pizzacrafting", math.random(1, 99), Crating)
				end
			end
		end

		-- local StallsDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["Table"]["x"], Config.Locations["Table"]["y"], Config.Locations["Table"]["z"])

		-- if StallsDist < 10 then
			
			-- for i = 1, #Config.Locations["Table"] do
			-- 	local tableCoords = Config.Locations["Table"][i]
			-- 	local StallsDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["Table"][i]["x"], Config.Locations["Table"][i]["y"], Config.Locations["Table"][i]["z"])
				
			-- 	if StallsDist < 1.5 then
			-- 		inRange = true
			-- 		Framework.Functions.DrawText3D(tableCoords["x"], tableCoords["y"], tableCoords["z"] - 0.97, "~g~[E]~w~ Bàn "..i)
			-- 		if IsControlJustReleased(0, Keys["E"]) then
			-- 			Other = {maxweight = 10000, slots = 6}
			-- 			TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "piz_za_ban_"..i, Other)
			-- 			TriggerEvent("pepe-inventory:client:SetCurrentStash", "piz_za_ban_"..i)
			-- 		end
			-- 	elseif StallsDist < 10 then
			-- 		-- DrawMarker(2, tableCoords["x"], tableCoords["y"], tableCoords["z"]- 0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
			-- 	end
			-- end
			for i = 1, #Config.Locations["ShopAuto"] do		
				local ShopDistance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Locations["ShopAuto"][i], true)
				
				if ShopDistance < 3.0 and PlayerJob.name == "pizza" and PlayerJob ~= nil and ((tonumber(PlayerJob.grade.level) == 1) or PlayerJob.isboss) and onDuty then
					isNearShop = true
					IDShopNearBy = i
					Framework.Functions.DrawText3D(Config.Locations["ShopAuto"][i].x, Config.Locations["ShopAuto"][i].y, Config.Locations["ShopAuto"][i].z + 1.0, "~g~E~w~ - Tủ bán tự động")
				
					if IsControlJustReleased(0, 38) and ShopDistance < 1.0 then
						Other = {maxweight = 900000, slots = Config.Items.slots}
						TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "tu_tu_dong_piz_za_"..i, Other)
						TriggerEvent("pepe-inventory:client:SetCurrentStash", "tu_tu_dong_piz_za_"..i)
					end
				elseif ShopDistance < 1.5 then
					isNearShop = true
					IDShopNearBy = i
				else
					isNearShop = false
					IDShopNearBy = 0
				end
			end
		-- end
	end
end)

function ItemsToItemInfo()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		costsInfo = ""
		for index, value in pairs(item.costs) do
			costsInfo = costsInfo..Framework.Shared.Items[index]["label"] .. ": "..value.."x, "
			
		end
		
		local itemInfo = Framework.Shared.Items[item.name:lower()]
		if itemInfo ~= nil then
			itemInfos = {costs = item.toamount.."x "..itemInfo["label"].." = "..costsInfo}
			items[item.slot] = {
				name = itemInfo["name"],
				amount = tonumber(item.amount),
				toamount = tonumber(item.toamount),
				tostash = item.tostash,
				info = itemInfos,
				label = itemInfo["label"],
				description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
				weight = itemInfo["weight"], 
				type = itemInfo["type"], 
				unique = itemInfo["unique"], 
				useable = itemInfo["useable"], 
				image = itemInfo["image"],
				slot = item.slot,
				costs = item.costs,
				threshold = item.threshold,
				points = item.points,
			}
		else
			Framework.Functions.Notify("Không tìm thấy vật phẩm : "..item.name)
		end
	end
	Config.CraftingItems = items
end

function LoadDict(dict)

    RequestAnimDict(dict)

	while not HasAnimDictLoaded(dict) do

	  	Citizen.Wait(10)

    end

end

-- Event item tra da

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
	 Citizen.Wait(250)
 end)
end)

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 

Citizen.CreateThread(function()
 while true do
    Citizen.Wait(10)
    if isInRagdoll then
        -- SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
        if IsPedOnFoot(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.35)
            SetPedToRagdollWithFall(PlayerPedId(), 2500, 4000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
    end
  end
end)

local function LoadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Wait(10)
	end
end

RegisterNetEvent('kingwolf-pizza:open:autoshop')
AddEventHandler('kingwolf-pizza:open:autoshop', function(ItemName, PropName)
	Framework.Functions.TriggerCallback('pepe-inventory:server:GetStashItems', function(StashItems)
		for i = 1, #Config.Items.items do
			Config.Items.items[i].amount = 0
		end

        for k, v in pairs(StashItems) do
			for i = 1, #Config.Items.items do
				if Config.Items.items[i].name == v.name then
					Config.Items.items[i].amount = v.amount + Config.Items.items[i].amount
				end
			end
        end
		TriggerServerEvent("pepe-inventory:server:OpenInventory", "pizzashop", "tu_tu_dong_piz_za_"..IDShopNearBy, Config.Items)
    end, "tu_tu_dong_piz_za_"..IDShopNearBy)
    
end)

function IsNearTraDaShop()
	return isNearShop
end

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)

		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		if isLoggedIn and PlayerJob.name == "pizza" then
			if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local RentDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["TakeVehicle"]["x"], Config.Locations["TakeVehicle"]["y"], Config.Locations["TakeVehicle"]["z"])

				if RentDist < 20.0 then
					DrawMarker(1, Config.Locations["TakeVehicle"]["x"], Config.Locations["TakeVehicle"]["y"], Config.Locations["TakeVehicle"]["z"]-0.97, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 209, 41, 242, 100, false, true, 2, false, false, false, false)
				end
				if RentDist < 1.0 then
					Framework.Functions.DrawText3D(Config.Locations["TakeVehicle"]["x"], Config.Locations["TakeVehicle"]["y"], Config.Locations["TakeVehicle"]["z"] + 0.15, "~g~[E]~w~ Lấy xe giao hàng")
					if IsControlJustReleased(0, Keys["E"]) then
						TriggerServerEvent("kingwolf-pizza:server:CheckRental")
					end
				end
			end

			local UnRentDist = GetDistanceBetweenCoords(plyCoords, Config.Locations["TakeVehicle"]["x"], Config.Locations["TakeVehicle"]["y"], Config.Locations["TakeVehicle"]["z"])
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local vehModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)))

				-- DrawMarker(1, Config.Locations["TakeVehicle"]["x"], Config.Locations["TakeVehicle"]["y"], Config.Locations["TakeVehicle"]["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 209, 41, 242, 100, false, true, 2, false, false, false, false)
				if vehModel:lower() == Config.CarModel then
					if UnRentDist < 20.0 then
					DrawMarker(1, Config.Locations["TakeVehicle"]["x"], Config.Locations["TakeVehicle"]["y"], Config.Locations["TakeVehicle"]["z"]-0.97, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 209, 41, 242, 100, false, true, 2, false, false, false, false)
					end

					if UnRentDist < 1.0 then
						Framework.Functions.DrawText3D(Config.Locations["TakeVehicle"]["x"], Config.Locations["TakeVehicle"]["y"], Config.Locations["TakeVehicle"]["z"] + 0.15, "~g~[E]~w~ Trả xe giao hàng")
						if IsControlJustReleased(0, Keys["E"]) then
							Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
						end
					end
				end
				
			end
		end
	end
end)

RegisterNetEvent('kingwolf-pizza:client:spawn:vehicle')
AddEventHandler('kingwolf-pizza:client:spawn:vehicle', function()
	local isSpawnPointClear = false
	for i = 1, #Config.Locations['Spawns'] do
		if isSpawnPointClear then
			break
		end
		local spawnCoords = Config.Locations['Spawns'][i]
		local CoordTable = {x = spawnCoords['x'], y = spawnCoords['y'], z = spawnCoords['z'], a = spawnCoords['h']}    
		if Framework.Functions.IsSpawnPointClear(CoordTable, 3.0) then
			isSpawnPointClear = true
			Framework.Functions.TriggerCallback('kingwolf-pizza:server:registerPlate', function(plateText)
				if plateText == nil then
					Framework.Functions.Notify("Không thể đăng ký thông tin biển số xe..")
				else
					Framework.Functions.SpawnVehicle(Config.CarModel, function(Vehicle)
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