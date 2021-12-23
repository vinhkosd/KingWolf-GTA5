local DutyVehicles = {}
HasHandCuffs = false

Config = Config or {}

Config.Keys = {["F1"] = 288}

Config.Menu = {
 [1] = {
    id = "citizen",
    displayName = "Công dân",
    icon = "#citizen-action",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            return true
        end
    end,
    subMenus = {"citizen:escort", 'citizen:steal', 'citizen:contact', 'citizen:vehicle:getout', 'citizen:vehicle:getin', 'citizen:corner:selling'}
 },
 [2] = {
    id = "animations",
    displayName = "Dáng đi",
    icon = "#walking",
    enableMenu = function()
       if not exports['pepe-hospital']:GetDeathStatus() then
           return true
        end
    end,
    subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
 },
 [3] = {
     id = "expressions",
     displayName = "Biểu cảm",
     icon = "#expressions",
     enableMenu = function()
         if not exports['pepe-hospital']:GetDeathStatus() then
            return true
         end
     end,
     subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
 },
 [4] = {
    id = "police",
    displayName = "Cảnh sát",
    icon = "#police-action",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:panic", "police:search", "police:tablet", "police:impound", "police:resetdoor", "police:enkelband", "police:dispatch"}
 },
 [5] = {
    id = "police",
    displayName = "Radio Channels",
    icon = "#police-radio-channel",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:radio:one", "police:radio:two", "police:radio:three", "police:radio:four", "police:radio:five"}
 },
 [6] = {
    id = "police",
    displayName = "Đồ cảnh sát",
    icon = "#police-action",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:object:cone", "police:object:barrier", "police:object:tent", "police:object:light", "police:object:schot", "police:object:delete"}
 },
 [7] = {
    id = "police-down",
    displayName = "10-13A",
    icon = "#police-down",
    close = true,
    functiontype = "client",
    functionParameters = 'Urgent',
    functionName = "pepe-radialmenu:client:send:down",
    enableMenu = function()
        if exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
 },
 [8] = {
    id = "police-down",
    displayName = "10-13B",
    icon = "#police-down",
    close = true,
    functiontype = "client",
    functionParameters = 'Normal',
    functionName = "pepe-radialmenu:client:send:down",
    enableMenu = function()
        if exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
 },
 [9] = {
    id = "ambulance",
    displayName = "Bác sĩ",
    icon = "#ambulance-action",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'ambulance' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"ambulance:heal", "ambulance:revive", "police:panic", "ambulance:blood"}
 },
 [10] = {
    id = "vehicle",
    displayName = "Phương tiện",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
            if Vehicle ~= 0 and Distance < 2.3 then
                return true
            end
        end
    end,
    subMenus = {"vehicle:flip", "vehicle:key"}
 },
 [11] = {
    id = "vehicle-doors",
    displayName = "Menu xe",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) or IsPedInAnyBoat(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1)) or IsPedOnAnyBike(GetPlayerPed(-1)) then
                return true
            end
        end
    end,
    close = true,
    functiontype = "client",
    functionName = "veh:options",
    -- subMenus = {"vehicle:door:motor", "vehicle:door:left:front", "vehicle:door:right:front", "vehicle:door:trunk", "vehicle:door:right:back", "vehicle:door:left:back"}
 },
 [12] = {
    id = "police-garage",
    displayName = "Ga-ra cảnh sát",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-police']:GetGarageStatus()and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty and tonumber(Framework.Functions.GetPlayerData().job.grade.level) < 1 then
                return true
            end
        end
    end,
    subMenus = {"police:garage:police2", "vehicle:delete"}
 },
 [13] = {
    id = "garage",
    displayName = "Ga-ra",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-garages']:IsNearGarage() then
                return true
            end
        end
    end,
    subMenus = {"garage:putin", "garage:getout"}
 },
 [14] = {
    id = "atm",
    displayName = "Bank",
    icon = "#global-bank",
    close = true,
    functiontype = "client",
    functionName = "pepe-banking:client:open:bank",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-banking']:IsNearAnyBank() then
                return true
            end
        end
  end,
 },
 [15] = {
    id = "appartment",
    displayName = "Đi vào trong",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "pepe-appartments:client:enter:appartment",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-appartments']:IsNearHouse() then
                return true
            end
        end
  end,
 },
 [16] = {
    id = "depot",
    displayName = "Chuộc xe",
    icon = "#global-depot",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "pepe-garages:client:open:depot",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-garages']:IsNearDepot() then
                return true
            end
        end
  end,
 },
 [17] = {
    id = "housing",
    displayName = "Đi vào trong",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "pepe-housing:client:enter:house",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-housing']:EnterNearHouse() then
                return true
            end
        end
  end,
 },
 [18] = {
    id = "housing-options",
    displayName = "Tùy chọn nhà",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-housing']:HasEnterdHouse() then
                return true
            end
        end
    end,
    subMenus = {"house:setstash", "house:setlogout", "house:setclothes", "house:givekey", "house:decorate" }
 },
 [19] = {
    id = "judge-actions",
    displayName = "Luật sư",
    icon = "#judge-actions",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'judge' then
            return true
        end
    end,
    subMenus = {"judge:tablet", "judge:job", "police:tablet"}
 },
 [20] = {
    id = "ambulance-garage",
    displayName = "Ga-ra bác sĩ",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'ambulance' and Framework.Functions.GetPlayerData().job.onduty then
            if exports['pepe-hospital']:NearGarage() then
                return true
            end
        end
    end,
    subMenus = {"ambulance:garage:sprinter", "ambulance:garage:suvems", "ambulance:garage:heli", "vehicle:delete"}
 },
 [21] = {
    id = "scrapyard",
    displayName = "Rã xe",
    icon = "#police-action-vehicle-spawn",
    close = true,
    functiontype = "client",
    functionName = "pepe-materials:client:scrap:vehicle",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
          if exports['pepe-materials']:IsNearScrapYard() then
            return true
          end
        end
  end,
  },
  [22] = {
    id = "cityhall",
    displayName = "Tòa thị chính",
    icon = "#global-cityhall",
    close = true,
    functiontype = "client",
    functionName = "pepe-cityhall:client:open:nui",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-cityhall']:CanOpenCityHall() then
                return true
            end
        end
  end,
 },
 [23] = {
    id = "dealer",
    displayName = "Dealer Shop",
    icon = "#global-dealer",
    close = true,
    functiontype = "client",
    functionName = "pepe-dealers:client:open:dealer",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-dealers']:CanOpenDealerShop() then
                return true
            end
        end
  end,
 },
 [24] = {
    id = "traphouse",
    displayName = "Traphouse",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionName = "pepe-traphouse:client:enter",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-traphouse']:CanPlayerEnterTraphouse() then
                return true
            end
        end
  end,
 },
 [25] = {
    id = "tow-menu",
    displayName = "Kéo xe",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'tow' then
            return true
        end
    end,
    subMenus = {"tow:hook", "tow:npc"}
 },
 [26] = {
    id = "cuff",
    displayName = "Còng tay",
    icon = "#citizen-action-cuff",
    close = true,
    functiontype = "client",
    functionName = "pepe-police:client:cuff:closest",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and HasHandCuffs then
          return true
        end
  end,
 },
 [27] = {
    id = "trunk",
    displayName = "Ra xe",
    icon = "#citizen-vehicle-trunk",
    close = true,
    functiontype = "client",
    functionName = "pepe-eye:client:getout:trunk",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and exports['pepe-eye']:GetInTrunkState() then
          return true
        end
  end,
 },
 [28] = {
    id = "cardealer-menu",
    displayName = "Bán xe",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'cardealer' then
            return true
        end
    end,
    subMenus = {"cardealer:tablet"}
 },
 [29] = {
    id = "cardealer-menu",
    displayName = "Bán xe",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'cardealer2' then
            return true
        end
    end,
    subMenus = {"cardealer2:tablet"}
 },
 [30] = {
    id = "cornerselling-menu",
    displayName = "Bán hàng",
    icon = "#citizen-corner",
    functiontype = "client",
    functionName = "pepe-illegal:client:sell:to:ped",
    enableMenu = function()
        if exports['pepe-illegal']:isNearByNPC() then
            return true
        end
    end,
 },
 [31] = {
    id = "shop",
    displayName = "Cửa hàng",
    icon = "#global-store",
    close = true,
    functiontype = "client",
    functionName = "pepe-stores:server:open:shop",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-stores']:IsNearShop() then
                return true
            end
        end
  end,
 },
 [32] = {
    id = "mechanic",
    displayName = "Thợ sửa",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'mechanic' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"mechanic:repair", "mechanic:tow"}
 },
 [33] = {
    id = "police-garagemain",
    displayName = "Ga-ra CS Chính thức",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-police']:GetGarageStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty and tonumber(Framework.Functions.GetPlayerData().job.grade.level) >= 1 then
                return true
            end
        end
    end,
    subMenus = {"police:garage:police2", "police:garage:police3", "vehicle:delete"}
 },
 [34] = {
    id = "police-garageboss",
    displayName = "Ga-ra CS Trưởng",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if exports['pepe-police']:GetGarageStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.isboss then
                return true
            end
        end
    end,
    subMenus = {"police:garage:police2", "police:garage:police3", "police:garage:police4", "vehicle:delete"}
 },
 [35] = {
    id = "shop-trada",
    displayName = "Cửa hàng trà đá",
    icon = "#global-store",
    close = true,
    functiontype = "client",
    functionName = "kingwolf-trada:open:autoshop",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if GetResourceState('kingwolf-trada') == "started" and exports['kingwolf-trada']:IsNearTraDaShop() then
                return true
            end
        end
    end,
 },
 [36] = {
    id = "shop-pizza",
    displayName = "Cửa hàng pizza",
    icon = "#global-store",
    close = true,
    functiontype = "client",
    functionName = "kingwolf-pizza:open:autoshop",
    enableMenu = function()
        if not exports['pepe-hospital']:GetDeathStatus() then
            if GetResourceState('kingwolf-pizza') == "started" and exports['kingwolf-pizza']:IsNearTraDaShop() then
                return true
            end
        end
    end,
 },
}

Config.SubMenus = {
    ['police:radio:one'] = {
     title = "Radio #1",
     icon = "#police-radio",
     close = true,
     functionParameters = 1,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:enter:radio"
    },
    ['police:radio:two'] = {
     title = "Radio #2",
     icon = "#police-radio",
     close = true,
     functionParameters = 2,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:enter:radio"
    },
    ['police:radio:three'] = {
     title = "Radio #3",
     icon = "#police-radio",
     close = true,
     functionParameters = 3,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:enter:radio"
    },
    ['police:radio:four'] = {
     title = "Radio #4",
     icon = "#police-radio",
     close = true,
     functionParameters = 4,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:enter:radio"
    },
    ['police:radio:five'] = {
     title = "Radio #5",
     icon = "#police-radio",
     close = true,
     functionParameters = 5,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:enter:radio"
    },
    ['police:panic'] = {
     title = "Khẩn cấp",
     icon = "#police-action-panic",
     close = true,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:send:panic:button"
    },
    ['police:dispatch'] = {
     title = "Thông báo gần đây",
     icon = "#police-action-bell",
     close = true,
     functiontype = "server",
     functionName = "pepe-radialmenu:server:open:dispatch"
    },
    ['police:tablet'] = {
     title = "MEOS Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "pepe-police:client:show:tablet"
    },
    ['police:impound'] = {
     title = "Giam xe",
     icon = "#police-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "pepe-police:client:impound:closest"
    },
    ['police:search'] = {
     title = "Tìm kiếm",
     icon = "#police-action-search",
     close = true,
     functiontype = "client",
     functionName = "pepe-police:client:search:closest"
    },
    ['police:resetdoor'] = {
     title = "Reset Huis Deur",
     icon = "#global-appartment",
     close = true,
     functiontype = "client",
     functionName = "pepe-housing:client:reset:house:door"
    },
    ['police:enkelband'] = {
     title = "Enkelband",
     icon = "#police-action-enkelband",
     close = true,
     functiontype = "client",
     functionName = "pepe-police:client:enkelband:closest"
    },
    ['police:vehicle:touran'] = {
     title = "Politie Touran",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieTouran',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:klasse'] = {
     title = "Politie B-Klasse",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieKlasse',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:vito'] = {
     title = "Politie Vito",
     icon = "#police-action-vehicle-spawn-bus",
     close = true,
     functionParameters = 'PolitieVito',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:audi'] = {
     title = "Politie Audi",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieRS6',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:velar'] = {
     title = "Politie Unmarked Velar",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieVelar',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:bmw'] = {
     title = "Politie Unmarked M5",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieBmw',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:unmaked:audi'] = {
     title = "Politie Unmarked A6",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieAudiUnmarked',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:heli'] = {
     title = "Trực thăng cảnh sát",
     icon = "#police-action-vehicle-spawn-heli",
     close = true,
     functionParameters = 'PolitieZulu',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:vehicle:motor'] = {
     title = "Moto cảnh sát",
     icon = "#police-action-vehicle-spawn-motor",
     close = true,
     functionParameters = 'PolitieMotor',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:object:cone'] = {
     title = "Nón lưu thượng",
     icon = "#global-box",
     close = true,
     functionParameters = 'cone',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:object"
    },
    ['police:object:barrier'] = {
     title = "Rào chắn",
     icon = "#global-box",
     close = true,
     functionParameters = 'barrier',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:object"
    },
    ['police:object:schot'] = {
     title = "Chắn đạn",
     icon = "#global-box",
     close = true,
     functionParameters = 'schot',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:object"
    },
    ['police:object:tent'] = {
     title = "Lều",
     icon = "#global-tent",
     close = true,
     functionParameters = 'tent',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:object"
    },
    ['police:object:light'] = {
     title = "Trụ ddèn",
     icon = "#global-box",
     close = true,
     functionParameters = 'light',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:object"
    },
    ['police:object:delete'] = {
     title = "Xóa vật thể",
     icon = "#global-delete",
     close = false,
     functiontype = "client",
     functionName = "pepe-police:client:delete:object"
    },
    ['ambulance:heal'] = {
      title = "Hồi máu người chơi",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "pepe-hospital:client:heal:closest"
    },
    ['ambulance:revive'] = {
      title = "Hồi sinh người chơi",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "pepe-hospital:client:revive:closest"
    },
    ['ambulance:blood'] = {
      title = "Lấy máu",
      icon = "#ambulance-action-blood",
      close = true,
      functiontype = "client",
      functionName = "pepe-hospital:client:take:blood:closest"
    },
    ['ambulance:garage:heli'] = {
      title = "Máy bay cứu thương",
      icon = "#police-action-vehicle-spawn",
      close = true,
      functionParameters = 'alifeliner',
      functiontype = "client",
      functionName = "pepe-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:suvems'] = {
     title = "Xe cứu thương 2",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'kingwolfsuvems',
     functiontype = "client",
     functionName = "pepe-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:sprinter'] = {
     title = "Xe cứu thương Sprinter",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'kingwolfems',
     functiontype = "client",
     functionName = "pepe-hospital:client:spawn:vehicle"
    },
    ['police:garage:police2'] = {
     title = "Xe tuần tra 2",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'police2',
     functiontype = "client",
     functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:garage:police3'] = {
        title = "Xe tuần tra 3",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'police',
        functiontype = "client",
        functionName = "pepe-police:client:spawn:vehicle"
    },
    ['police:garage:police4'] = {
        title = "Xe tuần tra 4",
        icon = "#police-action-vehicle-spawn",
        close = true,
        functionParameters = 'police4',
        functiontype = "client",
        functionName = "pepe-police:client:spawn:vehicle"
    },
    ['vehicle:delete'] = {
     title = "Xóa xe",
     icon = "#police-action-vehicle-delete",
     close = true,
     functiontype = "client",
     functionName = "Framework:Command:DeleteVehicle"
    },
    ['cardealer:tablet'] = {
     title = "Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "pepe-cardealer:client:open:tablet"
    },
    ['cardealer2:tablet'] = {
     title = "Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "pepe-cardealer2:client:open:tablet"
    },
    ['judge:tablet'] = {
     title = "Tablet Luật sư",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "pepe-judge:client:toggle"
    },
    ['judge:job'] = {
     title = "Thuê luật sư",
     icon = "#judge-actions",
     close = true,
     functiontype = "client",
     functionName = "pepe-judge:client:lawyer:add:closest"
    },
    ['citizen:corner:selling'] = {
     title = "Corner Selling",
     icon = "#citizen-corner",
     close = true,
     functiontype = "client",
     functionName = "pepe-illegal:client:toggle:corner:selling"
    },
    ['citizen:contact'] = {
     title = "Đưa thông tin liên hệ",
     icon = "#citizen-contact",
     close = true,
     functiontype = "client",
     functionName = "pepe-phone:client:GiveContactDetails"
    },
    ['citizen:escort'] = {
     title = "Hộ tống",
     icon = "#citizen-action-escort",
     close = true,
     functiontype = "client",
     functionName = "pepe-police:client:escort:closest"
    },
    -- ['citizen:steal'] = {
    --  title = "Cướp",
    --  icon = "#citizen-action-steal",
    --  close = true,
    --  functiontype = "client",
    --  functionName = "pepe-police:client:steal:closest"
    -- },
    ['citizen:vehicle:getout'] = {
     title = "Ra xe",
     icon = "#citizen-put-out-veh",
     close = true,
     functiontype = "client",
     functionName = "pepe-police:client:SetPlayerOutVehicle"
    },
    ['citizen:vehicle:getin'] = {
     title = "Vào xe",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "pepe-police:client:PutPlayerInVehicle"
    },
    ['vehicle:flip'] = {
     title = "Lật xe",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:flip:vehicle"
    },
    ['vehicle:key'] = {
     title = "Đưa chìa khóa",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "pepe-vehiclekeys:client:give:key"
    },

    ['vehicle:door:left:front'] = {
     title = "Cửa trái trước",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 0,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:open:door"
    },
    ['vehicle:door:motor'] = {
     title = "Mở mui xe",
     icon = "#global-arrow-up",
     close = true,
     functionParameters = 4,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:open:door"
    },
    ['vehicle:door:right:front'] = {
     title = "Cửa phải trước",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 1,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:open:door"
    },
    ['vehicle:door:right:back'] = {
     title = "Cửa phải sau",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 3,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:open:door"
    },
    ['vehicle:door:trunk'] = {
     title = "Mở cốp",
     icon = "#global-arrow-down",
     close = true,
     functionParameters = 5,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:open:door"
    },
    ['vehicle:door:left:back'] = {
     title = "Cửa trái sau",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 2,
     functiontype = "client",
     functionName = "pepe-radialmenu:client:open:door"
    },


    ['tow:hook'] = {
     title = "Kéo xe",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "pepe-tow:client:hook:car"
    },
    ['tow:npc'] = {
     title = "Toggle NPC",
     icon = "#citizen-action",
     close = true,
     functiontype = "client",
     functionName = "pepe-tow:client:toggle:npc"
    },



    ['garage:putin'] = {
     title = "Cất xe",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "pepe-garages:client:check:owner"
    },
    ['garage:getout'] = {
     title = "Lấy xe",
     icon = "#citizen-put-out-veh",
     close = true,
     functiontype = "client",
     functionName = "pepe-garages:client:set:vehicle:out:garage"
    }, 
    ['house:setstash'] = {
     title = "Đặt tủ đựng đồ",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'stash',
     functiontype = "client",
     functionName = "pepe-housing:client:set:location"
    },
    ['house:setlogout'] = {
     title = "Ra ngoài",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'logout',
     functiontype = "client",
     functionName = "pepe-housing:client:set:location"
    },
    ['house:setclothes'] = {
     title = "Đặt tủ quần áo",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'clothes',
     functiontype = "client",
     functionName = "pepe-housing:client:set:location"
    },
    ['house:givekey'] = {
     title = "Đưa chìa khóa",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "pepe-housing:client:give:keys"
    },
    ['house:decorate'] = {
     title = "Trang trí",
     icon = "#global-box",
     close = true,
     functiontype = "client",
     functionName = "pepe-housing:client:decorate"
    },
    -- // Anims and Expression \\ --
    ['animations:brave'] = {
        title = "Can đảm",
        icon = "#animation-brave",
        close = true,
        functionName = "AnimSet:Brave",
        functiontype = "client",
    },
    ['animations:hurry'] = {
        title = "Vội vã",
        icon = "#animation-hurry",
        close = true,
        functionName = "AnimSet:Hurry",
        functiontype = "client",
    },
    ['animations:business'] = {
        title = "Doanh nhân",
        icon = "#animation-business",
        close = true,
        functionName = "AnimSet:Business",
        functiontype = "client",
    },
    ['animations:tipsy'] = {
        title = "Say",
        icon = "#animation-tipsy",
        close = true,
        functionName = "AnimSet:Tipsy",
        functiontype = "client",
    },
    ['animations:injured'] = {
        title = "Bị thương",
        icon = "#animation-injured",
        close = true,
        functionName = "AnimSet:Injured",
        functiontype = "client",
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        close = true,
        functionName = "AnimSet:ToughGuy",
        functiontype = "client",
    },
    ['animations:sassy'] = {
        title = "Hỗn láo",
        icon = "#animation-sassy",
        close = true,
        functionName = "AnimSet:Sassy",
        functiontype = "client",
    },
    ['animations:sad'] = {
        title = "Buồn",
        icon = "#animation-sad",
        close = true,
        functionName = "AnimSet:Sad",
        functiontype = "client",
    },
    ['animations:posh'] = {
        title = "Lịch thiệp",
        icon = "#animation-posh",
        close = true,
        functionName = "AnimSet:Posh",
        functiontype = "client",
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        close = true,
        functionName = "AnimSet:Alien",
        functiontype = "client",
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        close = true,
        functionName = "AnimSet:NonChalant",
        functiontype = "client",
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        close = true,
        functionName = "AnimSet:Hobo",
        functiontype = "client",
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        close = true,
        functionName = "AnimSet:Money",
        functiontype = "client",
    },
    ['animations:swagger'] = {
        title = "Vênh váo",
        icon = "#animation-swagger",
        close = true,
        functionName = "AnimSet:Swagger",
        functiontype = "client",
    },
    ['animations:shady'] = {
        title = "Nhẫn giả",
        icon = "#animation-shady",
        close = true,
        functionName = "AnimSet:Shady",
        functiontype = "client",
    },
    ['animations:maneater'] = {
        title = "Đàn ông chính hiệu",
        icon = "#animation-maneater",
        close = true,
        functionName = "AnimSet:ManEater",
        functiontype = "client",
    },
    ['animations:chichi'] = {
        title = "Đàn ông đích thực",
        icon = "#animation-chichi",
        close = true,
        functionName = "AnimSet:ChiChi",
        functiontype = "client",
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        close = true,
        functionName = "AnimSet:default",
        functiontype = "client",
    },
    ["expressions:angry"] = {
        title="Giận giữ",
        icon="#expressions-angry",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" },
        functiontype = "client",
    },
    ["expressions:drunk"] = {
        title="Say",
        icon="#expressions-drunk",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" },
        functiontype = "client",
    },
    ["expressions:dumb"] = {
        title="Câm",
        icon="#expressions-dumb",
        close = true,
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" },
        functiontype = "client",
    },
    ["expressions:electrocuted"] = {
        title="Tê liệt",
        icon="#expressions-electrocuted",
        close = true,
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" },
        functiontype = "client",
    },
    ["expressions:grumpy"] = {
        title="Gắt gỏng",
        icon="#expressions-grumpy",
        close = true,
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" },
        functiontype = "client",
    },
    ["expressions:happy"] = {
        title="Vui vẻ",
        icon="#expressions-happy",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" },
        functiontype = "client",
    },
    ["expressions:injured"] = {
        title="Bị thương",
        icon="#expressions-injured",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" },
        functiontype = "client",
    },
    ["expressions:joyful"] = {
        title="Hân hoan",
        icon="#expressions-joyful",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" },
        functiontype = "client",
    },
    ["expressions:mouthbreather"] = {
        title="Thở bằng mồm",
        icon="#expressions-mouthbreather",
        close = true,
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" },
        functiontype = "client",
    },
    ["expressions:normal"]  = {
        title="Bình thường",
        icon="#expressions-normal",
        close = true,
        functionName = "expressions:clear",
        functiontype = "client",
    },
    ["expressions:oneeye"]  = {
        title="Nick fury",
        icon="#expressions-oneeye",
        close = true,
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" },
        functiontype = "client",
    },
    ["expressions:shocked"]  = {
        title="Sốc",
        icon="#expressions-shocked",
        close = true,
        functionName = "expressions",
        functionParameters = { "shocked_1" },
        functiontype = "client",
    },
    ["expressions:sleeping"]  = {
        title="Ngủ",
        icon="#expressions-sleeping",
        close = true,
        functionName = "expressions",
        functionParameters = { "dead_1" },
        functiontype = "client",
    },
    ["expressions:smug"]  = {
        title="Phê",
        icon="#expressions-smug",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_smug_1" },
        functiontype = "client",
    },
    ["expressions:speculative"]  = {
        title="Suy nghĩ",
        icon="#expressions-speculative",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" },
        functiontype = "client",
    },
    ["expressions:stressed"]  = {
        title="Căng thẳng",
        icon="#expressions-stressed",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" },
        functiontype = "client",
    },
    ["expressions:sulking"]  = {
        title="Dỗi",
        icon="#expressions-sulking",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
        functiontype = "client",
    },
    ["expressions:weird"]  = {
        title="Kỳ quái",
        icon="#expressions-weird",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_2" },
        functiontype = "client",
    },
    ["expressions:weird2"]  = {
        title="Kỳ quái 2",
        icon="#expressions-weird2",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_3" },
        functiontype = "client",
    },
    -- Mechanic subMenus
    ["mechanic:repair"] = {
        title = "Sửa chữa",
        icon = "#citizen-action-vehicle",
        close = true,
        functiontype = "client",
        functionName = "pepe-repair:client:triggerMenu",
    },
    ["mechanic:tow"] = {
        title = "Kéo xe",
        icon = "#citizen-action-vehicle",
        close = true,
        functiontype = "client",
        functionName = "pepe-tow:client:hook:car",
    },
}

RegisterNetEvent('pepe-radialmenu:client:update:duty:vehicles')
AddEventHandler('pepe-radialmenu:client:update:duty:vehicles', function()
    -- Config.Menu[12].subMenus = exports['pepe-police']:GetVehicleList()
end)