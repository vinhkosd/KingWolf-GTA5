Framework = nil

Citizen.CreateThread(function()

    while Framework == nil do

        TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

        Citizen.Wait(200)

    end

end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('kingwolf-hocnghe:client:ThiNghe')
AddEventHandler('kingwolf-hocnghe:client:ThiNghe', function()
    OpenTest()
end)

function OpenTest()
	SendNUIMessage({
		openQuestion = true
	})

	SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)
end

RegisterNUICallback('close', function(data, cb)
	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)
	--thi đậu
	TriggerServerEvent("kingwolf-hocnghe:server:transformLicense")
	cb()
end)

RegisterNUICallback('kick', function(data, cb)
	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)
	cb()
end)

RegisterNUICallback('closePanel', function(data, cb)
	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)
	cb()
end)

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
        openSection = 'question'
    })

	cb()
end)