Config = {}

Config.Locale = 'en'

Config.Delays = {
	CornProcessing = 1000 * 3
}

Config.CornPlant = 'prop_plant_01a'
Config.CornOutput = math.random(2,4)

Config.MowProp = 'prop_air_lights_02b'
-- Config.SellLocation =  { x = -45.67506, y = 1917.9635, z = 195.70533, h = 20.24583 } -- old location
-- Config.SellLocation =  { x = 1522.7043, y = 6329.5429, z = 24.606918, h = 157.66816 }
Config.SellLocation = { x = -50.23492, y = 1911.1407, z = 195.70539, h = 275.81692 }

Config.Tractor = 'tractor3'
Config.TractorCoords = vector3(2141.6279, 4788.9125, 40.970333)
Config.TractorSpawn = { x = 2134.132, y = 4780.5307, z = 40.970325, h = 18.008131 }
Config.TractorSpawnHeading = 349
Config.TractorRent = 1000

Config.CowProp = 'a_c_cow'
Config.MilkOutput = math.random(1,2)

Config.PrimaryColor = {r = 51, g = 136, b = 255, a = 255} -- Use RGB color picker
Config.SecondaryColor = {r = 33, g = 244, b = 218, a = 255} -- Use RGB color picker

Config.CircleZones = {
	FarmCoords = {coords = vector3(2030.7340087891, 4901.2221679688, 42.721950531006), name = 'blip_weedfield', color = 25, sprite = 496, radius = 100.0},
	Water = {coords = vector3(2041.5297851562, 4854.5625, 43.097927093506), name = 'blip_weedfield', color = 25, sprite = 496, radius = 100.0},
	CowFarm = {coords = vector3(2478.392578125,4728.8315429688,34.303840637207), name = 'blip_weedprocessing', color = 0, sprite = 6, radius = 10.0},
	OrangePack = {coords = vector3(2197.1828613281,5603.3310546875,53.513450622559), name = 'blip_weedprocessing', color = 0, sprite = 6, radius = 10.0},
	MilkPack = {coords = vector3(2198.8520507812,5609.2216796875,53.442737579346), name = 'blip_weedprocessing', color = 0, sprite = 6, radius = 10.0},
	Boxes = {coords = vector3(2192.2998046875,5594.560546875,53.768180847168), name = 'blip_weedprocessing', color = 0, sprite = 6, radius = 10.0},
	CornProcessing = {coords = vector3(2196.0209960938, 5594.4755859375, 53.773300170898), name = 'blip_weedprocessing', color = 0, sprite = 6, radius = 10.0},
	RiceProcessing = {coords = vector3(2604.1708, 4841.2392, 34.858806), name = 'blip_weedprocessing', color = 0, sprite = 6, radius = 10.0},
	RicePack = {coords = vector3(2196.4138, 5596.5664, 53.782985), name = 'blip_weedprocessing', color = 0, sprite = 6, radius = 10.0},
}

Config.OrangeFarm = {
	vector3(354.25085449219,6530.5913085938,28.372783660889),
	vector3(338.96520996094,6530.5283203125,28.569303512573),
	vector3(330.09320068359,6531.0278320312,28.569814682007),
	vector3(321.65646362305,6530.7075195312,29.177768707275),
	vector3(329.9287109375,6518.2021484375,28.958410263062),
	vector3(347.37521362305,6518.1303710938,28.804786682129),
	vector3(347.4914855957,6504.6416015625,28.815761566162)
}

Config.RiceFarm = {
	vector3(2599.8132, 4839.082,34.9463),
	vector3(2596.499, 4845.0395, 35.020805),
	vector3(2606.0683, 4847.1166, 34.849113),
}
-- Config.PipeRepairs = vector3(2293.6293945312,4819.9716796875,53.09984588623)
-- Config.GasSupply = vector3(2304.0451660156,4830.3271484375,50.071781158447)

Config.ItemList = {
    ["orange"] = math.random(10, 15),
    ["milk"] = math.random(20, 30),--
	["corn_kernel"] = math.random(20, 30),
    ["corn_pack"] = math.random(150, 200),
    ["milk_pack"] = math.random(250, 300),--60p duoc 8k
	["fruit_pack"] = math.random(220, 330),
	["packedchicken"] = math.random(10, 11),
}

Config.SellItems = {
	['orange'] = {
		PriceList = {
			[1] = 27
		},
    },
	['grape'] = {
		PriceList = {
			[1] = 27
		},
    },
	['milk'] = {
		PriceList = {
			[1] = 20
		},
    },
	['corn_kernel'] = {
		PriceList = {
			[1] = 27
		},
    },
    ['fruit_pack'] = {
		PriceList = {
			[1] = 296,
			[2] = 288,
			[3] = 280,
		},
    },
	['milk_pack'] = {
		PriceList = {
			[1] = 307,
			[2] = 300,
			[3] = 293,
		},
    },
	['corn_pack'] = {
		PriceList = {
			[1] = 170,
			[2] = 168,
			[3] = 164,
		},
    },
	['packedchicken'] = {
		PriceList = {
			[1] = 11,
			[2] = 12.5,
			[3] = 13.5,
		},
    },
	['grape_box'] = {
		PriceList = {
			[1] = 301,
			[2] = 293,
			[3] = 285,
		},
    },
	['bingo'] = {
		PriceList = {
			[1] = 27
		},
    },
	['cachua'] = {
		PriceList = {
			[1] = 27
		},
    },
	['bapcai'] = {
		PriceList = {
			[1] = 27
		},
    },
}

Config.Blips = {
   	{title="Vắt sữa bò",scale=0.8, colour=16, id=89, x = 2478.392578125, y = 4728.8315429688, z = 34.303840637207},
	{title="Trang trại bắp ngô",scale=0.8, colour=16, id=140, x = 2041.5297851562, y = 4854.5625, z= 43.097927093506},
	{title="Chế biến nông sản",scale=0.8, colour=16, id=478, x = 2195.4331054688, y = 5602.6352539062, z = 53.584144592285},
	{title="Hái cam",scale=0.8, colour=17, id=130, x = 346.62341308594, y = 6522.9448242188, z = 28.830759048462},
	{title="Bán nông sản",scale=1.2, colour=17, id=278, x = -50.23492, y = 1911.1407, z = 195.70539 },
	{title="Thuê xe máy cày",scale=0.8, colour=17, id=479, x = 2141.7529, y = 4788.9941, z = 40.970272, h = 302.4104 },
}

