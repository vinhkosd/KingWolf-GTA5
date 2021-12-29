isRoll = false
amount = 1000
Framework= nil

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

RegisterServerEvent('kingwolf_luckywheel:getLucky')
AddEventHandler('kingwolf_luckywheel:getLucky', function()
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    if not isRoll then
        if xPlayer ~= nil then
            if xPlayer.Functions.RemoveMoney("cash", amount) then
                isRoll = true
                -- local _priceIndex = math.random(1, 20)
                local _randomPrice = math.random(1, 100)
                if _randomPrice == 1 then
                    -- Win car
                    -- local _subRan = math.random(1,1000)
                    -- if _subRan <= 1 then-- 0.1% win xe
                        -- _priceIndex = 19
                    -- else--99.9% win 2k
                        -- _priceIndex = 3
                    -- end
                    _priceIndex = 20
                elseif _randomPrice > 1 and _randomPrice <= 6 then--5% ra 
                    -- Win
                    _priceIndex = 12
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then--10%
                        _priceIndex = 12
                    else--90% ra 30k
                        _priceIndex = 7
                    end
                elseif _randomPrice > 6 and _randomPrice <= 15 then--9% ra tiền bẩn
                    -- Black money
                    -- 4, 8, 11, 16
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 4
                    elseif _sRan == 2 then
                        _priceIndex = 8
                    elseif _sRan == 3 then
                        _priceIndex = 11
                    else
                        _priceIndex = 16
                    end
                elseif _randomPrice > 15 and _randomPrice <= 25 then--10% 15k
                    -- Win 15k$
                    -- _priceIndex = 5
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then--10% ra 15k
                        _priceIndex = 5--15k
                    else--90% ra 5k
                        _priceIndex = 20--5k
                    end
                elseif _randomPrice > 25 and _randomPrice <= 40 then--45% hụt
                    -- 1, 9, 13, 17
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 1
                    elseif _sRan == 2 then
                        _priceIndex = 9
                    elseif _sRan == 3 then
                        _priceIndex = 13
                    else
                        _priceIndex = 17
                    end
                elseif _randomPrice > 40 and _randomPrice <= 80 then--20%
                    local _itemList = {}
                    _itemList[1] = 2
                    _itemList[2] = 6
                    _itemList[3] = 10
                    _itemList[4] = 14
                    _itemList[5] = 18
                    _priceIndex = _itemList[math.random(1, 5)]--thuoc la
                elseif _randomPrice > 80 and _randomPrice <= 100 then--10%
                    local _itemList = {}
                    _itemList[1] = 3--2k
                    _itemList[2] = 7--3k
                    _itemList[3] = 15--4k
                    _itemList[4] = 20--5k
                    _priceIndex = _itemList[math.random(1, 4)]
                end

                SetTimeout(6000, function()
                    isRoll = false
                    -- Give Price
                    if _priceIndex == 1 or _priceIndex == 9 or _priceIndex == 13 or _priceIndex == 17 then
                        TriggerClientEvent('Framework:Notify', src, "Chúc bạn may mắn lần sau!", "error")
                    elseif _priceIndex == 2 or _priceIndex == 6 or _priceIndex == 10 or _priceIndex == 14 or _priceIndex == 18 then
                        local _countItem = 1
                        if _priceIndex == 6 then
                            _countItem = 1
                        elseif _priceIndex == 10 then
                            _countItem = 2
                        elseif _priceIndex == 14 then
                            _countItem = 2
                        elseif _priceIndex == 18 then
                            _countItem = 3
                        end
                        xPlayer.Functions.AddItem("ciggy", _countItem)
                        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['ciggy'], "add")
                        TriggerClientEvent('Framework:Notify', src, "Bạn đã trúng "..(_countItem).." thuốc lá", "success")
                    elseif _priceIndex == 3 or _priceIndex == 7 or _priceIndex == 15 or _priceIndex == 20 then
                        local _money = 0
                        if _priceIndex == 3 then
                            _money = 2000
                        elseif _priceIndex == 7 then
                            _money = 3000
                        elseif _priceIndex == 15 then
                            _money = 4000
                        elseif _priceIndex == 20 then
                            _money = 5000
                        end
                        xPlayer.Functions.AddMoney("cash", _money, "win-casino")
                        TriggerClientEvent('Framework:Notify', src, "Bạn đã trúng "..(_money).." tiền mặt", "success")
                    elseif _priceIndex == 4 or _priceIndex == 8 or _priceIndex == 11 or _priceIndex == 16 then--9% tien ban
                        local _blackMoney = 0
                        if _priceIndex == 4 then
                            _blackMoney = 10
                        elseif _priceIndex == 8 then
                            _blackMoney = 15
                        elseif _priceIndex == 11 then
                            _blackMoney = 20
                        elseif _priceIndex == 16 then
                            _blackMoney = 25
                        end
                        xPlayer.Functions.AddItem('money-roll', _blackMoney)
                        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['money-roll'], "add")
                        TriggerClientEvent('Framework:Notify', src, "Bạn đã trúng "..(_blackMoney).." tiền bẩn", "success")
                    elseif _priceIndex == 5 then
                        xPlayer.Functions.AddMoney("cash", 15000)
                        TriggerClientEvent('Framework:Notify', src, "Bạn đã trúng 15.000 tiền mặt", "success")
                    elseif _priceIndex == 12 then
                        --10% of 5%
                        TriggerClientEvent('Framework:Notify', src, "Chúc bạn may mắn lần sau!", "error")
                    elseif _priceIndex == 19 then
                        -- add car to garages
                        vehicleModel = "nero2"
                        --random car name
                        AddPlayerVehicle(xPlayer, vehicleModel)
                    end
                    TriggerClientEvent("kingwolf_luckywheel:rollFinished", -1)
                end)
                TriggerClientEvent("kingwolf_luckywheel:doRoll", -1, _priceIndex)
            else
                TriggerClientEvent("kingwolf_luckywheel:rollFinished", -1)    
                TriggerClientEvent('Framework:Notify', src, "Bạn không có đủ tiền trong ví để chơi! Yêu cầu " .. amount .. "$ cho 1 lần quay!")
            end
        end
    end
end)

function AddPlayerVehicle(pData, vehicle)
    local cid = pData.PlayerData.citizenid
    
    local GarageData = "Legion Parking"
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local plate = GeneratePlate()

    Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vehicle.."', '"..plate.."', '"..GarageData.."', 'in', '{}', '"..json.encode(VehicleMeta).."')")
end

function GeneratePlate()
    local plate = "LAV"..math.random(10000, 99999)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = "LAV"..math.random(10000, 99999)
        end
        return plate
    end)
    return plate:upper()
end