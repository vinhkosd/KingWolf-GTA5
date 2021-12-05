Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-emergencylights:server:get:config', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-emergencylights:server:setup:first:time')
AddEventHandler('pepe-emergencylights:server:setup:first:time', function(Plate)
    Config.ButtonData[Plate] = {
        ['Blue'] = false,
        ['Orange'] = false,
        ['Green'] = false,
        ['Stop'] = false,
        ['Follow'] = false,
        ['Siren'] = false,
        ['Pit'] = false,
    }
    TriggerClientEvent('pepe-emergencylights:client:setup:first:time', -1, Plate)
end)

RegisterServerEvent('pepe-emergencylights:server:update:button')
AddEventHandler('pepe-emergencylights:server:update:button', function(Data, Plate)
    Config.ButtonData[Plate][Data.Type] = Data.State
    TriggerClientEvent('pepe-emergencylights:client:update:button', -1, Data, Plate)
end)

RegisterServerEvent('pepe-emergencylights:server:toggle:sounds')
AddEventHandler('pepe-emergencylights:server:toggle:sounds', function(State)
    TriggerClientEvent('pepe-emergencylights:client:toggle:sounds', -1, source, State)
end)

RegisterServerEvent('pepe-emergencylights:server:set:sounds:disabled')
AddEventHandler('pepe-emergencylights:server:set:sounds:disabled', function()
    TriggerClientEvent('pepe-emergencylights:client:set:sounds:disabled', -1, source)
end)