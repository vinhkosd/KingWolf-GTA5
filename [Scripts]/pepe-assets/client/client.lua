local DisplayCount = 0
DisableSeatShuff = true
Framework = nil

LoggedIn = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
  TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 
  Citizen.Wait(150)
  SetDiscordButtons()
  NetworkSetFriendlyFireOption(true)
  SetCanAttackFriendly(PlayerPedId(), true, true)
  LoggedIn = true
end)

-- Code

-- // Events \\ --
-- Pvp Enable

function SetDiscordButtons()
  SetDiscordRichPresenceAction(0, 'Vào server', 'fivem://connect/gx7ojo')
  SetDiscordRichPresenceAction(1, 'Link Discord', 'https://discord.gg/DHntjapreK')
end

RegisterNetEvent('pepe-assets:client:seat:shuffle')
AddEventHandler('pepe-assets:client:seat:shuffle', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1)) then
    DisableSeatShuff = false
    Citizen.Wait(5000)
    DisableSeatShuff = true
  else
    CancelEvent()
  end
end)

RegisterNetEvent('pepe-assets:client:me:show')
AddEventHandler('pepe-assets:client:me:show', function(Text, Source)
  local PlayerId = GetPlayerFromServerId(Source)
  local IsDisplaying = true
  Citizen.CreateThread(function()
    local DisplayOffset = 0 + (DisplayCount * 0.14)
    DisplayCount = DisplayCount + 1
    while IsDisplaying do
      Citizen.Wait(0)
      local SourceCoords = GetEntityCoords(GetPlayerPed(PlayerId))
      local NearCoords = GetEntityCoords(PlayerPedId())
      local Distance = Vdist2(SourceCoords, NearCoords)
      if Distance < 25.0 then
        DrawText3D(SourceCoords.x, SourceCoords.y, SourceCoords.z + DisplayOffset, Text)
      end
    end
    DisplayCount = DisplayCount - 1
  end)
  Citizen.CreateThread(function()
   Citizen.Wait(6500)
   IsDisplaying = false
  end)
end)

RegisterNetEvent('pepe-assets:client:me:init')
AddEventHandler('pepe-assets:client:me:init', function(text, source)
  local coords = GetEntityCoords(GetPlayerPed(-1))
  TriggerServerEvent("pepe-assets:server:display:chatme", text, coords, source)
end)

RegisterNetEvent('pepe-assets:client:display:chatme')
AddEventHandler('pepe-assets:client:display:chatme', function(Text, coords, Source)
  local PlayerId = GetPlayerFromServerId(Source)
  local IsDisplaying = true
  Citizen.CreateThread(function()
    local DisplayOffset = 0 + (DisplayCount * 0.14)
    DisplayCount = DisplayCount + 1
    while IsDisplaying do
      Citizen.Wait(0)
      local SourceCoords = GetEntityCoords(GetPlayerPed(PlayerId))
      local NearCoords = GetEntityCoords(PlayerPedId())
      print(GetPlayerPed(PlayerId).."="..PlayerPedId())
      local Distance = Vdist2(coords, NearCoords)
      if Distance < 25.0 then
        DrawText3D(SourceCoords.x, SourceCoords.y, SourceCoords.z + DisplayOffset, Text)
      end
    end
    DisplayCount = DisplayCount - 1
  end)
  Citizen.CreateThread(function()
   Citizen.Wait(6500)
   IsDisplaying = false
  end)
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Blips) do
      Blips = AddBlipForCoord(Config.Blips[k]['X'], Config.Blips[k]['Y'], Config.Blips[k]['Z'])
      SetBlipSprite (Blips, Config.Blips[k]['SpriteId'])
      SetBlipDisplay(Blips, 4)
      SetBlipScale  (Blips, Config.Blips[k]['Scale'])
      SetBlipAsShortRange(Blips, true)
      SetBlipColour(Blips, Config.Blips[k]['Color'])
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentSubstringPlayerName(Config.Blips[k]['Name'])
      EndTextCommandSetBlipName(Blips)
    end
end)

function AddBlipToCoords(Coords, Sprite, Scale, Color, Text)
  Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
  SetBlipSprite (Blips, Sprite)
  SetBlipDisplay(Blips, 4)
  SetBlipScale  (Blips, Scale)
  SetBlipAsShortRange(Blips, true)
  SetBlipColour(Blips, Color)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentSubstringPlayerName(Text)
  EndTextCommandSetBlipName(Blips)
end

-- // Brighter Lights \\ --
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

Citizen.CreateThread(function()
	local settingsFile = LoadResourceFile(GetCurrentResourceName(), "misc/visualsettings.dat")
	local lines = stringsplit(settingsFile, "\n")
	for k,v in ipairs(lines) do
		if not starts_with(v, '#') and not starts_with(v, '//') and (v ~= "" or v ~= " ") and #v > 1 then
			v = v:gsub("%s+", " ")
			local setting = stringsplit(v, " ")
			if setting[1] ~= nil and setting[2] ~= nil and tonumber(setting[2]) ~= nil then
				if setting[1] ~= 'weather.CycleDuration' then	
					Citizen.InvokeNative(GetHashKey('SET_VISUAL_SETTING_FLOAT') & 0xFFFFFFFF, setting[1], tonumber(setting[2])+.0)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_UNARMED'), 0.3)
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_NIGHTSTICK'), 0.3)
	-- Melee
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_FLASHLIGHT'), 0.4)
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_HAMMER'), 0.4)
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_HATCHET'), 0.4)
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_SWITCHBLADE'), 0.4)
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_WRENCH'), 0.4)
	SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_BREAD'), 0.4)
  SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_CROWBAR'), 0.05)

  N_0x4757f00bc6323cfe(GetHashKey('WEAPON_UNARMED'), 0.3)
	N_0x4757f00bc6323cfe(GetHashKey('WEAPON_NIGHTSTICK'), 0.3)
	-- Melee
	N_0x4757f00bc6323cfe(GetHashKey('WEAPON_FLASHLIGHT'), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey('WEAPON_HAMMER'), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey('WEAPON_HATCHET'), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey('WEAPON_SWITCHBLADE'), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey('WEAPON_WRENCH'), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey('WEAPON_BREAD'), 0.4)
  N_0x4757f00bc6323cfe(GetHashKey('WEAPON_CROWBAR'), 0.05)
end)

RegisterNUICallback('CheckDevtools', function()
   TriggerServerEvent('pepe-assets:server:drop')
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end