Framework = nil
local _wheel = nil
local carRewardEntity = nil
local _isShowCar = false
-- local _wheelPos = vector3(949.02, 63.05, 75.99)
-- local _baseWheelPos = vector3(948.5, 63.37, 75.01)

local _wheelPos = vector3(977.75, 50.1, 74.77)
local _baseWheelPos = vector3(978.011, 50.348, 73.6761 + 0.25)
local _baseWheelHeading = 327.9941
local isLoggedIn = false
TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

local casinoprops = {}

local Keys = {
    ["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}
local _isRolling = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
	isLoggedIn = true
    local model = GetHashKey('vw_prop_vw_luckywheel_02a')
    -- local baseWheelModel = GetHashKey('vw_prop_vw_luckywheel_01a')

    Citizen.CreateThread(function()
        -- RequestModel(baseWheelModel)
        -- while not HasModelLoaded(baseWheelModel) do
        --     Citizen.Wait(0)
        -- end

        -- _basewheel = CreateObject(baseWheelModel, _baseWheelPos.x, _baseWheelPos.y, _baseWheelPos.z, false, false, true)
        -- SetEntityHeading(_basewheel, _baseWheelHeading)
        -- SetModelAsNoLongerNeeded(baseWheelModel)

        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        _wheel = CreateObject(model, _baseWheelPos.x, _baseWheelPos.y, _baseWheelPos.z, false, false, true)
        SetEntityHeading(_wheel, _baseWheelHeading)
        SetModelAsNoLongerNeeded(model)

        spawnRewardVehicle()
        table.insert(casinoprops, _wheel)
        -- table.insert(casinoprops, _basewheel)
    end)
end)

Citizen.CreateThread(function()
    while true do
        if carRewardEntity ~= nil then
            local _heading = GetEntityHeading(carRewardEntity)
            local _z = _heading - 0.3
            SetEntityHeading(carRewardEntity, _z)
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent("kingwolf_luckywheel:doRoll")
AddEventHandler("kingwolf_luckywheel:doRoll", function(_priceIndex)
    _isRolling = true
    SetEntityHeading(_wheel, -30.9754)
    SetEntityRotation(_wheel, 0.0, 0.0, 0.0, 1, true)
    Citizen.CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        -- local _priceIndex = math.random(1, 20)
        local _winAngle = (_priceIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(_wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0
                    
                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
            -- if _rollAngle < 5.0 then
            --     if _y > _winAngle then
            --         _y = _winAngle
            --     end
            -- end
            SetEntityHeading(_wheel, -30.9754)
            SetEntityRotation(_wheel, 0.0, _y, -30.9754, 2, true)
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent("kingwolf_luckywheel:rollFinished")
AddEventHandler("kingwolf_luckywheel:rollFinished", function()
    _isRolling = false
end)


function doRoll()
    if not _isRolling then
        _isRolling = true
        local playerPed = PlayerPedId()
        local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
        if IsPedMale(playerPed) then
            _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
        end
        local lib, anim = _lib, 'enter_right_to_baseidle'
        exports['pepe-assets']:RequestAnimationDict(lib)
        -- local _movePos = vector3(948.39, 62.14, 75.99)
        local _movePos = vector3(975.72, 50.42, 74.88)
        TaskGoStraightToCoord(playerPed, _movePos.x, _movePos.y, _movePos.z, 1.0, -1, 34.52, 0.0)
        local _isMoved = false
        while not _isMoved do
            local coords = GetEntityCoords(PlayerPedId())
            if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                _isMoved = true
            end
            Citizen.Wait(0)
        end
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TriggerServerEvent("kingwolf_luckywheel:getLucky")
        TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
    end
end

-- Menu Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        if(GetDistanceBetweenCoords(coords, _wheelPos.x, _wheelPos.y, _wheelPos.z, true) < 1.5) and not _isRolling then
            helpText('~g~[E]~w~ để quay vòng quay')
            if IsControlJustReleased(0, Keys['E']) then
                doRoll()
            end
        end
    end
end)

function spawnRewardVehicle()
    print("spawnRewardVehicle")
    local carmodel = GetHashKey('nero2')
    RequestModel(carmodel)
    while not HasModelLoaded(carmodel) do
        Citizen.Wait(0)
    end
    local CoordTable = {x = 963.7, y = 47.76, z = 75.15, a = 123.25}
    -- local CoordTable = {x = 963.68, y = 48.47, z = 75.57, a = 330.47}
    -- local CoordTable = {x = 953.7, y = 70.08, z = 75.23, a = 182.73}  
    local isNetworked = false
    SpawnVehicle(carmodel, function(vehicle)
        Citizen.Wait(10)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleOnGroundProperly(vehicle)
        Citizen.Wait(10)
        FreezeEntityPosition(vehicle, true)
        SetEntityInvincible(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)
        carRewardEntity = vehicle
        table.insert(casinoprops, carRewardEntity)
    end, CoordTable, isNetworked)
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _,wheel in pairs(casinoprops) do
            DeleteEntity(_wheel)
            -- DeleteEntity(_basewheel)
            DeleteEntity(carRewardEntity)
        end
	end
end)

RegisterNetEvent("kingwolf_luckywheel:winCar")
AddEventHandler("kingwolf_luckywheel:winCar", function() 
    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true)
end)

SpawnVehicle = function(vehicle, cb, coords)
	local model = (type(vehicle) == 'number' and vehicle or GetHashKey(vehicle))
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	Citizen.CreateThread(function()
		RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(10)
        end

		local vehicle = CreateVehicle(model, vector.xyz, coords.a, false, false)

		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		SetVehRadioStation(vehicle, 'OFF')

		RequestCollisionAtCoord(vector.xyz)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			Citizen.Wait(0)
		end

		if cb then
			cb(vehicle)
		end
	end)
end