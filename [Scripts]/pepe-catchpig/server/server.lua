Framework= nil
local ServerPrice = nil

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

Citizen.CreateThread(function()
    while true do
	    ServerPrice = Config.PriceList[math.random(1, #Config.PriceList)]
        Citizen.Wait(30 * 60 * 1000) -- 30 p doi gia 1 lan
    end
end)

Framework.Functions.CreateCallback('pepe-pig:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-pigjob:getNewChicken')

AddEventHandler('pepe-pigjob:getNewChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)

    local pick = ''

    if not Player.Functions.AddItem('alivepig', 3) then
        TriggerClientEvent("Framework:Notify", src, "Túi đồ của bạn đã đầy!", "error", 8000)
    else
        TriggerClientEvent("Framework:Notify", src, "Bạn nhận được 3 gà sống!", "Success", 8000)
        TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['alivepig'], "add")
    end

end)



RegisterServerEvent('pepe-pigjob:startChicken')

AddEventHandler('pepe-pigjob:startChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)



    --   if TriggerClientEvent("Framework:Notify", src, "Hãy vào bắt gà!", "Success", 8000) then

        -- Player.Functions.RemoveMoney('cash', 500)

    --   end

end)



RegisterServerEvent('pepe-pigjob:getcutChicken')

AddEventHandler('pepe-pigjob:getcutChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)

    local pick = ''

    local Item = Player.Functions.GetItemByName('alivepig')
    if Item ~= nil then
        if Item.amount > 0 then
            if TriggerClientEvent("Framework:Notify", src, "Mổ gà thành công.", "Success", 8000) then

                if Player.Functions.RemoveItem('alivepig', 1) then
      
                    Player.Functions.AddItem('slaughteredpig', 5)
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['alivepig'], "remove")
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['slaughteredpig'], "add")
                else
                    TriggerClientEvent("Framework:Notify", src, "Bạn không đủ gà sống!", "error", 8000)
                end
            end
        else
            TriggerClientEvent("Framework:Notify", src, "Bạn không có gà sống!", "error", 8000)
        end
    else
        TriggerClientEvent("Framework:Notify", src, "Bạn không có gà sống!", "error", 8000)
    end
end)



RegisterServerEvent('pepe-pigjob:getpackedChicken')

AddEventHandler('pepe-pigjob:getpackedChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)

    local pick = ''

    local Item = Player.Functions.GetItemByName('slaughteredpig')
    if Item ~= nil then
        if Item.amount > 0 then
            if TriggerClientEvent("Framework:Notify", src, "Đóng gói gà thành công .", "success", 8000) then
        
                if Player.Functions.RemoveItem('slaughteredpig', 5) then
      
                    Player.Functions.AddItem('packedpig', 5)
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['slaughteredpig'], "remove")
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['packedpig'], "add")
                else
                    TriggerClientEvent("Framework:Notify", src, "Bạn không đủ gà thịt!", "error", 8000)
                end
      
            end
        else
            TriggerClientEvent("Framework:Notify", src, "Bạn không có gà thịt!", "error", 8000)
        end
    else
        TriggerClientEvent("Framework:Notify", src, "Bạn không có gà thịt!", "error", 8000)
    end
end)





-- local ItemList = {

--     ["packedpig"] = math.random(32, 44),

-- }



-- RegisterServerEvent('pepe-pigjob:sell')

-- AddEventHandler('pepe-pigjob:sell', function()

--     local src = source

--     local price = 0.0

--     local Player = Framework.Functions.GetPlayer(src)

--     if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 

--         for k, v in pairs(Player.PlayerData.items) do 

--             if Player.PlayerData.items[k] ~= nil then 

--                 -- if ItemList[Player.PlayerData.items[k].name] ~= nil then 

--                 --     price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)

--                 --     Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)

--                 -- end

--                 if Player.PlayerData.items[k].name == "packedpig" then 
--                     if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
--                         price = price + (ServerPrice * Player.PlayerData.items[k].amount)
--                     end
--                 end

--             end

--         end

--         price = math.ceil(price)

--         Player.Functions.AddMoney("cash", price , "sold-pig-items")

--         TriggerClientEvent('Framework:Notify', src, "Bạn đã bán gà thành công bạn nhận được "..price.." $")

--     else

--         TriggerClientEvent('Framework:Notify', src, "Không có gà đóng gói để bán")

--     end

-- end)