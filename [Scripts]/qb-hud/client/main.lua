
Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

local stress = 0
local hunger = 100
local thirst = 100
local PlayerJob = {}
local setHealOnOff = false
local setArmorOnOff = false 
local setFoodOnOff = false
local setWateronOff = false
local setOxyOnOff = false
local setStressOnOff = false
local toggleHud = true
local oxyOn = false

--local isLoggedIn = false
local isLoggedIn = false

-- Citizen.CreateThread(function()
--     Citizen.Wait(5000)
--     if not isLoggedIn then
--         isLoggedIn = true
--         Config.Show = true
--         PlayerJob = Framework.Functions.GetPlayerData().job
--     end
-- end)

RegisterNetEvent('pepe-hud:toggleHud')
AddEventHandler('pepe-hud:toggleHud', function(toggleHud)
    QBHud.Show = toggleHud
end)


RegisterNetEvent("Framework:Client:OnPlayerUnload")
AddEventHandler("Framework:Client:OnPlayerUnload", function()
    isLoggedIn = false
    Config.Show = false
    SendNUIMessage({
        action = "hudtick",
        show = true,
    })
end)

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    Config.Show = true
    PlayerJob = Framework.Functions.GetPlayerData().job
end)






RegisterNetEvent('hud:client:UpdateVoiceProximity')
AddEventHandler('hud:client:UpdateVoiceProximity', function(Proximity)
    SendNUIMessage({
        action = "UpdateProximity",
        prox = Proximity
    })
end)

RegisterNetEvent('pepe-hud:client:ProximityActive')
AddEventHandler('pepe-hud:client:ProximityActive', function(active)
    SendNUIMessage({
        action = "talking",
        IsTalking = active
    })
end)

RegisterNetEvent('hud:client:UpdateStress') -- Add this event with adding stress elsewhere
AddEventHandler('hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

RegisterNetEvent('pepe-hud:client:update:stress') -- Add this event with adding stress elsewhere
AddEventHandler('pepe-hud:client:update:stress', function(newStress)
    stress = newStress
end)


RegisterNetEvent('hud:client:UpdateNeeds') -- Triggered in pepe-core
AddEventHandler('hud:client:UpdateNeeds', function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent('pepe-hud:client:update:needs') -- Triggered in pepe-core
AddEventHandler('pepe-hud:client:update:needs', function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

local speed = 0.0
local mic = 100
 
Citizen.CreateThread(function()
    Citizen.Wait(500)

    while true do 
        if Framework ~= nil and isLoggedIn and Config.Show then

            Framework.Functions.GetPlayerData(function(PlayerData)
                if PlayerData ~= nil and PlayerData.money ~= nil then
                    CashAmount,bankAmount = PlayerData.money["cash"], PlayerData.money["bank"] 
                    hunger, thirst, stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
                end
            end)

                local id = PlayerId()
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                -- speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * 2.23694
                speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
                -- local fuel = exports['LegacyFuel']:GetFuel(GetVehiclePedIsIn(ped))
                local fuel = 0
                if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
                    fuel = exports['pepe-fuel']:GetFuelLevel(Plate)
                end
            	local health = GetEntityHealth(ped)
            	local armor  = GetPedArmour(ped)
                 
                local mic = NetworkIsPlayerTalking(id)
        
                if mic then
                    mic = 100   
                else 
                    mic = 0
                end

            	if IsEntityInWater(ped) then
                	oxy = GetPlayerUnderwaterTimeRemaining(id) * 10
            	else
                	oxy = GetPlayerSprintTimeRemaining(id) * 10
            	end
                
                if hunger < 0 then hunger = 0 end
                if thirst < 0 then thirst = 0 end
                if stress < 0 then stress = 0 end

                SendNUIMessage({
                    action = "hudtick",
                    show = IsPauseMenuActive(),
                    varHealth = health,
                    varArmor = armor,
                    varThirst = thirst,
                    varHunger = hunger,
                    varStress = stress,
                    varOxy = oxy,
                    varMic = mic,
                    seatbelt = seatbeltOn,
                    drunk = true,
                    DrunkMode = true,
                    DevMode = true,
                    BugMode = true, 
                    WeaponMode = true,
                    speed = math.ceil(speed),
                    fuel = fuel,
                    on = on,
                    nivel = nivel, 
                    activo = activo,
                    setHealOnOff = setHealOnOff,
					setArmorOnOff = setArmorOnOff,
					setOxyOnOff = setOxyOnOff,
					setStressOnOff = setStressOnOff,
					setFoodOnOff = setFoodOnOff,
					setWateronOff = setWateronOff,
                    togglehud = toggleHud

                })
                Citizen.Wait(500)
        else
            Citizen.Wait(1000)
        end
    end
end)

local isPause = false
local uiHidden = false

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsBigmapActive() or IsPauseMenuActive() and not isPause or IsRadarHidden() then
            if not uiHidden then
                SendNUIMessage({
                    action = "hideUI"
                })
                uiHidden = true
            end
        elseif uiHidden or IsPauseMenuActive() and isPause then
            SendNUIMessage({
                action = "displayUI"
            })
            uiHidden = false
        end
    end
end)

local radarActive = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        local vehicleIsOn = GetIsVehicleEngineRunning(vehicle)
        if IsPedInAnyVehicle(PlayerPedId()) and isLoggedIn then
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

RegisterCommand('toggleradar', function()
	if IsRadarHidden() then
        DisplayRadar(true)
    else
        DisplayRadar(false)
    end
end, false)

RegisterCommand('tatradar', function()
	DisplayRadar(false)
end, false)

RegisterCommand('batradar', function()
	DisplayRadar(true)
end, false)


RegisterNetEvent('pepe-hud:client:UpdateNitrous')
AddEventHandler('pepe-hud:client:UpdateNitrous', function(toggle, level, IsActive)
        on = toggle
        nivel = level
        activo = IsActive
end)

-- Stress

local StressGain = 0
local IsGaining = false

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()

        if IsPedShooting(PlayerPedId()) then
            local StressChance = 10
            local odd = math.random(1, 3)
            if StressChance == odd then
                local PlusStress = math.random(1, 3) / 100
                StressGain = StressGain + PlusStress
            end
            if not IsGaining then
                IsGaining = true
            end
        else
            if IsGaining then
                IsGaining = false
            end
        end

        if (PlayerJob.name ~= "police") then
            if IsPlayerFreeAiming(PlayerId()) and not IsPedShooting(PlayerPedId()) then
                local CurrentWeapon = GetSelectedPedWeapon(ped)
                if Framework.Shared.Weapons ~= nil and Framework.Shared.Weapons[CurrentWeapon] ~= nil then
                    local WeaponData = Framework.Shared.Weapons[CurrentWeapon]
                    if WeaponData.name:upper() ~= "WEAPON_UNARMED" then
                        local StressChance = math.random(1, 20)
                        local odd = math.random(1, 20)
                        if StressChance == odd then
                            local PlusStress = math.random(1, 3) / 100
                            StressGain = StressGain + PlusStress
                        end
                    end
                end

                if not IsGaining then
                    IsGaining = true
                end
            else
                if IsGaining then
                    IsGaining = false
                end
            end
        end

        Citizen.Wait(2)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not IsGaining then
            StressGain = math.ceil(StressGain)
            if StressGain > 0 then
                Framework.Functions.Notify('You are feeling stressed', "primary", 2000)
                TriggerServerEvent('pepe-hud:Server:UpdateStress', StressGain)
                StressGain = 0
            end
        end

        Citizen.Wait(3000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Framework ~= nil and isLoggedIn and Config.Show then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                -- speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936
                speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
                if speed >= Config.MinimumSpeed then
                    TriggerServerEvent('pepe-hud:server:gain:stress', math.random(1, 2))
                end
            end
        end
        Citizen.Wait(20000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Framework ~= nil and isLoggedIn and Config.Show then
            TriggerServerEvent('pepe-hud:server:need:food', math.random(4, 7), math.random(4, 7))
        end
        Citizen.Wait(600000)
    end
end)


Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local Wait = GetEffectInterval(stress)
        if stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 3000, 500)

            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                local player = PlayerPedId()
                SetPedToRagdollWithFall(player, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end

            Citizen.Wait(500)
            for i = 1, FallRepeat, 1 do
                Citizen.Wait(750)
                DoScreenFadeOut(200)
                Citizen.Wait(1000) 
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                SetFlash(0, 0, 200, 750, 200)
            end
        elseif stress >= Config.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 2500, 500)
        end
        Citizen.Wait(Wait)
    end
end)


function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(Config.Intensity['shake']) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

--Hud Menu
RegisterNetEvent('hudmenu:set')
AddEventHandler('hudmenu:set', function(data)
	setHealOnOff = data['Health']
	setArmorOnOff = data['Armor']
	setFoodOnOff = data['Food']
	setWateronOff = data['Water']
	setOxyOnOff = data['Oxygen'] 
	setStressOnOff = data['Stress']
	setFpsBoost = data["Fps"]
    setBarrasOnOff = data["Barras"] 
    setCompassOnOff = data["Compass"]


    local Var = false
    if setCompassOnOff then
        TriggerEvent("doj:client:OpenCompass")
        Var = true
    elseif not setCompassOnOff then
        TriggerEvent("doj:client:CloseCompass")
        Var = false
    end  

    local booston = false
    if setFpsBoost then
        SetTimecycleModifier("cinema")
        booston = true
    elseif not setFpsBoost then
        SetTimecycleModifier("default")
        booston = false
    end 
    if setBarrasOnOff then
        CinematicCamDisplay(true)
        CinematicCamBool = true
    elseif not setBarrasOnOff then
        CinematicCamDisplay(false)
        CinematicCamBool = false
    end
end)

--Blackbars
CinematicCamMaxHeight = 0.2 -- [[The height of the rects. Keep below 1 and keep as a float however I recommend you keep it as it is as this is the best height I could find]]

CinematicCamBool = false
w = 0

function CinematicCamDisplay(bool) -- [[Handles Displaying Radar, Body Armour and the rects themselves.]]
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    if bool then
        for i = CinematicCamMaxHeight, 0, -1.0 do
            Wait(10)
            w = i
        end 
    else
        for i = 0, CinematicCamMaxHeight, 1.0 do 
            Wait(10)
            w = i
        end
    end
end 

Citizen.CreateThread(function()

    minimap = RequestScaleformMovie("minimap")

    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do 
            Wait(1)
        end
    end

    while true do
        Citizen.Wait(1)
        if w > 0 then
            DrawRects()
        end
    end
end)

function DrawRects() -- [[Draw the Black Rects]]
    DrawRect(0.0, 0.0, 2.0, w, 0, 0, 0, 255)
    DrawRect(0.0, 1.0, 2.0, w, 0, 0, 0, 255)
end

