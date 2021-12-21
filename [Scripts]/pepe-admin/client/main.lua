local myPermissionRank = nil

Framework = nil

-- Code

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     TriggerServerEvent("pepe-admin:server:loadPermissions")
     isLoggedIn = true
 end)
end)

RegisterNetEvent('pepe-admin:client:openMenu')
AddEventHandler('pepe-admin:client:openMenu', function(group)
 WarMenu.OpenMenu('admin')
 myPermissionRank = group
end)

Admin = {}
Admin.Functions = {}
in_noclip_mode = false
local isNoclip = false
local isFreeze = false
local isSpectating = false
local showNames = false
local showBlips = false
local isInvisible = false
local deleteLazer = false
local hasGodmode = false
local hasDev = false
local lastSpectateCoord = nil
local NoclipDev = true
local currentPlayerMenu = nil
local currentPlayer = 0
local currentBanIndex = 1
local selectedBanIndex = 1
local currentPermIndex = 1
local selectedPermIndex = 1

local Actions = {
 'Kick',
 'Ban',
}

local Action = {
 'Kick',
 'Ban',
}

local menus = {
 "admin",
 "playerMan",
 "serverMan",
 currentPlayer,
 "playerOptions",
 "teleportOptions",
 "permissionOptions",
 "weatherOptions",
 "adminOptions",
 "adminOpt",
 "selfOptions",
 "polyzone",
}

local times = {
 "00:00",
 "01:00",
 "02:00",
 "03:00",
 "04:00",
 "05:00",
 "06:00",
 "07:00",
 "08:00",
 "09:00",
 "10:00",
 "11:00",
 "12:00",
 "13:00",
 "14:00",
 "15:00",
 "16:00",
 "17:00",
 "18:00",
 "19:00",
 "20:00",
 "21:00",
 "22:00",
 "23:00",
}

local ServerTimes = {
    [1] = {hour = 0, minute = 0},
    [2] = {hour = 1, minute = 0},
    [3] = {hour = 2, minute = 0},
    [4] = {hour = 3, minute = 0},
    [5] = {hour = 4, minute = 0},
    [6] = {hour = 5, minute = 0},
    [7] = {hour = 6, minute = 0},
    [8] = {hour = 7, minute = 0},
    [9] = {hour = 8, minute = 0},
    [10] = {hour = 9, minute = 0},
    [11] = {hour = 10, minute = 0},
    [12] = {hour = 11, minute = 0},
    [13] = {hour = 12, minute = 0},
    [14] = {hour = 13, minute = 0},
    [15] = {hour = 14, minute = 0},
    [16] = {hour = 15, minute = 0},
    [17] = {hour = 16, minute = 0},
    [18] = {hour = 17, minute = 0},
    [19] = {hour = 18, minute = 0},
    [20] = {hour = 19, minute = 0},
    [21] = {hour = 20, minute = 0},
    [22] = {hour = 21, minute = 0},
    [23] = {hour = 22, minute = 0},
    [24] = {hour = 23, minute = 0},
}

local perms = {
 "User",
 "Admin",
 "God"
}

local AvailableWeatherTypes = {
 {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
 {label = "Clear",               weather = 'CLEAR',}, 
 {label = "Neutral",             weather = 'NEUTRAL',}, 
 {label = "Smog",                weather = 'SMOG',}, 
 {label = "Foggy",               weather = 'FOGGY',}, 
 {label = "Overcast",            weather = 'OVERCAST',}, 
 {label = "Clouds",              weather = 'CLOUDS',}, 
 {label = "Clearing",            weather = 'CLEARING',}, 
 {label = "Rain",                weather = 'RAIN',}, 
 {label = "Thunder",             weather = 'THUNDER',}, 
 {label = "Snow",                weather = 'SNOW',}, 
 {label = "Blizzard",            weather = 'BLIZZARD',}, 
 {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
 {label = "XMAS (Heavy Snow)",   weather = 'XMAS',}, 
 {label = "Halloween (Scarry)",  weather = 'HALLOWEEN',},
}

local PermissionLevels = {
 [1] = {rank = "user", label = "User"},
 [2] = {rank = "admin", label = "Admin"},
 [3] = {rank = "god", label = "God"},
}

Citizen.CreateThread(function()
RegisterFontFile('arial')
WarMenu.CreateMenu('admin', '~b~Admin Menu')
WarMenu.CreateSubMenu('playerMan', 'admin')
WarMenu.CreateSubMenu('serverMan', 'admin')
WarMenu.CreateSubMenu('adminOpt', 'admin')
WarMenu.CreateSubMenu('selfOptions', 'adminOpt')
--WarMenu.CreateSubMenu('polyzone', 'serverMan')
WarMenu.CreateSubMenu('weatherOptions', 'serverMan')
for k, v in pairs(menus) do
    WarMenu.SetMenuX(v, 0.71)
    WarMenu.SetMenuY(v, 0.15)
    WarMenu.SetMenuWidth(v, 0.23)
    WarMenu.SetTitleColor(v, 255, 255, 255, 255)
    WarMenu.SetTitleBackgroundColor(v, 0, 0, 0, 111)
end
while true do
    if WarMenu.IsMenuOpened('admin') then
        WarMenu.MenuButton('Quản lý Admin', 'adminOpt')
        WarMenu.MenuButton('Quản lý người chơi', 'playerMan')
        WarMenu.MenuButton('Quản lý server', 'serverMan')
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('adminOpt') then
        WarMenu.MenuButton('Tùy chọn người chơi (~g~'..GetPlayerName(PlayerId())..'~s~)', 'selfOptions')
        WarMenu.CheckBox("Hiện tên người chơi", showNames, function(checked) showNames = checked end)
         if WarMenu.CheckBox("Hiện trên map", showBlips, function(checked) showBlips = checked end) then
             toggleBlips()
         end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('selfOptions') then
        if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
            local target = PlayerId()
            local targetId = GetPlayerServerId(target)
            TriggerServerEvent("pepe-admin:server:togglePlayerNoclip", targetId)
        end
        if WarMenu.Button('Revive') then
            local target = PlayerId()
            local targetId = GetPlayerServerId(target)
            TriggerEvent('pepe-hospital:client:revive')
        end
        if WarMenu.CheckBox("Vô hình", isInvisible, function(checked) isInvisible = checked end) then
            local myPed = GetPlayerPed(-1)
            
            if isInvisible then
                SetEntityVisible(myPed, false, false)
            else
                SetEntityVisible(myPed, true, false)
            end
        end
        if WarMenu.CheckBox("Godmode", hasGodmode, function(checked) hasGodmode = checked end) then
            local myPlayer = PlayerId()
            
            SetPlayerInvincible(myPlayer, hasGodmode)
        end
        if WarMenu.CheckBox("Chế độ nhà phát triển", hasDev, function(checked) hasDev = checked end) then
            local myPlayer = PlayerId()
            ToggleDev(hasDev)
        end
        if WarMenu.CheckBox("Súng Laze phá hủy", deleteLazer, function(checked) deleteLazer = checked end) then
        end
        
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('playerMan') then
        local players = getPlayers()
        for k, v in pairs(players) do
            WarMenu.CreateSubMenu(v["id"], 'playerMan', v["serverid"].." | "..v["name"])
        end
        if WarMenu.MenuButton('#'..GetPlayerServerId(PlayerId()).." | "..GetPlayerName(PlayerId()), PlayerId()) then
            currentPlayer = PlayerId()
            if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                currentPlayerMenu = 'playerOptions'
            elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                currentPlayerMenu = 'teleportOptions'
            elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                currentPlayerMenu = 'adminOptions'
            end
            if myPermissionRank == "god" then
                if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                    currentPlayerMenu = 'permissionOptions'
                end
            end
        end
        for k, v in pairs(players) do
            if v["id"] ~= PlayerId() then
                if WarMenu.MenuButton('#'..v["serverid"].." | "..v["name"], v["id"]) then
                    currentPlayer = v["id"]
                    if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                        currentPlayerMenu = 'playerOptions'
                    elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                        currentPlayerMenu = 'teleportOptions'
                    elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                        currentPlayerMenu = 'adminOptions'
                    end
                end
            end
        end
        if myPermissionRank == "god" then
            if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                currentPlayerMenu = 'permissionOptions'
            end
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('serverMan') then
        WarMenu.MenuButton('Thời tiết', 'weatherOptions')
        WarMenu.MenuButton('Polyzones', 'polyzone')
        if WarMenu.ComboBox('Server Tijd', times, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
            currentBanIndex = currentIndex
            selectedBanIndex = selectedIndex
        end) then
            local time = ServerTimes[currentBanIndex]
            TriggerServerEvent("pepe-weathersync:server:setTime", time.hour, time.minute)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened(currentPlayer) then
        WarMenu.MenuButton('Tùy chọn người chơi (~g~'..GetPlayerName(currentPlayer)..'~s~)', 'playerOptions')
        WarMenu.MenuButton('Teleport', 'teleportOptions')
        WarMenu.MenuButton('Tùy chọn Admin', 'adminOptions')
        if myPermissionRank == "god" then
            WarMenu.MenuButton('Permission', 'permissionOptions')
        end
        
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('playerOptions') then
        if WarMenu.MenuButton('Kill', currentPlayer) then
            TriggerServerEvent("pepe-admin:server:killPlayer", GetPlayerServerId(currentPlayer))
        end
        if WarMenu.MenuButton('Revive', currentPlayer) then
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent('pepe-hospital:server:revive:player', target)
        end
        if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent("pepe-admin:server:togglePlayerNoclip", target)
        end
        if WarMenu.CheckBox("Freeze", isFreeze, function(checked) isFreeze = checked end) then
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent("pepe-admin:server:Freeze", target, isFreeze)
        end
         if WarMenu.CheckBox("Spectate", isSpectating, function(checked) isSpectating = checked end) then
             local target = GetPlayerFromServerId(GetPlayerServerId(currentPlayer))
             local targetPed = GetPlayerPed(target)
             local targetCoords = GetEntityCoords(targetPed)
             SpectatePlayer(targetPed, isSpectating)
         end
        if WarMenu.MenuButton("Open Inventory", currentPlayer) then
            local targetId = GetPlayerServerId(currentPlayer)
            OpenTargetInventory(targetId)
        end
        if WarMenu.MenuButton("Geef Kleding Menu", currentPlayer) then
            local targetId = GetPlayerServerId(currentPlayer)
            TriggerServerEvent('pepe-admin:server:OpenSkinMenu', targetId)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('teleportOptions') then
        if WarMenu.MenuButton('Teleport đến người chơi', currentPlayer) then
            local target = GetPlayerPed(currentPlayer)
            local ply = GetPlayerPed(-1)
            if in_noclip_mode then
                turnNoClipOff()
                SetEntityCoords(ply, GetEntityCoords(target))
                turnNoClipOn()
            else
                SetEntityCoords(ply, GetEntityCoords(target))
            end
        end
        if WarMenu.MenuButton('Teleport người chơi', currentPlayer) then
            local target = GetPlayerPed(currentPlayer)
            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
            TriggerServerEvent('pepe-admin:server:bringTp', GetPlayerServerId(currentPlayer), plyCoords)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('permissionOptions') then
        if WarMenu.ComboBox('Permission Group', perms, currentPermIndex, selectedPermIndex, function(currentIndex, selectedIndex)
            currentPermIndex = currentIndex
            selectedPermIndex = selectedIndex
        end) then
            local group = PermissionLevels[currentPermIndex]
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent('pepe-admin:server:setPermissions', target, group)
            Framework.Functions.Notify('Je hebt '..GetPlayerName(currentPlayer)..'\'s groep is veranderd naar '..group.label)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('adminOptions') then
        if WarMenu.ComboBox('Server Actie', Actions, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
            currentBanIndex = currentIndex
            selectedBanIndex = selectedIndex
        end) then
            local Action = Actions[currentBanIndex]
            if Action == 'Ban' then
                DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 128 + 1)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(7)
                end
                local Reden = GetOnscreenKeyboardResult()
                if Reden ~= nil and Reden ~= "" then
                    local Target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent('pepe-admin:server:banPlayer', Target, Reden)
                end
            elseif Action == 'Kick' then
                DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 128 + 1)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(7)
                end
                local Reden = GetOnscreenKeyboardResult()
                if Reden ~= nil and Reden ~= "" then
                    local Target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent('pepe-admin:server:kickPlayer', Target, Reden)
                end
            end
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('polyzone') then
            if WarMenu.MenuButton('Create Poly Zone', 'polyzone') then
            end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('weatherOptions') then
        for k, v in pairs(AvailableWeatherTypes) do
            if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'weatherOptions') then
                TriggerServerEvent('pepe-weathersync:server:setWeather', AvailableWeatherTypes[k].weather)
                Framework.Functions.Notify('Thời tiết đã thay đổi thành: '..AvailableWeatherTypes[k].label)
            end
        end
        WarMenu.Display()
    end
    Citizen.Wait(3)
    end
end)

-- // Troep \\ --

function SpectatePlayer(targetPed, toggle)
    local myPed = GetPlayerPed(-1)
    if toggle then
        showNames = true
        SetEntityVisible(myPed, false)
        SetEntityInvincible(myPed, true)
        lastSpectateCoord = GetEntityCoords(myPed)
        DoScreenFadeOut(150)
        SetTimeout(250, function()
            SetEntityVisible(myPed, false)
            SetEntityCoords(myPed, GetOffsetFromEntityInWorldCoords(targetPed, 0.0, 0.45, 0.0))
            AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -1.3, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            SetEntityVisible(myPed, false)
            SetEntityInvincible(myPed, true)
            DoScreenFadeIn(150)
        end)
    else
        showNames = false
        DoScreenFadeOut(150)
        DetachEntity(myPed, true, false)
        SetTimeout(250, function()
            SetEntityCoords(myPed, lastSpectateCoord)
            SetEntityVisible(myPed, true)
            SetEntityInvincible(myPed, false)
            DoScreenFadeIn(150)
            lastSpectateCoord = nil
        end)
    end
end

function OpenTargetInventory(targetId)
 WarMenu.CloseMenu()
 TriggerServerEvent("pepe-inventory:server:OpenInventory", "otherplayer", targetId)
end

Citizen.CreateThread(function()
while true do
    if showNames then
        for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 5.0)) do
            local PlayerId = GetPlayerServerId(player)
            local PlayerPed = GetPlayerPed(player)
            local PlayerName = GetPlayerName(player)
            local PlayerCoords = GetEntityCoords(PlayerPed)
            DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '[~g~'..PlayerId..'~s~] '..PlayerName)
        end
    else
        Citizen.Wait(1000)
    end
    Citizen.Wait(3)
    end
end)

local PlayerBlips = {}

function toggleBlips()
 Citizen.CreateThread(function()
     -- while true do 
         if showBlips then
             local Players = getPlayers() 
             for k, v in pairs(Players) do
                 local PlayerPed = v["ped"]
                 local playerName = v["name"] 
                 RemoveBlip(PlayerBlips[k]) 
                 local PlayerBlip = AddBlipForEntity(PlayerPed) 
                 SetBlipSprite(PlayerBlip, 1)
                 SetBlipColour(PlayerBlip, 0)
                 SetBlipScale  (PlayerBlip, 0.75)
                 SetBlipAsShortRange(PlayerBlip, true)
                 BeginTextCommandSetBlipName("STRING")
                 AddTextComponentString('['..v["serverid"]..'] '..playerName)
                 EndTextCommandSetBlipName(PlayerBlip)
                 PlayerBlips[k] = PlayerBlip
             end
         else
             if next(PlayerBlips) ~= nil then
                 for k, v in pairs(PlayerBlips) do
                     RemoveBlip(PlayerBlips[k])
                 end
                 PlayerBlips = {}
             end
             Citizen.Wait(1000)
         end
 end)
end

Citizen.CreateThread(function()
 while true do
     if showBlips then
         if next(PlayerBlips) ~= nil then
             for k, v in pairs(PlayerBlips) do
                 RemoveBlip(PlayerBlips[k])
             end
             PlayerBlips = {}
         end
         local Players = getPlayers()
         for k, v in pairs(Players) do
             local PlayerPed = v["ped"]
             local playerName = v["name"] 
             RemoveBlip(PlayerBlips[k]) 
             local PlayerBlip = AddBlipForEntity(PlayerPed) 
             SetBlipSprite(PlayerBlip, 1)
             SetBlipColour(PlayerBlip, 0)
             SetBlipScale  (PlayerBlip, 0.75)
             SetBlipAsShortRange(PlayerBlip, true)
             BeginTextCommandSetBlipName("STRING")
             AddTextComponentString('['..v["serverid"]..'] '..playerName)
             EndTextCommandSetBlipName(PlayerBlip)
             PlayerBlips[k] = PlayerBlip
         end 
         print('blip updated!')
     else
         if next(PlayerBlips) ~= nil then
             for k, v in pairs(PlayerBlips) do
                 RemoveBlip(PlayerBlips[k])
             end
             PlayerBlips = {}
         end
     end 
     Citizen.Wait(30000)
 end
end)

Citizen.CreateThread(function()	
 while true do
 	Citizen.Wait(0) 
     if deleteLazer then
         local color = {r = 255, g = 255, b = 255, a = 200}
         local position = GetEntityCoords(GetPlayerPed(-1))
         local hit, coords, entity = RayCastGamePlayCamera(1000.0)
         
         -- If entity is found then verifie entity
         if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
             local entityCoord = GetEntityCoords(entity)
             local minimum, maximum = GetModelDimensions(GetEntityModel(entity))
             
             DrawEntityBoundingBox(entity, color)
             DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
             DrawText3D(entityCoord.x, entityCoord.y, entityCoord.z, "Obj: " .. entity .. " Model: " .. GetEntityModel(entity).. " \nDruk [~g~E~s~] để xóa vật thể!", 2) 
             -- When E pressed then remove targeted entity
             if IsControlJustReleased(0, 38) then
                 -- Set as missionEntity so the object can be remove (Even map objects)
                 SetEntityAsMissionEntity(entity, true, true)
                 SetEntityAsNoLongerNeeded(entity)
                 DeleteEntity(entity)
             end
         -- Only draw of not center of map
         elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
             -- Draws line to targeted position
             DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
             DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
         end
     else
         Citizen.Wait(1000)
     end
 end
end)

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
 local model = GetEntityModel(entity)
 local min, max = GetModelDimensions(model)
 local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity) 
 -- Calculate size
 local dim = 
 { 
 	x = 0.5*(max.x - min.x), 
 	y = 0.5*(max.y - min.y), 
 	z = 0.5*(max.z - min.z)
 } 
 local FUR = 
 {
 	x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
 	y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
 	z = 0
 } 
 local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
 FUR.z = FUR_z
 FUR.z = FUR.z + 2 * dim.z 
 local BLL = 
 {
     x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
     y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
     z = 0
 }
 local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
 BLL.z = BLL_z 
 -- DEBUG
 local edge1 = BLL
 local edge5 = FUR 
 local edge2 = 
 {
     x = edge1.x + 2 * dim.y*rightVector.x,
     y = edge1.y + 2 * dim.y*rightVector.y,
     z = edge1.z + 2 * dim.y*rightVector.z
 } 
 local edge3 = 
 {
     x = edge2.x + 2 * dim.z*upVector.x,
     y = edge2.y + 2 * dim.z*upVector.y,
     z = edge2.z + 2 * dim.z*upVector.z
 } 
 local edge4 = 
 {
     x = edge1.x + 2 * dim.z*upVector.x,
     y = edge1.y + 2 * dim.z*upVector.y,
     z = edge1.z + 2 * dim.z*upVector.z
 } 
 local edge6 = 
 {
     x = edge5.x - 2 * dim.y*rightVector.x,
     y = edge5.y - 2 * dim.y*rightVector.y,
     z = edge5.z - 2 * dim.y*rightVector.z
 } 
 local edge7 = 
 {
     x = edge6.x - 2 * dim.z*upVector.x,
     y = edge6.y - 2 * dim.z*upVector.y,
     z = edge6.z - 2 * dim.z*upVector.z
 } 
 local edge8 = 
 {
     x = edge5.x - 2 * dim.z*upVector.x,
     y = edge5.y - 2 * dim.z*upVector.y,
     z = edge5.z - 2 * dim.z*upVector.z
 } 
 DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
 DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
 DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
 DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
 DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
 DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
 DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
 DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
 DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
 DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
 DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
 DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

-- Embed direction in rotation vector
function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

-- Raycast function for "Admin Lazer"
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

RegisterNetEvent('pepe-admin:client:bringTp')
AddEventHandler('pepe-admin:client:bringTp', function(coords)
    local ped = GetPlayerPed(-1)
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('pepe-admin:client:Freeze')
AddEventHandler('pepe-admin:client:Freeze', function(toggle)
    local ped = GetPlayerPed(-1)

    local veh = GetVehiclePedIsIn(ped)

    if veh ~= 0 then
        FreezeEntityPosition(ped, toggle)
        FreezeEntityPosition(veh, toggle)
    else
        FreezeEntityPosition(ped, toggle)
    end
end)

RegisterNetEvent('pepe-admin:client:SendReport')
AddEventHandler('pepe-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('pepe-admin:server:SendReport', name, src, msg)
end)

RegisterNetEvent('pepe-admin:client:SendStaffChat')
AddEventHandler('pepe-admin:client:SendStaffChat', function(name, msg)
    TriggerServerEvent('pepe-admin:server:StaffChatMessage', name, msg)
end)

RegisterNetEvent('pepe-admin:client:SetWeaponAmmoManual')
AddEventHandler('pepe-admin:client:SetWeaponAmmoManual', function(ammo)
    local ped = GetPlayerPed(-1)
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            SetPedAmmo(ped, weapon, tonumber(ammo))
            Framework.Functions.Notify('+' ..tonumber(ammo).. ' đạn cho súng '..Framework.Shared.Weapons[weapon]["label"], 'success')
        else
            Framework.Functions.Notify('Bạn không cầm vũ khí..', 'error')
        end
end)

RegisterNetEvent('pepe-admin:client:SaveCar')
AddEventHandler('pepe-admin:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        local model = GetEntityModel(veh)
        local displaytext = GetDisplayNameFromVehicleModel(model)
        local name = string.lower(GetLabelText(displaytext))
        local props = Framework.Functions.GetVehicleProperties(veh)
        --local hash = props.model
        --if Framework.Shared.Vehicles[hash] ~= nil and next(Framework.Shared.Vehicles[hash]) ~= nil then
        --if Framework.Shared.VehicleModels[hash] ~= nil and next(Framework.Shared.VehicleModels[hash]) ~= nil then
            TriggerServerEvent('pepe-admin:server:SaveCar', props, displaytext, GetHashKey(veh), plate)
        --else
        --    Framework.Functions.Notify('You cannot put this vehicle in your garage..', 'error')
        --end
    else
        Framework.Functions.Notify('Bạn không ở trong chiếc xe nào!', 'error')
    end
end)

RegisterNetEvent('pepe-admin:client:SetModel')
AddEventHandler('pepe-admin:client:SetModel', function(skin)
    local ped = PlayerPedId()
    local model = GetHashKey(skin)
    SetEntityInvincible(ped, true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        LoadPlayerModel(model)
        SetPlayerModel(PlayerId(), model)

        if isPedAllowedRandom() then
            SetPedRandomComponentVariation(ped, true)
        end
        
		SetModelAsNoLongerNeeded(model)
	end
	SetEntityInvincible(ped, false)
end)

function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
        
        Citizen.Wait(0)
    end
end

local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
    "tony",
    "g_m_m_chigoon_02_m",
    "u_m_m_jesus_01",
    "a_m_y_stbla_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_skater_m",
    "u_m_y_coop",
    "ig_car3guy1_m",
}

function isPedAllowedRandom(skin)
    local retval = false
    for k, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

function ToggleDev(status)
    local myPlayer = PlayerId()
    if status then
        TriggerEvent('ec-hud:clinet:set:mode', status)
        SetPlayerInvincible(myPlayer, status)
        TriggerServerEvent('pepe-admin:server:debugtool')
        Framework.Functions.Notify('Chế độ phát triển đang bật', 'success')
    else
        TriggerEvent('ec-hud:clinet:set:mode', status)
        SetPlayerInvincible(myPlayer, status)
        TriggerServerEvent('pepe-admin:server:debugtool')
        Framework.Functions.Notify('Chế độ phát triển đang tắt', 'error')
    end
end

DrawText3D = function(x, y, z, text, lines)
    if lines == nil then
        lines = 1
    end
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125 * lines, 0.017+ factor, 0.03 * lines, 0, 0, 0, 75)
    ClearDrawOrigin()
end

GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

GetPlayersFromCoords = function(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}
    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    return closePlayers
end

function getPlayers()
    players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, {
            ['ped'] = GetPlayerPed(player),
            ['name'] = GetPlayerName(player),
            ['id'] = player,
            ['serverid'] = GetPlayerServerId(player),
        })
    end
    return players
end

Citizen.CreateThread(function()
local Id = GetPlayerServerId(PlayerId())
while true do
    Citizen.Wait(1)
    if hasDev == true then
        if IsControlJustPressed(0, 27) then
            TriggerServerEvent("pepe-admin:server:togglePlayerNoclip", Id)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if isSpectating and IsEntityVisible(GetPlayerPed(-1)) == 1 then
        SetEntityVisible(GetPlayerPed(-1), false, false)
        end
    end
end)

RegisterNetEvent('pepe-admin:client:bring:to')
AddEventHandler('pepe-admin:client:bring:to', function(targetId)
    coords = GetEntityCoords(GetPlayerPed(-1))
    TriggerServerEvent('pepe-admin:server:bringTp', targetId, coords)
end)

RegisterNetEvent('pepe-houserobbery:client:cc')
AddEventHandler('pepe-houserobbery:client:cc', function()
    HouseLocations = {
        [1] = {
          ['Label'] = 'Huis 2',
          ['Opened'] = false,
          ['Tier'] = 3,
          ['Coords'] = {
            ['X'] = -971.57,
            ['Y'] = 122.15,
            ['Z'] = 57.04,
          },
          ['Extras'] = {
            [1] = {
              ['Stolen'] = false,
              ['Item'] = 'stolen-tv',
              ['PropName'] = 'apa_mp_h_str_avunits_01',
              ['Coords'] = {
                ['X'] = -973.08,
                ['Y'] = 111.16,
                ['Z'] = 16.88,
              }
            },
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = -979.36,
               ['Y'] = 121.15,
               ['Z'] = 20.79,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -969.13,
                ['Y'] = 116.35,
                ['Z'] = 20.78,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -967.44,
                ['Y'] = 119.85,
                ['Z'] = 20.78,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -976.61,
                ['Y'] = 126.45,
                ['Z'] = 20.78,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -980.98,
                ['Y'] = 127.14,
                ['Z'] = 20.79,
              },
             },
             [6] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -976.38,
                ['Y'] = 111.08,
                ['Z'] = 20.78,
              },
             },
             [7] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -979.47,
                ['Y'] = 123.33,
                ['Z'] = 16.20,
              },
             },
             [8] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -971.70,
                ['Y'] = 119.93,
                ['Z'] = 16.88,
              },
             },
             [9] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -965.97,
                ['Y'] = 126.93,
                ['Z'] = 16.65,
              },
             },
           },
        },
        [2] = {
          ['Label'] = 'Huis 3',
          ['Opened'] = false,
          ['Tier'] = 3,
          ['Coords'] = {
            ['X'] = -913.20,
            ['Y'] = 108.18,
            ['Z'] = 55.51,
          },
          ['Extras'] = {
            [1] = {
              ['Stolen'] = false,
              ['Item'] = 'stolen-pc',
              ['PropName'] = 'prop_laptop_01a',
              ['Coords'] = {
                ['X'] = -921.09,
                ['Y'] = 106.94,
                ['Z'] = 19.26,
              }
            },
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = -921.03,
               ['Y'] = 109.31,
               ['Z'] = 14.67,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -914.79,
                ['Y'] = 97.13,
                ['Z'] = 14.35,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -903.39,
                ['Y'] = 113.02,
                ['Z'] = 14.12,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -911.85,
                ['Y'] = 97.18,
                ['Z'] = 19.25,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -918.14,
                ['Y'] = 105.87,
                ['Z'] = 19.25,
              },
             },
             [6] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -919.51,
                ['Y'] = 113.16,
                ['Z'] = 19.26,
              },
             },
             [7] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -923.42,
                ['Y'] = 105.99,
                ['Z'] = 19.25,
              },
             },
             [8] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -920.75,
                ['Y'] = 97.04,
                ['Z'] = 19.25,
              },
             },
             [9] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -919.99,
                ['Y'] = 103.50,
                ['Z'] = 19.25,
              },
             },
           },
        },
        [3] = {
          ['Label'] = 'Huis 4',
          ['Opened'] = false,
          ['HasDog'] = true,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = 996.98,
            ['Y'] = -729.49,
            ['Z'] = 57.81,
          },
          ['Dog'] = {
            ['X'] = 994.41,
            ['Y'] = -730.18,
            ['Z'] = 18.14,
          },
          ['Extras'] = {
            [1] = {
              ['Stolen'] = false,
              ['Item'] = 'stolen-tv',
              ['PropName'] = 'Prop_TV_Flat_01',
              ['Coords'] = {
                ['X'] = 992.30,
                ['Y'] = -729.58,
                ['Z'] = 18.14,
              }
            },
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = 1000.27,
               ['Y'] = -733.76,
               ['Z'] = 18.10,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1006.13,
                ['Y'] = -730.94,
                ['Z'] = 18.10,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1005.50,
                ['Y'] = -725.86,
                ['Z'] = 18.10,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 993.44,
                ['Y'] = -735.44,
                ['Z'] = 18.10,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 998.24,
                ['Y'] = -733.31,
                ['Z'] = 18.10,
              },
             },
             [6] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 993.77,
                ['Y'] = -728.10,
                ['Z'] = 18.10,
              },
             },
           },
        },
        [4] = {
          ['Label'] = 'Huis 5',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = 1090.47,
            ['Y'] = -484.44,
            ['Z'] = 65.66,
          },
          ['Extras'] = {
            [1] = {
              ['Stolen'] = false,
              ['Item'] = 'stolen-micro',
              ['PropName'] = 'prop_micro_01',
              ['Coords'] = {
                ['X'] = 1091.79,
                ['Y'] = -489.28,
                ['Z'] = 25.99,
              }
            },
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = 1093.77,
               ['Y'] = -488.74,
               ['Z'] = 25.95,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1098.90,
                ['Y'] = -486.36,
                ['Z'] = 25.95,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1096.87,
                ['Y'] = -481.86,
                ['Z'] = 25.95,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 993.44,
                ['Y'] = -735.44,
                ['Z'] = 25.10,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1086.95,
                ['Y'] = -490.37,
                ['Z'] = 25.95,
              },
             },
             [6] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1091.75,
                ['Y'] = -488.19,
                ['Z'] = 25.95,
              },
             },
           },
        },
      
        [5] = {
          ['Label'] = 'Huis 6',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = 171.57,
            ['Y'] = -1871.47,
            ['Z'] = 24.40,
          },
          ['Extras'] = {
            [1] = {
              ['Stolen'] = false,
              ['Item'] = 'stolen-tv',
              ['PropName'] = 'Prop_TV_Flat_01',
              ['Coords'] = {
                ['X'] = 166.88,
                ['Y'] = -1871.45,
                ['Z'] = -15.26,
              }
            },
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = 174.84,
               ['Y'] = -1875.78,
               ['Z'] = -15.30,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 167.99,
                ['Y'] = -1877.50,
                ['Z'] = -15.30,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 171.09,
                ['Y'] = -1875.42,
                ['Z'] = -15.30,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 179.96,
                ['Y'] = -1873.26,
                ['Z'] = -15.30,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 178.03,
                ['Y'] = -1868.81,
                ['Z'] = -15.30,
              },
             },
             [6] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 180.10,
                ['Y'] = -1867.54,
                ['Z'] = -15.30,
              },
             },
           },
        },
      
        [6] = {
          ['Label'] = 'Huis 7',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = 130.60,
            ['Y'] = -1853.29,
            ['Z'] = 25.23,
          },
          ['Extras'] = {
            [1] = {
              ['Stolen'] = false,
              ['Item'] = 'stolen-tv',
              ['PropName'] = 'Prop_TV_Flat_01',
              ['Coords'] = {
                ['X'] = 125.94,
                ['Y'] = -1853.17,
                ['Z'] = -14.43,
              }
            },
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = 133.87,
               ['Y'] = -1857.48,
               ['Z'] = -14.47,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 126.66,
                ['Y'] = -1851.01,
                ['Z'] = -14.46,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 126.99,
                ['Y'] = -1859.15,
                ['Z'] = -14.47,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 139.72,
                ['Y'] = -1854.67,
                ['Z'] = -14.47,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 137.90,
                ['Y'] = -1849.38,
                ['Z'] = -14.47,
              },
             },
           },
        },
      
        [7] = {
          ['Label'] = 'Huis 8',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = 512.55,
            ['Y'] = -1790.71,
            ['Z'] = 28.91,
          },
          ['Extras'] = {
            [1] = {
              ['Stolen'] = false,
              ['Item'] = 'stolen-micro',
              ['PropName'] = 'prop_micro_01',
              ['Coords'] = {
                ['X'] = 513.87,
                ['Y'] = -1795.46,
                ['Z'] = -10.75,
              }
            },
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = 515.80,
               ['Y'] = -1794.97,
               ['Z'] = -10.79,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 520.96,
                ['Y'] = -1792.65,
                ['Z'] = -10.79,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 519.15,
                ['Y'] = -1788.09,
                ['Z'] = -10.79,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 521.91,
                ['Y'] = -1786.73,
                ['Z'] = -10.79,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 513.80,
                ['Y'] = -1786.73,
                ['Z'] = -10.79,
              },
             },
             [6] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 509.01,
                ['Y'] = -1796.70,
                ['Z'] = -10.79,
              },
             },
           },
        },
      
        [8] = {
          ['Label'] = 'Huis 9',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = 1639.36,
            ['Y'] = 3731.41,
            ['Z'] = 35.06,
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = 1638.96,
               ['Y'] = 3727.03,
               ['Z'] = -4.64,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1635.71,
                ['Y'] = 3725.43,
                ['Z'] = -4.64,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1648.43,
                ['Y'] = 3730.03,
                ['Z'] = -4.64,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1648.77,
                ['Y'] = 3735.35,
                ['Z'] = -4.64,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1645.89,
                ['Y'] = 3734.00,
                ['Z'] = -4.64,
              },
             },
           },
        },
      
        [9] = {
          ['Label'] = 'Huis 10',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = 1880.54,
            ['Y'] = 3920.63,
            ['Z'] = 33.21,
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = 1889.62,
               ['Y'] = 3919.02,
               ['Z'] = -6.49,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1889.05,
                ['Y'] = 3924.50,
                ['Z'] = -6.49,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1886.93,
                ['Y'] = 3923.29,
                ['Z'] = -6.49,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1877.34,
                ['Y'] = 3921.95,
                ['Z'] = -6.49,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = 1876.96,
                ['Y'] = 3914.59,
                ['Z'] = -6.49,
              },
             },
           },
        },
      
        [10] = {
          ['Label'] = 'Huis 11',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = -437.93,
            ['Y'] = 6272.08,
            ['Z'] = 30.17,
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = -441.43,
               ['Y'] = 6266.12,
               ['Z'] = -9.53,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -438.38,
                ['Y'] = 6289.45,
                ['Z'] = -9.53,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -436.95,
                ['Y'] = 6266.33,
                ['Z'] = -9.53,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -429.64,
                ['Y'] = 6270.21,
                ['Z'] = -9.53,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -431.52,
                ['Y'] = 6274.71,
                ['Z'] = -9.53,
              },
             },
           },
        },
      
        [11] = {
          ['Label'] = 'Huis 12',
          ['Opened'] = false,
          ['Tier'] = 1,
          ['Coords'] = {
            ['X'] = -15.31,
            ['Y'] = 6557.32,
            ['Z'] = 33.24,
          },
          ['Lockers'] = {
            [1] = {
             ['Busy'] = false,
             ['Opened'] = false,
             ['Coords'] = {
               ['X'] = -6.90,
               ['Y'] = 655.37,
               ['Z'] = -6.46,
             },
            },
            [2] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -9.45,
                ['Y'] = 6561.46,
                ['Z'] = -6.46,
              },
             },
             [3] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -6.80,
                ['Y'] = 6561.25,
                ['Z'] = -6.46,
              },
             },
             [4] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -14.06,
                ['Y'] = 6553.50,
                ['Z'] = -6.46,
              },
             },
             [5] = {
              ['Busy'] = false,
              ['Opened'] = false,
              ['Coords'] = {
                ['X'] = -19.41,
                ['Y'] = 6559.43,
                ['Z'] = -6.46,
              },
             },
           },
        },
      }

    for i = 1, #HouseLocations do
        if math.random(1, 100) > 60 then
            houseM = HouseLocations[i]
            ccoords = vector3(houseM['Coords']['X'], houseM['Coords']['Y'], houseM['Coords']['Z'])
            TriggerServerEvent('pepe-police:server:send:house:alert', ccoords, Framework.Functions.GetStreetLabel())
        end
    end
end)