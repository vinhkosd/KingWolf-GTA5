local DoingSomething = false
local currentVest = nil
local currentVestTexture = nil
Framework = nil

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
	 Citizen.Wait(250)
 end)
end)

-- Code

RegisterNetEvent('pepe-items:client:drink')
AddEventHandler('pepe-items:client:drink', function(ItemName, PropName)
	TriggerEvent('pepe-inventory:client:set:busy', true)
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    	 	Citizen.SetTimeout(1000, function()
    			exports['pepe-assets']:AddProp(PropName)
    			exports['pepe-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		Framework.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
    	 			disableMovement = false,
    	 			disableCarMovement = false,
    	 			disableMouse = false,
    	 			disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
    				 exports['pepe-assets']:RemoveProp()
    				 TriggerEvent('pepe-inventory:client:set:busy', false)
    				 TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
    				 StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
    			 end, function()
					DoingSomething = false
    				exports['pepe-assets']:RemoveProp()
    				TriggerEvent('pepe-inventory:client:set:busy', false)
    	 			Framework.Functions.Notify("Geannuleerd..", "error")
    				StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
end)

RegisterNetEvent('pepe-items:client:drink:slushy')
AddEventHandler('pepe-items:client:drink:slushy', function()
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    		Citizen.SetTimeout(1000, function()
    			exports['pepe-assets']:AddProp('Cup')
    			exports['pepe-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    			TriggerEvent('pepe-inventory:client:set:busy', true)
    			Framework.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
    				disableMovement = false,
    				disableCarMovement = false,
    				disableMouse = false,
    				disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					DoingSomething = false
    				 exports['pepe-assets']:RemoveProp()
    				 TriggerEvent('pepe-inventory:client:set:busy', false)
    				 TriggerServerEvent('pepe-hud:server:remove:stress', math.random(12, 20))
    				 TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['slushy'], "remove")
    				 StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
    			 end, function()
					DoingSomething = false
    				exports['pepe-assets']:RemoveProp()
    				TriggerEvent('pepe-inventory:client:set:busy', false)
    				Framework.Functions.Notify("Geannuleerd..", "error")
    				StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    			end)
    		end)
		end
	end
end)

RegisterNetEvent('pepe-items:client:eat')
AddEventHandler('pepe-items:client:eat', function(ItemName, PropName)
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
 			Citizen.SetTimeout(1000, function()
				exports['pepe-assets']:AddProp(PropName)
				TriggerEvent('pepe-inventory:client:set:busy', true)
				exports['pepe-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				Framework.Functions.Progressbar("eat", "Eten..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
					 exports['pepe-assets']:RemoveProp()
					 TriggerEvent('pepe-inventory:client:set:busy', false)
					 TriggerServerEvent('pepe-hud:server:remove:stress', math.random(6, 10))
					 StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
					 TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
					 if ItemName == 'burger-heartstopper' then
						TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
					 else
						TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
					 end
				 	end, function()
					DoingSomething = false
					exports['pepe-assets']:RemoveProp()
					TriggerEvent('pepe-inventory:client:set:busy', false)
 					Framework.Functions.Notify("Geannuleerd..", "error")
					StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('pepe-items:client:use:armor')
AddEventHandler('pepe-items:client:use:armor', function()
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
 		local CurrentArmor = GetPedArmour(GetPlayerPed(-1))
 		if CurrentArmor <= 100 and CurrentArmor + 50 <= 100 then
			local NewArmor = CurrentArmor + 50
			if CurrentArmor + 33 >= 100 or CurrentArmor >= 100 then NewArmor = 100 end
			 TriggerEvent('pepe-inventory:client:set:busy', true)
 		    Framework.Functions.Progressbar("vest", "Vest aantrekken..", 10000, false, true, {
 		    	disableMovement = false,
 		    	disableCarMovement = false,
 		    	disableMouse = false,
 		    	disableCombat = true,
 		    }, {}, {}, {}, function() -- Done
				SetPedArmour(GetPlayerPed(-1), NewArmor)
				TriggerEvent('pepe-inventory:client:set:busy', false)
				TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['armor'], "remove")
				TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
				Framework.Functions.Notify("Gelukt", "success")
 		    end, function()
				TriggerEvent('pepe-inventory:client:set:busy', false)
 		    	Framework.Functions.Notify("Geannuleerd..", "error")
 		    end)
 		else
			Framework.Functions.Notify("Je hebt al een vest om..", "error")
 		end
	end
end)

RegisterNetEvent("pepe-items:client:use:heavy")
AddEventHandler("pepe-items:client:use:heavy", function()
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
    	local Sex = "Man"
    	if Framework.Functions.GetPlayerData().charinfo.gender == 1 then
    	  Sex = "Vrouw"
    	end
		TriggerEvent('pepe-inventory:client:set:busy', true)
    	Framework.Functions.Progressbar("use_heavyarmor", "Vest aantrekken..", 5000, false, true, {
    	disableMovement = false,
    	disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerEvent('pepe-inventory:client:set:busy', false)
			TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['heavy-armor'], "remove")
    	    if Sex == 'Man' then
    	    currentVest = GetPedDrawableVariation(GetPlayerPed(-1), 9)
    	    currentVestTexture = GetPedTextureVariation(GetPlayerPed(-1), 9)
    	    if GetPedDrawableVariation(GetPlayerPed(-1), 9) == 7 then
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 19, GetPedTextureVariation(GetPlayerPed(-1), 9), 2)
    	    else
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 5, 0, 2)
    	    end
    	    SetPedArmour(GetPlayerPed(-1), 100)
    	  else
    	    currentVest = GetPedDrawableVariation(GetPlayerPed(-1), 9)
    	    currentVestTexture = GetPedTextureVariation(GetPlayerPed(-1), 9)
    	    if GetPedDrawableVariation(GetPlayerPed(-1), 9) == 7 then
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 20, GetPedTextureVariation(GetPlayerPed(-1), 9), 2)
    	    else
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 5, 0, 2)
    	    end
			SetPedArmour(GetPlayerPed(-1), 100)
			TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
    	  end
		end, function() -- Cancel
    	    TriggerEvent('pepe-inventory:client:set:busy', false)
    	    Framework.Functions.Notify("Geannuleerd..", "error")
    	end)
	end
end)

RegisterNetEvent("pepe-items:client:reset:armor")
AddEventHandler("pepe-items:client:reset:armor", function()
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
    	local ped = GetPlayerPed(-1)
    	if currentVest ~= nil and currentVestTexture ~= nil then 
    	    Framework.Functions.Progressbar("remove-armor", "Vest uittrekken..", 2500, false, false, {
    	        disableMovement = false,
    	        disableCarMovement = false,
    	        disableMouse = false,
    	        disableCombat = true,
    	    }, {}, {}, {}, function() -- Done
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, currentVest, currentVestTexture, 2)
    	        SetPedArmour(GetPlayerPed(-1), 0)
				TriggerServerEvent('pepe-items:server:giveitem', 'heavy-armor', 1)
				TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
				currentVest, currentVestTexture = nil, nil
    	    end)
    	else
    	    Framework.Functions.Notify("Je hebt geen vest aan..", "error")
    	end
	end
end)

RegisterNetEvent('pepe-items:client:use:repairkit')
AddEventHandler('pepe-items:client:use:repairkit', function()
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
		local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
		if GetVehicleEngineHealth(Vehicle) < 1000.0 then
			NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
			if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
				NewHealth = 1000.0 
			end
			if Distance < 4.0 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
				if IsBackEngine(GetEntityModel(Vehicle)) then
				  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
				end
			if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
				local VehicleDoor = nil
				if IsBackEngine(GetEntityModel(Vehicle)) then
					VehicleDoor = 5
				else
					VehicleDoor = 4
				end
				SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
				Citizen.Wait(450)
				TriggerEvent('pepe-inventory:client:set:busy', true)
				Framework.Functions.Progressbar("repair_vehicle", "Bezig met sleutelen..", math.random(10000, 20000), false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_player",
					flags = 16,
				}, {}, {}, function() -- Done
					TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['repairkit'], "remove")

					TriggerEvent('pepe-inventory:client:set:busy', false)
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
					StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
					Framework.Functions.Notify("Voertuig gemaakt!")
					SetVehicleEngineHealth(Vehicle, NewHealth) 
					for i = 1, 6 do
					 SetVehicleTyreFixed(Vehicle, i)
					end
				end, function() -- Cancel
					TriggerEvent('pepe-inventory:client:set:busy', false)
					StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
					Framework.Functions.Notify("Mislukt!", "error")
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				end)
			end
		 else
			Framework.Functions.Notify("Geen voertuig?!?", "error")
		end
		end	
	end
end)

RegisterNetEvent('pepe-items:client:dobbel')
AddEventHandler('pepe-items:client:dobbel', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('pepe-items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		local coords = GetEntityCoords(GetPlayerPed(-1))
		TriggerServerEvent('pepe-sound:server:play:distance', 2.0, 'dice', 0.5, coords)
		TriggerServerEvent('pepe-assets:server:display:chatme', RollText, coords)
	end)
end)

RegisterNetEvent('pepe-items:client:coinflip')
AddEventHandler('pepe-items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Coinflip: ~g~Kop'
     else
		CoinFlip = 'Coinflip: ~y~Munt'
	 end
	 TriggerEvent('pepe-items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		local coords = GetEntityCoords(GetPlayerPed(-1))
		TriggerServerEvent('pepe-sound:server:play:distance', 2.0, 'coin', 0.5, coords)
		TriggerServerEvent('pepe-assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('pepe-items:client:dice:anim')
AddEventHandler('pepe-items:client:dice:anim', function()
	exports['pepe-assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('pepe-items:client:use:duffel-bag')
AddEventHandler('pepe-items:client:use:duffel-bag', function(BagId)
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", 'tas_'..BagId, {maxweight = 25000, slots = 3})
    TriggerEvent("pepe-inventory:client:SetCurrentStash", 'tas_'..BagId)
end)

local ParachuteEquiped = false

RegisterNetEvent("pepe-items:client:UseParachute")
AddEventHandler("pepe-items:client:UseParachute", function()
    EquipParachuteAnim()
    Framework.Functions.Progressbar("use_parachute", "Đang dùng dù..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = PlayerPedId()
        TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["parachute"], "remove")
        GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 7, texture = 0},  -- Nek / Das
            }
        }
        TriggerEvent('pepe-clothing:client:loadOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    end)
end)

RegisterNetEvent("pepe-items:client:ResetParachute")
AddEventHandler("pepe-items:client:ResetParachute", function()
    if ParachuteEquiped then 
        EquipParachuteAnim()
        Framework.Functions.Progressbar("reset_parachute", "Đang thu dù..", 40000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ped = PlayerPedId()
            -- TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["parachute"], "add")
            local ParachuteRemoveData = { 
                outfitData = { 
                    ["bag"] = { item = 0, texture = 0} -- Nek / Das
                }
            }
            TriggerEvent('pepe-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            -- TriggerServerEvent("pepe-items:server:AddParachute")
            ParachuteEquiped = false
        end)
    else
        Framework.Functions.Notify("Bạn không có một chiếc dù!", "error")
    end
end)

RegisterNetEvent('pepe-items:client:use:jerrycan')
AddEventHandler('pepe-items:client:use:jerrycan', function()
	local PlayerCoords = GetEntityCoords(PlayerPedId())
	local Vehicle, Distance = Framework.Functions.GetClosestVehicle()

	if not IsPedInAnyVehicle(PlayerPedId()) then
		if Distance < 3.0 and not IsPedInAnyVehicle(PlayerPedId()) then
			local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
			if IsBackEngine(GetEntityModel(Vehicle)) then
			  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
			end
		if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
			TriggerEvent('pepe-inventory:client:set:busy', true)
			Citizen.Wait(450)
			Framework.Functions.Progressbar("repair_vehicle", "Đang đổ nhiên liệu...", math.random(10000, 20000), false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = "mini@repair",
				anim = "fixing_a_player",
				flags = 16,
			}, {}, {}, function() -- Done
				if math.random(1,50) < 10 then
				  TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['jerrycan'], "remove")
				end
				-- TriggerServerEvent('Framework:Server:RemoveItem', 'jerrycan', 1)
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				Framework.Functions.Notify("Xe đã đổ xăng")
				exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 65, false)
				TriggerEvent('pepe-inventory:client:set:busy', false)
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				Framework.Functions.Notify("Thất bại!", "error")
				TriggerEvent('pepe-inventory:client:set:busy', false)
			end)
		end
	 	else
		Framework.Functions.Notify("Không có xe gần đó", "error")
		end
	else
		Framework.Functions.Notify("Bạn đang ở trong một chiếc xe. Bước ra khỏi xe", "error")	
	end	
end)

RegisterNetEvent('pepe-items:client:use:cigarette')
AddEventHandler('pepe-items:client:use:cigarette', function()
    TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["ciggy"], "remove")
  	Citizen.SetTimeout(1000, function()
    Framework.Functions.Progressbar("smoke-cigarette", "Đang hút thuốc..", 4500, false, true, {
     disableMovement = false,
     disableCarMovement = false,
     disableMouse = false,
     disableCombat = true,
     }, {}, {}, {}, function() -- Done
        -- TriggerEvent('pepe-items:client:smoke:effect')
		TriggerServerEvent('pepe-hud:Server:RelieveStress', math.random(2, 6))
        if IsPedInAnyVehicle(PlayerPedId(), false) then
			TriggerEvent('animations:client:EmoteCommandStart', {"smoke"})
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"smoke2"})
		end
    end)
  end)
end)

--  // Functions \\ --

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function EquipParachuteAnim()
    loadAnimDict("clothingshirt")        
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function IsBackEngine(Vehicle)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == Vehicle then
            return true
        end
    end
    return false
end

function CreateRollText(rollTable, sides)
    local s = "~g~Xúc xắc~s~: "
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Tổng: ~g~"..total.."~s~)"
    return s
end