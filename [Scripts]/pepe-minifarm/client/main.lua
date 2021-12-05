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

local isPickingUp = false


local canPick = nil 

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
	sleep = 5
	while true do
		Citizen.Wait(sleep)
		sleep = 5
		for i = 1, #Config.FarmBiNgo do		
			local grapedis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.FarmBiNgo[i], true)
			if grapedis < 1.5 then 
				Draw3DText(Config.FarmBiNgo[i].x, Config.FarmBiNgo[i].y, Config.FarmBiNgo[i].z, '[E] - Hái bí', 4, 0.08, 0.08, Config.SecondaryColor)
				if IsControlJustReleased(0, 38) and not canPick then
					canPick = true
					HaiBi()
				elseif IsControlJustReleased(0, 38) and canPick then
					Framework.Functions.Notify('Thao tác quá nhanh!!')
				end
			elseif grapedis < 10 then
				DrawMarker(2, Config.FarmBiNgo[i].x, Config.FarmBiNgo[i].y, Config.FarmBiNgo[i].z , 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.15, 209, 41, 242, 200, 0, 0, 0, 0)
			else
				sleep = 1500
			end
		end
	end
end)

Citizen.CreateThread(function()
	sleep = 5
	while true do
		-- Citizen.Wait(5)
		Citizen.Wait(sleep)
		sleep = 5
		for i = 1, #Config.FarmCaChua do		
			local grapedis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.FarmCaChua[i], true)
			if grapedis < 1.5 then 
				Draw3DText(Config.FarmCaChua[i].x, Config.FarmCaChua[i].y, Config.FarmCaChua[i].z, '[E] - Hái cà chua', 4, 0.08, 0.08, Config.SecondaryColor)
				if IsControlJustReleased(0, 38) and not canPick then
					canPick = true
					HaiCaChua()
				elseif IsControlJustReleased(0, 38) and canPick then
					Framework.Functions.Notify('Thao tác quá nhanh!!')
				end
			elseif grapedis < 10 then
				DrawMarker(2, Config.FarmCaChua[i].x, Config.FarmCaChua[i].y, Config.FarmCaChua[i].z , 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.15, 209, 41, 242, 200, 0, 0, 0, 0)
			else
				sleep = 1500
			end
		end
		

	end
end)

Citizen.CreateThread(function()
	sleep = 5
	while true do
		Citizen.Wait(sleep)
		sleep = 5
		for i = 1, #Config.FarmBapCai do		
			local grapedis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.FarmBapCai[i], true)
			if grapedis < 1.5 then 
				Draw3DText(Config.FarmBapCai[i].x, Config.FarmBapCai[i].y, Config.FarmBapCai[i].z, '[E] - Hái bắp cải', 4, 0.08, 0.08, Config.SecondaryColor)
				if IsControlJustReleased(0, 38) and not canPick then
					canPick = true
					HaiBapCai()
				elseif IsControlJustReleased(0, 38) and canPick then
					Framework.Functions.Notify('Thao tác quá nhanh!!')
				end
			elseif grapedis < 10 then
				DrawMarker(2, Config.FarmBapCai[i].x, Config.FarmBapCai[i].y, Config.FarmBapCai[i].z , 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.15, 209, 41, 242, 200, 0, 0, 0, 0)
			else
				sleep = 1500
			end
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

function HaiBi()
	local ad = "timetable@tracy@ig_8@idle_b"
	local anim = "idle_d"
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
		Framework.Functions.Progressbar("grape_progress", "Đang hái bí..", 15000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-minifarm:HaiBi')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(5000)
			canPick = false
		end, function()
			Citizen.Wait(5000)
			canPick = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		canPick = false
	end
end

function HaiCaChua()
	local ad = "random@peyote@rabbit"
	local anim = "wakeup"
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
		Framework.Functions.Progressbar("grape_progress", "Đang hái cà chua..", 15000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-minifarm:HaiCaChua')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(5000)
			canPick = false
		end, function()
			Citizen.Wait(5000)
			canPick = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		canPick = false
	end
end

function HaiBapCai()
	local ad = "special_ped@mountain_dancer@monologue_3@monologue_3a"
	local anim = "mnt_dnc_buttwag"
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
		Framework.Functions.Progressbar("grape_progress", "Đang hái bắp cải..", 15000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerServerEvent('pepe-minifarm:HaiBapCai')
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(5000)
			canPick = false
		end, function()
			Citizen.Wait(5000)
			canPick = false
			ClearPedTasks(PlayerPedId())
		end)
	else
		canPick = false
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
