Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("ap", "Tự động lái..", {}, false, function(source, args)
    local src = source
    TriggerClientEvent("autopilot:start", src)
end, "admin")

Framework.Commands.Add("sap", "Tắt tự động lái..", {}, false, function(source, args)
    local src = source
    TriggerClientEvent("autopilot:stop", src)
end, "admin")