
Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)


RegisterServerEvent('wood:getItem')
AddEventHandler('wood:getItem', function()
	local src = source
	local xPlayer, randomItem = Framework.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	local Item = xPlayer.Functions.GetItemByName('wood-hachet')

	local LicenseItem = xPlayer.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end
	
	if Item == nil then
		TriggerClientEvent('Framework:Notify', source, 'Bạn không có rìu chặt gỗ, hãy ra cửa hàng dụng cụ để mua rìu chặt gỗ!', "error")
		return
	end

	if math.random(0, 100) <= Config.ChanceToGetItem then -- 20% get đc gỗ
		-- local randomSomeItem = math.random(1, 75)
		-- if randomSomeItem == 1 then
		-- 	--150 gỗ nhận sẽ random ra 1 sơn
		-- 	xPlayer.Functions.AddItem("spray", 1)
		-- end
		TriggerEvent("kingwolf-exp:addXP", src, 1)
		local Item = xPlayer.Functions.GetItemByName('wood_cut')
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
			TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items[randomItem], "add")
		else
		if xPlayer.Functions.AddItem(randomItem, 1) then
			-- xPlayer.Functions.AddItem(randomItem, 1)
			TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items[randomItem], "add")
		else
			TriggerClientEvent('Framework:Notify', source, 'Túi đã đầy không thể chặt gỗ!', "error")  
		end
		
	    end
    end
end)

RegisterServerEvent('wood_weed:processweed2')
AddEventHandler('wood_weed:processweed2', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	-- local Item = Player.Functions.GetItemByName(k)
	-- local Item = Player.Functions.GetItemByName('wood_cut')
	local Item = Player.Functions.GetItemByName('wood_cut')
	local Item2 = Player.Functions.GetItemByName('wood_proc')
	-- local RandomValue = math.random(1, 5)
	if Item ~= nil then
		if Item.amount >= 10 then
			if Player.Functions.RemoveItem('wood_cut', 10) then
				Player.Functions.AddItem('wood_proc', 10)
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['wood_cut'], "remove")
		
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['wood_proc'], "add")
				TriggerClientEvent('Framework:Notify', src, 'Bạn đã chế biến 10 gỗ xẻ!', "success")
			end
		else
				TriggerClientEvent("Framework:Notify", src, "Bạn không có đủ gỗ để xẻ!", "error", 4000)
		end
	else
		TriggerClientEvent("Framework:Notify", src, "Bạn không có đủ gỗ để xẻ!", "error", 4000)
	end
	-- if Player.Functions.GetItemByName('wood_cut') then
		
	-- 	Player.Functions.AddItem('wood_proc', 1)
	-- 	TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['wood_cut'], "remove")

	-- 	TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['wood_proc'], "add")
	-- 	TriggerClientEvent('Framework:Notify', src, 'Wood processed', "success")
	-- else
	-- 	TriggerClientEvent('Framework:Notify', src, 'You dont have the right items', "error") 
	-- end
end)

RegisterServerEvent('wood:sell')
AddEventHandler('wood:sell', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    -- for k, v in pairs(Player.PlayerData.items) do
    --     if v.name == 'wood_proc' then
	-- 		local moneyReceived = math.random(Config.WoodMinSell, Config.WoodMaxSell)
    --         Player.Functions.RemoveItem('wood_proc', 1)
    --         Player.Functions.AddMoney('cash', moneyReceived, 'sold-wood')
    --         TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['wood_proc'], "remove")
    --     end
	   -- end
	local Item = Player.Functions.GetItemByName('wood_proc')
	if Item ~= nil then
		if Item.amount > 0 then
		local WoodPriceSell = 35
		local moneyReceived = WoodPriceSell * Item.amount
		if Player.Functions.RemoveItem('wood_proc', Item.amount) then
			Player.Functions.AddMoney('cash', moneyReceived, 'sold-wood')
			TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['wood_proc'], "remove")
			TriggerClientEvent("Framework:Notify", src, "Bạn đã bán "..Item.amount.."x "..Item.name..", bạn nhận được : "..moneyReceived.." $", "success", 4000)
		end
		end
	else
		TriggerClientEvent("Framework:Notify", src, "Bạn không có gỗ để bán!", "error", 4000)
	end
end)

local prezzo = 10
RegisterServerEvent('pepe-jobwood:server:truck')
AddEventHandler('pepe-jobwood:server:truck', function(boatModel, BerthId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local plate = "WOOD"..math.random(1111, 9999)
    
	-- TriggerClientEvent('pepe-jobwood:Auto', src, boatModel, plate)
end)
