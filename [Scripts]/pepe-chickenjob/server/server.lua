Framework= nil
local ServerPrice = nil

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

Citizen.CreateThread(function()
    while true do
	    ServerPrice = Config.PriceList[math.random(1, #Config.PriceList)]
        Citizen.Wait(30 * 60 * 1000) -- 30 p doi gia 1 lan
    end
end)

Framework.Functions.CreateCallback('pepe-chicken:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-chickenjob:getNewChicken')

AddEventHandler('pepe-chickenjob:getNewChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)

    local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

    local pick = ''

    if not Player.Functions.AddItem('alivechicken', 3) then
        TriggerClientEvent("Framework:Notify", src, "Túi đồ của bạn đã đầy!", "error", 8000)
    else
        TriggerEvent("kingwolf-exp:addXP", src, 3)
        TriggerClientEvent("Framework:Notify", src, "Bạn nhận được 3 gà sống!", "Success", 8000)
        TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['alivechicken'], "add")
    end

end)



RegisterServerEvent('pepe-chickenjob:startChicken')

AddEventHandler('pepe-chickenjob:startChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)


    local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end
    --   if TriggerClientEvent("Framework:Notify", src, "Hãy vào bắt gà!", "Success", 8000) then

        -- Player.Functions.RemoveMoney('cash', 500)

    --   end

end)



RegisterServerEvent('pepe-chickenjob:getcutChicken')

AddEventHandler('pepe-chickenjob:getcutChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)

    local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end
    local pick = ''

    local Item = Player.Functions.GetItemByName('alivechicken')
    if Item ~= nil then
        if Item.amount > 0 then
            if TriggerClientEvent("Framework:Notify", src, "Mổ gà thành công.", "Success", 8000) then

                if Player.Functions.RemoveItem('alivechicken', 1) then
      
                    Player.Functions.AddItem('slaughteredchicken', 5)
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['alivechicken'], "remove")
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['slaughteredchicken'], "add")
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



RegisterServerEvent('pepe-chickenjob:getpackedChicken')

AddEventHandler('pepe-chickenjob:getpackedChicken', function()

    local src = source

    local Player = Framework.Functions.GetPlayer(src)

    local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

    local pick = ''

    local Item = Player.Functions.GetItemByName('slaughteredchicken')
    if Item ~= nil then
        if Item.amount > 0 then
            if TriggerClientEvent("Framework:Notify", src, "Đóng gói gà thành công .", "success", 8000) then
        
                if Player.Functions.RemoveItem('slaughteredchicken', 5) then
      
                    Player.Functions.AddItem('packedchicken', 5)
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['slaughteredchicken'], "remove")
        
                    TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['packedchicken'], "add")
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

--     ["packedchicken"] = math.random(32, 44),

-- }



-- RegisterServerEvent('pepe-chickenjob:sell')

-- AddEventHandler('pepe-chickenjob:sell', function()

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

--                 if Player.PlayerData.items[k].name == "packedchicken" then 
--                     if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
--                         price = price + (ServerPrice * Player.PlayerData.items[k].amount)
--                     end
--                 end

--             end

--         end

--         price = math.ceil(price)

--         Player.Functions.AddMoney("cash", price , "sold-chicken-items")

--         TriggerClientEvent('Framework:Notify', src, "Bạn đã bán gà thành công bạn nhận được "..price.." $")

--     else

--         TriggerClientEvent('Framework:Notify', src, "Không có gà đóng gói để bán")

--     end

-- end)