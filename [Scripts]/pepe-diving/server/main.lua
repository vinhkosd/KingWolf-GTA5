Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

RegisterServerEvent('pepe-diving:server:SetBerthVehicle')
AddEventHandler('pepe-diving:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('pepe-diving:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    
    QBBoatshop.Locations["berths"][BerthId]["boatModel"] = boatModel
end)

RegisterServerEvent('pepe-diving:server:SetDockInUse')
AddEventHandler('pepe-diving:server:SetDockInUse', function(BerthId, InUse)
    QBBoatshop.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('pepe-diving:client:SetDockInUse', -1, BerthId, InUse)
end)

Framework.Functions.CreateCallback('pepe-diving:server:GetBusyDocks', function(source, cb)
    cb(QBBoatshop.Locations["berths"])
end)

RegisterServerEvent('pepe-diving:server:BuyBoat')
AddEventHandler('pepe-diving:server:BuyBoat', function(boatModel, BerthId)
    local BoatPrice = QBBoatshop.ShopBoats[boatModel]["price"]
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }
    local missingMoney = 0
    local plate = "BOOT"..math.random(1111, 9999)

    if PlayerMoney.cash >= BoatPrice then
        Player.Functions.RemoveMoney('cash', BoatPrice, "bought-boat")
        TriggerClientEvent('pepe-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    elseif PlayerMoney.bank >= BoatPrice then
        Player.Functions.RemoveMoney('bank', BoatPrice, "bought-boat")
        TriggerClientEvent('pepe-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (BoatPrice - PlayerMoney.bank)
        else
            missingMoney = (BoatPrice - PlayerMoney.cash)
        end
        TriggerClientEvent('Framework:Notify', src, 'Bạn không có đủ tiền, bạn cần $'..missingMoney, 'error', 4000)
    end
end)

function InsertBoat(boatModel, Player, plate)
    Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..boatModel.."', '"..plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
end

Framework.Functions.CreateUseableItem("diving_gear", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)

    TriggerClientEvent("pepe-diving:client:UseGear", source, true)
end)

RegisterServerEvent('pepe-diving:server:RemoveItem')
AddEventHandler('pepe-diving:server:RemoveItem', function(item, amount)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
end)

Framework.Functions.CreateCallback('pepe-diving:server:GetMyBoats', function(source, cb, dock)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `garage` = '"..GarageData.."'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

Framework.Functions.CreateCallback('pepe-diving:server:GetDepotBoats', function(source, cb, dock)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `state` = '0'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('pepe-diving:server:SetBoatState')
AddEventHandler('pepe-diving:server:SetBoatState', function(plate, state, boathouse)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Framework.Functions.ExecuteSql(false, "UPDATE `characters_vehicles` SET `state` = '"..state.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
    
            if state == 1 then
                Framework.Functions.ExecuteSql(false, "UPDATE `characters_vehicles` SET `garage` = '"..boathouse.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end
    end)
end)

RegisterServerEvent('pepe-diving:server:CallCops')
AddEventHandler('pepe-diving:server:CallCops', function(Coords)
    local src = source
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                local msg = "San hô có thể bị đánh cắp!"
                TriggerClientEvent('pepe-diving:client:CallCops', Player.PlayerData.source, Coords, msg)
                local alertData = {
                    title = "Lặn bất hợp pháp",
                    coords = {x = Coords.x, y = Coords.y, z = Coords.z},
                    description = msg,
                }
                TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, alertData)
            end
        end
	end
end)

local AvailableCoral = {}

Framework.Commands.Add("coidolan", "Cởi đồ lặn", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("pepe-diving:client:UseGear", source, false)
end)

RegisterServerEvent('pepe-diving:server:SellCoral')
AddEventHandler('pepe-diving:server:SellCoral', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    if HasCoral(src) then
        for k, v in pairs(AvailableCoral) do
            local Item = Player.Functions.GetItemByName(v.item)
            local price = (Item.amount * v.price)
            local Reward = math.ceil(GetItemPrice(Item, price))

            -- if Item.amount > 1 then
                -- for i = 1, Item.amount, 1 do
                    Player.Functions.RemoveItem(Item.name, Item.amount)
                    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Item.name], "remove")
                    Player.Functions.AddMoney('cash', math.ceil(Reward), "sold-coral")
                    -- Citizen.Wait(250)
                -- end
            -- else
            --     Player.Functions.RemoveItem(Item.name, 1)
            --     Player.Functions.AddMoney('cash', Reward, "sold-coral")
            --     TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Item.name], "remove")
            -- end
        end
    else
        TriggerClientEvent('Framework:Notify', src, 'Bạn không có san hô để bán..', 'error')
    end
end)

function GetItemPrice(Item, price)
    if Item.amount > 5 then
        price = price / 100 * 80
    elseif Item.amount > 10 then
        price = price / 100 * 70
    elseif Item.amount > 15 then
        price = price / 100 * 50
    end
    return price
end

function HasCoral(src)
    local Player = Framework.Functions.GetPlayer(src)
    local retval = false
    AvailableCoral = {}

    for k, v in pairs(QBDiving.CoralTypes) do
        local Item = Player.Functions.GetItemByName(v.item)
        if Item ~= nil then
            table.insert(AvailableCoral, v)
            retval = true
        end
    end
    return retval
end