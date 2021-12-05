PlayerData = {}

Framework = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(1250, function()
		PlayerData = Framework.Functions.GetPlayerData()
	end)
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Framework.Functions.GetPlayerData(function(pData)
        PlayerData = pData
    end)
    isLoggedIn = true
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('okokBilling:client:openMenu')
AddEventHandler('okokBilling:client:openMenu', function(JobInfo)
	local isAllowed = false
	local jobName = ""
	for k, v in pairs(Config.AllowedSocieties) do
		if v == PlayerData.job.name then
			jobName = v
			isAllowed = true
		end
	end

	if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif Config.OnlyBossCanAccessSocietyInvoices and not PlayerData.job.isboss and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = true
		})
	elseif not Config.OnlyBossCanAccessSocietyInvoices and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif not isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = false
		})
	end
end)

function MyInvoices()
	Framework.Functions.TriggerCallback('okokBilling:GetInvoices', function(invoices)
        SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'myinvoices',
			invoices = invoices,
			VAT = Config.VATPercentage
		})
    end)
end

function SocietyInvoices(society)
	Framework.Functions.TriggerCallback('okokBilling:GetSocietyInvoices', function(cb, totalInvoices, totalIncome, totalUnpaid, awaitedIncome)
        if json.encode(cb) ~= '[]' then
			SetNuiFocus(true, true)
			SendNUIMessage({
				action = 'societyinvoices',
				invoices = cb,
				totalInvoices = totalInvoices,
				totalIncome = totalIncome,
				totalUnpaid = totalUnpaid,
				awaitedIncome = awaitedIncome,
				VAT = Config.VATPercentage
			})		
		else
			Framework.Functions.Notify("Không có hóa đơn!", "error")
			-- exports['okokNotify']:Alert("BILLING", "Your society doesn't have invoices.", 10000, 'info')
			SetNuiFocus(false, false)
		end
    end, society)
end

function CreateInvoice(society)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'createinvoice',
		society = society
	})
end

RegisterCommand(Config.InvoicesCommand, function()
	local isAllowed = false
	local jobName = ""
	for k, v in pairs(Config.AllowedSocieties) do
		if v == PlayerData.job.name then
			jobName = v
			isAllowed = true
		end
	end

	if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif Config.OnlyBossCanAccessSocietyInvoices and not PlayerData.job.isboss and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = true
		})
	elseif not Config.OnlyBossCanAccessSocietyInvoices and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif not isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = false
		})
	end
end, false)

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		SetNuiFocus(false, false)
	elseif data.action == "payInvoice" then
		TriggerServerEvent("okokBilling:PayInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "cancelInvoice" then
		TriggerServerEvent("okokBilling:CancelInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "createInvoice" then
		local closestPlayer, playerDistance = Framework.Functions.GetClosestPlayer()
		print(data.invoice_item)
		if data.invoice_item ~= nil and data.invoice_item ~= "" then
			-- local closestPlayer, playerDistance = Framework.Functions.GetClosestPlayer()
			-- target = GetPlayerServerId(closestPlayer)
			data.target = tonumber(data.invoice_item)
			closestPlayer = 0
			playerDistance = 0
		else
			target = GetPlayerServerId(closestPlayer)
			data.target = target
			data.invoice_item = target
		end

		data.society = PlayerData.job.name
		data.society_name = PlayerData.job.label

		if closestPlayer == -1 or playerDistance > 3.0 then
			Framework.Functions.Notify("Không gửi được hóa đơn, không ai gần đó", "error")
			-- exports['okokNotify']:Alert("BILLING", "Error sending the invoice! There's nobody near you.", 10000, 'error')
		else
			TriggerServerEvent("okokBilling:CreateInvoice", data)
			Framework.Functions.Notify("Ghi hóa đơn thành công", "success")
			-- exports['okokNotify']:Alert("BILLING", "Invoice successfully sent!", 10000, 'success')
		end
		
		SetNuiFocus(false, false)
	elseif data.action == "missingInfo" then
		Framework.Functions.Notify("Vui lòng điền đầy đủ thông tin!", "error")
		-- exports['okokNotify']:Alert("BILLING", "Fill in all fields before sending an invoice!", 10000, 'error')
	elseif data.action == "negativeAmount" then
		Framework.Functions.Notify("Số tiền không hợp lệ!", "error")
		-- exports['okokNotify']:Alert("BILLING", "You need to set a positive amount!", 10000, 'error')
	elseif data.action == "mainMenuOpenMyInvoices" then
		MyInvoices()
	elseif data.action == "mainMenuOpenSocietyInvoices" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.isboss then
					SocietyInvoices(PlayerData.job.label)
				elseif not Config.OnlyBossCanAccessSocietyInvoices then
					SocietyInvoices(PlayerData.job.label)
				elseif Config.OnlyBossCanAccessSocietyInvoices then
					Framework.Functions.Notify("Chỉ có chủ doanh nghiệp mới có quyền xem hóa đơn!", "error")
					-- exports['okokNotify']:Alert("BILLING", "Only the boss can access the society invoices.", 10000, 'error')
				end
			end
		end
	elseif data.action == "mainMenuOpenCreateInvoice" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				CreateInvoice(PlayerData.job.label)
			end
		end
	end
end)