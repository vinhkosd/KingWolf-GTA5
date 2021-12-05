local speed = 0.0
local seatbeltOn = false
local cruiseOn = false

local bleedingPercentage = 0
local hunger = 100
local thirst = 100
local level = 100

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
	if hour <= 9 then
		hour = "0" .. hour
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

local toggleHud = true

RegisterNetEvent('pepe-hud:toggleHud')
AddEventHandler('pepe-hud:toggleHud', function(toggleHud)
    QBHud.Show = toggleHud
end)

-- RegisterNetEvent("Framework:Client:OnPlayerLoaded")
-- AddEventHandler("Framework:Client:OnPlayerLoaded", function()
--     Citizen.SetTimeout(1750, function()
--         Framework.Functions.GetPlayerData(function(PlayerData)
--             if PlayerData ~= nil and PlayerData.money ~= nil then
--                 CashAmount = PlayerData.money["cash"]
--                 hunger, thirst, stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
--             end
--         end)
--         ShowHud = true
--         isLoggedIn = true
--     end)
-- end)

RegisterNetEvent("pepe-hud:client:update:needs")
AddEventHandler("pepe-hud:client:update:needs", function(NewHunger, NewThirst)
    hunger, thirst = newHunger, newThirst
end)

RegisterNetEvent('pepe-hud:client:update:stress')
AddEventHandler('pepe-hud:client:update:stress', function(NewStress)
    stress = newStress
end)

Citizen.CreateThread(function()
    Citizen.Wait(500)
    while true do 
        if Framework ~= nil and isLoggedIn and QBHud.Show then
            Framework.Functions.GetPlayerData(function(PlayerData)
                if PlayerData ~= nil and PlayerData.money ~= nil then
                    CashAmount = PlayerData.money["cash"]
                    hunger, thirst, stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
                end
            end)
            speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
            local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
            local pos = GetEntityCoords(PlayerPedId())
            local time = CalculateTimeToDisplay()
            local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
            local fuel = exports['pepe-fuel']:GetFuelLevel(Plate)
            local engine = GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId()))
            -- local breath = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
            local breath = GetPlayerUnderwaterTimeRemaining(PlayerId())
            if exports['pepe-diving'] ~= nil then
                -- breath = exports['pepe-diving']:GetDivingTime() ~= nil and exports['pepe-diving']:GetDivingTime() or 0
            end
            -- local breath = SetPedMaxTimeUnderwater(PlayerPedId(), 100.00) * 5
            if hunger < 0 then hunger = 0 end
            if thirst < 0 then thirst = 0 end
            if stress < 0 then stress = 0 end
            if breath < 0 then breath = 0 end
            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                health = GetEntityHealth(PlayerPedId()),
                armor = GetPedArmour(PlayerPedId()),
                thirst = thirst,
                hunger = hunger,
                stress = stress,
                oxy = breath,
                seatbelt = seatbeltOn,
                talking = NetworkIsPlayerTalking(PlayerId()),
                -- radio = exports:["rp-radio"]:IsRadioEnabled(),
                --bleeding = bleedingPercentage,
                -- direction = GetDirectionText(GetEntityHeading(PlayerPedId())),
                street1 = GetStreetNameFromHashKey(street1),
                street2 = GetStreetNameFromHashKey(street2),
                area_zone = current_zone,
                speed = math.ceil(speed),
                fuel = fuel,
                on = on,
                nivel = nivel,
                activo = activo,
                time = time,
                togglehud = toggleHud
            })
            Citizen.Wait(500)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Framework ~= nil and isLoggedIn and QBHud.Show then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
                if speed >= QBStress.MinimumSpeed then
                    TriggerServerEvent('pepe-hud:server:gain:stress', math.random(1, 2))
                end
            end
        end
        Citizen.Wait(20000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Framework ~= nil and isLoggedIn and QBHud.Show then
            TriggerServerEvent('pepe-hud:server:need:food', math.random(4, 7), math.random(4, 7))
        end
        Citizen.Wait(600000)
    end
end)

local radarActive = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) and isLoggedIn and QBHud.Show then
            DisplayRadar(true)
            SendNUIMessage({
                action = "car",
                show = true,
            })
            radarActive = true
        else
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })
            seatbeltOn = false
            cruiseOn = false

            SendNUIMessage({
                action = "seatbelt",
                seatbelt = seatbeltOn,
            })

            SendNUIMessage({
                action = "cruise",
                cruise = cruiseOn,
            })
            radarActive = false
        end
    end
end)

RegisterNetEvent("hud:client:UpdateNeeds")
AddEventHandler("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = toggle,
        })
    end
end)

RegisterNetEvent('pepe-hud:client:ToggleHarness')
AddEventHandler('pepe-hud:client:ToggleHarness', function(toggle)
    SendNUIMessage({
        action = "harness",
        toggle = toggle
    })
end)

RegisterNetEvent('pepe-hud:client:UpdateNitrous')
AddEventHandler('pepe-hud:client:UpdateNitrous', function(toggle, level, IsActive)
   --[[ SendNUIMessage({
        action = "nitrous",
        toggle = toggle,
        level = level,
        active = IsActive
    })]]
        on = toggle
        nivel = level
        activo = IsActive
end)

local LastHeading = nil
local Rotating = "left"

-- RegisterCommand("neon", function()
--     local veh = GetVehiclePedIsIn(PlayerPedId())
--     if veh ~= nil and veh ~= 0 and veh ~= 1 then
-- 		--left
--         if IsVehicleNeonLightEnabled(veh) then
--             SetVehicleNeonLightEnabled(veh, 0, false)
--             SetVehicleNeonLightEnabled(veh, 1, false)
--             SetVehicleNeonLightEnabled(veh, 2, false)
--             SetVehicleNeonLightEnabled(veh, 3, false)
--         else
--             SetVehicleNeonLightEnabled(veh, 0, true)
--             SetVehicleNeonLightEnabled(veh, 1, true)
--             SetVehicleNeonLightEnabled(veh, 2, true)
--             SetVehicleNeonLightEnabled(veh, 3, true)
--         end
--     end
-- end, false)