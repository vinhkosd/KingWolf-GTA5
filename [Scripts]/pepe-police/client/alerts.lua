RegisterNetEvent('pepe-police:client:send:officer:down')
AddEventHandler('pepe-police:client:send:officer:down', function(Coords, StreetName, Info, Priority)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        local Title, Callsign = 'Officier xuống', '10-13B'
        if Priority == 3 then
            Title, Callsign = 'Officier xuống (khẩn cấp)', '10-13A'
        end
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = Title,
            priority = Priority,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = Callsign,
        })
        AddAlert(Title, 306, 250, Coords, false)
    end
end)

RegisterNetEvent('pepe-police:client:send:alert:panic:button')
AddEventHandler('pepe-police:client:send:alert:panic:button', function(Coords, StreetName, Info)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Khẩn cấp",
            priority = 9,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-13C',
        })
        AddAlert('Nút khẩn cấp', 487, 250, Coords, false)
    end
end)

RegisterNetEvent('pepe-police:client:send:alert:gunshots')
AddEventHandler('pepe-police:client:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
   if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
     local AlertMessage, CallSign = 'Shots phát hành.', '10-47A'
     if InVeh then
         AlertMessage, CallSign = 'Phát súng bắn từ xe', '10-47B'
     end
     TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 7500,
        alertTitle = AlertMessage,
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="far fa-arrow-alt-circle-right"></i>',
                detail = GunType,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = CallSign,
    })
    AddAlert(AlertMessage, 313, 250, Coords, false)
  end
end)

RegisterNetEvent('pepe-police:client:send:alert:dead')
AddEventHandler('pepe-police:client:send:alert:dead', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police" or Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Công dân bị thương",
            priority = 90,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert('Công dân bị thương', 480, 250, Coords, false)
    end
end)

RegisterNetEvent('pepe-police:client:send:bank:alert')
AddEventHandler('pepe-police:client:send:bank:alert', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Ngân hàng Fleeca",
            priority = 100,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, true)
        AddAlert('Ngân hàng Fleeca', 108, 250, Coords, false)
    end
end)


RegisterNetEvent('pepe-police:client:send:meter:alert')
AddEventHandler('pepe-police:client:send:meter:alert', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Trộm đồng hồ",
            priority = 100,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, true)
        AddAlert('Trộm đồng hồ', 108, 250, Coords, false)
    end
end)


RegisterNetEvent('pepe-police:client:send:alert:jewellery')
AddEventHandler('pepe-police:client:send:alert:jewellery', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Cửa hàng đá quý",
        priority = 100,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-42A',
    }, true)
    AddAlert('Cửa hàng đá quý', 617, 250, Coords, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:alert:store')
AddEventHandler('pepe-police:client:send:alert:store', function(Coords, StreetName, StoreNumber)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Báo động cửa hàng",
        priority = 100,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-shopping-basket"></i>',
                detail = 'Winkel: '..StoreNumber,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-98A',
    }, true)
    AddAlert('Báo động cửa hàng', 59, 250, Coords, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:house:alert')
AddEventHandler('pepe-police:client:send:house:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Báo động nhà",
        priority = 100,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-63B',
    }, true)
    AddAlert('Báo động nhà', 40, 250, Coords, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:ammunation:alert')
AddEventHandler('pepe-police:client:send:ammunation:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Báo động cửa hàng vũ khí",
        priority = 100,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-03A',
    }, true)
    AddAlert('Báo động cửa hàng vũ khí', 67, 250, Coords, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:banktruck:alert')
AddEventHandler('pepe-police:client:send:banktruck:alert', function(Coords, Plate, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Báo động xe tải ngân hàng",
        priority = 100,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-closed-captioning"></i>',
                detail = 'Biển số xe: '..Plate,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-03A',
    }, true)
    AddAlert('Báo động xe tải ngân hàng', 67, 250, Coords, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:weed:alert')
AddEventHandler('pepe-police:client:send:weed:alert', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Hái cần sa",
            priority = 100,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-cannabis"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, true)
        AddAlert('Hái cần sa', 140, 250, Coords, false)
    end
end)

RegisterNetEvent('pepe-police:client:send:packweed:alert')
AddEventHandler('pepe-police:client:send:packweed:alert', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Chế cần sa",
            priority = 100,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-cannabis"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, true)
        AddAlert('Chế cần sa', 140, 250, Coords, false)
    end
end)

RegisterNetEvent('pepe-police:client:send:tracker:alert')
AddEventHandler('pepe-police:client:send:tracker:alert', function(Coords, Name)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
      AddAlert('Địa điểm Vòng đeo chân: '..Name, 480, 250, Coords, true)
    end
end)

-- // Funtions \\ --

function AddAlert(Text, Sprite, Transition, Coords, Tracker)
 local Transition = Transition
 local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
 SetBlipSprite(Blips, Sprite)
 SetBlipColour(Blips, 6)
 SetBlipDisplay(Blips, 4)
 SetBlipAlpha(Blips, transG)
 SetBlipScale(Blips, 1.0)
 SetBlipAsShortRange(Blips, false)
 SetBlipFlashes(Blips, true)
 BeginTextCommandSetBlipName('STRING')
 if not Tracker then
  AddTextComponentString('BÁO CÁO MỚI: '..Text)
 else
  AddTextComponentString(Text)
 end
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