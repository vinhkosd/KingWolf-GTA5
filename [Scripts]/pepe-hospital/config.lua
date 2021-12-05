Config = Config or {}
Config.MinimalDoctors = 1

Config.Keys = {["E"] = 38, ["T"] = 245, ["V"] = 0, ["ESC"] = 322, ["F1"] = 288, ["HOME"] = 213}

Config.Locale = "en"
Config.IsDeath = false
Config.IsInBed = false
Config.Timer = 300

Config.RespawnPrice = 5000 

Config.OnOxy = false

Config.BedPayment = 500

Config.MaxBodyPartHealth = 5

Config.CurrentPain = {}

Config.Locations = {
  ["CheckIn"] = {['X'] = -435.9427, ['Y'] = -325.8976, ['Z'] = 34.91 },
  ['Duty'] = {
    -- [1] = {['X'] = 312.29, ['Y'] = -597.26, ['Z'] = 43.28},
    -- [1] = { ['X'] = -435.9427, ['Y'] = -325.8976, ['Z'] = 34.91 },
    [1] = { ['X'] = -435.7298, ['Y'] = -320.2404, ['Z'] = 34.91 }
    -- thaydo = { ['x'] = -443.7537, ['y'] = -309.9167, ['z'] = 34.910541, ['h'] = 16.490957 }
  },
  ['Shop'] = {
    -- [1] = {['X'] = 308.91, ['Y'] = -562.32, ['Z'] = 43.28},
    [1] = { ['X'] = -491.098, ['Y'] = -340.2428, ['Z'] = 42.32 },
  },
  ['Storage'] = {
    -- [1] = {['X'] = 309.81, ['Y'] = -569.33, ['Z'] = 43.28},
    [1] = { ['X'] = -429.6763, ['Y'] = -318.0174, ['Z'] = 34.91 }
  },
  ['Boss'] = {
    -- [1] = {['X'] = 334.7536, ['Y'] = -594.1212, ['Z'] = 43.28},
    [1] = { ['X'] = -509.0816, ['Y'] = -301.0985, ['Z'] = 69.43 }
  },
  ['Teleporters'] = {
    -- ['ToHeli'] = {['X'] = 331.99, ['Y'] = -595.62, ['Z'] = 43.28},
    -- ['ToHospitalFirst'] = {['X'] = 339.06, ['Y'] = -583.92, ['Z'] = 74.16},
    ['ToHeli'] = { ['X'] = -444.0365, ['Y'] = -332.793, ['Z'] = 78.16 },
    ['ToHospitalFirst'] = { ['X'] = -436.0606, ['Y'] = -359.7031, ['Z'] = 34.94 },

    ['ToHospitalSecond'] = {['X'] = 329.98, ['Y'] = -601.08, ['Z'] = 43.28},
    ['ToLower'] = {['X'] = 344.84, ['Y'] = -586.30, ['Z'] = 28.79},
  },
  ['Garage'] = {
    [1] = {
      -- table = { ['X'] = -428.9572, ['Y'] = -348.4574, ['Z'] = 24.22937, ['h'] = 108.27359 }
      -- ['X'] = 329.30, 
      -- ['Y'] = -575.07, 
      -- ['Z'] = 28.79,
      ['X'] = -428.9572,
      ['Y'] = -348.4574,
      ['Z'] = 24.22937,
      ['Spawns'] = {
       [1] = {        
        -- table = { ['X'] = -431.9976, ['Y'] = -349.2804, ['Z'] = 24.2304, ['H'] = 193.30151 } 
        -- ['X'] = 320.39,
        -- ['Y'] = -569.56,
        -- ['Z'] = 28.79,
        -- ['H'] = 262.24,
        ['X'] = -431.9976,
        ['Y'] = -349.2804,
        ['Z'] = 24.2304,
        ['H'] = 193.30151,
         -- 320.39758, -569.5681, 28.796854, 262.24481
       },
       [2] = {
        -- ['X'] = 327.38,
        -- ['Y'] = -570.27,
        -- ['Z'] = 28.79,
        -- ['H'] = 340.72,
        ['X'] = -439.9455,
        ['Y'] = -351.794,
        ['Z'] = 24.23035,
        ['H'] = 196.63996,
        -- table = { ['X'] = -439.9455, ['Y'] = -351.794, ['Z'] = 24.23035, ['H'] = 196.63996 }
       },
       [3] = {
        -- ['X'] = 327.38,
        -- ['Y'] = -570.27,
        -- ['Z'] = 28.79,
        -- ['H'] = 340.72,
        ['X'] = -434.1387,
        ['Y'] = -366.4365,
        ['Z'] = 24.230348,
        ['H'] = 19.960802
        -- table = { ['X'] = -434.1387, ['Y'] = -366.4365, ['Z'] = 24.230348, ['H'] = 19.960802 }
       },
       [4] = {
        -- ['X'] = 327.38,
        -- ['Y'] = -570.27,
        -- ['Z'] = 28.79,
        -- ['H'] = 340.72,
        ['X'] = -426.2984,
        ['Y'] = -364.3053,
        ['Z'] = 24.230344,
        ['H'] = 19.143291,
        -- table = { ['X'] = -426.2984, ['Y'] = -364.3053, ['Z'] = 24.230344, ['H'] = 19.143291 }
       },
       [5] = {
        -- ['X'] = 327.38,
        -- ['Y'] = -570.27,
        -- ['Z'] = 28.79,
        -- ['H'] = 340.72,
        ['X'] = -437.1196,
        ['Y'] = -335.5969,
        ['Z'] = 24.230365,
        ['H'] = 202.90591,
        -- table = { ['X'] = -437.1196, ['Y'] = -335.5969, ['Z'] = 24.230365, ['H'] = 202.90591 }
       },
       [6] = {
        -- ['X'] = 327.38,
        -- ['Y'] = -570.27,
        -- ['Z'] = 28.79,
        -- ['H'] = 340.72,
        ['X'] = -444.8216,
        ['Y'] = -337.9231,
        ['Z'] = 24.23035,
        ['H'] = 196.0846
        -- table = { ['X'] = -444.8216, ['Y'] = -337.9231, ['Z'] = 24.23035, ['H'] = 196.0846 }
       },
      },
    },
    -- table = { ['X'] = -451.6941, ['Y'] = -301.6619, ['Z'] = 78.168037, ['h'] = 18.670991 }
    [2] = {
    --  ['X'] = 352.17, 
    --  ['Y'] = -587.87, 
    --  ['Z'] = 74.16,
    ['X'] = -451.6941,
    ['Y'] = -301.6619,
    ['Z'] = 78.168037,
    ['Spawns'] = nil
   },

},
}

Config.BodyHealth = {
 ['HEAD'] =       {['Name'] = 'đầu',         ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
 ['NECK'] =       {['Name'] = 'cổ',           ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
 ['LOWER_BODY'] = {['Name'] = 'bụng', ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
 ['UPPER_BODY'] = {['Name'] = 'ngực', ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
 ['SPINE'] =      {['Name'] = 'lưng',           ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
 ['LARM'] =       {['Name'] = 'cánh tay trái',    ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
 ['RARM'] =       {['Name'] = 'cánh tay phải',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
 ['LHAND'] =      {['Name'] = 'bàn tay trái',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
 ['RHAND'] =      {['Name'] = 'bàn tay phải',  ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = false},
 ['LLEG'] =       {['Name'] = 'chân trái',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
 ['RLEG'] =       {['Name'] = 'chân phải',  ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
 ['LFOOT'] =      {['Name'] = 'bàn chân trái',   ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
 ['RFOOT'] =      {['Name'] = 'bàn chân phải',  ['Health'] = 4, ['Pain'] = false, ['IsDead'] = false, ['CanDie'] = true},
}

Config.Beds = {
  [1] = {['X'] = -459.0627, ['Y'] = -279.8279, ['Z'] = 35.835102, ['H'] = 207.52749, ['Busy'] = false, ['Hash'] = 2117668672},
  [2] = {['X'] = -454.8921, ['Y'] = -286.2849, ['Z'] = 35.833221, ['H'] = 30.494487, ['Busy'] = false, ['Hash'] = 2117668672},
  [3] = {['X'] = -451.4768, ['Y'] = -285.0762, ['Z'] = 35.833209, ['H'] = 16.534025, ['Busy'] = false, ['Hash'] = 2117668672},
  [4] = {['X'] = -448.3439, ['Y'] = -283.5338, ['Z'] = 35.833202, ['H'] = 23.975502, ['Busy'] = false, ['Hash'] = 2117668672},
  [5] = {['X'] = -455.16, ['Y'] = -278.2385, ['Z'] = 35.835094, ['H'] = 203.29414, ['Busy'] = false, ['Hash'] = 2117668672},
}

Config.BodyParts = {
  [0]     = 'NONE',
  [31085] = 'HEAD',
  [31086] = 'HEAD',
  [39317] = 'NECK',
  [57597] = 'SPINE',
  [23553] = 'SPINE',
  [24816] = 'SPINE',
  [24817] = 'SPINE',
  [24818] = 'SPINE',
  [10706] = 'UPPER_BODY',
  [64729] = 'UPPER_BODY',
  [11816] = 'LOWER_BODY',
  [45509] = 'LARM',
  [61163] = 'LARM',
  [18905] = 'LHAND',
  [4089] = 'LFINGER',
  [4090] = 'LFINGER',
  [4137] = 'LFINGER',
  [4138] = 'LFINGER',
  [4153] = 'LFINGER',
  [4154] = 'LFINGER',
  [4169] = 'LFINGER',
  [4170] = 'LFINGER',
  [4185] = 'LFINGER',
  [4186] = 'LFINGER',
  [26610] = 'LFINGER',
  [26611] = 'LFINGER',
  [26612] = 'LFINGER',
  [26613] = 'LFINGER',
  [26614] = 'LFINGER',
  [58271] = 'LLEG',
  [63931] = 'LLEG',
  [2108] = 'LFOOT',
  [14201] = 'LFOOT',
  [40269] = 'RARM',
  [28252] = 'RARM',
  [57005] = 'RHAND',
  [58866] = 'RFINGER',
  [58867] = 'RFINGER',
  [58868] = 'RFINGER',
  [58869] = 'RFINGER',
  [58870] = 'RFINGER',
  [64016] = 'RFINGER',
  [64017] = 'RFINGER',
  [64064] = 'RFINGER',
  [64065] = 'RFINGER',
  [64080] = 'RFINGER',
  [64081] = 'RFINGER',
  [64096] = 'RFINGER',
  [64097] = 'RFINGER',
  [64112] = 'RFINGER',
  [64113] = 'RFINGER',
  [36864] = 'RLEG',
  [51826] = 'RLEG',
  [20781] = 'RFOOT',
  [52301] = 'RFOOT',  
}

Config.Items = {
  label = "Tủ đồ bệnh viện",
  slots = 5,
  items = {
      [1] = {
          name = "radio",
          price = 500,
          amount = 50,
          info = {},
          type = "item",
          slot = 1,
      },
      [2] = {
          name = "bandage",
          price = 300,
          amount = 50,
          info = {},
          type = "item",
          slot = 2,
      },
      [3] = {
          name = "painkillers",
          price = 500,
          amount = 50,
          info = {},
          type = "item",
          slot = 3,
      },
      [4] = {
          name = "weapon_fireextinguisher",
          price = 5000,
          amount = 50,
          info = {
            quality = 100.0,
          },
          type = "item",
          slot = 4,
      },
      [5] = {
        name = "health-pack",
        price = 2000,
        amount = 50,
        info = {},
        type = "item",
        slot = 5,
    },
  }
}

  --  Edit vi tri
  --   [1] = {
  --     ['X'] = 329.30, 
  --     ['Y'] = -575.07, 
  --     ['Z'] = 28.79,
  --     ['Spawns'] = {
  --      [1] = {         
  --       ['X'] = 320.39758,
  --       ['Y'] = -569.5681,
  --       ['Z'] = 28.796854,
  --       ['H'] = 262.24481,
  --        -- 320.39758, -569.5681, 28.796854, 262.24481
  --      },
  --      [2] = {
  --       ['X'] = 327.38,
  --       ['Y'] = -570.27,
  --       ['Z'] = 28.79,
  --       ['H'] = 340.72,
  --      },
  --    },
  --   },
  --   [2] = {
  --    ['X'] = 352.17, 
  --    ['Y'] = -587.87, 
  --    ['Z'] = 74.16,
  --    ['Spawns'] = nil
  --  },