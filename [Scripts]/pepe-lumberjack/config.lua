Config = {}

Config = {
    -- Lumberjack Job
    Prices = {
        ['wood_proc'] = {30, 50}
    },
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'wood_cut','wood_cut','wood_cut','wood_cut','wood_cut'},
    Sell = vector3(1210.0, -1318.51, 35.23),
    Process = vector3(-584.66, 5285.63, 70.26),
    -- Cars = vector3(1204.48, -1265.63, 35.23),
    -- delVeh = vector3(1187.84, -1286.76, 34.95),
    Objects = {
        ['pickaxe'] = 'w_me_hatchet',
    },
    WoodPosition = {
        {coords = vector3(-493.0, 5395.37, 77.18-0.97), heading = 282.49},
        {coords = vector3(-503.69, 5392.12, 75.98-0.97), heading = 113.62},
        {coords = vector3(-456.85, 5397.37, 79.49-0.97), heading = 29.92},
        {coords = vector3(-457.42, 5409.05, 78.78-0.97), heading = 209.65},
        {coords = vector3(-501.2, 5402.29, 74.2-0.97), heading = 179.62},
        {coords = vector3(-446.29, 5395.68, 7987-0.97), heading = 359.56}
    },
   
}

Config.textDel = 'Nhấn ~g~[E]~w~ Để chặt gỗ'
Config.canve = '~g~[E]~w~ Đỗ xe tại chỗ'
-- Config.textgar = '~g~[E]~w~ Phương tiện giao thông '
Config.ModelCar = 'rumpo'

-- Config.WoodMaxSell = 60

overpoweredvehicle = {}
overpoweredvehicle.SpawnVehicle = {
    x = 1205.31, 
    y = -1288.06, 
    z = 35.23, 
    h = 250.0,
}

Config.ProcessItems = {
    ['wood_cut'] = {--Gỗ chưa xử lý
      ['Type'] = 'item',
      ['Amount'] = math.random(15, 15),
    },
    
}
Strings = {
    ['wood_info'] = 'nhấn ~INPUT_ATTACK~ chặt, ~INPUT_FRONTEND_RIGHT~ dừng lại.',
    ['you_sold'] = 'Bạn có %sx %s Bán cho $%s',
    ['e_sell'] = 'nhấn ~g~[E]~w~ để bán',
    ['someone_close'] = 'Vẫn còn một công dân gần đó!',
    ['wood'] = 'Vị trí Woodhop',
    ['process'] = 'Chế biến gỗ',
    ['autotru'] = 'Xe chở gỗ',
    ['sell_wood'] = 'Bán gỗ',
    ['hevpark'] = 'Bãi đậu xe',
}