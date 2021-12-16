-- SCRIPT DEVELOPED BY OSMIUM | OSMFX | DISCORD.IO/OSMFX --

Framework = nil
isSpawnedNPC = false

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
local ServerPrice = {}

Citizen.CreateThread(function()
    while true do
		for k, v in pairs(Config.SellItems) do
			ServerPrice[k] = v.PriceList[math.random(1, #v.PriceList)]
			print(k.." - "..ServerPrice[k])
        end
        Citizen.Wait(30 * 60 * 1000) -- 30 p doi gia 1 lan
		-- Citizen.Wait(20 * 1 * 1000) -- 30 p doi gia 1 lan
    end
end)


local playersProcessingCannabis = {}

RegisterServerEvent('pepe-farming:pickedUpCannabis')
AddEventHandler('pepe-farming:pickedUpCannabis', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	-- local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end
	local cornReceived = math.random(6, 9)
	if Player.Functions.AddItem('corn_kernel', cornReceived) then
		TriggerEvent("kingwolf-exp:addXP", src, cornReceived)
		Player.Functions.AddItem('corn_silk', 2)
		
		TriggerClientEvent("Framework:Notify", src, "Bạn nhận được "..cornReceived.." bắp ngô và 2 râu ngô!!", "Success", 3000)
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['corn_kernel'], "add")
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['corn_silk'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end
end)

RegisterServerEvent('pepe-farming:GivePlayerBox')
AddEventHandler('pepe-farming:GivePlayerBox', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	-- local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	if Player.Functions.AddItem('box', 2) then
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['box'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end
end)

RegisterServerEvent("pepe-farming:server:SellFarmingItems")
AddEventHandler("pepe-farming:server:SellFarmingItems", function()
    local src = source
    local price = 0.0
    local Player = Framework.Functions.GetPlayer(src)
	
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ServerPrice[Player.PlayerData.items[k].name] ~= nil then 
                    if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
						--remove được item xong mới cộng tiền
						price = price + (ServerPrice[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
					end
                end
            end
        end
		price = math.ceil(price)
        Player.Functions.AddMoney("cash", price, "sold-farm-items")
        TriggerClientEvent('Framework:Notify', src, "Bạn nhận được "..price.."$")
    end
end)

RegisterServerEvent('pepe-farming:CowMilked')
AddEventHandler('pepe-farming:CowMilked', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	if Player.Functions.AddItem('milk', Config.MilkOutput) then
		TriggerEvent("kingwolf-exp:addXP", src, Config.MilkOutput)
		TriggerClientEvent("Framework:Notify", src, "Lấy sữa thành công!", "Success", 4000)
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['milk'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end
end)

RegisterServerEvent('pepe-farming:ProcessCorn')
AddEventHandler('pepe-farming:ProcessCorn', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local LicenseItem = Player.Functions.GetItemByName('farm-license')

	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
	-- 	return
	-- end

	local item = Player.Functions.GetItemByName('corn_kernel')
	if item ~= nil then 
		if item.amount >= 5 then 
			if Player.Functions.RemoveItem('corn_kernel', 5) then
				Player.Functions.AddItem('corn_pack', 1)
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['corn_kernel'], "remove")
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['corn_pack'], "add")
				TriggerClientEvent('Framework:Notify', src, 'Đóng gói ngô thành công!', "success")
			else
				TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 5 quả ngô!', "error")
			end
		else 
			TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 5 quả ngô!', "error")   
		end     
	else    
		TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 5 quả ngô!', "error")   
	end                                                                				
end)

RegisterServerEvent('pepe-farming:ProcessOranges')
AddEventHandler('pepe-farming:ProcessOranges', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	local item = Player.Functions.GetItemByName('orange')
	if item ~= nil then 
		if item.amount >= 10 then 
			if Player.Functions.RemoveItem('orange', 10) then
				Player.Functions.RemoveItem('box', 1)
				Player.Functions.AddItem('fruit_pack', 1)
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['orange'], "remove")
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['fruit_pack'], "add")
				TriggerClientEvent('Framework:Notify', src, 'Đóng gói trái cây thành công!', "success")  
			else
				TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 10 quả cam!', "error")
			end 
		else 
			TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 10 quả cam!', "error")   
		end     
	else    
		TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 10 quả cam!', "error")   
	end                                                                				
end)

RegisterServerEvent('pepe-farming:ProcessMilk')
AddEventHandler('pepe-farming:ProcessMilk', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	local item = Player.Functions.GetItemByName('milk')
	if item ~= nil then 
		if item.amount >= 5 then 
			if Player.Functions.RemoveItem('milk', 5) then
				Player.Functions.RemoveItem('box', 1)
				Player.Functions.AddItem('milk_pack', 1)
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['milk'], "remove")
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['milk_pack'], "add")
				TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được 1 sữa đóng hộp!', "success")
			else   
				TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 5 xô sữa!!', "error") 
			end
		else 
			TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 5 xô sữa!!', "error")   
		end     
	else    
		TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 5 xô sữa!', "error")   
	end                                                                				
end)

RegisterServerEvent('pepe-farming:server:SpawnTractor')
AddEventHandler('pepe-farming:server:SpawnTractor', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	local cashamount = Player.PlayerData.money["cash"]

	if cashamount >= Config.TractorRent then
		Player.Functions.RemoveMoney('cash', Config.TractorRent) 
		TriggerClientEvent('SpawnTractor', src)
	else
		TriggerClientEvent('Framework:Notify', src, 'Bạn cần $'..Config.TractorRent..' để thuê máy kéo', "success")   
	end
end)

RegisterServerEvent('pepe-farming:GiveOranges')
AddEventHandler('pepe-farming:GiveOranges', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local LicenseItem = Player.Functions.GetItemByName('farm-license')

	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
	-- 	return
	-- end

	if Player.Functions.AddItem('orange', 3) then
		TriggerEvent("kingwolf-exp:addXP", src, 3)
		TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được 3 quả cam!', "success")   
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['orange'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end                                                                    				
end)

RegisterServerEvent('Server:UnRentTractor')
AddEventHandler('Server:UnRentTractor', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local LicenseItem = Player.Functions.GetItemByName('farm-license')

	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn phải có chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
	-- 	return
	-- end

	-- Player.Functions.RemoveMoney('bank', 1500, 'tractor')
	TriggerClientEvent('UnRentTractor', src)
end)

RegisterServerEvent('pepe-farming:GatLua')
AddEventHandler('pepe-farming:GatLua', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local LiemCatLuaItem = Player.Functions.GetItemByName('liemcatlua')

	if LiemCatLuaItem == nil then
		TriggerClientEvent('Framework:Notify', source, 'LỖI: Bạn cần liềm để cắt lúa, vui lòng mua liềm ở cửa hàng dụng cụ!', "error")
		return
	end

	if Player.Functions.AddItem('luami', 3) then
		-- TriggerEvent("kingwolf-exp:addXP", src, 3)
		TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được 3 lúa mì!', "success")   
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['luami'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end                                                                    				
end)

RegisterServerEvent('pepe-farming:XayLua')
AddEventHandler('pepe-farming:XayLua', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local item = Player.Functions.GetItemByName('luami')
	if item ~= nil then 
		if item.amount >= 5 then 
			if Player.Functions.RemoveItem('luami', 5) then
				Player.Functions.AddItem('hatluami', 5)
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['luami'], "remove")
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['hatluami'], "add")
				TriggerClientEvent('Framework:Notify', src, 'Xay lúa thành công!', "success")  
			else
				TriggerClientEvent('Framework:Notify', src, 'Bạn không có 5 lúa để xay!', "error")
			end 
		else 
			TriggerClientEvent('Framework:Notify', src, 'Bạn không có 5 lúa để xay!', "error")   
		end     
	else    
		TriggerClientEvent('Framework:Notify', src, 'Bạn không có 5 lúa để xay!', "error")   
	end                                                                				
end)

RegisterServerEvent('pepe-farming:DongGoiLua')
AddEventHandler('pepe-farming:DongGoiLua', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local item = Player.Functions.GetItemByName('hatluami')
	if item ~= nil then 
		if item.amount >= 10 then 
			if Player.Functions.RemoveItem('hatluami', 10) then
				Player.Functions.AddItem('baoluami', 1)
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['hatluami'], "remove")
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['baoluami'], "add")
				TriggerClientEvent('Framework:Notify', src, 'Đóng gói thành công!', "success")  
			else
				TriggerClientEvent('Framework:Notify', src, 'Bạn không có 10 lúa để đóng gói!', "error")
			end 
		else 
			TriggerClientEvent('Framework:Notify', src, 'Bạn không có 10 lúa để đóng gói!', "error")   
		end     
	else    
		TriggerClientEvent('Framework:Notify', src, 'Bạn không có 10 lúa để đóng gói!', "error")   
	end                                                                				
end)

function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('pepe-farming:cancelProcessing')
AddEventHandler('pepe-farming:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('pepe-farming:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('pepe-farming:onPlayerDeath')
AddEventHandler('pepe-farming:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)

Framework.Functions.CreateCallback('pepe-farming:server:GetSellingPrice', function(source, cb)
    local retval = 0.0
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ServerPrice[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ServerPrice[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                end
            end
        end
    end
	retval = math.ceil(retval)
    cb(retval)
end)

RegisterServerEvent('pepe-farming:server:spawnNPC')
AddEventHandler('pepe-farming:server:spawnNPC', function(data)
	TriggerClientEvent('pepe-farming:client:spawnNPC', -1)
end)

Framework.Functions.CreateCallback('pepe-farming:server:isSpawnedNPC', function(source, cb)
	if not isSpawnedNPC then
		isSpawnedNPC = true
	
    	cb(false)
	else 
		cb(true)
	end
end)
