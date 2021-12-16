-- ESX = nil

-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- xPlayer.charinfo.account

Framework.Functions.CreateCallback("okokBanking:GetPlayerInfo", function(source, cb)
	local xPlayer = Framework.Functions.GetPlayer(source)
	-- ExecuteSql('SELECT * FROM users WHERE identifier = @identifier', {
	-- 	['@identifier'] = xPlayer.PlayerData.citizenid
	-- }, function(result)
	-- 	local db = result[1]
	-- 	local sex = "m"

	-- 	if Framework.Functions.GetPlayerData().charinfo.gender == 1 then
    --         sex = "f"
    --     end

	-- 	local data = {
	-- 		playerName = GetPlayerName(_source),
	-- 		playerBankMoney = xPlayer.PlayerData.money.bank,
	-- 		playerIBAN = xPlayer.charinfo.account,
	-- 		walletMoney = xPlayer.PlayerData.money.cash,
	-- 		sex = sex,
	-- 	}

	-- 	cb(data)
	-- end)

	local xPlayer = Framework.Functions.GetPlayer(source)
	if xPlayer ~= nil then
		local sex = "m"

		if xPlayer.PlayerData.charinfo.gender == 1 then
            sex = "f"
        end

		local data = {
			playerName = GetPlayerName(source),
			playerBankMoney = xPlayer.PlayerData.money.bank,
			playerIBAN = xPlayer.PlayerData.charinfo.account,
			walletMoney = xPlayer.PlayerData.money.cash,
			sex = sex,
		}

		cb(data)
	end
end)

Framework.Functions.CreateCallback("okokBanking:IsIBanUsed", function(source, cb, iban)
	local xPlayer = Framework.Functions.GetPlayer(source)
	
	ExecuteSql("SELECT * FROM `characters_metadata` WHERE `charinfo` LIKE '%"..iban.."%'", {}, function(result)
		local db = result[1]
		if db ~= nil then
			
			cb(db, true)
		else
			ExecuteSql('SELECT * FROM okokBanking_societies WHERE iban = @iban', {
				['@iban'] = iban
			}, function(result2)
				local db2 = result2[1]
				
				cb(db2, false)
			end)
		end
	end)
end)

Framework.Functions.CreateCallback("okokBanking:GetPIN", function(source, cb)
	local xPlayer = Framework.Functions.GetPlayer(source)

	cb(xPlayer.PlayerData.metadata["pincode"])
	-- if xPlayer.PlayerData.metadata["pincode"] ~= nil then
		-- cb(xPlayer.PlayerData.metadata["pincode"])
	-- end
	-- ExecuteSql('SELECT pincode FROM users WHERE identifier = @identifier', {
	-- 	['@identifier'] = xPlayer.PlayerData.citizenid,
	-- }, function(result)
	-- 	local pin = result[1]

	-- 	cb(pin.pincode)
	-- end)
end)

Framework.Functions.CreateCallback("okokBanking:SocietyInfo", function(source, cb, society)
	ExecuteSql('SELECT * FROM okokBanking_societies WHERE society = @society', {
		['@society'] = society
	}, function(result)
		local db = result[1]
		cb(db)
	end)
end)

RegisterServerEvent("okokBanking:CreateSocietyAccount")
AddEventHandler("okokBanking:CreateSocietyAccount", function(society, society_name, value, iban)
	ExecuteSql('INSERT INTO okokBanking_societies (society, society_name, value, iban) VALUES (@society, @society_name, @value, @iban)', {
		['@society'] = society,
		['@society_name'] = society_name,
		['@value'] = value,
		['@iban'] = iban:upper(),
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:SetIBAN")
AddEventHandler("okokBanking:SetIBAN", function(iban)
	local xPlayer = Framework.Functions.GetPlayer(source)

	xPlayer.PlayerData.charinfo.account = iban
	-- ExecuteSql('UPDATE users SET iban = @iban WHERE identifier = @identifier', {
	-- 	['@identifier'] = xPlayer.PlayerData.citizenid,
	-- 	['@iban'] = iban,
	-- }, function (result)
	-- end)
end)

RegisterServerEvent("okokBanking:DepositMoney")
AddEventHandler("okokBanking:DepositMoney", function(amount)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local playerMoney = xPlayer.PlayerData.money.cash

	if amount <= playerMoney then
		xPlayer.Functions.RemoveMoney('cash', amount)
		xPlayer.Functions.AddMoney('bank', amount)

		TriggerEvent('okokBanking:AddDepositTransaction', amount, xPlayer.PlayerData.source)
		TriggerClientEvent('okokBanking:updateTransactions', xPlayer.PlayerData.source, xPlayer.PlayerData.money.bank, xPlayer.PlayerData.money.cash)
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have deposited "..amount.."$", 5000, 'success')
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You don't have that much money on you", 5000, 'error')
	end
end)

RegisterServerEvent("okokBanking:WithdrawMoney")
AddEventHandler("okokBanking:WithdrawMoney", function(amount)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local playerMoney = xPlayer.PlayerData.money.bank

	if amount <= playerMoney then
		xPlayer.Functions.RemoveMoney('bank', amount)
		xPlayer.Functions.AddMoney('cash', amount)

		TriggerEvent('okokBanking:AddWithdrawTransaction', amount, xPlayer.PlayerData.source)
		TriggerClientEvent('okokBanking:updateTransactions', xPlayer.PlayerData.source, xPlayer.PlayerData.money.bank, xPlayer.PlayerData.money.cash)
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have withdrawn "..amount.."$", 5000, 'success')
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You don't have that much money on the bank", 5000, 'error')
	end
end)

RegisterServerEvent("okokBanking:TransferMoney")
AddEventHandler("okokBanking:TransferMoney", function(amount, ibanNumber, targetIdentifier, acc, targetName)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local xTarget = Framework.Functions.GetPlayerByCitizenId(targetIdentifier)
	local xPlayers = Framework.Functions.GetPlayers()
	local playerMoney = xPlayer.PlayerData.money.bank
	ibanNumber = ibanNumber:upper()
	if xPlayer.PlayerData.citizenid ~= targetIdentifier then
		if amount <= playerMoney then
			
			if xTarget ~= nil then
				xPlayer.Functions.RemoveMoney('bank', amount, "transfer-money-to"..xTarget.PlayerData.citizenid)
				-- xTarget.addAccountMoney('bank', amount)
				xTarget.Functions.AddMoney('bank', amount, "transfer-get-money-from"..xPlayer.PlayerData.citizenid)

				for i=1, #xPlayers, 1 do
				    local xForPlayer = Framework.Functions.GetPlayer(xPlayers[i])
				    if xForPlayer.PlayerData.citizenid == targetIdentifier then

				    	TriggerClientEvent('okokBanking:updateTransactions', xPlayers[i], xTarget.getAccount('bank').money, xTarget.PlayerData.money.cash)
				    	TriggerClientEvent('okokNotify:Alert', xPlayers[i], "BANK", "You have received "..amount.."$ from "..GetPlayerName(source), 5000, 'success')
				    end
				end
				TriggerEvent('okokBanking:AddTransferTransaction', amount, xTarget, xPlayer.PlayerData.source)
				TriggerClientEvent('okokBanking:updateTransactions', xPlayer.PlayerData.source, xPlayer.PlayerData.money.bank, xPlayer.PlayerData.money.cash)
				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have transferred "..amount.."$ to "..xTarget.getName(), 5000, 'success')
			elseif xTarget == nil then
				local playerAccount = json.decode(acc)
				playerAccount.bank = math.floor(playerAccount.bank + amount)
				playerAccount = json.encode(playerAccount)

				xPlayer.Functions.RemoveMoney('bank', amount)

				TriggerEvent('okokBanking:AddTransferTransaction', amount, xTarget, xPlayer.PlayerData.source, targetName, targetIdentifier)
				TriggerClientEvent('okokBanking:updateTransactions', xPlayer.PlayerData.source, xPlayer.PlayerData.money.bank, xPlayer.PlayerData.money.cash)
				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have transferred "..amount.."$ to "..targetName, 5000, 'success')

				ExecuteSql('UPDATE characters_metadata SET money = @playerAccount WHERE identifier = @target', {
					['@playerAccount'] = playerAccount,
					['@target'] = targetIdentifier
				}, function(changed)

				end)
			end
		else
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You don't have that much money on the bank", 5000, 'error')
		end
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You can't send money to yourself", 5000, 'error')
	end
end)

RegisterServerEvent("okokBanking:DepositMoneyToSociety")
AddEventHandler("okokBanking:DepositMoneyToSociety", function(amount, society, societyName)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local playerMoney = xPlayer.PlayerData.money.cash

	if amount <= playerMoney then
		ExecuteSql('UPDATE okokBanking_societies SET value = value + @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = society,
			['@society_name'] = societyName,
		}, function(changed)
		end)
		xPlayer.Functions.RemoveMoney('cash', amount)

		TriggerEvent('okokBanking:AddDepositTransactionToSociety', amount, xPlayer.PlayerData.source, society, societyName)
		TriggerClientEvent('okokBanking:updateTransactionsSociety', xPlayer.PlayerData.source, xPlayer.PlayerData.money.cash)
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have deposited "..amount.."$ to "..societyName, 5000, 'success')
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You don't have that much money on you", 5000, 'error')
	end
end)

RegisterServerEvent("okokBanking:WithdrawMoneyToSociety")
AddEventHandler("okokBanking:WithdrawMoneyToSociety", function(amount, society, societyName, societyMoney)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local _source = source
	local db
	local hasChecked = false

	ExecuteSql('SELECT * FROM okokBanking_societies WHERE society = @society', {
		['@society'] = society
	}, function(result)
		db = result[1]
		hasChecked = true
	end)

	ExecuteSql('UPDATE okokBanking_societies SET is_withdrawing = 1 WHERE society = @society AND society_name = @society_name', {
		['@value'] = amount,
		['@society'] = society,
		['@society_name'] = societyName,
	}, function(changed)
	end)

	while not hasChecked do 
		Citizen.Wait(100)
	end
	
	if amount <= db.value then
		if db.is_withdrawing == 1 then
			TriggerClientEvent('okokNotify:Alert', _source, "BANK", "Someone is already withdrawing", 5000, 'error')
		else

			ExecuteSql('UPDATE okokBanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
				['@value'] = amount,
				['@society'] = society,
				['@society_name'] = societyName,
			}, function(changed)
			end)
			
			xPlayer.Functions.AddMoney('cash', amount)
			--xPlayer.Functions.AddMoney('bank', amount)
			TriggerEvent('okokBanking:AddWithdrawTransactionToSociety', amount, _source, society, societyName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', _source, xPlayer.PlayerData.money.cash)
			TriggerClientEvent('okokNotify:Alert', _source, "BANK", "You have withdrawn "..amount.."$ from "..societyName, 5000, 'success')
		end
	else
		TriggerClientEvent('okokNotify:Alert', _source, "BANK", "Your society doesn't have that much money on the bank", 5000, 'error')
	end

	ExecuteSql('UPDATE okokBanking_societies SET is_withdrawing = 0 WHERE society = @society AND society_name = @society_name', {
		['@value'] = amount,
		['@society'] = society,
		['@society_name'] = societyName,
	}, function(changed)
	end)
end)

RegisterServerEvent("okokBanking:TransferMoneyToSociety")
AddEventHandler("okokBanking:TransferMoneyToSociety", function(amount, ibanNumber, societyName, society)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local playerMoney = xPlayer.PlayerData.money.bank

		if amount <= playerMoney then
			ExecuteSql('UPDATE okokBanking_societies SET value = value + @value WHERE iban = @iban', {
				['@value'] = amount,
				['@iban'] = ibanNumber
			}, function(changed)
			end)
			xPlayer.Functions.RemoveMoney('bank', amount)
			TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, xPlayer.PlayerData.source, society, societyName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', xPlayer.PlayerData.source, xPlayer.PlayerData.money.cash)
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have transferred "..amount.."$ to "..societyName, 5000, 'success')
		else
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You don't have that much money on the bank", 5000, 'error')
		end
end)

RegisterServerEvent("okokBanking:TransferMoneyToSocietyFromSociety")
AddEventHandler("okokBanking:TransferMoneyToSocietyFromSociety", function(amount, ibanNumber, societyNameTarget, societyTarget, society, societyName, societyMoney)
	local xPlayer = Framework.Functions.GetPlayer(source)
	-- local xTarget = Framework.Functions.GetPlayerByCitizenId(targetIdentifier)
	-- local xPlayers = Framework.Functions.GetPlayers()

	if amount <= societyMoney then
		ExecuteSql('UPDATE okokBanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = society,
			['@society_name'] = societyName,
		}, function(changed)
		end)
		ExecuteSql('UPDATE okokBanking_societies SET value = value + @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = societyTarget,
			['@society_name'] = societyNameTarget,
		}, function(changed)
		end)
		TriggerEvent('okokBanking:AddTransferTransactionFromSociety', amount, society, societyName, societyTarget, societyNameTarget)
		TriggerClientEvent('okokBanking:updateTransactionsSociety', xPlayer.PlayerData.source, xPlayer.PlayerData.money.cash)
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have transferred "..amount.."$ to "..societyNameTarget, 5000, 'success')
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "Your society doesn't have that much money on the bank", 5000, 'error')
	end
end)

RegisterServerEvent("okokBanking:TransferMoneyToPlayerFromSociety")
AddEventHandler("okokBanking:TransferMoneyToPlayerFromSociety", function(amount, ibanNumber, targetIdentifier, acc, targetName, society, societyName, societyMoney, toMyself)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local xTarget = Framework.Functions.GetPlayerByCitizenId(targetIdentifier)
	local xPlayers = Framework.Functions.GetPlayers()

	if amount <= societyMoney then
		ExecuteSql('UPDATE okokBanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = society,
			['@society_name'] = societyName,
		}, function(changed)
		end)
		if xTarget ~= nil then
			xTarget.Functions.AddMoney('bank', amount)
			-- xTarget.addAccountMoney('bank', amount)
			if not toMyself then
				for i=1, #xPlayers, 1 do
				    local xForPlayer = Framework.Functions.GetPlayer(xPlayers[i])
				    if xForPlayer.PlayerData.citizenid == targetIdentifier then
				    	--TriggerClientEvent('okokBanking:updateMoney', xPlayers[i], xTarget.getAccount('bank').money)
			    	
			    		TriggerClientEvent('okokBanking:updateTransactions', xPlayers[i], xTarget.getAccount('bank').money, xTarget.PlayerData.money.cash)
			    		TriggerClientEvent('okokNotify:Alert', xPlayers[i], "BANK", "You have received "..amount.."$ from "..GetPlayerName(source), 5000, 'success')
				    end
				end
			end
			TriggerEvent('okokBanking:AddTransferTransactionFromSocietyToP', amount, society, societyName, targetIdentifier, targetName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', xPlayer.PlayerData.source, xPlayer.PlayerData.money.cash)
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have transferred "..amount.."$ to "..xTarget.getName(), 5000, 'success')
		elseif xTarget == nil then
			local playerAccount = json.decode(acc)
			playerAccount.bank = math.floor(playerAccount.bank + amount)
			playerAccount = json.encode(playerAccount)

			--xPlayer.Functions.RemoveMoney('bank', amount)

			--TriggerClientEvent('okokBanking:updateMoney', xPlayer.PlayerData.source, xPlayer.PlayerData.money.bank)
			TriggerEvent('okokBanking:AddTransferTransactionFromSocietyToP', amount, society, societyName, targetIdentifier, targetName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', xPlayer.PlayerData.source, xPlayer.PlayerData.money.cash)
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You have transferred "..amount.."$ to "..targetName, 5000, 'success')

			-- Framework.Functions.ExecuteSql(false, "UPDATE `characters_metadata` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
			ExecuteSql('UPDATE `characters_metadata` SET money = @playerAccount WHERE identifier = @target', {
				['@playerAccount'] = playerAccount,
				['@target'] = targetIdentifier
			}, function(changed)

			end)
		end
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "Your society doesn't have that much money on the bank", 5000, 'error')
	end
end)

Framework.Functions.CreateCallback("okokBanking:GetOverviewTransactions", function(source, cb)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local playerIdentifier = xPlayer.PlayerData.citizenid
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	ExecuteSql('SELECT * FROM okokBanking_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
		['@identifier'] = playerIdentifier
	}, function(result)
		ExecuteSql('SELECT *, DATE(date) = CURDATE() AS "day1", DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" FROM `okokBanking_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY', {

		}, function(result2)
			for k, v in pairs(result2) do
				local type = v.type
				local receiver_identifier = v.receiver_identifier
				local sender_identifier = v.sender_identifier
				local value = tonumber(v.value)

				if v.day1 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day1_total = day1_total + value
							income = income + value
						elseif type == "withdraw" then
							day1_total = day1_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day1_total = day1_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day1_total = day1_total - value
							outcome = outcome - value
						end
					end
					
				elseif v.day2 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day2_total = day2_total + value
							income = income + value
						elseif type == "withdraw" then
							day2_total = day2_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day2_total = day2_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day2_total = day2_total - value
							outcome = outcome - value
						end
					end

				elseif v.day3 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day3_total = day3_total + value
							income = income + value
						elseif type == "withdraw" then
							day3_total = day3_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day3_total = day3_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day3_total = day3_total - value
							outcome = outcome - value
						end
					end

				elseif v.day4 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day4_total = day4_total + value
							income = income + value
						elseif type == "withdraw" then
							day4_total = day4_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day4_total = day4_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day4_total = day4_total - value
							outcome = outcome - value
						end
					end

				elseif v.day5 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day5_total = day5_total + value
							income = income + value
						elseif type == "withdraw" then
							day5_total = day5_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day5_total = day5_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day5_total = day5_total - value
							outcome = outcome - value
						end
					end

				elseif v.day6 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day6_total = day6_total + value
							income = income + value
						elseif type == "withdraw" then
							day6_total = day6_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day6_total = day6_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day6_total = day6_total - value
							outcome = outcome - value
						end
					end

				elseif v.day7 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day7_total = day7_total + value
							income = income + value
						elseif type == "withdraw" then
							day7_total = day7_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day7_total = day7_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day7_total = day7_total - value
							outcome = outcome - value
						end
					end

				end
			end

			totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

			table.remove(allDays)
			table.insert(allDays, day1_total)
			table.insert(allDays, day2_total)
			table.insert(allDays, day3_total)
			table.insert(allDays, day4_total)
			table.insert(allDays, day5_total)
			table.insert(allDays, day6_total)
			table.insert(allDays, day7_total)
			table.insert(allDays, income)
			table.insert(allDays, outcome)
			table.insert(allDays, totalIncome)

			cb(result, playerIdentifier, allDays)
		end)
	end)
end)

Framework.Functions.CreateCallback("okokBanking:GetSocietyTransactions", function(source, cb, society)
	local playerIdentifier = society
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	ExecuteSql('SELECT * FROM okokBanking_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
		['@identifier'] = society
	}, function(result)
		ExecuteSql('SELECT *, DATE(date) = CURDATE() AS "day1", DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" FROM `okokBanking_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY AND receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
			['@identifier'] = society
		}, function(result2)
			for k, v in pairs(result2) do
				local type = v.type
				local receiver_identifier = v.receiver_identifier
				local sender_identifier = v.sender_identifier
				local value = tonumber(v.value)

				if v.day1 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day1_total = day1_total + value
							income = income + value
						elseif type == "withdraw" then
							day1_total = day1_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day1_total = day1_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day1_total = day1_total - value
							outcome = outcome - value
						end
					end
					
				elseif v.day2 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day2_total = day2_total + value
							income = income + value
						elseif type == "withdraw" then
							day2_total = day2_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day2_total = day2_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day2_total = day2_total - value
							outcome = outcome - value
						end
					end

				elseif v.day3 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day3_total = day3_total + value
							income = income + value
						elseif type == "withdraw" then
							day3_total = day3_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day3_total = day3_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day3_total = day3_total - value
							outcome = outcome - value
						end
					end

				elseif v.day4 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day4_total = day4_total + value
							income = income + value
						elseif type == "withdraw" then
							day4_total = day4_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day4_total = day4_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day4_total = day4_total - value
							outcome = outcome - value
						end
					end

				elseif v.day5 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day5_total = day5_total + value
							income = income + value
						elseif type == "withdraw" then
							day5_total = day5_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day5_total = day5_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day5_total = day5_total - value
							outcome = outcome - value
						end
					end

				elseif v.day6 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day6_total = day6_total + value
							income = income + value
						elseif type == "withdraw" then
							day6_total = day6_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day6_total = day6_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day6_total = day6_total - value
							outcome = outcome - value
						end
					end

				elseif v.day7 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day7_total = day7_total + value
							income = income + value
						elseif type == "withdraw" then
							day7_total = day7_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day7_total = day7_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day7_total = day7_total - value
							outcome = outcome - value
						end
					end

				end
			end

			totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

			table.remove(allDays)
			table.insert(allDays, day1_total)
			table.insert(allDays, day2_total)
			table.insert(allDays, day3_total)
			table.insert(allDays, day4_total)
			table.insert(allDays, day5_total)
			table.insert(allDays, day6_total)
			table.insert(allDays, day7_total)
			table.insert(allDays, income)
			table.insert(allDays, outcome)
			table.insert(allDays, totalIncome)

			cb(result, playerIdentifier, allDays)
		end)
	end)
end)


RegisterServerEvent("okokBanking:AddDepositTransaction")
AddEventHandler("okokBanking:AddDepositTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = Framework.Functions.GetPlayer(_source)

	ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = 'bank',
		['@receiver_name'] = 'Bank Account',
		['@sender_identifier'] = tostring(xPlayer.PlayerData.citizenid),
		['@sender_name'] = tostring(GetPlayerName(_source)),
		['@value'] = tonumber(amount),
		['@type'] = 'deposit'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddWithdrawTransaction")
AddEventHandler("okokBanking:AddWithdrawTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = Framework.Functions.GetPlayer(_source)

	ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = tostring(xPlayer.PlayerData.citizenid),
		['@receiver_name'] = tostring(GetPlayerName(_source)),
		['@sender_identifier'] = 'bank',
		['@sender_name'] = 'Bank Account',
		['@value'] = tonumber(amount),
		['@type'] = 'withdraw'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransaction")
AddEventHandler("okokBanking:AddTransferTransaction", function(amount, xTarget, source_, targetName, targetIdentifier)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = Framework.Functions.GetPlayer(_source)
	if targetName == nil then
		ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(xTarget.PlayerData.citizenid),
			['@receiver_name'] = tostring(xTarget.getName()),
			['@sender_identifier'] = tostring(xPlayer.PlayerData.citizenid),
			['@sender_name'] = tostring(GetPlayerName(xPlayer.PlayerData.source)),
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	elseif targetName ~= nil and targetIdentifier ~= nil then
		ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(targetIdentifier),
			['@receiver_name'] = tostring(targetName),
			['@sender_identifier'] = tostring(xPlayer.PlayerData.citizenid),
			['@sender_name'] = tostring(GetPlayerName(xPlayer.PlayerData.source)),
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	end
end)

RegisterServerEvent("okokBanking:AddTransferTransactionToSociety")
AddEventHandler("okokBanking:AddTransferTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = Framework.Functions.GetPlayer(_source)
	if xPlayer ~= nil then
		ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = society,
			['@receiver_name'] = societyName,
			['@sender_identifier'] = tostring(xPlayer.PlayerData.citizenid),
			['@sender_name'] = tostring(GetPlayerName(xPlayer.PlayerData.source)),
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	end
end)

RegisterServerEvent("okokBanking:AddTransferTransactionFromSocietyToP")
AddEventHandler("okokBanking:AddTransferTransactionFromSocietyToP", function(amount, society, societyName, identifier, name)

	ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = identifier,
		['@receiver_name'] = name,
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransactionFromSociety")
AddEventHandler("okokBanking:AddTransferTransactionFromSociety", function(amount, society, societyName, societyTarget, societyNameTarget)
	
	ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = societyTarget,
		['@receiver_name'] = societyNameTarget,
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddDepositTransactionToSociety")
AddEventHandler("okokBanking:AddDepositTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = Framework.Functions.GetPlayer(_source)

	ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = society,
		['@receiver_name'] = societyName,
		['@sender_identifier'] = tostring(xPlayer.PlayerData.citizenid),
		['@sender_name'] = tostring(GetPlayerName(xPlayer.PlayerData.source)),
		['@value'] = tonumber(amount),
		['@type'] = 'deposit'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddWithdrawTransactionToSociety")
AddEventHandler("okokBanking:AddWithdrawTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = Framework.Functions.GetPlayer(_source)

	ExecuteSql('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = tostring(xPlayer.PlayerData.citizenid),
		['@receiver_name'] = tostring(GetPlayerName(xPlayer.PlayerData.source)),
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'withdraw'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:UpdateIbanDB")
AddEventHandler("okokBanking:UpdateIbanDB", function(iban, amount)
	local xPlayer = Framework.Functions.GetPlayer(source)
	TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "Chức năng đang phát triển", 5000, 'success')
	-- if Config.IBANChangeCost <= xPlayer.PlayerData.money.bank then
	-- 	xPlayer.PlayerData.charinfo.account = iban
	-- 	-- ExecuteSql('UPDATE users SET iban = @iban WHERE identifier = @identifier', {
	-- 	-- 	['@iban'] = iban,
	-- 	-- 	['@identifier'] = xPlayer.PlayerData.citizenid,
	-- 	-- }, function(changed)
	-- 	-- end)
	-- 	xPlayer.Functions.RemoveMoney('bank', Config.IBANChangeCost)
	-- 	xPlayer.Functions.UpdatePlayerData()
	-- 	xPlayer.Functions.Save()

	-- 	TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, xPlayer.PlayerData.source, "bank", "Bank (IBAN)")
	-- 	TriggerClientEvent('okokBanking:updateIban', xPlayer.PlayerData.source, iban)
	-- 	TriggerClientEvent('okokBanking:updateIbanPinChange', xPlayer.PlayerData.source)
	-- 	TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "IBAN successfully changed to "..iban, 5000, 'success')
	-- else
	-- 	TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You need to have "..Config.IBANChangeCost.."$ in order to change your IBAN", 5000, 'error')
	-- end
end)

RegisterServerEvent("okokBanking:UpdatePINDB")
AddEventHandler("okokBanking:UpdatePINDB", function(pin, amount)
	local xPlayer = Framework.Functions.GetPlayer(source)

	if Config.PINChangeCost <= xPlayer.PlayerData.money.bank then
		-- ExecuteSql('UPDATE users SET pincode = @pin WHERE identifier = @identifier', {
		-- 	['@pin'] = pin,
		-- 	['@identifier'] = xPlayer.PlayerData.citizenid,
		-- }, function(changed)
		-- end)
		-- xPlayer.PlayerData.metadata["pincode"] = pin
		xPlayer.Functions.RemoveMoney('bank', Config.PINChangeCost)
		xPlayer.Functions.SetMetaData("pincode", pin)
		xPlayer.Functions.Save()

		TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, xPlayer.PlayerData.source, "bank", "Bank (PIN)")
		TriggerClientEvent('okokBanking:updateIbanPinChange', xPlayer.PlayerData.source)
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "PIN successfully changed to "..pin, 5000, 'success')
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "BANK", "You need to have "..Config.PINChangeCost.."$ in order to change your PIN", 5000, 'error')
	end
end)

function ExecuteSql(query, params, cb)
	local rtndata = {}
	local waiting = true
	local wait = true
	local params = params ~= nil and params or {}
	exports['ghmattimysql']:execute(query, safeParameters(params), function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

function safeParameters(parameters)
	if parameters == nil then
	  return {[''] = ''}
	end
	return parameters
end