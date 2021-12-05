local Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterNetEvent('pepe-school:Betalendiemeuk')
AddEventHandler('pepe-school:Betalendiemeuk', function()
	local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
	local bankamount = xPlayer.PlayerData.money["bank"]

	if bankamount >= 300 then
		xPlayer.Functions.RemoveMoney('bank', 300)
	end
end)

Framework.Functions.CreateCallback('pepe-school:server:pay', function(source, cb)
	local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
	local cashamount = xPlayer.PlayerData.money["cash"]

	if cashamount >= 300 then
		if xPlayer.Functions.RemoveMoney('cash', 300) then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
	end
end)

Framework.Functions.CreateCallback('pepe-school:server:buyLicense', function(source, cb)
	local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
	local bankamount = xPlayer.PlayerData.money["bank"]

	if bankamount >= 20000 then
		if xPlayer.Functions.RemoveMoney('bank', 20000) then
            local info = {}
            info.firstname = xPlayer.PlayerData.charinfo.firstname
            info.lastname = xPlayer.PlayerData.charinfo.lastname
            info.birthdate = xPlayer.PlayerData.charinfo.birthdate
            info.type = "A1-A2-A | AM-B | C1-C-CE"


            xPlayer.Functions.AddItem('drive-card', 1, nil, info)

            TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['drive-card'], 'add')
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
	end
end)	



RegisterServerEvent('pepe-school:server:GetLicense')
AddEventHandler('pepe-school:server:GetLicense', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)


    local info = {}
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "A1-A2-A | AM-B | C1-C-CE"


    Player.Functions.AddItem('drive-card', 1, nil, info)

    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['drive-card'], 'add')
end)

