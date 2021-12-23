local CurrentDivingLocation = {
    Area = 0,
    Blip = {
        Radius = nil,
        Label = nil
    }
}
local canDiving = false
local CurrentCops = 0

RegisterNetEvent('pepe-diving:client:NewLocations')
AddEventHandler('pepe-diving:client:NewLocations', function()
    Framework.Functions.TriggerCallback('pepe-diving:server:GetDivingConfig', function(Config, Area)
        QBDiving.Locations = Config
        TriggerEvent('pepe-diving:client:SetDivingLocation', Area)
    end)
end)

RegisterNetEvent('pepe-diving:client:SetDivingLocation')
AddEventHandler('pepe-diving:client:SetDivingLocation', function(DivingLocation)
    CurrentDivingLocation.Area = DivingLocation

    -- for _, Blip in pairs(CurrentDivingLocation.Blip) do
    --     if Blip ~= nil then
    --         RemoveBlip(Blip)
    --     end
    -- end
    if CurrentDivingLocation.Blip.Label ~= nil then
        RemoveBlip(CurrentDivingLocation.Blip.Label)
        RemoveBlip(CurrentDivingLocation.Blip.Radius)
        CurrentDivingLocation.Blip.Label = nil
        CurrentDivingLocation.Blip.Radius = nil
    end

    canDiving = false
    if (Framework.Functions.GetPlayerData().job.name == "police" and Framework.Functions.GetPlayerData().job.onduty) then
        Citizen.CreateThread(function()
            RadiusBlip = AddBlipForRadius(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z, 100.0)
            
            SetBlipRotation(RadiusBlip, 0)
            SetBlipColour(RadiusBlip, 47)
    
            CurrentDivingLocation.Blip.Radius = RadiusBlip
    
            LabelBlip = AddBlipForCoord(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)
    
            SetBlipSprite (LabelBlip, 597)
            SetBlipDisplay(LabelBlip, 4)
            SetBlipScale  (LabelBlip, 0.7)
            SetBlipColour(LabelBlip, 0)
            SetBlipAsShortRange(LabelBlip, true)
    
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Khu vực lặn (Chỉ Cảnh sát)')
            EndTextCommandSetBlipName(LabelBlip)
    
            CurrentDivingLocation.Blip.Label = LabelBlip
            Citizen.SetTimeout((15 * 60 * 1000), function()
                canDiving = true
            end)
        end)
    else
        Citizen.CreateThread(function()
            -- Citizen.SetTimeout((15 * 60 * 1000), function()
                canDiving = true
                Citizen.CreateThread(function()
                    RadiusBlip = AddBlipForRadius(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z, 100.0)
                    
                    SetBlipRotation(RadiusBlip, 0)
                    SetBlipColour(RadiusBlip, 47)
            
                    CurrentDivingLocation.Blip.Radius = RadiusBlip
            
                    LabelBlip = AddBlipForCoord(QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)
            
                    SetBlipSprite (LabelBlip, 597)
                    SetBlipDisplay(LabelBlip, 4)
                    SetBlipScale  (LabelBlip, 0.7)
                    SetBlipColour(LabelBlip, 0)
                    SetBlipAsShortRange(LabelBlip, true)
            
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentSubstringPlayerName('Khu vực lặn')
                    EndTextCommandSetBlipName(LabelBlip)
            
                    CurrentDivingLocation.Blip.Label = LabelBlip
                end)
            -- end)--5p spawn lại điểm lặn 1 lần
        end)
    end
end)

RegisterNetEvent('pepe-police:SetCopCount')
AddEventHandler('pepe-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

Citizen.CreateThread(function()
    while true do
        local inRange = false
        local Ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(Ped)

        if CurrentDivingLocation.Area ~= 0 then
            local AreaDistance = GetDistanceBetweenCoords(Pos, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.x, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.y, QBDiving.Locations[CurrentDivingLocation.Area].coords.Area.z)
            local CoralDistance = nil
            if AreaDistance < 1000 then
                inRange = true
            end

            if inRange and canDiving then
                for cur, CoralLocation in pairs(QBDiving.Locations[CurrentDivingLocation.Area].coords.Coral) do
                    CoralDistance = GetDistanceBetweenCoords(Pos, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, true)

                    if CoralDistance ~= nil then
                        if CoralDistance <= 30 then
                            if not CoralLocation.PickedUp then
                                DrawMarker(32, CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 1.0, 0.4, 255, 223, 0, 255, true, false, false, false, false, false, false)
                                if CoralDistance <= 1.5 then
                                    DrawText3D(CoralLocation.coords.x, CoralLocation.coords.y, CoralLocation.coords.z, '[E] Tìm san hô')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        if CurrentCops < Config.PoliceNeededs then--Vinh:kiểm tra số lượng cảnh sát đã đủ chưa
                                            Framework.Functions.Notify('Cần '..Config.PoliceNeededs..' cảnh sát để làm việc này', 'error')
                                            return
                                        end
                                        -- loadAnimDict("pickup_object")
                                        local times = math.random(2, 5)
                                        CallCops()
                                        FreezeEntityPosition(Ped, true)
                                        Framework.Functions.Progressbar("take_coral", "Đang thu thập san hô..", times * 1000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                                            anim = "plant_floor",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            TakeCoral(cur)
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end, function() -- Cancel
                                            ClearPedTasks(Ped)
                                            FreezeEntityPosition(Ped, false)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2500)
        end

        Citizen.Wait(3)
    end
end)

function TakeCoral(coral)
    QBDiving.Locations[CurrentDivingLocation.Area].coords.Coral[coral].PickedUp = true
    TriggerServerEvent('pepe-diving:server:TakeCoral', CurrentDivingLocation.Area, coral, true)
end

RegisterNetEvent('pepe-diving:client:UpdateCoral')
AddEventHandler('pepe-diving:client:UpdateCoral', function(Area, Coral, Bool)
    QBDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
end)

function CallCops()
    local Call = math.random(1, 3)
    local Chance = math.random(1, 3)
    local Ped = GetPlayerPed(-1)
    local Coords = GetEntityCoords(Ped)

    if Call == Chance then
        TriggerServerEvent('pepe-diving:server:CallCops', Coords)
    end
end

RegisterNetEvent('pepe-diving:server:CallCops')
AddEventHandler('pepe-diving:server:CallCops', function(Coords, msg)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "112-MELDING", "error", msg)
    local transG = 100
    local blip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, 100.0)
    SetBlipSprite(blip, 9)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, transG)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("112 - Khu vực lặn")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end

RegisterNetEvent('pepe-diving:client:UseGear')
AddEventHandler('pepe-diving:client:UseGear', function(bool)
    if bool then
        TriggerServerEvent('pepe-diving:server:RemoveGear')
        GearAnim()
        Framework.Functions.Progressbar("equip_gear", "Mặc bộ đồ lặn...", 5000, false, true, {}, {}, {}, {}, function() -- Done
            DeleteGear()
            local maskModel = GetHashKey("p_d_scuba_mask_s")
            local tankModel = GetHashKey("p_s_scuba_tank_s")
    
            RequestModel(tankModel)
            while not HasModelLoaded(tankModel) do
                Citizen.Wait(1)
            end
            TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone1 = GetPedBoneIndex(GetPlayerPed(-1), 24818)
            AttachEntityToEntity(TankObject, GetPlayerPed(-1), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.tank = TankObject
    
            RequestModel(maskModel)
            while not HasModelLoaded(maskModel) do
                Citizen.Wait(1)
            end
            
            MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone2 = GetPedBoneIndex(GetPlayerPed(-1), 12844)
            AttachEntityToEntity(MaskObject, GetPlayerPed(-1), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.mask = MaskObject
            SetEnableScuba(GetPlayerPed(-1), true)
            SetPedMaxTimeUnderwater(GetPlayerPed(-1), Config.DivingMaxTimeUnderWater)
            currentGear.enabled = true
            print(json.encode(currentGear.enabled))
            ClearPedTasks(GetPlayerPed(-1))
            TriggerEvent('chatMessage', "SYSTEM", "error", "/coidolan để cởi bộ đồ lặn của bạn!")
            TriggerServerEvent("Framework:Server:SetMetaData", "diving_gear", true)
        end)
    else
        if currentGear.enabled then
            GearAnim()
            Framework.Functions.Progressbar("remove_gear", "Đang cởi đồ lặn..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                DeleteGear()
                SetEnableScuba(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), Config.NoDivingGearUnderWater)
                currentGear.enabled = false
                TriggerServerEvent('pepe-diving:server:GiveBackGear')
                ClearPedTasks(GetPlayerPed(-1))
                Framework.Functions.Notify('Bạn đã cởi đồ lặn!')
                TriggerServerEvent("Framework:Server:SetMetaData", "diving_gear", false)
            end)
        else
            Framework.Functions.Notify('Bạn không có đồ lặn..', 'error')
        end
    end
end)

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function GetDivingTime()
    return math.floor(GetPlayerUnderwaterTimeRemaining(PlayerId()) / (currentGear.enabled and Config.DivingMaxTimeUnderWater or Config.NoDivingGearUnderWater) * 100)
end