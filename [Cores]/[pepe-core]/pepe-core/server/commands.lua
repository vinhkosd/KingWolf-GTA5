Framework.Commands = {}
Framework.Commands.List = {}

Framework.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	Framework.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

Framework.Commands.Refresh = function(source)
	local Player = Framework.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(Framework.Commands.List) do
			if Framework.Functions.HasPermission(source, "god") or Framework.Functions.HasPermission(source, Framework.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

Framework.Commands.Add("tp", "Dịch chuyển đến một người chơi hoặc tọa độ", {{name="id/x", help="ID van een Player of X positie"}, {name="y", help="Y positie"}, {name="z", help="Z positie"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		-- tp to player
		local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('Framework:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('Framework:Command:TeleportToCoords', source, x, y, z)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Nhập đúng định dạng (x, y, z)")
		end
	end
end, "admin")

Framework.Commands.Add("addpermission", "Give permission to someone (god/admin)", {{name="id", help="ID Player"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		Framework.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")	
	end
end, "god")

Framework.Commands.Add("removepermission", "Remove permission from someone", {{name="id", help="ID Player"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Framework.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")	
	end
end, "god")

Framework.Commands.Add("refreshperm", "Refresh perms", {}, true, function(source, args)
	Framework.Functions.RefreshPerms()
	TriggerClientEvent('chatMessage', source, "SYSTEM", "success", "Reset phân quyền thành công!")
end, "admin")

Framework.Commands.Add("sv", "Spawn xe", {{name="model", help="Vehicle model name"}}, true, function(source, args)
	TriggerClientEvent('Framework:Command:SpawnVehicle', source, args[1])
end, "god")

Framework.Commands.Add("debug", "Turn on/off debug mode", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

Framework.Commands.Add("closenui", "Turn off a nui screen", {}, false, function(source, args)
	TriggerClientEvent('pepe-core:client:closenui', source)
end)

Framework.Commands.Add("opennui", "Open a nui screen", {}, false, function(source, args)
	TriggerClientEvent('pepe-core:client:opennui', source)
end)

Framework.Commands.Add("dv", "Delete a vehicle", {}, false, function(source, args)
	TriggerClientEvent('Framework:Command:DeleteVehicle', source)
end, "admin")

Framework.Commands.Add("tpm", "Teleport to waypoint", {}, false, function(source, args)
	TriggerClientEvent('Framework:Command:GoToMarker', source)
end, "admin")

Framework.Commands.Add("tpmh", "Teleport to waypoint with high landing", {}, false, function(source, args)
	TriggerClientEvent('Framework:Command:GoToMarkerHighLanding', source)
end, "admin")

Framework.Commands.Add("givemoney", "Give money to a Player", {{name="id", help="Player ID"},{name="moneytype", help="Type geld (cash, bank, crypto)"}, {name="amount", help="Money amount"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
	end
end, "god")

Framework.Commands.Add("duatien", "Đưa tiền cho người chơi", {{name="id", help="ID người chơi"}, {name="amount", help="Số tiền"}}, true, function(source, args)	
	local Player = Framework.Functions.GetPlayer(source)
	local OtherPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
	local Amount = tonumber(args[2])
	if Player ~= nil and OtherPlayer ~= nil then
		local CurrentCash = Player.PlayerData.money['cash']		
		-- playerId = tonumber(args[1])		
		if CurrentCash - Amount < 0 then
			TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Bạn không đủ tiền mặt")
		elseif CurrentCash - Amount >= 0 then
			if OtherPlayer ~= nil then
				Player.Functions.RemoveMoney("cash", Amount)
				TriggerClientEvent("Framework:Notify", source, "Bạn đã đưa $"..Amount.." cho người chơi: "..OtherPlayer.PlayerData.source.."!" , "success")
				OtherPlayer.Functions.AddMoney("cash", Amount)
				TriggerClientEvent("Framework:Notify", OtherPlayer.PlayerData.source, "Bạn đã nhận được $"..Amount.." từ: "..source.."!", "success")
			else
				TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Người chơi không online.")
				TriggerClientEvent("Framework:Notify", source, "Người chơi không online." , "error")
			end
		end
	else
		TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Người chơi không online.")
	end
end, "user")

Framework.Commands.Add("setmoney", "Set Player Money", {{name="id", help="Player ID"},{name="moneytype", help="Type money (cash, bank, crypto)"}, {name="amount", help="Money amount"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
	end
end, "god")

Framework.Commands.Add("setjob", "Give a job to a player", {{name="id", help="ID người chơi"}, {name="job", help="Tên công việc"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		if not Player.Functions.SetJob(tostring(args[2]), args[3]) then
			TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Job format incorrect")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")
	end
end, "admin")

Framework.Commands.Add("job", "Kiểm tra nghề và cấp bậc", {}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
	local duty = ""
	if Player.PlayerData.job.onduty then
		duty = "Trong ca"
	else
		duty = "Hết ca"
	end
	
	local grade = (Player.PlayerData.job.grade ~= nil and Player.PlayerData.job.grade.name ~= nil) and Player.PlayerData.job.grade.name or 'No Grades'
	TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message" style="background-color: rgba(219, 52, 235, 0.75);"><b>Thông tin nghề nghiệp</b> {0} [{1}] | {2}</div>',
    	args = { Player.PlayerData.job.label, duty, grade}
	})
end)

Framework.Commands.Add("clearinv", "Clear Player Inventory", {{name="id", help="Player ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = Framework.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
	end
end, "god")

Framework.Commands.Add("ooc", "Out of character message to citizens around you", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("Framework:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message)
	local Players = Framework.Functions.GetPlayers()

	for k, v in pairs(Framework.Functions.GetPlayers()) do
		if Framework.Functions.HasPermission(v, "admin") then
			if Framework.Functions.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC | " .. GetPlayerName(source), "normal", message)
			end
		end
	end
end)

Citizen.CreateThread(function()
	print("\x1b[32m[pepe-core:LOG]\x1b[0m commands.lua")
end)