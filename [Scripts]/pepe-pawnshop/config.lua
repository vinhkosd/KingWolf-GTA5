Config = Config or {}

Config.CurrentItems = {}

Config.SmeltTime = 300

Config.CanTake = false

Config.Smelting = false

Config.Locations = {
    ['PawnShops'] = {
        [1] = {['X'] = 182.26, ['Y'] = -1319.10, ['Z'] = 29.31, ['Open-Time'] = 6, ['Close-Time'] = 12, ['Sell-Value'] = 1.0, ['Type'] = 'Gold'},
        [2] = {['X'] = -1468.99, ['Y'] = -406.36, ['Z'] = 36.81, ['Open-Time'] = 12, ['Close-Time'] = 16, ['Sell-Value'] = 1.0, ['Type'] = 'Bars'},
    },
    ['Smeltery'] = {
        [1] = {['X'] = 1109.91, ['Y'] = -2008.23, ['Z'] = 31.08},
    },
    ['Gold-Sell'] = {
      [1] = {['X'] = -1468.99, ['Y'] = -406.36, ['Z'] = 36.81},
  },
}

Config.ItemPrices = {
  ['gold-rolex'] = math.random(350, 450),
  ['gold-necklace'] = math.random(400, 500),
  ['diamond-ring'] = math.random(600, 700),
}

Config.SellItems = {
	['diamond-ring'] = {--Nhấn KC : 790$ - 826$ - 864$
		PriceList = {
			[1] = 790,
			[2] = 826,
			[3] = 864,
		},
  },
	['gold-rolex'] = {--Đồng Hồ : 410$ - 468$ - 500$
		PriceList = {
			[1] = 410,
			[2] = 468,
			[3] = 500,
		},
  },
	['gold-necklace'] = {--Dây Chuyền : 657$ - 726$ - 786$
		PriceList = {
			[1] = 657,
			[2] = 726,
			[3] = 786,
		},
  },
  ['gold-bar'] = {--Dây Chuyền : giá vàng thỏi : 2510$ (35%) -  5960$ (28%) - 6472$ (27%) - 7011$ (10%) % đó là tỉ lệ bán đó =)) cứ 30p đổi giá 1 lần + % ra cái số tiền đó ! xD 
		PriceList = {
			[1] = 2510,
			[2] = 5960,
			[3] = 6472,
      [4] = 7011,
		},
  },
}

Config.SmeltItems = {
  ['gold-rolex'] = 16,
  ['gold-necklace'] = 26,
}