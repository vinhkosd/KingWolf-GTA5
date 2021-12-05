Framework= nil

TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

RegisterServerEvent('kingwolf-hocnghe:server:transformLicense')
AddEventHandler('kingwolf-hocnghe:server:transformLicense', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local PhieuDangKyNghe = Player.Functions.GetItemByName('farm-register')
	
    if PhieuDangKyNghe ~= nil then
        if Player.Functions.RemoveItem("farm-register", 1) then
            local info = {}
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
            Player.Functions.AddItem("farm-license", 1, false, info)
        end
        
        TriggerClientEvent('Framework:Notify', source, 'Bạn đã thi nghề thành công, bạn nhận được chứng chỉ nghề!')
        return
    else
        TriggerClientEvent('Framework:Notify', source, 'Không tìm thấy phiếu đăng ký nghề của bạn!')
    end
end)

Framework.Functions.CreateUseableItem("farm-register", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.PlayerData.metadata["farm-register-date"] ~= nil then
            local ts = tonumber(Player.PlayerData.metadata["farm-register-date"])
            if ts < os.time() then
                -- mở màn hình đăng ký thi nghề lên
                TriggerClientEvent('kingwolf-hocnghe:client:ThiNghe', source)
            else
                remainingseconds = ts - os.time()
                local hoursRemaining = math.floor(remainingseconds/3600)
                local minutesRemaining = math.floor((remainingseconds - hoursRemaining * 3600)/60)
                local secondsRemaining = math.floor((remainingseconds - hoursRemaining * 3600 - minutesRemaining * 60))

                local remainingTimeText = hoursRemaining.." giờ, "..minutesRemaining.." phút, "..secondsRemaining.." giây"

                TriggerClientEvent('Framework:Notify', source, "Bạn chưa đủ thời gian để đăng ký học nghề (Còn "..remainingTimeText..")!") 
            end
        else
            TriggerClientEvent('Framework:Notify', source, 'Không thể kiểm tra thông tin đăng ký học nghề!')
        end
    end
end)