Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
  
Framework.Functions.CreateCallback('pepe-wiet:server:GetConfig', function(source, cb)
    cb(Config)
end)

Framework.Functions.CreateUseableItem("scissor", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-wiet:client:use:scissor', source)
    end
end)


RegisterServerEvent('pepe-wiet:server:set:dry:busy')
AddEventHandler('pepe-wiet:server:set:dry:busy', function(DryRackId, bool)
    Config.Plants['drogen'][DryRackId]['IsBezig'] = bool
    TriggerClientEvent('pepe-wiet:client:set:dry:busy', -1, DryRackId, bool)
end)

RegisterServerEvent('pepe-wiet:server:set:pack:busy')
AddEventHandler('pepe-wiet:server:set:pack:busy', function(PackerId, bool)
    Config.WeedLocations[PackerId]['IsBezig'] = bool
    TriggerClientEvent('pepe-wiet:client:set:pack:busy', -1, PackerId, bool)
end)

RegisterServerEvent('pepe-wiet:server:give:tak')
AddEventHandler('pepe-wiet:server:give:tak', function()
    local Speler = Framework.Functions.GetPlayer(source)
    Speler.Functions.AddItem('wet-tak', math.random(2,4))
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['wet-tak'], "add")
end)

RegisterServerEvent('pepe-wiet:server:add:item')
AddEventHandler('pepe-wiet:server:add:item', function(Item, Amount)
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.AddItem(Item, Amount)
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items[Item], "add")
end)

RegisterServerEvent('pepe-wiet:server:remove:item')
AddEventHandler('pepe-wiet:server:remove:item', function(Item, Amount)
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(Item, Amount)
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items[Item], "remove")
end)

Framework.Functions.CreateCallback('pepe-wiet:server:has:takken', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local ItemTak = Player.Functions.GetItemByName("wet-tak")
	if ItemTak ~= nil then
        if ItemTak.amount >= 2 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)

Framework.Functions.CreateCallback('pepe-wiet:server:has:nugget', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local ItemNugget = Player.Functions.GetItemByName("wet-tak")
    local ItemBag = Player.Functions.GetItemByName("plastic-bag")
	if ItemNugget ~= nil and ItemBag ~= nil then
        if ItemNugget.amount >= 2 and ItemBag.amount >= 1 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)

RegisterServerEvent('pepe-wiet:server:weed:reward')
AddEventHandler('pepe-wiet:server:weed:reward', function()
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 1000)
    if RandomValue >= 100 and RandomValue <= 400 then--30% ra lá cần
        local randomAmount = math.random(1, 2) * 2
        Player.Functions.AddItem('wet-tak', randomAmount)
        TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['wet-tak'], "add")
    elseif RandomValue >= 600 and RandomValue <= 850 then--25% ra túi nhựa trong đó 2% 9 cần sa - 98% 2 túi nhựa
        local SubValue = math.random(1,50)
        if SubValue == 1 then
            Player.Functions.AddItem('wet-tak', 6)
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['wet-tak'], "add")
        else
            Player.Functions.AddItem('plastic-bag', 2)
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['plastic-bag'], "add") 
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Bạn không nhận được gì cả", "error")
    end
end)


RegisterServerEvent('pepe-wiet:server:pack:item')
AddEventHandler('pepe-wiet:server:pack:item', function()
    local Player = Framework.Functions.GetPlayer(source)

    if Player.Functions.RemoveItem("wet-tak", 2) and Player.Functions.RemoveItem("plastic-bag", 1) then
        if Player.Functions.AddItem('weed_ak47', 1) then
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['weed_ak47'], "add")
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['wet-tak'], "remove")
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['plastic-bag'], "remove")
        else
            TriggerClientEvent('Framework:Notify', source, "Túi đã đầy không thể đóng gói", "error")
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Bạn không có đủ cần sa hoặc túi bóng để đóng gói", "error")
    end
end)