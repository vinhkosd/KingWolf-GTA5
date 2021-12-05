Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-mine:getItem')
AddEventHandler('pepe-mine:getItem', function()
    local src = source
	local xPlayer, randomItem = Framework.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
    local xPlayer2 = Framework.Functions.GetPlayer(source)
	local randomRareItem = math.random(1, 100)
    local randomValue = math.random(1, 150)
    local randomMetalSrapValue = math.random(1, 150)

    local LicenseItem = xPlayer.Functions.GetItemByName('farm-license')
	
	if LicenseItem == nil then
		TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
        return
	end

    local ToolItem = xPlayer.Functions.GetItemByName('mine-pickaxe')
	
	if ToolItem == nil then
		TriggerClientEvent('Framework:Notify', source, 'Bạn không có cuốc đá, hãy ra cửa hàng dụng cụ để mua cuốc đá!', "error")
        return
	end

    if randomValue >= Config.ChanceToGetItem and randomValue <= Config.ChanceToGetItem2 and randomMetalSrapValue == 1 then--150 phát trúng được 1 sắt vụn
        xPlayer.Functions.AddItem("metalscrap", 1)
    end

	if randomRareItem <= 80 and randomValue >= Config.ChanceToGetItem and randomValue <= Config.ChanceToGetItem2 then
        TriggerEvent("kingwolf-exp:addXP", src, 1)
		local Item = xPlayer.Functions.GetItemByName(randomItem)
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
		else	
		if Item.amount < 35 then
            xPlayer.Functions.AddItem(randomItem, 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
		else
			TriggerClientEvent('Framework:Notify', source, 'Túi của bạn đã đầy', "error")  
		end
	    end
    end
    -- Ti le ra da va ngoc luc bao
    if randomRareItem >= 80 and randomRareItem <= 100 and randomValue >= Config.ChanceToGetItem and randomValue <= Config.ChanceToGetItem2 then
        TriggerEvent("kingwolf-exp:addXP", src, 1)

        local randomItem2  = 'diamond'
        if(randomRareItem > 92) then --8% ngọc lục bảo
            randomItem2  = 'emerald'
        end

		local Item2 = xPlayer2.Functions.GetItemByName(randomItem2)
		if Item2 == nil then
			xPlayer2.Functions.AddItem(randomItem2, 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer2.PlayerData.source, Framework.Shared.Items[randomItem2], 'add')
		else	
		if Item2.amount < 35 then        
            xPlayer2.Functions.AddItem(randomItem2, 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer2.PlayerData.source, Framework.Shared.Items[randomItem2], 'add')
		else
			TriggerClientEvent('Framework:Notify', source, 'Túi của bạn đã đầy', "error")  
		end
	    end
    end
    -- if randomValue >= Config.ChanceToGetItem and randomValue <= Config.ChanceToGetItem2 then
	-- 	local Item = xPlayer.Functions.GetItemByName(randomItem)
	-- 	if Item == nil then
	-- 		xPlayer.Functions.AddItem(randomItem, 1)
    --         TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
	-- 	else	
	-- 	if Item.amount < 35 then
        
    --     xPlayer.Functions.AddItem(randomItem, 1)
    --     TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
	-- 	else
	-- 		TriggerClientEvent('Framework:Notify', source, 'Túi của bạn đã đầy', "error")  
	-- 	end
	--     end
    -- end
end)

-- Edit tỏ lệ ra đá
-- RegisterServerEvent('pepe-mine:getItem')
-- AddEventHandler('pepe-mine:getItem', function()
-- 	local xPlayer, randomItem = Framework.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
-- 	local randomValue = math.random(1, 150)
-- 	if math.random(0, 100) <= Config.ChanceToGetItem then
-- 		local Item = xPlayer.Functions.GetItemByName(randomItem)
-- 		if Item == nil then
-- 			xPlayer.Functions.AddItem(randomItem, 1)
--             TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
-- 		else	
-- 		if Item.amount < 35 then
        
--         xPlayer.Functions.AddItem(randomItem, 1)
--         TriggerClientEvent('pepe-inventory:client:ItemBox', xPlayer.PlayerData.source, Framework.Shared.Items[randomItem], 'add')
-- 		else
-- 			TriggerClientEvent('Framework:Notify', source, 'Túi của bạn đã đầy', "error")  
-- 		end
-- 	    end
--     end
-- end)



RegisterServerEvent('pepe-mine:sell')
AddEventHandler('pepe-mine:sell', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    -- local RandomValue = math.random(1, 5)
    if Player ~= nil then
        --Vinh: ban item
        for k, v in pairs(Config.SellItems) do
            local Item = Player.Functions.GetItemByName(k)
            if Item ~= nil then
                if Item.amount > 0 then
                    local moneyReceived = v['Money'] * Item.amount
                    Player.Functions.RemoveItem(Item.name, Item.amount)
                    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Item.name], 'remove')
                    Player.Functions.AddMoney('cash', moneyReceived, 'sold-mine')
                    TriggerClientEvent("Framework:Notify", src, "Bạn đã bán "..Item.amount.."x "..Item.name..", bạn nhận được : "..moneyReceived.." $", "success", 4000)
                    Citizen.Wait(200)
                end
            end
        end
        --Vinh: end ban item

        -- if Player.Functions.RemoveItem("steel", 1) then
        --     TriggerClientEvent("Framework:Notify", src, "Bạn đã bán 1x Thép", "success", 1000)
        --     Player.Functions.AddMoney("cash", Config.pricexd.steel)
        --     Citizen.Wait(200)
        --     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['steel'], 'remove')
        -- else
        --     TriggerClientEvent("Framework:Notify", src, "Bạn không có vật phẩm để bán.", "error", 1000)
        -- end
        --     Citizen.Wait(1000)
        -- if Player.Functions.RemoveItem("iron", 1) then
        --     TriggerClientEvent("Framework:Notify", src, "Bạn đã bán 1x sắt", "success", 1000)
        --     Player.Functions.AddMoney("cash", Config.pricexd.iron)
        --     Citizen.Wait(200)
        --     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['iron'], 'remove')
        -- else
        --     TriggerClientEvent("Framework:Notify", src, "Bạn không có vật phẩm để bán.", "error", 1000)
        -- end
        --     Citizen.Wait(1000)
        -- if Player.Functions.RemoveItem("copper", 1) then
        --     TriggerClientEvent("Framework:Notify", src, "Bạn đã bán 1x đồng", "success", 1000)
        --     Player.Functions.AddMoney("cash", Config.pricexd.copper)
        --     Citizen.Wait(200)
        --     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['copper'], 'remove')
        -- else
        --     TriggerClientEvent("Framework:Notify", src, "Bạn không có vật phẩm để bán.", "error", 1000)
        -- end
        --     Citizen.Wait(1000)
        -- if Player.Functions.RemoveItem("diamond", 1) then
        --     TriggerClientEvent("Framework:Notify", src, "Bạn đã bán đường đá 1x", "success", 1000)
        --     Player.Functions.AddMoney("cash", Config.pricexd.diamond)
        --     Citizen.Wait(200)
        --     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['diamond'], 'remove')
        -- else
        --     TriggerClientEvent("Framework:Notify", src, "Bạn không có vật phẩm để bán.", "error", 1000)
        -- end
        --     Citizen.Wait(1000)
        -- if Player.Functions.RemoveItem("emerald", 1) then
        --     TriggerClientEvent("Framework:Notify", src, "Bạn đã bán 1x ngọc lục bảo", "success", 1000)
        --     Player.Functions.AddMoney("cash", Config.pricexd.emerald)
        --     Citizen.Wait(200)
        --     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['emerald'], 'remove')
        -- else
        --     TriggerClientEvent("Framework:Notify", src, "Bạn không có vật phẩm để bán.", "error", 1000)
        -- end
    end
end)
