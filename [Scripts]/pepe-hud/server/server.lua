Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-hud:server:gain:stress')
AddEventHandler('pepe-hud:server:gain:stress', function(Amount)
    local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
	  local NewStress = Player.PlayerData.metadata["stress"] + Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 100 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("pepe-hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

RegisterServerEvent('pepe-hud:server:remove:stress')
AddEventHandler('pepe-hud:server:remove:stress', function(Amount)
    local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
	  local NewStress = Player.PlayerData.metadata["stress"] - Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 100 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("pepe-hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

Framework.Commands.Add("cash", "Kijk hoeveel geld je bij je hebt", {}, false, function(source, args)
    TriggerClientEvent('pepe-hud:client:show:cash', source)
end)

Framework.Commands.Add("players", "Kijk hoeveel spelers er online zijn", {}, false, function(source, args)
	TriggerClientEvent('pepe-hud:client:show:current:players', source)
end)