Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-assets:server:tackle:player')
AddEventHandler('pepe-assets:server:tackle:player', function(playerId)
    TriggerClientEvent("pepe-assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('pepe-assets:server:display:text')
AddEventHandler('pepe-assets:server:display:text', function(Text)
	TriggerClientEvent('pepe-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('pepe-assets:server:drop')
AddEventHandler('pepe-assets:server:drop', function()
	if not Framework.Functions.HasPermission(source, 'admin') then
		TriggerEvent("pepe-logs:server:SendLog", "anticheat", "Nui Devtools", "red", "**".. GetPlayerName(source).. "** Tried to activate the NUI_Devtools.")
		DropPlayer(source, '\nYou are not supposed to open the devtools..')
	end
end)

RegisterServerEvent('pepe-assets:server:display:chatme')
AddEventHandler('pepe-assets:server:display:chatme', function(Text, coords)
	TriggerClientEvent('pepe-assets:client:display:chatme', -1, Text, coords, source)
end)

Framework.Commands.Add("shuff", "Van stoel schuiven", {}, false, function(source, args)
 TriggerClientEvent('pepe-assets:client:seat:shuffle', source)
end)

Framework.Commands.Add("me", "Chat gần", {}, false, function(source, args)
  local Text = table.concat(args, ' ')
  TriggerClientEvent('pepe-assets:client:me:init', source, Text, source)
end)

Framework.Commands.Add("id", "Check id của bạn?", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "warning", "ID: "..source)
end)

Framework.Commands.Add("carblacklist", "Bật/Tắt blacklistcar", {}, false, function(source, args)
    TriggerClientEvent('pepe-assets:client:turnoffblacklist', -1)
end, "admin")