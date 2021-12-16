Config = {}
Config.Locale = "en" -- Language "en" "ru"
Config.GameName = "Đèn xanh - Đèn đỏ"

Config.Fee = 1000 -- How much money cost to participate in game
Config.StartPoint = vector3(-1644.08, -880.5484, 8.9999914) -- Lobby point
Config.DollyWatchingRandomTime = {1000, 2000, 3000, 4000, 5000, 6000, 7000} -- Doll watching time in milliseconds (random)
Config.GameDuration = 2 * 60 * 1000 -- Game duration is 2 minutes
Config.GameStartInterval = 15 * 1000 -- Game automatically starts every 1 minute

Config.EnablePlayerNPCs = false -- Spawns NPC's

Config.ChangePlayerSkin = true
Config.UsePedModelsInsteadOutfitsForPlayers = false -- Useful when you want to use ped models and don't want to use multiplayer clothes
Config.UsePedModelsInsteadOutfitsForGuards = false -- Useful when you want to use ped models and don't want to use multiplayer clothes
Config.AllowCustomPeds = false -- Players with custom ped models will have them in game

Config.EnableHitting = true -- players allowed/blocked to hit someone
Config.EnableGodmode = true -- players will not receive damage

-- Player spawns when game starts, finish and guards position
Config.SpawnCoords = {
    GameStarted = {
        vector3(1173.152, 7151.829, 21.41101),
        vector3(1127.96, 7151.004, 20.40002),
        vector3(1152.963, 7154.185, 20.40002),
        vector3(1171.701, 7153.426, 20.41687),
        vector3(1167.864, 7152.598, 20.41687),
        vector3(1167.864, 7153.598, 20.41687),
        vector3(1166.004, 7153.13, 20.41687),
        vector3(1162.378, 7152.657, 20.41687),
        vector3(1157.96, 7152.495, 20.41687),
        vector3(1153.714, 7152.525, 20.41687),
        vector3(1150.246, 7155.571, 20.41687),
        vector3(1153.714, 7153.525, 20.41687),
        vector3(1150.246, 7152.571, 20.41687),
        vector3(1144.312, 7152.281, 20.41687),
        vector3(1140.659, 7154.158, 20.41687),
        vector3(1137.692, 7152.323, 20.41687),
        vector3(1134.501, 7153.053, 20.41687),
        vector3(1132.167, 7151.033, 20.41687),
        vector3(1129.068, 7153.512, 20.41687),
        vector3(1124.36, 7153.883, 20.41687),
        vector3(1165.464, 7154.336, 20.41687),
        vector3(1170.382, 7154.213, 20.41687),
    },
    GameSuccess = { -- Player won the game. You can use it for teleporting player to next level
        vector3(-1597.481, -926.1502, 9.4967107),
        vector3(-1599.548, -929.8125, 9.4967107),
    },
    GameFailed = { -- Player failed the game. You can use it for teleporting player to some limbo or something :P
        vector3(-1590.18, -917.3345, 9.7992401),
        vector3(-1587.685, -913.9578, 9.7992401),
    },
    GuardsNPC = {
        vector3(1143.029, 7252.681, 20.41687),
        vector3(1150.029, 7252.681, 20.41687),
    },
}


-- Clothes https://forum.cfx.re/t/release-paid-squid-game-clothing-pack-optimisation/
-- Guidline: https://forum.cfx.re/t/squid-game-level-1-esx-qbcore-standalone/4768952/31?u=draobrehtom
Config.PlayerOutfits = {
    ["male"] = {
        {
            [4] = {28, 8},-- Pants
            [6] = {77, 2},-- Shoes
            [8] = {148, 8},-- T-Shirt
            [11] = {230, 11},-- Torso 2

            [1] = {146, 6}, -- MASK: vMenu values 2 and 39
            [2] = {0, 0},-- Hair
            [3] = {79, 0},-- Arms
            [5] = {0, 0},-- Bag
            [7] = {0, 0},-- Accessory
            [9] = {0, 0},-- Vest
            [10] = {0, 0},-- Badge
            [12] = {22, 0},-- Hat
        },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {75, 1},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {75, 2},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {75, 3},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },

        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {74, 0},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {74, 1},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {74, 2},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {74, 3},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },

        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {0, 0},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {0, 1},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {0, 2},

        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        -- {
        --     [4] = {5, 0},
        --     [6] = {43, 0},
        --     [8] = {0, 0},
        --     [11] = {0, 3},
            
        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
    },
    ["female"] = {
        -- {
        --     [4] = {66, 0},
        --     [6] = {80, 0},
        --     [8] = {2, 0},
        --     [11] = {147, 0},
            
        --     [1] = {0, 0},
        --     [2] = {0, 0},
        --     [3] = {0, 0},
        --     [5] = {0, 0},
        --     [7] = {0, 0},
        --     [9] = {0, 0},
        --     [10] = {0, 0},
        -- },
        {
            [4] = {28, 0},-- Pants
            [6] = {77, 2},-- Shoes
            [8] = {28, 5},-- T-Shirt
            [11] = {240, 11},-- Torso 2

            [1] = {146, 6}, -- MASK: vMenu values 2 and 39
            [2] = {0, 0},-- Hair
            [3] = {4, 0},-- Arms
            [5] = {0, 0},-- Bag
            [7] = {0, 0},-- Accessory
            [9] = {0, 0},-- Vest
            [10] = {0, 0},-- Badge
            [12] = {23, 0},-- Hat
        },
    }
}

-- Guard clothes, credits https://de.gta5-mods.com/player/squid-game-mask-for-mp-male-sp-fivem
Config.GuardOutfits = {
    {
        [1] = {4, 0},
        [4] = {19, 0}, -- b1608 {19, 0}, b2189 {122, 0}, 
        [3] = {16, 0},
        [11] = {65, 0},
        [6] = {25, 0}, -- b1608 {25, 0}, b2189 {97, 0},
        [8] = {15, 0},
    },
    {
        [1] = {4, 1},
        [4] = {19, 0}, 
        [3] = {16, 0},
        [11] = {65, 0},
        [6] = {25, 0},
        [8] = {15, 0},

    },
    {
        [1] = {4, 2},
        [4] = {19, 0}, 
        [3] = {16, 0},
        [11] = {65, 0},
        [6] = {25, 0},
        [8] = {15, 0},
    },
}

-- Same as PlayerOutfits, but intead used ped models
Config.PlayerPeds = {"u_m_y_zombie_01", "u_m_y_mani", "u_m_y_juggernaut_01", "u_m_m_streetart_01", "ig_rashcosvki", "ig_claypain"}
-- Same as GuardOutfits, but instead used ped models
Config.GuardPeds = {"hc_gunman", "hc_driver", "s_m_y_swat_01"}

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- Variables bellow are only for devs, 
-- but you can try to change it if you want to experiment
-- just make a backup of files.
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
Config.DollyCoords = vector3(1147.029, 7252.681, 20.41687) -- Doll position
Config.DollyIsWatchingHeading = 0.0 -- Angle of the Doll when she is watching
Config.DollyIsNotWatchingHeading = 180.0 -- Angle of the Doll when she is not watching
Config.GunCoords = { -- Gun positions where shoots are comming from
    vector3(1117.00500000, 7154.95200000, 32.22739000),
    vector3(1116.89100000, 7176.52800000, 32.16578000),
    vector3(1116.89100000, 7214.59300000, 32.16578000),
    vector3(1117.00500000, 7193.01700000, 32.22739000),
    vector3(1177.62300000, 7249.56900000, 32.16578000),
    vector3(1177.70200000, 7227.99300000, 32.22739000),
    vector3(1177.70200000, 7190.06200000, 32.22739000),
    vector3(1177.62300000, 7211.63800000, 32.16578000),
    vector3(1177.70200000, 7152.09800000, 32.22739000),
    vector3(1177.62300000, 7173.67500000, 32.16578000),
    vector3(1117.00500000, 7230.30600000, 32.22739000),
    vector3(1116.89100000, 7251.88100000, 32.16578000),
}

-- Auto plug-in framework. See `server/framework.lua` for API.

if GetResourceState('es_extended') == 'started' or GetResourceState('extendedmode') == 'started' then -- ESX
    Config.Framework = "ESX"
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif GetResourceState('qb-core') == 'started' then -- QBCore
    Config.Framework = "QB"
	TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
elseif GetResourceState('vrp') == 'started' then
    Config.Framework = "vRP"
    if IsDuplicityVersion() then
        Proxy = module("vrp", "lib/Proxy")
        Tunnel = module("vrp", "lib/Tunnel")
        vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())
    else
        Proxy = {}
        local proxy_rdata = {}
        local function proxy_callback(rvalues) -- save returned values, TriggerEvent is synchronous
          proxy_rdata = rvalues
        end
        local function proxy_resolve(itable,key)
        local iname = getmetatable(itable).name
        -- generate access function
        local fcall = function(args,callback)
            if args == nil then
              args = {}
            end
        
            TriggerEvent(iname..":proxy",key,args,proxy_callback)
            return table.unpack(proxy_rdata) -- returns
          end
          itable[key] = fcall -- add generated call to table (optimization)
          return fcall
        end
        --- Add event handler to call interface functions (can be called multiple times for the same interface name with different tables)
        function Proxy.addInterface(name, itable)
          AddEventHandler(name..":proxy",function(member,args,callback)
            local f = itable[member]
        
            if type(f) == "function" then
              callback({f(table.unpack(args))}) -- call function with and return values through callback
              -- CancelEvent() -- cancel event doesn't seem to cancel the event for the other handlers, but if it does, uncomment this
            else
              -- print("error: proxy call "..name..":"..member.." not found")
            end
          end)
        end
        function Proxy.getInterface(name)
          local r = setmetatable({},{ __index = proxy_resolve, name = name })
          return r
        end
        -- END PROXY

        ---- TUNNEL CLIENT SIDE VERSION (https://github.com/ImagicTheCat/vRP)
        -- Too bad that require doesn't exist client-side
        -- TOOLS DEF
        Tools = {}

        -- ID generator

        local IDGenerator = {}

        function Tools.newIDGenerator()
        local r = setmetatable({}, { __index = IDGenerator })
        r:construct()
        return r
        end

        function IDGenerator:construct()
        self:clear()
        end

        function IDGenerator:clear()
        self.max = 0
        self.ids = {}
        end

        -- return a new id
        function IDGenerator:gen()
        if #self.ids > 0 then
            return table.remove(self.ids)
        else
            local r = self.max
            self.max = self.max+1
            return r
        end
        end

        -- free a previously generated id
        function IDGenerator:free(id)
        table.insert(self.ids,id)
        end

        -- TUNNEL DEF
        Tunnel = {}

        local function tunnel_resolve(itable,key)
        local mtable = getmetatable(itable)
        local iname = mtable.name
        local ids = mtable.tunnel_ids
        local callbacks = mtable.tunnel_callbacks
        local identifier = mtable.identifier

        -- generate access function
        local fcall = function(args,callback)
            if args == nil then
            args = {}
            end
            
            -- send request
            if type(callback) == "function" then -- ref callback if exists (become a request)
            local rid = ids:gen()
            callbacks[rid] = callback
            TriggerServerEvent(iname..":tunnel_req",key,args,identifier,rid)
            else -- regular trigger
            TriggerServerEvent(iname..":tunnel_req",key,args,"",-1)
            end

        end

        itable[key] = fcall -- add generated call to table (optimization)
        return fcall
        end

        -- bind an interface (listen to net requests)
        -- name: interface name
        -- interface: table containing functions
        function Tunnel.bindInterface(name,interface)
        -- receive request
        RegisterNetEvent(name..":tunnel_req")
        AddEventHandler(name..":tunnel_req",function(member,args,identifier,rid)
            local f = interface[member]

            local delayed = false

            local rets = {}
            if type(f) == "function" then
            -- bind the global function to delay the return values using the returned function with args
            TUNNEL_DELAYED = function()
                delayed = true
                return function(rets)
                rets = rets or {}
                if rid >= 0 then
                    TriggerServerEvent(name..":"..identifier..":tunnel_res",rid,rets)
                end
                end
            end

            rets = {f(table.unpack(args))} -- call function 
            -- CancelEvent() -- cancel event doesn't seem to cancel the event for the other handlers, but if it does, uncomment this
            end

            -- send response (event if the function doesn't exist)
            if not delayed and rid >= 0 then
            TriggerServerEvent(name..":"..identifier..":tunnel_res",rid,rets)
            end
        end)
        end

        -- get a tunnel interface to send requests 
        -- name: interface name
        -- identifier: unique string to identify this tunnel interface access (the name of the current resource should be fine)
        function Tunnel.getInterface(name,identifier)
        local ids = Tools.newIDGenerator()
        local callbacks = {}

        -- build interface
        local r = setmetatable({},{ __index = tunnel_resolve, name = name, tunnel_ids = ids, tunnel_callbacks = callbacks, identifier = identifier })

        -- receive response
        RegisterNetEvent(name..":"..identifier..":tunnel_res")
        AddEventHandler(name..":"..identifier..":tunnel_res",function(rid,args)
            local callback = callbacks[rid]
            if callback ~= nil then
            -- free request id
            ids:free(rid)
            callbacks[rid] = nil

            -- call
            callback(table.unpack(args))
            end
        end)

        return r
        end
        ---- END TUNNEL CLIENT SIDE VERSION

        vRPserver = Tunnel.getInterface("vRP", "vRP")
    end
    vRP = Proxy.getInterface("vRP")

    -- vRP 2
    -- Proxy = module("vrp", "lib/Proxy")
    -- vRP = Proxy.getInterface("vRP")
    -- vRP.loadScript(GetCurrentResourceName(), "config.lua")
elseif GetResourceState('pepe-core') == 'started' then -- Your_Framework
    Config.Framework = "pepe"
    TriggerEvent('Framework:GetObject', function(obj) FrameworkObj = obj end)
else -- Standalone
    Config.Framework = "standalone"
end