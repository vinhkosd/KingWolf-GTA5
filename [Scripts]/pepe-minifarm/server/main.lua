-- SCRIPT DEVELOPED BY OSMIUM | OSMFX | DISCORD.IO/OSMFX --

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-minifarm:HaiBi')
AddEventHandler('pepe-minifarm:HaiBi', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	
	local RegisterItem = Player.Functions.GetItemByName('farm-register')
	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil and RegisterItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	if Player.Functions.AddItem('bingo', 3) then
		TriggerEvent("kingwolf-exp:addXP", src, 3)
		TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được 3 quả bí!', "success")   
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['bingo'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end                                                                    				
end)

RegisterServerEvent('pepe-minifarm:HaiCaChua')
AddEventHandler('pepe-minifarm:HaiCaChua', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	
	local RegisterItem = Player.Functions.GetItemByName('farm-register')
	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil and RegisterItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	if Player.Functions.AddItem('cachua', 3) then
		TriggerEvent("kingwolf-exp:addXP", src, 3)
		TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được 3 quả cà chua!', "success")   
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['cachua'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end                                                                    				
end)

RegisterServerEvent('pepe-minifarm:HaiBapCai')
AddEventHandler('pepe-minifarm:HaiBapCai', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	
	local RegisterItem = Player.Functions.GetItemByName('farm-register')
	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil and RegisterItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	if Player.Functions.AddItem('bapcai', 3) then
		TriggerEvent("kingwolf-exp:addXP", src, 3)
		TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được 3 quả bắp cải!', "success")   
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['bapcai'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end                                                                    				
end)