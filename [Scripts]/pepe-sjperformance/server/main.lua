Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code

RegisterNetEvent('pepe-sjperformance:server:buyVehicle')
AddEventHandler('pepe-sjperformance:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = Framework.Shared.Vehicles[vehicleData["model"]]
    local balance = pData.PlayerData.money["bank"]
    
    if (balance - vData["price"]) >= 0 then
        local plate = GeneratePlate()
        Framework.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData["model"].."', '"..GetHashKey(vData["model"]).."', '{}', '"..plate.."', '"..garage.."')")
        TriggerClientEvent("Framework:Notify", src, "Gelukt! Je voertuig is afgeleverd bij "..QB.GarageLabel2[garage], "success", 5000)
        pData.Functions.RemoveMoney('bank', vData["price"], "vehicle-bought-in-shop")
        TriggerEvent("pepe-log:server:sendLog", cid, "vehiclebought", {model=vData["model"], name=vData["name"], from="garage", location=QB.GarageLabel2[garage], moneyType="bank", price=vData["price"], plate=plate})
        TriggerEvent("pepe-log:server:CreateLog", "vehicleshop", "Voertuig gekocht (garage)", "green", "**"..GetPlayerName(src) .. "** heeft een " .. vData["name"] .. " gekocht voor €" .. vData["price"])
    else
		TriggerClientEvent("Framework:Notify", src, "Je hebt niet voldoende geld, je mist €"..format_thousand(vData["price"] - balance), "error", 5000)
    end
end)

RegisterNetEvent('pepe-sjperformance:server:buyShowroomVehicle')
AddEventHandler('pepe-sjperformance:server:buyShowroomVehicle', function(vehicle, class)
    local src = source
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = Framework.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (balance - vehiclePrice) >= 0 then
        Framework.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vehicle.."', '"..GetHashKey(vehicle).."', '{}', '"..plate.."', 0)")
        TriggerClientEvent("Framework:Notify", src, "Gelukt! Je voertuig staat buiten te op je te wachten.", "success", 5000)
        TriggerClientEvent('pepe-sjperformance:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
        TriggerEvent("pepe-log:server:sendLog", cid, "vehiclebought", {model=vehicle, name=Framework.Shared.Vehicles[vehicle]["name"], from="showroom", moneyType="bank", price=Framework.Shared.Vehicles[vehicle]["price"], plate=plate})
        TriggerEvent("pepe-log:server:CreateLog", "vehicleshop", "Voertuig gekocht (showroom)", "green", "**"..GetPlayerName(src) .. "** heeft een " .. Framework.Shared.Vehicles[vehicle]["name"] .. " gekocht voor €" .. Framework.Shared.Vehicles[vehicle]["price"])
    else
        TriggerClientEvent("Framework:Notify", src, "Je hebt niet voldoende geld, je mist €"..format_thousand(vehiclePrice - balance), "error", 5000)
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
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
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

RegisterServerEvent('pepe-sjperformance:server:setShowroomCarInUse')
AddEventHandler('pepe-sjperformance:server:setShowroomCarInUse', function(showroomVehicle, bool)
    QB.ShowroomVehicles2[showroomVehicle].inUse = bool
    TriggerClientEvent('pepe-sjperformance:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('pepe-sjperformance:server:setShowroomVehicle')
AddEventHandler('pepe-sjperformance:server:setShowroomVehicle', function(vData, k)
    QB.ShowroomVehicles2[k].chosenVehicle = vData
    TriggerClientEvent('pepe-sjperformance:client:setShowroomVehicle', -1, vData, k)
end)

RegisterServerEvent('pepe-sjperformance:server:SetCustomShowroomVeh')
AddEventHandler('pepe-sjperformance:server:SetCustomShowroomVeh', function(vData, k)
    QB.ShowroomVehicles2[k].vehicle = vData
    TriggerClientEvent('pepe-sjperformance:client:SetCustomShowroomVeh', -1, vData, k)
end)

Framework.Commands.Add("sjverkoop", "Verkoop voertuig uit de SJ Performance", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "sjperformance" then
        if TargetId ~= nil then
            TriggerClientEvent('pepe-sjperformance:client:SellCustomVehicle', source, TargetId)
        else
            TriggerClientEvent('Framework:Notify', source, 'Je moet een Speler ID meegeven!', 'error')
        end
    else
        TriggerClientEvent('Framework:Notify', source, 'Je bent geen Voertuig Dealer', 'error')
    end
end)

Framework.Commands.Add("sjtestrit", "Testrit maken", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "sjperformance" then
        TriggerClientEvent('pepe-sjperformance:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('Framework:Notify', source, 'Je bent geen Voertuig Dealer', 'error')
    end
end)

RegisterServerEvent('pepe-sjperformance:server:SellCustomVehicle')
AddEventHandler('pepe-sjperformance:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('pepe-sjperformance:client:SetVehicleBuying', TargetId, ShowroomSlot)
end)

RegisterServerEvent('pepe-sjperformance:server:ConfirmVehicle')
AddEventHandler('pepe-sjperformance:server:ConfirmVehicle', function(ShowroomVehicle)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local VehPrice = Framework.Shared.Vehicles[ShowroomVehicle.vehicle].price
    local plate = GeneratePlate()

    if Player.PlayerData.money.cash >= VehPrice then
        Player.Functions.RemoveMoney('cash', VehPrice)
        TriggerClientEvent('pepe-sjperformance:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    elseif Player.PlayerData.money.bank >= VehPrice then
        Player.Functions.RemoveMoney('bank', VehPrice)
        TriggerClientEvent('pepe-sjperformance:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    else
        if Player.PlayerData.money.cash > Player.PlayerData.money.bank then
            TriggerClientEvent('Framework:Notify', src, 'Je hebt niet voldoende geld.. Je mist ('..(Player.PlayerData.money.cash - VehPrice)..',-)')
        else
            TriggerClientEvent('Framework:Notify', src, 'Je hebt niet voldoende geld.. Je mist ('..(Player.PlayerData.money.bank - VehPrice)..',-)')
        end
    end
end)

Framework.Functions.CreateCallback('pepe-sjperformance:server:SellVehicle', function(source, cb, vehicle, plate)
    local VehicleData = Framework.Shared.VehicleModels[vehicle]
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Player.Functions.AddMoney('bank', math.ceil(VehicleData["price"] / 100 * 60))
            Framework.Functions.ExecuteSql(false, "DELETE FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'")
            cb(true)
        else
            cb(false)
        end
    end)
end)