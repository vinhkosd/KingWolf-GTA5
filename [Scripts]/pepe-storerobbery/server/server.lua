Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-storerobbery:server:get:config', function(source, cb)
    cb(Config)
end)

Framework.Commands.Add("resetsafes", "Đặt lại các cửa hàng", {}, false, function(source, args)
    for k, v in pairs(Config.Safes) do
        Config.Safes[k]['Busy'] = false
        TriggerClientEvent('pepe-storerobbery:client:safe:busy', -1, k, false)
    end
end, "admin")

Framework.Functions.CreateCallback('pepe-storerobbery:server:HasItem', function(source, cb, itemName)
    local Player = Framework.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(itemName)
	if Player ~= nil then
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Registers) do
            if Config.Registers[k]['Time'] > 0 and (Config.Registers[k]['Time'] - Config.Inverval) >= 0 then
                Config.Registers[k]['Time'] = Config.Registers[k]['Time'] - Config.Inverval
            else
                Config.Registers[k]['Time'] = 0
                Config.Registers[k]['Robbed'] = false
                TriggerClientEvent('pepe-storerobbery:client:set:register:robbed', -1, k, false)
            end
        end
        Citizen.Wait(Config.Inverval)
    end
end)

RegisterServerEvent('pepe-storerobbery:server:set:register:robbed')
AddEventHandler('pepe-storerobbery:server:set:register:robbed', function(RegisterId, bool)
    Config.Registers[RegisterId]['Robbed'] = bool
    Config.Registers[RegisterId]['Time'] = Config.ResetTime
    TriggerClientEvent('pepe-storerobbery:client:set:register:robbed', -1, RegisterId, bool)
end)

RegisterServerEvent('pepe-storerobbery:server:set:register:busy')
AddEventHandler('pepe-storerobbery:server:set:register:busy', function(RegisterId, bool)
    Config.Registers[RegisterId]['Busy'] = bool
    TriggerClientEvent('pepe-storerobbery:client:set:register:busy', -1, RegisterId, bool)
end)

RegisterServerEvent('pepe-storerobbery:server:safe:busy')
AddEventHandler('pepe-storerobbery:server:safe:busy', function(SafeId, bool)
    Config.Safes[SafeId]['Busy'] = bool
    TriggerClientEvent('pepe-storerobbery:client:safe:busy', -1, SafeId, bool)
end)

RegisterServerEvent('pepe-storerobbery:server:safe:robbed')
AddEventHandler('pepe-storerobbery:server:safe:robbed', function(SafeId, bool)
    Config.Safes[SafeId]['Robbed'] = bool
    TriggerClientEvent('pepe-storerobbery:client:safe:robbed', -1, SafeId, bool)
    SetTimeout((1000 * 60) * 25, function()
        TriggerClientEvent('pepe-storerobbery:client:safe:robbed', -1, SafeId, false)
        Config.Safes[SafeId]['Robbed'] = false
    end)
end)

RegisterServerEvent('pepe-storerobbery:server:rob:register')
AddEventHandler('pepe-storerobbery:server:rob:register', function(RegisterId, IsDone)
    local Player = Framework.Functions.GetPlayer(source)
    local curRep = Player.PlayerData.metadata["lockpickrep"]
    Player.Functions.AddMoney('cash', math.random(50, 92), "Winkel overval")
    if IsDone then
        local RandomItem = Config.SpecialItems[math.random(#Config.SpecialItems)]
        local RandomValue = math.random(1, 100)
        if RandomValue <= 16 then--1.3% ra thẻ xanh đỏ tím vàng
            Player.Functions.AddItem(RandomItem, 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items[RandomItem], "add")
        end

        Player.Functions.AddMoney('cash', 1900, "store-register-robbed")
        -- Player.Functions.AddItem('money-roll', math.random(2, 12))
        -- TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['money-roll'], "add")
        Player.Functions.SetMetaData('lockpickrep', (curRep + 1))
    end
end)

RegisterServerEvent('pepe-storerobbery:server:safe:reward')
AddEventHandler('pepe-storerobbery:server:safe:reward', function()
    local Player = Framework.Functions.GetPlayer(source)
    local RandomItem = Config.SpecialItems[math.random(#Config.SpecialItems)]
    -- Player.Functions.AddMoney('cash', 1000, "store-safe-robbed")
    Player.Functions.AddItem("gold-bar", 4)
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items["gold-bar"], "add") 
end)