local isAttached = false
local objectId = 1
local ObjectList = {}
local currentObj = nil
local attachBox = nil
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

local function f(n)
	return (n + 0.00001)
end

local BMenu = Menu.new("Barricade System","OBJECTS", 0.16,0.13,0.90,0.36,0,{255,255,255,255})
BMenu.config.pcontrol = true

BMenu.buttons = {}
BMenu:setTitle("Barricade system")

--Controls
BMenu.config.controls = Config.menu.controls
	
--Max buttons
BMenu:setMaxButtons(Config.menu.maxbuttons)

--Width, height of menu
BMenu.config.size.width = f(Config.menu.width) or 0.24;
BMenu.config.size.height = f(Config.menu.height) or 0.36;

--Position
if type(Config.menu.position) == 'table' then
	BMenu.config.position = { x = Config.menu.position.x, y = Config.menu.position.y}
elseif type(Config.menu.position) == 'string' then
	if Config.menu.position == "left" then
		BMenu.config.position = { x = 0.34, y = 0.13}
	elseif  Config.menu.position == "right" then
		BMenu.config.position = { x = 1-0.16, y = 0.13}
	end
end

--Theme
if type(Config.menu.theme) == "table" then
	BMenu:setColors(Config.menu.theme.text_color,Config.menu.theme.stext_color,Config.menu.theme.bg_color,Config.menu.theme.sbg_color)
elseif	type(Config.menu.theme) == "string" then
	if Config.menu.theme == "light" then
		--text_color,stext_color,bg_color,sbg_color
		BMenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 155},{ r = 255,g = 255, b = 255, a = 255})
	elseif Config.menu.theme == "darkred" then
		BMenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 155},{ r = 200,g = 15, b = 15, a = 200})
	elseif Config.menu.theme == "bluish" then	
		BMenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 100},{ r = 0,g = 100, b = 255, a = 200})
	elseif Config.menu.theme == "greenish" then	
		BMenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 100},{ r = 0,g = 200, b = 0, a = 200})
	end
end

BMenu:addSubMenu("OBJECTS", "objectmenu",nil, false)
BMenu.objectmenu.buttons = {}
BMenu.objectmenu:addButton("Delete Object", "deleteobject")
for i = 1, #Config.Objects do
	local obj = Config.Objects[i]
	BMenu.objectmenu:addButton(obj[1], obj)
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if isAttached then
		DisableControlAction(0, Keys["SPACE"], true)
		DisableControlAction(0, Keys["Q"], true)
		LoadDict('anim@heists@box_carry@')

		if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 3 ) then
			TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		end
	  end
	end
end)

local function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(5)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local rotationSpeed = 1.5
		if true then
			if IsControlJustReleased(0, Keys["G"]) and not isAttached then		
				BMenu:Open("objectmenu")
			end

			if IsDisabledControlPressed(0, Keys["SPACE"]) and isAttached then
				FreezeEntityPosition(GetPlayerPed(-1), true)
				Citizen.Wait(100)
				DetachObj()
				Citizen.Wait(250)
				FreezeEntityPosition(GetPlayerPed(-1), false)
				DisableControlAction(0, Keys["SPACE"], false)
				if attachBox ~= nil then
					ClearPedTasks(GetPlayerPed(-1))
					DeleteEntity(attachBox)
					attachBox = nil
				end
			end

			for i = 1, #ObjectList do
				if(ObjectList[i].object ~= nil) and (currentObj == nil or i == currentObj) then
					local coordsObject = GetEntityCoords(ObjectList[i].object)
					local dist = #(plyCoords - vector3(coordsObject.x, coordsObject.y, coordsObject.z))
            		if dist <= 15.0 then
						if ObjectList[i].freezing then
							currentObj = i
							local dragger = GetPlayerPed(-1)
							DrawText3Ds(coordsObject.x, coordsObject.y, coordsObject.z, "~r~[Q]~w~ Xoay trái / ~r~[E]~w~ Xoay phải")
							local hit, coords, entity = RayCastGamePlayCamera(50.0)
							local distFromCamera = GetDistanceBetweenCoords(plyCoords, coords)
							
							if distFromCamera > 2.5 and distFromCamera < 15.0 then
								local color = {r = 255, g = 255, b = 255, a = 200}
								if coords.x ~= 0.0 and coords.y ~= 0.0 then
									-- Draws line to targeted position
									DrawLine(plyCoords.x, plyCoords.y, plyCoords.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
									-- DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
								end
								SetEntityCoords(ObjectList[i].object, coords.x, coords.y, coords.z + 0.15)
							else
								ChangeEntityHeading(ObjectList[i].object)
							end

							if IsDisabledControlPressed(0, Keys["Q"]) or IsControlPressed(0, Keys["Q"]) then--rotate left
								if(ObjectList[i].object ~= nil and ObjectList[i].freezing) then
									curEntity = ObjectList[i].object
									curHeading = GetEntityHeading(curEntity)
									curHeading = curHeading + rotationSpeed
									SetEntityHeading(curEntity, curHeading)
								end
							end
				
							if IsDisabledControlPressed(0, Keys["E"]) or IsControlPressed(0, Keys["E"]) then--rotate left
								if(ObjectList[i].object ~= nil and ObjectList[i].freezing) then
									curEntity = ObjectList[i].object
									curHeading = GetEntityHeading(curEntity)
									curHeading = curHeading - rotationSpeed
									SetEntityHeading(curEntity, curHeading)
								end
							end

							DrawText3Ds(coordsObject.x, coordsObject.y, coordsObject.z + 1.0, "~r~[SPACE]~w~ Hoàn tất")
						elseif dist <= 3.0 then
							currentObj = i

							DrawText3Ds(coordsObject.x, coordsObject.y, coordsObject.z, "~r~[DEL]~w~ Xóa vật thể")
							
							if IsControlJustPressed(0, Keys["DELETE"]) then
								NetworkRequestControlOfEntity(ObjectList[currentObj].object)
								DeleteObject(ObjectList[currentObj].object)
								ObjectList[i].object = nil
								currentObj = nil
								Citizen.Wait(500)
							end
						end
					else
						currentObj = nil
					end
				end
			end
		end
	end
end)

function BMenu:onButtonSelected(name, button)
	print(json.encode(button.args))
	if(type(button.args) == "table") then
		CreateObjectAndAttachToPlayer(button.args[2])
	else
		DeleteObjectNearBy()
	end
	BMenu:Close()
end

function CreateObjectAndAttachToPlayer(objectname)
	local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
	if not isAttached then
		local x, y, z = table.unpack(plyCoords)

		attachBox = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z + 0.2,  true,  true, true)

		AttachEntityToEntity(attachBox, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)

		LoadDict('anim@heists@box_carry@')

		if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 3 ) then

			TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )

		end

		isAttached = true
		local heading = GetEntityHeading(GetPlayerPed(-1))
		local forward = GetEntityForwardVector(PlayerPedId())
		local x, y, z = table.unpack(plyCoords + forward * 0.5)
		local spawnedObj = CreateObject(objectname, x, y, z, false, false, false)
		PlaceObjectOnGroundProperly(spawnedObj)
		SetEntityHeading(spawnedObj, heading)

		ObjectList[objectId] = {
			id = objectId,
			object = spawnedObj,
			freezing = true,
		}
		currentObj = objectId

		Citizen.Wait(5)
		local dragger = GetPlayerPed(-1)
		local heading = GetEntityHeading(dragger)
		SetEntityCoords(spawnedObj, GetOffsetFromEntityInWorldCoords(dragger, 0.0, 1.5, -1.0))
		-- AttachEntityToEntity(spawnedObj, dragger, 11816, 0.0, 2.5, -1.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		objectId = objectId + 1
	end
end

function DetachObj()
	DisableControlAction(0, Keys["Q"], false)
	isAttached = false
	currentObj = nil
	for i = 1, #ObjectList do
		if ObjectList[i].freezing then
			ObjectList[i].freezing = false
			local coordsObject = GetEntityCoords(ObjectList[i].object)
			-- SetEntityCoords(ObjectList[i].object, coordsObject.x, coordsObject.y, coordsObject.z - 0.15)
			--tháo vật thể ra khỏi người chơi
			DetachEntity(PlayerPedId(), true, false)
			DetachEntity(ObjectList[i].object, true, false)
			PlaceObjectOnGroundProperly(ObjectList[objectId - 1].object)
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(50)
			FreezeEntityPosition(ObjectList[i].object, true)
		end
	end
end

function DeleteObjectNearBy()
	PlayerPos = GetEntityCoords(PlayerPedId())
	currentObj = nil
	for i = 1, #Config.Objects do
		local current = Config.Objects[i]
		object = GetClosestObjectOfType(PlayerPos, 1.0, GetHashKey(current[2]), false, false, false)
		if object ~= 0 then
			for i = 1, #ObjectList do
				if object == ObjectList[i].object then
					NetworkRequestControlOfEntity(ObjectList[i].object)
					DeleteObject(ObjectList[i].object)
					ObjectList[i].object = nil
				end
			end
		end
	end
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 350
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

local canChangeHeading = true

function ChangeEntityHeading(object)
	Citizen.CreateThread(function()
		if canChangeHeading then
			local dragger = GetPlayerPed(-1)
			local playerHeading = GetGameplayCamRelativeHeading()
			SetEntityHeading(object, playerHeading)
			canChangeHeading = false
			Citizen.Wait(500)
			canChangeHeading = true
		end
	end)
end

RegisterNetEvent('kingwolf-barricade:openMenu')
AddEventHandler('kingwolf-barricade:openMenu', function()
	BMenu:Open("objectmenu")
end)