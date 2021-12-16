Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

productBills = {}

RegisterServerEvent('kingwolf-shopping:server:buyItem')
AddEventHandler('kingwolf-shopping:server:buyItem', function(cartItems, type, priceConfig)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    --ghi hoa don so tien
    local billNote = ""
    local labelNote = ""
    local billAmount = 0

    for i = 1, #cartItems do
        local cartItem = cartItems[i]
        local itemInfo = Framework.Shared.Items[cartItem.name:lower()]
        billNote = billNote..cartItem.amount.." x "..cartItem.name..", "
        labelNote = labelNote..cartItem.amount.." x "..itemInfo["label"]..", "
        if priceConfig[cartItem.name] == nil then
            TriggerClientEvent("Framework:Notify", src, "Không thể tìm thấy vật phẩm :"..cartItem.name , "error")
            return
        end
        billAmount = billAmount + tonumber(cartItem.amount) * tonumber(priceConfig[cartItem.name])
    end

    local data = {}
    data.target = src-- nhân viên trà đá hoặc pizza
    data.source = src-- nhân viên trà đá hoặc pizza
    data.invoice_value = billAmount
    data.invoice_item = src
    data.society = type
    data.invoice_notes = billNote
    data.label_note = labelNote
    local JobInfo = Framework.Shared.Jobs[type]
    data.society_name = JobInfo.label
    data.created = false
    data.target_name = GetPlayerName(src)
    data.phone = Player.PlayerData.charinfo.phone

    table.insert(productBills, data)
    

    -- local playerList = FindPlayerByJobName(type)
    -- for _, player in pairs(playerList) do
        -- TriggerClientEvent('pepe-phone:client:addNotification', player.source, "Bạn vừa có đơn hàng "..billAmount.."$ mới!")
        -- TriggerClientEvent('Framework:Notify', player.source, "Bạn vừa có đơn hàng "..billAmount.."$ mới!", "success")
        
    -- end
    TriggerEvent('kingwolf-shopping:server:send:alert', GetEntityCoords(GetPlayerPed(src)), "", type)
    TriggerClientEvent('kingwolf-shopping:client:refreshData', -1)
end)



Framework.Functions.CreateCallback("kingwolf-shopping:server:getProductBills", function(source, cb, job)
    receivedBills = {}
    pendingBills = {}
    for i = 1, #productBills do
        billData = productBills[i]
        billData.id = i
        if job == billData.society then
            if billData.created then
                table.insert(receivedBills, billData)
            else
                table.insert(pendingBills, billData)
            end
        end
    end



	cb(receivedBills, pendingBills)
end)

Framework.Functions.CreateCallback("kingwolf-shopping:server:getCoords", function(source, cb, id)
    if productBills[id] ~= nil then
        pedId = productBills[id].target
        ped = GetPlayerPed(pedId)
        pedCoords = GetEntityCoords(ped)
        -- data.coords = {table.unpack(pedCoords)}
        cb(pedCoords)
    else
        cb(nil)
    end

end)

RegisterServerEvent('kingwolf-shopping:server:callPlayer')
AddEventHandler('kingwolf-shopping:server:callPlayer', function(id)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)
    if productBills[id] ~= nil then
        local Target = Framework.Functions.GetPlayerByPhone(productBills[id].phone)
        if Target ~= nil then
            CallData = {}
            CallData.number = productBills[id].phone
            CallData.name = Target.target_name
            TriggerClientEvent('pepe-phone:client:CallContact', src, CallData, false)
        else
            TriggerClientEvent("Framework:Notify", src, "Người chơi không trực tuyến" , "error")
        end
    else
        TriggerClientEvent("Framework:Notify", src, "Hóa đơn không hợp lệ" , "error")
    end
end)

RegisterServerEvent('kingwolf-shopping:server:acceptBill')
AddEventHandler('kingwolf-shopping:server:acceptBill', function(id)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    
   

    if productBills[id] ~= nil then
        if Player.PlayerData.job.name ~= productBills[id].society or not Player.PlayerData.job.onduty then
            local staffName = productBills[id].society_name
            TriggerClientEvent("Framework:Notify", src, "Bạn phải là nhân viên "..staffName.." mới có thể nhận đơn này!" , "error")
            return
        end

        local data = productBills[id]
        local Target = Framework.Functions.GetPlayer(data.target)
        if Target ~= nil then
            if not productBills[id].created then
                Framework.Functions.TriggerCallback('okokBilling:CreateCustomInvoice', src, function(flag)
                    if flag then
                        productBills[id].created = true
                        local shipperName = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
                        TriggerClientEvent("Framework:Notify", data.target, "Đơn hàng của bạn đã được shipper ["..shipperName.."] nhận" , "error")
                        TriggerClientEvent("Framework:Notify", src, "Nhận đơn thành công" , "error")

                        pedId = productBills[id].target
                        ped = GetPlayerPed(pedId)
                        pedCoords = GetEntityCoords(ped)

                        TriggerClientEvent("kingwolf-shopping:client:setGPS", src, pedCoords)
                        TriggerClientEvent('kingwolf-shopping:client:refreshData', -1, productBills[id].society)
                    else
                        TriggerClientEvent("Framework:Notify", src, "Không thể tạo hóa đơn" , "error")
                    end
                end, data)
            else
                TriggerClientEvent("Framework:Notify", src, "Đơn này đã được người khác nhận! Không thể nhận đơn." , "error")
            end
        else
            TriggerClientEvent("Framework:Notify", src, "Người chơi không online" , "error")
        end
        
    else
        TriggerClientEvent("Framework:Notify", src, "Hóa đơn không hợp lệ" , "error")
    end
end)

RegisterServerEvent('kingwolf-shopping:server:send:alert')
AddEventHandler('kingwolf-shopping:server:send:alert', function(Coords, StreetName, job)
    TriggerClientEvent('kingwolf-shopping:client:send:alert', -1, Coords, StreetName, job)
end)

function FindPlayerByJobName(jobName)
    local playerList = {}
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == jobName and Player.PlayerData.job.onduty) then
                table.insert(playerList, {
                    source = Player.PlayerData.source, 
                })
            end
        end
    end
    return playerList
end