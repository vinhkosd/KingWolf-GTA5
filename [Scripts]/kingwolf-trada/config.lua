Config = Config or {}

Config.Locations = {
	['Stash'] = { ['x'] = -485.8309, ['y'] = -400.9107, ['z'] = 34.5466, ['h'] = 173.6475 },
    ['SellStash'] = { ['x'] = -477.932, ['y'] = -396.2772, ['z'] = 34.017715, ['h'] = 224.25219 },
    -- ['Stalls'] = { ['x'] = 336.05429, ['y'] = -883.0854, ['z'] = 29.339908, ['h'] = 176.5977 },
    ['Craft'] = { ['x'] = -478.699, ['y'] = -401.6635, ['z'] = 34.546638, ['h'] = 345.72085 },
    ['Duty'] = { ['x'] = -477.8077, ['y'] = -398.3818, ['z'] = 34.5466, ['h'] = 263.45867 },
    ['Boss'] = { ['x'] = -481.9307, ['y'] = -400.832, ['z'] = 34.546592, ['h'] = 351.03933 },
    ['Table'] = {
        [1] = { ['x'] = -479.8166, ['y'] = -394.3835, ['z'] = 34.570404, ['h'] = 317.69277 },
        [2] = { ['x'] = -481.4816, ['y'] = -390.802, ['z'] = 34.621822, ['h'] = 354.89401 },
        [3] = { ['x'] = -485.7417, ['y'] = -393.4344, ['z'] = 34.714248, ['h'] = 344.9107 },
        [4] = { ['x'] = -486.2486, ['y'] = -398.6085, ['z'] = 34.758228, ['h'] = 97.487548 },
    },

    ['Water'] = {
      [1] = { ['x'] = -1503.42, ['y'] = 1549.8319, ['z'] = 106.9624, ['h'] = 98.931152 },
      [2] = { ['x'] = -1541.156, ['y'] = 1453.6793, ['z'] = 115.86617, ['h'] = 66.463233 },
    },
    
    ['Spawns'] = {
      [1] = { ['x'] = -447.957, ['y'] = -413.1385, ['z'] = 32.844791, ['h'] = 262.41082 },
    },
    ['TakeVehicle'] = { ['x'] = -447.957, ['y'] = -413.1385, ['z'] = 32.844791, ['h'] = 262.41082 },
    
    ['Shop'] = { ['x'] = -477.6302, ['y'] = -396.2876, ['z'] = 34.016578, ['h'] = 236.74955 },
    ['ShopAuto'] = {
      vector3(-1226.47, -907.4805, 12.326354),
      vector3(-1486.458, -382.8505, 40.163391),
      vector3(381.82818, 325.3074, 103.56658),
      vector3(33.706295, -1346.296, 29.497028),
      vector3(-708.8721, -909.9694, 19.215593),
      vector3(-46.37863, -1753.591, 29.421003),
      vector3(1967.6021, 3745.4699, 32.343753),
      vector3(167.35202, 6635.375, 31.698947),
      vector3(-2970.311, 387.84674, 15.043313),
      vector3(1702.5615, 4923.0468, 42.063644),
      --vector3(-477.6302, -396.2876, 34.016578),
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

Config.CarModel = "sh350"

Config.Color1 = 112

Config.Color2 = 12

Config.CraftingItems = {
    [1] = {
        name = "orange-juice",--nước cam
        amount = 50,
        toamount = 5,
        tostash = true,
        info = {},
        costs = {
          ["orange"] = 5,
          ['ice-water'] = 1,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 0,
    },
    [2] = {
        name = "thuoc-lao",-- thuốc lào 1/2 stress
        amount = 50,
        toamount = 1,
        tostash = true,
        info = {},
        costs = {
          ["corn_silk"] = 3,
          ['rolling-paper'] = 1,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 0,
    },
    [3] = {
        name = "ice-water",--nước đá
        amount = 50,
        toamount = 5,
        tostash = false,
        info = {},
        costs = {
          ["water-bucket"] = 1,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 0,
    },
    [4] = {
        name = "bottle-water",--nước suối đóng chai
        amount = 50,
        toamount = 1,
        tostash = true,
        info = {},
        costs = {
          ["water-bucket"] = 1,
          ["cash"] = 25,
        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 0,
    },
    [5] = {
        name = "fruit-plate",--đĩa trái cây (1/2 nước)
        amount = 50,
        toamount = 2,
        tostash = true,
        info = {},
        costs = {
          ["ice-water"] = 1,
          ["orange"] = 5,
          ["grape"] = 5,
        },
        type = "item",
        slot = 5,
        threshold = 0,
        points = 0,
    },
    [6] = {
      name = "ice-scream",--kem (1/3 nước)
      amount = 50,
      toamount = 2,
      tostash = true,
      info = {},
      costs = {
        ["ice-water"] = 1,
        ["orange"] = 3,
        ["grape"] = 3,
      },
      type = "item",
      slot = 6,
      threshold = 0,
      points = 0,
    },
}

Config.Items = {
  label = "Shop trà đá tự động",
  slots = 5,
  items = {
    [1] = {
      name = "orange-juice",
      price = 200,
      amount = 0,
      info = {},
      type = "item",
      slot = 1,
    },
    [2] = {
      name = "bottle-water",
      price = 100,
      amount = 0,
      info = {},
      type = "item",
      slot = 2,
    },
    [3] = {
      name = "ice-scream",
      price = 200,
      amount = 0,
      info = {},
      type = "item",
      slot = 3,
    },
    [4] = {
      name = "thuoc-lao",
      price = 300,
      amount = 0,
      info = {},
      type = "item",
      slot = 4,
    },
    [5] = {
      name = "fruit-plate",
      price = 250,
      amount = 0,
      info = {},
      type = "item",
      slot = 5,
    },
  }
}