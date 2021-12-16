

local ResetStress = false

Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

Framework.Commands.Add('cash', 'Check Cash Balance', {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local cashamount = Player.PlayerData.money.cash
    TriggerClientEvent('Framework:Notify', source, 'Bạn có $'..cashamount..' tiền mặt','primary', 3700)
	TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)

end)

Framework.Commands.Add('bank', 'Check Bank Balance', {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local bankamount = Player.PlayerData.money.bank
    TriggerClientEvent('Framework:Notify', source, 'Bạn có $'..bankamount..' ngân hàng','primary', 3700)
	TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
end)
 

RegisterServerEvent("pepe-hud:Server:UpdateStress")
AddEventHandler('pepe-hud:Server:UpdateStress', function(StressGain)
	local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata["stress"] == nil then
                Player.PlayerData.metadata["stress"] = 0
            end
            newStress = Player.PlayerData.metadata["stress"] + StressGain
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData("stress", newStress)
		TriggerClientEvent("hud:client:UpdateStress", src, newStress)
	end
end)

RegisterServerEvent('hud:server:GainStress')
AddEventHandler('hud:server:GainStress', function(amount)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil and Player.PlayerData.job.name ~= 'police' then
        if not ResetStress then
            if Player.PlayerData.metadata['stress'] == nil then
                Player.PlayerData.metadata['stress'] = 0
            end
            newStress = Player.PlayerData.metadata['stress'] + amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData('stress', newStress)
        TriggerClientEvent('hud:client:UpdateStress', src, newStress)
        TriggerClientEvent('Framework:Notify', src, 'Getting Stressed', 'error', 1500)
	end
end)

RegisterServerEvent('hud:server:RelieveStress')
AddEventHandler('hud:server:RelieveStress', function(amount)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata['stress'] == nil then
                Player.PlayerData.metadata['stress'] = 0
            end
            newStress = Player.PlayerData.metadata['stress'] - amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData('stress', newStress)
        TriggerClientEvent('hud:client:UpdateStress', src, newStress)
        TriggerClientEvent('Framework:Notify', src, 'You Are Relaxing')
	end
end)

RegisterServerEvent('pepe-hud:Server:RelieveStress')
AddEventHandler('pepe-hud:Server:RelieveStress', function(amount)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata["stress"] == nil then
                Player.PlayerData.metadata["stress"] = 0
            end
            newStress = Player.PlayerData.metadata["stress"] - amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData("stress", newStress)
        TriggerClientEvent("pepe-hud:client:update:stress", src, newStress)
        -- TriggerClientEvent('Framework:Notify', src, 'Giảm căng thẳng')
	end
end)

RegisterServerEvent('pepe-hud:server:remove:stress')
AddEventHandler('pepe-hud:server:remove:stress', function(Amount)
    local Player = Framework.Functions.GetPlayer(source)
    local NewStress = nil
    if Player ~= nil then
      NewStress = Player.PlayerData.metadata["stress"] - Amount
      if NewStress <= 0 then NewStress = 0 end
      if NewStress > 105 then NewStress = 100 end
      Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("pepe-hud:client:update:stress", Player.PlayerData.source, NewStress)
    end
end)

RegisterServerEvent('pepe-hud:server:gain:stress')
AddEventHandler('pepe-hud:server:gain:stress', function(amount)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata["stress"] == nil then
                Player.PlayerData.metadata["stress"] = 0
            end
            newStress = Player.PlayerData.metadata["stress"] + amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData("stress", newStress)
        TriggerClientEvent("pepe-hud:client:update:stress", src, newStress)
        -- TriggerClientEvent('Framework:Notify', src, 'Bạn đang bị căng thẳng', 'error', 1500)
	end
end)

RegisterServerEvent('pepe-hud:server:need:food')
AddEventHandler('pepe-hud:server:need:food', function(newHunger, newThirst)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        local oldHunger = Player.PlayerData.metadata["hunger"] - newHunger
        local oldThirst = Player.PlayerData.metadata["thirst"] - newThirst
        Player.Functions.SetMetaData("hunger", oldHunger)
        Player.Functions.SetMetaData("thirst", oldThirst)
        TriggerClientEvent("pepe-hud:client:update:needs", src, newHunger, newThirst)
    end
end)

RegisterServerEvent('equip:harness')
AddEventHandler('equip:harness', function(item)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Player.PlayerData.items[item.slot].info.uses - 1 == 0 then
        TriggerClientEvent("inventory:client:ItemBox", source, Framework.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterServerEvent('seatbelt:DoHarnessDamage')
AddEventHandler('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses = Player.PlayerData.items[data.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)