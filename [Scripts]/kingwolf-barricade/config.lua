Config = Config or {}

Config.Locations = {
	['Rent'] = { ['x'] = 107.13736, ['y'] = -1087.499, ['z'] = 29.302476, ['h'] = 151.5935 },
  ['UnRent'] = { ['x'] = 109.6812, ['y'] = -1056.435, ['z'] = 28.72092, ['h'] = 66.862213 },
  ['Spawns'] = {
    [1] = { ['x'] = 104.37204, ['y'] = -1078.54, ['z'] = 28.718713, ['h'] = 338.75085 },
    [2] = { ['x'] = 107.75343, ['y'] = -1079.592, ['z'] = 28.716796, ['h'] = 339.30035 },
    [3] = { ['x'] = 111.32739, ['y'] = -1081.313, ['z'] = 28.720062, ['h'] = 339.64343 },
    [4] = { ['x'] = 117.42417, ['y'] = -1081.909, ['z'] = 28.717977, ['h'] = 0.0760006 },
    [5] = { ['x'] = 121.21636, ['y'] = -1081.984, ['z'] = 28.72113, ['h'] = 359.91342 },
  },
}

Config.CarModel = "kalahari"

Config.PayAmount = 500
Config.ReturnPay = 100


Config.Objects = {
  -- [1] = {[1] = 'name', [2] = 'prop', [3] = 'prop', [4] = 'prop', [5] = 'prop'},
  [1] = {[1] = 'Traffic Cone', [2] = 'prop_mp_cone_02', [3] = '1.0', [4] = 0, [5] = 0},
  [2] = {[1] = 'Spike Strip', [2] = 'p_ld_stinger_s', [3] = '3.7', [4] = 0, [5] = 0},
  [3] = {[1] = 'Do Not Cross (wood)', [2] = 'prop_barrier_work05', [3] = '3.0', [4] = 1, [5] = 0},
  [4] = {[1] = 'Road Work Ahead', [2] = 'prop_barrier_work04a', [3] = '3.0', [4] = 1, [5] = 0},
  [5] = {[1] = 'Concrete Block', [2] = 'prop_mp_barrier_01', [3] = '5.0', [4] = 1, [5] = 0},
  [6] = {[1] = 'Work Barrier', [2] = 'prop_barrier_work06a', [3] = '3.0', [4] = 1, [5] = 0},
  [7] = {[1] = 'Road Work Ahead (small)', [2] = 'prop_barrier_work06b', [3] = '3.0', [4] = 1, [5] = 0},
}

Config.menu = {

  -------Controls--------
    controls = {
      menu_up = 27,
      menu_down = 173,
      menu_left = 174,
      menu_right = 175,
      menu_select = 201,
      menu_back = 177
    },
  
  -------Menu position-----
    --Possible positions:
    --Left
    --Right
    --Custom position, example: position = {x = 0.2, y = 0.2}
    position = "left",
  
  -------Menu theme--------
    --Possible themes: light, darkred, bluish, greenish
    --Custom example:
    --[[theme = {
      text_color = { r = 255,g = 255, b = 255, a = 255},
      bg_color = { r = 0,g = 0, b = 0, a = 155},
      --Colors when button is selected
      stext_color = { r = 0,g = 0, b = 0, a = 255},
      sbg_color = { r = 255,g = 255, b = 0, a = 200},
    },]]
    theme = "light",
    
  --------Max buttons------
    --Default: 10
    maxbuttons = 10,
  
  -------Size---------
    --[[
    Default:
    width = 0.24
    height = 0.36
    ]]
    width = 0.54,
    height = 0.36
  
  }
  