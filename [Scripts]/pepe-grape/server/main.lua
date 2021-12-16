-- SCRIPT DEVELOPED BY OSMIUM | OSMFX | DISCORD.IO/OSMFX --

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-grape:ProcessGrapes')
AddEventHandler('pepe-grape:ProcessGrapes', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)

	local LicenseItem = Player.Functions.GetItemByName('farm-license')

	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
	-- 	return
	-- end

	local item = Player.Functions.GetItemByName('grape')
	if item ~= nil then 
		if item.amount >= 10 then 
			if Player.Functions.RemoveItem('grape', 10) then
				Player.Functions.AddItem('grape_box', 1)
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['grape'], "remove")
				TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['grape_box'], "add")
				TriggerClientEvent('Framework:Notify', src, 'Đóng gói nho thành công!', "success")  
			else
				TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 10 quả nho!', "error")
			end 
		else 
			TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 10 quả nho!', "error")   
		end     
	else    
		TriggerClientEvent('Framework:Notify', src, 'Bạn cần ít nhất 10 quả nho!', "error")   
	end                                                                				
end)

RegisterServerEvent('pepe-grape:GiveGrapes')
AddEventHandler('pepe-grape:GiveGrapes', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	
	local LicenseItem = Player.Functions.GetItemByName('farm-license')
	
	-- if LicenseItem == nil then
	-- 	TriggerClientEvent('Framework:Notify', source, 'LỖI: Vui lòng đăng ký chứng chỉ nghề trước khi đi farm tại các khu vực này!', "error")
    --     return
	-- end

	if Player.Functions.AddItem('grape', 3) then
		TriggerEvent("kingwolf-exp:addXP", src, 3)
		TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được 3 quả nho!', "success")   
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['grape'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end                                                                    				
end)
