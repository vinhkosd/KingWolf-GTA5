Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 8
Config.SpeedMultiplier =  3.6


Config.SpeedLimits = {
	residence = 50,
	town      = 80,
	freeway   = 130
}


Config.Vehicles = {
    ["blista"] = "NAME HERE",
}

Config.Zones = {
	DMVSchool = {
		Pos   = {x = 240.02688, y = -1380.107, z = 33.741722},
		Size  = {x = 0.1, y = 0.1, z = 0.05},
		Color = {r = 255, g = 255, b = 255},
		Type  = 2
	},

}

Config.CheckPoints = {

	{
		Pos = {x = 255.139, y = -1400.731, z = 29.537},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify("Tốc độ cho phép: "..Config.SpeedLimits['residence'].."km/h ", "success", 5000)

		end
	},

	{
		Pos = {x = 271.874, y = -1370.574, z = 30.932},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi tới điểm tiếp theo', "success", 5000)
		end
	},

	{
		Pos = {x = 234.907, y = -1345.385, z = 29.542},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				
				Framework.Functions.Notify('Dừng lại và chờ người đi qua đường', "error", 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(4000)

				FreezeEntityPosition(vehicle, false)
				Framework.Functions.Notify('Tốt! Hãy tiếp tục đi tiếp', "error", 5000)
			end)
		end
	},

	{
		Pos = {x = 217.821, y = -1410.520, z = 28.292 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				Framework.Functions.Notify("Quan sát trái phải. Tốc độ cho phép: "..Config.SpeedLimits['town'].." km/h ", "error", 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)

				FreezeEntityPosition(vehicle, false)
				Framework.Functions.Notify('Tiếp tục lái!', "success", 5000)
			end)
		end
	},

	{
		Pos = {x = 183.73622, y = -1394.504, z = 28.425479 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Chú ý tín hiệu giao thông!', "error", 5000)
		end
	},

	{
		Pos = {x = 234.23289, y = -1238.983, z = 28.218307 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},

	{ 
		Pos = {x = 224.55731, y = -1069.657, z = 28.152294 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Dừng lại cho người qua đường', "error", 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(6000)
			FreezeEntityPosition(vehicle, false)
		end
	},

	{
		Pos = {x = 587.50573, y = -1029.189, z = 36.099342 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},
	{
		Pos = {x = 1137.8361, y = -952.9248, z = 47.097686 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},
	{-- RE TRAI RA DUONG RA CAO TOC = { x = 1162.1196, y = -868.9716, z = 53.338146, ['h'] = 346.87951 }
		Pos = { x = 1162.1196, y = -868.9716, z = 53.338146-0.97 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},
	{-- RE PHAI RA CAO TOC = { x = 1056.2985, y = -834.6182, z = 48.582294, ['h'] = 87.966262 }
		Pos = { x = 1056.2985, y = -834.6182, z = 48.582294-0.97 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},
	{-- TANG TOC 130kmh tren cao toc = { x = 904.64593, y = -695.2348, z = 41.691867, ['h'] = 53.895866 }
		Pos = { x = 904.64593, y = -695.2348, z = 41.691867-0.97 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')

			Citizen.CreateThread(function()
				Framework.Functions.Notify("Quan sát bên phải và bên trái trước khi ra cao tốc. Tốc độ cho phép: "..Config.SpeedLimits['freeway'].." km/h ", "error", 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(2000)

				FreezeEntityPosition(vehicle, false)
				Framework.Functions.Notify('Tiếp tục lái!', "success", 5000)
			end)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},
	{-- RE PHAI RA DUONG DAN = { x = 523.61218, y = -492.8114, z = 35.052482, ['h'] = 68.067802 }
		Pos = { x = 523.61218, y = -492.8114, z = 35.052482-0.97 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},
	{-- RE TRAI VE BENH VIEN = { x = 335.47683, y = -468.992, z = 42.519073, ['h'] = 85.802345 }
		Pos = { x = 335.47683, y = -468.992, z = 42.519073-0.97 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
		end
	},
	{-- VAO TRUNG TAM TP GIAM TOC = { x = 175.93922, y = -791.8145, z = 30.725223, ['h'] = 160.54408 }
		Pos = { x = 175.93922, y = -791.8145, z = 30.725223-0.97 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				Framework.Functions.Notify("Quan sát bên phải và bên trái trước khi ra cao tốc. Tốc độ cho phép: "..Config.SpeedLimits['town'].." km/h ", "error", 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(2000)

				FreezeEntityPosition(vehicle, false)
				Framework.Functions.Notify('Tiếp tục lái!', "success", 5000)
			end)
		end
	},
	{-- GAN TOI DIEM THI CUOI CUNG = { x = 81.446128, y = -1336.955, z = 28.632974, ['h'] = 212.38415 }
		Pos = { x = 81.446128, y = -1336.955, z = 28.632974, ['h'] = 212.38415-0.97 },
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Framework.Functions.Notify('Gần tới nơi rồi cẩn thận kẻo trượt nhé!', "error", 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},
	-- {
	-- 	Pos = {x = 1201.3891, y = -734.4391, z = 57.839035},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
	-- 	end
	-- },

	-- { 
	-- 	Pos = {x = 1043.0256, y = -202.6507, z = 69.097633},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
	-- 	end
	-- },
	
	-- { 
	-- 	Pos = {x = 816.22613, y = -54.7724, z = 79.587684},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 1149.5267, y = 372.1109, z = 90.341171},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 949.3327, y = 262.78665, z = 80.055412},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		setCurrentZoneType('freeway')

			
	-- 		Framework.Functions.Notify("Chú ý. Tốc độ tối đa ở đây là - "..Config.SpeedLimits['freeway'].." km/h ", "error", 5000)
	-- 		PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
	-- 	end
	-- },

	-- { 
	-- 	Pos = {x = 637.54058, y = -230.6599, z = 42.168529},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
	-- 	end
	-- },

	-- { 
	-- 	Pos = {x = 331.88369, y = -711.3079, z = 28.349275},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Framework.Functions.Notify('Đi đến điểm tiếp theo', "success", 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 291.35293, y = -831.4489, z = 28.309329},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		setCurrentZoneType('town')
	-- 		Framework.Functions.Notify("Chú ý. Tốc độ tối đa ở đây là - "..Config.SpeedLimits['town'].." km/h ", "error", 5000)
	-- 	end
	-- },

	-- { 
	-- 	Pos = {x = 204.9886, y = -1116.451, z = 28.333709},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Framework.Functions.Notify('Hãy tỉnh táo!', "error", 5000)
	-- 		PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
	-- 	end
	-- },

	{ 
		Pos = {x = 235.283, y = -1398.329, z = 28.921},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DeleteVehicle(vehicle)
		end
	}

}
