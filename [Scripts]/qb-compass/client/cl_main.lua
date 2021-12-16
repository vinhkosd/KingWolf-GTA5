
playerShowLocation = false

Citizen.CreateThread(function()
    while true do
        Wait(500)
		local player = PlayerPedId()
		local veh = GetVehiclePedIsIn(player, false)
		SetPedSuffersCriticalHits(PlayerPedId(),false)
		local x, y, z = table.unpack(GetEntityCoords(player, true))
		local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
		currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
		intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
		zone = tostring(GetNameOfZone(x, y, z))
		local area = GetLabelText(zone)
		if not zone then
			zone = "UNKNOWN"
		end
		if intersectStreetName ~= nil and intersectStreetName ~= "" and currentStreetName ~= nil and currentStreetName ~= "" then
			playerStreetsLocation = currentStreetName .. " | [" .. intersectStreetName .. "]"
		elseif currentStreetName ~= nil and currentStreetName ~= "" then
			playerStreetsLocation = currentStreetName
		end
		street = playerStreetsLocation
        SendNUIMessage({ShowLocation = playerShowLocation, street = area, street2 = street})
        SendNUIMessage({showCarUi = false})
		-- if IsPedInAnyVehicle(PlayerPedId(), true) and not IsPauseMenuActive() and IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then 
		-- 	local Mph = math.ceil(GetEntitySpeed(veh) * 2.236936)
		-- 	local vehhash = GetEntityModel(veh)
		-- 	local maxspeed = GetVehicleModelMaxSpeed(vehhash) * 3.6
		-- 	SendNUIMessage({showCarUi = true})
		-- 	SendNUIMessage({street = area, street2 = street, engine = engine})
		-- else
		-- 	SendNUIMessage({ShowLocation = playerShowLocation, street = area, street2 = street})
		-- 	SendNUIMessage({showCarUi = false})
		-- end     
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(3)
--         local player = PlayerPedId()

--         if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) or playerShowLocation or sleeping then
--             SendNUIMessage({
--                 direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
--             })
--         else
--             Citizen.Wait(1500)
--         end
--     end
-- end)

-- Map stuff below
local x = -0.025
local y = -0.015
local w = 0.16
local h = 0.25


RegisterNetEvent('doj:client:OpenCompass')
AddEventHandler('doj:client:OpenCompass', function()
    playerShowLocation = true
end)

RegisterNetEvent('doj:client:CloseCompass')
AddEventHandler('doj:client:CloseCompass', function()
    playerShowLocation = false
end)

RegisterCommand("togglehud", function()  
	SendNUIMessage({action = "toggle_hud"})
end, false)


local imageWidth = 100 -- leave this variable, related to pixel size of the directions
local containerWidth = 100 -- width of the image container
local width =  0;
local south = (-imageWidth) + width
local west = (-imageWidth * 2) + width
local north = (-imageWidth * 3) + width
local east = (-imageWidth * 4) + width
local south2 = (-imageWidth * 5) + width

function calcHeading(direction)
    if (direction < 90) then
        return lerp(north, east, direction / 90)
    elseif (direction < 180) then
        return lerp(east, south2, rangePercent(90, 180, direction))
    elseif (direction < 270) then
        return lerp(south, west, rangePercent(180, 270, direction))
    elseif (direction <= 360) then
        return lerp(west, north, rangePercent(270, 360, direction))
    end
end

function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end

function lerp(min, max, amt)
    return (1 - amt) * min + amt * max
end

function IsCar(veh)
  local vc = GetVehicleClass(veh)
  return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

function Fwv(entity)
  local hr = GetEntityHeading(entity) + 90.0
  if hr < 0.0 then hr = 360.0 + hr end
  hr = hr * 0.0174533
  return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

function round( n )
    return math.floor( n + 0.5 )
end

function lerp(min, max, amt)
	return (1 - amt) * min + amt * max
end

function rangePercent(min, max, amt)
	return (((amt - min) * 100) / (max - min)) / 100
end

