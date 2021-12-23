Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local Casings = {}
local HairDrops = {}
local BloodDrops = {}
local SlimeDrops = {}
local FingerDrops = {}
local PlayerStatus = {}
local PlayerStatus = {}
local Objects = {}

RegisterServerEvent('pepe-police:server:UpdateBlips')
AddEventHandler('pepe-police:server:UpdateBlips', function()
    -- local src = source
    -- local dutyPlayers = {}
    -- for k, v in pairs(Framework.Functions.GetPlayers()) do
    --     local Player = Framework.Functions.GetPlayer(v)
    --     ped = GetPlayerPed(v)
    --     pedCoords = GetEntityCoords(ped)
    --     if Player ~= nil then 
    --         if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
    --             table.insert(dutyPlayers, {
    --                 source = Player.PlayerData.source,
    --                 label = Player.PlayerData.metadata["callsign"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
    --                 job = Player.PlayerData.job.name,
    --                 coords = pedCoords,
    --                 ped = ped,
    --             })
    --         end
    --     end
    -- end
    -- TriggerClientEvent("pepe-police:client:UpdateBlips", -1, dutyPlayers)
    --no affect when player join
end)

function updateBlips()
    local dutyPlayers = {}
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        ped = GetPlayerPed(v)
        pedCoords = GetEntityCoords(ped)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
                    job = Player.PlayerData.job.name,
                    coords = pedCoords,
                    ped = ped,
                })
            end
        end
    end

    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("pepe-police:client:UpdateBlips", Player.PlayerData.source, dutyPlayers)
            end
        end
    end
end

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(0)
    local CurrentCops = GetCurrentCops()
    TriggerClientEvent("pepe-police:SetCopCount", -1, CurrentCops)
    Citizen.Wait(1000 * 60 * 10)
  end
end)

Citizen.CreateThread(function()
    while true do 
      Citizen.Wait(0)
      updateBlips() 
      Citizen.Wait(1000)
    end
end)

-- // Functions \\ --

function IsVehicleOwned(plate)
    local val = false
	Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
		else
			val = false
		end
	end)
	return val
end
function GetCurrentCops()
    local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

-- // Evidence Events \\ --

Framework.Functions.CreateCallback('pepe-police:GetPlayerStatus', function(source, cb, playerId)
    local Player = Framework.Functions.GetPlayer(playerId)
    local statList = {}
	if Player ~= nil then
        if PlayerStatus[Player.PlayerData.source] ~= nil and next(PlayerStatus[Player.PlayerData.source]) ~= nil then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                table.insert(statList, PlayerStatus[Player.PlayerData.source][k].text)
            end
        end
	end
    cb(statList)
end)

RegisterServerEvent('pepe-police:server:CreateCasing')
AddEventHandler('pepe-police:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local casingId = CreateIdType('casing')
    local weaponInfo = exports['pepe-weapons']:GetWeaponList(weapon)
    local serieNumber = nil
    if weaponInfo ~= nil then 
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["IdName"])
        if weaponItem ~= nil then
            if weaponItem.info ~= nil and weaponItem.info ~= "" then 
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("pepe-police:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)

RegisterServerEvent('pepe-police:server:CreateBloodDrop')
AddEventHandler('pepe-police:server:CreateBloodDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local bloodId = CreateIdType('blood')
 BloodDrops[bloodId] = Player.PlayerData.metadata["bloodtype"]
 TriggerClientEvent("pepe-police:client:AddBlooddrop", -1, bloodId, Player.PlayerData.metadata["bloodtype"], coords)
end)

RegisterServerEvent('pepe-police:server:CreateFingerDrop')
AddEventHandler('pepe-police:server:CreateFingerDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local fingerId = CreateIdType('finger')
 FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
 TriggerClientEvent("pepe-police:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('pepe-police:server:CreateHairDrop')
AddEventHandler('pepe-police:server:CreateHairDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local HairId = CreateIdType('hair')
 HairDrops[HairId] = Player.PlayerData.metadata["haircode"]
 TriggerClientEvent("pepe-police:client:AddHair", -1, HairId, Player.PlayerData.metadata["haircode"], coords)
end)

RegisterServerEvent('pepe-police:server:CreateSlimeDrop')
AddEventHandler('pepe-police:server:CreateSlimeDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local SlimeId = CreateIdType('slime')
 SlimeDrops[SlimeId] = Player.PlayerData.metadata["slimecode"]
 TriggerClientEvent("pepe-police:client:AddSlime", -1, SlimeId, Player.PlayerData.metadata["slimecode"], coords)
end)

RegisterServerEvent('pepe-police:server:AddEvidenceToInventory')
AddEventHandler('pepe-police:server:AddEvidenceToInventory', function(EvidenceType, EvidenceId, EvidenceInfo)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
    if Player.Functions.AddItem("filled_evidence_bag", 1, false, EvidenceInfo) then
        RemoveDna(EvidenceType, EvidenceId)
        TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, EvidenceType, EvidenceId)
        TriggerClientEvent("pepe-inventory:client:ItemBox", src, Framework.Shared.Items["filled_evidence_bag"], "add")
    
        Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"]+1)
    end
 else
    TriggerClientEvent('Framework:Notify', src, "Bạn phải có một túi bằng chứng trống với bạn...", "error")
 end
end)


RegisterServerEvent('pepe-police:server:SyncSpikes')
AddEventHandler('pepe-police:server:SyncSpikes', function(table)
    TriggerClientEvent('pepe-police:client:SyncSpikes', -1, table)
end)

-- // Finger Scanner \\ --

RegisterServerEvent('pepe-police:server:show:machine')
AddEventHandler('pepe-police:server:show:machine', function(PlayerId)
    local Player = Framework.Functions.GetPlayer(PlayerId)
    TriggerClientEvent('pepe-police:client:show:machine', PlayerId, source)
    TriggerClientEvent('pepe-police:client:show:machine', source, PlayerId)
end)

RegisterServerEvent('pepe-police:server:showFingerId')
AddEventHandler('pepe-police:server:showFingerId', function(FingerPrintSession)
 local Player = Framework.Functions.GetPlayer(source)
 local FingerId = Player.PlayerData.metadata["fingerprint"] 
 if math.random(1,25)  <= 15 then
 TriggerClientEvent('pepe-police:client:show:fingerprint:id', FingerPrintSession, FingerId)
 TriggerClientEvent('pepe-police:client:show:fingerprint:id', source, FingerId)
 end
end)

RegisterServerEvent('pepe-police:server:set:tracker')
AddEventHandler('pepe-police:server:set:tracker', function(TargetId)
    local Target = Framework.Functions.GetPlayer(TargetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('Framework:Notify', TargetId, 'Dây đeo mắt cá chân của bạn đã được thực hiện.', 'error', 5000)
        TriggerClientEvent('Framework:Notify', source, 'Bạn có một ban nhạc tắt '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('pepe-police:client:set:tracker', TargetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('Framework:Notify', TargetId, 'Bạn đã nhận được một cà vạt duy nhất.', 'error', 5000)
        TriggerClientEvent('Framework:Notify', source, 'Bạn đã đặt một cà vạt duy nhất tại '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('pepe-police:client:set:tracker', TargetId, true)
    end
end)

RegisterServerEvent('pepe-police:server:send:tracker:location')
AddEventHandler('pepe-police:server:send:tracker:location', function(Coords, RequestId)
    local Target = Framework.Functions.GetPlayer(RequestId)
    local AlertData = {title = "Vị trí vòng chân.", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Vị trí ban nhạc mắt cá chân của: "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname}
    TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('pepe-police:client:send:tracker:alert', -1, Coords, Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
end)

-- // Update Cops \\ --
RegisterServerEvent('pepe-police:server:UpdateCurrentCops')
AddEventHandler('pepe-police:server:UpdateCurrentCops', function()
    local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    TriggerClientEvent("pepe-police:SetCopCount", -1, amount)
end)

RegisterServerEvent('pepe-police:server:UpdateStatus')
AddEventHandler('pepe-police:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterServerEvent('pepe-police:server:ClearDrops')
AddEventHandler('pepe-police:server:ClearDrops', function(Type, List)
    local src = source
    if Type == 'casing' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'casing', v)
                Casings[v] = nil
            end
        end
    elseif Type == 'finger' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'finger', v)
                FingerDrops[v] = nil
            end
        end
    elseif Type == 'blood' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'blood', v)
                BloodDrops[v] = nil
            end
        end
    elseif Type == 'Hair' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'hair', v)
                HairDrops[v] = nil
            end
        end
    elseif Type == 'Slime' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'slime', v)
                HairDrops[v] = nil
            end
        end
    end
end)

function RemoveDna(EvidenceType, EvidenceId)
 if EvidenceType == 'hair' then
     HairDrops[EvidenceId] = nil
 elseif EvidenceType == 'blood' then
     BloodDrops[EvidenceId] = nil
 elseif EvidenceType == 'finger' then
     FingerDrops[EvidenceId] = nil
 elseif EvidenceType == 'slime' then
     SlimeDrops[EvidenceId] = nil
 elseif EvidenceType == 'casing' then
     Casings[EvidenceId] = nil
 end
end

-- // Functions \\ --

function CreateIdType(Type)
    if Type == 'casing' then
        if Casings ~= nil then
	    	local caseId = math.random(10000, 99999)
	    	while Casings[caseId] ~= nil do
	    		caseId = math.random(10000, 99999)
	    	end
	    	return caseId
	    else
	    	local caseId = math.random(10000, 99999)
	    	return caseId
        end
    elseif Type == 'finger' then
        if FingerDrops ~= nil then
            local fingerId = math.random(10000, 99999)
            while FingerDrops[fingerId] ~= nil do
                fingerId = math.random(10000, 99999)
            end
            return fingerId
        else
            local fingerId = math.random(10000, 99999)
            return fingerId
        end
    elseif Type == 'blood' then
        if BloodDrops ~= nil then
            local bloodId = math.random(10000, 99999)
            while BloodDrops[bloodId] ~= nil do
                bloodId = math.random(10000, 99999)
            end
            return bloodId
        else
            local bloodId = math.random(10000, 99999)
            return bloodId
        end
    elseif Type == 'hair' then
        if HairDrops ~= nil then
            local hairId = math.random(10000, 99999)
            while HairDrops[hairId] ~= nil do
                hairId = math.random(10000, 99999)
            end
            return hairId
        else
            local hairId = math.random(10000, 99999)
            return hairId
        end
    elseif Type == 'slime' then
        if SlimeDrops ~= nil then
            local slimeId = math.random(10000, 99999)
            while SlimeDrops[slimeId] ~= nil do
                slimeId = math.random(10000, 99999)
            end
            return slimeId
        else
            local slimeId = math.random(10000, 99999)
            return slimeId
        end
   end
end

Framework.Functions.CreateCallback('pepe-police:GetPoliceVehicles', function(source, cb)
    local vehicles = {}
    exports['ghmattimysql']:execute('SELECT * FROM characters_vehicles WHERE state = @state', {['@state'] = "impound"}, function(result)
        if result[1] ~= nil then
            vehicles = result
        end
        cb(vehicles)
    end)
end)
-- // Commands \\ --

Framework.Commands.Add("boei", "Phao ai đó (Quản trị viên.)", {{name="id", help="ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args ~= nil then
     local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
       if TargetPlayer ~= nil then
         TriggerClientEvent("pepe-police:client:get:cuffed", TargetPlayer.PlayerData.source, Player.PlayerData.source)
       end
    end
end, "admin")

Framework.Commands.Add("zethogecommando", "Zet iemand zijn hoge commando status", {{name="id", help="Speler ID"}, {name="status", help="True / False"}}, true, function(source, args)
  if args ~= nil then
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayer ~= nil then
      if args[2]:lower() == 'true' then
          TargetPlayer.Functions.SetMetaData("ishighcommand", true)
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent nu een leidinggevende!', 'success')
          TriggerClientEvent('Framework:Notify', source, 'Speler is nu een leidinggevende!', 'success')
      else
          TargetPlayer.Functions.SetMetaData("ishighcommand", false)
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent geen leidinggevende meer!', 'error')
          TriggerClientEvent('Framework:Notify', source, 'Speler is GEEN leidinggevende meer!', 'error')
      end
    end
  end
end, "admin")

Framework.Commands.Add("zetpolitie", "Neem een agent aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als agent!', 'success')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als agent!', 'success')
          TargetPlayer.Functions.SetJob('police')
      end
    end
end)

Framework.Functions.CreateUseableItem("spikestrip", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("pepe-police:client:SpawnSpikeStrip", source)
    end
end)

Framework.Commands.Add("ontslapolitie", "Ontsla een agent", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
          TargetPlayer.Functions.SetJob('unemployed')
      end
    end
end)

Framework.Commands.Add("callsign", "Thay đổi số dịch vụ của bạn", {{name="Nummer", help="Số dịch vụ"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
         Player.Functions.SetMetaData("callsign", args[1])
         TriggerClientEvent('Framework:Notify', source, 'Số dịch vụ thành công. Bây giờ bạn là: ' ..args[1], 'success')
        else
            TriggerClientEvent('Framework:Notify', source, 'Điều này chỉ dành cho các dịch vụ trợ giúp..', 'error')
        end
    end
end)

Framework.Commands.Add("setplate", "Thay đổi biển số giấy phép của bạn", {{name="Nummer", help="Dienstnummer"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
           if args[1]:len() == 8 then
             Player.Functions.SetDutyPlate(args[1])
             TriggerClientEvent('Framework:Notify', source, 'Biển số được điều chỉnh thành công. Tấm giấy phép dịch vụ của bạn bây giờ: ' ..args[1], 'success')
           else
               TriggerClientEvent('Framework:Notify', source, 'Nó phải dài 8 ký tự..', 'error')
           end
        else
            TriggerClientEvent('Framework:Notify', source, 'Điều này chỉ dành cho các dịch vụ trợ giúp..', 'error')
        end
    end
end)

Framework.Commands.Add("kluis", "Mở bằng chứng an toàn", {{"bsn", "BSN Nummer"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then 
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("pepe-police:client:open:evidence", source, args[1])
    else
        TriggerClientEvent('Framework:Notify', source, "Dit commando is alleen voor hulpdiensten!", "error")
    end
  else
    TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Je moet alle argumenten invoeren.")
 end
end)

Framework.Commands.Add("zetdienstvoertuig", "Geef een werk voertuig aan een werknemer", {{name="id", help="Speler ID"}, {name="voertuig", help="Standaard / Audi / Heli / Motor / Unmarked"}, {name="status", help="True / False"}}, true, function(source, args)
    local SelfPlayerData = Framework.Functions.GetPlayer(source)
    local TargetPlayerData = Framework.Functions.GetPlayer(tonumber(args[1]))
    local TargetPlayerVehicleData = TargetPlayerData.PlayerData.metadata['duty-vehicles']
    if SelfPlayerData.PlayerData.metadata['ishighcommand'] then
       if args[2]:upper() == 'STANDAARD' then
           if args[3] == 'true' then
               VehicleList = {Standard = true, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
           else
               VehicleList = {Standard = false, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
           end
       elseif args[2]:upper() == 'AUDI' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = true, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = false, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
           end
       elseif args[2]:upper() == 'UNMARKED' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = true}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = false}
           end 
        elseif args[2]:upper() == 'MOTOR' then
            if args[3] == 'true' then
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = true, Unmarked = TargetPlayerVehicleData.Unmarked}
            else
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = false, Unmarked = TargetPlayerVehicleData.Unmarked}
            end 
       elseif args[2]:upper() == 'HELI' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = true, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = false, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
           end 
       end
       local PlayerCredentials = TargetPlayerData.PlayerData.metadata['callsign']..' | '..TargetPlayerData.PlayerData.charinfo.firstname..' '..TargetPlayerData.PlayerData.charinfo.lastname
       TargetPlayerData.Functions.SetMetaData("duty-vehicles", VehicleList)
       TriggerClientEvent('pepe-radialmenu:client:update:duty:vehicles', TargetPlayerData.PlayerData.source)
       if args[3] == 'true' then
           TriggerClientEvent('Framework:Notify', TargetPlayerData.PlayerData.source, 'Bạn đã nhận được một chuyên ngành xe hơi ('..args[2]:upper()..')', 'success')
           TriggerClientEvent('Framework:Notify', SelfPlayerData.PlayerData.source, 'Bạn đã chuyên về xe ('..args[2]:upper()..') gegeven aan '..PlayerCredentials, 'success')
       else
           TriggerClientEvent('Framework:Notify', TargetPlayerData.PlayerData.source, 'Je ('..args[2]:upper()..') Chuyên môn hóa đã giảm mọt sách..', 'error')
           TriggerClientEvent('Framework:Notify', SelfPlayerData.PlayerData.source, 'Bạn đã chuyên về xe ('..args[2]:upper()..') afgenomen van '..PlayerCredentials, 'error')
       end
    end
end)

-- Framework.Commands.Add("viethoadon", "Viết hóa đơn", {{name="id", help="ID"},{name="geld", help="Số tiền"}}, true, function(source, args)
--     local Player = Framework.Functions.GetPlayer(source)
--     local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
--     local Amount = tonumber(args[2])
--     if TargetPlayer ~= nil then
--        if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "cardealer") then
--          if Amount > 0 then
--           TriggerClientEvent("pepe-police:client:bill:player", TargetPlayer.PlayerData.source, Amount)
-- 	   	  TriggerEvent('pepe-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, Player.PlayerData.job.name, 'invoice')  
--             --  TriggerClientEvent("Framework:Notify", source, "Hoá đơn $"..Amount.." vừa được thanh toán" , "success")
--             --  TriggerClientEvent("Framework:Notify", TargetPlayer.PlayerData.source, "Hoá đơn $"..Amount.." vừa được thanh toán" , "success")
--          else
--              TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Số tiền phải cao hơn 0")
--          end
--        elseif Player.PlayerData.job.name == "realestate" then
--         if Amount > 0 then
--                TriggerEvent('pepe-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Makelaar', 'realestate')  
--            else
--                TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Số tiền phải cao hơn 0")
--            end
--        else
--            TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Lệnh này chỉ dành cho các doanh nghiệp!")
--        end
       
--        Player.Functions.SetMetaData("lockpickrep", Player.PlayerData.metadata["lockpickrep"]+1)
--     end
-- end)
-- Edit sua hoa don them 2 cot

Framework.Commands.Add("paylaw", "Betaal een advocaat", {{name="id", help="Speler ID"}, {name="geld", help="Hoeveelheid"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = Framework.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEEM", "warning", "Je hebt €"..Amount..",- ontvangen voor je gegeven diensten!")
                TriggerClientEvent('Framework:Notify', source, 'Je hebt een advocaat betaald!')
            else
                TriggerClientEvent('Framework:Notify', source, 'Persoon is geen advocaat...', "error")
            end
            
       Player.Functions.SetMetaData("lockpickrep", Player.PlayerData.metadata["lockpickrep"]+1)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is alleen voor hulpdiensten!")
    end
end)

Framework.Commands.Add("camera", "Bekijk Camera", {{name="camid", help="Camera ID"}}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("pepe-police:client:CameraCommand", source, tonumber(args[1]))
    else
        TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message emergency">Dit commando is alleen voor hulpdiensten!  </div>',
        })
    end
end)

Framework.Commands.Add("112", "Gửi thông báo cho các dịch vụ khẩn cấp", {{name="melding", help="Thông báo mà bạn muốn gửi"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        local MessageWithID = "["..source.."] - "..Message
        TriggerClientEvent('pepe-police:client:send:alert', source, MessageWithID, false)
    else
        TriggerClientEvent('Framework:Notify', source, 'Bạn không có điện thoại...', 'error')
    end
end)

Framework.Commands.Add("112r", "Stuur een bericht terug naar een melding", {{name="id", help="ID van de melding"}, {name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local OtherPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    table.remove(args, 1)
    local message = table.concat(args, " ")
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(POLITIE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("pepe-police:client:call:anim", source)
        end
    elseif Player.PlayerData.job.name == "ambulance" then
        if OtherPlayer ~= nil then 
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(AMBULANCE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("pepe-police:client:call:anim", source)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

Framework.Commands.Add("112a", "Stuur een anonieme melding naar hulpdiensten (geeft geen locatie)", {{name="melding", help="De melding die je anoniem wilt sturen"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("pepe-police:client:call:anim", source)
        TriggerClientEvent('pepe-police:client:send:alert', -1, Message, true)
    else
        TriggerClientEvent('Framework:Notify', source, 'Je hebt geen telefoon...', 'error')
    end
end)

Framework.Commands.Add("unjail", "Haal persoon uit het gevang.", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        local playerId = tonumber(args[1])
        TriggerClientEvent("pepe-prison:client:leave:prison", playerId)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alleen voor hulpdiensten.", "success")
    end
end)


-- Framework.Commands.Add("beslag", "Neem een voertuig in beslag", {}, true, function(source, args)
-- 	local Player = Framework.Functions.GetPlayer(source)
--     if Player.PlayerData.job.name == "police" then
--         TriggerClientEvent("pepe-police:client:ImpoundVehicle", source, tonumber(args[1]))
--     else
--         TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alleen voor hulpdiensten.")
--     end
-- end)

Framework.Commands.Add("enkelbandlocatie", "Haal locatie van persoon met enkelband", {{name="bsn", help="BSN van de burger"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = Framework.Functions.GetPlayerByCitizenId(citizenid)
            local Tracking = false
            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] and not Tracking then
                    Tracking = true
                    TriggerClientEvent("pepe-police:client:send:tracker:location", Target.PlayerData.source, Target.PlayerData.source)
                else
                    TriggerClientEvent('Framework:Notify', source, 'Dit persoon heeft geen enkelband...', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is alleen voor hulpdiensten!")
    end
end)

Framework.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("pepe-police:client:cuff:closest", source)
    end
end)

-- // HandCuffs \\ --
RegisterServerEvent('pepe-police:server:cuff:closest')
AddEventHandler('pepe-police:server:cuff:closest', function(SeverId)
    local Player = Framework.Functions.GetPlayer(source)
    local CuffedPlayer = Framework.Functions.GetPlayer(SeverId)
    if CuffedPlayer ~= nil then
        TriggerClientEvent("pepe-police:client:get:cuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterServerEvent('pepe-police:server:set:handcuff:status')
AddEventHandler('pepe-police:server:set:handcuff:status', function(Cuffed)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", Cuffed)
	end
end)

RegisterServerEvent('pepe-police:server:escort:closest')
AddEventHandler('pepe-police:server:escort:closest', function(SeverId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(SeverId)
    if EscortPlayer ~= nil then
        if (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"]) then
            TriggerClientEvent("pepe-police:client:get:escorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Người chơi không bị bất tỉnh hoặc bị còng!")
        end
    end
end)

RegisterServerEvent('pepe-police:server:set:out:veh')
AddEventHandler('pepe-police:server:set:out:veh', function(ServerId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("pepe-police:client:set:out:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Người chơi không bị bất tỉnh hoặc bị còng!")
        end
    end
end)

RegisterServerEvent('pepe-police:server:set:in:veh')
AddEventHandler('pepe-police:server:set:in:veh', function(ServerId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("pepe-police:client:set:in:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Người chơi không bị bất tỉnh hoặc bị còng!")
        end
    end
end)

Framework.Functions.CreateCallback('pepe-police:server:is:player:dead', function(source, cb, playerId)
    local Player = Framework.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

RegisterServerEvent('pepe-police:server:SearchPlayer')
AddEventHandler('pepe-police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "warning", "Người chơi có $"..SearchedPlayer.PlayerData.money["cash"]..",- trong túi..")
        TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "Bạn đang bị lục soát..")
    end
end)

RegisterServerEvent('pepe-police:server:rob:player')
AddEventHandler('pepe-police:server:rob:player', function(playerId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "Bạn bị tịch thu $"..money.." ")
    end
    
    Player.Functions.SetMetaData("lockpickrep", Player.PlayerData.metadata["lockpickrep"]+1)
end)

RegisterServerEvent('pepe-police:server:send:call:alert')
AddEventHandler('pepe-police:server:send:call:alert', function(Coords, Message)
 local Player = Framework.Functions.GetPlayer(source)
 local Name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
 local AlertData = {title = "112 Thông điệp - "..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " ("..source..")", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = Message}
 TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
 TriggerClientEvent('pepe-police:client:send:message', -1, Coords, Message, Name)
end)

RegisterServerEvent('pepe-police:server:spawn:object')
AddEventHandler('pepe-police:server:spawn:object', function(type, coords)
    local src = source
    local objectId = CreateIdType('casing')
    Objects[objectId] = type
    TriggerClientEvent("pepe-police:client:place:object", -1, objectId, type, src, coords)
end)

RegisterServerEvent('pepe-police:server:delete:object')
AddEventHandler('pepe-police:server:delete:object', function(objectId)
    local src = source
    TriggerClientEvent('pepe-police:client:remove:object', -1, objectId)
end)



RegisterServerEvent('pepe-police:server:hardimpound')
AddEventHandler('pepe-police:server:hardimpound', function(plate, price)
    local src = source
    local price = price ~= nil and price or 1000
    local state = "in"
    if IsVehicleOwned(plate) then
            exports['ghmattimysql']:execute('UPDATE characters_vehicles SET garage = "Police", state = @state, depotprice = @depotprice WHERE plate = @plate', {['@garage'] = "Police", ['@state'] = "in", ['@depotprice'] = price, ['@plate'] = plate})
            TriggerClientEvent('Framework:Notify', src, "Xe bao gồm trong kho cho $"..price.."!")
    end
end)


-- // Police Alerts Events \\ --

RegisterServerEvent('pepe-police:server:send:alert:officer:down')
AddEventHandler('pepe-police:server:send:alert:officer:down', function(Coords, StreetName, Info, Priority)
   TriggerClientEvent('pepe-police:client:send:officer:down', -1, Coords, StreetName, Info, Priority)
end)

RegisterServerEvent('pepe-police:server:send:alert:panic:button')
AddEventHandler('pepe-police:server:send:alert:panic:button', function(Coords, StreetName, Info)
    local AlertData = {title = "Assistentie collega", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Noodknop ingedrukt door "..Info['Callsign'].." "..Info['Firstname']..' '..Info['Lastname'].." bij "..StreetName}
    TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('pepe-police:client:send:alert:panic:button', -1, Coords, StreetName, Info)
end)

RegisterServerEvent('pepe-police:server:send:alert:gunshots')
AddEventHandler('pepe-police:server:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
    local AlertData = {title = "Bắn đạn",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Ảnh bị bắn gần đó ' ..StreetName}
    if InVeh then
      AlertData = {title = "Bắn đạn",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Bắn ra khỏi xe, gần ' ..StreetName}
    end
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:gunshots', -1, Coords, GunType, StreetName, InVeh)
end)

RegisterServerEvent('pepe-police:server:send:alert:dead')
AddEventHandler('pepe-police:server:send:alert:dead', function(Coords, StreetName)
   local AlertData = {title = "Công dân bị thương", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Một công dân đã được báo cáo đã tèo gần "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:dead', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:bank:alert')
AddEventHandler('pepe-police:server:send:bank:alert', function(Coords, StreetName, CamId)
   local AlertData = {title = "Báo động ngân hàng", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Cuộc cướp ngân hàng Fleeca đang diễn ra tại "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:bank:alert', -1, Coords, StreetName, CamId)
end)

RegisterServerEvent('pepe-police:server:send:alert:meter')
AddEventHandler('pepe-police:server:send:alert:meter', function(Coords, StreetName)
   local AlertData = {title = "Parkingmeter Robbery", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Đồng hồ đỗ xe đang bị cướp tại "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:meter:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:alert:jewellery')
AddEventHandler('pepe-police:server:send:alert:jewellery', function(Coords, StreetName)
   local AlertData = {title = "Jewellery Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Jewellery robbery in progress at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:jewellery', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:alert:store')
AddEventHandler('pepe-police:server:send:alert:store', function(Coords, StreetName, StoreNumber)
   local AlertData = {title = "Store Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Store robbery: "..StoreNumber..' currently being robbed at '..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:store', -1, Coords, StreetName, StoreNumber)
end)

RegisterServerEvent('pepe-police:server:send:house:alert')
AddEventHandler('pepe-police:server:send:house:alert', function(Coords, StreetName)
   local AlertData = {title = "Cảnh báo đột nhập nhà", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Cảnh báo đột nhập nhà tại "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:house:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:banktruck:alert')
AddEventHandler('pepe-police:server:send:banktruck:alert', function(Coords, Plate, StreetName)
   local AlertData = {title = "Bankwagen Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Bank truck robbery started. Plate: "..Plate..'. near '..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:banktruck:alert', -1, Coords, Plate, StreetName)
end)


RegisterServerEvent('pepe-police:server:send:weaponrobbery:alert')
AddEventHandler('pepe-police:server:send:weaponrobbery:alert', function(Coords, Plate, StreetName)
   local AlertData = {title = "Ammunation Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Ammunation is being robbed near "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:ammunation:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:alert:weed')
AddEventHandler('pepe-police:server:send:alert:weed', function(Coords, StreetName)
   local AlertData = {title = "Hái cần sa", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Hái cần sa tại "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:weed:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:alert:packweed')
AddEventHandler('pepe-police:server:send:alert:packweed', function(Coords, StreetName)
   local AlertData = {title = "Chế cần sa", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Hái cần sa tại "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:packweed:alert', -1, Coords, StreetName)
end)