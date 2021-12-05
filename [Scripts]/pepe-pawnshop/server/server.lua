local TotalGoldBars = 0

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local ServerPrice = {}

Citizen.CreateThread(function()
    while true do
		for k, v in pairs(Config.SellItems) do
            if k == "gold-bar" then
                local randomPriceChance = math.random(1, 100)
                if randomPriceChance <= 35 then--35% giá 1
                    ServerPrice[k] = v.PriceList[1]
                    print(k.." - "..ServerPrice[k])
                elseif randomPriceChance <= 63 then -- 28% giá 2
                    ServerPrice[k] = v.PriceList[2]
                    print(k.." - "..ServerPrice[k])
                elseif randomPriceChance <= 90 then -- 27% giá 3
                    ServerPrice[k] = v.PriceList[3]
                    print(k.." - "..ServerPrice[k])
                else -- 10% giá 4
                    ServerPrice[k] = v.PriceList[4]
                    print(k.." - "..ServerPrice[k])
                end
            else
                ServerPrice[k] = v.PriceList[math.random(1, #v.PriceList)]
                print(k.." - "..ServerPrice[k])
            end
        end
        Citizen.Wait(30 * 60 * 1000) -- 30 p doi gia 1 lan
		-- Citizen.Wait(35 * 1 * 1000) -- 30 p doi gia 1 lan
    end
end)
-- Code

Framework.Functions.CreateCallback('pepe-pawnshop:server:has:gold', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("gold-necklace") ~= nil or Player.Functions.GetItemByName("gold-rolex") or Player.Functions.GetItemByName("diamond-ring") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('pepe-pawnshop:server:sell:gold:items')
AddEventHandler('pepe-pawnshop:server:sell:gold:items', function()
  local Player = Framework.Functions.GetPlayer(source)
  local Price = 0
  if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
     for k, v in pairs(Player.PlayerData.items) do
         if ServerPrice[Player.PlayerData.items[k].name] ~= nil then
            Price = Price + (ServerPrice[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
            Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
         end
     end
     if Price > 0 then
       Player.Functions.AddMoney("cash", Price, "sold-pawn-items")
       TriggerClientEvent('Framework:Notify', source, "Bạn đã bán thành công")
     end
  end
end)

RegisterServerEvent('pepe-pawnshop:server:sell:gold:bars')
AddEventHandler('pepe-pawnshop:server:sell:gold:bars', function()
    local Player = Framework.Functions.GetPlayer(source)
    local GoldBarsPrice = ServerPrice["gold-bar"]
    if GoldBarsPrice ~= nil then
        local GoldItem = Player.Functions.GetItemByName("gold-bar")
        if Player.Functions.RemoveItem('gold-bar', GoldItem.amount) then
            TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['gold-bar'], "remove")
            Player.Functions.AddMoney("cash", GoldBarsPrice * GoldItem.amount, "sold-pawn-items")
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Không thể định giá vàng, lỗi hệ thống!")
    end
end)

RegisterServerEvent('pepe-pawnshop:server:smelt:gold')
AddEventHandler('pepe-pawnshop:server:smelt:gold', function()
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Config.SmeltItems[Player.PlayerData.items[k].name] ~= nil then
               local ItemAmount = (Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                if ItemAmount >= 1 then
                    ItemAmount = math.ceil(Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                    if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
                        TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items[Player.PlayerData.items[k].name], "remove")
                        TotalGoldBars = TotalGoldBars + ItemAmount
                        if TotalGoldBars > 0 then
                          TriggerClientEvent('pepe-pawnshop:client:start:process', -1)
                        end
                    end
                end
            end
        end
     end
end)

-- RegisterServerEvent('pepe-pawnshop:server:redeem:gold:bars')
-- AddEventHandler('pepe-pawnshop:server:redeem:gold:bars', function()
--     local Player = Framework.Functions.GetPlayer(source)
--     Player.Functions.AddItem("gold-bar", TotalGoldBars)
--     TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items["gold-bar"], "add")
--     TriggerClientEvent('pepe-pawnshop:server:reset:smelter', -1)
-- end)

RegisterServerEvent('pepe-pawnshop:server:redeem:gold:bars')
AddEventHandler('pepe-pawnshop:server:redeem:gold:bars', function()
    local Player = Framework.Functions.GetPlayer(source)
    if TotalGoldBars > 0 then
        if Player.Functions.AddItem("gold-bar", TotalGoldBars) then
            TotalGoldBars = 0
            TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items["gold-bar"], "add")
            TriggerClientEvent('pepe-pawnshop:server:reset:smelter', -1)
        end
    end
end)