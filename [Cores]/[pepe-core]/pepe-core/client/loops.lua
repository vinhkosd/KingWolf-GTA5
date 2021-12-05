Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if NetworkIsSessionStarted() then
			Citizen.Wait(10)
			TriggerServerEvent('Framework:PlayerJoined')
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait((1000 * 60) * 7)
			TriggerEvent("Framework:Player:UpdatePlayerData")
		else
			Citizen.Wait(5000)
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(7)
-- 		if isLoggedIn then
-- 			Citizen.Wait((1000 * 60) * 10)
-- 			TriggerEvent("Framework:Player:Salary")
-- 		else
-- 			Citizen.Wait(5000)
-- 		end
-- 	end
-- end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if isLoggedIn then
			Citizen.Wait((1000 * 60) * 10)
			TriggerEvent("Framework:Player:GetSalary")
			-- if Player.PlayerData.job.payment ~= nil and Player.PlayerData.job.payment ~= 0 then
			-- 	Player.Functions.AddMoney("bank", Player.PlayerData.job.payment)
			-- 	TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "warning", "Bạn vừa nhận lương ($"..Player.PlayerData.job.payment..")")
			-- 	end
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait(30000)
			local position = Framework.Functions.GetCoords(GetPlayerPed(-1))
			TriggerServerEvent('Framework:UpdatePlayerPosition', position)
		else
			Citizen.Wait(5000)
		end
	end
end)

-- // Food Enz \\ --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random(3000, 5000))
		if isLoggedIn then
			if Framework.Functions.GetPlayerData().metadata["hunger"] <= 1 or Framework.Functions.GetPlayerData().metadata["thirst"] <= 1 then
				if not Framework.Functions.GetPlayerData().metadata["isdead"] then
				 local CurrentHealth = GetEntityHealth(GetPlayerPed(-1))
				 SetEntityHealth(GetPlayerPed(-1), CurrentHealth - math.random(5, 10))
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon

	while true do
		Citizen.Wait(0)
		if IsEntityDead(GetPlayerPed(PlayerId())) then
			Citizen.Wait(0)
			local PedKiller = GetPedSourceOfDeath(GetPlayerPed(PlayerId()))
			local killername = GetPlayerName(PedKiller)
			DeathCauseHash = GetPedCauseOfDeath(GetPlayerPed(PlayerId()))
			Weapon = Config.WeaponNames[tostring(DeathCauseHash)]

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end

			if (Killer == PlayerId()) then
				DeathReason = 'committed suicide'
			elseif (Killer == nil) then
				DeathReason = 'died'
			else
				if Framework.Functions.IsMelee(DeathCauseHash) then
					DeathReason = 'murdered'
				elseif Framework.Functions.IsTorch(DeathCauseHash) then
					DeathReason = 'torched'
				elseif Framework.Functions.IsKnife(DeathCauseHash) then
					DeathReason = 'knifed'
				elseif Framework.Functions.IsPistol(DeathCauseHash) then
					DeathReason = 'pistoled'
				elseif Framework.Functions.IsSub(DeathCauseHash) then
					DeathReason = 'riddled'
				elseif Framework.Functions.IsRifle(DeathCauseHash) then
					DeathReason = 'rifled'
				elseif Framework.Functions.IsLight(DeathCauseHash) then
					DeathReason = 'machine gunned'
				elseif Framework.Functions.IsShotgun(DeathCauseHash) then
					DeathReason = 'pulverized'
				elseif Framework.Functions.IsSniper(DeathCauseHash) then
					DeathReason = 'sniped'
				elseif Framework.Functions.IsHeavy(DeathCauseHash) then
					DeathReason = 'obliterated'
				elseif Framework.Functions.IsMinigun(DeathCauseHash) then
					DeathReason = 'shredded'
				elseif Framework.Functions.IsBomb(DeathCauseHash) then
					DeathReason = 'bombed'
				elseif Framework.Functions.IsVeh(DeathCauseHash) then
					DeathReason = 'mowed over'
				elseif Framework.Functions.IsVK(DeathCauseHash) then
					DeathReason = 'flattened'
				else
					DeathReason = 'killed'
				end
			end

			if DeathReason == 'committed suicide' or DeathReason == 'died' then
				TriggerServerEvent('Framework:Server:OnPlayerDied', {
					type = 1, 
					player_id = GetPlayerServerId(PlayerId()), 
					death_reason = DeathReason, 
					weapon = Weapon
				})
			else
				TriggerServerEvent('Framework:Server:OnPlayerDied', {
					type = 2, 
					player_id = GetPlayerServerId(PlayerId()), 
					player_2_id = GetPlayerServerId(Killer), 
					death_reason = DeathReason, 
					weapon = Weapon
				})
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(0)
		end
	end
end)