Config = Config or {}

Config.Locations = {
	['Stash'] = { ['x'] = -571.4837, ['y'] = -413.6253, ['z'] = 34.917022, ['h'] = 173.6475 },
    ['SellStash'] = { ['x'] = -567.3016, ['y'] = -409.8931, ['z'] = 34.91703, ['h'] = 164.6735 },
    -- ['Stalls'] = { ['x'] = 336.05429, ['y'] = -883.0854, ['z'] = 29.339908, ['h'] = 176.5977 },
    ['Craft'] = { ['x'] = -566.0625, ['y'] = -413.5116, ['z'] = 34.91703, ['h'] = 345.72085 },
    ['Duty'] = { ['x'] = -571.1494, ['y'] = -409.7015, ['z'] = 34.91703, ['h'] = 263.45867 },
    ['Boss'] = { ['x'] = -579.5701, ['y'] = -408.6983, ['z'] = 37.893154, ['h'] = 351.03933 },
    ['Table'] = {
        [1] = { ['x'] = -563.6885, ['y'] = -397.4381, ['z'] = 35.928726, ['h'] = 183.51019 },
        [2] = { ['x'] = -566.3422, ['y'] = -400.3947, ['z'] = 35.801147, ['h'] = 359.01577 },
        [3] = { ['x'] = -563.5344, ['y'] = -403.7551, ['z'] = 35.928371, ['h'] = 175.64173 },
        [4] = { ['x'] = -574.2904, ['y'] = -402.4182, ['z'] = 35.801658, ['h'] = 339.74304 },
    },

    ['Shop'] = { ['x'] = -563.3693, ['y'] = -385.9087, ['z'] = 35.067878, ['h'] = 236.74955 },
    ['Spawns'] = {
      [1] = { ['x'] = -576.3643, ['y'] = -389.1362, ['z'] = 34.354251, ['h'] = 7.0080332 },
    },
    ['TakeVehicle'] = { ['x'] = -576.3643, ['y'] = -389.1362, ['z'] = 34.354251, ['h'] = 7.0080332 },
    -- table = { ['x'] = -576.3643, ['y'] = -389.1362, ['z'] = 34.354251, ['h'] = 7.0080332 },
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
      --vector3(-563.3693, -385.9087, 35.067878),
    },
}
--pizza chay 1/5
--pizza ga 1/3
--pizza hai san 1/3
--pizza thap cam 1/2
--pizza salad 1/3 + 1/6 drink
Config.HungerGainItems = {
  ["pizzachay"] = 20,
  ["pizzaga"] = 33,
  ["pizzahaisan"] = 33,
  ["pizzathapcam"] = 50,
  ["pizzasalad"] = 33,
}

Config.ThirstGainItems = {
  ["pizzachay"] = 0,
  ["pizzaga"] = 0,
  ["pizzahaisan"] = 0,
  ["pizzathapcam"] = 0,
  ["pizzasalad"] = 16,
}

Config.CarModel = "sh350"

Config.Color1 = 40

Config.Color2 = 12

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
          ['cachua'] = 1,
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
          ['cachua'] = 2,
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
        tostash = true,
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
      price = 250,
      amount = 0,
      info = {},
      type = "item",
      slot = 2,
    },
    [3] = {
      name = "pizzahaisan",
      price = 200,
      amount = 0,
      info = {},
      type = "item",
      slot = 3,
    },
    [4] = {
      name = "pizzachay",
      price = 100,
      amount = 0,
      info = {},
      type = "item",
      slot = 4,
    },
    [5] = {
      name = "pizzathapcam",
      price = 350,
      amount = 0,
      info = {},
      type = "item",
      slot = 5,
    },
  }
}