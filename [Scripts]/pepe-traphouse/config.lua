Config = Config or {}

Config.IsSelling = false

Config.TrapHouse = {
    ['Code'] = math.random(1000, 9999),
    ['Owner'] = '',
    ['Coords'] = {
        ['Enter'] = {
            ['X'] = -1533.35, ['Y'] = -275.44, ['Z'] = 49.73, ['H'] = 52.30,
            ['Z-OffSet'] = 35.0,
        },
        ['Interact'] = {
            ['X'] = -1532.42, ['Y'] = -269.79, ['Z'] = 16.88,
        },
    },
}

Config.SellItems = {
 ['diamond-blue'] = {
   ['Type'] = 'money',
   ['Amount'] = math.random(4500, 7000),
 },
 ['diamond-red'] = {
   ['Type'] = 'money',
   ['Amount'] = math.random(4500, 7500),
 },
 ['markedbills'] = {
   ['Type'] = 'money',
   ['Amount'] = 800,
  },
}