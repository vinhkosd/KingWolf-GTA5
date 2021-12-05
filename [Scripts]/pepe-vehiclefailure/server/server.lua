Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("fix", "Sửa xe", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:fix:veh', source)
end, "god")

Framework.Commands.Add("lockpick", "Lockpick xe", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:hotwire:veh', source)
end, "god")

Framework.Commands.Add("mokhoaxe", "Lockpick xe", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:hotwire:veh', source)
end, "god")

Framework.Commands.Add("doxang", "Đổ xăng xe", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:fillfuel:veh', source)
end, "god")

Framework.Commands.Add("fillfuel", "Đổ xăng xe", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:fillfuel:veh', source)
end, "god")

Framework.Commands.Add("flipveh", "Lật xe", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:flip:veh', source)
end, "god")

Framework.Commands.Add("latxe", "Lật xe", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:flip:veh', source)
end, "god")

Framework.Commands.Add("dv2", "Xóa xe gần bạn", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:delc:veh', source)
end, "god")

Framework.Commands.Add("xoaxe", "Xóa xe gần bạn", {}, false, function(source, args)
    TriggerClientEvent('pepe-vehiclefailure:client:delc:veh', source)
end, "god")