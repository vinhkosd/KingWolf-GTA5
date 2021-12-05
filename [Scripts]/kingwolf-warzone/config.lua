Config = Config or {}

Config.Timer = 0

Config.Locations = {
    ['WarZone'] = { ['x'] = 4773.20, ['y'] = -4969.59, ['z'] = -0.4155, ['h'] = 236.74955 },
    ['Revive'] = { ['x'] = 4452.6953, ['y'] = -4464.9, ['z'] = 4.3303442, ['h'] = 145.24098 },
    ['GoToWarZone'] = { ['x'] = -1046.052, ['y'] = -2751.952, ['z'] = 21.36343, ['h'] = 328.82058 },
    ['GoBack'] = { ['x'] = 4441.0976, ['y'] = -4468.182, ['z'] = 4.329741, ['h'] = 31.874198 },
    ['Stash'] = { ['x'] = 4432.1303, ['y'] = -4447.581, ['z'] = 7.2382712, ['h'] = 18.101829 },
    ['Stashsky'] = { ['x'] = -1047.788, ['y'] = -2743.538, ['z'] = 21.359382, ['h'] = 143.27587 },
    ['Craft1'] = { ['x'] = 4448.2143, ['y'] = -4445.038, ['z'] = 7.2732901, ['h'] = 283.52252 },
    ['Craft2'] = { ['x'] = 4447.1171, ['y'] = -4442.246, ['z'] = 7.2370843, ['h'] = 294.15963 },
    ['FoodShop'] = { ['x'] = 4494.2983, ['y'] = -4521.362, ['z'] = 4.4123601, ['h'] = 111.05572 },
    ['WeaponShop'] = { ['x'] = 4440.4926, ['y'] = -4482.392, ['z'] = 4.2921686, ['h'] = 30.542173 },
    ['RentCar'] = { ['x'] = 4367.5673, ['y'] = -4574.75, ['z'] = 4.2077531, ['h'] = 202.41911 },
    ['UnRent'] = { ['x'] = 4387.1401, ['y'] = -4567.946, ['z'] = 4.2543687, ['h'] = 195.33547 },
    ['Spawns'] = {
        [1] = { ['x'] = 4361.1147, ['y'] = -4551.802, ['z'] = 3.6024918, ['h'] = 289.58721 },
        [2] = { ['x'] = 4358.2192, ['y'] = -4544.105, ['z'] = 3.5987489, ['h'] = 292.05429 },
        [3] = { ['x'] = 4356.1479, ['y'] = -4536.479, ['z'] = 3.6026492, ['h'] = 287.77258 },
    },
    ['RentCar2'] = { ['x'] = 5194.0903, ['y'] = -5131.955, ['z'] = 3.3634972, ['h'] = 347.07931 },
    ['UnRent2'] = { ['x'] = 5183.6542, ['y'] = -5132.804, ['z'] = 3.3325893, ['h'] = 260.35815 },
    ['Spawns2'] = {
        [1] = { ['x'] = 5156.0415, ['y'] = -5125.114, ['z'] = 1.8193297, ['h'] = 270.25466 },
        [2] = { ['x'] = 5155.0043, ['y'] = -5130.812, ['z'] = 1.805472, ['h'] = 264.78283 },
        [3] = { ['x'] = 5156.1611, ['y'] = -5134.54, ['z'] = 1.815831, ['h'] = 268.78533 },
    },
    ['Renttank'] = { ['x'] = 4999.5278, ['y'] = -5164.8, ['z'] = 2.7643887, ['h'] = 299.5371 },
    ['UnRentank'] = { ['x'] = 5017.0751, ['y'] = -5196.935, ['z'] = 2.5183286, ['h'] = 306.10876 },
    ['Spawnstank'] = {
        [1] = { ['x'] = 4980.0302, ['y'] = -5173.921, ['z'] = 2.4748075, ['h'] = 246.91374 },
        [2] = { ['x'] = 4984.1376, ['y'] = -5151.399, ['z'] = 2.5276088, ['h'] = 196.1575 },
        [3] = { ['x'] = 4998.9174, ['y'] = -5141.227, ['z'] = 2.5636436, ['h'] = 131.69352 },
    },
}

Config.Radius = 1257.0

Config.Items = {
    label = "Shop súng Warzone",
    slots = 5,
    items = {
        [1] = {
            name = "weapon_pistol_mk2",
            price = 20000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_assaultrifle_mk2",
            price = 50000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weapon_machinepistol",
            price = 40000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "weapon_appistol",
            price = 20000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "weapon_knife",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "weapon_bat",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "weapon_nightstick",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "weapon_flashlight",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "weapon_molotov",
            price = 5000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "weapon_hatchet",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "weapon_switchblade",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "weapon_hammer",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "weapon_wrench",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "weapon_bread",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "weapon_crowbar",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "weapon_carbinerifle_mk2",
            price = 60000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 16,
        },
        [17] = {
            name = "weapon_sawnoffshotgun",
            price = 80000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 17,
        },
        [18] = {
            name = "weapon_snspistol_mk2",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 18,
        },
        [19] = {
            name = "weapon_heavypistol",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 19,
        },
        [20] = {
            name = "weapon_vintagepistol",
            price = 10000,
            amount = 50,
            info = {
                quality = 100.0,
            },
            type = "item",
            slot = 20,
        },
        [21] = {
            name = "pistol-ammo",
            price = 2000,
            amount = 50,
            info = {},
            type = "item",
            slot = 21,
        },
        [22] = {
            name = "smg-ammo",
            price = 3000,
            amount = 50,
            info = {},
            type = "item",
            slot = 22,
        },
        [23] = {
            name = "rifle-ammo",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 23,
        },
        [24] = {
            name = "shotgun-ammo",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 24,
        },
    }
  }