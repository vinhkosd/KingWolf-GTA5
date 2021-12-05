Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local ServerPrice = {}

Citizen.CreateThread(function()
    while true do
		for k, v in pairs(Config.SellPrices) do
			ServerPrice[k] = v.PriceList[math.random(1, #v.PriceList)]
			print(k.." - "..ServerPrice[k])
        end
        Citizen.Wait(30 * 60 * 1000) -- 30 p doi gia 1 lan
		-- Citizen.Wait(20 * 1 * 1000) -- 30 p doi gia 1 lan
    end
end)

Framework.Functions.CreateCallback('pepe-fishing:server:can:pay', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", Config.BoatPrice, "boat-price") then
        cb(true)
    else 
        cb(false)
    end
end)
-- Thêm return tiền cho người chơi
Framework.Functions.CreateCallback('pepe-fishing:server:return:pay', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.AddMoney("cash", Config.BoatReturnPrice, "boat-price") then
        cb(true)
    else 
        cb(false)
    end
end)

Framework.Functions.CreateUseableItem("fishrod", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil  then
        TriggerClientEvent('pepe-fishing:client:use:fishingrod', source)
        else
            -- TriggerClientEvent("Framework:Notify", source, "Bạn không có mồi câu!" , "error")
    end
end)

-- Framework.Functions.CreateUseableItem("fishrod", function(source, item)
-- 	local Player = Framework.Functions.GetPlayer(source)
-- 	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
--         TriggerClientEvent('pepe-fishing:client:use:fishingrod', source)
--     end
-- end)

Framework.Functions.CreateCallback('pepe-fishing:server:get:attempt', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    if RandomValue <= 50 then
        cb(1)-- cá 1
    end
    if RandomValue > 50 and RandomValue <= 80 then
        cb(2)
    end
    if RandomValue > 80 and RandomValue <= 97 then
        cb(3)
    end
    if RandomValue > 97 and RandomValue <= 100 then
        cb(4)
    end
end)

RegisterServerEvent('pepe-fishing:server:fish:reward')
AddEventHandler('pepe-fishing:server:fish:reward', function(attempt, duration, width)
--Framework.Functions.CreateCallback('pepe-fishing:server:fish:reward', function()
    -- 100% phát câu có 90% trúng, 10% hụt
    -- Trong 100% phát câu trúng có:
    -- - 50% tỉ lệ ra fish-1 (1 lần E)
    -- - 30% tỉ lệ ra fish-2 (2 lần E)
    -- - 17% tỉ lệ ra fish-3 (3 lần E)
    -- - 3% tỉ lệ ra fish-shark (4 lần E)
    -- Mức độ khó của E sẽ tăng dần theo số lượng lần E (ví dụ E 1 lần đầu sẽ dễ hơn E lần 2, E lần 2 dễ hơn E lần 3, E lần 3 dễ hơn E lần 4)
    -- ------------------------
    -- Tỉ lệ ra các vật phẩm phụ như sau:
    -- - Câu trúng fish-2 sẽ có 30% ra 1 Giày hoặc 1 túi nhựa
    -- - Câu trúng fish-3 sẽ có 40% ra 1 sắt vụn hoặc 1 thủy tinh
    -- - Câu trúng fish-shark sẽ có 0.3% ra điện thoại bẩn hoặc 2% ra thỏi vàng

    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    if RandomValue <= 10 then
        TriggerClientEvent("Framework:Notify", source, "Bạn đã câu hụt! ", "success", 4000)
        return
    end
    TriggerEvent("kingwolf-exp:addXP", source, 1)
    if attempt <= 3 then -- trúng cá 1, 2, 3
        local randomRewardFish = math.random(1,100)

        if attempt == 1 then -- 50% ra fish 1
            Player.Functions.AddItem('fish-1', 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['fish-1'], "add") 
        elseif attempt == 2 then -- 30% ra fish 2, 30% ra giày/ túi nhựa
            if randomRewardFish <= 75 then
                Player.Functions.AddItem('fish-2', 1)
                TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['fish-2'], "add") 
            else
                --ra túi nhựa, giày cũ
                local randomShoeOrPlasticBag = math.random(1, 5)
                if randomShoeOrPlasticBag < 5 then--ra túi nhựa
                    Player.Functions.AddItem('plasticbag', 1)
                    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['plasticbag'], "add")
                else--ra giày cũ
                    Player.Functions.AddItem('shoe', 1)
                    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['shoe'], "add")
                end
            end
        else -- 30% fish 3
            Player.Functions.AddItem('fish-3', 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['fish-3'], "add") 
        end
    elseif attempt == 4 then -- ra cá mập to%
        Player.Functions.AddItem('fish-shark', 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['fish-shark'], "add")
    end
end)

RegisterServerEvent('pepe-fishing:server:sell:items')
AddEventHandler('pepe-fishing:server:sell:items', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellItems) do
        
        -- while Player.Functions.GetItemByName(k) do -- bán cho bằng hết
            local Item = Player.Functions.GetItemByName(k)
            if Item ~= nil then
                if Item.amount > 0 then
                    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Item.name], "remove")
                    if v['Type'] == 'item' then--quy đổi item
                        if(v['FromAmount'] ~= nil) then -- quy đổi từ FromAmount to Amount
                            if Item.amount >= v['FromAmount'] then
                                local amountPlayerRecevied = math.floor(Item.amount * v['Amount'] / v['FromAmount'])
                                -- amountPlayerRecevied * v['FromAmount'] / v['Amount']
                                Player.Functions.RemoveItem(Item.name, Item.amount)
                                Player.Functions.AddItem(v['Item'], amountPlayerRecevied)
                                TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[v['Item']], "add")
                                TriggerClientEvent("Framework:Notify", src, "Bạn đã đổi thành công "..Item.amount.."x "..Item.name.."! ", "success", 4000)
                            end
                        else -- quy đổi 1:1
                            Player.Functions.RemoveItem(Item.name, Item.amount)
                            local amountPlayerRecevied = math.floor(Item.amount * v['Amount'])
                            Player.Functions.AddItem(v['Item'], amountPlayerRecevied)
                            TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[v['Item']], "add")
                            TriggerClientEvent("Framework:Notify", src, "Bạn đã đổi thành công "..Item.amount.."x "..Item.name.."! ", "success", 4000)
                        end
                        
                    else--bán ra tiền
                        Player.Functions.RemoveItem(Item.name, Item.amount)
                        local moneyReceived = ServerPrice[Item.name] * Item.amount
                        Player.Functions.AddMoney('cash', moneyReceived, 'sold-fish')
                        TriggerClientEvent("Framework:Notify", src, "Bạn đã bán "..Item.amount.."x "..Item.name..", bạn nhận được : "..moneyReceived.." $", "success", 4000)
                    end
                    -- Citizen.Wait(500)--không cần delay 0.5s nữa
            else
                    TriggerClientEvent("Framework:Notify", src, "Bạn không có vật phẩm cần thiết để bán!", "error", 4000)
                end
            end
        -- end
        
    end
end)