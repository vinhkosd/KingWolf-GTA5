-- City of Zombies (air-drop timer)
local airdropTimer
startTimer = function(s)
    airdropTimer = s
    local m = math.floor(s / 60)
    local s = s - m * 60
    SendNUIMessage({
        start = true,
        s = s,
        m = m,
        show = true,
    })
end

stopTimer = function()
    SendNUIMessage({
        stop = true,
        show = false,
    })
end

resetTimer = function()
    SendNUIMessage({
        reset = true,
    })
end

RegisterNetEvent("squidgame:startTimer", function(s)
    startTimer(s)
end)

RegisterNetEvent("squidgame:stopTimer", function()
    stopTimer()
end)

RegisterNetEvent("squidgame:resetTimer", function()
    resetTimer()
end)

function toggleTimer(state)
    SendNUIMessage({
        show = state,
    })
end
exports("toggleTimer", toggleTimer)