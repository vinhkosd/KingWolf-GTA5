local DoingRayCast, ShowingEye, PreviousEntity = false, false, 1
TrunkCam, InTrunk = nil, false
local CurrentEntity = {}
local HitData = false
local LoggedIn = false
local Framework = nil  

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1000, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(250)
        LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InTrunk then
                if IsEntityDead(GetPlayerPed(-1)) then
                    local Vehicle = GetEntityAttachedTo(PlayerPedId())
                    local VehicleCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -5.0, 0)
                    local Plate = GetVehicleNumberPlateText(Vehicle)
                    TrunkCams(false)
                    SetEntityVisible(GetPlayerPed(-1), true)
                    DetachEntity(GetPlayerPed(-1), true, true)
                    ClearPedTasks(GetPlayerPed(-1))
                    SetEntityCoords(GetPlayerPed(-1), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z)
                    SetEntityCollision(PlayerPedId(), true, true)
                    TriggerServerEvent('pepe-eye:server:set:trunk:data', Plate, false)
                    InTrunk = false
                end
                Citizen.Wait(150)
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local Vehicle = GetEntityAttachedTo(PlayerPedId())
        local CameraCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -5.5, 0)
        local VehicleHeading = GetEntityHeading(Vehicle)
        if TrunkCam ~= nil then
            SetCamRot(TrunkCam, -2.5, 0.0, VehicleHeading, 0.0)
            SetCamCoord(TrunkCam, CameraCoords.x, CameraCoords.y, CameraCoords.z + 2)
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustPressed(0, 47) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if not ShowingEye then
                    DoingRayCast = true
                    ShowingEye = true
                    SetNuiFocus(true, false)
                    SetNuiFocusKeepInput(true)
                    SendNUIMessage({action = 'OpenEye'})
                    TriggerEvent('pepe-inventory:client:set:busy', true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if DoingRayCast then
                local DataOne, DataTwo, DataThree, DataFour, DataFive = RayCastGamePlayCamera()
                if DataFive ~= PreviousEntity then
                    CurrentEntity['Entity'] = DataFive
                    CurrentEntity['Hash'] = GetEntityModel(DataFive)
                    CurrentEntity['Coords'] = GetEntityCoords(DataFive)
                    CurrentEntity['Heading'] =  GetEntityHeading(DataFive)
                    CurrentEntity['Rotation'] = GetEntityRotation(DataFive)
                    CurrentEntity['IsPlayer'] = false
                    CurrentEntity['IsCar'] = false
                    CurrentEntity['IsPed'] = false
                    if IsPedAPlayer(DataFive) then
                        CurrentEntity['IsPlayer'] = true
                    elseif IsThisModelACar(CurrentEntity['Hash']) then
                        CurrentEntity['IsCar'] = true
                    elseif IsModelAPed(CurrentEntity['Hash']) then
                        CurrentEntity['IsPed'] = true
                    end
                    SendCurrentObjectData()
                    PreviousEntity = DataFive
                end
            else
                Citizen.Wait(450)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if ShowingEye then
                if IsControlJustReleased(0, 68) then
                    if HitData then
                        if not MouseActive then
                            MouseActive = true
                            SetNuiFocus(true, true)
                            SetNuiFocusKeepInput(false)
                            SendNUIMessage({action = 'OpenMenu'})
                            Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
                        end
                    end
                end
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisablePlayerFiring(PlayerPedId(), true)
            else
                Citizen.Wait(450)
            end
        end
    end
end)

-- // Main Functions \\ --

function SendCurrentObjectData()
    if Config.ObjectOptions[CurrentEntity['Hash']] ~= nil then
        if Config.ObjectOptions[CurrentEntity['Hash']]['Job'] ~= nil then
            if Framework.Functions.GetPlayerData().job.name == Config.ObjectOptions[CurrentEntity['Hash']]['Job'] then
                if Config.ObjectOptions[CurrentEntity['Hash']]['UseDuty'] then
                    if Framework.Functions.GetPlayerData().job.onduty then
                        if not CurrentEntity['IsPlayer'] then
                            SendNUIMessage({
                                action = 'SetData',
                                specific = false,
                                currentdata = Config.ObjectOptions[CurrentEntity['Hash']],
                            })
                            HitData = true
                        end
                    else
                        HitData = false
                        SendNUIMessage({action = 'ResetEye'})
                    end
                else
                    if not CurrentEntity['IsPlayer'] then
                        SendNUIMessage({
                            action = 'SetData',
                            specific = false,
                            currentdata = Config.ObjectOptions[CurrentEntity['Hash']],
                        })
                        HitData = true
                    end
                end
            end
        elseif Config.ObjectOptions[CurrentEntity['Hash']]['MetaData'] ~= nil then
            if Config.ObjectOptions[CurrentEntity['Hash']]['MetaData'] == 'jail' then
                if Framework.Functions.GetPlayerData().metadata['jail'].Injail then
                    if not CurrentEntity['IsPlayer'] then
                        SendNUIMessage({
                            action = 'SetData',
                            specific = false,
                            currentdata = Config.ObjectOptions[CurrentEntity['Hash']],
                        })
                        HitData = true
                    end
                else
                    HitData = false
                    SendNUIMessage({action = 'ResetEye'})
                end
            else
                if Framework.Functions.GetPlayerData().metadata[Config.ObjectOptions[CurrentEntity['Hash']]['MetaData']] then
                    if not CurrentEntity['IsPlayer'] then
                        SendNUIMessage({
                            action = 'SetData',
                            specific = false,
                            currentdata = Config.ObjectOptions[CurrentEntity['Hash']],
                        })
                        HitData = true
                    end
                else
                    HitData = false
                    SendNUIMessage({action = 'ResetEye'})
                end
            end
        else
            if CurrentEntity['Hash'] == GetHashKey('v_ind_bin_01') then
                local ObjectData = Config.ObjectOptions[CurrentEntity['Hash']]
                if ObjectData[1]['Job'] == Framework.Functions.GetPlayerData().job.name then
                    if Framework.Functions.GetPlayerData().job.onduty then
                        SendNUIMessage({
                            action = 'SetData',
                            specific = false,
                            currentdata = ObjectData,
                        })
                        HitData = true
                    else
                        SendNUIMessage({
                            action = 'SetData',
                            specific = true,
                            currentdata = ObjectData[2],
                        })
                        HitData = true
                    end
                else
                    SendNUIMessage({
                        action = 'SetData',
                        specific = true,
                        currentdata = ObjectData[2],
                    })
                    HitData = true
                end
            else
                if not CurrentEntity['IsPlayer'] then
                    SendNUIMessage({
                        action = 'SetData',
                        specific = false,
                        currentdata = Config.ObjectOptions[CurrentEntity['Hash']],
                    })
                    HitData = true
                end
            end
        end
    elseif CurrentEntity['IsCar'] then
        if Framework.Functions.GetPlayerData().job.name == 'cardealer' then
            SendNUIMessage({
                action = 'SetData',
                specific = false,
                currentdata = Config.CarDealerVehicleMenu,
            })
            HitData = true
        else
          SendNUIMessage({
              action = 'SetData',
              specific = false,
              currentdata = Config.VehicleMenu,
          })
          HitData = true
        end
    elseif CurrentEntity['IsPed'] then
        if not IsEntityDead(CurrentEntity['Entity']) then
            if not CurrentEntity['IsPlayer'] then
                SendNUIMessage({
                    action = 'SetData',
                    specific = false,
                    currentdata = Config.PedMenu,
                })
                HitData = true
            end
        else
            HitData = false
            SendNUIMessage({action = 'ResetEye'}) 
        end
    else
        HitData = false
        SendNUIMessage({action = 'ResetEye'})
    end
end

RegisterNUICallback('CloseUi', function()
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    Citizen.Wait(50)
    ShowingEye = false
    PreviousEntity = 1
    MouseActive = false
    DoingRayCast = false
    Citizen.SetTimeout(165, function()
        CurrentEntity = {}
    end)
    DisablePlayerFiring(PlayerPedId(), false)
    TriggerEvent('pepe-inventory:client:set:busy', false)
end)

RegisterNUICallback('CloseMenu', function()
    MouseActive = false
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, false)
    SendNUIMessage({action = 'CloseMenu'})
end)

RegisterNUICallback('DoSomething', function(data)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    Citizen.SetTimeout(250, function()
        if data.type == 'Client' then
            TriggerEvent(data.event, data.parameter)
        else
            TriggerServerEvent(data.event, data.parameter)
        end
    end)
end)

RegisterNetEvent('pepe-eye:client:open:trunk')
AddEventHandler('pepe-eye:client:open:trunk', function()
    if GetVehicleDoorAngleRatio(CurrentEntity['Entity'], 5) > 0.0 then
        SetVehicleDoorShut(CurrentEntity['Entity'], 5, false)
    else
        SetVehicleDoorOpen(CurrentEntity['Entity'], 5, false, false)
    end
end)

RegisterNetEvent('pepe-eye:client:sync:trunk:data')
AddEventHandler('pepe-eye:client:sync:trunk:data', function(ConfigData)
    Config.TrunkData = ConfigData
end)

RegisterNetEvent('pepe-eye:client:getin:trunk')
AddEventHandler('pepe-eye:client:getin:trunk', function()
    local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
    if Vehicle ~= 0 and Distance < 5.0 then
        local VehicleClass = GetVehicleClass(Vehicle)
        local Plate = GetVehicleNumberPlateText(Vehicle)
        if Config.TrunkData[Plate] == nil then
            TriggerServerEvent('pepe-eye:server:setup:trunk:data', Plate)
            Citizen.Wait(150)
            if not Config.TrunkData[Plate]['Busy'] then
                if GetVehicleDoorAngleRatio(Vehicle, 5) > 0 then
                    local ClassData = Config.VehicleOFfsets[VehicleClass]
                    if ClassData['CanEnter'] then
                        InTrunk = true
                        exports['pepe-assets']:RequestAnimationDict("fin_ext_p1-7")
                        TriggerServerEvent('pepe-eye:server:set:trunk:data', Plate, true)
                        TaskPlayAnim(GetPlayerPed(-1), "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                        AttachEntityToEntity(GetPlayerPed(-1), Vehicle, 0, ClassData['X-Offset'], ClassData['Y-Offset'], ClassData['Z-Offset'], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                        SetVehicleDoorShut(Vehicle, 5, false)
                        SetEntityVisible(GetPlayerPed(-1), false)
                        TrunkCams(true)
                    else
                        Framework.Functions.Notify('Đã từng nhảy vào cốp xe?', 'error', 2500)
                    end
                else
                    Framework.Functions.Notify('Đang mở cốp?', 'error', 2500)
                end
            else
                Framework.Functions.Notify('Đã có một người nào đó trong cốp.', 'error', 2500)
            end
        else
            if not Config.TrunkData[Plate]['Busy'] then
                if GetVehicleDoorAngleRatio(Vehicle, 5) > 0 then
                    local ClassData = Config.VehicleOFfsets[VehicleClass]
                    if ClassData['CanEnter'] then
                        InTrunk = true
                        exports['pepe-assets']:RequestAnimationDict("fin_ext_p1-7")
                        TriggerServerEvent('pepe-eye:server:set:trunk:data', Plate, true)
                        TaskPlayAnim(GetPlayerPed(-1), "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                        AttachEntityToEntity(GetPlayerPed(-1), Vehicle, 0, ClassData['X-Offset'], ClassData['Y-Offset'], ClassData['Z-Offset'], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                        SetVehicleDoorShut(Vehicle, 5, false)
                        SetEntityVisible(GetPlayerPed(-1), false)
                        TrunkCams(true)
                    else
                        Framework.Functions.Notify('Đã từng nhảy vào cốp xe?', 'error', 2500)
                    end
                else
                    Framework.Functions.Notify('Đang mở cốp xe?', 'error', 2500)
                end
            else
                Framework.Functions.Notify('Đã có một người nào đó trong cốp xe', 'error', 2500)
            end
        end
    else
        Framework.Functions.Notify('Không tìm thấy xe', 'error', 2500)
    end
end)

RegisterNetEvent('pepe-eye:client:getout:trunk')
AddEventHandler('pepe-eye:client:getout:trunk', function()
    local Vehicle = GetEntityAttachedTo(PlayerPedId())
    local VehicleCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -5.0, 0)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if GetVehicleDoorAngleRatio(Vehicle, 5) > 0 then
        TrunkCams(false)
        SetEntityVisible(GetPlayerPed(-1), true)
        DetachEntity(GetPlayerPed(-1), true, true)
        ClearPedTasks(GetPlayerPed(-1))
        SetEntityCoords(GetPlayerPed(-1), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z)
        SetEntityCollision(PlayerPedId(), true, true)
        TriggerServerEvent('pepe-eye:server:set:trunk:data', Plate, false)
        InTrunk = false
    else
        Framework.Functions.Notify('Đang mở cốp xe?', 'error', 2500)
    end
end)

RegisterNetEvent('pepe-eye:client:refresh')
AddEventHandler('pepe-eye:client:refresh', function()
    Framework.Functions.Progressbar("reset-eye", "Đã đặt lại..", 1200, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        SendNUIMessage({action = 'ForceRefresh'})
    end, function() -- Cancel
    end)
end)

FishyDEV = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
        local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 108.79, -1288.87, 29.43, true)
        if Distance <= 3.0 then
            if IsControlJustReleased(0, 38) and not FishyDEV then
			    FishyDEV = true
                LoadDict('mini@strip_club@pole_dance@pole_dance1')
                local scene = NetworkCreateSynchronisedScene(108.81, -1289.04, 29.43, vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance1', 'pd_dance_01', 1.5, -4.0, 1, 1, 1148846080, 0)
                NetworkStartSynchronisedScene(scene)
			elseif IsControlJustReleased(0, 38) and FishyDEV then
			FishyDEV = false
			ClearPedTasksImmediately(PlayerPedId())
            end
        end
    end
end)

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end