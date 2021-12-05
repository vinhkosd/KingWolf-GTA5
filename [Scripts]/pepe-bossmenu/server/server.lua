Framework = nil
Accounts = {}
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

CreateThread(function()
    Wait(500)
    -- local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "./database.json"))
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `boss_accounts`", function(results)
        if results[1] ~= nil then
            for key, value in pairs(results) do
                -- local isOnline = Framework.Functions.GetPlayerByCitizenId(value.citizenid)

                -- if isOnline then
                --     table.insert(employees, {
                --         source = isOnline.PlayerData.citizenid, 
                --         grade = isOnline.PlayerData.job.grade,
                --         isboss = isOnline.PlayerData.job.isboss,
                --         name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                --     })
                -- else
                --     table.insert(employees, {
                --         source = value.citizenid, 
                --         grade =  json.decode(value.job).grade,
                --         isboss = json.decode(value.job).isboss,
                --         name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                --     })
                -- end
                local k = tostring(value.type)
                local v = tonumber(value.amount)
                print(k)
                print(v)
                if k and v then
                    Accounts[k] = v
                end
            end
        end
    end)
    -- if not result then
    --     return
    -- end

    -- for k,v in pairs(result) do
    --     local k = tostring(k)
    --     local v = tonumber(v)

    --     if k and v then
    --         Accounts[k] = v
    --     end
    -- end
end)

RegisterServerEvent("pepe-bossmenu:server:withdrawMoney")
AddEventHandler("pepe-bossmenu:server:withdrawMoney", function(amount)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if Accounts[job] >= amount then
        Accounts[job] = Accounts[job] - amount
        xPlayer.Functions.AddMoney("cash", amount)
    else
        TriggerClientEvent('Framework:Notify', src, "Số tiền bất bại :/", "error")
        return
    end

    TriggerClientEvent('pepe-bossmenu:client:refreshSociety', -1, job, Accounts[job])
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `boss_accounts` WHERE `type` = '"..job.."'", function(result)
        if result[1] ~= nil then
            Framework.Functions.ExecuteSql(false, "UPDATE `boss_accounts` SET `amount` = "..Accounts[job].." WHERE `type` = '"..job.."'")
        else
            Framework.Functions.ExecuteSql(false, "INSERT INTO `boss_accounts` (`type`, `amount`) VALUES ('"..job.."', "..Accounts[job]..")")
        end
    end)
    -- SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent('pepe-logs:server:createLog', 'bossmenu', 'Rút tiền', "Đã rút thành công $" .. amount .. ' (' .. job .. ')', src)
end)

RegisterServerEvent("pepe-bossmenu:server:depositMoney")
AddEventHandler("pepe-bossmenu:server:depositMoney", function(amount)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job.name

    if not Accounts[job] then
        Accounts[job] = 0
    end

    if xPlayer.Functions.RemoveMoney("cash", amount) then
        Accounts[job] = Accounts[job] + amount
    else
        TriggerClientEvent('Framework:Notify', src, "Sai số tiền :/", "error")
        return
    end

    TriggerClientEvent('pepe-bossmenu:client:refreshSociety', -1, job, Accounts[job])
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `boss_accounts` WHERE `type` = '"..job.."'", function(result)
        if result[1] ~= nil then
            Framework.Functions.ExecuteSql(false, "UPDATE `boss_accounts` SET `amount` = "..Accounts[job].." WHERE `type` = '"..job.."'")
        else
            Framework.Functions.ExecuteSql(false, "INSERT INTO `boss_accounts` (`type`, `amount`) VALUES ('"..job.."', "..Accounts[job]..")")
        end
    end)
    -- SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
    TriggerEvent('pepe-logs:server:createLog', 'bossmenu', 'Tiền đặt cọc', "Đổ xô thành công $" .. amount .. ' (' .. job .. ')', src)
end)

RegisterServerEvent("pepe-bossmenu:server:addAccountMoney")
AddEventHandler("pepe-bossmenu:server:addAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end    
    Accounts[account] = Accounts[account] + amount
    TriggerClientEvent('pepe-bossmenu:client:refreshSociety', -1, account, Accounts[account])
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `boss_accounts` WHERE `type` = '"..account.."'", function(result)
        if result[1] ~= nil then
            Framework.Functions.ExecuteSql(false, "UPDATE `boss_accounts` SET `amount` = "..Accounts[account].." WHERE `type` = '"..account.."'")
        else
            Framework.Functions.ExecuteSql(false, "INSERT INTO `boss_accounts` (`type`, `amount`) VALUES ('"..account.."', "..Accounts[account]..")")
        end
    end)
    -- SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("pepe-bossmenu:server:removeAccountMoney")
AddEventHandler("pepe-bossmenu:server:removeAccountMoney", function(account, amount)
    if not Accounts[account] then
        Accounts[account] = 0
    end

    if Accounts[account] >= amount then
        Accounts[account] = Accounts[account] - amount
    end

    TriggerClientEvent('pepe-bossmenu:client:refreshSociety', -1, account, Accounts[account])
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `boss_accounts` WHERE `type` = '"..account.."'", function(result)
        if result[1] ~= nil then
            Framework.Functions.ExecuteSql(false, "UPDATE `boss_accounts` SET `amount` = "..Accounts[account].." WHERE `type` = '"..account.."'")
        else
            Framework.Functions.ExecuteSql(false, "INSERT INTO `boss_accounts` (`type`, `amount`) VALUES ('"..account.."', "..Accounts[account]..")")
        end
    end)
    -- SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Accounts), -1)
end)

RegisterServerEvent("pepe-bossmenu:server:openMenu")
AddEventHandler("pepe-bossmenu:server:openMenu", function()
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local job = xPlayer.PlayerData.job
    local employees = {}

    if job.isboss == true then
        if not Accounts[job.name] then
            Accounts[job.name] = 0
        end

        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `job` LIKE '%".. job.name .."%'", function(players)
            if players[1] ~= nil then
                for key, value in pairs(players) do
                    local isOnline = Framework.Functions.GetPlayerByCitizenId(value.citizenid)

                    if isOnline then
                        table.insert(employees, {
                            source = isOnline.PlayerData.citizenid, 
                            grade = isOnline.PlayerData.job.grade,
                            isboss = isOnline.PlayerData.job.isboss,
                            name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                        })
                    else
                        table.insert(employees, {
                            source = value.citizenid, 
                            grade =  json.decode(value.job).grade,
                            isboss = json.decode(value.job).isboss,
                            name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                        })
                    end
                end
            end

            TriggerClientEvent('pepe-bossmenu:client:openMenu', src, employees, Framework.Shared.Jobs[job.name])
            TriggerClientEvent('pepe-bossmenu:client:refreshSociety', -1, job.name, Accounts[job.name])
        end)
    else
        TriggerClientEvent('Framework:Notify', src, "Bạn không phải là ông chủ, làm thế nào bạn đến đây??!", "error")
    end
end)

RegisterServerEvent('pepe-bossmenu:server:fireEmployee')
AddEventHandler('pepe-bossmenu:server:fireEmployee', function(data)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local xEmployee = Framework.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob("unemployed", '0') then
            TriggerEvent('pepe-logs:server:createLog', 'bossmenu', 'Ontslaan', "Succesvol ontslagen " .. GetPlayerName(xEmployee.PlayerData.source) .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)

            TriggerClientEvent('Framework:Notify', src, "Đã loại bỏ thành công!", "success")
            TriggerClientEvent('Framework:Notify', xEmployee.PlayerData.source , "Bạn bị sa thải.", "success")

            Wait(500)
            local employees = {}
            Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = Framework.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end
                    TriggerClientEvent('pepe-bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('Framework:Notify', src, "Lỗi.", "error")
        end
    else
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '" .. data.source .. "' LIMIT 1", function(player)
            if player[1] ~= nil then
                xEmployee = player[1]

                local job = {}
	            job.name = "unemployed"
	            job.label = "Unemployed"
	            job.payment = 10
	            job.onduty = true
	            job.isboss = false
	            job.grade = {}
	            job.grade.name = nil
                job.grade.level = 0

                Framework.Functions.ExecuteSql(false, "UPDATE `characters_metadata` SET `job` = '"..json.encode(job).."' WHERE `citizenid` = '".. data.source .."'")
                TriggerClientEvent('Framework:Notify', src, "Succesvol ontslagen!", "success")
                TriggerEvent('pepe-logs:server:createLog', 'bossmenu', 'Fire', "Succesvol ontslagen " .. data.source .. ' (' .. xPlayer.PlayerData.job.name .. ')', src)
                
                Wait(500)
                local employees = {}
                Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = Framework.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('pepe-bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('Framework:Notify', src, "Sai lầm. Không thể tìm thấy người chơi.", "error")
            end
        end)
    end
end)

RegisterServerEvent('pepe-bossmenu:server:giveJob')
AddEventHandler('pepe-bossmenu:server:giveJob', function(data)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local xTarget = Framework.Functions.GetPlayerByCitizenId(data.source)

    if xPlayer.PlayerData.job.isboss == true then
        if xTarget and xTarget.Functions.SetJob(xPlayer.PlayerData.job.name, '0') then
            print(json.encode(xTarget.PlayerData.job))
            xTarget.Functions.Save()
            -- Framework.Functions.ExecuteSql(false, "UPDATE `characters_metadata` SET `job` = '"..Framework.EscapeSqli(json.encode(xTarget.PlayerData.job)).."' WHERE `citizenid` = '".. data.source .."'")
            TriggerClientEvent('Framework:Notify', src, "Bạn tuyển dụng. " .. (xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname) .. " đến " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerClientEvent('Framework:Notify', xTarget.PlayerData.source , "Bạn đã được tuyển dụng cho " .. xPlayer.PlayerData.job.label .. ".", "success")
            TriggerEvent('pepe-logs:server:createLog', 'bossmenu', 'Tuyển dụng', "Tuyển dụng thành công. " .. (xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname) .. ' (' .. xTarget.PlayerData.job.label .. ')', src)
        end
    else
        TriggerClientEvent('Framework:Notify', src, "Bạn không phải là ông chủ, làm thế nào bạn đến đây??!", "error")
    end
end)

RegisterServerEvent('pepe-bossmenu:server:updateGrade')
AddEventHandler('pepe-bossmenu:server:updateGrade', function(data)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local xEmployee = Framework.Functions.GetPlayerByCitizenId(data.source)

    if xEmployee then
        if xEmployee.Functions.SetJob(xPlayer.PlayerData.job.name, data.grade) then
            TriggerClientEvent('Framework:Notify', src, "Quảng bá thành công!", "success")
            TriggerClientEvent('Framework:Notify', xEmployee.PlayerData.source , "Bạn vừa được thăng chức [" .. data.grade .."].", "success")

            Wait(500)
            local employees = {}
            Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                if players[1] ~= nil then
                    for key, value in pairs(players) do
                        local isOnline = Framework.Functions.GetPlayerByCitizenId(value.citizenid)
                    
                        if isOnline then
                            table.insert(employees, {
                                source = isOnline.PlayerData.citizenid, 
                                grade = isOnline.PlayerData.job.grade,
                                isboss = isOnline.PlayerData.job.isboss,
                                name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                            })
                        else
                            table.insert(employees, {
                                source = value.citizenid, 
                                grade =  json.decode(value.job).grade,
                                isboss = json.decode(value.job).isboss,
                                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                            })
                        end
                    end

                    TriggerClientEvent('pepe-bossmenu:client:refreshPage', src, 'employee', employees)
                end
            end)
        else
            TriggerClientEvent('Framework:Notify', src, "Lỗi.", "error")
        end
    else
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '" .. data.source .. "' LIMIT 1", function(player)
            if player[1] ~= nil then
                xEmployee = player[1]
                local job = Framework.Shared.Jobs[xPlayer.PlayerData.job.name]
                local employeejob = json.decode(xEmployee.job)
                employeejob.grade = job.grades[data.grade]
                Framework.Functions.ExecuteSql(false, "UPDATE `characters_metadata` SET `job` = '"..json.encode(employeejob).."' WHERE `citizenid` = '".. data.source .."'")
                TriggerClientEvent('Framework:Notify', src, "Quảng bá thành công!", "success")
                
                Wait(500)
                local employees = {}
                Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `job` LIKE '%".. xPlayer.PlayerData.job.name .."%'", function(players)
                    if players[1] ~= nil then
                        for key, value in pairs(players) do
                            local isOnline = Framework.Functions.GetPlayerByCitizenId(value.citizenid)
                        
                            if isOnline then
                                table.insert(employees, {
                                    source = isOnline.PlayerData.citizenid, 
                                    grade = isOnline.PlayerData.job.grade,
                                    isboss = isOnline.PlayerData.job.isboss,
                                    name = isOnline.PlayerData.charinfo.firstname .. ' ' .. isOnline.PlayerData.charinfo.lastname
                                })
                            else
                                table.insert(employees, {
                                    source = value.citizenid, 
                                    grade =  json.decode(value.job).grade,
                                    isboss = json.decode(value.job).isboss,
                                    name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
                                })
                            end
                        end

                        TriggerClientEvent('pepe-bossmenu:client:refreshPage', src, 'employee', employees)
                    end
                end)
            else
                TriggerClientEvent('Framework:Notify', src, "Sai lầm. Không thể tìm thấy người chơi.", "error")
            end
        end)
    end
end)

RegisterServerEvent('pepe-bossmenu:server:updateNearbys')
AddEventHandler('pepe-bossmenu:server:updateNearbys', function(data)
    local src = source
    local players = {}
    local xPlayer = Framework.Functions.GetPlayer(src)
    for _, player in pairs(data) do
        local xTarget = Framework.Functions.GetPlayer(player)
        if xTarget and xTarget.PlayerData.job.name ~= xPlayer.PlayerData.job.name then
            table.insert(players, {
                source = xTarget.PlayerData.citizenid,
                name = xTarget.PlayerData.charinfo.firstname .. ' ' .. xTarget.PlayerData.charinfo.lastname
            })
        end
    end

    TriggerClientEvent('pepe-bossmenu:client:refreshPage', src, 'recruits', players)
end)

function GetAccount(account)
    return Accounts[account] or 0
end