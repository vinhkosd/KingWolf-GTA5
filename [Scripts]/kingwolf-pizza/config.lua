Config = Config or {}

Config.Locations = {
	['Stash'] = { ['x'] = -571.4837, ['y'] = -413.6253, ['z'] = 34.917022, ['h'] = 173.6475 },
    ['SellStash'] = { ['x'] = -567.3016, ['y'] = -409.8931, ['z'] = 34.91703, ['h'] = 164.6735 },
    -- ['Stalls'] = { ['x'] = 336.05429, ['y'] = -883.0854, ['z'] = 29.339908, ['h'] = 176.5977 },
    ['Craft'] = { ['x'] = -566.0625, ['y'] = -413.5116, ['z'] = 34.91703, ['h'] = 345.72085 },
    ['Duty'] = { ['x'] = -571.1494, ['y'] = -409.7015, ['z'] = 34.91703, ['h'] = 263.45867 },
    ['Boss'] = { ['x'] = -579.5701, ['y'] = -408.6983, ['z'] = 37.893154, ['h'] = 351.03933 },
    ['Table'] = {
        [1] = { ['x'] = -479.8166, ['y'] = -394.3835, ['z'] = 34.570404, ['h'] = 317.69277 },
        [2] = { ['x'] = -481.4816, ['y'] = -390.802, ['z'] = 34.621822, ['h'] = 354.89401 },
        [3] = { ['x'] = -485.7417, ['y'] = -393.4344, ['z'] = 34.714248, ['h'] = 344.9107 },
        [4] = { ['x'] = -486.2486, ['y'] = -398.6085, ['z'] = 34.758228, ['h'] = 97.487548 },
    },

    ['Shop'] = { ['x'] = -563.3693, ['y'] = -385.9087, ['z'] = 35.067878, ['h'] = 236.74955 },
    ['Spawns'] = {
      [1] = { ['x'] = -477.9977, ['y'] = -452.0055, ['z'] = 34.199443, ['h'] = 170.50019 },
    },
    ['TakeVehicle'] = { ['x'] = -477.9977, ['y'] = -452.0055, ['z'] = 34.199443, ['h'] = 170.50019 },
    ['ShopAuto'] = {
      vector3(-1221.457, -906.2603, 12.326354),
      vector3(-1487.878, -378.4274, 40.163391),
      vector3(381.2702, 328.6394, 103.56643),
      vector3(32.239936, -1343.033, 29.497028),
      vector3(-714.4494, -909.1818, 19.215593),
      vector3(-50.93773, -1748.641, 29.421003),
      vector3(1964.8734, 3747.7238, 32.343753),
      vector3(169.1499, 6639.0341, 31.698947),
      vector3(-2967.752, 392.27902, 15.043313),
      vector3(1707.324, 4928.3901, 42.063644),
    },
}
-- 5 QUẢ CAM + 1 NƯỚC ĐÁ -> RA 1 NƯỚC CAM (nước lên 1/3)
-- 3 Râu ngô + 1 giấy cuốn -> 1 THUOC LAO (giảm stress 1/2)
-- 1 NƯỚC SUỐI -> 5 Nước đá
-- 1 NƯỚC SUỐI + 25$ -> 1 NƯỚC SUỐI đóng chai (nước lên 1/5)
-- 1 NƯỚC ĐÁ + 5 cam + 5 nho -> 2 ĐĨA TRÁI CÂY (nước thêm 1/2)
-- 3 cam + 3 nho + 1 nước đá -> 1 kem(hồi 1/3 nước)
Config.UseItemsConfig = {
  ["orange-juice"] = 33,
  ["thuoc-lao"] = 50,
  ["bottle-water"] = 20,
  ["fruit-plate"] = 50,
  ["ice-scream"] = 33,
}

Config.CarModel = "foodbike"

Config.CraftingItems = {
    [1] = {
        name = "pizzaga",--pizza gà
        amount = 50,
        toamount = 1,
        tostash = true,
        info = {},
        costs = {
          ["botmi"] = 5,
          ['slaughteredchicken'] = 2,
          ['cachua'] = 3,
          ['bingo'] = 1,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 0,
    },
    [2] = {
        name = "pizzasalad",-- pizza salad
        amount = 50,
        toamount = 1,
        tostash = true,
        info = {},
        costs = {
          ["botmi"] = 5,
          ['bingo'] = 2,
          ['cachua'] = 3,
          ['bapcai'] = 2,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 0,
    },
    [3] = {
        name = "pizzachay",--pizza chay
        amount = 50,
        toamount = 1,
        tostash = false,
        info = {},
        costs = {
          ["botmi"] = 10,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 0,
    },
    [4] = {
        name = "pizzahaisan",--pizza hải sản
        amount = 50,
        toamount = 1,
        tostash = true,
        info = {},
        costs = {
          ["botmi"] = 5,
          ['fish-1'] = 2,
          ['bingo'] = 2,
        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 0,
    },
    [5] = {
        name = "pizzathapcam",--pizza thập cẩm
        amount = 50,
        toamount = 1,
        tostash = true,
        info = {},
        costs = {
          ["botmi"] = 5,
          ['fish-1'] = 1,
          ['slaughteredchicken'] = 1,
          ['cachua'] = 1,
          ['bapcai'] = 1,
          ['bingo'] = 1,
        },
        type = "item",
        slot = 5,
        threshold = 0,
        points = 0,
    },
    [6] = {
      name = "botmi",--1 bao gạo = 20 bột mì
      amount = 50,
      toamount = 20,
      tostash = false,
      info = {},
      costs = {
        ['baoluami'] = 1,
      },
      type = "item",
      slot = 6,
      threshold = 0,
      points = 0,
  },
}

Config.Items = {
  label = "Cửa hàng pizza tự động",
  slots = 5,
  items = {
    [1] = {
      name = "pizzaga",
      price = 200,
      amount = 0,
      info = {},
      type = "item",
      slot = 1,
    },
    [2] = {
      name = "pizzasalad",
      price = 100,
      amount = 0,
      info = {},
      type = "item",
      slot = 2,
    },
    [3] = {
      name = "pizzathapcam",
      price = 200,
      amount = 0,
      info = {},
      type = "item",
      slot = 3,
    },
    [4] = {
      name = "pizzachay",
      price = 300,
      amount = 0,
      info = {},
      type = "item",
      slot = 4,
    },
    [5] = {
      name = "pizzathapcam",
      price = 250,
      amount = 0,
      info = {},
      type = "item",
      slot = 5,
    },
  }
}