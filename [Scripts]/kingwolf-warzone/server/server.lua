Framework= nil

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

RegisterServerEvent('kingwolf-warzone:server:RemoveInventory')
AddEventHandler('kingwolf-warzone:server:RemoveInventory', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("lastwarzoneitems", Player.PlayerData.items)
	Player.Functions.ClearInventory()
	TriggerEvent("pepe-logs:server:SendLog", "default", "Warzone event", "red", "**".. GetPlayerName(src) .. "** (BSN: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) ".." đã rời khỏi WarZone")
end)

RegisterServerEvent('kingwolf-warzone:server:CheckRental')
AddEventHandler('kingwolf-warzone:server:CheckRental', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    local payCash = 1000
	if Player.Functions.RemoveMoney("cash", payCash) then
		TriggerClientEvent("kingwolf-warzone:client:spawn:vehicle", src)
	else
		TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền thuê xe ("..payCash.."$)!!", "error", 5000)
	end
end)

RegisterServerEvent('kingwolf-warzone:server:CheckRental2')
AddEventHandler('kingwolf-warzone:server:CheckRental2', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    local payCash = 50000
	if Player.Functions.RemoveMoney("cash", payCash) then
		TriggerClientEvent("kingwolf-warzone:client:spawn:vehicle2", src)
	else
		TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền thuê xe ("..payCash.."$)!!", "error", 5000)
	end
end)

RegisterServerEvent('kingwolf-warzone:server:CheckRental3')
AddEventHandler('kingwolf-warzone:server:CheckRental3', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    local payCash = 500000
	if Player.Functions.RemoveMoney("cash", payCash) then
		TriggerClientEvent("kingwolf-warzone:client:spawn:vehicle3", src)
	else
		TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền thuê xe ("..payCash.."$)!!", "error", 5000)
	end
end)