Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("closeradial", "Sluit je radialmenu waneer die vast zit.", {}, false, function(source, args)
   TriggerClientEvent('pepe-radialmenu:client:force:close', source)
end)

RegisterServerEvent('pepe-radialmenu:server:open:dispatch')
AddEventHandler('pepe-radialmenu:server:open:dispatch', function()
   local src = source
   local Player = Framework.Functions.GetPlayer(src)
   Citizen.SetTimeout(650, function()
      if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) or (Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty) then
         TriggerClientEvent('pepe-alerts:client:open:previous:alert', src, Player.PlayerData.job.name)
     end
   end)
end)

RegisterServerEvent('pepe-radialmenu:server:sendLogs')
AddEventHandler('pepe-radialmenu:server:sendLogs', function(data)
    local src = source
    local Player = Framework.Functions.GetPlayer(source)
    TriggerEvent("pepe-logs:server:SendLog", "default", "RadialMenu Trigger", "red", "**".. GetPlayerName(src) .. "** (BSN: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) ".." đã **triggerEvent** không hợp lệ: **" ..json.encode(data).."**")
end)

Framework.Functions.CreateCallback('pepe-radialmenu:server:HasItem', function(source, cb, itemName)
    local Player = Framework.Functions.GetPlayer(source)
    if Player ~= nil then
      local Item = Player.Functions.GetItemByName(itemName)
      if Item ~= nil then
			  cb(true)
      else
			  cb(false)
      end
	end
end)