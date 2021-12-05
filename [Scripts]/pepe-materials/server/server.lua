Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('pepe-materials:server:is:vehicle:owned', function(source, cb, plate)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('pepe-materials:server:get:reward')
AddEventHandler('pepe-materials:server:get:reward', function()
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 20)
     local RandomItems = Config.BinItems[math.random(#Config.BinItems)]
    if RandomValue <= 20 then
        local info = {}
        info.quality = 100.0
        info.serie = tostring(Framework.Shared.RandomInt(2) .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(1) .. Framework.Shared.RandomStr(2) .. Framework.Shared.RandomInt(3) .. Framework.Shared.RandomStr(4))
   
        Player.Functions.AddItem(RandomItems, 1, false, info)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[RandomItems], 'add')
    else
        TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Không tìm thấy gì cả..', 'error')
    end
end)

RegisterServerEvent('pepe-materials:server:recycle:reward')
AddEventHandler('pepe-materials:server:recycle:reward', function()
  local Player = Framework.Functions.GetPlayer(source)
  for i = 1, 2, 1 do
      local Items = Config.RecycleItems[math.random(1, #Config.RecycleItems)]
      local RandomNum = math.random(1, 3)
      Player.Functions.AddItem(Items, RandomNum)
      TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[Items], 'add')
      Citizen.Wait(500)
  end
--   if math.random(1, 100) <= 20 then
--     Player.Functions.AddItem('rubber', math.random(20, 30))
--     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rubber'], 'add')
--   end
end)

RegisterServerEvent('pepe-materials:server:scrap:reward')
AddEventHandler('pepe-materials:server:scrap:reward', function()
  local Player = Framework.Functions.GetPlayer(source)
  for i = 1, 2, 1 do
      local Items = Config.CarItems[math.random(1, #Config.CarItems)]
      local RandomNum = math.random(1, 4)
      Player.Functions.AddItem(Items, RandomNum)
      TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[Items], 'add')
      Citizen.Wait(500)
  end
--   if math.random(1, 100) <= 35 then
--     Player.Functions.AddItem('rubber', math.random(25, 55))
--     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rubber'], 'add')
--   end
end)