RegisterNetEvent('kingwolf-shopping:client:send:alert')
AddEventHandler('kingwolf-shopping:client:send:alert', function(Coords, StreetName, job)
    if (Framework.Functions.GetPlayerData().job.name == job) and Framework.Functions.GetPlayerData().job.onduty then
        local Color = 47
        if job == "trada" then
            Color = 49
        end
        TriggerEvent('pepe-alerts:client:send:alert:shopping', {
            timeOut = 15000,
            alertTitle = "Có đơn hàng mới",
            priority = 100,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-utensils"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, true)
        AddAlert('Có đơn hàng mới', 1, 250, Coords, Color)
    end
end)

-- // Funtions \\ --

function AddAlert(Text, Sprite, Transition, Coords, Color)
 local Transition = Transition
 local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
 SetBlipSprite(Blips, Sprite)
 SetBlipColour(Blips, Color)--pizza 47, trada 49
 SetBlipDisplay(Blips, 4)
 SetBlipAlpha(Blips, transG)
 SetBlipScale(Blips, 1.0)
 SetBlipAsShortRange(Blips, false)
 SetBlipFlashes(Blips, true)
 BeginTextCommandSetBlipName('STRING')
 AddTextComponentString(Text)
 EndTextCommandSetBlipName(Blips)
 while Transition ~= 0 do
     Wait(180 * 4)
     Transition = Transition - 1
     SetBlipAlpha(Blips, Transition)
     if Transition == 0 then
         SetBlipSprite(Blips, 2)
         RemoveBlip(Blips)
         return
     end
 end
end