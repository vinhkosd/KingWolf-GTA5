gameStarted = false

--Name: gameZone | 2021-10-07T20:48:05Z
gameZone = PolyZone:Create({
    vector2(1117.0521240234, 7139.6284179688),
    vector2(1177.8442382812, 7139.2993164062),
    vector2(1177.8076171875, 7261.033203125),
    vector2(1116.6044921875, 7261.1059570312)
  }, {
name="gameZone",
-- debugGrid = true,
--minZ = 20.404836654663,
--maxZ = 20.412622451782
})
  
--Name: finishZone | 2021-10-07T20:49:10Z
finishZone =  PolyZone:Create({
vector2(1116.2489013672, 7250.2392578125),
vector2(1178.558, 7250.453),
vector2(1177.8227539062, 7261.056640625),
vector2(1116.033203125, 7261.1098632812)
  }, {
name="finishZone",
-- debugGrid = true,
--minZ = 23.45532989502,
--maxZ = 23.45532989502
})

local insideGameZone = false
gameZone:onPlayerInOut(function(isPointInside, point)
    insideGameZone = isPointInside
    if gameStarted and not insideGameZone then
        TriggerEvent("squidgame:gameOver")
    end
end)

local insideFinishZone
finishZone:onPlayerInOut(function(isPointInside, point)
    insideFinishZone = isPointInside
    LocalPlayer.state:set("squidgame:inFinishZone", insideFinishZone, true)

    if insideFinishZone then
        if gameStarted then
            TriggerServerEvent("squidgame:playerInFinishZone")
        end
    end
end)


local createdObjects = {}
RegisterNetEvent("squidgame:createObjects", function(objects)
    for k,data in pairs(objects) do
        -- Create gun
        local gunHash = GetHashKey(data.model)
        RequestModel(gunHash)
        while not HasModelLoaded(gunHash) do
            Citizen.Wait(0)
        end
        local createdObject = CreateObjectNoOffset(gunHash, data.coords.x, data.coords.y, data.coords.z, false, true)

        if data.rotation then
            SetEntityRotation(createdObject, data.rotation.x, data.rotation.y, data.rotation.z)
        end

        if data.heading then
            SetEntityHeading(createdObject, data.heading)
        end

        createdObjects[data.id] = createdObject
    end
end)

RegisterNetEvent("squidgame:SetEntityRotation", function(data)
    local createdObject = createdObjects[data.id]
    if createdObject and DoesEntityExist(createdObject) then
        SetEntityRotation(createdObject, data.rotation.x, data.rotation.y, data.rotation.z)
    end
end)

RegisterNetEvent("squidgame:SetEntityHeading", function(data)
    local createdObject = createdObjects[data.id]
    if createdObject and DoesEntityExist(createdObject) then
        SetEntityHeading(createdObject, data.heading)
    end
end)


RegisterNetEvent("squidgame:notification", function(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end)



local dollyIsWatching = false
RegisterNetEvent("squidgame:dollyIsWatching", function()
    SendNUIMessage({
        stopSong = true,
    })
    Citizen.Wait(700)
    dollyIsWatching = true
end)
RegisterNetEvent("squidgame:dollyIsNotWatching", function()
    dollyIsWatching = false
    SendNUIMessage({
        playSong = true,
    })
end)

local IK_Head = 12844
-- https://github.com/Apex0909/multi_zones-by-Apex/blob/main/files/multi_zones/cl_m-gz.lua
function restrictPlayerOnTick()
    local playerPed = PlayerPedId()

    if not Config.EnableHitting then
        DisableControlAction(2, 37, true) -- Disable Weaponwheel
        DisablePlayerFiring(playerPed,true) -- Disable firing
        DisableControlAction(0, 45, true) -- Disable reloading
        DisableControlAction(0, 24, true) -- Disable attacking
        DisableControlAction(0, 263, true) -- Disable melee attack 1
        DisableControlAction(0, 140, true) -- Disable light melee attack (r)
        DisableControlAction(0, 142, true) -- Disable left mouse button (pistol whack etc)
    end

    if Config.EnableGodmode then
        SetEntityInvincible(playerPed, true)
        SetPlayerInvincible(PlayerId(), true)
    end

    if dollyIsWatching and not insideFinishZone then
        local speed = GetEntitySpeed(playerPed)
        if IsControlJustPressed(0, 36)
        or speed > 0.5
        or nil -- just for fun
        then
            TriggerEvent("squidgame:gameOver")
        end
    end

end

RegisterNetEvent("squidgame:gameStarted", function()
    gameStarted = true
    startTimer(Config.GameDuration / 1000)
    while gameStarted do
        Citizen.Wait(0)
        restrictPlayerOnTick()  
    end

    -- Disable godmode
    if Config.EnableGodmode then
        local playerPed = PlayerPedId()
        SetEntityInvincible(playerPed, false)
        SetPlayerInvincible(PlayerId(), false)
    end
end)

RegisterNetEvent("squidgame:gameOver", function()
    if not gameStarted then
        return
    end

    local playerPed = PlayerPedId()

    stopTimer()
    gameStarted = false
    dollyIsWatching = false

    Framework.showNotification(_U("game_finished"))
    SendNUIMessage({
        stopSong = true,
    })

    if insideFinishZone then
        TriggerServerEvent("squidgame:playerSuccess")
    else
        SetPedToRagdoll(playerPed, 6000, 6000, 0, 0, 0, 0) 
        for k,v in ipairs(Config.GunCoords) do
            local boneCoords = GetPedBoneCoords(playerPed, IK_Head, 0.0, 0.0, 0.0)
            ShootSingleBulletBetweenCoords(
                v.x, v.y, v.z, 
                boneCoords.x, boneCoords.y, boneCoords.z, 1000, false, GetHashKey("WEAPON_SNIPERRIFLE"), playerPed, true, false, 9000
            )
            Citizen.Wait(math.random(1, 5) * 50)
        end
        TriggerServerEvent("squidgame:playerFailed")
    end
end)

RegisterNetEvent("squidgame:killPed", function(netId)
    local ped = NetworkGetEntityFromNetworkId(netId)
    for k,v in ipairs(Config.GunCoords) do
        local boneCoords = GetPedBoneCoords(ped, IK_Head, 0.0, 0.0, 0.0)
        ShootSingleBulletBetweenCoords(
            v.x, v.y, v.z, 
            boneCoords.x, boneCoords.y, boneCoords.z, 1000, false, GetHashKey("WEAPON_SNIPERRIFLE"), nil, true, false, 9000, nil
        )
        Citizen.Wait(math.random(1, 5) * 50)
    end
    SetEntityHealth(ped, 0)
end)

TriggerServerEvent("squidgame:clientStarted")