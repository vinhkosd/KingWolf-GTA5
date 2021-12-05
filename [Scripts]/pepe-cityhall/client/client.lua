Framework = nil

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(100)
  end)
end)

-- Code

-- // Events \\ --

RegisterNetEvent('pepe-cityhall:client:open:nui')
AddEventHandler('pepe-cityhall:client:open:nui', function()
    Citizen.SetTimeout(350, function()
        OpenCityHall()
    end)
end)

-- // Functions \\ 

function OpenCityHall()
 SetNuiFocus(true, true)  
 SendNUIMessage({
     action = "open"
 }) 
end

RegisterNUICallback('Close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('requestId', function(data)
    local idType = data.idType
    TriggerServerEvent('pepe-cityhall:server:requestId', Config.IdTypes[idType])
    -- Framework.Functions.Notify('Bạn đã yêu cầu '..Config.IdTypes[idType].label..' thành công. Bạn bị trừ 50$.', 'success', 3500)
end)

RegisterNUICallback('requestLicenses', function(data, cb)
    local PlayerData = Framework.Functions.GetPlayerData()
    local licensesMeta = PlayerData.metadata["licences"]
    local availableLicenses = {}
    for type,_ in pairs(licensesMeta) do
        if licensesMeta[type] then
            local licenseType = nil
            local label = nil
            if type == "driver" then licenseType = "rijbewijs" label = "Bằng lái xe" end
            table.insert(availableLicenses, {
                idType = licenseType,
                label = label
            })
        end
    end
    cb(availableLicenses)
end)

RegisterNUICallback('applyJob', function(data)
    if data.job == "hocnghe" then
        SetNewWaypoint(2617.3503, 4860.5078)
        Framework.Functions.Notify("Tọa độ nông trại vui vẻ đã được cài đặt trên bản đồ")
    end
    TriggerServerEvent('pepe-cityhall:server:ApplyJob', data.job)
end)

-- // Functions \\ --

function CanOpenCityHall()
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Location['X'], Config.Location['Y'], Config.Location['Z'], true)
    if Distance < 3.0 then  
      return true
    end
end