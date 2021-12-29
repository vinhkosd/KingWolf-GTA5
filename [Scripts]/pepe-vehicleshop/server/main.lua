Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
RegisterNetEvent('pepe-vehicleshop:server:buyVehicle')
AddEventHandler('pepe-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = Framework.Shared.Vehicles[vehicleData["model"]]
    local balance = pData.PlayerData.money["bank"]
    local GarageData = {garagename = 'Blokkenpark Parkeerplaats', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}

    if (balance - vData["price"]) >= 0 then
        local plate = GeneratePlate()
       Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vData["model"].."', '"..plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
 
        TriggerClientEvent("Framework:Notify", src, "Thank you!Your vehicle has been delivered.", "success", 5000)
        pData.Functions.RemoveMoney('bank', vData["price"], "vehicle-bought-in-shop")
       else
		TriggerClientEvent("Framework:Notify", src, "You don't have enough cash with you. You miss: € "..format_thousand(vData["price"] - balance), "error", 5000)
    end
end)

RegisterNetEvent('pepe-vehicleshop:server:buyShowroomVehicle')
AddEventHandler('pepe-vehicleshop:server:buyShowroomVehicle', function(vehicle, class)
    local src = source
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    
   -- local GarageData = {garagename = 'Blokkenpark Parkeerplaats', garagenumber = 1}
    
    local GarageData = "Legion Parking"
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = Framework.Shared.Vehicles[vehicle]["price"]
    --print(vehicle)
    local Model = Framework.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (balance - vehiclePrice) >= 0 then
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vehicle.."', '"..plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
 
        TriggerClientEvent("Framework:Notify", src, "Thank you!Your vehicle has been delivered.", "success", 5000)
        TriggerClientEvent('pepe-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
    else
        TriggerClientEvent("Framework:Notify", src, "You don't have enough money on the bank. You miss: € "..format_thousand(vehiclePrice - balance), "error", 5000)
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function GeneratePlate()
    --KWX50000
    local plate = "LAC"..math.random(10000, 99999)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = "LAC"..math.random(10000, 99999)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterServerEvent('pepe-vehicleshop:server:setShowroomCarInUse')
AddEventHandler('pepe-vehicleshop:server:setShowroomCarInUse', function(showroomVehicle, bool)
    Pepe.ShowroomVehicles[showroomVehicle].inUse = bool
    TriggerClientEvent('pepe-vehicleshop:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('pepe-vehicleshop:server:setShowroomVehicle')
AddEventHandler('pepe-vehicleshop:server:setShowroomVehicle', function(vData, k)
    Pepe.ShowroomVehicles[k].chosenVehicle = vData
    TriggerClientEvent('pepe-vehicleshop:client:setShowroomVehicle', -1, vData, k)
end)

RegisterServerEvent('pepe-vehicleshop:server:SetCustomShowroomVeh')
AddEventHandler('pepe-vehicleshop:server:SetCustomShowroomVeh', function(vData, k)
    -- Pepe.ShowroomVehicles[k].vehicle = vData
    PepeCustoms.ShowroomPositions[k].vehicle = vData
    TriggerClientEvent('pepe-vehicleshop:client:SetCustomShowroomVeh', -1, vData, k)
end)

Framework.Commands.Add("sellvh", "Bán xe", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        if TargetId ~= nil then
            TriggerClientEvent('pepe-vehicleshop:client:SellCustomVehicle', source, TargetId)
        else
            TriggerClientEvent('Framework:Notify', source, 'Bạn phải điền vào một ID công dân.', 'error')
        end
    else
        TriggerClientEvent('Framework:Notify', source, 'Bạn không phải là một đại lý xe.', 'error')
    end
end)

Framework.Commands.Add("testrit", "Chạy thử", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        TriggerClientEvent('pepe-vehicleshop:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('Framework:Notify', source, 'Bạn không phải là một đại lý xe.', 'error')
    end
end)

RegisterServerEvent('pepe-vehicleshop:server:SellCustomVehicle')
AddEventHandler('pepe-vehicleshop:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('pepe-vehicleshop:client:SetVehicleBuying', TargetId, ShowroomSlot)
end)

RegisterServerEvent('pepe-vehicleshop:server:ConfirmVehicle')
AddEventHandler('pepe-vehicleshop:server:ConfirmVehicle', function(ShowroomVehicle)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local VehPrice = Framework.Shared.Vehicles[ShowroomVehicle.vehicle].price
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    
   -- local GarageData = {garagename = 'Blokkenpark Parkeerplaats', garagenumber = 1}
   
    local GarageData = "Legion Parking"
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local balance = pData.PlayerData.money["bank"]
    --local vehiclePrice = Framework.Shared.Vehicles[vehicle]["price"]

    --local VehicleData = Framework.Shared.Vehicles[ShowroomVehicle]
    local plate = GeneratePlate()

    --local GarageData = {garagename = 'Blokkenpark Parkeerplaats', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    Framework.Functions.TriggerCallback('pepe-inventory:server:registerWeight', src, function(result)
        if not result then
        --   Framework.Functions.Notify('Không thể đăng ký thông tin cốp xe, vui lòng cất xe vào thử lại.', 'error')
        end
    end, plate, ShowroomVehicle.vehicle)
    if Player.PlayerData.money.cash ~= 0 then
        -- Player.Functions.RemoveMoney('cash', VehPrice)
        TriggerClientEvent('pepe-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
    elseif Player.PlayerData.money.bank ~= 0 then
        -- Player.Functions.RemoveMoney('bank', VehPrice)
        TriggerClientEvent('pepe-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
    else
        -- if Player.PlayerData.money.cash > Player.PlayerData.money.bank then
        --     TriggerClientEvent('Framework:Notify', src, 'Bạn không có đủ tiền mặt với bạn. Bạn cần $ '..(Player.PlayerData.money.cash - VehPrice)..',-')
        -- else
        --     TriggerClientEvent('Framework:Notify', src, 'Bạn không có đủ tiền trên ngân hàng. Bạn cần $ '..(Player.PlayerData.money.bank - VehPrice)..',-')
        -- end
    end
end)

Framework.Functions.CreateCallback('pepe-vehicleshop:server:SellVehicle', function(source, cb, vehicle, plate)
    local VehicleData = Framework.Shared.VehicleModels[vehicle]
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Player.Functions.AddMoney('bank', math.ceil(VehicleData["price"] / 100 * 60))
            Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'")
            cb(true)
        else
            cb(false)
        end
    end)
end)