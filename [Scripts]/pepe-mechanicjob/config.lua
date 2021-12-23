Config = {}

Config.AttachedVehicle = nil

Config.Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}
Config.Locale = 'en'
Config.AuthorizedIds = {
}

Config.MaxStatusValues = {
    ["engine"] = 1000.0,
    ["body"] = 1000.0,
    ["radiator"] = 100,
    ["axle"] = 100,
    ["brakes"] = 100,
    ["clutch"] = 100,
    ["fuel"] = 100,
}

Config.ValuesLabels = {
    ["engine"] = "Động cơ",
    ["body"] = "Thân vỏ",
    ["radiator"] = "Bộ tản nhiệt",
    ["axle"] = "Khung xe",
    ["brakes"] = "Phanh",
    ["clutch"] = "Hộp số",
    ["fuel"] = "Xăng",
}

Config.RepairCost = {
    ["body"] = "plastic",
    ["radiator"] = "plastic",
    ["axle"] = "steel",
    ["brakes"] = "iron",
    ["clutch"] = "aluminum",
    ["fuel"] = "plastic",
}

Config.RepairCostAmount = {
    ["engine"] = {
        item = "metalscrap",
        costs = 2,
    },
    ["body"] = {
        item = "plastic",
        costs = 3,
    },
    ["radiator"] = {
        item = "steel",
        costs = 5,
    },
    ["axle"] = {
        item = "aluminum",
        costs = 7,
    },
    ["brakes"] = {
        item = "copper",
        costs = 5,
    },
    ["clutch"] = {
        item = "copper",
        costs = 6,
    },
    ["fuel"] = {
        item = "plastic",
        costs = 5,
    },
}

Config.Businesses = {
    "autocare",
}

Config.Plates = {
    [1] = {
        coords = {x = -323.1741, y = -134.0071, z = 38.981792, h = 69.773284, r = 1.0},
        AttachedVehicle = nil,
    },
    [2] = {
        coords = {x = -318.9394, y = -123.7791, z = 38.98, h = 68.536979, r = 1.0},
        AttachedVehicle = nil,
    },
    [3] = {
        coords = {x = -315.4446, y = -113.3009, z = 38.98, h = 70.15, r = 1.0},
        AttachedVehicle = nil,
    },
    [4] = {
        coords = {x = -326.3368, y = -144.5348, z = 38.98, h = 70.01, r = 1.0},
        AttachedVehicle = nil,
    },
}
-- Config.Locations = {
--     ["exit"] = {x = -332.6539, y = -123.63, z = 39.01, h = 330.04, r = 1.0},
--     ["stash"] = {x = -346.0346, y = -111.4645, z = 39.01, h = 71.8, r = 1.0},
--     ["duty"] = {x = -352.5502, y = -127.4821, z = 39.01, h = 147, r = 1.0},
--     ["vehicle"] = {x = -353.4633, y = -89.97753, z = 38.98, h = 70.35, r = 1.0},
--     ['boss'] = {x = -339.6861, y = -157.3088, z = 44.587074, h = 336.62225, r = 1.0},
--     ['kleren'] = {x = -336.5321, y = -165.1832, z = 44.587959, h = 1.129433, r = 1.0},
-- }

Config.Locations = {
    ["exit"] = {x = -341.425, y = -120.529, z = 39.49, h = 70.5, r = 1.0},
    ["stash"] = {x = -345.8361, y = -110.9983, z = 39.01, h = 73, r = 1.0},
    ["duty"] = {x = -346.925, y = -128.6472, z = 39.01, h = 80, r = 1.0},
    ["vehicle"] = {x = -363.0823, y = -119.865, z = 38.69924, h = 75, r = 1.0}, 
    ['boss'] = {x = -305.9205, y = -120.9122, z = 39.009487, h = 161.84399, r = 1.0},
    ['kleren'] = {x = -310.9285, y = -137.8209, z = 39.009487, h = 284.84399, r = 1.0},
}

Config.Vehicles = {
    ["towtruck"] = "Towtruck",
    ["flatbed"] = "Flatbed",
    -- ["blista"] = "Blista",
}

Config.MinimalMetersForDamage = {
    [1] = {
        min = 8000,
        max = 12000,
        multiplier = {
            min = 1,
            max = 8,
        }
    },
    [2] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 8,
            max = 16,
        }
    },
    [3] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 16,
            max = 24,
        }
    },
}

Config.Damages = {
    ["radiator"] = "Radiator",
    ["axle"] = "Axle",
    ["brakes"] = "Brakes",
    ["clutch"] = "Clutch",
    ["fuel"] = "Tank",
}