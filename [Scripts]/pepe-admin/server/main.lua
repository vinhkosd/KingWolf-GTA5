Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
    ["devmode"] = "admin",
}

RegisterServerEvent('pepe-admin:server:togglePlayerNoclip')
AddEventHandler('pepe-admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("pepe-admin:client:toggleNoclip", playerId)
    end
end)

RegisterServerEvent('pepe-admin:server:debugtool')
AddEventHandler('pepe-admin:server:debugtool', function()
    local src = source
    if Framework.Functions.HasPermission(src, permissions["devmode"]) then
        TriggerClientEvent('koil-debug:toggle', src)
    end
end)

RegisterServerEvent('pepe-admin:server:killPlayer')
AddEventHandler('pepe-admin:server:killPlayer', function(playerId)
    TriggerClientEvent('hospital:client:KillPlayer', playerId)
end)

RegisterServerEvent('pepe-admin:server:kickPlayer')
AddEventHandler('pepe-admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "\n🛑 Bạn đã bị kick khỏi server:\n🛑 Lý do: "..reason.."\n\n")
    end
end)

RegisterServerEvent('pepe-admin:server:Freeze')
AddEventHandler('pepe-admin:server:Freeze', function(playerId, toggle)
    TriggerClientEvent('pepe-admin:client:Freeze', playerId, toggle)
end)

RegisterServerEvent('pepe-admin:server:serverKick')
AddEventHandler('pepe-admin:server:serverKick', function(reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(Framework.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "\n🛑 Bạn đã bị kick khỏi server:\n🛑 Lý do: Server Restart..\n\n")
            end
        end
    end
end)

RegisterServerEvent('pepe-admin:server:banPlayer')
AddEventHandler('pepe-admin:server:banPlayer', function(playerId, Reason)
    local src = source
    local BanId = 'BAN-'..math.random(11111,99999)
    if Framework.Functions.HasPermission(src, permissions["ban"]) then
        Framework.Functions.ExecuteSql(false, "INSERT INTO `server_bans` (`banid`, `name`, `steam`, `license`, `reason`, `bannedby`) VALUES ('"..BanId.."', '"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..Reason.."', '"..GetPlayerName(src).."')")
        TriggerEvent("pepe-logs:server:SendLog", "bans", "Verbannen", "green", "**Speler:** "..GetPlayerName(playerId).." \n**Reden:** " ..Reason.. "\n **Ban ID:** "..BanId.."\n**Door:** "..GetPlayerName(src))
        DropPlayer(playerId, "\n🔰 Bạn đã bị cấm khỏi máy chủ. \n🛑 Reden: " ..Reason.. '\n🛑 Ban ID: '..BanId..'\n🛑 Verbannen Door: ' ..GetPlayerName(source).. '\n\n Voor een unban kan je een ticket openen in de discord.')
    end      
end)

Framework.Commands.Add("announce", "Gửi thông báo toàn server", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

Framework.Commands.Add("admin", "Mở menu admin", {}, false, function(source, args)
    local group = Framework.Functions.GetPermission(source)
    TriggerClientEvent('pepe-admin:client:openMenu', source, group)
end, "admin")

Framework.Commands.Add("report", "Gửi báo cáo cho Admin (Chỉ gửi khi cần thiết!)", {{name="noi_dung", help="Nhập nội dung"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent('pepe-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "REPORT VERSTUURD", "normal", msg)
    TriggerEvent("ec-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

Framework.Commands.Add("s", "Gửi tin nhắn cho tất cả admin", {{name="noi_dung", help="Nhập nội dung"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    TriggerClientEvent('pepe-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

Framework.Commands.Add("reportr", "Trả lời báo cáo - Admin", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = Framework.Functions.GetPlayer(playerId)
    local Player = Framework.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "reportr", msg)
        TriggerClientEvent('Framework:Notify', source, "Đã phản hồi")
        TriggerEvent("ec-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(Framework.Functions.GetPlayers()) do
            if Framework.Functions.HasPermission(v, "admin") then
                if Framework.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "reportr", msg)
                end
            end
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Persoon is niet online", "error")
    end
end, "admin")

Framework.Commands.Add("reporttoggle", "Bật/Tắt nhận báo cáo", {}, false, function(source, args)
    Framework.Functions.ToggleOptin(source)
    if Framework.Functions.IsOptin(source) then
        TriggerClientEvent('Framework:Notify', source, "Bật nhận báo cáo", "success")
    else
        TriggerClientEvent('Framework:Notify', source, "TẮT nhận báo cáo", "error")
    end
end, "admin")

Framework.Commands.Add("unban", "Unban người chơi", {{name="Banid", help="BanId của người chơi"}}, true, function(source, args)
    local src = source
    local BanID = args[1]
    if BanID ~= nil then
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `server_bans` WHERE `banid` = '"..BanID.."'", function(result)
            if result[1] ~= nil then 
                Framework.Functions.ExecuteSql(false, "DELETE FROM `server_bans` WHERE `banid` = '"..BanID.."'")
                TriggerEvent("pepe-logs:server:SendLog", "bans", "Unban", "red", "**BanId:** "..BanID.." \n**Status:** Unbanned. \n**Door:** "..GetPlayerName(src))
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message error"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Ban ID:</strong> {1} <br><strong>Status:</strong> {2} <br><strong>Unbanned Door:</strong> {3} </div></div>',
                    args = {'Unban Info', BanID, 'Lệnh cấm đã bị thu hồi', GetPlayerName(src)}
                })
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geen bans gevonden op dit id')
            end
        end)
    else 
        TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geef een ban id op..')
    end
end, "admin")

Framework.Commands.Add("baninfo", "Xem thông tin ban của người chơi", {{name="BanId", help="BanId của người chơi"}}, true, function(source, args)
    local src = source
    local BanId = args[1]
    if BanId ~= nil then
        Framework.Functions.ExecuteSql(true, "SELECT * FROM `server_bans` WHERE `banid` = '"..BanId.."'", function(result)
            if result[1] ~= nil then 
                local Info = result[1].reason
                local bannedby = result[1].bannedby
                local bannedplayername = result[1].name
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message error"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Speler:</strong> {1} <br><strong>Ban ID:</strong> {2} <br><strong>Ban Reden:</strong> {3} <br><strong>Verbannen Door:</strong> {4} <br><strong>Notitie:</strong> {5} </div></div>',
                    args = {'Ban Info', bannedplayername, BanId, Info, bannedby, '/unban ' ..BanId.. ' | Nếu bạn muốn bỏ cấm người chơi này'}
                })
            else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Không tìm thấy BanId')
            end
        end)
    else 
    TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Vui lòng nhập BanId..')
    end
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = Framework.Functions.GetPlayer(src)
        if Framework.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(Framework.Functions.GetPlayers()) do
                    local Player = Framework.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Vui lòng nhập lý do..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Không đủ quyền hạn..')
        end
    else
        for k, v in pairs(Framework.Functions.GetPlayers()) do
            local Player = Framework.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Khởi động lại máy chủ, vui lòng chờ trong giây lát!")
            end
        end
    end
end, false)

RegisterServerEvent('pepe-admin:server:bringTp')
AddEventHandler('pepe-admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('pepe-admin:client:bringTp', targetId, coords)
end)

Framework.Functions.CreateCallback('pepe-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false
    if Framework.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('pepe-admin:server:setPermissions')
AddEventHandler('pepe-admin:server:setPermissions', function(targetId, group)
    Framework.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('Framework:Notify', targetId, 'Đã set permission thành công '..group.label)
end)

RegisterServerEvent('pepe-admin:server:OpenSkinMenu')
AddEventHandler('pepe-admin:server:OpenSkinMenu', function(targetId)
    TriggerClientEvent("pepe-clothing:client:openMenu", targetId)
end)

RegisterServerEvent('pepe-admin:server:SendReport')
AddEventHandler('pepe-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = Framework.Functions.GetPlayers()
    if Framework.Functions.HasPermission(src, "admin") then
        if Framework.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('pepe-admin:server:StaffChatMessage')
AddEventHandler('pepe-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = Framework.Functions.GetPlayers()

    if Framework.Functions.HasPermission(src, "admin") then
        if Framework.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)

Framework.Commands.Add("setammo", "Staff: Set manual ammo for a weapon.", {{name="amount", help="The amount of bullets, e.g .: 20"}, {name="weapon", help="Name of weapon, eg: WEAPON_RAILGUN"}}, false, function(source, args)
    local src = source
    local weapon = args[2] ~= nil and args[2] or "current"
    local amount = tonumber(args[1]) ~= nil and tonumber(args[1]) or 250

    TriggerClientEvent('pepe-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
end, 'admin')

Framework.Commands.Add("br", "Kéo người chơi về.", {{name="id", help="ID người chơi"}}, false, function(source, args)
    local playerId = tonumber(args[1])

    local plyCoords = GetEntityCoords(GetPlayerPed(source))

    TriggerEvent('pepe-admin:server:bringTp', playerId, plyCoords)
end, 'admin')

Framework.Commands.Add("tps", "Dịch chuyển đến một người chơi hoặc tọa độ", {{name="id/x", help="ID van een Player of X positie"}, {name="y", help="Y positie"}, {name="z", help="Z positie"}}, false, function(source, args)
    local playerId = tonumber(args[1])
	TriggerClientEvent('pepe-admin:client:bring:to', playerId, source)
end, "admin")

Framework.Commands.Add("nc", "Toggle No clip", {}, false, function(source, args)
    TriggerEvent("pepe-admin:server:togglePlayerNoclip", source)
end, 'admin')

Framework.Commands.Add("triggerlogin", "Trigger Player Login", {{name="id", help="ID người chơi"}}, false, function(source, args)
    src = source
    local playerId = args[1]
    if playerId == nil then 
        playerId = src
    else
        playerId = tonumber(playerId)
    end

    TriggerClientEvent("Framework:Client:OnPlayerLoaded", playerId)
end, 'admin')



Framework.Commands.Add("fakecops", "Giả lập số lượng cảnh sát lên 15", {}, false, function(source, args)
    TriggerClientEvent("pepe-police:SetCopCount", -1, 15)
end, 'admin')

Framework.Commands.Add("savecar", "Lưu xe vào ga-ra", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent('pepe-admin:client:SaveCar', source)
end, "god")

RegisterServerEvent('pepe-admin:server:SaveCar')
AddEventHandler('pepe-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local pData = Framework.Functions.GetPlayer(source)
    
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local GarageData = "Legion Parking"
    -- local plate = GeneratePlate()
    Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vehicle.."', '"..plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
end)

Framework.Commands.Add("setmodel", "Change into a model of your choice..", {{name="model", help="Name of the model"}, {name="id", help="Player ID (leave blank for yourself)"}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])

    if model ~= nil or model ~= "" then
        if target == nil then
            TriggerClientEvent('pepe-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = Framework.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('pepe-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('Framework:Notify', source, "This person is not in town yeet..", "error")
            end
        end
    else
        TriggerClientEvent('Framework:Notify', source, "You have not provided a Model ..", "error")
    end
end, "admin")