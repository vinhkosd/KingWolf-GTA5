Framework = nil
isLoggedIn = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local isPickingUp, isProcessing = false, false


local availableGrapePicking = nil 

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
		if not availableGrapePicking then 
			for i = 1, #Config.GrapeFarm do		
				local grapedis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.GrapeFarm[i], true)
				if grapedis < 1.5 then 
					Draw3DText(Config.GrapeFarm[i].x, Config.GrapeFarm[i].y, Config.GrapeFarm[i].z, '[E] - Hái nho', 4, 0.08, 0.08, Config.SecondaryColor)
					if IsControlJustReleased(0, 38) and not availableGrapePicking then
						-- if (Framework.Functions.GetPlayerData().metadata["currentrank"] == nil or Framework.Functions.GetPlayerData().metadata["currentrank"] < 3) then
						-- 	Framework.Functions.Notify("Bạn chưa đủ điều kiện để farm khu vực này (Yêu cầu: Level 3)", "error")
						-- else
							availableGrapePicking = true
							PickGrape()
						-- end
					elseif IsControlJustReleased(0, 38) and availableGrapePicking then
						Framework.Functions.Notify('Thao tác quá nhanh, vui lòng chờ nho chín!')
					end
				elseif grapedis < 10 then
					DrawMarker(2, Config.GrapeFarm[i].x, Config.GrapeFarm[i].y, Config.GrapeFarm[i].z , 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.15, 209, 41, 242, 200, 0, 0, 0, 0)
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

		if GetDistanceBetweenCoords(coords, Config.ProcessLocation, true) < 3 then
			local nowcoords = Config.ProcessLocation
			DrawMarker(1, nowcoords.x, nowcoords.y, nowcoords.z - 1 , 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 209, 41, 242, 200, 0, 0, 0, 0)

			if not isProcessing then
				Draw3DText(nowcoords.x, nowcoords.y,nowcoords.z, '[E] - Đóng gói nho', 4, 0.08, 0.08, Config.SecondaryColor)
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				ProcessGrapes()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessGrapes()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)

	Framework.Functions.Progressbar("grape_progress", "Đang đóng gói..", Config.Delays.GrapesProcessing, false, true, {--15000
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('pepe-grape:ProcessGrapes')
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end, function()
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end) -- Cancel
end

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

local prog = 0 

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

function PickGrape()
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
		Framework.Functions.Progressbar("grape_progress", "Đang hái nho..", 15000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-grape:GiveGrapes')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(5000)
			availableGrapePicking = false
		end, function()
			Citizen.Wait(5000)
			availableGrapePicking = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		availableGrapePicking = false
	end
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
