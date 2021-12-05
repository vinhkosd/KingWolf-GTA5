Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Citizen.CreateThread(function()
    Config.TrapHouse['Coords']['Enter'] = {['X'] = -1533.35, ['Y'] = -275.44, ['Z'] = 49.73, ['H'] = 52.30}
    Config.TrapHouse['Coords']['Interact'] = {['X'] = -1532.42, ['Y'] = -269.79, ['Z'] = 16.88}
end)

Framework.Functions.CreateCallback("pepe-traphouse:server:get:config", function(source, cb)
    cb(Config)
end)

Framework.Functions.CreateCallback("pepe-traphouse:server:pin:code", function(source, cb)
    cb(Config.TrapHouse['Code'])
end)

Framework.Functions.CreateCallback("pepe-traphouse:server:is:current:owner", function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.PlayerData.citizenid == Config.TrapHouse['Owner'] then
            cb(true)
        else
            cb(false)
        end
    end
end)

Framework.Functions.CreateCallback("pepe-traphouse:server:has:sell:item", function(source, cb)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
     local BlueDiamondItem = Player.Functions.GetItemByName('diamond-blue')
     local RedDiamondItem = Player.Functions.GetItemByName('diamond-red')
     local BillsItem = Player.Functions.GetItemByName('markedbills')
     if BlueDiamondItem ~= nil or RedDiamondItem ~= nil or BillsItem ~= nil then
        cb(true)
     else
        cb(false)
     end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        Config.TrapHouse['Code'] = math.random(1111,9999)
        print('Traphouse Code Reset..', Config.TrapHouse['Code'])
        TriggerEvent("pepe-logs:server:SendLog", "default", "TrapHouse Code Reset", "red", "Đã đổi mật khẩu Traphouse **".. Config.TrapHouse['Code'] .. "**", true)

        Citizen.Wait((1000 * 60) * 60)
    end
end)

RegisterServerEvent('pepe-traphouse:server:sell:item')
AddEventHandler('pepe-traphouse:server:sell:item', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellItems) do
        local Item = Player.Functions.GetItemByName(k)
        if Item ~= nil then
          if Item.amount > 0 then
                for i = 1, Item.amount do
                    if Player.Functions.RemoveItem(Item.name, 1) then
                        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Item.name], "remove")
                        if v['Type'] == 'info' then
                            Player.Functions.AddMoney('cash', Item.info.worth, 'sold-traphouse')
                        else
                            Player.Functions.AddMoney('cash', v['Amount'], 'sold-traphouse')
                        end
                    end
                    Citizen.Wait(500)
                end
          end
        end
    end
end)

RegisterServerEvent('pepe-traphouse:server:set:selling:state')
AddEventHandler('pepe-traphouse:server:set:selling:state', function(bool)
    Config.IsSelling = bool
    TriggerClientEvent('pepe-traphouse:client:set:selling:state', -1, bool)
end)

RegisterServerEvent('pepe-traphouse:set:owner')
AddEventHandler('pepe-traphouse:set:owner', function()
    local Player = Framework.Functions.GetPlayer(source)
    Config.TrapHouse['Owner'] = Player.PlayerData.citizenid
end)

RegisterServerEvent('pepe-traphouse:server:rob:npc')
AddEventHandler('pepe-traphouse:server:rob:npc', function()
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 50)
    if RandomValue <= 5 then
        Player.Functions.AddItem("note", 1, false, {label = 'Traphouse code: '..tonumber(Config.TrapHouse['Code'])})
        TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items["note"], "add")
    end
end)