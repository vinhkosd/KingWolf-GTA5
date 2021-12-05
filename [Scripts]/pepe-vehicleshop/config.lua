Pepe = {}

PepeCustoms = {}

Config = {}

Config.Job = 'cardealer'

Config = {
    Startpoint = {x = -27.65, y = -1104.08, z = 26.42, h = 250.25, d = 0.8},  
	spawnveh = {x = -50.01, y = -1110.38, z = 26.44, h = 71.81, d = 0.8},  
	Holdup = 30 --- in minute cooldown
}

Config.Locations = {
    ['Stash'] = { ['x'] = -779.7492, ['y'] = -233.6356, ['z'] = 37.07958, ['h'] = 176 },
    ['Boss'] = { ['x'] = -809.4218, ['y'] = -207.7646, ['z'] = 37.07958, ['h'] = 32 },
    ['Duty'] = { ['x'] = -781.5814, ['y'] = -211.6974, ['z'] = 37.152732, ['h'] = 95.220619 }
    -- -781.5814, -211.6974, 37.152732, 95.220619
}


Config.cars = {  ---------------- Which car do they need to sell?
  "taxi",
  "sentinel3",
}

Config.sellveh = {
	[1] = {x = 1710.35, y = 3704.05, z = 34.37, h = 252.47, d = 1.8}, 
	[2] = {x = 2008.6, y = 4986.35, z = 41.32, h = 41.32, d = 1.8}, 
}

Pepe.VehicleShops = {
    {x = -56.71, y = -1096.65, z = 25.44}
}

Pepe.GarageLabel = {
    ["motelgarage"] = "Motel Garage",
    ["sapcounsel"]  = "San Andreas Parking Counsel",
}

Pepe.SpawnPoint = {x = -744.424, y = -233.0766, z = 36.35, h = 208.749}
Pepe.DefaultGarage = "centralgarage"

Pepe.QuickSell = {x = -760.0483, y = -232.6357, z = 36.05, h = 208.88, r = 1.0}

Pepe.ShowroomVehicles = {
    -- [1] = {
    --     coords = {x = -778.8745, y = -219.6282, z = 36.05, h = 27.54},
    --     defaultVehicle = "adder",
    --     chosenVehicle = "adder",
    --     inUse = false,
   
    -- },
    -- [2] = {
    --     coords = {x = -787.191, y = -206.7663, z = 36.05, h = 294.5},
    --     defaultVehicle = "schafter2",
    --     chosenVehicle = "schafter2",
    --     inUse = false,
    --  }
    -- [3] = {
    --     coords = {x = -39.6, y = -1096.01, z = 25.44, h = 66.5},
    --     defaultVehicle = "comet2",
    --     chosenVehicle = "comet2",
    --     inUse = false,
    -- },
    -- [4] = {
    --     coords = {x = -51.21, y = -1096.77, z = 25.44, h = 254.5},
    --     defaultVehicle = "vigero",
    --     chosenVehicle = "vigero",
    --     inUse = false,
    -- }
    -- [5] = {
    --     coords = {x = -40.18, y = -1104.13, z = 25.44, h = 338.5},
    --     defaultVehicle = "t20",
    --     chosenVehicle = "t20",
    --     inUse = false,
    -- },
    -- [6] = {
    --     coords = {x = -43.31, y = -1099.02, z = 25.44, h = 52.5},
    --     defaultVehicle = "bati",
    --     chosenVehicle = "bati",
    --     inUse = false,
    -- },
    -- [7] = {
    --     coords = {x = -50.66, y = -1093.05, z = 25.44, h = 222.5},
    --     defaultVehicle = "bati",
    --     chosenVehicle = "bati",
    --     inUse = false,
    -- },
    -- [8] = {
    --     coords = {x = -44.28, y = -1102.47, z = 25.44, h = 298.5},
    --     defaultVehicle = "bati",
    --     chosenVehicle = "bati",
    --     inUse = false,
    -- }
}

Pepe.VehicleMenuCategories = {
    ["sports"]  = {label = "Sports"},
    ["super"]   = {label = "Super"},
    ["sedans"]  = {label = "Sedans"},
    ["coupes"]  = {label = "Coupes"},
    ["suvs"]    = {label = "SUV's"},
    ["offroad"] = {label = "Offroad"},
}

Pepe.Classes = {
    -- [0] = "compacts",  
    -- [1] = "sedans",  
    -- [2] = "suvs",  
    -- [3] = "coupes",  
    -- [4] = "muscle",  
    -- [5] = "sportsclassics ", 
    -- [6] = "sports",  
    -- [7] = "super",  
    -- [8] = "motorcycles",  
    -- [9] = "offroad", 
    -- [10] = "industrial",  
    -- [11] = "utility",  
    -- [12] = "vans",  
    -- [13] = "cycles",  
    -- [14] = "boats",  
    -- [15] = "helicopters",  
    -- [16] = "planes",  
    -- [17] = "service",  
    -- [18] = "emergency",  
    -- [19] = "military",  
    -- [20] = "commercial",  
    -- [21] = "trains",  
}

Pepe.DefaultBuySpawn = {x = -774.36, y = -233.5776, z = 36.627, h = 214.33}

PepeCustoms.VehicleBuyLocation = {x = -775.4078, y = -231.7079, z = 36.15, h = 207.3916, r = 1.0}
PepeCustoms.ShowroomPositions = {
    [1] = {
        coords = {
            x = -791.7578, 
            y = -217.5236, 
            z = 36.10, 
            h = 117.29499,
            -- -791.7578, -217.5236, 37.414314, 117.29499
        },
        vehicle = "burrito2",
        buying = false,
        inUse = false,
    }, 
    [2] = {
        coords = {
            x = -804.778, 
            y = -214.3469, 
            z = 36.05, 
            h = 207.10113, 
            
        }, 
        vehicle = "faggio",
        buying = false,
        inUse = false,
    }, 
    [3] = {
        coords = {
            x = -795.3166, 
            y = -228.7689, 
            z = 36.10, 
            h = 79.42234,
    -- -795.3166, -228.7689, 37.154785, 79.42234
        },
        vehicle = "kamacho",
        buying = false,
        inUse = false,
    }, 
    [4] = {
        coords = {
            x = -791.9648, 
            y = -235.3013, 
            z = 36.10, 
            h = 88.785842,
    -- -791.9648, -235.3013, 37.160953, 88.785842
        },
        vehicle = "glendale",
        buying = false,
        inUse = false,
    },
    [5] = {
        coords = {
            x = -786.8523, 
            y = -242.5909, 
            z = 36.10, 
            h = 73.369758
    -- -786.8523, -242.5909, 37.168148, 73.369758
            },
        vehicle = "xls",
        buying = false,
        inUse = false,
    },
    [6] = {
       coords = {x = -778.8745, y = -219.6282, z = 36.05, h = 27.54},
        vehicle = "burrito2",
        buying = false,
        inUse = false,
    }, 
    [7] = {
        coords = {x = -787.191, y = -206.7663, z = 36.05, h = 294.5},
        vehicle = "burrito2",
        buying = false,
        inUse = false,
    }, 
}