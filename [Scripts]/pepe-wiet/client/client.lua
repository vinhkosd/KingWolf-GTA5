Framework = nil

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 

local weedPlants = {}
local spawnedweeds = 0
local DoingSomething = false
local inWeedZone = true
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15)
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords, Config.WeedFieldsSpawnCoords, true) < 50 then
            inWeedZone = true
			SpawnWeeds()
			Citizen.Wait(500)
		else
            inWeedZone = false
            RemoveWeeds()
			Citizen.Wait(500)
		end
	end
end)

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

local LoggedIn = false

local CurrentCops = 0

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
  Citizen.SetTimeout(650, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)   
      Citizen.Wait(200)
      LoggedIn = true 
  end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('pepe-wiet:client:set:dry:busy')
AddEventHandler('pepe-wiet:client:set:dry:busy',function(DryRackId, bool)
    Config.WeedLocations['drogen'][DryRackId]['IsBezig'] = bool
end)

RegisterNetEvent('pepe-wiet:client:set:pack:busy')
AddEventHandler('pepe-wiet:client:set:pack:busy',function(PackerId, bool)
    Config.WeedLocations['verwerk'][PackerId]['IsBezig'] = bool
end)

--Vinh: 60*3s 1 lần server trigger setCopCount 1 lần
RegisterNetEvent('pepe-police:SetCopCount')
AddEventHandler('pepe-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Code


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         local SpelerCoords = GetEntityCoords(GetPlayerPed(-1))
            NearAnything = false

            for k, v in pairs(Config.WeedLocations["verwerk"]) do
                local PlantDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.WeedLocations["verwerk"][k]['x'], Config.WeedLocations["verwerk"][k]['y'], Config.WeedLocations["verwerk"][k]['z'], true)
                if PlantDistance < 1.2 then
                    NearAnything = true

                    DrawMarker(2, Config.WeedLocations["verwerk"][k]['x'], Config.WeedLocations["verwerk"][k]['y'], Config.WeedLocations["verwerk"][k]['z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 67, 156, 77, 255, false, false, false, 1, false, false, false)

                    if IsControlJustPressed(0, Config.Keys['E']) then
                        if CurrentCops < Config.PoliceNeededs then
                            Framework.Functions.Notify('Cần '..Config.PoliceNeededs..' cảnh sát để làm việc này', 'error')
                        else
                            if not Config.WeedLocations['verwerk'][k]['IsBezig'] then
                                Framework.Functions.TriggerCallback('pepe-wiet:server:has:nugget', function(HasNugget)
                                    if HasNugget then
                                        PoliceCallPackWeed()
                                        PackagePlant(k)
                                    else
                                        Framework.Functions.Notify("Bạn không có các vật phẩm cần thiết ..", "error")
                                    end
                                end)
                            else
                                Framework.Functions.Notify("Ai đó đang sử dụng máy đóng gói.", "error")
                            end
                        end
                    end
                end
            end

            if not NearAnything then
                Citizen.Wait(2500)
            end
        end
    end
end)

RegisterNetEvent('pepe-wiet:client:rod:anim')
AddEventHandler('pepe-wiet:client:rod:anim', function()
    exports['pepe-assets']:AddProp('Schaar')
    exports['pepe-assets']:RequestAnimationDict('amb@world_human_gardener_plant@male@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@idle_a", "idle_a", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('pepe-wiet:client:use:scissor')
AddEventHandler('pepe-wiet:client:use:scissor', function()
    Citizen.SetTimeout(1000, function()
        if not Config.UsingRod then
            local playerPed = PlayerPedId()
		    local coords = GetEntityCoords(playerPed)
            local nearbyObject, nearbyID = nil, nil
            for i=1, #weedPlants, 1 do
                if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) <= 1.5 then
                    nearbyObject, nearbyID = weedPlants[i], i
                end
            end

            if nearbyObject and IsPedOnFoot(playerPed) then

                if CurrentCops < Config.PoliceNeededs then
                    Framework.Functions.Notify('Cần '..Config.PoliceNeededs..' cảnh sát để làm việc này', 'error')
                    return
                end

                if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    if not IsEntityInWater(GetPlayerPed(-1)) then
                        Config.UsingRod = true
                        FreezeEntityPosition(GetPlayerPed(-1), true)
                        TriggerEvent('pepe-wiet:client:rod:anim')
                        if not exports['pepe-progressbar']:GetTaskBarStatus() then
                            if not DoingSomething then
                                PoliceCall()
                                DoingSomething = true
                                Framework.Functions.Progressbar("weed", "Đang hái cần sa..", 15000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                                    DoingSomething = false
                                    DeleteWeedObject(nearbyObject) 
                                    table.remove(weedPlants, nearbyID)
                                    spawnedweeds = spawnedweeds - 1
                                    -- Finish
                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                    exports['pepe-assets']:RemoveProp()
                                    Config.UsingRod = false
                                    TriggerServerEvent('pepe-wiet:server:weed:reward')
                                    StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@idle_a", "idle_a", 1.0)
                                end, function()
                                    Framework.Functions.Notify("Đã hủy bỏ..", "error")
                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                    DoingSomething = false
                                    exports['pepe-assets']:RemoveProp()
                                    Config.UsingRod = false
                                    Framework.Functions.Notify('Thất bại..', 'error')
                                    StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@idle_a", "idle_a", 1.0)
                                end)
                            end
                        end
                    else
                        Framework.Functions.Notify('Bạn đang bơi', 'error')
                    end
                else
                    Framework.Functions.Notify('Bạn đang ở trong một chiếc xe', 'error')
                end
            end
        end
    end)
end)

function DryPlant(DryRackId)
    TriggerServerEvent('pepe-wiet:server:remove:item', 'wet-tak', 2)
    TriggerServerEvent('pepe-wiet:server:set:dry:busy', DryRackId, true)
    Framework.Functions.Progressbar("pick_plant", "Sấy khô....", math.random(6000, 11000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('pepe-wiet:server:add:item', 'wet-bud', math.random(1,3))
        TriggerServerEvent('pepe-wiet:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Success!", "success")
    end, function() -- Cancel
        TriggerServerEvent('pepe-wiet:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Canceled.", "error")
    end) 
end

function PackagePlant(PackerId)
    TriggerServerEvent('pepe-wiet:server:set:pack:busy', PackerId, true)
    Framework.Functions.Progressbar("pick_plant", "Đang đóng gói...", math.random(3500, 6500), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('pepe-wiet:server:pack:item')
        TriggerServerEvent('pepe-wiet:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Thành công!", "success")
    end, function() -- Cancel
        TriggerServerEvent('pepe-wiet:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Hủy bỏ!.", "error")
    end) 
end

function SpawnWeeds()
    Citizen.CreateThread(function()
        while spawnedweeds < Config.MaxWeedsSpawn do
            Citizen.Wait(5)
            
            if not inWeedZone then
                break
            end
            local weedCoords = GenerateweedCoords()
                -- lá cocain: prop_fib_plant_02
                -- lá weed gốc: prop_weed_02
                -- la weed co chau : bkr_prop_weed_lrg_01a
            SpawnLocalWeedObject('prop_weed_02', weedCoords, function(obj)
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
    
                table.insert(weedPlants, obj)
                spawnedweeds = spawnedweeds + 1
            end)
        end
    end)
end

function SpawnLocalWeedObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		exports['pepe-assets']:RequestModelHash(model)

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

function ValidateweedCoord(plantCoord)
	if spawnedweeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.WeedFieldsSpawnCoords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateweedCoords()
	while true do
		Citizen.Wait(15)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-30, 30)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-30, 30)

		weedCoordX = Config.WeedFieldsSpawnCoords.x + modX
		weedCoordY = Config.WeedFieldsSpawnCoords.y + modY

		local coordZ = GetCoordZ(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateweedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 486.0, 487.0, 488.0, 489.0, 490.0, 491.0, 492.0, 493.0, 494.0, 495.0, 496.0, 497.0, 498.0, 499.0, 500.0, 501.0, 502.0, 503.0, 504.0, 180.0, 181.0, 182.0, 183.0, 184.0, 185.0, 186.0, 187.0, 188.0, 189.0, 190.0, 191.0, 192.0, 193.0, 194.0, 195.0, 196.0, 197.0, 198.0, 199.0, 200.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 490.0
end

function RemoveWeeds() 
    for k, v in pairs(weedPlants) do
        DeleteWeedObject(v)
        table.remove(weedPlants, k)
        spawnedweeds = spawnedweeds - 1
    end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			DeleteWeedObject(v)
            table.remove(weedPlants, k)
            spawnedweeds = spawnedweeds - 1
		end
	end
end)

function DeleteWeedObject(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

function PoliceCall()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local StreetLabel = Framework.Functions.GetStreetLabel()
    local chance = 75
    if GetClockHours() >= 1 and GetClockHours() <= 6 then
        chance = 25
    end
    TriggerServerEvent('pepe-police:server:send:alert:weed', GetEntityCoords(GetPlayerPed(-1)), StreetLabel)
    -- if math.random(1,100) < 40 then        
       
    --  end
end

function PoliceCallPackWeed()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local StreetLabel = Framework.Functions.GetStreetLabel()
    local chance = 75
    if GetClockHours() >= 1 and GetClockHours() <= 6 then
        chance = 25
    end
    TriggerServerEvent('pepe-police:server:send:alert:packweed', GetEntityCoords(GetPlayerPed(-1)), StreetLabel)
    -- if math.random(1,100) < 40 then        
       
    --  end
end