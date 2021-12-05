Config = {
    pricexd = {
        -- ['item'] = {min, max} --
        steel = math.random(20, 20),
        iron = math.random(15, 15),
        copper = math.random(25, 25),
        diamond = math.random(50, 60),
        emerald = math.random(60, 70)
    },
    ChanceToGetItem = 10,
    ChanceToGetItem2 = 30, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'steel','steel','steel','steel','iron', 'iron', 'iron', 'copper', 'copper'},
    ItemsNew = {'diamond', 'emerald'},
    Sell = vector3(-97.12, -1013.8, 26.3),
    Objects = {
        ['pickaxe'] = 'prop_tool_pickaxe',
    },
    MiningPositions = {
        {coords = vector3(2992.77, 2750.64, 42.78), heading = 209.29},
        {coords = vector3(2983.03, 2750.9, 42.02), heading = 214.08},
        {coords = vector3(2976.74, 2740.94, 43.63), heading = 246.21},
        {coords = vector3(2934.265, 2742.695, 43.1), heading = 96.1},
        {coords = vector3(2907.25, 2788.27, 45.4), heading = 109.39},
        -- {coords = vector3(3004.96, 2782.89, 44.6), heading = 286.01},
        -- {coords = vector3(2986.64, 2815.98, 45.74), heading = 311.42}
    },
}

Config.SellItems = {
    ['steel'] = {--thép
      ['Type'] = 'money',
      ['Money'] = 24,
    },
    ['iron'] = {--sắt
      ['Type'] = 'money',
      ['Money'] = 29,
    },
    ['copper'] = {--đồng
      ['Type'] = 'money',
      ['Money'] = 34,
    },
    ['diamond'] = {--kim cương
      ['Type'] = 'money',
      ['Money'] = 82,-- *1.5 so voi gia ban dau
    },
    ['emerald'] = {--lục bảo
      ['Type'] = 'money',
      ['Money'] = 62,-- *1.5 so voi gia ban dau
    },
}

Strings = {
    ['press_mine'] = '~g~E~s~ - Đào đá',
    ['mining_info'] = 'Nhấn ~INPUT_ATTACK~ chặt, ~INPUT_FRONTEND_RRIGHT~ dừng lại.',
    ['you_sold'] = 'Bạn có %sx %s voor $%s đã bán',
    ['e_sell'] = '~g~E~s~ - Bán đá',
    ['someone_close'] = 'Công dân quá gần!',
    ['mining'] = 'Khu đào đá',
    ['sell_mine'] = 'Bán đá'
}