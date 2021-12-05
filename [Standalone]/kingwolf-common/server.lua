Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local CoolDowns = {}
local PlateInfos = {}


Framework.Functions.CreateCallback('kingwolf-common:server:registerPlate', function(source, cb, plateText)
    local Player = Framework.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    if PlateInfos[plateText] ~= nil then
        cb(false)
    else
        PlateInfos[plateText] = CitizenId
        cb(true)
    end
end)

Framework.Functions.CreateCallback('kingwolf-common:server:createCoolDown', function(source, cb, addCoolDowns)
    local Player = Framework.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    CoolDowns[CitizenId] = GetGameTimer() + addCoolDowns
    cb(true)
end)

Framework.Functions.CreateCallback('kingwolf-common:server:getCoolDown', function(source, cb, plateText)
    local Player = Framework.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    local coolDown = 0
    if CoolDowns[CitizenId] ~= nil then
        coolDown = CoolDowns[CitizenId] - GetGameTimer()
    end

    cb(coolDown)
end)

Framework.Functions.CreateCallback('kingwolf-common:server:removeCoolDown', function(source, cb, plateText)
    local Player = Framework.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    local found = false
    if CoolDowns[CitizenId] ~= nil then
        CoolDowns[CitizenId] = 0
        found = true
    end

    cb(found)
end)


Framework.Functions.CreateCallback('kingwolf-common:server:getPlateOwner', function(source, cb, plate)
    if PlateInfos[plate] ~= nil then
        local vehicleData = {}
        local ownerPlayer = Framework.Functions.GetPlayerByCitizenId(PlateInfos[plate])
        local playerName = ownerPlayer ~= nil and ownerPlayer.PlayerData.charinfo.firstname .. " " .. ownerPlayer.PlayerData.charinfo.lastname or ""
        local playerId = ownerPlayer ~= nil and ownerPlayer.PlayerData.source or "unknown"
        vehicleData = {
            plate = plate,
            status = true,
            owner = playerName.."(Citizen :"..PlateInfos[plate].." | id: "..playerId..")",
            citizenid = PlateInfos[plate],
        }
        cb(vehicleData)
    else
        cb(nil)
    end
end)