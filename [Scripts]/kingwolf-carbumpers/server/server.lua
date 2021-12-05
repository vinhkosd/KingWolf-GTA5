Framework= nil

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)


RegisterServerEvent('kingwolf-carbumpers:server:Checklambo')
AddEventHandler('kingwolf-carbumpers:server:Checklambo', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    local payCash = 250
	if Player.Functions.RemoveMoney("cash", payCash) then
		TriggerClientEvent("kingwolf-carbumpers:client:spawn:vehicle", src)
	else
		TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền thuê xe ("..payCash.."$)!!", "error", 5000)
	end
end)
