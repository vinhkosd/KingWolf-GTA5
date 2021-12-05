-- Player joined
RegisterServerEvent("Framework:PlayerJoined")
AddEventHandler('Framework:PlayerJoined', function()
	local src = source
end)


RegisterServerEvent("Framework:GetSalary")
AddEventHandler('Framework:GetSalary', function(data)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil and Player.PlayerData.job ~= nil and Player.PlayerData.job.onduty and Player.PlayerData.job.payment > 0 then
		Player.Functions.AddMoney("cash", Player.PlayerData.job.payment)
		TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "warning", "Bạn vừa nhận lương ($ "..Player.PlayerData.job.payment..")")
	end
end)

Citizen.CreateThread(function()
	print("\x1b[32m[pepe-core:LOG]\x1b[0m salaryevents.lua")
end)