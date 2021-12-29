Shared = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Shared.RandomStr = function(length)
	if length > 0 then
		return Shared.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Shared.RandomInt = function(length)
	if length > 0 then
		return Shared.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Shared.SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end

Shared.Items = {
	-- Unarmed --
    ["weapon_unarmed"] 				 = {["name"] = "weapon_unarmed", 		 	  	["label"] = "Hands", 					["weight"] = 1000, 		["type"] = "weapon",	["ammotype"] = 'nil', 					["image"] = "placeholder.png", 	["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Đây là mô tả quy trình giữ chỗ"},
    ["weapon_fireextinguisher"]      = {["name"] = "weapon_fireextinguisher", 		["label"] = "Bình cứu hỏa", 		["weight"] = 1000, 		["type"] = "weapon",	["ammotype"] = 'AMMO_WATER', 			["image"] = "fireext.png",   	["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Bình chữa cháy?"},
	-- Pistols --
	["weapon_stungun"] 				 = {["name"] = "weapon_stungun", 				["label"] = "súng điện", 				["weight"] = 5000, 		["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "stungun.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Cảnh sát đặc nghiệm."},
	["weapon_pistol_mk2"] 			 = {["name"] = "weapon_pistol_mk2", 			["label"] = "Glock 17", 				["weight"] = 7000, 		["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "glock-17.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Súng cảnh sát."},
	["weapon_snspistol_mk2"] 		 = {["name"] = "weapon_snspistol_mk2", 			["label"] = "Sns Pistol", 				["weight"] = 5000, 		["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "snspistol.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Người kế nhiệm cho game bắn súng ewrten chỉ tốt hơn."},
	["weapon_heavypistol"] 			 = {["name"] = "weapon_heavypistol", 			["label"] = "Heavy Pistol", 			["weight"] = 12000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "heavypistol.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "A heavy gun."},
	["weapon_vintagepistol"] 		 = {["name"] = "weapon_vintagepistol", 		    ["label"] = "súng lục cổ điển", 			["weight"] = 7500,    	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "vintage.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Một khẩu súng cổ điển."},
	-- SMG Pistols --A truly classic pisto
	["weapon_machinepistol"] 		 = {["name"] = "weapon_machinepistol", 		    ["label"] = "Machine Pistol", 			["weight"] = 12000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "machine.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Rattatatatataaaaaa."},
	["weapon_appistol"] 			 = {["name"] = "weapon_appistol", 			    ["label"] = "AP Pistol", 			    ["weight"] = 12000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "appistol.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Đây là một lực lượng cứu hỏa."},
	-- Shothguns --
	["weapon_sawnoffshotgun"] 		 = {["name"] = "weapon_sawnoffshotgun", 		["label"] = "Sawnoff Shotgun", 			["weight"] = 15500, 	["type"] = "weapon", 	["ammotype"] = "AMMO_SHOTGUN",			["image"] = "sawnoff.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Đây là sự thỏa thuận."},
	-- Rifles --
	["weapon_carbinerifle_mk2"] 	 = {["name"] = "weapon_carbinerifle_mk2", 		["label"] = "Carbine Rifle",	 		["weight"] = 17000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_RIFLE",			["image"] = "saltmaker.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Súng cảnh sát Carbine."},
	["weapon_assaultrifle_mk2"] 	 = {["name"] = "weapon_assaultrifle_mk2", 		["label"] = "Assault Rifle",	 		["weight"] = 17000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_RIFLE",			["image"] = "assaultrifle.png",   ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Aks in the back."},
	-- Melee --
	["weapon_nightstick"] 			 = {["name"] = "weapon_nightstick", 			["label"] = "Police Baton", 			["weight"] = 3000,	 	["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "baton.png", 		  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "A police baton."},
	["weapon_flashlight"] 			 = {["name"] = "weapon_flashlight", 			["label"] = "Flashlight", 				["weight"] = 1350,	 	["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "flashlight.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Chiếu sáng cho tôi."},
	["weapon_hatchet"] 				 = {["name"] = "weapon_hatchet", 		 	  	["label"] = "Rìu", 						["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',		            	["image"] = "hatchet.png", 		  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Để chặt gỗ hoặc một cái gì đó."},
	["weapon_switchblade"] 			 = {["name"] = "weapon_switchblade", 	 	  	["label"] = "Switchblade", 				["weight"] = 1750, 		["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "switchblade.png",	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Một con dao chết người."},
	["weapon_hammer"] 				 = {["name"] = "weapon_hammer", 			 	["label"] = "Búa", 						["weight"] = 2750, 		["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "hammer.png",         ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Búa gõ"},
	["weapon_bat"] 				 	= {["name"] = "weapon_bat", 			 		["label"] = "Knuppel", 					["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "bat.png",         ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Búa gõ"},
	["weapon_wrench"] 				 = {["name"] = "weapon_wrench", 			 	["label"] = "Sleutel", 					["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "wrench.png",         ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Cờ lê."},
	["weapon_bread"] 				 = {["name"] = "weapon_bread", 		 			["label"] = "Brood", 					["weight"] = 2550, 		["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "baquette.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Một cây gậy dài."},
	["weapon_knife"] 				 = {["name"] = "weapon_knife", 			 	  	["label"] = "Dao", 						["weight"] = 3000, 		["type"] = "weapon", 	["ammotype"] = nil,						["image"] = "knife.png", 				["unique"] = true, 		["useable"] = true, 	["combinable"] = nil, ["description"] = "Nội dung sắc nét?"},
	["weapon_crowbar"] 				 = {["name"] = "weapon_crowbar", 			 	  	["label"] = "Cục gạch", 						["weight"] = 3000, 		["type"] = "weapon", 	["ammotype"] = nil,						["image"] = "cucgach.png", 				["unique"] = true, 		["useable"] = true, 	["combinable"] = nil, ["description"] = "Nội dung sắc nét?"},

	["weapon_molotov"] 				 = {["name"] = "weapon_molotov", 		 		["label"] = "Molotov", 					["weight"] = 4550, 		["type"] = "weapon", 	["ammotype"] = 'nil',						["image"] = "molotov.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Cocktail ngon lành."},
	["cash"] 						 = {["name"] = "cash", 			 	  			["label"] = "Cash", 					["weight"] = 1, 		["type"] = "item", 		["image"] = "ammo-pistol.png", 			["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Cash"},
	
	-- Ammo --
	["pistol-ammo"] 				 = {["name"] = "pistol-ammo", 			 	  	["label"] = "Pistool Munitie", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "ammo-pistol.png", 			["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Đạn súng lục."},
	["rifle-ammo"] 					 = {["name"] = "rifle-ammo", 			 	  	["label"] = "Rifle Munitie", 			["weight"] = 300, 		["type"] = "item", 		["image"] = "ammo-rifle.png", 			["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Tôi nghĩ đây là đạn súng trường tự động..."},
	["smg-ammo"] 					 = {["name"] = "smg-ammo", 			 	  		["label"] = "Smg Munitie", 				["weight"] = 250, 		["type"] = "item", 		["image"] = "ammo-smg.png", 			["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Đạn súng trường bắn tự động."},
	["shotgun-ammo"] 				 = {["name"] = "shotgun-ammo", 			 	  	["label"] = "Shotgun Shells", 			["weight"] = 250, 		["type"] = "item", 		["image"] = "ammo-shotgun.png", 		["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Shotguns Shells."},
	["taser-ammo"] 				 	 = {["name"] = "taser-ammo", 			 	  	["label"] = "Tazer Cartridge", 			["weight"] = 250, 		["type"] = "item", 		["image"] = "taser-ammo.png", 		    ["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Hãy cẩn thận, bạn không nhận được một opter."},
	-- Attatchments --
	["pistol_suppressor"] 			 = {["name"] = "pistol_suppressor", 			["label"] = "Pistol Suppressor", 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "pistol_suppressor.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "weapon attatchement."},
	["pistol_extendedclip"] 		 = {["name"] = "pistol_extendedclip", 			["label"] = "Pistol EXT Clip", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "pistol_extendedclip.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "weapon attatchement."},
	
	["rifle_extendedclip"] 		 	 = {["name"] = "rifle_extendedclip", 			["label"] = "Rifle EXT Clip", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_extendedclip.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "weapon attatchement."},
	["rifle_flashlight"] 		 	 = {["name"] = "rifle_flashlight", 				["label"] = "Rifle Flashlight", 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_flashlight.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "weapon attatchement."},
	["rifle_suppressor"] 			 = {["name"] = "rifle_suppressor", 				["label"] = "Rifle Suppressor", 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_suppressor.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "weapon attatchement."},
	["rifle_grip"] 			 	     = {["name"] = "rifle_grip", 					["label"] = "Rifle Grip", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_grip.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "weapon attatchement."},
	["rifle_scope"] 			 	 = {["name"] = "rifle_scope", 					["label"] = "Rifle Scope", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_scope.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "weapon attatchement."},
	-- Items --
	["handcuffs"] 					 = {["name"] = "handcuffs", 			 	  	["label"] = "Còng tay", 				["weight"] = 1250, 		["type"] = "item", 		["image"] = "cuffs.png", 				["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Còng tay ai đó"},
	["radio"] 						 = {["name"] = "radio", 			 	 		["label"] = "Radio", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "porto.png", 				["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Nói chuyện qua mạng."},
	["police_stormram"] 			 = {["name"] = "police_stormram", 			 	["label"] = "Stormram", 				["weight"] = 7500, 		["type"] = "item", 		["image"] = "stormram.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Một con bão lao thẳng vào nhà."},
	["empty_evidence_bag"] 			 = {["name"] = "empty_evidence_bag", 			["label"] = "Túi bằng chứng trống", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "evidence.png", 			["unique"] = false,     ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Thường được sử dụng để lưu trữ bằng chứng. Nghĩ về DNA từ máu, vỏ đạn hoặc tóc, etc.."},
	["filled_evidence_bag"] 		 = {["name"] = "filled_evidence_bag", 			["label"] = "Túi bằng chứng đã đầy", 		["weight"] = 200, 		["type"] = "item", 		["image"] = "evidence.png", 			["unique"] = true, 	    ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Túi bằng chứng đầy."},	
	["bloodvial"] 					 = {["name"] = "bloodvial", 					["label"] = "Bình máu", 				["weight"] = 350, 		["type"] = "item", 		["image"] = "bloodvial.png", 			["unique"] = true, 	    ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Một ống y tế và một bình máu."},
	["armor"] 						 = {["name"] = "armor", 			 	  		["label"] = "Áo Giáp 1", 				["weight"] = 7500, 	["type"] = "item", 		["image"] = "vest.png", 				["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Áo chống đạn 1."},
	["heavy-armor"] 				 = {["name"] = "heavy-armor", 			 	  	["label"] = "Áo giáp 2", 				["weight"] = 11000, 	["type"] = "item", 		["image"] = "zwaar-vest.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Áo chống đạn 2."},
	["policecard"] 		 		 	 = {["name"] = "policecard",           			["label"] = "Politie Card",	 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "card.png", 				["unique"] = true, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Thẻ Cảnh sát để mở tất cả các cánh cửa của các PD"},
	["spikestrip"] 					 = {["name"] = "spikestrip", 			 	  	["label"] = "Spikestrip", 			    ["weight"] = 3500, 	["type"] = "item", 		["image"] = "spikestrip.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Sắp bật ra?"},
	["gatecrack"] 					 = {["name"] = "gatecrack", 			 	  	["label"] = "Gatecrack", 			    ["weight"] = 3500, 	["type"] = "item", 		["image"] = "gatecrack.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Thường được sử dụng trong các cuộc vượt ngục..."},
	-- Lockpicks     
	["lockpick"] 					 = {["name"] = "lockpick", 			 	 	 	["label"] = "Lockpick", 				["weight"] = 1000,  	["type"] = "item", 		["image"] = "lockpick.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = {accept = {"toolkit"}, reward = "advancedlockpick", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Lockpick maken", ["timeOut"] = 7500,}},   ["description"] = "Mở khóa"},
	["toolkit"] 					 = {["name"] = "toolkit", 			 			["label"] = "Toolkit", 					["weight"] = 450,  		["type"] = "item", 		["image"] = "toolkit.png", 				["unique"] = false,     ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = {accept = {"lockpick"}, reward = "advancedlockpick", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Lockpick maken", ["timeOut"] = 7500,}},  ["description"] = "Bộ tuốc nơ vít tiện dụng."},
	["repairkit"] 					 = {["name"] = "repairkit", 			 		["label"] = "Bộ dụng cụ sửa chữa", 				["weight"] = 2500,  	["type"] = "item", 		["image"] = "repairkit.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Dùng để sửa xe."},
	["advancedlockpick"] 			 = {["name"] = "advancedlockpick", 			 	["label"] = "Adv. Lockpick", 			["weight"] = 1500,  	["type"] = "item", 		["image"] = "advlockpick.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["drill"] 				 		 = {["name"] = "drill", 			    		["label"] = "Máy khoan", 					["weight"] = 5000, 	["type"] = "item", 		["image"] = "drill.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = ""},
	["explosive"] 				 	 = {["name"] = "explosive", 			    	["label"] = "Explosief", 				["weight"] = 20000, 	["type"] = "item", 		["image"] = "c4.png", 				["unique"] = true, 	["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Big boom!"},
	["lighter"] 				 	 = {["name"] = "lighter", 			    		["label"] = "Aansteker", 				["weight"] = 1000, 	["type"] = "item", 		["image"] = "lighter.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Light the mf on fire"},
	["nitrous"] 				 	 = {["name"] = "nitrous", 			    		["label"] = "Nitro", 					["weight"] = 1000, 	["type"] = "item", 		["image"] = "nitrous.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "YEEEEEEEEEET!"},
	-- Cards --
	["blue-card"] 			 		 = {["name"] = "blue-card", 			 		["label"] = "Thẻ màu xanh lam", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-blue.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Thẻ màu xanh lam.."},
	["purple-card"] 				 = {["name"] = "purple-card", 			 		["label"] = "Thẻ màu tím", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-purple.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Thẻ màu tím.."},
	["red-card"] 					 = {["name"] = "red-card", 					 	["label"] = "Thẻ màu đỏ", 				["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-red.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Thẻ màu đỏ.."},
	["green-card"] 					 = {["name"] = "green-card", 					["label"] = "Thẻ màu xanh lá", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-green.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Thẻ màu xanh lá.."},
	["yellow-card"] 				 = {["name"] = "yellow-card", 					["label"] = "Thẻ màu vàng", 				["weight"] = 1000,  	["type"] = "item", 		["image"] = "jewerly-yellow.png", 		["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Thẻ màu vàng.."},
	["black-card"] 				 	 = {["name"] = "black-card", 					["label"] = "Thẻ màu đen", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-black.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Thẻ màu đen.."},
	["electronickit"] 			   	 = {["name"] = "electronickit", 				["label"] = "Bộ dụng cụ điện tử", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "electronickit.png", 		["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = {accept = {"trojan_usb"}, reward = "gatecrack", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Lockpick maken", ["timeOut"] = 7500,}},   ["description"] = "Một số loại bo mạch chủ?!?"},
	["trojan_usb"] 				 	 = {["name"] = "trojan_usb", 			  	  	["label"] = "Trojan USB", 				["weight"] = 5000, 		["type"] = "item", 		["image"] = "usbplugin.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Phần mềm tiện dụng để tắt một số hệ thống nhất định."},
	-- Robbery Rewards --
	["ciggy"] 						 = {["name"] = "ciggy", 			  	  		["label"] = "Thuốc lá", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "cigarette.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Thuốc lá..."},
	["markedbills"] 				 = {["name"] = "markedbills", 			  	  	["label"] = "Hóa đơn bẩn", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "markedbills.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een tas đánh dấu hóa đơn"},
	["gold-rolex"] 				 	 = {["name"] = "gold-rolex", 			  	  	["label"] = "Rolex vàng", 			["weight"] = 1500, 		["type"] = "item", 		["image"] = "gold-rolex.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Đây có phải là rolex thực sự hay không?"},
	["gold-necklace"] 				 = {["name"] = "gold-necklace", 			  	["label"] = "Vòng cổ dây xích vàng", 			["weight"] = 1500, 		["type"] = "item", 		["image"] = "gold-necklace.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Đây là một sợi dây chuyền vàng đẹp làm sao."},
	["gold-bar"] 			 	 	 = {["name"] = "gold-bar", 			  			["label"] = "Thỏi vàng", 				["weight"] = 7000, 	    ["type"] = "item", 		["image"] = "gold-bar.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một thanh vàng nặng."},
	["diamond-ring"] 			 	 = {["name"] = "diamond-ring", 			  		["label"] = "Kim cương", 			["weight"] = 1250, 	    ["type"] = "item", 		["image"] = "diamond-ring.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Trông giống như một chiếc nhẫn cưới hoặc một cái gì đó."},
	["diamond-blue"] 			 	 = {["name"] = "diamond-blue", 			  		["label"] = "Kim cương xanh", 			["weight"] = 3500, 	    ["type"] = "item", 		["image"] = "diamond-blue.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một viên kim cương xanh? Có thật không?"},
	["diamond-red"] 			 	 = {["name"] = "diamond-red", 			  		["label"] = "Kim cương đỏ", 			["weight"] = 3500, 	    ["type"] = "item", 		["image"] = "diamond-red.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Và sau đó cũng có một cái màu đỏ??"},
	["note"] 			 	 		 = {["name"] = "note", 			  				["label"] = "Ghi chú", 				["weight"] = 500, 	    ["type"] = "item", 		["image"] = "note.png", 				["unique"] = true,   	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một mảnh giấy trống?"},
	["printerdocument"] 			 = {["name"] = "printerdocument", 			  	["label"] = "Tài liệu", 				["weight"] = 500, 	    ["type"] = "item", 		["image"] = "note.png", 				["unique"] = true,   	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một tài liệu hoặc máy in"},
	["duffel-bag"] 					 = {["name"] = "duffel-bag", 			 	  	["label"] = "Túi vải ", 			    ["weight"] = 7500, 	["type"] = "item", 		["image"] = "duffel-bag.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Gieo cái này thật nặng."},
	["stolen-tv"] 			 		 = {["name"] = "stolen-tv", 			  		["label"] = "TV bị đánh cấp", 			    ["weight"] = 10000, 	["type"] = "item", 		["image"] = "stolen-tv.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bạn có bị thoát vị từ việc này không?"},
	["stolen-pc"] 			 		 = {["name"] = "stolen-pc", 			  		["label"] = "Máy tính bị đánh cấp", 	   	["weight"] = 5000, 	["type"] = "item", 		["image"] = "stolen-pc.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Tôi có thể vài điều này được không?"},
	["stolen-micro"] 			 	 = {["name"] = "stolen-micro", 			  		["label"] = "Lò vi sóng bị đánh cấp", 	    ["weight"] = 2000, 		["type"] = "item", 		["image"] = "stolen-micro.png", 		["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bỏng ngô và nó rất ngon."},
	["tunerlaptop"] 				 = {["name"] = "tunerlaptop", 			 	 	["label"] = "Điều chỉnh chip", 				["weight"] = 500,  	    ["type"] = "item", 		["image"] = "tunerlaptop.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Máy tính xách tay"},
	["recyclablematerial"] 			 = {["name"] = "recyclablematerial", 			["label"] = "Tái chế vật liệu", 			["weight"] = 100, 		["type"] = "item", 		["image"] = "trashbag.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Vật liệu có thể tái chế"},	
	["plastic"] 					 = {["name"] = "plastic", 			  	  	  	["label"] = "Nhựa", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "plastic.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Nhựa để chế tạo đồ vật"},
	["metalscrap"] 					 = {["name"] = "metalscrap", 			  	  	["label"] = "Sắt vụn", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "metalscrap.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Bạn có thể tạo ra một cái gì đó chắc chắn với cái này."},
	["copper"] 					 	 = {["name"] = "copper", 			  	  		["label"] = "Đồng", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "copper.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Vật liệu chế tạo"},
	["aluminum"] 					 = {["name"] = "aluminum", 			  	  		["label"] = "Nhôm", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "aluminum.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Vật liệu chế tạo"},
	["iron"] 				 	     = {["name"] = "iron", 			  				["label"] = "Sắt", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "ironplate.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Vật liệu chế tạo"},
	["steel"] 				 	 	 = {["name"] = "steel", 			  			["label"] = "Thép", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "steel.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Vật liệu chế tạo"},
	["rubber"] 				 	 	 = {["name"] = "rubber", 			  			["label"] = "Cao su", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "rubber.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Miếng cao su tiện dụng mà bạn có thể sử dụng."},
	["glass"] 				 	 	 = {["name"] = "glass", 			  			["label"] = "Thủy tinh", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "glassplate.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Nó khả mong manh coi chừng."},
	["diamond"] 				 	 = {["name"] = "diamond", 			  			["label"] = "Kim cương", 					["weight"] = 2000, 		["type"] = "item", 		["image"] = "diamond.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Khá đẹp."},
	["emerald"] 				 	 = {["name"] = "emerald", 			  			["label"] = "Ngọc lục bảo", 					["weight"] = 2000, 		["type"] = "item", 		["image"] = "emerald.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Khá đẹp."},
	["parachute"] 				 	 = {["name"] = "parachute", 			  		["label"] = "Dù bay", 				["weight"] = 2000, 		["type"] = "item", 		["image"] = "parachute.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Cái dù bay"},
	
	["rifle-body"] 				 	 = {["name"] = "rifle-body", 			  		["label"] = "Thân súng trường", 				["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-body.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A weapon part or something?"},
	["rifle-clip"] 				 	 = {["name"] = "rifle-clip", 			  		["label"] = "Kẹp súng trường", 				["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-clip.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A weapon part or something?"},
	["rifle-stock"] 				 = {["name"] = "rifle-stock", 			  		["label"] = "Rifle Stock", 				["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-stock.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A weapon part or something?"},
	["rifle-trigger"] 				 = {["name"] = "rifle-trigger", 			  	["label"] = "Rifle Trigger", 			["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-trigger.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A weapon part or something?"},

	["ironoxide"] 				 	 = {["name"] = "ironoxide", 			  		["label"] = "Sắt ôxít", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "ironoxide.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = {accept = {"aluminumoxide"}, reward = "thermite", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Mixing Powders", ["timeOut"] = 10000}},   ["description"] = "Một ít bột để trộn với."},
	["aluminumoxide"] 				 = {["name"] = "aluminumoxide", 			  	["label"] = "Nhôm ôxít", 			["weight"] = 100, 		["type"] = "item", 		["image"] = "aluminumoxide.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = {accept = {"ironoxide"}, reward = "thermite", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Mixing Powders", ["timeOut"] = 10000}},   ["description"] = "Một ít bột để trộn với."},
	["thermite"] 			 	 	 = {["name"] = "thermite", 			  			["label"] = "Thermite", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "thermite.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Wow cái này rất dễ cháy.."},

	["coin"] 						 = {["name"] = "coin", 						  	["label"] = "Đồng tiền", 	    			["weight"] = 100, 		["type"] = "item", 		["image"] = "coin.png", 		        ["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đồng tiền may mắn?"},
	["dice"] 						 = {["name"] = "dice", 			  				["label"] = "xúc xắc", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "dice.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Bộ xúc xắc."},
	["boombox"] 				 	 = {["name"] = "boombox", 			  			["label"] = "Boombox", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "boombox.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Chơi một số bài nhạc."},
	["binoculars"] 			 	 	 = {["name"] = "binoculars", 					["label"] = "Ống nhòm", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "binoculars.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil, ["description"] = "Xem một cảnh đẹp.."},

	["bandage"] 					 = {["name"] = "bandage", 			  			["label"] = "Bandage", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "bandage.png", 		        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Băng bó vết thương nhỏ của bạn."},
	["painkillers"] 				 = {["name"] = "painkillers", 			  		["label"] = "Thuốc giảm đau", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "painkillers.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đây là loại thuốc khá nặng."},
	["coke-bag"] 			     	 = {["name"] = "coke-bag", 			  			["label"] = "Thùng rác", 			["weight"] = 250, 		["type"] = "item", 		["image"] = "coke-bag.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Grams of coke."},
	["lsd-strip"] 			     	 = {["name"] = "lsd-strip", 			  		["label"] = "Dải hoặc LSD", 			["weight"] = 30, 		["type"] = "item", 		["image"] = "postzegel.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lekker likken."},
	["joint"] 						 = {["name"] = "joint", 			  	    	["label"] = "1G Joint", 				["weight"] = 30, 		["type"] = "item", 		["image"] = "joint.png", 		        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een joint."},
	["superjoint"] 					 = {["name"] = "superjoint", 			  	    ["label"] = "3G Joint", 				["weight"] = 30, 		["type"] = "item", 		["image"] = "joint.png", 		        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een super duper joint."},
	["health-pack"] 				 = {["name"] = "health-pack", 			    	["label"] = "MED Kit", 				["weight"] = 6000,   	["type"] = "item", 		["image"] = "health-pack.png", 			["unique"] = true, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Có vẻ bạn có thể giúp ai đó về việc này.."},
	["jerrycan"] 				 	 = {["name"] = "jerrycan", 			    		["label"] = "Can xăng", 				["weight"] = 6000,   	["type"] = "item", 		["image"] = "jerrycan.png", 			["unique"] = true, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Jerrycan met benzine"},

	["key-a"] 				 	     = {["name"] = "key-a", 			    		["label"] = "Sleutel A", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "key-a.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Key A?"},
	["key-b"] 				 		 = {["name"] = "key-b", 			    		["label"] = "Sleutel B", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "key-b.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Key B?"},
	["key-c"] 				 		 = {["name"] = "key-c", 			    		["label"] = "Sleutel C", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "key-c.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Key C?"},
	
	["wet-tak"] 					 = {["name"] = "wet-tak", 			  	    	["label"] = "Rau muống xanh", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "wet-tak.png", 		        ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một ngành luật?!?"},
	["wet-bud"] 					 = {["name"] = "wet-bud", 			  	    	["label"] = "Lỗi ẩm ướt", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "wet-bud.png", 		        ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Tất cả những thứ ẩm ướt này là gì?"},
	["plastic-bag"] 				 = {["name"] = "plastic-bag", 			  	    ["label"] = "Túi nhựa", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "plastic-bag.png", 		    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một túi nhựa để đặt một cái gì đó vào ?"},
	["weed_white-widow"] 			 = {["name"] = "weed_white-widow", 			 	["label"] = "White Widow 2g", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = {accept = {"rolling-paper"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Bezig met joint draaien", ["timeOut"] = 3000,}},   ["description"] = "Một túi có chất màu xanh lá cây."},
	["weed_skunk"] 				  	 = {["name"] = "weed_skunk", 			 		["label"] = "Chồn hôi 2g", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = {accept = {"rolling-paper"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Bezig met joint draaien", ["timeOut"] = 3000,}},   ["description"] = "Một túi có chất màu xanh lá cây."},
	["weed_purple-haze"] 			 = {["name"] = "weed_purple-haze", 			 	["label"] = "Màu tím khói 2g", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = {accept = {"rolling-paper"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Bezig met joint draaien", ["timeOut"] = 3000,}},   ["description"] = "Một túi có chất màu xanh lá cây."},
	["weed_og-kush"] 				 = {["name"] = "weed_og-kush", 			 		["label"] = "OGKush 2g", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = {accept = {"rolling-paper"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Bezig met joint draaien", ["timeOut"] = 3000,}},   ["description"] = "Một túi có chất màu xanh lá cây."},
	["weed_amnesia"] 				 = {["name"] = "weed_amnesia", 			 		["label"] = "Amnesia 2g", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = {accept = {"rolling-paper"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Bezig met joint draaien", ["timeOut"] = 6000,}},   ["description"] = "Một túi có chất màu xanh lá cây."},
	["weed_ak47"] 				     = {["name"] = "weed_ak47", 			 		["label"] = "AK47 2g", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = {accept = {"rolling-paper"}, reward = "superjoint", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Bezig met joint draaien", ["timeOut"] = 5000,}},   ["description"] = "Một túi có chất màu xanh lá cây."},
	["weed_nutrition"] 				 = {["name"] = "weed_nutrition", 			 	["label"] = "Dinh dưỡng", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "nutrition.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Chất lỏng cho nhà máy blaster tổng thể xanh"},
	["rolling-paper"] 			 	 = {["name"] = "rolling-paper", 			  	["label"] = "Giấy cuộn", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "rolling-paper.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = {accept = {"wet-bud"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "anim@amb@business@weed@weed_inspecting_high_dry@", ["lib"] = "weed_inspecting_high_base_inspector", ["text"] = "Bezig met joint draaien", ["timeOut"] = 5000,}},   ["description"] = "Shaggies rolling Papers."},
	["oxy"] 			 	 		 = {["name"] = "oxy", 			  				["label"] = "Oxycodon", 				["weight"] = 150, 		["type"] = "item", 		["image"] = "oxy.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Viên thuốc lớn"},
	["diving_gear"] 			 	 = {["name"] = "diving_gear", 			  		["label"] = "Bình lặn", 				["weight"] = 150, 		["type"] = "item", 		["image"] = "diving_gear.png", 		["unique"] = true, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Bình lặn."},

	["white-widow-seed"] 		 	= {["name"] = "white-widow-seed", 				["label"] = "Hạt giống góa phụ trắng", 		["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een plantzaadje van White Widow"},
	["skunk-seed"] 				 	= {["name"] = "skunk-seed", 			    	["label"] = "Hạt giống chồn hôi", 				["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van Skunk"},
	["purple-haze-seed"] 		 	= {["name"] = "purple-haze-seed", 				["label"] = "Hạt giống màu tím", 		["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van Purple Haze"},
	["og-kush-seed"] 			 	= {["name"] = "og-kush-seed", 					["label"] = "OGKush Zaad", 				["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van OG Kush"},
	["amnesia-seed"] 			 	= {["name"] = "amnesia-seed", 					["label"] = "Amnesia Zaad", 			["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van Amnesia"},
	["ak47-seed"] 				 	= {["name"] = "ak47-seed", 			    		["label"] = "AK47 Zaad", 				["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van AK47"},
	
	-- Food --
	["phone"] 						 = {["name"] = "phone", 			 	  	  	["label"] = "Điện thoại", 				["weight"] = 750, 		["type"] = "item", 		["image"] = "phone.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một phần của công nghệ"},
	["sandwich"] 					 = {["name"] = "sandwich", 			 	  	  	["label"] = "Bánh mì sandwich", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "bread.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một chiếc bánh sandwich với lớp trên bề mặt."},
	["water"] 						 = {["name"] = "water", 			 	  	  	["label"] = "Nước", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "water.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Chúc bạn có bữa uống nước ngon miệng."},
	["slushy"] 						 = {["name"] = "slushy", 			 	  	  	["label"] = "Slushi", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "slushy.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Coi chừng bị não đóng băng."},
	["ecola"] 						 = {["name"] = "ecola", 			 	  	  	["label"] = "Cola", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "ecola.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lon coke."},
	["sprunk"] 						 = {["name"] = "sprunk", 			 	  	  	["label"] = "Sprunk", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "sprunk.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lon sprunk?"},
	["chocolade"] 					 = {["name"] = "chocolade", 			 	  	["label"] = "Socola", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "chocolade.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một thanh socola."},
	["donut"] 						 = {["name"] = "donut", 			 	  	  	["label"] = "Bánh vòng", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "donut.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bánh rán ngon."},
	["carapils"] 					 = {["name"] = "carapils", 			 	  	  	["label"] = "Bia", 					["weight"] = 25, 		["type"] = "item", 		["image"] = "carapils.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Phong cách ăn uống của Den."},
	["pizza"] 						 = {["name"] = "pizza", 			 	  	  	["label"] = "Pizza", 					["weight"] = 25, 		["type"] = "item", 		["image"] = "pizza.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Pizza"},

	["fishingbait"] 	 		     = {["name"] = "fishingbait", 	  	            ["label"] = "Mồi câu cá", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "fishingbait.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Mồi câu cá."},
	["fishrod"] 					 = {["name"] = "fishrod", 			 	  	  	["label"] = "Cần câu", 		    	["weight"] = 500, 		["type"] = "item", 		["image"] = "vishengel.png", 			["unique"] = true, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Cứ tận hưởng câu cá.."},
	["fish-1"] 						 = {["name"] = "fish-1", 			 	  	  	["label"] = "Cá Vàng", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "fish-1.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đây gần như là một con cá vàng.."},
	["fish-2"] 						 = {["name"] = "fish-2", 			 	  	  	["label"] = "Cá Rô", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "fish-2.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hãy coi chừng tôi có thể bị châm chích.."},
	["fish-3"] 						 = {["name"] = "fish-3", 			 	  	  	["label"] = "Cá Balem", 				["weight"] = 2000, 		["type"] = "item", 		["image"] = "fish-3.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đúng là một con cá khổng lồ."},
	["fish-shark"] 						 = {["name"] = "fish-shark", 			 	["label"] = "Cá mập con", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "fish-shark.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đây là một co cá mập con dễ thương"},
	["plasticbag"] 					 = {["name"] = "plasticbag", 			 	 	["label"] = "Túi nhựa", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "plasticbag.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dù sao thì hãy đeo túi qua đầu và đi??"},
	["shoe"] 						 = {["name"] = "shoe", 			 	     	  	["label"] = "Giày cũ", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "shoe.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Mô hình thể thao."},
	["trojan_usb"] 				 	 = {["name"] = "trojan_usb", 			  	  	["label"] = "Trojan USB", 				["weight"] = 5000, 		["type"] = "item", 		["image"] = "usbplugin.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Phần mềm tiện dụng để tắt một số hệ thống nhất định."},
	["id-card"] 					 = {["name"] = "id-card", 			 	  	  	["label"] = "IDCard", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "license-id.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một thẻ chứa tất cả dữ liệu của bạn."},
	["drive-card"] 			    	 = {["name"] = "drive-card", 		    	  	["label"] = "Bằng lái xe", 			["weight"] = 100, 		["type"] = "item", 		["image"] = "license-drive.png", 		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bằng chứng cho thấy bạn có thể lái xe."},
	["lawyerpass"] 					 = {["name"] = "lawyerpass", 			 	  	["label"] = "Thẻ luật sư ", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "lawyerpass.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Chỉ dành cho luật sư để làm bằng chứng rằng họ có thể đại diện cho một nghi phạm."},
	["bag"] 						 = {["name"] = "bag", 			 	  			["label"] = "Cái túi", 		    			["weight"] = 0, 		["type"] = "item", 		["image"] = "bag.png", 		    	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Điều gì có trong đó?"},
	["kerstkado"] 					 = {["name"] = "kerstkado", 			 	  	["label"] = "Quà Giáng Sinh", 		    ["weight"] = 0, 		["type"] = "item", 		["image"] = "kadoo.png", 		    	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Ho Ho Ho? Điều gì có thể xảy ra khi ở trong đó?"},
	["notenkraker"] 				 = {["name"] = "notenkraker", 			 	  	["label"] = "Kẹp hạt dẻ", 		   		["weight"] = 3500, 		["type"] = "item", 		["image"] = "notenkraker.png", 		    ["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Mục sự kiện Giáng sinh 2020 đặc biệt."},
	["scissor"] 				 	 = {["name"] = "scissor", 			 			["label"] = "Cây kéo", 					["weight"] = 250, 		["type"] = "item", 		["image"] = "scissor.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Cây kéo."},
	["blinddoek"] 				 	 = {["name"] = "blinddoek", 			 		["label"] = "Bịt mắt", 				["weight"] = 250, 		["type"] = "item", 		["image"] = "blinddoek.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bịt mắt hoặc túi trên đầu."},

   -- // Pizzaria \\ --
   ["pizzameat"] 		 			 	 = {["name"] = "pizzameat",       		    ["label"] = "Pizza thịt",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizzameat.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,	  ["description"] = "Pizza thịt"},
   ["groenten"] 						 = {["name"] = "groenten", 			  	  	["label"] = "Pizza Rau", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "groenten.png", 	    	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Rau sạch"},
   ["pizza-vooraad"] 	 			 	 = {["name"] = "pizza-vooraad",       		["label"] = "Hộp kho",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizavooraad.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,    ["expire"] = 5,	  ["description"] = "Hộp kho cửa hàng pizza"},
   ["pizza-doos"] 	 			 	 	 = {["name"] = "pizza-doos",       			["label"] = "Hộp bánh pizza",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizzadoos.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,	  ["description"] = "Giao bánh pizza ngon này đi"},
	
   --KLEDING MAKER--
   ["katoen"] 						 = {["name"] = "katoen", 			 	  	  	["label"] = "Bông", 					["weight"] = 1500, 		["type"] = "item", 		["image"] = "katoen.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    ["combinable"] = nil,   ["description"] = "Bông"},
   ["stofrol"] 						 = {["name"] = "stofrol", 			 	  	  	["label"] = "Cuộn vải", 					["weight"] = 6400, 		["type"] = "item", 		["image"] = "stofrol.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    ["combinable"] = nil,   ["description"] = "Cuộn vải"},
   ["tshirt"] 					 = {["name"] = "tshirt", 			 	  	["label"] = "Áo thun", 				["weight"] = 6400, 		["type"] = "item", 		["image"] = "tshirt.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "T shirt"},
   ["zeis"] 						 = {["name"] = "zeis", 			 	  	  		["label"] = "Lưỡi hái", 					["weight"] = 150, 		["type"] = "item", 		["image"] = "zeis.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,    ["description"] = "Mục để vào trang trại bông"},


	-- Hout
	["wood_cut"] 		 		 	= {["name"] = "wood_cut",           			["label"] = "Gỗ chưa xử lý",	 				["weight"] = 1000,  	["type"] = "item", 		["image"] = "wood_cut.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Hout"},
	["wood_proc"] 		 		 	= {["name"] = "wood_proc",           			["label"] = "Gỗ đã qua xử lý",	 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "wood_proc.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Hout"},

	-- Drugs --
	["wetbud"] 						 = {["name"] = "wetbud", 			 	  	  	["label"] = "Wetbud", 					["weight"] = 240, 		["type"] = "item", 		["image"] = "wetbud.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Wetbud"},
	["drybud"] 						 = {["name"] = "drybud", 			 	  	  	["label"] = "Drybud", 					["weight"] = 140, 		["type"] = "item", 		["image"] = "wetbud.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Drybud"},
	["cokeleafs"] 					 = {["name"] = "cokeleafs", 			 	  	["label"] = "Coke Leafs", 				["weight"] = 150, 		["type"] = "item", 		["image"] = "cokeleafs.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Cokeleafs"},
	["coke"] 						 = {["name"] = "coke", 			 	  	  		["label"] = "Coke", 					["weight"] = 150, 		["type"] = "item", 		["image"] = "coke.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,    ["description"] = "Một viên thuốc đáng ngờ, hãy thử hoặc không?"},
	-- Taco job --
	["taco"] 		 			 	 = {["name"] = "taco",       		    		["label"] = "Taco",	 					["weight"] = 300, 		["type"] = "item", 		["image"] = "taco.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Some big taco brother"},
	["meat"] 		 			 	 = {["name"] = "meat",       		    		["label"] = "Meat",	 					["weight"] = 100, 		["type"] = "item", 		["image"] = "meat.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,	  ["description"] = "Some big taco brother"},
	["meath"] 						 = {["name"] = "meath", 			  	  		["label"] = "Vension", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "meath.png", 	    	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Deer Venison"},
	["leather"] 					 = {["name"] = "leather", 			  			["label"] = "Da thú", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "leather.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Deer Leather"},	["lettuce"] 	 			 	 = {["name"] = "lettuce",       			    ["label"] = "Lettuce",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "lettuce.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,  ["description"] = "Some big taco brother"},
	["taco-box"] 	 			 	 = {["name"] = "taco-box",       			    ["label"] = "Taco Box",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "taco-box.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,    ["expire"] = 5,	  ["description"] = "Some big taco brother"},
	["taco-bag"] 	 			 	 = {["name"] = "taco-bag",       			    ["label"] = "Taco Bag",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "taco-bag.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,	  ["description"] = "Some big taco brother"},
	-- Burger Shot
	["burger-bleeder"] 				 = {["name"] = "burger-bleeder", 			 	["label"] = "Người chảy máu", 					["weight"] = 250, 		["type"] = "item", 		["image"] = "burger-bleeder.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Một trong những điều tốt nhất nó sẽ giết bạn?"},
	["burger-moneyshot"] 			 = {["name"] = "burger-moneyshot", 			 	["label"] = "Bắn tiền", 				["weight"] = 300, 		["type"] = "item", 		["image"] = "burger-moneyshot.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Tiền?"},
	["burger-torpedo"] 				 = {["name"] = "burger-torpedo", 			 	["label"] = "Torpedo", 					["weight"] = 310, 		["type"] = "item", 		["image"] = "burger-torpedo.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Cái này không phải của tàu ngầm đúng không?"},
	["burger-heartstopper"] 		 = {["name"] = "burger-heartstopper", 			["label"] = "Trái tim ngưng đập", 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "burger-heartstopper.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Nó sẽ khiến trái tim bạn ngưng đập!"},
	["burger-softdrink"] 			 = {["name"] = "burger-softdrink", 				["label"] = "Cup Soda", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-softdrink.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Straight zippin."},
	["burger-coffee"] 			     = {["name"] = "burger-coffee", 				["label"] = "Cup Coffee", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-coffee.png", 	    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Cà phê ngon nhất trong thị trấn"},
	["burger-fries"] 				 = {["name"] = "burger-fries", 			 	  	["label"] = "Khoai tây chiên", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-fries.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Fries or pommes? #ComeAtMe"},
	
	["burger-bun"] 				 	 = {["name"] = "burger-bun", 			 	  	["label"] = "Bánh mì kẹp thịt", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-bun.png", 		    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bánh mì kẹp thịt."},
	["burger-meat"] 				 = {["name"] = "burger-meat", 			 	  	["label"] = "Bánh mì burger", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-meat.png", 		    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Burger meat."},
	["burger-lettuce"] 				 = {["name"] = "burger-lettuce", 			 	["label"] = "Bánh mì sla", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-lettuce.png", 	    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Trông giống như chất độc."},
	
	["burger-raw"] 				 	 = {["name"] = "burger-raw", 			 		["label"] = "Thịt sống", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-raw.png", 	        ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bạn không thể tin tưởng ở tôi"},
	["burger-potato"] 				 = {["name"] = "burger-potato", 			 	["label"] = "Khoai tây chiên", 		["weight"] = 1500, 		["type"] = "item", 		["image"] = "burger-potato.png", 	    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hành phi"},
	
	["burger-ticket"] 				 = {["name"] = "burger-ticket", 			 	["label"] = "Order Bon", 	     	["weight"] = 150, 		["type"] = "item", 		["image"] = "burger-ticket.png", 	    ["unique"] = true,   	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đây là một đơn đặt hàng cần được giao càng sớm càng tốt!"},
	["burger-box"] 				 	 = {["name"] = "burger-box", 			 	    ["label"] = "Hộp bánh mì kẹp thịt", 	     	    ["weight"] = 1000, 		["type"] = "item", 		["image"] = "burger-box.png", 	        ["unique"] = true,   	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đây chắc chắn là một số thứ tốt trong đó"},
	-- butcher job --

	["alivecow"] 				 	 = {["name"] = "alivecow", 			 	 	    ["label"] = "Bò còn sống", 				["weight"] = 1300, 		["type"] = "item", 		["image"] = "alivecow.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Một con bò sữa trông đáng yêu, làm ơn đừng giết nó"},
	["alivepig"] 		     		 = {["name"] = "alivepig", 						["label"] = "Heo còn sống", 				["weight"] = 1300, 		["type"] = "item", 		["image"] = "alivepig.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Một con heo bụng bự đang sống ấm no, làm ơn đừng giết nó"},
	["slaughteredbeef"] 			 = {["name"] = "slaughteredbeef", 			 	["label"] = "Thịt bò đã giết mổ", 		["weight"] = 1500, 		["type"] = "item", 		["image"] = "slaughteredbeef.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Nếu bạn đã giết con bò yêu đấy, tôi thù bạn"},
	["slaughteredpig"] 				 = {["name"] = "slaughteredpig", 			 	["label"] = "Lợn giết mổ", 			["weight"] = 1500, 		["type"] = "item", 		["image"] = "slaughteredpig.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Bạn giết con heo ủn ỉn đấy thì bạn sẽ phải trả giá"},
	["packedbeef"] 		     		 = {["name"] = "packedbeef", 					["label"] = "Thịt bò đóng gói", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "packedchicken.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Vì vậy, bạn dự định bán con bò này sau khi bạn đã làm gì ? zZzZz"},
	["packedpig"] 					 = {["name"] = "packedpig", 			 		["label"] = "Thịt heo đóng gói", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "packedbeef.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Vì vậy, bạn dự định bán con heo này sau khi bạn đã làm gì ? zZzZz"},
	["coke-bag"] 			     	= {["name"] = "coke-bag", 			  			["label"] = "Túi cocain", 			["weight"] = 250, 		["type"] = "item", 		["image"] = "coke-bag.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Gam than cốc"},
	["packed-coke-brick"] 			= {["name"] = "packed-coke-brick", 			    ["label"] = "Gói cocain", 		["weight"] = 7500, 		["type"] = "item", 		["image"] = "packaged-brick.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Bột trắng đóng gói?"},
	["pure-coke-brick"] 			= {["name"] = "pure-coke-brick", 			    ["label"] = "Túi cocain nguyên chất", 		["weight"] = 4500, 		["type"] = "item", 		["image"] = "pure-coke-brick.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Đây là diện mạo của than cốc khi mới được vận chuyển đến"},
	["coke-brick"] 					= {["name"] = "coke-brick", 			   		["label"] = "Cocaine Brick", 			["weight"] = 1550, 		["type"] = "item", 		["image"] = "coke-brick.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Cocain phê thật đấy"},
	["coke-powder"] 				= {["name"] = "coke-powder", 			   		["label"] = "Bột cocain", 			["weight"] = 250, 		["type"] = "item", 		["image"] = "coke-powder.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Cái gì đây cho những thứ tốt?"},
	
	["meth-bag"] 					= {["name"] = "meth-bag", 			   			["label"] = "Bag Meth", 				["weight"] = 250, 		["type"] = "item", 		["image"] = "meth-bag.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Đường xanh ?"},
	["meth-powder"] 				= {["name"] = "meth-powder", 			   		["label"] = "Bột Meth", 				["weight"] = 250, 		["type"] = "item", 		["image"] = "meth-powder.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Tony chết tiệt montana!"},
	["meth-ingredient-1"] 			= {["name"] = "meth-ingredient-1", 			   	["label"] = "Meth Ingredient", 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "meth-ingredient-1.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Có vẻ như một thành phần cho meth"},
	["meth-ingredient-2"] 			= {["name"] = "meth-ingredient-2", 			   	["label"] = "Meth Ingredient", 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "meth-ingredient-2.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Có vẻ như một thành phần cho meth"},
	["knife"] 				 		= {["name"] = "knife", 			    			["label"] = "Dao", 						["weight"] = 1250, 		["type"] = "item", 		["image"] = "knife.png", 				["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = {accept = {"pure-coke-brick"}, reward = "coke-brick", RemoveToItem = false, RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Brick versnijden..", ["timeOut"] = 7500,}}, ["description"] = "Messie sắc nét mặc dù."},

	["lotto-card"] 					 = {["name"] = "lotto-card", 			 	  	["label"] = "Thẻ xổ số", 					["weight"] = 100,		["type"] = "item", 		["image"] = "lotto-card.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hôm nay là một ngày may mắn của bạn sao?"},
	["used-card"] 					 = {["name"] = "used-card", 			 	  	["label"] = "Sử dụng hình dán", 		    ["weight"] = 75,		["type"] = "item", 		["image"] = "used-card.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Cái này đã bị xước rồi.."},
	["burner-phone"] 			 	= {["name"] = "burner-phone", 			   		["label"] = "Điện thoại ghi", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "old-phone.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Một chiếc điện thoại cũ dude poah."},
	["money-paper"] 				= {["name"] = "money-paper", 			   		["label"] = "Giấy tiền", 				["weight"] = 4500, 		["type"] = "item", 		["image"] = "money-paper.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Gieo một chồng giấy nặng như búa tạ."},
	["money-inkt"] 					= {["name"] = "money-inkt", 			   		["label"] = "Mực in tiền", 				["weight"] = 5400, 		["type"] = "item", 		["image"] = "money-inkt.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Giá như tôi không lấy cái này trên quần áo của mình."},
	["money-roll"] 					= {["name"] = "money-roll", 			   		["label"] = "Tiền bẩn", 			["weight"] = 25, 		["type"] = "item", 		["image"] = "money-roll.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Những cuộn tiền một lần nữa dude.."},
	["knife-part-1"] 				 = {["name"] = "knife-part-1", 			 	  	["label"] = "Phần dao", 			["weight"] = 450, 		["type"] = "item", 		["image"] = "knife-part-1.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"knife-part-2"}, reward = "weapon_knife", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combining..", ["timeOut"] = 7500,}},   ["description"] = "Trông giống như một bộ phận nào đó của một con dao"},
	["knife-part-2"] 				 = {["name"] = "knife-part-2", 			 	  	["label"] = "Phần dao", 			["weight"] = 450, 		["type"] = "item", 		["image"] = "knife-part-2.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"knife-part-1"}, reward = "weapon_knife", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combining..", ["timeOut"] = 7500,}},   ["description"] = "Trông giống như một bộ phận nào đó của một con dao"},
	["switch-part-1"] 				 = {["name"] = "switch-part-1", 			 	["label"] = "Switchblade Part", 	["weight"] = 450, 		["type"] = "item", 		["image"] = "switch-part-1.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"switch-part-2"}, reward = "weapon_switchblade", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combining..", ["timeOut"] = 7500,}},   ["description"] = "Trông giống như một bộ phận nào đó của một con dao"},
	["switch-part-2"] 				 = {["name"] = "switch-part-2", 			 	["label"] = "Switchblade Part", 	["weight"] = 450, 		["type"] = "item", 		["image"] = "switch-part-2.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"switch-part-1"}, reward = "weapon_switchblade", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combining..", ["timeOut"] = 7500,}},   ["description"] = "Trông giống như một bộ phận nào đó của một con dao"},

	["snspistol_part_1"] 			 = {["name"] = "snspistol_part_1", 				["label"] = "SNS Thùng", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "snspistol_part_1.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_part_3"}, reward = "snspistol_stage_1", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}},   ["description"] = "Loop van een SNS Pistol"},
	["snspistol_part_2"] 			 = {["name"] = "snspistol_part_2", 				["label"] = "SNS Trigger", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "snspistol_part_2.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_stage_1"}, reward = "weapon_snspistol_mk2", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}},   ["description"] = "Trigger van een SNS Pistol"},
	["snspistol_part_3"] 			 = {["name"] = "snspistol_part_3", 				["label"] = "SNS Clip", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "snspistol_part_3.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_part_1"}, reward = "snspistol_stage_1", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}},   ["description"] = "Clip van een SNS Pistol"},
	["snspistol_stage_1"] 			 = {["name"] = "snspistol_stage_1", 			["label"] = "SNS Body", 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "snspistol_stage_1.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_part_2"}, reward = "weapon_snspistol_mk2", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}}, ["description"] = "SNS w/ Loop & Clip"},
	-- Apple Store
	["laptop"] 				 		 = {["name"] = "laptop", 			 	  		["label"] = "Laptop", 					["weight"] = 450, 		["type"] = "item", 		["image"] = "laptop.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Máy tính xách tay i7 đẹp đấy!"},
	["tablet"] 				 		 = {["name"] = "tablet", 			 			["label"] = "Tablet", 					["weight"] = 450, 		["type"] = "item", 		["image"] = "tablet.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Máy tính bảng đẹp nè!"},

	-- Store
	["ciggy"] 						 = {["name"] = "ciggy", 			  	  		["label"] = "Thuốc lá", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "cigarette.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Thuốc lá..."},
	-- Coraallll
	["dendrogyra_coral"] 			 = {["name"] = "dendrogyra_coral", 			  	["label"] = "Dendrogyra", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "dendrogyra_coral.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "San hô"},
	["antipatharia_coral"] 			 = {["name"] = "antipatharia_coral", 			["label"] = "Antipatharia", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "antipatharia_coral.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "San hô"},
	-- Item Su kien
	["event-ticket"] 					 = {["name"] = "event-ticket", 			 	  	["label"] = "Vé tham dự", 					["weight"] = 100,		["type"] = "item", 		["image"] = "event-ticket.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Vé tham dự sự kiện ca nhạc?"},
	-- farming
	["corn_kernel"] 		        = {["name"] = "corn_kernel", 			    ["label"] = "Bắp ngô", 	        		["weight"] = 1000, 		["type"] = "item", 		["image"] = "corn_kernel.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Quả ngô"},
	["corn_pack"] 		         	= {["name"] = "corn_pack", 			        ["label"] = "Ngô đóng gói", 	        ["weight"] = 5000, 		["type"] = "item", 		["image"] = "corn_pack.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Hộp ngô đóng gói"},
	["corn_silk"] 		         	= {["name"] = "corn_silk", 			        ["label"] = "Râu ngô", 	        		["weight"] = 100, 		["type"] = "item", 		["image"] = "corn_silk.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Râu ngô"},
	["orange"] 		                = {["name"] = "orange", 			        ["label"] = "Cam", 	                	["weight"] = 1000, 		["type"] = "item", 		["image"] = "orange.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Quả cam"},
	["fruit_pack"] 		            = {["name"] = "fruit_pack", 			    ["label"] = "Trái cây đóng hộp", 	    ["weight"] = 10000, 		["type"] = "item", 		["image"] = "fruit_pack.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Hộp đựng trái cây"},
	["milk"] 		                = {["name"] = "milk", 			            ["label"] = "Sữa", 	                	["weight"] = 2000, 		["type"] = "item", 		["image"] = "milk.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Sữa"},
	["milk_pack"] 		            = {["name"] = "milk_pack", 			        ["label"] = "Sữa đóng gói", 	        ["weight"] = 5000, 		["type"] = "item", 		["image"] = "milk_pack.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Sữa hộp"},
	["box"] 		                = {["name"] = "box", 			            ["label"] = "Hộp", 	                	["weight"] = 100, 		["type"] = "item", 		["image"] = "box.png", 	            	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Thùng"},
	["alivechicken"] 				= {["name"] = "alivechicken", 			 	 	["label"] = "Gà sống", 			["weight"] = 2000, 		["type"] = "item", 		["image"] = "Alivechicken.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Nó là một con gà tội nghiệp, làm ơn đừng giết nó"},
	["slaughteredchicken"] 		    = {["name"] = "slaughteredchicken", 			["label"] = "Gà thịt", 			["weight"] = 400, 		["type"] = "item", 		["image"] = "SlaughteredChicken.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Kể từ khi bạn giết con gà, tôi ghét bạn"},
	["packedchicken"] 				= {["name"] = "packedchicken", 			 	["label"] = "Gà đóng gói", 		["weight"] = 400, 		["type"] = "item", 		["image"] = "packedchicken.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = " Vì vậy, bạn dự định bán con gà này sau khi bạn đã làm gì?"},
	-- Scale
	["rc"] 		                 	= {["name"] = "rc", 			                ["label"] = "Xe rc", 	                	["weight"] = 100, 		["type"] = "item", 		["image"] = "rc.png", 	            ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "rc"},
	-- do xe
	["spray"] 				 		= {["name"] = "spray", 			 	["label"] = "Sơn xe", 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "son-xe.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil, ["expire"] = 14,   ["description"] = "Bình xịt sơn xe"},
	["water-bucket"] 		        = {["name"] = "water-bucket", 			            ["label"] = "Xô nước", 	                	["weight"] = 1000, 		["type"] = "item", 		["image"] = "water-bucket.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Xô nước"},
	["mine-pickaxe"] 		        = {["name"] = "mine-pickaxe", 			            ["label"] = "Cuốc đá", 	                	["weight"] = 1000, 		["type"] = "item", 		["image"] = "pickaxe.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Cuốc đào đá"},
	["wood-hachet"] 		        = {["name"] = "wood-hachet", 			            ["label"] = "Rìu chặt gỗ", 	                ["weight"] = 1000, 		["type"] = "item", 		["image"] = "axe.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Rìu chặt gỗ"},
	-- hai nho
	["grape"] 		                = {["name"] = "grape", 			        ["label"] = "Nho", 	                ["weight"] = 1000, 			["type"] = "item", 		["image"] = "grape.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Quả nho"},
	["grape_box"] 		            = {["name"] = "grape_box", 			    ["label"] = "Nho lên men", 	    	["weight"] = 10000, 		["type"] = "item", 		["image"] = "grape_box.png", 	        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Nho lên men"},
	-- tra da
	["thuoc-lao"] 					 = {["name"] = "thuoc-lao", 			 	  	  	["label"] = "Thuốc lào", 		    	["weight"] = 500, 		["type"] = "item", 		["image"] = "thuoc-lao.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Thuốc lào"},
	["orange-juice"] 				 = {["name"] = "orange-juice", 			 	  		["label"] = "Nước cam", 		    	["weight"] = 100, 		["type"] = "item", 		["image"] = "orange-juice.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Nước cam"},
	["ice-water"] 					 = {["name"] = "ice-water", 			 	  	  	["label"] = "Nước đá", 		    		["weight"] = 100, 		["type"] = "item", 		["image"] = "ice-water.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Nước đá"},
	["bottle-water"] 				 = {["name"] = "bottle-water", 			 	  	  	["label"] = "Nước suối đóng chai", 		["weight"] = 100, 		["type"] = "item", 		["image"] = "bottle-water.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Nước suối đóng chai"},
	["fruit-plate"] 				 = {["name"] = "fruit-plate", 			 	  		["label"] = "Đĩa trái cây", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "fruit-plate.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Đĩa trái cây"},
	["ice-scream"] 					 = {["name"] = "ice-scream", 			 	  	  	["label"] = "Kem", 		    			["weight"] = 100, 		["type"] = "item", 		["image"] = "ice-scream.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Kem"},

	["farm-register"] 					 = {["name"] = "farm-register", 			 	  	["label"] = "Phiếu đăng ký nghề", 		    		["weight"] = 100, 		["type"] = "item", 		["image"] = "farm-register.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Phiếu đăng ký nghề"},
	["farm-license"] 					 = {["name"] = "farm-license", 			 	  	  	["label"] = "Chứng chỉ nghề", 		    			["weight"] = 100, 		["type"] = "item", 		["image"] = "farm-license.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Chứng chỉ nghề farm"},
	-- mini farm

	["bingo"] 					 = {["name"] = "bingo", 			 	  	  	["label"] = "Bí ngô", 		    			["weight"] = 1000, 		["type"] = "item", 		["image"] = "bingo.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bí ngô"},
	["cachua"] 					 = {["name"] = "cachua", 			 	  	  	["label"] = "Cà chua", 		    			["weight"] = 1000, 		["type"] = "item", 		["image"] = "cachua.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Cà chua"},
	["bapcai"] 					 = {["name"] = "bapcai", 			 	  	  	["label"] = "Bắp cải", 		    			["weight"] = 1000, 		["type"] = "item", 		["image"] = "bapcai.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bắp cải"},

	["luami"] 					 	 = {["name"] = "luami", 			 	  	  	["label"] = "Lúa mì", 		    				["weight"] = 1000, 		["type"] = "item", 		["image"] = "luami.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lúa mì"},
	["hatluami"] 					 = {["name"] = "hatluami", 			 	  	  	["label"] = "Hạt lúa mì", 		    			["weight"] = 1000, 		["type"] = "item", 		["image"] = "hatluami.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Sản phẩm từ lúa mì"},
	["baoluami"] 					 = {["name"] = "baoluami", 			 	  	  	["label"] = "Bao lúa mì", 		    			["weight"] = 10000, 		["type"] = "item", 		["image"] = "baoluami.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bao lúa"},
	["liemcatlua"] 					 = {["name"] = "liemcatlua", 			 	  	["label"] = "Liềm cắt lúa", 		    		["weight"] = 1000, 		["type"] = "item", 		["image"] = "liemcatlua.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Liềm cắt lúa"},

	["botmi"] 					 	 = {["name"] = "botmi", 			 	  	  	["label"] = "Bột mì", 		    				["weight"] = 500, 		["type"] = "item", 		["image"] = "botmi.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bột mì"},
	
	["pizzaga"] 					 	 = {["name"] = "pizzaga", 			 	  	  	["label"] = "Pizza gà", 		    				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizzaga.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bánh Pizza"},
	["pizzasalad"] 					 	 = {["name"] = "pizzasalad", 			 	  	["label"] = "Pizza salad", 		    				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizzasalad.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bánh Pizza"},
	["pizzachay"] 					 	 = {["name"] = "pizzachay", 			 	  	["label"] = "Pizza chay", 		    				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizzachay.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bánh Pizza"},
	["pizzahaisan"] 					 = {["name"] = "pizzahaisan", 			 	  	["label"] = "Pizza hải sản", 		    				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizzahaisan.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bánh Pizza"},
	["pizzathapcam"] 					 = {["name"] = "pizzathapcam", 			 	  	["label"] = "Pizza thập cẩm", 		    				["weight"] = 100, 		["type"] = "item", 		["image"] = "pizzathapcam.png", 			["unique"] = false, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bánh Pizza"},
}
	
Shared.StarterItems = {
  ["phone"] = {amount = 1, item = "phone"},
--   ["id-card"] = {amount = 1, item = "id-card"},
  ["water"] = {amount = 5, item = "water"},
  ["sandwich"] = {amount = 5, item = "sandwich"},
  ["lockpick"] = {amount = 5, item = "lockpick"},
--   ["ciggy"] = {amount = 5, item = "ciggy"},
}

-- // VEHICLES // --
Shared.Vehicles = {
	-- Xe cardealer
	["faggio"] = {
		["name"] = "faggio",
		["brand"] = "Peugeot",
		["model"] = "faggio",
		["price"] = 8000,
		["category"] = "motorcycles",
		["hash"] = GetHashKey("2452219115"),
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
		["trunkspace"] = 35000,
		["trunkslots"] = 30,
		["shop"] = "custom",
	},	
	["burrito2"] = {
        ["name"] = "burrito2",
        ["brand"] = "peugeot",
        ["model"] = "burrito2",
        ["price"] = 220000,
        ["category"] ="vans", 
        ["hash"] = GetHashKey("0xAFBB2CA4"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["xls"] = {
        ["name"] = "xls",
        ["brand"] = "peugeot",
        ["model"] = "xls",
        ["price"] = 390000,
        ["category"] = "suvs", 
        ["hash"] = GetHashKey("0x47BBCF2E"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },

	["baller2"] = {
        ["name"] = "baller2",
        ["brand"] = "peugeot",
        ["model"] = "baller2",
        ["price"] = 632500,
        ["category"] = "suvs", 
        ["hash"] = GetHashKey("142944341"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },

	["huntley"] = {
        ["name"] = "huntley",
        ["brand"] = "peugeot",
        ["model"] = "huntley",
        ["price"] = 632500,
        ["category"] = "suvs", 
        ["hash"] = GetHashKey("486987393"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },

	["baller4"] = {
        ["name"] = "baller4",
        ["brand"] = "peugeot",
        ["model"] = "baller4",
        ["price"] = 747500,
        ["category"] = "suvs", 
        ["hash"] = GetHashKey("634118882"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["dubsta"] = {
        ["name"] = "dubsta",
        ["brand"] = "peugeot",
        ["model"] = "dubsta",
        ["price"] = 747500,
        ["category"] = "suvs", 
        ["hash"] = GetHashKey("1177543287"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },	
	["dubsta2"] = {
        ["name"] = "dubsta2",
        ["brand"] = "peugeot",
        ["model"] = "dubsta2",
        ["price"] = 862500,
        ["category"] = "suvs", 
        ["hash"] = GetHashKey("3900892662"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["glendale"] = {
        ["name"] = "glendale",
        ["brand"] = "peugeot",
        ["model"] = "glendale",
        ["price"] = 170000,
        ["category"] ="sedans",
        ["hash"] = GetHashKey("0x47A6BC1"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },	 
	["cog55"] = {
        ["name"] = "cog55",
        ["brand"] = "peugeot",
        ["model"] = "cog55",
        ["price"] = 345000,
        ["category"] ="sedans",
        ["hash"] = GetHashKey("906642318"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },	   
	["akuma"] = {
        ["name"] = "akuma",
        ["brand"] = "peugeot",
        ["model"] = "akuma",
        ["price"] = 103000,
        ["category"] = "motorcycles",
        ["hash"] = GetHashKey("0x63ABADE7"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["issi2"] = {
        ["name"] = "issi2",
        ["brand"] = "peugeot",
        ["model"] = "issi2",
        ["price"] = 110000,
        ["category"] = "compacts",
        ["hash"] = GetHashKey("0xB9CB3B69"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["brioso"] = {
        ["name"] = "brioso",
        ["brand"] = "peugeot",
        ["model"] = "brioso",
        ["price"] = 55000,
        ["category"] = "compacts",
        ["hash"] = GetHashKey("1429622905"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["faggio2"] = {
        ["name"] = "faggio2",
        ["brand"] = "peugeot",
        ["model"] = "faggio2",
        ["price"] = 35000,
        ["category"] = "motorcycles",
        ["hash"] = GetHashKey("55628203"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["bati"] = {
        ["name"] = "bati",
        ["brand"] = "peugeot",
        ["model"] = "bati",
        ["price"] = 170000,
        ["category"] = "motorcycles",
        ["hash"] = GetHashKey("4180675781"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["asterope"] = {
        ["name"] = "asterope",
        ["brand"] = "peugeot",
        ["model"] = "asterope",
        ["price"] = 100000,
        ["category"] = "sedans",
        ["hash"] = GetHashKey("2391954683"),
        ["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
        ["trunkspace"] = 35000,
        ["trunkslots"] = 30,
        ["shop"] = "custom",
    },
	["bobcatxl"] = {
			["name"] = "bobcatxl",
			["brand"] = "Vapid",
			["model"] = "bobcatxl",
			["price"] = 450000,
			["category"] = "vans",
			["hash"] = "1069929536",
			["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
			["trunkspace"] = 100000,
			["trunkslots"] = 80,
			["shop"] = "custom",
	},
	["bison"] = {
		["name"] = "bison",
		["brand"] = "Vapid",
		["model"] = "bison",
		["price"] = 345000,
		["category"] = "vans",
		["hash"] = "4278019151",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
},
["rumpo"] = {
	["name"] = "rumpo",
	["brand"] = "Vapid",
	["model"] = "rumpo",
	["price"] = 115000,
	["category"] = "vans",
	["hash"] = "1162065741",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},
	["minivan"] = {
		["name"] = "minivan",
		["brand"] = "Vapid",
		["model"] = "minivan",
		["price"] = 246400,
		["category"] = "vans",
		["hash"] = "3984502180",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
},
["youga"] = {
	["name"] = "youga",
	["brand"] = "Vapid",
	["model"] = "youga",
	["price"] = 280000,
	["category"] = "vans",
	["hash"] = "65402552",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["surfer"] = {
	["name"] = "surfer",
	["brand"] = "Vapid",
	["model"] = "surfer",
	["price"] = 63000,
	["category"] = "vans",
	["hash"] = "699456151",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["kamacho"] = {
	["name"] = "kamacho",
	["brand"] = "Vapid",
	["model"] = "kamacho",
	["price"] = 880000,
	["category"] = "off-road",
	["hash"] = "4173521127",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},
["bodhi2"] = {
	["name"] = "bodhi2",
	["brand"] = "Vapid",
	["model"] = "bodhi2",
	["price"] = 460000,
	["category"] = "off-road",
	["hash"] = "2859047862",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["riata"] = {
	["name"] = "riata",
	["brand"] = "Vapid",
	["model"] = "riata",
	["price"] = 632500,
	["category"] = "off-road",
	["hash"] = "2762269779",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["dominator"] = {
	["name"] = "dominator",
	["brand"] = "Vapid",
	["model"] = "dominator",
	["price"] = 560000,
	["category"] = "muscle",
	["hash"] = "80636076",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["flashgt"] = {
	["name"] = "flashgt",
	["brand"] = "Vapid",
	["model"] = "flashgt",
	["price"] = 880000,
	["category"] = "sports",
	["hash"] = "3035832600",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["alpha"] = {
	["name"] = "alpha",
	["brand"] = "Vapid",
	["model"] = "alpha",
	["price"] = 460000,
	["category"] = "sports",
	["hash"] = "767087018",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["kuruma"] = {
	["name"] = "kuruma",
	["brand"] = "Vapid",
	["model"] = "kuruma",
	["price"] = 862500,
	["category"] = "sports",
	["hash"] = "2922118804",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["jugular"] = {
	["name"] = "jugular",
	["brand"] = "Vapid",
	["model"] = "jugular",
	["price"] = 805000,
	["category"] = "sports",
	["hash"] = "4086055493",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},
["sultan"] = {
	["name"] = "sultan",
	["brand"] = "Vapid",
	["model"] = "sultan",
	["price"] = 575000,
	["category"] = "sports",
	["hash"] = "970598228",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["sultan2"] = {
	["name"] = "sultan2",
	["brand"] = "Vapid",
	["model"] = "sultan2",
	["price"] = 690000,
	["category"] = "sports",
	["hash"] = "872704284",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},

["dominator"] = {
	["name"] = "dominator",
	["brand"] = "Vapid",
	["model"] = "dominator",
	["price"] = 575000,
	["category"] = "sports",
	["hash"] = "80636076",
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/3/37/BobcatXL-GTAV-front.png",
	["trunkspace"] = 100000,
	["trunkslots"] = 80,
	["shop"] = "custom",
},


["sanchez"] = {
	["name"] = "sanchez",
	["brand"] = "peugeot",
	["model"] = "sanchez",
	["price"] = 80500,
	["category"] = "motorcycles",
	["hash"] = GetHashKey("788045382"),
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
	["trunkspace"] = 35000,
	["trunkslots"] = 30,
	["shop"] = "custom",
},
["bmx"] = {
	["name"] = "bmx",
	["brand"] = "peugeot",
	["model"] = "bmx",
	["price"] = 6900,
	["category"] = "cycles",
	["hash"] = GetHashKey("1131912276"),
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
	["trunkspace"] = 35000,
	["trunkslots"] = 30,
	["shop"] = "custom",
},
["panto"] = {
	["name"] = "panto",
	["brand"] = "peugeot",
	["model"] = "panto",
	["price"] = 20000,
	["category"] = "compacts",
	["hash"] = GetHashKey("3863274624"),
	["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
	["trunkspace"] = 35000,
	["trunkslots"] = 30,
	["shop"] = "custom",
},
	["hakuchou"] = {
		["name"] = "hakuchou",
		["brand"] = "Shitzu",
		["model"] = "hakuchou",
		["price"] = 189750,
		["category"] = "motorcycles",
		["hash"] = "1265391242",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/a/ab/Hakuchou-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["double"] = {
		["name"] = "double",
		["brand"] = "Shitzu",
		["model"] = "double",
		["price"] = 287500,
		["category"] = "motorcycles",
		["hash"] = "2623969160",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/a/ab/Hakuchou-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},

	["bati2"] = {
		["name"] = "bati2",
		["brand"] = "Shitzu",
		["model"] = "bati2",
		["price"] = 189750,
		["category"] = "motorcycles",
		["hash"] = "3403504941",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/a/ab/Hakuchou-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
 	["primo"] = {
		["name"] = "primo",
		["brand"] = "Albany",
		["model"] = "primo",
		["price"] = 138000,
		["category"] = "sedans",
		["hash"] = "3144368207",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/c/ca/PrimoCustom-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["coquette4"] = {
		["name"] = "coquette4",
		["brand"] = "Albany",
		["model"] = "coquette4",
		["price"] = 2070000,
		["category"] = "sports",
		["hash"] = "2566281822",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/c/ca/PrimoCustom-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["surge"] = {
		["name"] = "surge",
		["brand"] = "Cheval",
		["model"] = "surge",
		["price"] = 220000,
		["category"] = "sedans",
		["hash"] = "-1894894188",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/c/c2/Surge-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["fugitive"] = {
		["name"] = "fugitive",
		["brand"] = "Cheval",
		["model"] = "fugitive",
		["price"] = 170000,
		["category"] = "sedans",
		["hash"] = "1909141499",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/5/5c/Fugitive-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["rebel2"] = {
		["name"] = "rebel2",
		["brand"] = "peugeot",
		["model"] = "rebel2",
		["price"] = 632500,
		["category"] = "off-road",
		["hash"] = GetHashKey("2249373259"),
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
		["trunkspace"] = 35000,
		["trunkslots"] = 30,
		["shop"] = "custom",
	},
	["futo"] = {
		["name"] = "futo",
		["brand"] = "Karin",
		["model"] = "futo",
		["price"] = 287500,
		["category"] = "sports",
		["hash"] = "2016857647",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/6/67/Futo-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["hakuchou2"] = {
		["name"] = "hakuchou2",
		["brand"] = "Shitzu",
		["model"] = "hakuchou2",
		["price"] = 189750,
		["category"] = "motorcycles",
		["hash"] = "-255678177",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/a/ab/Hakuchou-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["stretch"] = {
		["name"] = "stretch",
		["brand"] = "Albany",
		["model"] = "stretch",
		["price"] = 320000,
		["category"] = "sedans",
		["hash"] = "-255678177",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/1/11/Stretch-GTAIV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["tailgater"] = {
		["name"] = "tailgater",
		["brand"] = "Obey",
		["model"] = "tailgater",
		["price"] = 320000,
		["category"] = "sedans",
		["hash"] = "-2125685308",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/e/e1/Tailgater-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["vectre"] = {
		["name"] = "vectre",
		["brand"] = "Emperor",
		["model"] = "vectre",
		["price"] = 320000,
		["category"] = "sedans",
		["hash"] = "-1540373595",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/8/8a/Vectre-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["calico"] = {
		["name"] = "calico",
		["brand"] = "Karin",
		["model"] = "calico",
		["price"] = 320000,
		["category"] = "sports",
		["hash"] = "-1193912403",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/a/ad/CalicoGTF-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["issi7"] = {
		["name"] = "issi7",
		["brand"] = "Karin",
		["model"] = "issi7",
		["price"] = 320000,
		["category"] = "sports",
		["hash"] = "1854776567",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/9/91/IssiSport-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["neo"] = {
		["name"] = "neo",
		["brand"] = "Karin",
		["model"] = "neo",
		["price"] = 320000,
		["category"] = "sports",
		["hash"] = "-1620126302",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/0/01/Neo-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["raptor"] = {
		["name"] = "raptor",
		["brand"] = "BF",
		["model"] = "raptor",
		["price"] = 320000,
		["category"] = "sports",
		["hash"] = "-674927303",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/c/cc/Raptor-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["krieger"] = {
		["name"] = "krieger",
		["brand"] = "Benefactor",
		["model"] = "krieger",
		["price"] = 320000,
		["category"] = "sports",
		["hash"] = "-664141241",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/e/e4/Krieger-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["nero"] = {
		["name"] = "nero",
		["brand"] = "Truffade",
		["model"] = "nero",
		["price"] = 320000,
		["category"] = "sports",
		["hash"] = "1034187331",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/5/5e/Nero-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["reaper"] = {
		["name"] = "reaper",
		["brand"] = "Pegassi",
		["model"] = "reaper",
		["price"] = 320000,
		["category"] = "sports",
		["hash"] = "234062309",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["rcbandito"] = {
		["name"] = "rcbandito",
		["brand"] = "",
		["model"] = "rcbandito",
		["price"] = 320000,
		["category"] = "off-road",
		["hash"] = "-286046740",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/1/14/RCBandito-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["trophytruck"] = {
		["name"] = "trophytruck",
		["brand"] = "Vapid",
		["model"] = "trophytruck",
		["price"] = 320000,
		["category"] = "off-road",
		["hash"] = "101905590",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/e/ec/TrophyTruck-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["guardian"] = {
		["name"] = "guardian",
		["brand"] = "Vapid",
		["model"] = "guardian",
		["price"] = 320000,
		["category"] = "off-road",
		["hash"] = "-2107990196",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/5/57/Guardian-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["cruiser"] = {
		["name"] = "cruiser",
		["brand"] = "",
		["model"] = "cruiser",
		["price"] = 320000,
		["category"] = "cycles",
		["hash"] = "448402357",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/b/bd/Cruiser-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["schafter2"] = {
		["name"] = "schafter2",
		["brand"] = "Benefactor",
		["model"] = "schafter2",
		["price"] = 650000,
		["category"] = "sedans",
		["hash"] = "-1255452397",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/6/6d/Schafter-GTAIV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["tailgater2"] = {
		["name"] = "tailgater2",
		["brand"] = "Obey",
		["model"] = "tailgater2",
		["price"] = 320000,
		["category"] = "sedans",
		["hash"] = "-1244461404",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/8/83/TailgaterS-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["vetir"] = {
		["name"] = "vetir",
		["brand"] = "HVY",
		["model"] = "vetir",
		["price"] = 1250000,
		["category"] = "off-road",
		["hash"] = "2014313426",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/b/b9/Vetir-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["blazer"] = {
		["name"] = "blazer",
		["brand"] = "Nagasaki",
		["model"] = "blazer",
		["price"] = 999000,
		["category"] = "off-road",
		["hash"] = "-2128233223",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/3/35/Blazer-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["verus"] = {
		["name"] = "verus",
		["brand"] = "Dinka",
		["model"] = "verus",
		["price"] = 999000,
		["category"] = "off-road",
		["hash"] = "298565713",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/6/62/Verus-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["slamvan"] = {
		["name"] = "slamvan",
		["brand"] = "Vapid",
		["model"] = "slamvan",
		["price"] = 550000,
		["category"] = "vans",
		["hash"] = "729783779",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/c/cb/Slamvan-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["slamvan3"] = {
		["name"] = "slamvan3",
		["brand"] = "Vapid",
		["model"] = "slamvan3",
		["price"] = 550000,
		["category"] = "vans",
		["hash"] = "1119641113",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/9/96/SlamvanCustom-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["moonbeam2"] = {
		["name"] = "moonbeam2",
		["brand"] = "Declasse",
		["model"] = "moonbeam2",
		["price"] = 550000,
		["category"] = "vans",
		["hash"] = "1896491931",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/9/94/MoonbeamCustom-GTAO-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["burrito3"] = {
		["name"] = "burrito3",
		["brand"] = "Declasse",
		["model"] = "burrito3",
		["price"] = 550000,
		["category"] = "vans",
		["hash"] = "-1743316013",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/8/80/Burrito3-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["gburrito2"] = {
		["name"] = "gburrito2",
		["brand"] = "Declasse",
		["model"] = "gburrito2",
		["price"] = 550000,
		["category"] = "vans",
		["hash"] = "296357396",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/d/d0/GangBurrito-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["paradise"] = {
		["name"] = "paradise",
		["brand"] = "Bravado",
		["model"] = "paradise",
		["price"] = 550000,
		["category"] = "vans",
		["hash"] = "1488164764",
		["image"] = "https://static.wikia.nocookie.net/gtawiki/images/d/d6/Paradise-GTAV-front.png",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["rebel"] = {
		["name"] = "rebel",
		["brand"] = "peugeot",
		["model"] = "rebel",
		["price"] = 632500,
		["category"] = "off-road",
		["hash"] = "-1207771834",
		["image"] = "https://vignette.wikia.nocookie.net/gtawiki/images/0/07/FaggioMod-GTAO-front.png",
		["trunkspace"] = 35000,
		["trunkslots"] = 30,
		["shop"] = "custom",
	},
	["mesa"] = {
		["name"] = "mesa",
		["brand"] = "Canis",
		["model"] = "mesa",
		["price"] = 320000,
		["category"] = "suvs",
		["hash"] = "914654722",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["bison"] = {
		["name"] = "bison",
		["brand"] = "Bravado",
		["model"] = "bison",
		["price"] = 320000,
		["category"] = "vans",
		["hash"] = "-16948145",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["bison2"] = {
		["name"] = "bison2",
		["brand"] = "Bravado",
		["model"] = "bison2",
		["price"] = 320000,
		["category"] = "vans",
		["hash"] = "2072156101",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["bobcatxl"] = {
		["name"] = "bobcatxl",
		["brand"] = "Vapid",
		["model"] = "bobcatxl",
		["price"] = 320000,
		["category"] = "vans",
		["hash"] = "1069929536",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["sandking"] = {
		["name"] = "sandking",
		["brand"] = "Vapid",
		["model"] = "sandking",
		["price"] = 320000,
		["category"] = "off-road",
		["hash"] = "-1189015600",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["sadler"] = {
		["name"] = "sadler",
		["brand"] = "Vapid",
		["model"] = "sadler",
		["price"] = 320000,
		["category"] = "off-road",
		["hash"] = "-599568815",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	["dubsta3"] = {
		["name"] = "dubsta3",
		["brand"] = "Benefactor",
		["model"] = "dubsta3",
		["price"] = 320000,
		["category"] = "off-road",
		["hash"] = "-1237253773",
		["image"] = "",
		["trunkspace"] = 100000,
		["trunkslots"] = 80,
		["shop"] = "custom",
	},
	
	
	
	
-- Xe cardealer

}

Shared.Jobs = {
	["unemployed"] = {
		label = "Thất nghiệp",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Thât nghiệp",
                payment = 0--90 1h
			},
		},
		defaultDuty = true,
	},
	["police"] = {
        label = "Cảnh sát",
        grades = {
            ['0'] = {
                name = "Học viên",
                payment = 0--4k 1h
            },
            ['1'] = {
                name = "Cảnh sát Chính thức",
                payment = 500--3k 1h
            },
            ['2'] = {
                name = "Trung Sĩ",
                payment = 633--3k8 1h
            },
            ['3'] = {
                name = "Thiếu Úy",
                payment = 766--4k6 1h
            },
            ['4'] = {
                name = "Trung Úy",
                payment = 866--5k2 1h
            },
            ['5'] = {
                name = "Đại Tá",
                payment = 966--5k8 1h
            },
			['6'] = {
				name = "Giám đốc cảnh sát",
				isboss = true,
                payment = 1050--6k3 1h
            },
        },
        defaultDuty = true,
	},
	["ambulance"] = {
		label = "Bệnh viện",
		grades = {
			['0'] = {
                name = "Học viên",
                payment = 0
            },
			['1'] = {
                name = "Y Tá",
                payment = 583--3k5 1h
            },
			['2'] = {
                name = "Bác Sĩ",
                payment = 666--4k 1h
            },
			['3'] = {
                name = "Viện Phó",
                payment = 750--4k5 1h
            },
			['4'] = {
                name = "Viện Trưởng",
                payment = 833--5k 1h
            },
			['5'] = {
				name = "Giám Đốc Bệnh Viện",
				isboss = true,
                payment = 1000--6k 1h
            },
        },
		defaultDuty = true,
	},

	["trucker"] = {
		label = "Người lái xe tải",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["taxi"] = {
		label = "Taxi",
		payment = 0,
		grades = {
			['0'] = {
                name = "Nhân viên",
                payment = 0
            },
			['1'] = {
				name = "Ông chủ",
				isboss = true,
                payment = 0
            },
		},
		defaultDuty = true,
	},
	["realestate"] = {
		label = "Địa ốc",
		payment = 0,
		grades = {
			['0'] = {
                name = "Nhà thầu",
                payment = 0
            },
			['1'] = {
                name = "Chủ nhân",
				isboss = true,
                payment = 0
            },
        },
		defaultDuty = true,
	},
	["tow"] = {
		label = "Kéo xe",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["reporter"] = {
		label = "Tin tức",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Cộng tác viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["judge"] = {
		label = "Luật sư",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Luật sư",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["lawyer"] = {
		label = "Luật sư",
		payment = 0,
		defaultDuty = true,
		grades = {
			['0'] = {
                name = "Thư ký",
                payment = 0
            },
            ['1'] = {
                name = "Luật sư",
                payment = 0
            },
		}
	},
	["cardealer"] = {
		label = "Car Dealer",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0--3k 1h
            },
			['1'] = {
				name = "Giám đốc",
				isboss = true,
                payment = 0--4k 1h
            },
        },
		defaultDuty = true,
	},
	["mechanic"] = {
		label = "Cứu hộ",
		payment = 0,
		defaultDuty = true,
		grades = {
			['0'] = {
                name = "Học viên",--1k2
                payment = 200
			},
            ['1'] = {
                name = "Thợ sửa chính",--2k8
                payment = 466
			},
            ['2'] = {
                name = "Quản lý",
				isboss = true,
                payment = 583
			},
			['3'] = {
				name = "Tổng giám đốc",
				isboss = true,
                payment = 866
            },
		}
	},
	["bennys"] = {
		label = "Độ xe",
		payment = 0,
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Nhân viên", -- ko độ xe, ko kho đồ, chỉ thay đồ on offduty
                payment = 0
			},
			['1'] = {
                name = "Quản lý", -- sẽ được độ xe, onoffduty, kho đồ, thay đồ
                payment = 0
			},
            ['2'] = {
                name = "Giám đốc",
				isboss = true,
                payment = 0
			},            
		}
	},
	["vanilla"] = {
		label = "Con kỳ lân",
		payment = 0,
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
			['1'] = {
				name = "Ông chủ",
				isboss = true,
                payment = 0
            },
		}
	},
	["garbage"] = {
		label = "Hốt Rác",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["burger"] = {
		label = "Bán bánh mì",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["butcher"] = {
		label = "Người bán thịt",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["fueler"] = {
		label = "người đổ xăng",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["pizza"] = {
		label = "Pizza",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
			['1'] = {
                name = "Pha chế",
                payment = 0
			},
			['2'] = {
                name = "Quản lý",
                payment = 0
			},
			['3'] = {
                name = "Giám đốc",
				isboss = true,
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["kledingmaker"] = {
		label = "Nhà sản xuất quần áo",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["kfc"] = {
		label = "kfc",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
			['1'] = {
                name = "Thủ kho",
                payment = 0
			},
			['2'] = {
                name = "Quản lý",
				isboss = true,
                payment = 0
			},
			['3'] = {
                name = "Giám đốc",
				isboss = true,
                payment = 0
			},
		},
		defaultDuty = true,
	},
	["trada"] = {
		label = "Trà đá",
		payment = 0,
		grades = {
            ['0'] = {
                name = "Nhân viên",
                payment = 0
			},
			['1'] = {
                name = "Pha chế",
                payment = 0
			},
			['2'] = {
                name = "Quản lý",
                payment = 0
			},
			['3'] = {
                name = "Giám đốc",
				isboss = true,
                payment = 0
			},
		},
		defaultDuty = true,
	},
}

Citizen.CreateThread(function()
	print("\x1b[32m[pepe-core:LOG]\x1b[0m shared.lua")
end)