Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local Webhook = 'https://discord.com/api/webhooks/923589924911992873/R27LmoNjKuOrBgw1xgeK7dO5wC2aloxdcJQiChnHSPtbY9lMLNr0priFSL6VTcuTJyjB'
local limiteTimeHours = Config.LimitDateDays*24
local hoursToPay = limiteTimeHours
local whenToAddFees = {}

for i = 1, Config.LimitDateDays, 1 do
	hoursToPay = hoursToPay - 24
	table.insert(whenToAddFees, hoursToPay)
end

Framework.Functions.CreateCallback('okokBilling:GetInvoices', function(source, cb)
    local Ply = Framework.Functions.GetPlayer(source)

    Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokBilling WHERE receiver_identifier = "'..Ply.PlayerData.citizenid..'" ORDER BY CASE WHEN status = "unpaid" THEN 1 WHEN status = "autopaid" THEN 2 WHEN status = "paid" THEN 3 WHEN status = "cancelled" THEN 4 END ASC, id DESC'
	, function(result)
        local invoices = {}

		if result ~= nil then
			for i=1, #result, 1 do
				table.insert(invoices, result[i])
			end
		end

		cb(invoices)
    end)
end)

Framework.Functions.CreateCallback('okokBilling:PayInvoice', function(source, cb, invoice_id)
    local src = source
	local xPlayer = Framework.Functions.GetPlayer(src)
	Framework.Functions.ExecuteSql(false, "SELECT * FROM okokBilling WHERE id = '"..invoice_id.."'", function(result)
        local invoices = result[1]
		local playerMoney = xPlayer.PlayerData.money.bank
		local webhookData = {
			id = invoices.id,
			player_name = invoices.receiver_name,
			value = invoices.invoice_value,
			item = invoices.item,
			society = invoices.society_name
		}

		invoices.invoice_value = math.ceil(invoices.invoice_value)

		if playerMoney == nil then
			playerMoney = 0
		end

		if playerMoney < invoices.invoice_value then
			TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền" , "error")
			cb(false)
		else
			xPlayer.Functions.RemoveMoney('bank', invoices.invoice_value, "paid-invoice-"..invoice_id)

			local totalMoneyAccountGet = math.floor(invoices.invoice_value * ((100 - Config.VATPercentage) / 100))
			TriggerEvent("pepe-bossmenu:server:addAccountMoney", invoices.society, totalMoneyAccountGet)

			local bossList = FindBossPlayerByJobName(invoices.society)
			for _, player in pairs(bossList) do
				TriggerClientEvent('pepe-phone:client:addNotification', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!")
				TriggerClientEvent('Framework:Notify', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!", "success")
			end

			Framework.Functions.ExecuteSql(true, "UPDATE okokBilling SET status = 'paid', paid_date = CURRENT_TIMESTAMP WHERE id = '"..invoice_id.."'")
			TriggerClientEvent("Framework:Notify", src, "Thanh toán hóa đơn thành công" , "error")

			if Webhook ~= '' then
				payInvoiceWebhook(webhookData)
			end
			cb(true)
		end
    end)
end)

RegisterServerEvent("okokBilling:PayInvoice")
AddEventHandler("okokBilling:PayInvoice", function(invoice_id)
	local src = source
	local xPlayer = Framework.Functions.GetPlayer(source)
	Framework.Functions.ExecuteSql(false, "SELECT * FROM okokBilling WHERE id = '"..invoice_id.."'", function(result)
        local invoices = result[1]
		local playerMoney = xPlayer.PlayerData.money.bank
		local webhookData = {
			id = invoices.id,
			player_name = invoices.receiver_name,
			value = invoices.invoice_value,
			item = invoices.item,
			society = invoices.society_name
		}

		invoices.invoice_value = math.ceil(invoices.invoice_value)

		if playerMoney == nil then
			playerMoney = 0
		end

		if playerMoney < invoices.invoice_value then
			TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền" , "error")
				
		else
			xPlayer.Functions.RemoveMoney('bank', invoices.invoice_value, "paid-invoice-"..invoice_id)

			local totalMoneyAccountGet = math.floor(invoices.invoice_value * ((100 - Config.VATPercentage) / 100))
			TriggerEvent("pepe-bossmenu:server:addAccountMoney", invoices.society, totalMoneyAccountGet)

			local bossList = FindBossPlayerByJobName(invoices.society)
			for _, player in pairs(bossList) do
				TriggerClientEvent('pepe-phone:client:addNotification', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!")
				TriggerClientEvent('Framework:Notify', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!", "success")
			end

			Framework.Functions.ExecuteSql(true, "UPDATE okokBilling SET status = 'paid', paid_date = CURRENT_TIMESTAMP WHERE id = '"..invoice_id.."'")
			TriggerClientEvent("Framework:Notify", src, "Thanh toán hóa đơn thành công" , "error")

			if Webhook ~= '' then
				payInvoiceWebhook(webhookData)
			end
		end
    end)
end)

RegisterServerEvent("okokBilling:CancelInvoice")
AddEventHandler("okokBilling:CancelInvoice", function(invoice_id)
	local src = source
	local xPlayer = Framework.Functions.GetPlayer(source)
	Framework.Functions.ExecuteSql(false, "SELECT * FROM okokBilling WHERE id = '"..invoice_id.."'", function(result)
        local invoices = result[1]
		local webhookData = {
			id = invoices.id,
			player_name = invoices.receiver_name,
			value = invoices.invoice_value,
			item = invoices.item,
			society = invoices.society_name,
			name = GetPlayerName(src)
		}

		Framework.Functions.ExecuteSql(true, "UPDATE okokBilling SET status = 'cancelled', paid_date = CURRENT_TIMESTAMP WHERE id = '"..invoice_id.."'")
		TriggerClientEvent("Framework:Notify", src, "Bạn đã hủy hóa đơn" , "error")
		if Webhook ~= '' then
			cancelInvoiceWebhook(webhookData)
		end
    end)
end)

RegisterServerEvent("okokBilling:CreateInvoice")
AddEventHandler("okokBilling:CreateInvoice", function(data)
	local src = source
	local _source = Framework.Functions.GetPlayer(source)
    local target = Framework.Functions.GetPlayer(tonumber(data.target))
	if target == nil or data.target == src then
		TriggerClientEvent("Framework:Notify", src, "ID Người chơi không hợp lệ" , "error")
		return
	end

	local webhookData = {}
	local waiting = true

	Framework.Functions.ExecuteSql(true, "SELECT id FROM okokBilling WHERE id = (SELECT MAX(id) FROM okokBilling)", function(result)
		local oldId = tonumber(result[1].id and result[1].id or 0)
        webhookData = {
			id = oldId + 1,
			player_name = GetPlayerName(tonumber(data.target)),
			value = data.invoice_value,
			item = data.invoice_item,
			society = data.society_name,
			name = GetPlayerName(src)
		}
		waiting = false
    end)

	while waiting do
		Citizen.Wait(5)
	end

	if Config.LimitDate then
		Framework.Functions.ExecuteSql(false, "INSERT INTO okokBilling (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES ('"..target.PlayerData.citizenid.."', '"..GetPlayerName(tonumber(data.target)).."', '".._source.PlayerData.citizenid.."', '"..GetPlayerName(src).."', '"..data.society.."', '"..data.society_name.."', '"..data.invoice_item.."', '"..data.invoice_value.."', 'unpaid', '"..data.invoice_notes.."', CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL "..Config.LimitDateDays.." DAY))")
		TriggerClientEvent("Framework:Notify", data.target, "Bạn vừa nhận được hóa đơn" , "error")
		if Webhook ~= '' then
			createNewInvoiceWebhook(webhookData)
		end
	else
		Framework.Functions.ExecuteSql(false, "INSERT INTO okokBilling (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES ('"..target.PlayerData.citizenid.."', '"..GetPlayerName(tonumber(data.target)).."', '".._source.PlayerData.citizenid.."', '"..GetPlayerName(src).."', '"..data.society.."', '"..data.society_name.."', '"..data.invoice_item.."', '"..data.invoice_value.."', 'unpaid', '"..data.invoice_notes.."', CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL 0 DAY))")
		TriggerClientEvent("Framework:Notify", data.target, "Bạn vừa nhận được hóa đơn" , "error")
		if Webhook ~= '' then
			createNewInvoiceWebhook(webhookData)
		end
	end
end)

Framework.Functions.CreateCallback("okokBilling:CreateCustomInvoice", function(source, cb, data)
	local _source = Framework.Functions.GetPlayer(tonumber(data.source))
    local target = Framework.Functions.GetPlayer(tonumber(data.target))
	if target == nil then
		TriggerClientEvent("Framework:Notify", source, "ID Người chơi không hợp lệ" , "error")
		cb(false)
		return
	end

	local webhookData = {}
	local waiting = true

	Framework.Functions.ExecuteSql(true, "SELECT id FROM okokBilling WHERE id = (SELECT MAX(id) FROM okokBilling)", function(result)
		oldId = 0
		if result[1] ~= nil then
			oldId = tonumber((result[1].id) and result[1].id or 0)
		end
        webhookData = {
			id = oldId + 1,
			player_name = GetPlayerName(tonumber(data.target)),
			value = data.invoice_value,
			item = data.invoice_item,
			society = data.society_name,
			name = GetPlayerName(data.source)
		}
		waiting = false
    end)


	while waiting do
		Citizen.Wait(5)
	end

	if Config.LimitDate then
		Framework.Functions.ExecuteSql(false, "INSERT INTO okokBilling (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES ('"..target.PlayerData.citizenid.."', '"..GetPlayerName(tonumber(data.target)).."', '".._source.PlayerData.citizenid.."', '"..GetPlayerName(tonumber(data.source)).."', '"..data.society.."', '"..data.society_name.."', '"..data.invoice_item.."', '"..data.invoice_value.."', 'unpaid', '"..data.invoice_notes.."', CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL "..Config.LimitDateDays.." DAY))")
		TriggerClientEvent("Framework:Notify", data.target, "Bạn vừa nhận được hóa đơn" , "error")
		if Webhook ~= '' then
			createNewInvoiceWebhook(webhookData)
		end
	else
		Framework.Functions.ExecuteSql(false, "INSERT INTO okokBilling (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES ('"..target.PlayerData.citizenid.."', '"..GetPlayerName(tonumber(data.target)).."', '".._source.PlayerData.citizenid.."', '"..GetPlayerName(tonumber(data.source)).."', '"..data.society.."', '"..data.society_name.."', '"..data.invoice_item.."', '"..data.invoice_value.."', 'unpaid', '"..data.invoice_notes.."', CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL 0 DAY))")
		TriggerClientEvent("Framework:Notify", data.target, "Bạn vừa nhận được hóa đơn" , "error")
		if Webhook ~= '' then
			createNewInvoiceWebhook(webhookData)
		end
	end

	cb(true)
end)

Framework.Functions.CreateCallback("okokBilling:GetSocietyInvoices", function(source, cb, society)
	local xPlayer = Framework.Functions.GetPlayer(source)

	Framework.Functions.ExecuteSql(false, "SELECT * FROM okokBilling WHERE society_name = '"..society.."' ORDER BY id DESC"
	, function(result)
        local invoices = {}
		local totalInvoices = 0
		local totalIncome = 0
		local totalUnpaid = 0
		local awaitedIncome = 0

		if result ~= nil then
			for i=1, #result, 1 do
				table.insert(invoices, result[i])
				totalInvoices = totalInvoices + 1

				if result[i].status == 'paid' then
					totalIncome = totalIncome + result[i].invoice_value
				elseif result[i].status == 'unpaid' then
					awaitedIncome = awaitedIncome + result[i].invoice_value
					totalUnpaid = totalUnpaid + 1
				end
			end
		end
		cb(invoices, totalInvoices, totalIncome, totalUnpaid, awaitedIncome)
    end)
end)

function checkTimeLeft()
	Framework.Functions.ExecuteSql(false, 'SELECT *, TIMESTAMPDIFF(HOUR, limit_pay_date, CURRENT_TIMESTAMP()) AS "timeLeft" FROM okokBilling WHERE status = "unpaid"'
	, function(result)
        for k, v in ipairs(result) do
			local invoice_value = v.invoice_value * (Config.FeeAfterEachDayPercentage / 100 + 1)
			if v.timeLeft < 0 and Config.FeeAfterEachDay then
				for k, vl in pairs(whenToAddFees) do
					if v.fees_amount == k - 1 then
						if v.timeLeft >= vl*(-1) then
							Framework.Functions.ExecuteSql(false, "UPDATE okokBilling SET fees_amount = '"..k.."', invoice_value = '"..v.invoice_value * (Config.FeeAfterEachDayPercentage / 100 + 1).."' WHERE id = '"..v.id.."'")
						end
					end
				end
			elseif v.timeLeft >= 0 and Config.PayAutomaticallyAfterLimit then
				local xPlayer = Framework.Functions.GetPlayerByCitizenId(v.receiver_identifier)
				local webhookData = {
					id = v.id,
					player_name = v.receiver_name,
					value = v.invoice_value,
					item = v.item,
					society = v.society_name
				}

				if xPlayer == nil then
					Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..v.receiver_identifier.."'", function(account)
						if account[1] ~= nil then
							local moneyInfo = json.decode(account[1].money)

							local canFund = false
							local playerMoney = moneyInfo.bank
							if playerMoney == nil then
								playerMoney = 0
							end
					
							if playerMoney < invoice_value then
								if moneyInfo.cash > invoice_value then
									moneyInfo.cash = math.floor(moneyInfo.cash - invoice_value)
									canFund = true
								end
							else
								moneyInfo.bank = math.floor(moneyInfo.bank - invoice_value)
								canFund = true
							end

							if canFund then
								-- TriggerServerEvent('pepe-phone:server:sendNewMailToOffline', v.receiver_identifier, {
								-- 	sender = "Thành phố Los Angeles",
								-- 	subject = "Hóa đơn thanh toán tự động",
								-- 	message = "Chào bạn ,<br/><br />Bạn vừa được thanh toán hóa đơn tự động!<br /><br />Tổng số tiền: <strong>$"..invoice_value.."</strong> <br><br>Cảm ơn bạn đã sử dụng dịch vụ hóa đơn của chúng tôi!<br/><br/>Trân trọng,<br />Los Angeles",
								-- 	button = {}
								-- })

								Framework.Functions.ExecuteSql(false, "UPDATE `characters_metadata` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..account[1].citizenid.."'")
								TriggerEvent("pepe-logs:server:SendLog", "playermoney", "RemoveMoney", "red", "**"..account[1].name.. " (citizenid: "..account[1].citizenid..")** $"..invoice_value .. " (bank) đã trừ bank số tiền còn lại: "..moneyInfo.bank.." reason: autopaidinvoice")

								local totalMoneyAccountGet = math.floor(invoice_value * ((100 - Config.VATPercentage) / 100))
								TriggerEvent("pepe-bossmenu:server:addAccountMoney", v.society, totalMoneyAccountGet)
								local bossList = FindBossPlayerByJobName(v.society)
								for _, player in pairs(bossList) do
									TriggerClientEvent('pepe-phone:client:addNotification', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!")
									TriggerClientEvent('Framework:Notify', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!", "success")
								end
								Framework.Functions.ExecuteSql(false, "UPDATE okokBilling SET status = 'autopaid', paid_date = CURRENT_TIMESTAMP() WHERE id = '"..v.id.."'")
							end
						end
					end)
				else
					local canFund = false
					local playerMoney = xPlayer.PlayerData.money.bank
					if playerMoney == nil then
						playerMoney = 0
					end
			
					if playerMoney < invoice_value then
						if xPlayer.PlayerData.money.cash > invoice_value then
							xPlayer.Functions.RemoveMoney('cash', invoice_value, "paid-invoice")
							canFund = true
						end
					else
						xPlayer.Functions.RemoveMoney('bank', invoice_value, "paid-invoice")
						canFund = true
					end

					if canFund then
						TriggerClientEvent('Framework:Notify', xPlayer.PlayerData.source, "Hóa đơn $"..invoice_value.." đã được thanh toán!", "error")

						local totalMoneyAccountGet = math.floor(invoice_value * ((100 - Config.VATPercentage) / 100))
						TriggerEvent("pepe-bossmenu:server:addAccountMoney", v.society, totalMoneyAccountGet)
						local bossList = FindBossPlayerByJobName(v.society)
						for _, player in pairs(bossList) do
							TriggerClientEvent('pepe-phone:client:addNotification', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!")
							TriggerClientEvent('Framework:Notify', player.source, "Quỹ vừa nhận được "..totalMoneyAccountGet.."$ từ hoá đơn thanh toán!", "success")
						end

						Framework.Functions.ExecuteSql(false, "UPDATE okokBilling SET status = 'autopaid', paid_date = CURRENT_TIMESTAMP() WHERE id = '"..v.id.."'")
						if Webhook ~= '' then
							autopayInvoiceWebhook(webhookData)
						end
					else
						TriggerClientEvent('Framework:Notify', xPlayer.PlayerData.source, "Bạn có một hóa đơn $"..invoice_value.." còn nợ cần thanh toán!", "error")
					end
				end
			end
		end
    end)
	SetTimeout(30 * 60000, checkTimeLeft)
end

if Config.PayAutomaticallyAfterLimit then
	checkTimeLeft()
end

-------------------------- PAY INVOICE WEBHOOK

function payInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.PayInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Invoice #'..data.id..' has been paid',
			["description"] = '**Receiver:** '..data.player_name..'\n**Value:** '..data.value..'$\n**Item:** '..data.item..'\n**Beneficiary Society:** '..data.society,

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end

-------------------------- CANCEL INVOICE WEBHOOK

function cancelInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.CancelInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Invoice #'..data.id..' has been cancelled',
			["description"] = '**Cancelled by:** '..data.name..'\n\n**Receiver:** '..data.player_name..'\n**Value:** '..data.value..'$\n**Item:** '..data.item..'\n**Society:** '..data.society,

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end

-------------------------- CREATE NEW INVOICE WEBHOOK

function createNewInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.CreateNewInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Invoice #'..data.id..' has been created',
			["description"] = '**Created by:** '..data.name..'\n**Society:** '..data.society..'\n\n**Receiver:** '..data.player_name..'\n**Value:** '..data.value..'$\n**Item:** '..data.item,

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end

-------------------------- AUTOPAY INVOICE WEBHOOK

function autopayInvoiceWebhook(data)
	local information = {
		{
			["color"] = Config.AutopayInvoiceWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'Invoice #'..data.id..' has been autopaid',
			["description"] = '**Receiver:** '..data.player_name..'\n**Value:** '..data.value..'$\n**Item:** '..data.item..'\n**Beneficiary Society:** '..data.society,

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = '', embeds = information}), {['Content-Type'] = 'application/json'})
end

function FindBossPlayerByJobName(jobName)
    local bossList = {}
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == jobName and Player.PlayerData.job.isboss) then
                table.insert(bossList, {
                    source = Player.PlayerData.source, 
                })
            end
        end
    end
    return bossList
end

Framework.Commands.Add("billtimeleft", "Check time bill", {}, false, function(source, args)
    checkTimeLeft()
end, "god")

