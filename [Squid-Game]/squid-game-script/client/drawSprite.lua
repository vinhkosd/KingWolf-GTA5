local drawing = false

local xscale = 4.0
local yscale = 4.0
local aspect = GetAspectRatio(0)

RegisterNetEvent("squidgame:drawSprite", function(textureName, duration)
    drawing = false
    drawing = true
    local timestamp = GetGameTimer()
    while drawing and (GetGameTimer() - timestamp <= duration) do
        Citizen.Wait(0)
        if HasStreamedTextureDictLoaded("squidgame") then
            DrawSprite(
                "squidgame" --[[ string ]], 
                textureName --[[ string ]], 
                0.5 --[[ number ]], 
                0.5 --[[ number ]], 
                100.0 --[[ number ]], 
                100.0 --[[ number ]], 
                0.0 --[[ number ]], 
                255 --[[ integer ]], 
                255 --[[ integer ]], 
                255 --[[ integer ]], 
                255 --[[ integer ]]
            )
            DrawSprite("squidgame", textureName, 0.5, 0.1, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
        else
            RequestStreamedTextureDict("squidgame", true)
        end
    end    
end)