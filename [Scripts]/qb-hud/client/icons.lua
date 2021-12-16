RegisterNetEvent('pepe-hud:client:ToggleDevMode')
AddEventHandler('pepe-hud:client:ToggleDevMode', function(IsActive) 
    if IsActive == nil then
        DevMode = not DevMode
        SendNUIMessage({
            action = "DevMode",
            DevMode = DevMode,
        }) 
    else
        DevMode = IsActive
        SendNUIMessage({
            action = "DevMode",
            DevMode = IsActive,
        })
    end
end)  

RegisterNetEvent('pepe-hud:client:ToggleWeaponMode')
AddEventHandler('pepe-hud:client:ToggleWeaponMode', function(IsActive) 
    if IsActive == nil then
        WeaponMode = not WeaponMode
        SendNUIMessage({
            action = "WeaponMode",
            WeaponMode = WeaponMode,
        }) 
    else
        WeaponMode = IsActive
        SendNUIMessage({
            action = "WeaponMode",
            WeaponMode = IsActive,
        })
    end
end)  

RegisterNetEvent('pepe-hud:client:ToggleBugMode')
AddEventHandler('pepe-hud:client:ToggleBugMode', function(IsActive) 
    if IsActive == nil then
        BugMode = not BugMode
        SendNUIMessage({
            action = "BugMode",
            BugMode = BugMode,
        }) 
    else
        BugMode = IsActive
        SendNUIMessage({
            action = "BugMode",
            BugMode = IsActive,
        })
    end
end) 


RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = toggle,
        })
    end
end)

RegisterNetEvent('pepe-hud:client:ToggleDrunkMode')
AddEventHandler('pepe-hud:client:ToggleDrunkMode', function(IsActive)  
    if IsActive == nil then
        DrunkMode = not DrunkMode
        SendNUIMessage({
            action = "DrunkMode", 
            DrunkMode = DrunkMode,
        }) 
    else
        DrunkMode = IsActive
        SendNUIMessage({
            action = "DrunkMode",
            DrunkMode = IsActive,
        })
    end
end) 