local showMenu = false
local MAX_MENU_ITEMS = 7

local isLoggedIn = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(100)
      isLoggedIn = true
  end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
           if IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) and showMenu then
               showMenu = false
               SetNuiFocus(false, false)
           end
           if IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) then
               showMenu = true
             if showMenu == true then
               DisableControlAction(0, 289, true)  
               DisableControlAction(0, 288, true)  
             end
            local enabledMenus = {}
               for _, menuConfig in ipairs(Config.Menu) do
                   if menuConfig:enableMenu() then
                       local dataElements = {}
                       local hasSubMenus = false
                       if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
                           hasSubMenus = true
                           local previousMenu = dataElements
                           local currentElement = {}
                           for i = 1, #menuConfig.subMenus do
                               currentElement[#currentElement+1] = Config.SubMenus[menuConfig.subMenus[i]]
                               currentElement[#currentElement].id = menuConfig.subMenus[i]
                               currentElement[#currentElement].enableMenu = nil
   
                               if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
                                   previousMenu[MAX_MENU_ITEMS + 1] = {
                                       id = "_more",
                                       title = "Meer",
                                       icon = "#more",
                                       items = currentElement
                                   }
                                   previousMenu = currentElement
                                   currentElement = {}
                               end
                           end
                           if #currentElement > 0 then
                               previousMenu[MAX_MENU_ITEMS + 1] = {
                                   id = "_more",
                                   title = "Meer",
                                   icon = "#more",
                                   items = currentElement
                               }
                           end
                           dataElements = dataElements[MAX_MENU_ITEMS + 1].items
   
                       end
                       enabledMenus[#enabledMenus+1] = {
                           id = menuConfig.id,
                           title = menuConfig.displayName,
                           close = menuConfig.close,
                           functiontype = menuConfig.functiontype,
                           functionParameters = menuConfig.functionParameters,
                           functionName = menuConfig.functionName,
                           icon = menuConfig.icon,
                       }
                       if hasSubMenus then
                           enabledMenus[#enabledMenus].items = dataElements
                       end
                   end
               end
               SendNUIMessage({
                   state = "show",
                   data = enabledMenus,
                   menuKeyBind = 'F1'
               })
               SetCursorLocation(0.5, 0.5)
               SetNuiFocus(true, true)
               PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
               while showMenu == true do Citizen.Wait(100) end
               Citizen.Wait(100)
               while IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) do Citizen.Wait(100) end
           end
         else
            Citizen.Wait(150)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if isLoggedIn then
            Framework.Functions.TriggerCallback('pepe-radialmenu:server:HasItem', function(HasItem)
                if HasItem then
                    HasHandCuffs = true
                else
                    HasHandCuffs = false
                end
            end, 'handcuffs')
            Citizen.Wait(250)
        else
            Citizen.Wait(250)
        end
    end
end)

RegisterNetEvent('pepe-radialmenu:client:force:close')
AddEventHandler('pepe-radialmenu:client:force:close', function()
  showMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({
      state = 'destroy'
  })
end)

RegisterNUICallback('closemenu', function(data, cb)
 showMenu = false
 SetNuiFocus(false, false)
 SendNUIMessage({
     state = 'destroy'
 })
 PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
 cb('ok')
end)

RegisterNUICallback('triggerAction', function(data, cb)
    local found = false
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    local canTriggerSubMenus = {}
    for k, v in pairs(Config.Menu) do
        if not found then
            if v.functionName ~= nil and data.action == v.functionName and v.functiontype == data.type then
                local isMenuEnable = false
                if  v.enableMenu ~= nil then
                    isMenuEnable = v.enableMenu()
                else
                    isMenuEnable = true
                end
                if isMenuEnable then
                    found = true
                    break
                end
            elseif v.subMenus then
                for i = 1, #v.subMenus do
                    if  v.enableMenu ~= nil then
                        if (canTriggerSubMenus[v.subMenus[i]] == nil) or not canTriggerSubMenus[v.subMenus[i]] then
                            canTriggerSubMenus[v.subMenus[i]] = v.enableMenu()
                            -- print("SET TRIGGER"..v.subMenus[i]..json.encode(v.enableMenu())..json.encode(v.enableMenu ~= nil))
                        end
                    else
                        if (canTriggerSubMenus[v.subMenus[i]] == nil) or not canTriggerSubMenus[v.subMenus[i]] then
                            canTriggerSubMenus[v.subMenus[i]] = true
                        end
                    end        
                end
            end
        else
            break
        end
    end

    for k, v in pairs(Config.SubMenus) do
        if not found then
            if v.functionName ~= nil and data.action == v.functionName and v.functiontype == data.type then
                -- print("CAN TRIGGER"..k.."-"..v.functionName..json.encode(canTriggerSubMenus[k]))
                if canTriggerSubMenus[k] then
                    found = true
                    break
                end
            end
        else
            break
        end
    end

    if not found then
        TriggerServerEvent("pepe-radialmenu:server:sendLogs", data)
    else
        if data.type == 'client' then
            TriggerEvent(data.action, data.parameters)
        elseif data.type == 'server' then 
            TriggerServerEvent(data.action, data.parameters)
        end
    end
    -- if data.type == 'client' then
    --     TriggerEvent(data.action, data.parameters)
    -- elseif data.type == 'server' then 
    --     TriggerServerEvent(data.action, data.parameters)
    -- end
    
 
    cb('ok')
end)