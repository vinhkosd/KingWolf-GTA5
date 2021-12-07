local lastPlayerModel
local lastPlayerSkin = {}

local function restorePlayerSkin()
    local playerPed = PlayerPedId()
    if GetEntityModel(playerPed) ~= lastPlayerModel then
        RequestModel(lastPlayerModel)
        while not HasModelLoaded(lastPlayerModel) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), lastPlayerModel)
        playerPed = PlayerPedId()
    end

    for componentId,v in pairs(lastPlayerSkin) do
        if componentId == 12 then
            if v[1] ~= -1 and v[1] ~= 0 then
                SetPedPropIndex(playerPed, 0,  v[1], v[2], true)
            else
                ClearPedProp(ped, 0)
            end
        else
            SetPedComponentVariation(playerPed, componentId, v[1], v[2], v[3])
        end
        
    end
end

local function savePlayerSkin()
    local playerPed = PlayerPedId()
    lastPlayerModel = GetEntityModel(playerPed)
    for i=0,12,1 do
        if i == 12 then
            local d = GetPedPropIndex(playerPed, 0)
            local t = GetPedPropTextureIndex(playerPed, 0)
            local p = 0
            lastPlayerSkin[i] = {d, t, p}
            print(i, d, t, p)
        else
        local d = GetPedDrawableVariation(playerPed, i)
        local t = GetPedTextureVariation(playerPed, i)
        local p = GetPedPaletteVariation(playerPed, i)
        lastPlayerSkin[i] = {d, t, p}
        print(i, d, t, p)
        end
    end
end

RegisterNetEvent("squidgame:gameOver", function()
    if Config.ChangePlayerSkin then
        restorePlayerSkin()
    end
end)

RegisterNetEvent("squidgame:refreshGameInfo", function(isPointInside, point)
    if Config.ChangePlayerSkin then
        savePlayerSkin()
    end
end)