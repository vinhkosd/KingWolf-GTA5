KingWolfSCfg = {}

--[[Server Config]]--
KingWolfSCfg.DiscordNote = '' -- Not important
KingWolfSCfg.Logo = '' -- Put your server logo
KingWolfSCfg.ServerName = 'ServerName' -- Put your server name
KingWolfSCfg.FileName = 'installer' -- Name of your lua file for install (Default = installer.lua) // You can change this if you want

--[Webhook]--
KingWolfSCfg.BanWebhook = 'https://discord.com/api/webhooks/...' -- Put your ban webhook
KingWolfSCfg.LogWebhook = 'https://discord.com/api/webhooks/...' -- Put your log webhook
KingWolfSCfg.ScreenWebhook = 'https://discord.com/api/webhooks/...' -- Put your screenshot webhook

--[[Kick Message]]--
KingWolfSCfg.KickMessage = "You have been permanently banned." -- You can edit this

--[[Blacklist Entity]]--
KingWolfSCfg.ExplosionsAC = true -- Detects blacklisted explosions and who created them (tables/explosions.lua) // HIGHLY RECOMMENDED
KingWolfSCfg.BlacklistPed = true -- Detects blacklisted ped and remove (tables/blacklist.lua) // HIGHLY RECOMMENDED
KingWolfSCfg.BlacklistVeh = true -- Detects blacklisted vehicle and remove (tables/blacklist.lua) // HIGHLY RECOMMENDED

KingWolfSCfg.ObjectDetect = true -- Detects blacklisted object and remove // HIGHLY RECOMMENDED
KingWolfSCfg.AllObject = false -- If = true, All objects will be detected and deleted | If = false, will detect the objects contained here (tables/blacklist.lua)
KingWolfSCfg.AllObjectWhitelist = { -- Objects in this list will not be deleted (Works only if AllObject = true)
}
KingWolfSCfg.ObjectBan = false -- Ban player who created blacklistobject (Works only if AllObject = false)
KingWolfSCfg.BlacklistVehBan = true -- Ban player who spawn blacklist vehicles

--[[Logs System]]--
KingWolfSCfg.PedsLog = true
KingWolfSCfg.VehiclesLog = true
KingWolfSCfg.ObjectsLog = true

--[[Onesync Configs]]-- You can edit numbers
KingWolfSCfg.MaxSpawner = true -- (Set = true to use the options below, set = false to disable)
KingWolfSCfg.MaxObject = 500 -- Maximum number of objects the player can spawn in 1 minute, if over the player will be banned (Default = 80, set = 0 to disable)
KingWolfSCfg.MaxVehicle = 500 -- Maximum number of vehicles the player can spawn in 1 minute, if over the player will be banned (Default = 80, set = 0 to disable)
KingWolfSCfg.MaxPed = 500 -- Maximum number of peds the player can spawn in 1 minute, if over the player will be banned (Default = 80, set = 0 to disable)

--[[Blacklist Event]]--
KingWolfSCfg.BlacklistEvent = false -- Detects when player TriggerServer blacklisted event and ban them (tables/blacklistevent.lua) // (Remember to save your original server resource)

--[[Blacklist Words]]--
KingWolfSCfg.FakeChat = false -- Detects if player try to say with other player's name
KingWolfSCfg.BlacklistWords = false -- Detects if player try to say a blacklist word and ban them (tables/blacklistwords.lua)

--[[ClearPedTasksImmediately Detection]]--
KingWolfSCfg.ClearDetected = true -- Detects ClearPedTasksImmediately (Detects cheaters that are kicking out of vehicles other players) // HIGHLY RECOMMENDED
KingWolfSCfg.ClearDetectedBan = false -- Ban Player

--[[GiveWeapon Detection]]--
KingWolfSCfg.WeaponDetected = false -- Detects GiveWeapon (detects if cheater tries to give another player a weapon on the blacklist) // (tables/weapon.lua) HIGHLY RECOMMENDED

KingWolfSCfg.BlacklistNames = true -- Do not allow players named in the blacklist to connect to the server
KingWolfSCfg.NamesKickReason = 'Your name have a blacklist words, please change your name' -- You can edit this
KingWolfSCfg.BlackListNamesTables = {
"administrator", "admin", "adm1n", "adm!n", "admln", "moderator", "owner", "nigger", "n1gger", "eulencheats", "lynxmenu", "atgmenu", "hacker", "bastard", "hamhaxia", "333gang", "ukrp", "eguk", "n1gger", "n1ga", "nigga", "n1gga", "nigg3r",
    "nig3r", "shagged", "4dm1n", "4dmin", "m0d3r4t0r", "n199er", "n1993r", "rustchance.com", "rustchance", "hellcase.com", "hellcase", "youtube.com", "youtu.be", "youtube", "twitch.tv", "twitch", "anticheat.gg", "anticheat", "fucking", "ψ", "@", "&", "{", "}", ";", "ϟ", "♕", "Æ", "Œ", "‰", "™", "š", "œ", "Ÿ", "µ", "ß",
    "±", "¦", "»", "«", "¼", "½", "¾", "¬", "¿", "Ñ", "®", "©", "²", "·", "•", "°", "þ", "ベ", "ル", "ろ", "ぬ", "ふ", "う", "え", "お", "や", "ゆ", "よ", "わ", "ほ", "へ", "た", "て", "い", "す", "か", "ん", "な", "に", "ら", "ぜ", "む",
    "ち", "と", "し", "は", "き", "く", "ま", "の", "り", "れ", "け", "む", "つ", "さ", "そ", "ひ", "こ", "み", "も", "ね", "る", "め", "ロ", "ヌ", "フ", "ア", "ウ", "エ", "オ", "ヤ", "ユ", "ヨ", "ワ", "ホ", "ヘ", "タ", "テ", "イ", "ス", "カ", "ン",
    "ナ", "ニ", "ラ", "セ", "ム", "チ", "ト", "シ", "ハ", "キ", "ク", "マ", "ノ", "リ", "レ", "ケ", "ム", "ツ", "サ", "ソ", "ヒ", "コ", "ミ", "モ", "ネ", "ル", "メ", "✪", "Ä", "ƒ", "Ã", "¢", "?", "†", "€", "웃", "и", "】", "【", "j4p.pl", "ֆ", "ȶ",
    "你", "好", "爱", "幸", "福", "猫", "狗", "微", "笑", "中", "安", "東", "尼", "杰", "诶", "西", "开", "陈", "瑞", "华", "馬", "塞", "洛", "ダ", "仇", "觉", "感", "衣", "德", "曼", "L͙", "a͙", "l͙", "ľ̶̚͝", "Ḩ̷̤͚̤͑͂̎̎͆", "a̸̢͉̠͎͒͌͐̑̇", "♚", "я", "Ʒ", "Ӂ̴", "Ƹ̴", "≋",
    "chocohax", "civilgamers.com", "civilgamers", "csgoempire.com", "csgoempire", "g4skins.com", "g4skins", "gameodds.gg", "duckfuck.com", "crysishosting.com", "crysishosting", "key-drop.com", "key-drop.pl", "skinhub.com", "skinhub", "`", "¤", "¡",
    "casedrop.eu", "casedrop", "cs.money", "rustypot.com", "✈", "⛧", "☭", "☣", "✠", "dkb.xss.ht", "( . )( . )", "⚆", "╮", "╭", "rampage.lt", "?", "xcasecsgo.com", "xcasecsgo", "csgocases.com",
    "csgocases", "K9GrillzUK.co.uk", "moat.gg", "princevidz.com", "princevidz", "pvpro.com", "Pvpro", "ez.krimes.ro", "loot.farm", "arma3fisherslife.net", "arma3fisherslife", "egamers.io", "ifn.gg", "key-drop", "sups.gg", "tradeit.gg",
    "§", "csgotraders.net", "csgotraders", "Σ", "Ξ", "hurtfun.com", "hurtfun", "gamekit.com", "¥", "t.tv", "yandex.ru", "yandex", "csgofly.com", "csgofly", "pornhub.com", "pornhub", "一", "", "Ｊ", "◢", "◤", "⋡", "℟", "ᴮ", "ᴼ", "ᴛᴇᴀᴍ",
    "cs.deals","twat", "STRESS.PW", "/", "script", "<", ">"
}

--[[Permission System]]-- DO NOT TOUCH IF YOU DON'T KNOW WHAT ARE U DOING 
KingWolfSCfg.Admin = {"kwadmin"} -- This will allow the user with these perms to bypass Violation detections such as mod menus/weapons/godmode, etc.
KingWolfSCfg.Blips = {"kwadmin"} -- This will allow the user with these perms to use Player Blips.