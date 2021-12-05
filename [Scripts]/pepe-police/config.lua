Config = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.CurrentId = nil

Config.IsEscorted = false
Config.IsHandCuffed = false

Config.Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Config.Keys = {["E"] = 38, ["G"] = 47, ["H"] = 74, ["BACKSPACE"] = 177}

Config.AmmoLabels = {
 ["AMMO_PISTOL"] = "9x19mm Parabellum kogel",
 ["AMMO_SMG"] = "9x19mm Parabellum kogel",
 ["AMMO_RIFLE"] = "7.62x39mm kogel",
 ["AMMO_MG"] = "7.92x57mm Mauser kogel",
 ["AMMO_SHOTGUN"] = "12-gauge kogel",
 ["AMMO_SNIPER"] = "Groot kaliber kogel",
}

Config.StatusList = {
 ["fight"] = "Rode handen",
 ["widepupils"] = "Verwijde pupillen",
 ["redeyes"] = "Rode ogen",
 ["weedsmell"] = "Ruikt naar wiet",
 ["alcohol"] = "Adem ruikt naar alcohol",
 ["gunpowder"] = "Kruitsporen in kleding",
 ["chemicals"] = "Ruikt chemisch",
 ["heavybreath"] = "Ademt zwaar",
 ["sweat"] = "Zweet erg",
 ["handbleed"] = "Bloed op handen",
 ["confused"] = "Verward",
 ["alcohol"] = "Ruikt naar alcohol",
 ["heavyalcohol"] = "Ruikt erg naar alcohol",
}

Config.SilentWeapons = {
 "WEAPON_UNARMED",
 "WEAPON_SNOWBALL",
 "WEAPON_PETROLCAN",
 "WEAPON_STUNGUN",
 "WEAPON_FIREEXTINGUISHER",
}

Config.WeaponHashGroup = {
 [416676503] =   {['name'] = "Pistool"},
 [860033945] =   {['name'] = "Shotgun"},
 [970310034] =   {['name'] = "Semi-Automatisch"},
 [1159398588] =  {['name'] = "Automatisch"},
 [-1212426201] = {['name'] = "Scherpschutter"},
 [-1569042529] = {['name'] = "Zwaar"},
 [1548507267] =  {['name'] = "Granaat"},
}
-- Config.ClothingRooms = {
--   [1] = {requiredJob = "police", x = 462.07, y = -999.08, z = 30.68, cameraLocation = {x = 462.02, y = -998.90, z = 30.68, h = 87.96}},
--   [3] = {requiredJob = "ambulance", x = 300.16, y = -598.93, z = 43.28, cameraLocation = {x = 301.09, y = -596.09, z = 43.28, h = 157.5}},
-- }
Config.Locations = {
    ['checkin'] = {
      [1] = {['X'] = 441.27, ['Y'] = -981.96, ['Z'] = 30.68},
    },
    ['fingerprint'] = {
        [1] = {['X'] = 473.19, ['Y'] = -1007.45, ['Z'] = 26.27},
    },
    ['personal-safe'] = {
      [1] = {['X'] = 461.70, ['Y'] = -996.09, ['Z'] = 30.68},
    },
    ['work-shops'] = {
      [1] = {['X'] = 482.63, ['Y'] = -995.21, ['Z'] = 30.68},
    },
    ['boss'] = {
      [1] = {['X'] = 460.55288, ['Y'] = -985.4736, ['Z'] = 30.728073},
    },
    ['impound'] = {
      [1] = {['X'] = 425.91876, ['Y'] = -991.558, ['Z'] = 25.69979},
    },
    ['clothing'] = {
      [1] = {['X'] = 462.07, ['Y'] = -999.08, ['Z'] = 30.68},
    },
    ['garage'] = {
        [1] = {
         ['X'] = 441.05, 
         ['Y'] = -992.93, 
         ['Z'] = 25.69,
         ['Spawns'] = {
            [1] = {
             ['X'] = 436.87,
             ['Y'] = -994.17,
             ['Z'] = 25.69,
             ['H'] = 88.02,
            },
            [2] = {
             ['X'] = 437.08,
             ['Y'] = -988.96,
             ['Z'] = 25.89,
             ['H'] = 90.94,
            },
            [3] = {
             ['X'] = 445.19,
             ['Y'] = -991.56,
             ['Z'] = 25.69,
             ['H'] = 268.71,
            },
          },
       },
      [2] = {
          ['X'] = 450.02, 
          ['Y'] = -981.21, 
          ['Z'] = 43.69,
          ['Spawns'] = nil
      },
      [3] = {
        ['X'] = 1836.65, 
        ['Y'] = 3694.99, 
        ['Z'] = 34.27,
        ['Spawns'] = {
          [1] = {
            ['X'] = 1836.77,
            ['Y'] = 3698.77,
            ['Z'] = 34.22,
            ['H'] = 111.41,
          },
          [2] = {
            ['X'] = 1827.03,
            ['Y'] = 3693.26,
            ['Z'] = 34.22,
            ['H'] = 298.9,
          },
          [3] = {
          ['X'] = 1817.98,
          ['Y'] = 3687.9,
          ['Z'] = 34.22,
          ['H'] = 299.67,
          },
          [4] = {
            ['X'] = 1805.4,
            ['Y'] = 3681.21,
            ['Z'] = 34.22,
            ['H'] = 287.25,
          },
           
           
         },
      },
      [4] = {
        ['X'] = -436.05, 
        ['Y'] = 6025.69, 
        ['Z'] = 31.49,
        ['Spawns'] = {
          [1] = {
            ['X'] = -438.56,
            ['Y'] = 6029.16,
            ['Z'] = 31.34,
            ['H'] = 217.14,
          },
          [2] = {
            ['X'] = -442.51,
            ['Y'] = 6027.28,
            ['Z'] = 31.34,
            ['H'] = 220.98,
          },
          [3] = {
          ['X'] = -435.49,
          ['Y'] = 6032.8,
          ['Z'] = 31.34,
          ['H'] = 208.43,
          },
          [4] = {
            ['X'] = -443.57,
            ['Y'] = 6052.06,
            ['Z'] = 31.34,
            ['H'] = 25.76,
          },
          [5] = {
            ['X'] = -447.13,
            ['Y'] = 6050.08,
            ['Z'] = 31.34,
            ['H'] = 34.79,
          },
          [6] = {
            ['X'] = -451.63,
            ['Y'] = 6047.31,
            ['Z'] = 31.34,
            ['H'] = 40.22,
          },
         },
      },
    },
}

Config.Objects = {
  ["cone"] = {model = `prop_roadcone02a`, freeze = false},
  ["barrier"] = {model = `prop_barrier_work06a`, freeze = true},
  ["schot"] = {model = `prop_snow_sign_road_06g`, freeze = true},
  ["tent"] = {model = `prop_gazebo_03`, freeze = true},
  ["light"] = {model = `prop_worklight_03b`, freeze = true},
}

Config.Items = {
  label = "Politie Wapenkluis",
  slots = 30,
  items = {
      [1] = {
        name = "weapon_pistol_mk2",
        price = 0,
        amount = 1,
        info = {
            serie = "",  
            quality = 100.0,              
            attachments = {{component = "COMPONENT_AT_PI_FLSH_02", label = "Flashlight"}}
        },
        type = "weapon",
        slot = 1,
        bossRequired = true,
      },
      [2] = {
        name = "weapon_stungun",
        price = 0,
        amount = 1,
        info = {
            serie = "",   
            quality = 100.0,         
        },
        type = "weapon",
        slot = 2,
      },
      [3] = {
        name = "weapon_carbinerifle_mk2",
        price = 0,
        amount = 1,
        info = {
          serie = "",  
          quality = 100.0,
          attachments = {{component = "COMPONENT_AT_SCOPE_MEDIUM_MK2", label = "Scope"}, {component = "COMPONENT_AT_MUZZLE_05", label = "Muzzle Demper"}, {component = "COMPONENT_AT_AR_AFGRIP_02", label = "Grip"}, {component = "COMPONENT_AT_AR_FLSH", label = "Falshlight"}}    
        },
        type = "weapon",
        slot = 3,
        bossRequired = true,
      },
      [4] = {
        name = "weapon_flashlight",
        price = 0,
        amount = 1,
        info = {
          quality = 100.0
        },
        type = "weapon",
        slot = 4,
        bossRequired = true,
      },
      [5] = {
        name = "weapon_nightstick",
        price = 0,
        amount = 1,
        info = {
          quality = 100.0
        },
        type = "weapon",
        slot = 5,
        bossRequired = true,
      },
      [6] = {
        name = "pistol-ammo",
        price = 100,
        amount = 50,
        info = {},
        type = "item",
        slot = 6,
        bossRequired = true,
      },
      [7] = {
        name = "rifle-ammo",
        price = 250,
        amount = 50,
        info = {},
        type = "item",
        slot = 7,
        bossRequired = true,
      },
      [8] = {
        name = "armor",
        price = 150,
        amount = 50,
        info = {},
        type = "item",
        slot = 8,
        bossRequired = true,
      },
      [9] = {
        name = "heavy-armor",
        price = 350,
        amount = 50,
        info = {},
        type = "item",
        slot = 9,
        bossRequired = true,
      },
      [10] = {
        name = "handcuffs",
        price = 0,
        amount = 1,
        info = {},
        type = "item",
        slot = 10,
        bossRequired = true,
      },
      [11] = {
        name = "empty_evidence_bag",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 11,
        bossRequired = true,
      },
      [12] = {
        name = "radio",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 12,
        bossRequired = true,
      },
      [13] = {
        name = "police_stormram",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 13,
        bossRequired = true,
      }, 
      [14] = {
        name = "spikestrip",
        price = 0,
        amount = 50,
        info = {},
        type = "item",
        slot = 14,
        bossRequired = true,
    },
   }
}


Config.SecurityCameras = {
  hideradar = false,
  cameras = {
      [1] = {label = "Pacific Bank CAM#1", x = 257.45, y = 210.07, z = 109.08, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = false, isOnline = true},
      [2] = {label = "Pacific Bank CAM#2", x = 232.86, y = 221.46, z = 107.83, r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = false, isOnline = true},
      [3] = {label = "Pacific Bank CAM#3", x = 252.27, y = 225.52, z = 103.99, r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = false, isOnline = true},
      [4] = {label = "Limited Ltd Grove St. CAM#1", x = -53.1433, y = -1746.714, z = 31.546, r = {x = -35.0, y = 0.0, z = -168.9182}, canRotate = false, isOnline = true},
      [5] = {label = "Rob's Liqour Prosperity St. CAM#1", x = -1482.9, y = -380.463, z = 42.363, r = {x = -35.0, y = 0.0, z = 79.53281}, canRotate = false, isOnline = true},
      [6] = {label = "Rob's Liqour San Andreas Ave. CAM#1", x = -1224.874, y = -911.094, z = 14.401, r = {x = -35.0, y = 0.0, z = -6.778894}, canRotate = false, isOnline = true},
      [7] = {label = "Limited Ltd Ginger St. CAM#1", x = -718.153, y = -909.211, z = 21.49, r = {x = -35.0, y = 0.0, z = -137.1431}, canRotate = false, isOnline = true},
      [8] = {label = "24/7 Supermarkt Innocence Blvd. CAM#1", x = 23.885, y = -1342.441, z = 31.672, r = {x = -35.0, y = 0.0, z = -142.9191}, canRotate = false, isOnline = true},
      [9] = {label = "Rob's Liqour El Rancho Blvd. CAM#1", x = 1133.024, y = -978.712, z = 48.515, r = {x = -35.0, y = 0.0, z = -137.302}, canRotate = false, isOnline = true},
      [10] = {label = "Limited Ltd West Mirror Drive CAM#1", x = 1151.93, y = -320.389, z = 71.33, r = {x = -35.0, y = 0.0, z = -119.4468}, canRotate = false, isOnline = true},
      [11] = {label = "24/7 Supermarkt Clinton Ave CAM#1", x = 383.402, y = 328.915, z = 105.541, r = {x = -35.0, y = 0.0, z = 118.585}, canRotate = false, isOnline = true},
      [12] = {label = "Limited Ltd Banham Canyon Dr CAM#1", x = -1832.057, y = 789.389, z = 140.436, r = {x = -35.0, y = 0.0, z = -91.481}, canRotate = false, isOnline = true},
      [13] = {label = "Rob's Liqour Great Ocean Hwy CAM#1", x = -2966.15, y = 387.067, z = 17.393, r = {x = -35.0, y = 0.0, z = 32.92229}, canRotate = false, isOnline = true},
      [14] = {label = "24/7 Supermarkt Ineseno Road CAM#1", x = -3046.749, y = 592.491, z = 9.808, r = {x = -35.0, y = 0.0, z = -116.673}, canRotate = false, isOnline = true},
      [15] = {label = "24/7 Supermarkt Barbareno Rd. CAM#1", x = -3246.489, y = 1010.408, z = 14.705, r = {x = -35.0, y = 0.0, z = -135.2151}, canRotate = false, isOnline = true},
      [16] = {label = "24/7 Supermarkt Route 68 CAM#1", x = 539.773, y = 2664.904, z = 44.056, r = {x = -35.0, y = 0.0, z = -42.947}, canRotate = false, isOnline = true},
      [17] = {label = "Rob's Liqour Route 68 CAM#1", x = 1169.855, y = 2711.493, z = 40.432, r = {x = -35.0, y = 0.0, z = 127.17}, canRotate = false, isOnline = true},
      [18] = {label = "24/7 Supermarkt Senora Fwy CAM#1", x = 2673.579, y = 3281.265, z = 57.541, r = {x = -35.0, y = 0.0, z = -80.242}, canRotate = false, isOnline = true},
      [19] = {label = "24/7 Supermarkt Alhambra Dr. CAM#1", x = 1966.24, y = 3749.545, z = 34.143, r = {x = -35.0, y = 0.0, z = 163.065}, canRotate = false, isOnline = true},
      [20] = {label = "24/7 Supermarkt Senora Fwy CAM#2", x = 1729.522, y = 6419.87, z = 37.262, r = {x = -35.0, y = 0.0, z = -160.089}, canRotate = false, isOnline = true},
      [21] = {label = "Fleeca Bank Hawick Ave CAM#1", x = 309.341, y = -281.439, z = 55.88, r = {x = -35.0, y = 0.0, z = -146.1595}, canRotate = false, isOnline = true},
      [22] = {label = "Fleeca Bank Legion Square CAM#1", x = 144.871, y = -1043.044, z = 31.017, r = {x = -35.0, y = 0.0, z = -143.9796}, canRotate = false, isOnline = true},
      [23] = {label = "Fleeca Bank Hawick Ave CAM#2", x = -355.7643, y = -52.506, z = 50.746, r = {x = -35.0, y = 0.0, z = -143.8711}, canRotate = false, isOnline = true},
      [24] = {label = "Fleeca Bank Del Perro Blvd CAM#1", x = -1214.226, y = -335.86, z = 39.515, r = {x = -35.0, y = 0.0, z = -97.862}, canRotate = false, isOnline = true},
      [25] = {label = "Fleeca Bank Great Ocean Hwy CAM#1", x = -2958.885, y = 478.983, z = 17.406, r = {x = -35.0, y = 0.0, z = -34.69595}, canRotate = false, isOnline = true},
      [26] = {label = "Paleto Bank CAM#1", x = -102.939, y = 6467.668, z = 33.424, r = {x = -35.0, y = 0.0, z = 24.66}, canRotate = false, isOnline = true},
      [27] = {label = "Del Vecchio Liquor Paleto Bay", x = -163.75, y = 6323.45, z = 33.424, r = {x = -35.0, y = 0.0, z = 260.00}, canRotate = false, isOnline = true},
      [28] = {label = "Don's Country Store Paleto Bay CAM#1", x = 166.42, y = 6634.4, z = 33.69, r = {x = -35.0, y = 0.0, z = 32.00}, canRotate = false, isOnline = true},
      [29] = {label = "Don's Country Store Paleto Bay CAM#2", x = 163.74, y = 6644.34, z = 33.69, r = {x = -35.0, y = 0.0, z = 168.00}, canRotate = false, isOnline = true},
      [30] = {label = "Don's Country Store Paleto Bay CAM#3", x = 169.54, y = 6640.89, z = 33.69, r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = false, isOnline = true},
  },
}