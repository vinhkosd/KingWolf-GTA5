Config = Config or {}

Config.CanWiet = false

Config.BoatPrice = 500

Config.PoliceNeededs = 1

Config.UsingRod = false

Config.Locations = {
    ['Sell'] = {['X'] = -1686.52, ['Y'] = -1072.51, ['Z'] = 13.15},
    ['Boat'] = {['X'] = 1551.37, ['Y'] = 3799.74, ['Z'] = 34.41},
}

Config.Blips = {
  {title="",scale=0.8, colour=16, id=140, x = 3094.5529, y = 5556.1123, z= 190.27403},
}


-- Config.WeedLocationSpawn = { ['x'] = -1191.905, ['y'] = 3855.8229, ['z'] = 490.15524, ['h'] = 57.111816 }
Config.WeedFieldsSpawnCoords = vector3(3094.5529, 5556.1123, 190.27403)
-- { ['x'] = 3094.5529, ['y'] = 5556.1123, ['z'] = 190.27403, ['h'] = 263.52609 }
Config.MaxWeedsSpawn  = 100

Config.WeedSoorten = {
  'weed_purple-haze',  
  'weed_og-kush',  
  'weed_amnesia', 
  'weed_ak47', 
}

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

Config.WeedLocations = {
  ['drogen'] = {
    [1] = {
       ['x'] = 3822.2775,
       ['y'] = 4440.6489,
       ['z'] = 2.8033063,
       ['IsBezig'] = false,
      --  1392.0277, 3605.5063, 38.941932, 99.26921
      -- 3822.2775, 4440.6489, 2.8033063, 174.26502
       },
   },
   ['verwerk'] = {
    [1] = {
      ['x'] = 3829.27,
      ['y'] = 4441.11,
      ['z'] = 2.8,
      ['IsBezig'] = false,
    },
    [1] = {
      ['x'] = 92.149665,
      ['y'] = 3749.8979,
      ['z'] = 40.771278,
      ['IsBezig'] = false,
    },
   },
    [1] = {
        ['Name'] = 'Wiet1',
        ['Coords'] = {['X'] = 5211.1103, ['Y'] = -5169.724, ['Z'] = 12.056114}
    },
    [2] = {
        ['Name'] = 'Wiet2',
        ['Coords'] = {['X'] = 2202.7255, ['Y'] = 5583.583, ['Z'] = 53.901042}
    },
    -- [3] = {
    --     ['Name'] = 'Wiet3',
    --     ['Coords'] = {['X'] = 5376.8452, ['Y'] = -5262.711, ['Z'] = 34.056072}
    -- },
    -- [4] = {
    --     ['Name'] = 'Wiet4',
    --     ['Coords'] = {['X'] = 1255.98, ['Y'] = 3846.79, ['Z'] = 31.9}
    -- },
    -- [5] = {
    --     ['Name'] = 'Wiet5',
    --     ['Coords'] = {['X'] = 1960.00, ['Y'] = 4255.00, ['Z'] = 30.55}
    -- },
    -- [6] = {
    --     ['Name'] = 'Wiet6',
    --     ['Coords'] = {['X'] = 1011.30, ['Y'] = 3805.20, ['Z'] = 31.55}
    -- },
    -- [7] = {
    --     ['Name'] = 'Wiet7',
    --     ['Coords'] = {['X'] = 598.80, ['Y'] = 3723.56, ['Z'] = 31.45}
    -- },
    -- [8] = {
    --     ['Name'] = 'Wiet8',
    --     ['Coords'] = {['X'] = 636.74, ['Y'] = 4073.77, ['Z'] = 31.45}
    -- },
    -- [9] = {
    --     ['Name'] = 'Wiet9',
    --     ['Coords'] = {['X'] = -55.77, ['Y'] = 4056.46, ['Z'] = 31.2}
    -- },
    -- [10] = {
    --     ['Name'] = 'Wiet10',
    --     ['Coords'] = {['X'] = 1612.92, ['Y'] = 4066.92, ['Z'] = 31.8}
    -- },
    -- [11] = {
    --     ['Name'] = 'Wiet11',
    --     ['Coords'] = {['X'] = -63.36, ['Y'] = 4180.44, ['Z'] = 31.8}
    -- },
}

Config.SellItems = {
 ['Wiet-1'] = {
   ['Type'] = 'money',
   ['Amount'] = math.random(100, 125),
 },
 ['Wiet-2'] = {
   ['Type'] = 'money',
   ['Amount'] = math.random(150, 175),
 },
 ['Wiet-3'] = {
   ['Type'] = 'money',
   ['Amount'] = math.random(200, 225),
 },
 ['plasticbag'] = {
   ['Type'] = 'item',
   ['Item'] = 'plastic',
   ['Amount'] = math.random(10, 17),
 },
 ['shoe'] = {
   ['Type'] = 'item',
   ['Item'] = 'rubber',
   ['Amount'] = math.random(10, 17),
 },
}