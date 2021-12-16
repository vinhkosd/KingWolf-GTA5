Framework= nil

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)


RegisterServerEvent('kingwolf-tanks:server:Checktank')
AddEventHandler('kingwolf-tanks:server:Checktank', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    local payCash = 2500
	if Player.Functions.RemoveMoney("cash", payCash) then
		TriggerClientEvent("kingwolf-tanks:client:spawn:vehicle", src)
	else
		TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền thuê xe Tank ("..payCash.."$)!!", "error", 5000)
	end
end)
