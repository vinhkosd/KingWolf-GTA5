Config = Config or {}

Config.Products = {
    ['Shops'] = {
      -- [1] = {
      --   name = "sandwich",
      --   price = 50,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 1,
      -- },
      -- [2] = {
      --   name = "chocolade",
      --   price = 50,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 2,
      -- },
      -- [3] = {
      --   name = "donut",
      --   price = 50,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 3,
      -- },
    },
    ['ShopsExtra'] = {
      -- [1] = {
      --   name = "sandwich",
      --   price = 50,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 1,
      -- },
      -- [2] = {
      --   name = "chocolade",
      --   price = 50,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 2,
      -- },
      -- [3] = {
      --   name = "donut",
      --   price = 50,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 3,
      -- },
    },
    ['Weed'] = {
      -- [1] = {
      --   name = "weed-nutrition",
      --   price = 150,
      --   amount = 500,
      --   info = {},
      --   type = "item",
      --   slot = 1,
      -- },
      [1] = {
        name = "white-widow-seed",
        price = 250,
        amount = 500,
        info = {},
        type = "item",
        slot = 1,
      },
      [2] = {
        name = "rolling-paper",
        price = 25,
        amount = 450,
        info = {},
        type = "item",
        slot = 2,
      },
    },
    ['Sea'] = {
      [1] = {
        name = "fishrod",
        price = 500,
        amount = 100,
        info = {},
        type = "item",
        slot = 1,
      },
    },
    ['Unicorn'] = {
      -- [1] = {
      --   name = "cocktail-1",
      --   price = 25,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 1,
      -- },
      -- [2] = {
      --   name = "cocktail-2",
      --   price = 25,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 2,
      -- },
      -- [3] = {
      --   name = "cocktail-3",
      --   price = 25,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 3,
      -- },
    },
    ['Vending'] = {
      -- [1] = {
      --   name = "donut",
      --   price = 4,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 1,
      -- },
      -- [2] = {
      --   name = "420-choco",
      --   price = 11,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 2,
      -- },
    },
    ['Coffee'] = {
      -- [1] = {
      --   name = "burger-coffee",
      --   price = 7,
      --   amount = 100,
      --   info = {},
      --   type = "item",
      --   slot = 1,
      -- },
    },
    ['Hardware'] = {
      [1] = {
        name = "lockpick",
        price = 450,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
      },
      [2] = {
        name = "toolkit",
        price = 2500,
        amount = 50,
        info = {},
        type = "item",
        slot = 2,
      },
    },
    ['Hardware-2'] = {
      [1] = {
        name = "radio",
        price = 500,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
      },
      [2] = {
        name = "phone",
        price = 850,
        amount = 50,
        info = {},
        type = "item",
        slot = 2,
      },
      [3] = {
        name = "dice",
        price = 500,
        amount = 50,
        info = {},
        type = "item",
        slot = 3,
      },
      [4] = {
        name = "mine-pickaxe",
        price = 500,
        amount = 100,
        info = {},
        type = "item",
        slot = 4,
      },
      [5] = {
        name = "wood-hachet",
        price = 500,
        amount = 100,
        info = {},
        type = "item",
        slot = 5,
      },
      [6] = {
        name = "scissor",
        price = 500,
        amount = 100,
        info = {},
        type = "item",
        slot = 6,
      },
      [7] = {
        name = "spray",
        price = 200,
        amount = 100,
        info = {},
        type = "item",
        slot = 7,
      },
      [8] = {
        name = "liemcatlua",
        price = 500,
        amount = 100,
        info = {},
        type = "item",
        slot = 8,
      },
    },
}

Config.Shops = {
  [1] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 25.92,
      ['Y'] = -1346.68,
      ['Z'] = 29.49,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [2] = {
    ['Name'] = 'LTD Gasoline',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -48.09,
      ['Y'] = -1757.16,
      ['Z'] = 29.42,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [3] = {
    ['Name'] = 'LTD Gasoline',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -707.78,
      ['Y'] = -913.96,
      ['Z'] = 19.21,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [4] = {
    ['Name'] = 'Rob\'s Liquor',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -1222.86,
      ['Y'] = -907.16,
      ['Z'] = 12.32,
    },
    ['Product'] = Config.Products["ShopsExtra"]
  },
  [5] = {
    ['Name'] = 'Rob\'s Liquor',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 1135.79,
      ['Y'] = -981.91,
      ['Z'] = 46.41,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [6] = {
    ['Name'] = 'Rob\'s Liquor',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -159.94,
      ['Y'] = 6322.61,
      ['Z'] = 31.58,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [7] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 162.10,
      ['Y'] = 6641.16,
      ['Z'] = 31.69,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [8] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 1729.43,
      ['Y'] = 6415.32,
      ['Z'] = 35.03,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [9] = {
    ['Name'] = 'LTD Gasoline',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 1698.82,
      ['Y'] = 4924.58,
      ['Z'] = 42.06,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [10] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 2678.00,
      ['Y'] = 3281.03,
      ['Z'] = 55.24,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [11] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 1961.00,
      ['Y'] = 3741.30,
      ['Z'] = 32.34,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [12] = {
    ['Name'] = 'Rob\'s Liquor',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 1166.12,
      ['Y'] = 2709.18,
      ['Z'] = 38.15,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [13] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 547.99,
      ['Y'] = 2670.43,
      ['Z'] = 42.15,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [14] = {
    ['Name'] = 'LTD Gasoline',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -1820.98,
      ['Y'] = 792.98,
      ['Z'] = 138.116,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [15] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -3243.04,
      ['Y'] = 1001.49,
      ['Z'] = 12.83,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [16] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -3040.01,
      ['Y'] = 585.66,
      ['Z'] = 7.9,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [17] = {
    ['Name'] = 'Rob\'s Liquor',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -2967.93,
      ['Y'] = 391.03,
      ['Z'] = 15.04,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [18] = {
    ['Name'] = 'Rob\'s Liquor',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -1487.37,
      ['Y'] = -379.13,
      ['Z'] = 40.16,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [19] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 374.08,
      ['Y'] = 326.64,
      ['Z'] = 103.56,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [20] = {
    ['Name'] = '24/7 Avond Winkel',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 2556.50,
      ['Y'] = 382.16,
      ['Z'] = 108.62,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [21] = {
    ['Name'] = 'LTD Gasoline',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 1163.50,
      ['Y'] = -323.27,
      ['Z'] = 69.20,
    },
    ['Product'] = Config.Products["Shops"]
  },
  [22] = {
    ['Name'] = 'Slotenmaker',
    ['Type'] = 'Hardware',
    ['Coords'] = {
      ['X'] = 170.14,
      ['Y'] = -1799.22,
      ['Z'] = 29.31,
    },
    ['Product'] = Config.Products["Hardware"]
  },
  [23] = {
    ['Name'] = 'Hardware Store',
    ['Type'] = 'Hardware',
    ['Coords'] = {
      ['X'] = 44.74,
      ['Y'] = -1748.21,
      ['Z'] = 29.52,
    },
    ['Product'] = Config.Products["Hardware-2"]
  },
  [24] = {
    ['Name'] = 'Hardware Store',
    ['Type'] = 'Hardware',
    ['Coords'] = {
      ['X'] = 2748.84,
      ['Y'] = 3472.50,
      ['Z'] = 55.67,
    },
    ['Product'] = Config.Products["Hardware-2"]
  },
  [25] = {
    ['Name'] = 'Weed Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -1171.89,
      ['Y'] = -1572.03,
      ['Z'] = 4.66,
    },
    ['Product'] = Config.Products["Weed"]
  },
  [26] = {
    ['Name'] = 'Sea Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -1686.52,
      ['Y'] = -1072.51,
      ['Z'] = 13.15,
    },
    ['Product'] = Config.Products["Sea"]
  },
}