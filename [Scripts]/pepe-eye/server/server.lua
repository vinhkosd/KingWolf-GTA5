Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("eyereset", "Reset the eye.", {}, false, function(source, args)
    TriggerClientEvent('pepe-eye:client:refresh', source)
end)

Framework.Commands.Add("resettrunk", "Reset the eye.", {}, false, function(source, args)
    local Plate = args[1]
    Config.TrunkData[Plate] = {['Busy'] = false}
    TriggerClientEvent('pepe-eye:client:sync:trunk:data', -1, Config.TrunkData)
end, "admin")

RegisterServerEvent('pepe-eye:server:setup:trunk:data')
AddEventHandler('pepe-eye:server:setup:trunk:data', function(Plate)
    Config.TrunkData[Plate] = {['Busy'] = false}
    TriggerClientEvent('pepe-eye:client:sync:trunk:data', -1, Config.TrunkData)
end)

RegisterServerEvent('pepe-eye:server:set:trunk:data')
AddEventHandler('pepe-eye:server:set:trunk:data', function(Plate, Bool)
    Config.TrunkData[Plate]['Busy'] = Bool
    TriggerClientEvent('pepe-eye:client:sync:trunk:data', -1, Config.TrunkData)
end)
