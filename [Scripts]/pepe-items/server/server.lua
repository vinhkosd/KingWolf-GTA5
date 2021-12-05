Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

-- // Lockpick \\ --
Framework.Functions.CreateUseableItem("advancedlockpick", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-items:client:use:lockpick', source, true)
    end
end)

Framework.Functions.CreateUseableItem("lockpick", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-items:client:use:lockpick', source, false)
    end
end)

Framework.Functions.CreateUseableItem("drill", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-items:client:use:drill', source)
    end
end)

-- // Eten \\ --

Framework.Functions.CreateUseableItem("water", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:drink', source, 'water', 'water')
        end
    end
end)

Framework.Functions.CreateUseableItem("ecola", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:drink', source, 'ecola', 'cola')
        end
    end
end)

Framework.Functions.CreateUseableItem("sprunk", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:drink', source, 'sprunk', 'cola')
        end
    end
end)

Framework.Functions.CreateUseableItem("slushy", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:drink:slushy', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("sandwich", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'sandwich', 'sandwich')
        end
    end
end)

Framework.Functions.CreateUseableItem("chocolade", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'chocolade', 'chocolade')
        end
    end
end)

Framework.Functions.CreateUseableItem("420-choco", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, '420-choco', 'chocolade')
        end
    end
end)

Framework.Functions.CreateUseableItem("donut", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'donut', 'donut')
        end
    end
end)

Framework.Functions.CreateUseableItem("coffee", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:drink', source, 'coffee', 'coffee')
        end
    end
end)

-- BurgerShot

Framework.Functions.CreateUseableItem("burger-bleeder", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'burger-bleeder', 'hamburger')
        end
    end
end)

Framework.Functions.CreateUseableItem("burger-moneyshot", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'burger-moneyshot', 'hamburger')
        end
    end
end)

Framework.Functions.CreateUseableItem("burger-torpedo", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'burger-torpedo', 'hamburger')
        end
    end
end)

Framework.Functions.CreateUseableItem("burger-heartstopper", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'burger-heartstopper', 'hamburger')
        end
    end
end)

Framework.Functions.CreateUseableItem("burger-softdrink", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:drink', source, 'burger-softdrink', 'burger-soft')
        end
    end
end)

Framework.Functions.CreateUseableItem("burger-fries", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:eat', source, 'burger-fries', 'burger-fries')
        end
    end
end)

Framework.Functions.CreateUseableItem("burger-box", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-burgershot:client:open:box', source, item.info.boxid)
    end
end)

Framework.Functions.CreateUseableItem("burger-coffee", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:drink', source, 'burger-coffee', 'coffee')
        end
    end
end)

-- // Other \\ --

Framework.Functions.CreateUseableItem("ciggy", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:cigarette', source, true)
        end
    end
end)

Framework.Functions.CreateUseableItem("duffel-bag", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-items:client:use:duffel-bag', source, item.info.bagid)
    end
end)

Framework.Functions.CreateUseableItem("armor", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:armor', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("heavy-armor", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:heavy', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("repairkit", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:repairkit', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("bandage", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-hospital:client:use:bandage', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("health-pack", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-hospital:client:use:health-pack', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("painkillers", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-hospital:client:use:painkillers', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("joint", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:joint', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("superjoint", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:superjoint', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("coke-bag", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:coke', source)
        end
    end
end)

Framework.Functions.CreateUseableItem("lsd-strip", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent("pepe-items:client:use:lsd", source)
        end
    end
end)

Framework.Functions.CreateUseableItem("coin", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-items:client:coinflip', source)
    end
end)

Framework.Functions.CreateUseableItem("dice", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        local Player = Framework.Functions.GetPlayer(source)
        local DiceItems = Player.Functions.GetItemByName("dice")
        local Amount = 3
        local Sides = 6
        if DiceItems ~= nil then
            TriggerClientEvent('pepe-items:client:dobbel', source, Amount, Sides)
        else
            TriggerClientEvent('Framework:Notify', source, "Bạn không có súc xắc..", "error", 3500)
        end
    end
end)
-- Weed

Framework.Functions.CreateUseableItem("weed-nutrition", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-houseplants:client:feed:plants', source)
    end
end)

Framework.Functions.CreateUseableItem("white-widow-seed", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-houseplants:client:plant', source, 'White Widow', 'White-Widow', 'white-widow-seed')
    end
end)

Framework.Functions.CreateUseableItem("skunk-seed", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-houseplants:client:plant', source, 'Skunk', 'Skunk', 'skunk-seed')
    end
end)

Framework.Functions.CreateUseableItem("purple-haze-seed", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-houseplants:client:plant', source, 'Purple Haze', 'Purple-Haze', 'purple-haze-seed')
    end
end)

Framework.Functions.CreateUseableItem("og-kush-seed", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-houseplants:client:plant', source, 'Og Kush', 'Og-Kush', 'og-kush-seed')
    end
end)

Framework.Functions.CreateUseableItem("amnesia-seed", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-houseplants:client:plant', source, 'Amnesia', 'Amnesia', 'amnesia-seed')
    end
end)

Framework.Functions.CreateUseableItem("ak47-seed", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-houseplants:client:plant', source, 'AK47', 'AK47', 'ak47-seed')
    end
end)

-- // Coke \\ --

Framework.Functions.CreateUseableItem("packed-coke-brick", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-illegal:client:unpack:coke', source)
    end
end)

Framework.Functions.CreateUseableItem("burner-phone", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-illegal:client:start:burner-call', source)
    end
end)

-- // Sleutels \\ --

Framework.Functions.CreateUseableItem("key-a", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-illegal:client:use:key', source, 'key-a')
    end
end)

Framework.Functions.CreateUseableItem("key-b", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-illegal:client:use:key', source, 'key-b')
    end
end)

Framework.Functions.CreateUseableItem("key-c", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('pepe-illegal:client:use:key', source, 'key-c')
    end
end)

-- Framework.Commands.Add("dobbel", "Lekker dobbelen", {{name="aantal", help="Aantal dobbelsteentjes"}, {name="zijdes", help="Aantal zijdes van dobbelsteentje"}}, true, function(source, args)
--     local Player = Framework.Functions.GetPlayer(source)
--     local DiceItems = Player.Functions.GetItemByName("dice")
--     if args[1] ~= nil and args[2] ~= nil then 
--       local Amount = tonumber(args[1])
--       local Sides = tonumber(args[2])
--       if DiceItems ~= nil then
--          if (Sides > 0 and Sides <= 20) and (Amount > 0 and Amount <= 5) then 
--              TriggerClientEvent('pepe-items:client:dobbel', source, Amount, Sides)
--          else
--              TriggerClientEvent('Framework:Notify', source, "Teveel aantal kanten of 0 (max: 5) of teveel aantal dobbelstenen of 0 (max: 20)", "error", 3500)
--          end
--       else
--         TriggerClientEvent('Framework:Notify', source, "JE hebt geen eens dobbelstenen..", "error", 3500)
--       end
--   end
-- end)

Framework.Commands.Add("vestuit", "Doe je vest uit", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("pepe-items:client:reset:armor", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RegisterServerEvent('pepe-items:server:giveitem')
AddEventHandler('pepe-items:server:giveitem', function(ItemName, Amount)
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.AddItem(ItemName, Amount)
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items[ItemName], "add")
end)

Framework.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("pepe-items:client:UseParachute", source)
    end
end)

Framework.Commands.Add("coidu", "Lấy dù của bạn", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("pepe-items:client:ResetParachute", source)
end)

Framework.Functions.CreateUseableItem("jerrycan", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:jerrycan', source)
        end
    end
end)