startPoint = CircleZone:Create(Config.StartPoint, 20.0, {
    name="startPoint",
    useZ=true,
    -- debugPoly=true
})

local drawMarkerPoint = CircleZone:Create(Config.StartPoint, 50.0, {
    name="startPoint",
    useZ=false,
    -- debugPoly=true
})

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.StartPoint.x,Config.StartPoint.y,Config.StartPoint.z)
    SetBlipSprite(blip, 378)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 1.3)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
    SetBlipHighDetail(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U("squid_game"))
    EndTextCommandSetBlipName(blip)
end)

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0*scale, 1.15*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150) 
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawIndicator(location, color)
    if HasStreamedTextureDictLoaded("squidgame") then
        local scale = 3.2
        DrawMarker(
            9, -- type (6 is a vertical and 3D ring)
            location,
            0.0, 0.0, 0.0, -- direction (?)
            90.0, 90.0, 0.0, -- rotation (90 degrees because the right is really vertical)
            scale, scale, scale, -- scale
            color[1], color[2], color[3], color[4],
            false, -- bob
            true, -- face camera
            2, -- dunno, lol, 100% cargo cult
            false, -- rotates
            "squidgame", "3", -- texture
            false -- Projects/draws on entities
        )
    else
        RequestStreamedTextureDict("squidgame", true)
    end
end

local timeLeftBeforeGameStarts = 0
local playersCount = 0
local totalReward = 0
local insideStartPoint = false
startPoint:onPlayerInOut(function(isPointInside, point)
    insideStartPoint = isPointInside

    if not gameStarted and insideStartPoint then
        ExecuteCommand("squidgame-join")
    end

    if not insideStartPoint and not gameStarted then
        ExecuteCommand("squidgame-left")
    end

    Citizen.CreateThread(function()
        while insideStartPoint do
            Citizen.Wait(0)
            local gameInfoText = ""
            
            if gameStarted then
                gameInfoText = "~r~GAME STARTED"
            else
                local seconds = math.ceil(timeLeftBeforeGameStarts / 1000)
                if timeLeftBeforeGameStarts == 0 then
                    gameInfoText = _U("game_already_started")
                else
                    gameInfoText = _U("game_waiting", seconds, Config.Fee)
                end
                
            end

            Draw3DText(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z + 1.0, gameInfoText)
        end
    end)
end)
local insideDrawMarkerPoint = false
drawMarkerPoint:onPlayerInOut(function(isPointInside, point)
    insideDrawMarkerPoint = isPointInside
    Citizen.CreateThread(function()
        while insideDrawMarkerPoint do
            Citizen.Wait(0)
            local gameInfoText = ""
            DrawIndicator(vector3(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z + 2.0), {255, 255, 255, 255})
            DrawMarker(
                1, -- type (6 is a vertical and 3D ring)
                vector3(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z - 2.0),
                0.0, 0.0, 0.0, -- direction (?)
                0.0, 0.0, 0.0, -- rotation (90 degrees because the right is really vertical)
                40.0, 40.0, 4.0, -- scale
                255, 255, 0, 125,
                false, -- bob
                true, -- face camera
                2, -- dunno, lol, 100% cargo cult
                false, -- rotates
                nil, nil, -- texture
                false -- Projects/draws on entities
            )
        end
    end)
end)


RegisterNetEvent("squidgame:timeLeftBeforeGameStarts", function(v)
    timeLeftBeforeGameStarts = v
end)

RegisterNetEvent("squidgame:refreshGameInfo", function(v)
    playersCount = v.playersCount
    totalReward = v.totalReward
end)

