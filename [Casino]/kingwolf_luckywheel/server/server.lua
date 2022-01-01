isRoll = false
amount = 1000
Framework= nil

VehicleRewards = {
    ["mesa"] = {vehicle = "mesa", quantity = 2, chancePercent = 20},
    ["adder"] = {vehicle = "adder", quantity = 4, chancePercent = 10},
    ["btype3"] = {vehicle = "btype3", quantity = 4, chancePercent = 10},
    ["sultan2"] = {vehicle = "sultan2", quantity = 4, chancePercent = 10},
    ["fq2"] = {vehicle = "fq2", quantity = 2, chancePercent = 20},
    ["sanchez"] = {vehicle = "sanchez", quantity = 5, chancePercent = 30},
}
--tổng chancePercent của xe phải là 100%

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

playerRewarded = {}

local carQuantity = 0

playerMustReward = {
    ["XKU52534"] = {
        ["sultan2"] = false,
    },--DucChinh
    ["THY98846"] = {
        ["mesa"] = false,
        ["adder"] = false,
    },--ChinhQuang
    ["KQB91221"] = {
        ["btype3"] = false,
    },--Seo_Toxic
    ["KPZ84234"] = {
        ["adder"] = false,
    },--ngocanld
    ["SDD08357"] = {
        ["btype3"] = false,
    },--SupLo
    ["SCZ81339"] = {
        ["sultan2"] = false,
    },--anhChu
    ["BGX18778"] = {
        ["sultan2"] = false,
    },--Viet
    ["PWA07429"] = {
        ["sultan2"] = false,
        ["adder"] = false,
    },--Tino
    ["OAS50576"] = {
        ["adder"] = false,
    },--Huynh Tuan
    ["EYO68995"] = {
        ["sanchez"] = false,
    },--Noobi
}

Citizen.CreateThread(function()
    local queryWhere = ""
    local i = 0
    local countVehicleRewards = 0
    local chanceToGetCarPrize = 0

    for k,v in pairs(VehicleRewards) do
        countVehicleRewards = countVehicleRewards + 1
        carQuantity = carQuantity + v.quantity
        VehicleRewards[k].startChanceAmount = chanceToGetCarPrize
        chanceToGetCarPrize = chanceToGetCarPrize + VehicleRewards[k].chancePercent
        VehicleRewards[k].endChanceAmount = chanceToGetCarPrize
    end

    for k,v in pairs(VehicleRewards) do
        vehInfo = v
        i = i + 1
        queryWhere = queryWhere .. "`vehicle` = '" .. vehInfo.vehicle .. "'"
        if i ~= countVehicleRewards then
            queryWhere = queryWhere .. " or "
        end
    end

    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE "..queryWhere.."", function(result)
        if result[1] ~= nil then
            for i = 1, #result do
                local vehicleName = result[i].vehicle:lower()
                if vehicleName ~= nil and VehicleRewards[vehicleName] ~= nil and VehicleRewards[vehicleName].quantity > 0 then
                    VehicleRewards[vehicleName].quantity = VehicleRewards[vehicleName].quantity - 1
                    carQuantity = carQuantity - 1
                    if playerMustReward[result[i].citizenid] ~= nil and playerMustReward[result[i].citizenid][vehicleName] ~= nil then
                        playerMustReward[result[i].citizenid][vehicleName] = true
                    end
                end
            end
        end
    end)
end)

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

RegisterServerEvent('kingwolf_luckywheel:getLucky')
AddEventHandler('kingwolf_luckywheel:getLucky', function()
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    if not isRoll then
        if xPlayer ~= nil then
            if xPlayer.Functions.RemoveItem("casinoticket", 1) then
                isRoll = true
                -- local _priceIndex = math.random(1, 20)
                local _randomPrice = math.random(1, 100)
                if _randomPrice == 1 then-- Ra xe
                    local _subRan = math.random(1, 100)
                    if _subRan <= 1 then-- 50% cua 1% Ra xe
                        _priceIndex = 19
                    else--50% win 2k
                        _priceIndex = 3
                    end
                    -- _priceIndex = 20
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

                local customCarPrize = nil

                if playerMustReward[xPlayer.PlayerData.citizenid] ~= nil and _randomPrice > 10 then
                    for k, v in pairs(playerMustReward[xPlayer.PlayerData.citizenid]) do
                        if not v then
                            _priceIndex = 19
                            customCarPrize = k
                            playerMustReward[xPlayer.PlayerData.citizenid][k] = true
                            break
                        end
                    end
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
                        vehicleModel = ""
                        foundCarPrize = false
                        timeout = 10
                        if carQuantity > 0 then
                            if customCarPrize ~= nil and VehicleRewards[customCarPrize] ~= nil then
                                foundCarPrize = true
                                vehicleModel = customCarPrize
                                VehicleRewards[customCarPrize].quantity = VehicleRewards[customCarPrize].quantity - 1
                                carQuantity = carQuantity - 1
                            else
                                while not foundCarPrize and timeout > 0 do --nếu quay trúng xe hết stock thì random lại
                                    local chanceAmountToGetPrize = math.random(1, 100)
                                    for k,v in pairs(VehicleRewards) do
                                        if chanceAmountToGetPrize > VehicleRewards[k].startChanceAmount and chanceAmountToGetPrize <= VehicleRewards[k].endChanceAmount then
                                            if VehicleRewards[k].quantity > 0 then
                                                foundCarPrize = true
                                                vehicleModel = k
                                                VehicleRewards[k].quantity = VehicleRewards[k].quantity - 1
                                                carQuantity = carQuantity - 1
                                            end
                                        end
                                    end
                                    Citizen.Wait(1)
                                    timeout = timeout - 1
                                end
                            end

                            if foundCarPrize then --validate nếu config chưa đúng thì vượt ngoài % trúng xe sẽ cộng 2k cho người chơi thay vì phần thưởng xe
                                AddPlayerVehicle(xPlayer, vehicleModel)
                                TriggerClientEvent('Framework:Notify', src, "Bạn đã trúng thưởng xe "..vehicleModel..", xe của bạn được vận chuyển vào Gara trung tâm!", "success")
                                -- TriggerClientEvent('Framework:Notify', -1, "Người chơi đã trúng thưởng xe "..vehicleModel.." tại vòng quay Casino!", "success")
                            end
                        end

                        if not foundCarPrize then
                            xPlayer.Functions.AddMoney("cash", 2000)
                            TriggerClientEvent('Framework:Notify', src, "Bạn đã trúng 2000 tiền mặt", "success")
                        end
                    end
                    TriggerClientEvent("kingwolf_luckywheel:rollFinished", -1)
                end)
                TriggerClientEvent("kingwolf_luckywheel:doRoll", -1, _priceIndex)
            else
                TriggerClientEvent("kingwolf_luckywheel:rollFinished", -1)    
                TriggerClientEvent('Framework:Notify', src, "Bạn không có vé casino!")
            end
        end
    end
end)

RegisterServerEvent('kingwolf-luckywheel:server:getTicket')
AddEventHandler('kingwolf-luckywheel:server:getTicket', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    
    if Player.PlayerData.metadata["isgetcasinoticket"] == nil or not Player.PlayerData.metadata["isgetcasinoticket"] then
        Player.Functions.SetMetaData("isgetcasinoticket", true)
        Player.Functions.AddItem("casinoticket", 5)
        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['casinoticket'], "add")
        TriggerClientEvent('Framework:Notify', src, "Bạn nhận được 5 vé Casino!", "success")
    else
        TriggerClientEvent('Framework:Notify', src, "Bạn đã nhận vé thử này rồi!", "error")
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
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
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
