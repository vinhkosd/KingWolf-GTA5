checkidentifier = 1
va = {}
BanList = {}
local StringCharset = {}

function inTable(a, b)
  a = a
  for fg, fh in pairs(a) do
      if fh == b then
          return fg
      end
  end
  return false
end

CreateThread(
  function()
      for fd, fe in pairs(KingWolfSCfg.AllObjectWhitelist) do
          table.insert(va, GetHashKey(fe))
          while true do
              Wait(2000)
              if vb == false then
                  loadBanList()
                  if BanList ~= {} then
                      print("^" .. math.random(1, 9) .. "KWAntiCheat^0: ^3Banlist loaded^0")
                      vb = true
                  else
                      print("^" .. math.random(1, 9) .. "KWAntiCheat^0: ^3Banlist loaded ^1No dâta^0")
                  end
              end
          end
      end
  end
)
function loadBanList()
    if BanList == {} then
        BanList = json.decode(LoadResourceFile(GetCurrentResourceName(), "./bans.json"))
    end
end

RegisterCommand(
  "kwreload",
  function(a)
      if a == 0 then
      elseif doesPlayerHavePerms(a, KingWolfSCfg.Admin) then
          loadBanList()
          print("^" .. math.random(1, 9) .. "KWAntiCheat^0: ^3Banlist loaded^0")
      else
          print("Insufficient Permission")
      end
  end
)


RegisterCommand(
  "kwunbanticket",
  function(source, args, rawCommand)
      if not source or source == nil or doesPlayerHavePerms(source, KingWolfSCfg.Admin) then
        unbanticket(source, args[1])
      else
          TriggerClientEvent(
              "chat:addMessage",
              source,
              {
                  args = {
                      "^" .. math.random(1, 9) .. "KWAntiCheat^0 ",
                      "Insufficient Permission"
                  }
              }
          )
      end
  end
)

RegisterCommand(
  "clearallpeds",
  function(a)
      a = a
      if doesPlayerHavePerms(a, KingWolfSCfg.Admin) then
          TriggerClientEvent("KingWolf:ClearAllPeds", math.floor(-1))
      else
          TriggerClientEvent(
              "chat:addMessage",
              a,
              {
                  args = {
                      "^" .. math.random(1, 9) .. "KWAntiCheat^0 ",
                      "Insufficient Permission"
                  }
              }
          )
          sendlog("Player: " .. GetPlayerName(a) .. " tried to /clearallpeds", "56108")
      end
  end
)
RegisterCommand(
  "clearallobjects",
  function(a)
      a = a
      if doesPlayerHavePerms(a, KingWolfSCfg.Admin) then
          TriggerClientEvent("KingWolf:ClearAllObjs", math.floor(-1))
      else
          TriggerClientEvent(
              "chat:addMessage",
              a,
              {
                  args = {
                      "^" .. math.random(1, 9) .. "KWAntiCheat^0 ",
                      "Insufficient Permission"
                  }
              }
          )
          sendlog("Player: " .. GetPlayerName(a) .. " tried to /clearallobjects", "56108")
      end
  end
)
RegisterCommand(
  "clearallvehicles",
  function(a)
      a = a
      if doesPlayerHavePerms(a, KingWolfSCfg.Admin) then
          TriggerClientEvent("KingWolf:ClearAllVehs", math.floor(-1))
      else
          TriggerClientEvent(
              "chat:addMessage",
              a,
              {
                  args = {
                      "^" .. math.random(1, 9) .. "KWAntiCheat^0 ",
                      "Insufficient Permission"
                  }
              }
          )
          sendlog("Player: " .. GetPlayerName(a) .. " tried to /clearallvehicles", "56108")
      end
  end
)
function cmdunban(a, b)
    a = a
    if b[1] ~= nil then
        TriggerClientEvent(
            "chat:addMessage",
            va,
            {
                args = {
                    "^" .. math.random(1, 9) .. "KWAntiCheat^0 ",
                    vb .. " has been unbanned"
                }
            }
        )
    end
end

function unbanticket(source, ticketId)
    local foundTicket = false
    if ticketId ~= nil then
        for fo = math.floor(1), #BanList, math.floor(1) do
  
            if tostring(BanList[fo].ticket) == tostring(ticketId) then
                BanList[fo] = nil
                if source == 0 then
                    print(ticketId .. " has been unbanned")
                else
                    TriggerClientEvent(
                        "chat:addMessage",
                        source,
                        {
                            args = {
                                "^" .. math.random(1, 9) .. "KWAntiCheat^0 ",
                                BanList[fo].ticket .. " has been unbanned"
                            }
                        }
                    )
                end
                
                foundTicket = true
            end
        end

        if not foundTicket then
            if source == 0 then
                print("Cant find the ticketId: "..ticketId)
            else
            TriggerClientEvent(
                "chat:addMessage",
                source,
                {
                    args = {
                        "^" .. math.random(1, 9) .. "KWAntiCheat^0 ",
                        "Cant find the ticketId: "..ticketId
                    }
                }
            )
            end
        end
    end
end

if KingWolfSCfg.BlacklistEvent then
  for fl = 1, #BlacklistedEvents do
      RegisterServerEvent(BlacklistedEvents[fl])
      AddEventHandler(
          BlacklistedEvents[fl],
          function()
              TriggerEvent("KingWolf:BanPlayer", source, "Blacklist event: " .. BlacklistedEvents[va])
          end
      )
  end
end
AddEventHandler(
  "chatMessage",
  function(a, b, c)
      a = a
      if KingWolfSCfg.FakeChat and b ~= GetPlayerName(a) then
          TriggerEvent("KingWolf:BanPlayer", a, "[FAKE CHAT] This player tried to say: " .. c .. " with name | " .. b)
      end
      if KingWolfSCfg.BlacklistWords then
          do
              return
          end
          while true do
              if c == "[FAKE CHAT] This player tried to say: " .. c .. " with name | " .. b then
                  TriggerEvent("KingWolf:BanPlayer", a, "Blacklisted Word: This player tried to say : **" .. c .. "**")
              end
              for fo in c:lower():gmatch(
                  "%s?" .. string.lower("[FAKE CHAT] This player tried to say: " .. c .. " with name | " .. b) .. "%s"
              ) do
                  TriggerEvent(
                      "KingWolf:BanPlayer",
                      a,
                      "Blacklisted Word: **" .. tostring(fo) .. "** | This player tried to say : **" .. c .. "**"
                  )
              end
          end
      end
  end
)
if KingWolfSCfg.MaxSpawner then
  Citizen.CreateThread(
      function()
          maxobject = {}
          maxvehicle = {}
          maxped = {}
          while true do
              Citizen.Wait(60000)
              maxobject = {}
              maxvehicle = {}
              maxped = {}
          end
      end
  )
end
if KingWolfSCfg.MaxSpawner then
  AddEventHandler(
      "entityCreating",
      function(a)
          a = a
          if DoesEntityExist(a) and KingWolfSCfg.MaxVehicle == 0 then
              if KingWolfSCfg.MaxObject ~= 0 and GetEntityType(a) == 3 then
                  maxobject[NetworkGetEntityOwner(a)] = (maxobject[NetworkGetEntityOwner(a)] or 0) + 1
                  if maxobject[NetworkGetEntityOwner(a)] > KingWolfSCfg.MaxObject then
                    checkidentifier = 2
                      TriggerEvent(
                          "KingWolf:BanPlayer",
                          NetworkGetEntityOwner(a),
                          "Player spawned objects over the allowed number: " .. maxobject[NetworkGetEntityOwner(a)]
                      )
                  end
              end
              if KingWolfSCfg.MaxVehicle ~= 0 and GetEntityType(a) == 2 then
                  maxvehicle[NetworkGetEntityOwner(a)] = (maxvehicle[NetworkGetEntityOwner(a)] or 0) + 1
                  if maxvehicle[NetworkGetEntityOwner(a)] > KingWolfSCfg.MaxVehicle then
                    checkidentifier = 3
                      TriggerEvent(
                          "KingWolf:BanPlayer",
                          NetworkGetEntityOwner(a),
                          "Player spawned vehicles over the allowed number: " .. maxvehicle[NetworkGetEntityOwner(a)]
                      )
                  end
              end
              if KingWolfSCfg.MaxPed ~= 0 and GetEntityType(a) == 1 then
                  maxped[NetworkGetEntityOwner(a)] = (maxped[NetworkGetEntityOwner(a)] or 0) + 1
                  if maxped[NetworkGetEntityOwner(a)] > KingWolfSCfg.MaxPed then
                    checkidentifier = 4
                      TriggerEvent(
                          "KingWolf:BanPlayer",
                          NetworkGetEntityOwner(a),
                          "Player spawned peds over the allowed number: " .. maxped[NetworkGetEntityOwner(a)]
                      )
                  end
              end
          end
      end
  )
end
AddEventHandler(
  "entityCreating",
  function(a)
      a = a
      if DoesEntityExist(a) then
          if NetworkGetEntityOwner(a) == nil then
              CancelEvent()
          end
          if KingWolfSCfg.ObjectDetect then
              if KingWolfSCfg.AllObject then
                  if GetEntityType(a) == 3 and inTable(va, (GetEntityModel(a))) == false then
                      CancelEvent()
                  end
              else
                  for fh, fj in ipairs(BlacklistedObject) do
                      if GetEntityModel(a) == GetHashKey(fj) then
                          CancelEvent()
                          if KingWolfSCfg.ObjectBan then
                              Wait(1000)
                              TriggerEvent("KingWolf:BanPlayer", NetworkGetEntityOwner(a), "Object: " .. fj)
                          elseif KingWolfSCfg.ObjectsLog then
                              sendlog(
                                  GetPlayerName((NetworkGetEntityOwner(a))) ..
                                      " | Detected Object: " ..
                                          fj .. " | The user created this object and got detected",
                                  "16744192"
                              )
                          end
                      end
                  end
              end
          end
          if KingWolfSCfg.BlacklistPed then
              for fh, fj in ipairs(BlacklistedPeds) do
                  if GetEntityModel(a) == GetHashKey(fj) then
                    local owner = NetworkGetEntityOwner(a)
                    if false then
                        
                        Citizen.CreateThread(function()
                            Wait(50)
                            TriggerEvent("KingWolf:BanPlayer", owner, "Try to spawn Blacklisted Peds: " .. fj)
                        end)
                        
                    elseif KingWolfSCfg.PedsLog then
                          sendlog(
                              GetPlayerName(owner) ..
                                  " | Detected Ped: " .. fj .. " | The user created this ped and got detected",
                              "8434611"
                          )
                      end
                      CancelEvent()
                  end
              end
          end
          if KingWolfSCfg.BlacklistVeh then
              for fh, fj in ipairs(BlacklistedVehicle) do
                  if GetEntityModel(a) == GetHashKey(fj) then
                    local owner = NetworkGetEntityOwner(a)
                    if KingWolfSCfg.BlacklistVehBan then
                        Citizen.CreateThread(function()
                            Wait(50)
                            TriggerEvent("KingWolf:BanPlayer", owner, "Try to spawn Blacklisted vehicles: " .. fj)
                        end)
                    elseif KingWolfSCfg.VehiclesLog then
                        sendlog(
                            GetPlayerName((owner)) ..
                                " | Detected Vehicle: " .. fj .. " | The user created this vehicle and got detected",
                            "8408397"
                        )
                    end
                    CancelEvent()
                  end
              end
          end
      end
  end
)
AddEventHandler(
  "giveWeaponEvent",
  function(a, b)
      a = a
      if KingWolfSCfg.WeaponDetected then
          for fg, fh in ipairs(BlacklistedWeapons) do
              if GetHashKey(fh) == b.weaponType then
                  CancelEvent()
                  Wait(3000)
                  TriggerEvent("KingWolf:BanPlayer", a, "Player tried to give a Blacklisted Weapon: **" .. fh .. "**")
              end
          end
      end
  end
)
AddEventHandler(
  "removeAllWeaponEvent",
  function(a, b)
      a = a
      print(a .. " removeAllWeapon")
  end
)
AddEventHandler(
  "removeWeaponEvent",
  function(a, b)
      a = a
      print(a .. " removeWeapon")
  end
)
AddEventHandler(
  "clearPedTasksEvent",
  function(a, b)
      a = a
      if KingWolfSCfg.ClearDetected and b.immediately and not doesPlayerHavePerms(a, KingWolfSCfg.Admin) then
          CancelEvent()
          if KingWolfSCfg.ClearDetectedBan then
              TriggerEvent("KingWolf:BanPlayer", a, "Player tried to ClearPedTasks on another players")
          end
      end
  end
)
AddEventHandler(
  "explosionEvent",
  function(a, b)
      a = a
      if KingWolfSCfg.ExplosionsAC then
          if ExplosionsList[b.explosionType] then
              if ExplosionsList[b.explosionType].log and not ExplosionsList[b.explosionType].ban then
                  sendlog(
                      GetPlayerName(a) ..
                          " | Detected Explosion: " ..
                              ExplosionsList[b.explosionType].name ..
                                  " | The user created this explosion and got detected",
                      "8421504"
                  )
              end
              if ExplosionsList[b.explosionType].ban then
                  TriggerEvent(
                      "KingWolf:BanPlayer",
                      a,
                      "Detected Explosion: " .. ExplosionsList[b.explosionType].name,
                      " | The user created this explosion and got detected"
                  )
              end
          end
          CancelEvent()
      end
      for fg, fh in ipairs(ExplosionsCancel) do
          if b.explosionType == fh then
              CancelEvent()
          end
      end
  end
)
RegisterServerEvent("KingWolf:DetectAntiBlips")
AddEventHandler(
  "KingWolf:DetectAntiBlips",
  function()
      if not doesPlayerHavePerms(source, KingWolfSCfg.Blips) then
          TriggerEvent("KingWolf:BanPlayer", source, "This player tried to enable playerblips")
      end
  end
)
RegisterServerEvent("KingWolf:DetectGodMode")
AddEventHandler(
  "KingWolf:DetectGodMode",
  function(a)
      a = a
  end
)
RegisterServerEvent("KingWolf:DetectBlackListKeys")
AddEventHandler(
  "KingWolf:DetectBlackListKeys",
  function(a)
      a = a 
  end
)
RegisterServerEvent("KingWolf:DetectKeysBlackList")
AddEventHandler(
  "KingWolf:DetectKeysBlackList",
  function(a, b)
      a = a
      for fr, fs in ipairs(GetPlayerIdentifiers(source)) do
          if string.sub(fs, math.floor(1), string.len("steam:")) == "steam:" then
          elseif string.sub(fs, math.floor(1), string.len("license:")) == "license:" then
          elseif string.sub(fs, math.floor(1), string.len("live:")) == "live:" then
          elseif string.sub(fs, math.floor(1), string.len("xbl:")) == "xbl:" then
          elseif string.sub(fs, math.floor(1), string.len("discord:")) == "discord:" then
          else
          end
      end
      sendlogg(
          "**Player:** " ..
              GetPlayerName(source) ..
                  [[

**ServerID: **]] ..
                      source ..
                          [[

**SteamID:** ]] ..
                              fs ..
                                  [[

**Steam Link:** ]] ..
                                      ("https://steamcommunity.com/profiles/" ..
                                          tostring(tonumber(fs:gsub("steam:", ""), 16))) ..
                                          [[

**License:** ]] ..
                                              fs ..
                                                  [[

**LiveID:** ]] ..
                                                      fs ..
                                                          [[

**XboxID:** ]] ..
                                                              fs ..
                                                                  [[

**DiscordID:** ]] ..
                                                                      fs ..
                                                                          [[

**Discord Tag:** <@]] ..
                                                                              fs:gsub("discord:", "") ..
                                                                                  [[
>
**IP:** ]] ..
                                                                                      fs ..
                                                                                          [[

**Reason:** ]] ..
                                                                                              "This player pressed a blacklist key: **" ..
                                                                                                  a .. "**",
          "11750815"
      )
      Wait(500)
      sendimg(b)
  end
)
function sendlogg(a, b)
  a = a
  PerformHttpRequest(
      KingWolfSCfg.ScreenWebhook,
      function(a, b, c)
          a = a
      end,
      "POST",
      json.encode(
          {
              username = KingWolfSCfg.ServerName,
              embeds = {
                  {
                      color = b,
                      title = "KWAntiCheat - FiveM Anticheat",
                      description = a,
                      footer = {
                          text = KingWolfSCfg.ServerName
                      }
                  }
              },
              avatar_url = KingWolfSCfg.Logo
          }
      ),
      {
          ["Content-Type"] = "application/json"
      }
  )
end
function sendimg(a)
  a = a
  PerformHttpRequest(
      KingWolfSCfg.ScreenWebhook,
      function(a, b, c)
          a = a
      end,
      "POST",
      json.encode(
          {
              username = KingWolfSCfg.ServerName,
              content = a,
              avatar_url = KingWolfSCfg.Logo
          }
      ),
      {
          ["Content-Type"] = "application/json"
      }
  )
end
RegisterServerEvent("KingWolf:ServerLogs")
AddEventHandler(
  "KingWolf:ServerLogs",
  function(a)
      a = a
      sendlog(GetPlayerName(source) .. " | This player has a blacklist weapon: **" .. a .. "**", "56108")
  end
)
RegisterServerEvent("KingWolf:BanPlayer")
AddEventHandler(
  "KingWolf:BanPlayer",
  function(a, b)
      a = a
      for fr, fs in ipairs(GetPlayerIdentifiers(a)) do
          if string.sub(fs, math.floor(1), string.len("steam:")) == "steam:" then
          elseif string.sub(fs, math.floor(1), string.len("license:")) == "license:" then
          elseif string.sub(fs, math.floor(1), string.len("live:")) == "live:" then
          elseif string.sub(fs, math.floor(1), string.len("xbl:")) == "xbl:" then
          elseif string.sub(fs, math.floor(1), string.len("discord:")) == "discord:" then
          else
          end
      end
      local steamid = GetPlayerIdentifiers(a)[1]
      local licenseid = GetPlayerIdentifiers(a)[2]
      local discordid = GetPlayerIdentifiers(a)[3]
      local ip  = GetPlayerIdentifiers(a)[6]
      ban(a, steamid, licenseid, fs, fs, discordid, ip, GetPlayerName(a), "No reason")
  end
)
BanList = {}
oneetimer = {}
function ban(a, b, c, d, e, g, h, j, k)
    local ticketId = RandomStr(10)
    if checkidentifier >= 0 then
        SaveResourceFile(GetCurrentResourceName(), "./bans.json", json.encode(BanList), -1)
        return
    end
  a = a
  if not oneetimer[a] then
      table.insert(
          BanList,
          {
              identifier = b,
              license = c,
              liveid = d,
              xblid = e,
              discord = g,
              playerip = h,
              reason = k,
              ticket = ticketId,
          }
      )
      sendban(
          "**Player:** " ..
              j ..
                  [[

**ServerID: **]] ..
                      a ..
                          [[

**SteamID:** ]] ..
                              b ..
                                  [[

**Steam Link:** ]] ..
                                      ("https://steamcommunity.com/profiles/" ..
                                          tostring(tonumber(b:gsub("steam:", ""), 16))) ..
                                          [[

**License:** ]] ..
                                              c ..
                                                  [[

**LiveID:** ]] ..
                                                      "" ..
                                                          [[

**XboxID:** ]] ..
                                                              "" ..
                                                                  [[

**DiscordID:** ]] ..
                                                                      g ..
                                                                          [[

**Discord Tag:** <@]] ..
                                                                              g:gsub("discord:", "") ..
                                                                                  [[
>
**IP:** ]] ..
                                                                                      h .. [[

**Reason:** ]] .. k,
          "11750815"
      )
      sendcheat(
          ("**Player:** " ..
              j ..
                  [[

**ServerID: **]] ..
                      a ..
                          [[

**SteamID:** ]] ..
                              b ..
                                  [[

**Steam Link:** ]] ..
                                      ("https://steamcommunity.com/profiles/" ..
                                          tostring(tonumber(b:gsub("steam:", ""), 16))) ..
                                          [[

**License:** ]] ..
                                              c ..
                                                  [[

**LiveID:** ]] ..
                                                      "" ..
                                                          [[

**XboxID:** ]] ..
                                                              "" ..
                                                                  [[

**DiscordID:** ]] ..
                                                                      g ..
                                                                          [[

**Discord Tag:** <@]] ..
                                                                              g:gsub("discord:", "") ..
                                                                                  [[
>
**IP:** ]] ..
                                                                                      h .. [[

**Reason:** ]] .. k) ..
              " | " .. KingWolfSCfg.DiscordNote,
          "16711680"
      )
      oneetimer[a] = true
      print("^" .. math.random(1, 9) .. "KWAntiCheat^0: ^3Banlist loaded")
  end
end
RegisterServerEvent("KingWolf:BanInject")
AddEventHandler(
  "KingWolf:BanInject",
  function(a)
      a = a
      if not doesPlayerHavePerms(source, KingWolfSCfg.Admin) then
          TriggerEvent("KingWolf:BanPlayer", source, a)
      end
  end
)
RegisterServerEvent("KingWolf:BanPlayers:jjhjxjzj")
AddEventHandler(
  "KingWolf:BanPlayers:jjhjxjzj",
  function(a)
      a = a
      if not doesPlayerHavePerms(source, KingWolfSCfg.Admin) then
          TriggerEvent("KingWolf:BanPlayer", source, a)
      end
  end
)
function Vl(a, b)
  a = a
  for fg, fh in ipairs(KingWolfSCfg.BlackListNamesTables) do
      if string.find(string.lower(a), string.lower(fh)) then
          b("[KINGWOLFANTICHEAT] - " .. KingWolfSCfg.NamesKickReason .. ": " .. tostring(fh))
          sendlog("Player **" .. a .. "** tried to connect with a blacklist name: " .. tostring(fh))
          sendcheat("Player **" .. a .. "** tried to connect with a blacklist name: " .. tostring(fh))
          CancelEvent()
      end
  end
end
AddEventHandler(
  "playerConnecting",
  function(a, b)
      a = a
      if KingWolfSCfg.BlacklistNames then
          Vl(a, b)
      end
      for fo, fp in ipairs(GetPlayerIdentifiers(source)) do
          if string.sub(fp, math.floor(1), string.len("steam:")) == "steam:" then
          elseif string.sub(fp, math.floor(1), string.len("license:")) == "license:" then
          elseif string.sub(fp, math.floor(1), string.len("live:")) == "live:" then
          elseif string.sub(fp, math.floor(1), string.len("xbl:")) == "xbl:" then
          elseif string.sub(fp, math.floor(1), string.len("discord:")) == "discord:" then
          else
          end
      end
      for fo = math.floor(1), #BanList, math.floor(1) do
          local steamid = GetPlayerIdentifiers(source)[1]
          local licenseid = GetPlayerIdentifiers(source)[2]
          local discordid = GetPlayerIdentifiers(source)[3]
          local ip  = GetPlayerIdentifiers(source)[6]

          if tostring(BanList[fo].identifier) == tostring(steamid) or tostring(licenseid) == tostring(BanList[fo].license) or tostring(discordid) == tostring(BanList[fo].discord) then
            b("[KINGWOLFANTICHEAT] - " .. KingWolfSCfg.KickMessage.." Your Ticket ID is "..(BanList[fo].ticket and BanList[fo].ticket or ""))
              print(
                  "^" ..
                      math.random(1, 9) ..
                          "KWAntiCheat^0: ^3Player: " ..
                              GetPlayerName(source) ..
                                  " tried to connect when banned ^1(" .. BanList[fo].identifier .. ")^0"
              )
              sendlog(
                  "KWAntiCheat^0: Player: " ..
                      GetPlayerName(source) .. " tried to connect when banned (" .. BanList[fo].identifier .. ")",
                  "16711680"
              )
              sendcheat(
                  "KWAntiCheat^0: Player: " ..
                      GetPlayerName(source) .. " tried to connect when banned (" .. BanList[fo].identifier .. ")",
                  "16711680"
              )
              CancelEvent()
          end
          if tostring(BanList[fo].playerip) == ip then
              b("[KINGWOLFANTICHEAT] - " .. KingWolfSCfg.KickMessage.." Your Ticket ID is "..(BanList[fo].ticket and BanList[fo].ticket or ""))
              print(
                  "^" ..
                      math.random(1, 9) ..
                          "KWAntiCheat^0: ^3Player: " ..
                              GetPlayerName(source) ..
                                  " tried to connect when banned ^1(" .. BanList[fo].identifier .. ")^0"
              )
              sendlog(
                  "KWAntiCheat^0: Player: " ..
                      GetPlayerName(source) .. " tried to connect when banned (" .. BanList[fo].identifier .. ")",
                  "16711680"
              )
              sendcheat(
                  "KWAntiCheat^0: Player: " ..
                      GetPlayerName(source) .. " tried to connect when banned (" .. BanList[fo].identifier .. ")",
                  "16711680"
              )
              CancelEvent()
          end
      end
  end
)
function doesPlayerHavePerms(a, b)
    if a ==0 then
        return true
    end

    for fh, fj in ipairs(b) do
        if IsPlayerAceAllowed(a, fj) then
            return true
        end
    end
  return false
end
Citizen.CreateThread(
  function()
      Citizen.Wait(15000)
      if LoadResourceFile(GetCurrentResourceName(), "configs/config-cl.lua") then
      end
      if LoadResourceFile(GetCurrentResourceName(), "configs/config-cl.lua") == "" then
          print(
              "^" ..
                  math.random(1, 9) ..
                      "KWAntiCheat^0:^1 configs/config-cl.lua Missing, Please make sure you installed KWAntiCheat correctly.^0"
          )
          Wait(5000)
          print("^" .. math.random(1, 9) .. "KWAntiCheat^0:^1 Destroy server.^0")
          StopResource(GetCurrentResourceName())
          Wait(5000)
          os.exit(-1)
      elseif KingWolfCfg == nil then
          print(
              "^" ..
                  math.random(1, 9) ..
                      "KWAntiCheat^0:^1 configs/config-cl.lua Corrupted, Please make sure you installed KWAntiCheat correctly.^0"
          )
          Wait(5000)
          print("^" .. math.random(1, 9) .. "KWAntiCheat^0:^1 Destroy server.^0")
          StopResource(GetCurrentResourceName())
          Wait(5000)
          os.exit(-1)
      end
      if LoadResourceFile(GetCurrentResourceName(), "DoNotTouch.lua") then
      end
      if LoadResourceFile(GetCurrentResourceName(), "DoNotTouch.lua") == "" then
          print(
              "^" ..
                  math.random(1, 9) ..
                      "KWAntiCheat^0:^1 DoNotTouch.lua Missing, Please make sure you installed KWAntiCheat correctly.^0"
          )
          Wait(5000)
          print("^" .. math.random(1, 9) .. "KWAntiCheat^0:^1 Destroy server.^0")
          StopResource(GetCurrentResourceName())
          Wait(5000)
          os.exit(-1)
      end
      if LoadResourceFile(GetCurrentResourceName(), "installer.lua") then
      end
      if LoadResourceFile(GetCurrentResourceName(), "installer.lua") == "" then
          print(
              "^" ..
                  math.random(1, 9) ..
                      "KWAntiCheat^0:^1 installer.lua Missing, Please make sure you installed KWAntiCheat correctly.^0"
          )
          Wait(5000)
          print("^" .. math.random(1, 9) .. "KWAntiCheat^0:^1 Destroy server.^0")
          StopResource(GetCurrentResourceName())
          Wait(5000)
          os.exit(-1)
      end
  end
)
non = {}
RegisterNetEvent("KingWolf:AntiResourceStops")
AddEventHandler(
  "KingWolf:AntiResourceStops",
  function()
      if not non[source] then
          TriggerClientEvent(
              "KingWolf:client:InitAntiCheat",
              source,
              LoadResourceFile(GetCurrentResourceName(), "configs/config-cl.lua")
          )
        --   TriggerClientEvent(
        --       "KingWolf:StartAntiInject",
        --       source,
        --       'local a=GetCurrentResourceName()e={}InSec={}Plane={}OnionUI={}CKgang={}local b="vrp"local c="server"local d="client"local f="alex"local g="vrp"local h="server"local i="client"local j="alex"local k="emp"Citizen.CreateThread(function()Citizen.Wait(2000)while true do Citizen.Wait(2000)for l,m in next,_G do if type(m)=="table"and l~="exports"then if m.CreateMenu~=nil and type(m.CreateMenu)=="function"then if l~="WarMenu"and l~="vRP"and l~="NativeUI"and l~="RageUI"and l~="JayMenu"and l~="VEM"and l~="VLM"and l~="func"and not string.match(l:lower(),g:lower())and not string.match(l:lower(),h:lower())and not string.match(l:lower(),i:lower())and not string.match(l:lower(),j:lower())and not string.match(l:lower(),k:lower())then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","This player injected a mod menu in **"..a.."** : "..l)end elseif m.InitializeTheme~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","\173This player injected a mod menu in **"..a.."** : "..l)end end end;if Plane.Create~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(01) Detected a mod menu in **"..a.."**")elseif e.debug~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(02) Detected a mod menu in **"..a.."**")elseif InSec.Logo~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(03) Detected a mod menu in **"..a.."**")elseif MaestroEra~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(04) Detected a mod menu in **"..a.."**")elseif OnionUI.CreateUI~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(05) Detected a mod menu in **"..a.."**")elseif CKgang.Button2~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(06) Detected a mod menu in **"..a.."**")elseif nofuckinglol~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(07) Detected a mod menu in **"..a.."**")elseif LDOWJDWDdddwdwdad~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(08) Detected a mod menu in **"..a.."**")elseif HoaxMenu~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(11) Detected a mod menu in **"..a.."**")elseif nukeserver~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(12) Detected a mod menu in **"..a.."**")elseif RapeAllFunc~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(18) Detected a mod menu in **"..a.."**")elseif CrashPlayer~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(19) Detected a mod menu in **"..a.."**")elseif bananaparty~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(25) Detected a mod menu in **"..a.."**")elseif destroyserverdb~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(26) Detected a mod menu in **"..a.."**")elseif INFINITY~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(32) Detected a mod menu in **"..a.."**")elseif INFINITY2337~=nil then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","(34) Detected a mod menu in **"..a.."**")end end end)RegisterNetEvent("IS:Sdstopmbean")AddEventHandler("IS:Sdstopmbean",function(n)Citizen.CreateThread(function()while true do Citizen.Wait(2000)if GetResourceState(n)~="started"then TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj","AntiResourceStop: This player tried to block anticheat _(DONT START OR RESTART RESOURCES)_")end end end)end)\n'
        --   )
          non[source] = true
          if KingWolfCfg.AntiResourceStop then
              TriggerClientEvent("IS:Sdstopmbean", source, GetCurrentResourceName())
          end
      else
          return
      end
  end
)
RegisterNetEvent("fretanoisaa")
AddEventHandler(
  "fretanoisaa",
  function()
      TriggerClientEvent("fretanoisa", source)
  end
)

function sendlog(a, b)
  a = a
  PerformHttpRequest(
      KingWolfSCfg.LogWebhook,
      function(a, b, c)
          a = a
      end,
      "POST",
      json.encode(
          {
              username = KingWolfSCfg.ServerName,
              embeds = {
                  {
                      color = b,
                      title = "KWAntiCheat - FiveM Anticheat",
                      description = a,
                      footer = {
                          text = KingWolfSCfg.ServerName
                      }
                  }
              },
              avatar_url = KingWolfSCfg.Logo
          }
      ),
      {
          ["Content-Type"] = "application/json"
      }
  )
end
function sendban(a, b)
  a = a
  PerformHttpRequest(
      KingWolfSCfg.BanWebhook,
      function(a, b, c)
          a = a
      end,
      "POST",
      json.encode(
          {
              username = KingWolfSCfg.ServerName,
              embeds = {
                  {
                      color = b,
                      title = "KWAntiCheat - FiveM Anticheat",
                      description = a,
                      footer = {
                          text = KingWolfSCfg.ServerName
                      }
                  }
              },
              avatar_url = KingWolfSCfg.Logo
          }
      ),
      {
          ["Content-Type"] = "application/json"
      }
  )
end
function sendcheat(a, b)
  a = a
  PerformHttpRequest(
      "",
      function(a, b, c)
          a = a
      end,
      "POST",
      json.encode(
          {
              username = KingWolfSCfg.ServerName,
              embeds = {
                  {
                      color = b,
                      title = "KWAntiCheat - FiveM Anticheat",
                      description = a,
                      footer = {
                          text = "KWAntiCheat - FiveM Anticheat"
                      }
                  }
              },
              avatar_url = KingWolfSCfg.Logo
          }
      ),
      {
          ["Content-Type"] = "application/json"
      }
  )
end

for i = 48,  57 do table.insert(StringCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

function RandomStr(length)
	if length > 0 then
		return RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end