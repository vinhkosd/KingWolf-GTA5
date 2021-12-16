PlayerData = {}

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterNetEvent('kingwolf-shopping:client:openMenu')
AddEventHandler('kingwolf-shopping:client:openMenu', function()
	SetNuiFocus(true, true)
	local pizzaProduct = {}
    local PizzaItems = exports['kingwolf-pizza']:GetItems()
    for i = 1, #PizzaItems.items do
        local item = PizzaItems.items[i]
        item.amount = 50
        local itemInfo = Framework.Shared.Items[item.name:lower()]
        table.insert(pizzaProduct, {
            label = itemInfo["label"],
            name = item.name,
            amount = item.amount,
            price = item.price
        })
    end

	local tradaProduct = {}
    local tradaItems = exports['kingwolf-trada']:GetItems()
    for i = 1, #tradaItems.items do
        local item = tradaItems.items[i]
        item.amount = 50
        local itemInfo = Framework.Shared.Items[item.name:lower()]
        table.insert(tradaProduct, {
            label = itemInfo["label"],
            name = item.name,
            amount = item.amount,
            price = item.price
        })
    end

    Framework.Functions.TriggerCallback('kingwolf-shopping:server:getProductBills', function(productBills, productPendingBills)
        local canOpenBill = false
        if Framework.Functions.GetPlayerData().job.name == "pizza" and Framework.Functions.GetPlayerData().job.onduty then
            canOpenBill = true
        end

        if Framework.Functions.GetPlayerData().job.name == "trada" and Framework.Functions.GetPlayerData().job.onduty then
            canOpenBill = true
        end

        SendNUIMessage({
            action = 'mainmenu',
            pizzaProduct = pizzaProduct,
            tradaProduct = tradaProduct,
            productBills = productBills,
            canOpenBill = canOpenBill,
            productPendingBills = productPendingBills,
        })
    end, Framework.Functions.GetPlayerData().job.name)
end)

RegisterNetEvent('kingwolf-shopping:client:refreshData')
AddEventHandler('kingwolf-shopping:client:refreshData', function(job)
	local pizzaProduct = {}
    local PizzaItems = exports['kingwolf-pizza']:GetItems()
    for i = 1, #PizzaItems.items do
        local item = PizzaItems.items[i]
        item.amount = 50
        local itemInfo = Framework.Shared.Items[item.name:lower()]
        table.insert(pizzaProduct, {
            label = itemInfo["label"],
            name = item.name,
            amount = item.amount,
            price = item.price
        })
    end

	local tradaProduct = {}
    local tradaItems = exports['kingwolf-trada']:GetItems()
    for i = 1, #tradaItems.items do
        local item = tradaItems.items[i]
        item.amount = 50
        local itemInfo = Framework.Shared.Items[item.name:lower()]
        table.insert(tradaProduct, {
            label = itemInfo["label"],
            name = item.name,
            amount = item.amount,
            price = item.price
        })
    end

    Framework.Functions.TriggerCallback('kingwolf-shopping:server:getProductBills', function(productBills, productPendingBills)
        local canOpenBill = false
        if Framework.Functions.GetPlayerData().job.name == "pizza" and Framework.Functions.GetPlayerData().job.onduty then
            canOpenBill = true
        end

        if Framework.Functions.GetPlayerData().job.name == "trada" and Framework.Functions.GetPlayerData().job.onduty then
            canOpenBill = true
        end

        SendNUIMessage({
            action = 'refreshdata',
            pizzaProduct = pizzaProduct,
            tradaProduct = tradaProduct,
            productBills = productBills,
            canOpenBill = canOpenBill,
            productPendingBills = productPendingBills,
        })
    end, job)
end)

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		SetNuiFocus(false, false)
	elseif data.action == "buyItem" then
		-- TriggerServerEvent("buyItem:buyItem", data)
        local cartItems = data.carts
        local type = data.productState

        local priceConfig = {}

        if type == "pizza" then
            
            local PizzaItems = exports['kingwolf-pizza']:GetItems()
            for i = 1, #PizzaItems.items do
                local item = PizzaItems.items[i]
                priceConfig[item.name] = item.price
            end
        else
            local TradaItems = exports['kingwolf-trada']:GetItems()
            for i = 1, #TradaItems.items do
                local item = TradaItems.items[i]
                priceConfig[item.name] = item.price
            end
        end
        
        TriggerServerEvent("kingwolf-shopping:server:buyItem", cartItems, type, priceConfig)
    elseif data.action == "setGPS" then
        Framework.Functions.TriggerCallback('kingwolf-shopping:server:getCoords', function(coords)
            -- coords
            if coords ~= nil then
                SetNewWaypoint(coords.x, coords.y)
                Framework.Functions.Notify("Đã nhận đơn!", "error")
            else
                Framework.Functions.Notify("Không thể tìm thấy hóa đơn này!", "error")
            end
        end, data.productId)
    elseif data.action == "callPlayer" then
        TriggerServerEvent("kingwolf-shopping:server:callPlayer", data.productId)
    elseif data.action == "acceptBill" then
        TriggerServerEvent("kingwolf-shopping:server:acceptBill", data.productId)
	end
end)

RegisterNetEvent('kingwolf-shopping:client:setGPS')
AddEventHandler('kingwolf-shopping:client:setGPS', function(coords)
    SetNewWaypoint(coords.x, coords.y)
end)