Config = Config or {}

Config.CanFish = false

Config.BoatPrice = 150

Config.BoatReturnPrice = 0

Config.UsingRod = false

Config.Locations = {
    ['Sell'] = {['X'] = -1686.52, ['Y'] = -1072.51, ['Z'] = 13.15},
    ['Boat'] = {['X'] = 1551.37, ['Y'] = 3799.74, ['Z'] = 34.41},
    ['RBoat'] = {['X'] = 1517.0755, ['Y'] = 3822.0073, ['Z'] = 32.548604},
}

Config.FishLocations = {
    [1] = {
        ['Name'] = 'Fish1',
        ['Coords'] = {['X'] = 241.00, ['Y'] = 3993.00, ['Z'] = 30.40}
    },
    [2] = {
        ['Name'] = 'Fish2',
        ['Coords'] = {['X'] = 1252.38, ['Y'] = 3928.29, ['Z'] = 30.8}
    },
    [3] = {
        ['Name'] = 'Fish3',
        ['Coords'] = {['X'] = 2237.00, ['Y'] = 4046.41, ['Z'] = 31.6}
    },
    [4] = {
        ['Name'] = 'Fish4',
        ['Coords'] = {['X'] = 1255.98, ['Y'] = 3846.79, ['Z'] = 31.9}
    },
    [5] = {
        ['Name'] = 'Fish5',
        ['Coords'] = {['X'] = 1960.00, ['Y'] = 4255.00, ['Z'] = 30.55}
    },
    [6] = {
        ['Name'] = 'Fish6',
        ['Coords'] = {['X'] = 1011.30, ['Y'] = 3805.20, ['Z'] = 31.55}
    },
    [7] = {
        ['Name'] = 'Fish7',
        ['Coords'] = {['X'] = 598.80, ['Y'] = 3723.56, ['Z'] = 31.45}
    },
    [8] = {
        ['Name'] = 'Fish8',
        ['Coords'] = {['X'] = 636.74, ['Y'] = 4073.77, ['Z'] = 31.45}
    },
    [9] = {
        ['Name'] = 'Fish9',
        ['Coords'] = {['X'] = -55.77, ['Y'] = 4056.46, ['Z'] = 31.2}
    },
    [10] = {
        ['Name'] = 'Fish10',
        ['Coords'] = {['X'] = 1612.92, ['Y'] = 4066.92, ['Z'] = 31.8}
    },
    [11] = {
        ['Name'] = 'Fish11',
        ['Coords'] = {['X'] = -63.36, ['Y'] = 4180.44, ['Z'] = 31.8}
    },
}

Config.SellItems = {
 ['fish-1'] = {
   ['Type'] = 'money',
   ['Amount'] = 50,
 },
 ['fish-2'] = {
   ['Type'] = 'money',
   ['Amount'] = 65,
 },
 ['fish-3'] = {
   ['Type'] = 'money',
   ['Amount'] = 120,
 },
 ['plasticbag'] = {
   ['Type'] = 'item',
   ['Item'] = 'plastic',
   ['Amount'] = 1,
   ['FromAmount'] = 2,
 },
 ['shoe'] = {
   ['Type'] = 'item',
   ['Item'] = 'rubber',
   ['Amount'] = 1,
   ['FromAmount'] = 2,
 },
 ['fish-shark'] = {
    ['Type'] = 'money',
    ['Amount'] = 500,
  },
}

Config.SellPrices = {
	['fish-1'] = {
		PriceList = {
			[1] = 39,
			[2] = 44,
			[3] = 54,
		},
    },
	['fish-2'] = {
		PriceList = {
			[1] = 49,
			[2] = 56,
			[3] = 64,
		},
    },
	['fish-3'] = {
		PriceList = {
			[1] = 94,
			[2] = 108,
			[3] = 116,
		},
    },
    ['fish-shark'] = {
		PriceList = {
			[1] = 344,
			[2] = 390,
			[3] = 450,
		},
    },
}