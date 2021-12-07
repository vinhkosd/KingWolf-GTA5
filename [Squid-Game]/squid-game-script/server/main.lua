-- Waiting time between Doll spin. Changing of this value will break things.
Config.DollySpinInterval = 2700 

local createdObjects = {
    ["dolly_head"] = {
        id = "dolly_head",
        model = "dolly_head",
        coords = vector3(Config.DollyCoords.x, Config.DollyCoords.y + 0.1, Config.DollyCoords.z + 2.2 + 1.3),
        heading = Config.DollyIsWatchingHeading,
    },
    ["dolly_body"] = {
        id = "dolly_body",
        model = "dolly_body",
        coords = vector3(Config.DollyCoords.x, Config.DollyCoords.y, Config.DollyCoords.z + 1.3),
        heading = Config.DollyIsWatchingHeading,
    },
}

local totalReward = 0
local gameStarted = false
local joinedPlayers = {}
RegisterCommand("squidgame-announce", function()
    if gameStarted then
        return error("Trò chơi được bắt đầu. Trước tiên, bạn cần phải hoàn thành trò chơi.", 1)
    end

    local players = GetPlayers()
    for k,v in ipairs(players) do
        Framework.showNotification(v, _U("game_starts"))
    end
end, true)

function refreshGameInfo()
    local playersCount = 0
    for k,v in pairs(joinedPlayers) do
        playersCount = playersCount + 1
    end

    for k,v in pairs(joinedPlayers) do
        TriggerClientEvent("squidgame:refreshGameInfo", k, {
            playersCount = playersCount,
            totalReward = totalReward,
        })
    end
end

RegisterCommand("squidgame-join", function(source, args, raw)
    if gameStarted then
        Framework.showNotification(source, _U("game_already_started"))
        return
    end

    if not Framework.takeMoney(source, Config.Fee) then
        Framework.showNotification(source, _U("not_enaugh_money"))
        return 
    end
    totalReward = totalReward + Config.Fee
    

    for playerId,v in pairs(joinedPlayers) do
        Framework.showNotification(playerId, _U("player_joined", source))
    end

    joinedPlayers[tostring(source)] = true
    Framework.showNotification(source, _U("you_joined_game"))

    refreshGameInfo()
end, false)

RegisterCommand("squidgame-left", function(source, args, raw)
    if gameStarted then
        return
    end

    if not joinedPlayers[tostring(source)] then
        return
    end

    joinedPlayers[tostring(source)] = nil
    Framework.giveMoney(source, Config.Fee)
    totalReward = totalReward - Config.Fee

    Framework.showNotification(source, _U("you_left_game"))
    refreshGameInfo()
end, false)

local createdPeds = {}
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k,v in ipairs(createdPeds) do
            if DoesEntityExist(v.ped) then
                DeleteEntity(v.ped)
            end
        end
        createdPeds = {}
    end
end)
function stopGame()
    -- Delete peds
    for k,v in ipairs(createdPeds) do
        if DoesEntityExist(v.ped) then
            DeleteEntity(v.ped)
        end
    end
    createdPeds = {}

    -- Give reward
    local playersInFinishZone = 0
    for k,v in pairs(joinedPlayers) do
        if Player(k).state["squidgame:inFinishZone"] then
            playersInFinishZone = playersInFinishZone + 1
        end
    end
    for k,v in pairs(joinedPlayers) do
        if Player(k).state["squidgame:inFinishZone"] then
            local reward = math.ceil(totalReward / playersInFinishZone)
            Framework.giveMoney(k, reward)
            Framework.showWinnerMessage(-1, k, reward)
        end
    end

    -- Stop game
    for k,v in pairs(joinedPlayers) do
        TriggerClientEvent("squidgame:gameOver", k)
    end

    -- We don't clean joinedPlayers because they cleaned by itself when player succeed or failed, see squidgame:gameOver -> fail | success
    -- joinedPlayers = {}

    totalReward = 0
    gameStarted = false
end

RegisterCommand("squidgame-stop", function()
    stopGame()
end, true)

function playerFailed(playerId)
    
    joinedPlayers[tostring(playerId)] = nil

    local playerPed = GetPlayerPed(playerId)
    local coords = Config.SpawnCoords.GameFailed[math.random(#Config.SpawnCoords.GameFailed)]
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)

    if next(joinedPlayers) == nil then
        stopGame()
    end
end

AddEventHandler("playerDropped", function(reason)
    local playerId = source
    playerFailed(playerId)
end)


function startGame()
    if gameStarted then
        return
    end
    
    if next(joinedPlayers) == nil then
        return
    end

    -- Spawn NPC Guards
    for k,v in ipairs(Config.SpawnCoords.GuardsNPC) do
        local ped
        if Config.UsePedModelsInsteadOutfitsForGuards then
            ped = CreatePed(nil, GetHashKey(Config.GuardPeds[1]), v.x, v.y, v.z, Config.DollyIsNotWatchingHeading, true, false)
        else
            ped = CreatePed(nil, GetHashKey("mp_m_freemode_01"), v.x, v.y, v.z, Config.DollyIsNotWatchingHeading, true, false)
        end

        while not DoesEntityExist(ped) do
            Citizen.Wait(0)
        end

        if not Config.UsePedModelsInsteadOutfitsForGuards then
            for k,v in pairs(Config.GuardOutfits[1]) do
                SetPedComponentVariation(
                    ped, 
                    k,
                    v[1],
                    v[2]
                )
            end
        end

        FreezeEntityPosition(ped, true)
        SetPedConfigFlag(ped, 17, true)
        table.insert(createdPeds, {
            ped = ped,
            type = "guard",
        })
    end

    -- Create Player NPC's
    if Config.EnablePlayerNPCs then
        for k,v in ipairs(Config.SpawnCoords.GameStarted) do
            local ped
            local isMale = math.random(0, 1) == 1

            if Config.UsePedModelsInsteadOutfitsForPlayers then
                if #Config.PlayerPeds > 0 then
                    ped = CreatePed(nil, GetHashKey(Config.PlayerPeds[math.random(#Config.PlayerPeds)]), v.x, v.y, v.z, Config.DollyIsWatchingHeading, true, false)
                else
                    break -- NPC's not created, because `Config.PlayerPeds` is empty 
                end
            else
                if isMale then
                    ped = CreatePed(nil, GetHashKey("mp_m_freemode_01"), v.x, v.y, v.z, Config.DollyIsWatchingHeading, true, false)
                else
                    ped = CreatePed(nil, GetHashKey("mp_f_freemode_01"), v.x, v.y, v.z, Config.DollyIsWatchingHeading, true, false)
                end
            end

            while not DoesEntityExist(ped) do
                Citizen.Wait(0)
            end

            -- Set clothes
            if not Config.UsePedModelsInsteadOutfitsForPlayers then
                if isMale and #Config.PlayerOutfits["male"] > 0 then
                    for k,v in pairs(Config.PlayerOutfits["male"][math.random(#Config.PlayerOutfits["male"])]) do
                        if k == 12 then
                            SetPedPropIndex(ped, 0,  v[1], v[2], true)
                        else
                            SetPedComponentVariation(
                                ped, 
                                k,
                                v[1],
                                v[2]
                            )
                        end
                        
                    end
                elseif not isMale and #Config.PlayerOutfits["female"] > 0 then
                    for k,v in pairs(Config.PlayerOutfits["female"][math.random(#Config.PlayerOutfits["female"])]) do
                        if k == 12 then
                            SetPedPropIndex(ped, 0,  v[1], v[2], true)
                        else
                            SetPedComponentVariation(
                                ped, 
                                k,
                                v[1],
                                v[2]
                            )
                        end
                    end
                end
            end


            SetPedConfigFlag(ped, 17, true)
            table.insert(createdPeds, {
                ped = ped,
                type = "player",
            })
        end
    end
    
    -- Set player models, clothes and teleport them into game area
    gameStarted = true
    for playerId,v in pairs(joinedPlayers) do
        local playerPed = GetPlayerPed(playerId)

        if Config.ChangePlayerSkin then 
            if Config.UsePedModelsInsteadOutfitsForPlayers then
                -- Set usual ped model
                if #Config.PlayerPeds > 0 then
                    SetPlayerModel(playerId, GetHashKey(Config.PlayerPeds[math.random(#Config.PlayerPeds)]))
                end
            else
    
                local playerPedModel = GetEntityModel(playerPed)
    
                -- Set (male or female) multiplayer ped model
                if not Config.AllowCustomPeds then
                    if playerPedModel ~= GetHashKey("mp_m_freemode_01") and playerPedModel ~= GetHashKey("mp_f_freemode_01") then
                        local model = GetHashKey(math.random(0, 1) == 1 and "mp_m_freemode_01" or "mp_f_freemode_01")
                        SetPlayerModel(playerId, model)
                        playerPed = GetPlayerPed(playerId)
                        playerPedModel = model
                    end
                end
    
                -- Set clothes
                if playerPedModel == GetHashKey("mp_m_freemode_01") then
                    if #Config.PlayerOutfits["male"] > 0 then
                        for k,v in pairs(Config.PlayerOutfits["male"][math.random(#Config.PlayerOutfits["male"])]) do
                            if k == 12 then
                                SetPedPropIndex(playerPed, 0,  v[1], v[2], true)
                            else
                                SetPedComponentVariation(
                                    playerPed, 
                                    k,
                                    v[1],
                                    v[2]
                                )
                            end
                        end
                    end
                elseif playerPedModel == GetHashKey("mp_f_freemode_01") then
                    if #Config.PlayerOutfits["female"] > 0 then
                        for k,v in pairs(Config.PlayerOutfits["female"][math.random(#Config.PlayerOutfits["female"])]) do
                            if k == 12 then
                                SetPedPropIndex(playerPed, 0,  v[1], v[2], true)
                            else
                                SetPedComponentVariation(
                                    playerPed, 
                                    k,
                                    v[1],
                                    v[2]
                                )
                            end
                        end
                    end
                end
            end
        end


        -- Teleport
        SetEntityCoords(playerPed, Config.SpawnCoords.GameStarted[math.random(#Config.SpawnCoords.GameStarted)])
        FreezeEntityPosition(playerPed, true)
    end


    Citizen.Wait(1000)
    for playerId,v in pairs(joinedPlayers) do
        TriggerClientEvent("squidgame:drawSprite", playerId, "1", 1000)
    end
    Citizen.Wait(1000)
    for playerId,v in pairs(joinedPlayers) do
        TriggerClientEvent("squidgame:drawSprite", playerId, "2", 1000)
    end
    Citizen.Wait(1000)
    for playerId,v in pairs(joinedPlayers) do
        TriggerClientEvent("squidgame:drawSprite", playerId, "3", 1000)
    end
    Citizen.Wait(1000)

    -- Unfreeze players
    for playerId,v in pairs(joinedPlayers) do
        local playerPed = GetPlayerPed(playerId)
        FreezeEntityPosition(playerPed, false)
        TriggerClientEvent("squidgame:gameStarted", playerId)
    end

    for k,v in ipairs(createdPeds) do
        if v.type == "player" then
            TaskGoStraightToCoord(v.ped, Config.DollyCoords.x, Config.DollyCoords.y, Config.DollyCoords.z, 2.0, 5.0, 5.0, 5.0)
        end
    end

    -- Rotate Dolly
    local dollyIsWatching = false
    for playerId,v in pairs(joinedPlayers) do
        TriggerClientEvent("squidgame:dollyIsNotWatching", playerId)
    end
    rotateObjectDuringTime("dolly_head", Config.DollyIsNotWatchingHeading, 5.0)
    Citizen.Wait(Config.DollySpinInterval)

    -- Stop game when time is up
    Citizen.CreateThread(function()
        local timestamp = GetGameTimer()
        while gameStarted and GetGameTimer() - timestamp < Config.GameDuration do
            Citizen.Wait(1000)
        end
        if gameStarted then
            stopGame()
        end
    end)

    -- Repeat Dolly rotations
    while gameStarted do
        dollyIsWatching = not dollyIsWatching
        if dollyIsWatching then

            rotateObjectDuringTime("dolly_head", Config.DollyIsWatchingHeading, 15.0)
            for playerId,v in pairs(joinedPlayers) do
                TriggerClientEvent("squidgame:dollyIsWatching", playerId)
            end
 
            for k,v in ipairs(createdPeds) do
                if v.type == "player" then
                    if DoesEntityExist(v.ped) then
                        ClearPedTasks(v.ped)
                        if math.random(1, 100) > 50 and GetEntityHealth(v.ped) > 0 then
                            TriggerClientEvent("squidgame:killPed", next(joinedPlayers), NetworkGetNetworkIdFromEntity(v.ped))
                        end
                    end
                end
            end

            Citizen.Wait(Config.DollyWatchingRandomTime[math.random(#Config.DollyWatchingRandomTime)])
        else
            for k,v in ipairs(createdPeds) do
                if v.type == "player" then
                    TaskGoStraightToCoord(v.ped, Config.DollyCoords.x, Config.DollyCoords.y, Config.DollyCoords.z, 2.0, 5.0, 5.0, 5.0)
                end
            end

            for playerId,v in pairs(joinedPlayers) do
                TriggerClientEvent("squidgame:dollyIsNotWatching", playerId)
            end
            rotateObjectDuringTime("dolly_head", Config.DollyIsNotWatchingHeading, 5.0)
        end

        Citizen.Wait(Config.DollySpinInterval)
    end
end

RegisterCommand("squidgame-start", function()
    startGame()
end, true)

RegisterNetEvent("squidgame:playerFailed", function()
    playerFailed(source)
end)

RegisterNetEvent("squidgame:playerSuccess", function()
    local playerId = source
    if not joinedPlayers[tostring(playerId)] then
        return
    end

    print("Người chơi đã hoàn thành", GetPlayerName(playerId))

    local playerPed = GetPlayerPed(playerId)
    joinedPlayers[tostring(playerId)] = nil
    
    SetEntityCoords(playerPed, Config.SpawnCoords.GameSuccess[math.random(#Config.SpawnCoords.GameSuccess)])
end)


function rotateObjectDuringTime(objectId, finalHeading, deg)
    deg = deg or 5.0
    local heading = createdObjects[objectId].heading

    while true do
        Citizen.Wait(25)
        heading = (heading + deg) % 360
        local diff = math.abs(finalHeading - heading)
        
        if diff < (deg * 2) then
            createdObjects[objectId].heading = finalHeading
            for playerId,v in pairs(joinedPlayers) do
                TriggerClientEvent("squidgame:SetEntityHeading", playerId, {
                    id = objectId,
                    heading = math.abs((finalHeading + deg) % 360)
                })
            end
            break
        end

        createdObjects[objectId].heading = heading

        for playerId,v in pairs(joinedPlayers) do
            TriggerClientEvent("squidgame:SetEntityHeading", playerId, {
                id = objectId,
                heading = heading
            })
        end

    end
end

RegisterNetEvent("squidgame:clientStarted", function()
    local playerId = source
    Player(playerId).state:set("squidgame:inFinishZone", false, true)
    TriggerClientEvent("squidgame:createObjects", playerId, createdObjects)
end)


Citizen.CreateThread(function()
    local gameStartsAt = GetGameTimer() + Config.GameStartInterval
    while true do

        local timeLeftBeforeGameStarts = math.max(0, gameStartsAt - GetGameTimer())
        for playerId,v in pairs(joinedPlayers) do
            TriggerClientEvent("squidgame:timeLeftBeforeGameStarts", playerId, timeLeftBeforeGameStarts)
        end

        if timeLeftBeforeGameStarts == 0 then
            startGame()
            gameStartsAt = GetGameTimer() + Config.GameStartInterval
        end
        
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("squidgame:playerInFinishZone", function()
    local playerId = source
    if not joinedPlayers[tostring(playerId)] then
        return
    end

    local playersCount = 0
    for k,v in pairs(joinedPlayers) do
        playersCount = playersCount + 1
    end

    if playersCount == 1 then
        stopGame()
    end
end)