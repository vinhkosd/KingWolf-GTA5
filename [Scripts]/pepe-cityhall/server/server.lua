Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-cityhall:server:requestId')
AddEventHandler('pepe-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local licenses = {
        ["driver"] = true,
    }
    local info = {}
    if identityData.item == "id-card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "drive-card" then
        -- info.firstname = Player.PlayerData.charinfo.firstname
        -- info.lastname = Player.PlayerData.charinfo.lastname
        -- info.birthdate = Player.PlayerData.charinfo.birthdate
        -- info.type = "A1-A2-A | AM-B | C1-C-CE"
        TriggerClientEvent('Framework:Notify', src, 'Để mua bằng, bạn cần tới trường thi bằng lái!')
        return
    end
    Player.Functions.AddItem(identityData.item, 1, false, info)
    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[identityData.item], 'add')
end)

RegisterServerEvent('pepe-cityhall:server:ApplyJob')
AddEventHandler('pepe-cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if job == "hocnghe" then
        local PhieuDangKyNghe = Player.Functions.GetItemByName('farm-register')
        if Player.PlayerData.metadata["farm-register-date"] ~= nil then
            local ts = tonumber(Player.PlayerData.metadata["farm-register-date"])
            if ts > os.time() then
                remainingseconds = ts - os.time()
                local hoursRemaining = math.floor(remainingseconds/3600)
                local minutesRemaining = math.floor((remainingseconds - hoursRemaining * 3600)/60)
                local secondsRemaining = math.floor((remainingseconds - hoursRemaining * 3600 - minutesRemaining * 60))

                local remainingTimeText = hoursRemaining.." giờ, "..minutesRemaining.." phút, "..secondsRemaining.." giây"

                TriggerClientEvent('Framework:Notify', source, "Bạn đã đăng ký học nghề trước đó (Còn "..remainingTimeText..")!")
                return
            end
        end
        if PhieuDangKyNghe == nil then
            Player.Functions.AddItem("farm-register", 1)
            -- Player.Functions.SetMetaData("farm-register-date", os.time() + 3 * 24 * 60 * 60)--hạn 3 ngày được nộp
            Player.Functions.SetMetaData("farm-register-date", os.time() + 1 * 60)--hạn 1 phut được nộp
            TriggerClientEvent('Framework:Notify', src, 'Bạn nhận được phiếu đăng ký nghề!')
            
            return
        else
            TriggerClientEvent('Framework:Notify', src, 'Bạn đã có phiếu đăng ký nghề!')
        end
        return
    end

    local JobInfo = Framework.Shared.Jobs[job]

    if JobInfo ~= nil then

        Player.Functions.SetJob(job, 0)

        TriggerClientEvent('Framework:Notify', src, 'Bạn đã nhận việc ('..JobInfo.label..')!')
    end
end)