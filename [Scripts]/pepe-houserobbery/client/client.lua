local HouseData, OffSets = nil, nil
local InsideHouse = false
local ShowingItems = false
local CurrentEvent = {}
local CurrentCops = 0
local CurrentHouse = nil
local LoggedIn = false
local Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)
        Citizen.Wait(250)
        Framework.Functions.TriggerCallback("pepe-houserobbery:server:get:config", function(ConfigData)
            Config = ConfigData
        end)
        LoggedIn = true
    end) 
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('pepe-police:SetCopCount')
AddEventHandler('pepe-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Code

RegisterNetEvent('pepe-houserobbery:client:set:door:status')
AddEventHandler('pepe-houserobbery:client:set:door:status', function(RobHouseId, bool)
    Config.HouseLocations[RobHouseId]['Opened'] = bool 
end)

RegisterNetEvent('pepe-houserobbery:client:set:locker:state')
AddEventHandler('pepe-houserobbery:client:set:locker:state', function(RobHouseId, LockerId, Type, bool)
    Config.HouseLocations[RobHouseId]['Lockers'][LockerId][Type] = bool 
end)

RegisterNetEvent('pepe-houserobbery:client:set:extra:state')
AddEventHandler('pepe-houserobbery:client:set:extra:state', function(RobHouseId, Id, bool)
    Config.HouseLocations[RobHouseId]['Extras'][Id]['Stolen'] = bool 
end)

RegisterNetEvent('pepe-houserobbery:server:reset:state')
AddEventHandler('pepe-houserobbery:server:reset:state', function(RobHouseId)
    Config.HouseLocations[RobHouseId]['Opened'] = bool 
    for k, v in pairs(Config.HouseLocations[RobHouseId]["Lockers"]) do
        v["Opened"] = false
        v["Busy"] = false
    end
    if Config.HouseLocations[RobHouseId]["Extras"] ~= nil then
        for k, v in pairs(Config.HouseLocations[RobHouseId]["Extras"]) do
            v['Stolen'] = false
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local ItemsNeeded = {[1] = {name = Framework.Shared.Items["toolkit"]["name"], image = Framework.Shared.Items["toolkit"]["image"]}, [2] = {name = Framework.Shared.Items["lockpick"]["name"], image = Framework.Shared.Items["lockpick"]["image"]}}
            NearRobHouse = false
            for k, v in pairs(Config.HouseLocations) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x ,PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 2.0 then 
                  NearRobHouse = true
                  CurrentHouse = k
                  if not ShowingItems and not v['Opened'] then
                    ShowingItems = true
                    TriggerEvent('pepe-inventory:client:requiredItems', ItemsNeeded, true)
                  end
                end
            end
            if not NearRobHouse then
                if ShowingItems then
                    ShowingItems = false
                    TriggerEvent('pepe-inventory:client:requiredItems', ItemsNeeded, false)
                end
                Citizen.Wait(1500)
                if not InsideHouse then
                    CurrentHouse = nil
                end
            end
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if CurrentHouse ~= nil then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                if not InsideHouse and Config.HouseLocations[CurrentHouse]['Opened'] then
                    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.HouseLocations[CurrentHouse]['Coords']['X'], Config.HouseLocations[CurrentHouse]['Coords']['Y'], Config.HouseLocations[CurrentHouse]['Coords']['Z'], true) < 3.0) then
                        DrawMarker(2, Config.HouseLocations[CurrentHouse]['Coords']['X'], Config.HouseLocations[CurrentHouse]['Coords']['Y'], Config.HouseLocations[CurrentHouse]['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.HouseLocations[CurrentHouse]['Coords']['X'], Config.HouseLocations[CurrentHouse]['Coords']['Y'], Config.HouseLocations[CurrentHouse]['Coords']['Z'], '~g~E~s~ - Đi vào bên trong')
                        if IsControlJustReleased(0, 38) then
                            EnterHouseRobbery()
                        end
                    end
                elseif InsideHouse then
                    if OffSets ~= nil then
                        if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.HouseLocations[CurrentHouse]['Coords']['X'] - OffSets.exit.x, Config.HouseLocations[CurrentHouse]['Coords']['Y'] - OffSets.exit.y, Config.HouseLocations[CurrentHouse]['Coords']['Z'] - OffSets.exit.z, true) < 1.4) then
                            DrawMarker(2, Config.HouseLocations[CurrentHouse]['Coords']['X'] - OffSets.exit.x, Config.HouseLocations[CurrentHouse]['Coords']['Y'] - OffSets.exit.y, Config.HouseLocations[CurrentHouse]['Coords']['Z'] - OffSets.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                            DrawText3D(Config.HouseLocations[CurrentHouse]['Coords']['X'] - OffSets.exit.x, Config.HouseLocations[CurrentHouse]['Coords']['Y'] - OffSets.exit.y, Config.HouseLocations[CurrentHouse]['Coords']['Z'] - OffSets.exit.z + 0.12, '~g~E~s~ - Rời đi')
                            if IsControlJustReleased(0, 38) then
                               LeaveHouseRobbery()
                            end
                        end
                        for k, v in pairs(Config.HouseLocations[CurrentHouse]['Lockers']) do
                            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true) < 1.5) then
                                local Text = '~g~E~s~ - Trộm'
                                if Config.HouseLocations[CurrentHouse]['Lockers'][k]['Busy'] then Text = '~o~Bận...' elseif Config.HouseLocations[CurrentHouse]['Lockers'][k]['Opened'] then Text = '~r~Trống...' end
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] + 0.15, Text)
                                DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                if IsControlJustReleased(0, 38) and not Config.HouseLocations[CurrentHouse]['Lockers'][k]['Opened'] and not Config.HouseLocations[CurrentHouse]['Lockers'][k]['Busy'] then
                                    Config.HouseLocations[CurrentHouse]['Lockers'][k]['Busy'] = true
                                    OpenLocker(k)
                                end
                            end
                        end
                        if Config.HouseLocations[CurrentHouse]['Extras'] ~= nil then
                            for k, v in pairs(Config.HouseLocations[CurrentHouse]['Extras']) do
                                if not v['Stolen'] then
                                    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true) < 1.7) then
                                        DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] + 0.15, '~g~E~s~ - Để ăn cắp')
                                        DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                        if IsControlJustReleased(0, 38) then
                                            Config.HouseLocations[CurrentHouse]['Extras'][k]['Stolen'] = true
                                            StealPropItem(k)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('pepe-items:client:use:lockpick')
AddEventHandler('pepe-items:client:use:lockpick', function(IsAdvanced)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
    if CurrentHouse ~= nil then
        
        local ClockTime = GetClockHours()
        if CurrentCops >= Config.CopsNeeded then
            if IsAdvanced then
                local PlayerData = Framework.Functions.GetPlayerData()
                Framework.Functions.TriggerCallback('pepe-houserobbery:server:get:cooldown', function(cooldown)
                    if cooldown > 0 then
                        local remainingseconds = (cooldown) / 1000
                        local hoursRemaining = math.floor(remainingseconds/3600)
                        local minutesRemaining = math.floor((remainingseconds - hoursRemaining * 3600)/60)
                        local secondsRemaining = math.floor((remainingseconds - hoursRemaining * 3600 - minutesRemaining * 60))
                        
                        local remainingTimeText = hoursRemaining.." giờ, "..minutesRemaining.." phút, "..secondsRemaining.." giây"
                        Framework.Functions.Notify("Bạn vừa thực hiện một vụ cướp trước đó, vui lòng chờ thêm 10 phút (còn "..remainingTimeText.." )", "error")
                        return
                    end

                    exports['pepe-lockpick']:OpenLockpickGame(function(Success)
                        if Success then
                            TriggerServerEvent("pepe-houserobbery:server:create:cooldown")
                            LockpickFinish(true)
                        else
                            if math.random(1,100) < 19 then
                                TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
                                TriggerServerEvent('pepe-police:server:CreateBloodDrop', GetEntityCoords(PlayerPedId()))
                                TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
                                Framework.Functions.Notify("Bạn bị khóa chọc vào tay.", "error")
                            end
                        end
                    end)
                end)
            else
                if HasItem then
                    local PlayerData = Framework.Functions.GetPlayerData()
                    Framework.Functions.TriggerCallback('pepe-houserobbery:server:get:cooldown', function(cooldown)
                        if cooldown > 0 then
                            local remainingseconds = (cooldown) / 1000
                            local hoursRemaining = math.floor(remainingseconds/3600)
                            local minutesRemaining = math.floor((remainingseconds - hoursRemaining * 3600)/60)
                            local secondsRemaining = math.floor((remainingseconds - hoursRemaining * 3600 - minutesRemaining * 60))
                            
                            local remainingTimeText = hoursRemaining.." giờ, "..minutesRemaining.." phút, "..secondsRemaining.." giây"
                            Framework.Functions.Notify("Bạn vừa thực hiện một vụ cướp trước đó, vui lòng chờ thêm (còn "..remainingTimeText.." )", "error")
                            return
                        end

                        exports['pepe-lockpick']:OpenLockpickGame(function(Success)
                            if Success then
                                TriggerServerEvent("pepe-houserobbery:server:create:cooldown")
                                LockpickFinish(true)
                            else
                                if math.random(1,100) <= 35 then
                                TriggerServerEvent('Framework:Server:RemoveItem', 'lockpick', 1)
                                TriggerServerEvent('pepe-police:server:CreateBloodDrop', GetEntityCoords(PlayerPedId()))
                                TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['lockpick'], "remove")
                                Framework.Functions.Notify("Bạn bị khóa chọc vào tay.", "error")
                                end
                            end
                        end)
                    end)
                else
                    Framework.Functions.Notify("Bạn thiếu dụng cụ.", "error")
                end
             end
         else
             Framework.Functions.Notify("Không đủ cảnh sát ( Cần"..Config.CopsNeeded.." )", "info")
         end
     end
   end, "toolkit")
 end)
 


function LockpickFinish(Success)
 if Success then
   local Time = math.random(13000, 17000)
   LockpickAnim(Time)
   Framework.Functions.Progressbar("lockpick-door", "Đang phá khoá...", Time, false, true, {
       disableMovement = true,
       disableCarMovement = true,
       disableMouse = false,
       disableCombat = true,
   }, {}, {}, {}, function() -- Done    
       TriggerServerEvent('pepe-houserobbery:server:set:door:status', CurrentHouse, true)
       EnterHouseRobbery()
       StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
   end, function() -- Cancel
       StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
   end)
 else
    Framework.Functions.Notify("Bạn đã thất bại..", "error")
 end
end

function EnterHouseRobbery()
    local HouseInterior = {}
    local CoordsTable = {x = Config.HouseLocations[CurrentHouse]['Coords']['X'], y = Config.HouseLocations[CurrentHouse]['Coords']['Y'], z = Config.HouseLocations[CurrentHouse]['Coords']['Z'] - Config.ZOffSet}
    TriggerEvent("pepe-sound:client:play", "house-door-open", 0.1)
    OpenDoorAnim()
    InsideHouse = true
    Citizen.Wait(350)
    -- if math.random(1, 100) <= 36 then
        local StreetLabel = Framework.Functions.GetStreetLabel()
        TriggerServerEvent('pepe-police:server:send:house:alert', GetEntityCoords(PlayerPedId()), StreetLabel)
    -- end
    if Config.HouseLocations[CurrentHouse]['Tier'] == 1 then
        HouseInterior = exports['pepe-interiors']:HouseRobTierOne(CoordsTable)
    elseif Config.HouseLocations[CurrentHouse]['Tier'] == 2 then
        HouseInterior = exports['pepe-interiors']:HouseRobTierOne(CoordsTable)
    else
        HouseInterior = exports['pepe-interiors']:HouseRobTierThree(CoordsTable)
    end
    TriggerEvent('pepe-weathersync:client:DisableSync')
    TriggerEvent("pepe-sound:client:play", "house-door-close", 0.1)
    HouseData, OffSets = HouseInterior[1], HouseInterior[2]
    if Config.HouseLocations[CurrentHouse]['HasDog'] ~= nil and Config.HouseLocations[CurrentHouse]['HasDog'] then
        exports['pepe-assets']:RequestModelHash("A_C_Rottweiler")
        SupriseEvent = CreatePed(GetPedType(GetHashKey("A_C_Rottweiler")), GetHashKey("A_C_Rottweiler"), Config.HouseLocations[CurrentHouse]['Dog']['X'], Config.HouseLocations[CurrentHouse]['Dog']['Y'], Config.HouseLocations[CurrentHouse]['Dog']['Z'], 90, 1, 0)
        TaskCombatPed(SupriseEvent, PlayerPedId(), 0, 16)
        SetPedKeepTask(SupriseEvent, true)
        SetEntityAsNoLongerNeeded(SupriseEvent)
        table.insert(CurrentEvent, SupriseEvent)
    end

    Citizen.SetTimeout(120000, function()
        if HouseData ~= nil then
            LeaveHouseRobbery()
        end
        
    end)
end

function LeaveHouseRobbery()
    TriggerEvent("pepe-sound:client:play", "house-door-open", 0.1)
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['pepe-interiors']:DespawnInterior(HouseData, function()
      SetEntityCoords(PlayerPedId(), Config.HouseLocations[CurrentHouse]['Coords']['X'], Config.HouseLocations[CurrentHouse]['Coords']['Y'], Config.HouseLocations[CurrentHouse]['Coords']['Z'])
      TriggerEvent('pepe-weathersync:client:EnableSync')
      DoScreenFadeIn(1000)
      CurrentHouse = nil
      HouseData, OffSets = nil, nil
      InsideHouse = false
      TriggerEvent("pepe-sound:client:play", "house-door-close", 0.1)
      if CurrentEvent ~= nil then
        for k, v in pairs(CurrentEvent) do 
            DeleteEntity(v)
        end
        CurrentEvent = {}
      end
    end)
end

function StealPropItem(Id)
   local StealObject = GetClosestObjectOfType(Config.HouseLocations[CurrentHouse]['Extras'][Id]['Coords']['X'], Config.HouseLocations[CurrentHouse]['Extras'][Id]['Coords']['Y'], Config.HouseLocations[CurrentHouse]['Extras'][Id]['Coords']['Z'], 5.0, GetHashKey(Config.HouseLocations[CurrentHouse]['Extras'][Id]['PropName']), false, false, false)
   NetworkRequestControlOfEntity(StealObject)
   DeleteEntity(StealObject)
   TriggerServerEvent('pepe-houserobbery:server:recieve:extra', CurrentHouse, Id)
end

function OpenLocker(LockerId)
  local Time = math.random(15000, 18000)
  if not IsWearingHandshoes() then
    TriggerServerEvent("pepe-police:server:CreateFingerDrop", GetEntityCoords(PlayerPedId()))
  end
  LockpickAnim(Time)
  TriggerServerEvent('pepe-houserobbery:server:set:locker:state', CurrentHouse, LockerId, 'Busy', true)
  Framework.Functions.Progressbar("lockpick-locker", "Tìm kiếm...", Time, false, true, {
    disableMovement = true,
    disableCarMovement = true,
    disableMouse = false,
    disableCombat = true,
    }, {}, {}, {}, function() -- Done    
      TriggerServerEvent('pepe-houserobbery:server:locker:reward', math.random(1,3))
      TriggerServerEvent('pepe-houserobbery:server:set:locker:state', CurrentHouse, LockerId, 'Busy', false)
      TriggerServerEvent('pepe-houserobbery:server:set:locker:state', CurrentHouse, LockerId, 'Opened', true)
      StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
    end, function() -- Cancel
      OpeningSomething = false
      TriggerServerEvent('pepe-houserobbery:server:set:locker:state', CurrentHouse, LockerId, 'Busy', false)
      StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
  end)
end

function LockpickAnim(time)
  time = time / 1000
  exports['pepe-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
  TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
  OpeningSomething = true
  Citizen.CreateThread(function()
      while OpeningSomething do
          TriggerServerEvent('pepe-hud:server:gain:stress', 1)
          TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
          Citizen.Wait(2000)
          time = time - 2
          if time <= 0 then
              OpeningSomething = false
              StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
          end
      end
  end)
end

function OpenDoorAnim()
 exports['pepe-assets']:RequestAnimationDict('anim@heists@keycard@')
 TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
 Citizen.Wait(400)
 ClearPedTasks(PlayerPedId())
end

function IsWearingHandshoes()
  local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
  local model = GetEntityModel(PlayerPedId())
  local retval = true
  if model == GetHashKey("mp_m_freemode_01") then
      if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
          retval = false
      end
  else
      if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
          retval = false
      end
  end
  return retval
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end