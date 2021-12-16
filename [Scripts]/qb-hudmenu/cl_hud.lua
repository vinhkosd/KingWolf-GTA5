local hudDisplay = false


RegisterCommand("hud", function(source)
    SetNuiFocus(true,true)
    SendNUIMessage({
        response = "hud"
    })
end)

RegisterNetEvent('doj:client:OpenHudMenu')
AddEventHandler('doj:client:OpenHudMenu', function()
    SetNuiFocus(true,true)
    SendNUIMessage({
        response = "hud"
    }) 
end)


function setDisplayHud(bool)
    SendNUIMessage({
        response = "hud"
    })
end

RegisterNUICallback('closeHud', function()
    SetNuiFocus(false, false)
    hudDisplay = false
end) 

RegisterNUICallback('UpdateHudSettings', function(data)
    TriggerEvent('hudmenu:set',data)
end)
