Framework = nil

local CoolDownBringPeds = {}

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)



RegisterServerEvent('pepe-hospital:server:set:state')
AddEventHandler('pepe-hospital:server:set:state', function(type, state)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData(type, state)
	end
end)


RegisterServerEvent('pepe-hospital:server:hospital:respawn')
AddEventHandler('pepe-hospital:server:hospital:respawn', function()
	local Player = Framework.Functions.GetPlayer(source)
	local src = source
	Player.Functions.RemoveMoney('bank', Config.BedPayment, 'Hospital')
	TriggerClientEvent('pepe-hospital:client:SendBillEmail', src, Config.BedPayment)
end)

RegisterServerEvent('pepe-hospital:server:dead:respawn')
AddEventHandler('pepe-hospital:server:dead:respawn', function()
	local Player = Framework.Functions.GetPlayer(source)
	-- Player.Functions.ClearInventory()
	if(getDoctors() > 0) then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('Framework:Notify', source, 'Vì không có bác sĩ nào online nên bạn vẫn được giữ lại đồ khi hồi sinh!', 'success')
	end
	
	Citizen.SetTimeout(250, function()
		Player.Functions.Save()
	end)
	Player.Functions.RemoveMoney('bank', Config.RespawnPrice, 'respawn-fund')
end)

RegisterServerEvent('pepe-hospital:server:save:health:armor')
AddEventHandler('pepe-hospital:server:save:health:armor', function(PlayerHealth, PlayerArmor)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData('health', PlayerHealth)
		Player.Functions.SetMetaData('armor', PlayerArmor)
	end
end)

RegisterServerEvent('pepe-hospital:server:revive:player')
AddEventHandler('pepe-hospital:server:revive:player', function(PlayerId)
	local TargetPlayer = Framework.Functions.GetPlayer(PlayerId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('pepe-hospital:client:revive', TargetPlayer.PlayerData.source, true, true)
	end
end)

RegisterServerEvent('pepe-hospital:server:heal:player')
AddEventHandler('pepe-hospital:server:heal:player', function(TargetId)
	local TargetPlayer = Framework.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('pepe-hospital:client:heal', TargetPlayer.PlayerData.source)
	end
end)

RegisterServerEvent('pepe-hospital:server:SendDoctorAlert')
AddEventHandler('pepe-hospital:server:SendDoctorAlert', function()
	local src = source
	for k, v in pairs(Framework.Functions.GetPlayers()) do
		local Player = Framework.Functions.GetPlayer(v)
		if Player ~= nil then 
			if ((Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
				TriggerClientEvent("pepe-hospital:client:SendAlert", v, "Một bác sĩ là cần thiết tại Bệnh viện Pillbox Tầng 1")
			end
		end
	end
end)

RegisterServerEvent('pepe-hospital:server:SetDoctor')
AddEventHandler('pepe-hospital:server:SetDoctor', function()
	local amount = 0
	for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	TriggerClientEvent("pepe-hospital:client:SetDoctorCount", -1, amount)
end)

RegisterServerEvent('pepe-hospital:server:take:blood:player')
AddEventHandler('pepe-hospital:server:take:blood:player', function(TargetId)
	local src = source
	local SourcePlayer = Framework.Functions.GetPlayer(src)
	local TargetPlayer = Framework.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
	 local Info = {vialid = math.random(11111,99999), vialname = TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname, bloodtype = TargetPlayer.PlayerData.metadata['bloodtype'], vialbsn = TargetPlayer.PlayerData.citizenid}
	 SourcePlayer.Functions.AddItem('bloodvial', 1, false, Info)
	 TriggerClientEvent('pepe-inventory:client:ItemBox', SourcePlayer.PlayerData.source, Framework.Shared.Items['bloodvial'], "add")
	end
end)

RegisterServerEvent('pepe-hospital:server:set:bed:state')
AddEventHandler('pepe-hospital:server:set:bed:state', function(BedData, bool)
	Config.Beds[BedData]['Busy'] = bool
	TriggerClientEvent('pepe-hospital:client:set:bed:state', -1 , BedData, bool)
end)

RegisterServerEvent('pepe-hospital:server:UpdateBlips')
AddEventHandler('pepe-hospital:server:UpdateBlips', function()
    local src = source
    local dutyPlayers = {}
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
                    job = Player.PlayerData.job.name,
                })
            end
        end
    end
    TriggerClientEvent("pepe-hospital:client:UpdateBlips", -1, dutyPlayers)
end)

Framework.Functions.CreateCallback('pepe-hospital:GetDoctors', function(source, cb)
	local amount = 0
	for k, v in pairs(Framework.Functions.GetPlayers()) do
		local Player = Framework.Functions.GetPlayer(v)
		if Player ~= nil then 
			if ((Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
				amount = amount + 1
			end
		end
	end
	cb(amount)
end)

Framework.Functions.CreateCallback("pepe-hospital:server:get:cooldown", function(source, cb)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local CitizenId = xPlayer.PlayerData.citizenid
	local coolDown = 0
	if CoolDownBringPeds[CitizenId] ~= nil then
		coolDown = CoolDownBringPeds[CitizenId] - GetGameTimer()
	end
	if coolDown < 0 then
		CoolDownBringPeds[CitizenId] = 0
	end
	cb(coolDown)
  end)
  
  RegisterServerEvent('pepe-hospital:server:create:cooldown')
  AddEventHandler('pepe-hospital:server:create:cooldown', function()
	local xPlayer = Framework.Functions.GetPlayer(source)
	local CitizenId = xPlayer.PlayerData.citizenid
	local addCoolDowns = 5 * 60 * 1000
	CoolDownBringPeds[CitizenId] = GetGameTimer() + addCoolDowns
  end)
  

Framework.Commands.Add("revive", "Hồi sinh một người chơi hoặc chính bạn", {{name="id", help="ID người chơi"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('pepe-hospital:client:revive', Player.PlayerData.source, true, true)
		else
			TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Người chơi không trực tuyến!")
		end
	else
		TriggerClientEvent('pepe-hospital:client:revive', source, true, true)
	end
end, "admin")

Framework.Commands.Add("setems", "Thuê một ai đó như EMS", {{name="id", help="ID người chơi"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Bạn đã được thuê như một lời chúc mừng của EMS!', 'success')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Bạn đã thuê'..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' như ems.!', 'success')
          TargetPlayer.Functions.SetJob('ambulance', 0)
      end
    end
end)

Framework.Commands.Add("fireems", "Sa thải một cá nhân", {{name="id", help="ID người chơi"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Bạn bị sa thải từ công việc cuối cùng của bạn!', 'error')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Bạn đã bắn '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..'!', 'success')
          TargetPlayer.Functions.SetJob('unemployed', 0)
      end
    end
end)

Framework.Commands.Add("keoxac", "Kéo xác id người chơi nhất định", {{name="id", help="ID người chơi"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
	if TargetPlayer ~= nil then
		print(Player.PlayerData.job.name)
		if Player.PlayerData.job.name == "ambulance" then
			local coolDownBringPed = getCoolDownPed(Player.PlayerData.citizenid)
			if coolDownBringPed > 0 then
				local remainingseconds = (coolDownBringPed) / 1000
				local hoursRemaining = math.floor(remainingseconds/3600)
				local minutesRemaining = math.floor((remainingseconds - hoursRemaining * 3600)/60)
				local secondsRemaining = math.floor((remainingseconds - hoursRemaining * 3600 - minutesRemaining * 60))
				
				local remainingTimeText = hoursRemaining.." giờ, "..minutesRemaining.." phút, "..secondsRemaining.." giây"
				TriggerClientEvent('Framework:Notify', source, "Vui lòng chờ thêm 5 phút (còn "..remainingTimeText.." )", 'error')
				return
			else
				TriggerClientEvent('pepe-hospital:client:bring:ped', source, TargetPlayer.PlayerData.source)
				Citizen.Wait(500)
				TriggerClientEvent("pepe-police:client:get:escorted", TargetPlayer.PlayerData.source, Player.PlayerData.source)
				TriggerClientEvent("pepe-hospital:client:lagxac", TargetPlayer.PlayerData.source)
				
				TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, "Bạn được bác sĩ tìm thấy xác", 'error')
			end
		end
	end
end)

Framework.Commands.Add("lagxac", "Lag xác", {}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		TriggerClientEvent("pepe-hospital:client:lagxac", Player.PlayerData.source)
	end
end)

Citizen.CreateThread(function()
	while true do 
	  Citizen.Wait(0)
	  local CurrentDoctors = getDoctors()
	  TriggerClientEvent("pepe-hospital:SetDoctorsCount", -1, CurrentDoctors)
	  Citizen.Wait(1000 * 60 * 1)--1p set số lượng bs 1 lần
	end
end)

function getDoctors() 
	local amount = 0
	for k, v in pairs(Framework.Functions.GetPlayers()) do
		local Player = Framework.Functions.GetPlayer(v)
		if Player ~= nil then 
			if ((Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
				amount = amount + 1
			end
		end
	end
	return amount
end

function getCoolDownPed(CitizenId)
	local coolDown = 0
	if CoolDownBringPeds[CitizenId] ~= nil then
		coolDown = CoolDownBringPeds[CitizenId] - GetGameTimer()
	end
	if coolDown < 0 then
		CoolDownBringPeds[CitizenId] = 0
	end
	return coolDown
end