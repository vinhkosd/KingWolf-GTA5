Config = Config or {}

Config.Locations = {
	['Stash'] = { ['x'] = -474.8923, ['y'] = -147.8666, ['z'] = 39.116859, ['h'] = 300.27212 },
    ['SellStash'] = { ['x'] = -484.7672, ['y'] = -164.3198, ['z'] = 38.151412, ['h'] = 307.33831 },
    -- ['Stalls'] = { ['x'] = 336.05429, ['y'] = -883.0854, ['z'] = 29.339908, ['h'] = 176.5977 },
    ['Craft'] = { ['x'] = -476.9965, ['y'] = -146.428, ['z'] = 39.116859, ['h'] = 38.197628 },
    ['Duty'] = { ['x'] = -480.211, ['y'] = -153.7064, ['z'] = 38.742321, ['h'] = 206.98826 },
    ['Quannuoc'] = { ['x'] = -468.5653, ['y'] = -177.4822, ['z'] = 37.781127, ['h'] = 29.861036 },
    ['Boss'] = { ['x'] = -478.1042, ['y'] = -154.685, ['z'] = 39.14812, ['h'] = 211.76536 },
    ['Table'] = {
        [1] = { ['x'] = -477.5318, ['y'] = -172.0179, ['z'] = 38.407863, ['h'] = 99.505874 },
        [2] = { ['x'] = -466.6035, ['y'] = -173.9864, ['z'] = 38.3483, ['h'] = 54.651687 },
        [3] = { ['x'] = -467.7893, ['y'] = -180.3057, ['z'] = 38.11906, ['h'] = 185.7498 },
        [4] = { ['x'] = -466.6773, ['y'] = -168.232, ['z'] = 38.348114, ['h'] = 66.674514 },
    },

    ['Water'] = {
      [1] = { ['x'] = -1503.42, ['y'] = 1549.8319, ['z'] = 106.9624, ['h'] = 98.931152 },
      [2] = { ['x'] = -1541.156, ['y'] = 1453.6793, ['z'] = 115.86617, ['h'] = 66.463233 },
    },
    
    ['Spawns'] = {
      [1] = { ['x'] = -487.6652, ['y'] = -137.7623, ['z'] = 38.894191, ['h'] = 37.094593 },
    },
    ['TakeVehicle'] = { ['x'] = -487.6652, ['y'] = -137.7623, ['z'] = 38.894191, ['h'] = 37.094593 },
    
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