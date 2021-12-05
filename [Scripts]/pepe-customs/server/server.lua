Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('lscustoms:server:setGarageBusy')
AddEventHandler('lscustoms:server:setGarageBusy', function(garage, busy)
	TriggerClientEvent('lscustoms:client:setGarageBusy', -1, garage, busy)
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if not button.purchased then
		if button.price then -- check if button have price
			print(type(button.price))
			-- if Player.Functions.RemoveMoney("cash", button.price, "lscustoms-bought") then
			-- 	TriggerClientEvent("LSC:buttonSelected", source, name, button, true)
			-- 	TriggerEvent("pepe-logs:server:SendLog", "vehicleupgrades", "Độ xe", "green", "**"..GetPlayerName(src).."** đã độ xe ("..name..") số tiền $" .. button.price)
			-- elseif Player.Functions.RemoveMoney("bank", button.price, "lscustoms-bought") then
			-- 	TriggerClientEvent("LSC:buttonSelected", source, name, button, true)
			-- 	TriggerEvent("pepe-logs:server:SendLog", "vehicleupgrades", "Độ xe", "green", "**"..GetPlayerName(src).."** đã độ xe ("..name..") số tiền $" .. button.price)
			-- else
			-- 	TriggerClientEvent("LSC:buttonSelected", source, name, button, false)
			-- end
			if type(button.price) == "table" then -- need items

				Framework.Functions.TriggerCallback('pepe-inventory:server:RemoveStashItems', src, function(canRemove)
					triggerSuccess = true
					if not canRemove then
						TriggerClientEvent("Framework:Notify", src, "Bạn không đủ vật phẩm cần thiết!", "error")
						TriggerClientEvent("LSC:buttonSelected", src, name, button, false)
					else
						TriggerClientEvent("Framework:Notify", src, "Độ xe thành công!", "success")
					TriggerClientEvent("LSC:buttonSelected", src, name, button, true)
					TriggerEvent("pepe-logs:server:SendLog", "vehicleupgrades", "Độ xe", "green", "**"..GetPlayerName(src).."** đã độ xe ("..name..") ")
					end
				end, "Bennys", button.price)
			else
				--need money
				TriggerClientEvent("LSC:buttonSelected", src, name, button, true)
			end
			
		end
	else
		TriggerClientEvent("LSC:buttonSelected", src, name, button, false)
	end
end)

RegisterServerEvent("lscustoms:server:SaveVehicleProps")
AddEventHandler("lscustoms:server:SaveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        Framework.Functions.ExecuteSql(false, "UPDATE `characters_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end