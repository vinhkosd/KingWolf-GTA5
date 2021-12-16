local Webhook = 'https://discordapp.com/api/webhooks/919632745582460980/wu64sFbkK2YAzz3zCSYcupP22SNS6D3IeyPtKZ_J7Dxl6RH2ApoJ5OTC3qemzofv9iTE'
Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('okokMarketplace:getItems', function(source, cb)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)
	-- local xPlayer = Framework.Functions.GetPlayer(_source)
	local vehicles = {}
	-- local loadout = xPlayer.getLoadout()
	local loadout = {}
	local items = {}
	if xPlayer.PlayerData.items ~= nil and next(xPlayer.PlayerData.items) ~= nil then 
        for k, v in pairs(xPlayer.PlayerData.items) do 
            if xPlayer.PlayerData.items[k] ~= nil then 
                -- if ServerPrice[xPlayer.PlayerData.items[k].name] ~= nil then 
                --     retval = retval + (ServerPrice[xPlayer.PlayerData.items[k].name] * xPlayer.PlayerData.items[k].amount)
                -- end
				table.insert(items, xPlayer.PlayerData.items[k])
            end
        end
    end

	Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_vehicles` WHERE citizenid = "'..xPlayer.PlayerData.citizenid..'" and `forSale` = 0'
	, function(data)
        for _,v in pairs(data) do
			properties = v
			local metadata = json.decode(v.metadata)
			properties.Engine = metadata.Engine
			properties.Fuel = metadata.Fuel
			properties.Body = metadata.Body
			properties.State = properties.state
			properties.Model = properties.vehicle
			properties.Plate = properties.plate
			properties.Price = properties.depotprice
			properties.model = properties.vehicle
			-- local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, {vehicle = properties, plate = v.plate})
		end

		cb(vehicles, items, loadout)
    end)

	-- MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = 1', {
	-- 	['@owner'] = xPlayer.PlayerData.citizenid,
	-- 	['@Type'] = 'car',
	-- 	['@job'] = 'civ',
	-- }, function(data) 
	-- 	for _,v in pairs(data) do
	-- 		local vehicle = json.decode(v.vehicle)
	-- 		table.insert(vehicles, {vehicle = vehicle, plate = v.plate})
	-- 	end
	-- 	cb(vehicles, xPlayer.getInventory(), loadout)
	-- end)
end)

Framework.Functions.CreateCallback('okokMarketplace:getAds', function(source, cb)
	local _source = source
	-- local xPlayer = Framework.Functions.GetPlayer(_source)
	local xPlayer = Framework.Functions.GetPlayer(source)

	Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_vehicles ORDER BY id ASC'
	, function(veh)
        Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_items ORDER BY id ASC'
		, function(items)
			Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_blackmarket ORDER BY id ASC'
			, function(blackmarket)
				cb(veh, items, blackmarket, xPlayer.PlayerData.citizenid)
			end)
		end)
    end)

	-- MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_vehicles ORDER BY id ASC', {
	-- }, function(veh) 
	-- 	MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_items ORDER BY id ASC', {
	-- 	}, function(items) 
	-- 		MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_blackmarket ORDER BY id ASC', {
	-- 		}, function(blackmarket) 
	-- 			cb(veh, items, blackmarket, xPlayer.PlayerData.citizenid)
	-- 		end)
	-- 	end)
	-- end)
end)

Framework.Functions.CreateCallback('okokMarketplace:phone', function(source, cb)
	local _source = source
	-- local xPlayer =? Framework.Functions.GetPlayer(_source)
	local xPlayer = Framework.Functions.GetPlayer(_source)

	cb(xPlayer.PlayerData.charinfo.phone)
	-- MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
	-- 	['@identifier'] = xPlayer.PlayerData.citizenid
	-- }, function(result)
	-- 	cb(result[1].phone_number)
	-- end)
end)



RegisterServerEvent("okokMarketplace:addVehicle")
AddEventHandler("okokMarketplace:addVehicle", function(vehicle, price, desc, phone_number)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(source)
	local plate = vehicle.plate
	local id = plate:gsub("%s+", "")

	-- MySQL.Async.execute('UPDATE characters_vehicles SET citizenid = "selling" WHERE plate = "'..PlateEscapeSqli(plate)..'"', {
	-- 	['@plate'] = vehicle.plate,
	-- 	['@owner'] = "selling",
	-- })

	Framework.Functions.ExecuteSql(true, "UPDATE characters_vehicles SET citizenid = 'selling' WHERE `plate` = '"..PlateEscapeSqli(plate).."'")
	
	Framework.Functions.ExecuteSql(false, "INSERT INTO okokmarketplace_vehicles (item_id, plate, label, author_identifier, author_name, phone_number, description, price, start_date) VALUES ('"..id.."', '"..plate.."', '"..vehicle.name.."', '"..xPlayer.PlayerData.citizenid.."', '"..GetPlayerName(_source).."', '"..phone_number.."', '"..PlateEscapeSqli(desc).."', '"..price.."', '"..os.date("%d/%m - %H:%M").."')")

	TriggerClientEvent('okokMarketplace:updateVehiclesDropdown', _source)
	TriggerClientEvent('okokMarketplace:updateVehicles', _source)
	TriggerClientEvent('okokMarketplace:updateMyAdsTable', _source)
	TriggerClientEvent('okokNotify:Alert', _source, "THÔNG BÁO", "Bạn đã bán phương tiện "..vehicle.name.." ("..vehicle.plate..")", 5000, 'success')

	if Webhook ~= '' then
		local identifierlist = ExtractIdentifiers(_source)
		local data = {
			playerid = _source,
			identifier = identifierlist.license:gsub("license2:", ""),
			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
			type = "add",
			action = "Added an Ad",
			item = vehicle.name.." ("..vehicle.plate..")",
			price = price,
			desc = desc,
			title = "MARKETPLACE - Vehicles",
		}
		discordWenhook(data)
	end
 
	-- MySQL.Async.insert('INSERT INTO okokmarketplace_vehicles (item_id, plate, label, author_identifier, author_name, phone_number, description, price, start_date) VALUES (@item_id, @plate, @label, @author_identifier, @author_name, @phone_number, @description, @price, @start_date)', {
	-- 	['@item_id'] = id,
	-- 	['@plate'] = plate,
	-- 	['@label'] = vehicle.name,
	-- 	['@author_identifier'] = xPlayer.PlayerData.citizenid,
	-- 	['@author_name'] = GetPlayerName(_source),
	-- 	['@phone_number'] = phone_number,
	-- 	['@description'] = desc,
	-- 	['@price'] = price,
	-- 	['@start_date'] = os.date("%d/%m - %H:%M"),
	-- }, function(result)
	-- 	TriggerClientEvent('okokMarketplace:updateVehiclesDropdown', xPlayer.PlayerData.source)
	-- 	TriggerClientEvent('okokMarketplace:updateVehicles', xPlayer.PlayerData.source)
	-- 	TriggerClientEvent('okokMarketplace:updateMyAdsTable', xPlayer.PlayerData.source)
	-- 	TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You are now selling the vehicle "..vehicle.name.." ("..vehicle.plate..")", 5000, 'success')

	-- 	if Webhook ~= '' then
	-- 		local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
	-- 		local data = {
	-- 			playerid = xPlayer.PlayerData.source,
	-- 			identifier = identifierlist.license:gsub("license2:", ""),
	-- 			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
	-- 			type = "add",
	-- 			action = "Added an Ad",
	-- 			item = vehicle.name.." ("..vehicle.plate..")",
	-- 			price = price,
	-- 			desc = desc,
	-- 			title = "MARKETPLACE - Vehicles",
	-- 		}
	-- 		discordWenhook(data)
	-- 	end
	-- end)
end)

RegisterServerEvent("okokMarketplace:addItem")
AddEventHandler("okokMarketplace:addItem", function(item, amount, price, desc, phone_number)
	local _source = source
	-- local xPlayer = Framework.Functions.GetPlayer(_source)
	local xPlayer = Framework.Functions.GetPlayer(source)
	local amount = tonumber(amount)
	local GetInvItems = xPlayer.Functions.GetItemByName(item.id)
	if xPlayer.Functions.GetItemByName(item.id).amount >= amount and amount > 0 then
		-- INSERT INTO okokmarketplace_items (item_id, label, amount, author_identifier, author_name, phone_number, description, price, start_date) VALUES (@item_id, @label, @amount, @author_identifier, @author_name, @phone_number, @description, @price, @start_date)
		Framework.Functions.ExecuteSql(true, "INSERT INTO okokmarketplace_items (item_id, label, amount, author_identifier, author_name, phone_number, description, price, start_date) VALUES ('"..item.id.."', '"..item.label.."', '"..amount.."', '"..xPlayer.PlayerData.citizenid.."', '"..GetPlayerName(_source).."', '"..phone_number.."' , '"..PlateEscapeSqli(desc).."', '"..price.."', '"..os.date("%d/%m - %H:%M").."')")

		TriggerClientEvent('okokMarketplace:updateItemsDropdown', xPlayer.PlayerData.source)
		TriggerClientEvent('okokMarketplace:updateItems', xPlayer.PlayerData.source)
		TriggerClientEvent('okokMarketplace:updateMyAdsTable', xPlayer.PlayerData.source)
		xPlayer.Functions.RemoveItem(item.id, amount)
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã bán vật phẩm "..item.label.." ("..amount..")", 5000, 'success')

		if Webhook ~= '' then
			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
			local data = {
				playerid = xPlayer.PlayerData.source,
				identifier = identifierlist.license:gsub("license2:", ""),
				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
				type = "add",
				action = "Added an Ad",
				item = item.label.." (x"..amount..")",
				price = price,
				desc = desc,
				title = "MARKETPLACE - Items",
			}
			discordWenhook(data)
		end
	
		-- MySQL.Async.insert('INSERT INTO okokmarketplace_items (item_id, label, amount, author_identifier, author_name, phone_number, description, price, start_date) VALUES (@item_id, @label, @amount, @author_identifier, @author_name, @phone_number, @description, @price, @start_date)', {
		-- 	['@item_id'] = item.id,
		-- 	['@label'] = item.label,
		-- 	['@amount'] = amount,
		-- 	['@author_identifier'] = xPlayer.PlayerData.citizenid,
		-- 	['@author_name'] = GetPlayerName(_source),
		-- 	['@phone_number'] = phone_number,
		-- 	['@description'] = desc,
		-- 	['@price'] = price,
		-- 	['@start_date'] = os.date("%d/%m - %H:%M"),
		-- }, function(result)
		-- 	TriggerClientEvent('okokMarketplace:updateItemsDropdown', xPlayer.PlayerData.source)
		-- 	TriggerClientEvent('okokMarketplace:updateItems', xPlayer.PlayerData.source)
		-- 	TriggerClientEvent('okokMarketplace:updateMyAdsTable', xPlayer.PlayerData.source)
		-- 	xPlayer.Functions.RemoveItem(item.id, amount)
		-- 	TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You are now selling the item "..item.label.." ("..amount..")", 5000, 'success')

		-- 	if Webhook ~= '' then
		-- 		local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 		local data = {
		-- 			playerid = xPlayer.PlayerData.source,
		-- 			identifier = identifierlist.license:gsub("license2:", ""),
		-- 			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 			type = "add",
		-- 			action = "Added an Ad",
		-- 			item = item.label.." (x"..amount..")",
		-- 			price = price,
		-- 			desc = desc,
		-- 			title = "MARKETPLACE - Items",
		-- 		}
		-- 		discordWenhook(data)
		-- 	end
		-- end)
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Không đủ vật phẩm để bán", 5000, 'error')
	end
end)

RegisterServerEvent("okokMarketplace:addBlackmarket")
AddEventHandler("okokMarketplace:addBlackmarket", function(item, price, desc, phone_number, amount)
	local _source = source
	-- local xPlayer = Framework.Functions.GetPlayer(_source)
	local xPlayer = Framework.Functions.GetPlayer(source)

	if item.type == "weapon" then-- and xPlayer.hasWeapon(item.id) and amount <= item.count then
		-- MySQL.Async.insert('INSERT INTO okokmarketplace_blackmarket (item_id, label, type, amount, author_identifier, author_name, phone_number, description, price, start_date) VALUES (@item_id, @label, @type, @amount, @author_identifier, @author_name, @phone_number, @description, @price, @start_date)', {
		-- 	['@item_id'] = item.id,
		-- 	['@label'] = item.label,
		-- 	['@type'] = item.type,
		-- 	['@amount'] = amount,
		-- 	['@author_identifier'] = xPlayer.PlayerData.citizenid,
		-- 	['@author_name'] = GetPlayerName(_source),
		-- 	['@phone_number'] = phone_number,
		-- 	['@description'] = desc,
		-- 	['@price'] = price,
		-- 	['@start_date'] = os.date("%d/%m - %H:%M"),
		-- }, function(result)
		-- 	TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
		-- 	TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
		-- 	TriggerClientEvent('okokMarketplace:updateMyAdsTable', xPlayer.PlayerData.source)
		-- 	xPlayer.removeWeapon(item.id, amount)
		-- 	TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You are now selling the item "..item.label, 5000, 'success')

		-- 	if Webhook ~= '' then
		-- 		local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 		local data = {
		-- 			playerid = xPlayer.PlayerData.source,
		-- 			identifier = identifierlist.license:gsub("license2:", ""),
		-- 			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 			type = "add",
		-- 			action = "Added an Ad",
		-- 			item = item.label.." (x"..amount..")",
		-- 			price = price,
		-- 			desc = desc,
		-- 			title = "MARKETPLACE - Blackmarket",
		-- 		}
		-- 		discordWenhook(data)
		-- 	end
		-- end)
	elseif item.type == "item" and xPlayer.Functions.GetItemByName(item.id).amount > 0 and amount <= xPlayer.Functions.GetItemByName(item.id).amount then
		Framework.Functions.ExecuteSql(true, "INSERT INTO okokmarketplace_blackmarket (item_id, label, type, amount, author_identifier, author_name, phone_number, description, price, start_date) VALUES ('"..item.id.."', '"..item.label.."', '"..item.type.."', '"..amount.."', '"..xPlayer.PlayerData.citizenid.."', '"..GetPlayerName(_source).."', '"..phone_number.."', '"..PlateEscapeSqli(desc).."', '"..price.."', '"..os.date("%d/%m - %H:%M").."'")

		TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
		TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
		TriggerClientEvent('okokMarketplace:updateMyAdsTable', xPlayer.PlayerData.source)
		xPlayer.Functions.RemoveItem(item.id, amount)
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã bán vật phẩm "..item.label, 5000, 'success')
		if Webhook ~= '' then
			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
			local data = {
				playerid = xPlayer.PlayerData.source,
				identifier = identifierlist.license:gsub("license2:", ""),
				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
				type = "add",
				action = "Added an Ad",
				item = item.label.." (x"..amount..")",
				price = price,
				desc = desc,
				title = "MARKETPLACE - Blackmarket",
			}
			discordWenhook(data)
		end
		
		-- MySQL.Async.insert('INSERT INTO okokmarketplace_blackmarket (item_id, label, type, amount, author_identifier, author_name, phone_number, description, price, start_date) VALUES (@item_id, @label, @type, @amount, @author_identifier, @author_name, @phone_number, @description, @price, @start_date)', {
		-- 	['@item_id'] = item.id,
		-- 	['@label'] = item.label,
		-- 	['@type'] = item.type,
		-- 	['@amount'] = amount,
		-- 	['@author_identifier'] = xPlayer.PlayerData.citizenid,
		-- 	['@author_name'] = GetPlayerName(_source),
		-- 	['@phone_number'] = phone_number,
		-- 	['@description'] = desc,
		-- 	['@price'] = price,
		-- 	['@start_date'] = os.date("%d/%m - %H:%M"),
		-- }, function(result)
		-- 	TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
		-- 	TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
		-- 	TriggerClientEvent('okokMarketplace:updateMyAdsTable', xPlayer.PlayerData.source)
		-- 	xPlayer.Functions.RemoveItem(item.id, amount)
		-- 	TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You are now selling the item "..item.label, 5000, 'success')
		-- 	if Webhook ~= '' then
		-- 		local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 		local data = {
		-- 			playerid = xPlayer.PlayerData.source,
		-- 			identifier = identifierlist.license:gsub("license2:", ""),
		-- 			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 			type = "add",
		-- 			action = "Added an Ad",
		-- 			item = item.label.." (x"..amount..")",
		-- 			price = price,
		-- 			desc = desc,
		-- 			title = "MARKETPLACE - Blackmarket",
		-- 		}
		-- 		discordWenhook(data)
		-- 	end
		-- end)
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Không đủ "..item.label.." để bán", 5000, 'error')
	end
end)

Framework.Functions.CreateCallback('okokMarketplace:getVehicle', function(source, cb, id)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)

	Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_vehicles WHERE item_id = "'..id..'" AND sold = false'
	, function(veh)
        if veh[1] ~= nil then
			cb(veh)
		else
			TriggerClientEvent('okokMarketplace:updateVehicles', xPlayer.PlayerData.source)
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Phương tiện này không còn bán trên chợ", 5000, 'error')
		end
    end)

	-- MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_vehicles WHERE item_id = @item_id AND sold = false', {
	-- 	['@item_id'] = id,
	-- }, function(veh)
	-- 	if veh[1] ~= nil then
	-- 		cb(veh)
	-- 	else
	-- 		TriggerClientEvent('okokMarketplace:updateVehicles', xPlayer.PlayerData.source)
	-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "This vehicle is no longer for sale", 5000, 'error')
	-- 	end
	-- end)
end)

Framework.Functions.CreateCallback('okokMarketplace:getItem', function(source, cb, id, item)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)

	Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_items WHERE id = "'..id..'" AND item_id = "'..item..'" AND sold = false'
	, function(item)
        if item[1] ~= nil then
			cb(item)
		else
			TriggerClientEvent('okokMarketplace:updateItems', xPlayer.PlayerData.source)
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Mặt hàng này không còn bán trên chợ", 5000, 'error')
		end
    end)

	-- MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_items WHERE id = @id AND item_id = @item_id AND sold = false', {
	-- 	['@id'] = id,
	-- 	['@item_id'] = item,
	-- }, function(item)
	-- 	if item[1] ~= nil then
	-- 		cb(item)
	-- 	else
	-- 		TriggerClientEvent('okokMarketplace:updateItems', xPlayer.PlayerData.source)
	-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "This item is no longer for sale", 5000, 'error')
	-- 	end
	-- end)
end)

Framework.Functions.CreateCallback('okokMarketplace:getBlackmarket', function(source, cb, id, blackmarket)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)

	Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_blackmarket WHERE id = "'..id..'" AND item_id = "'..blackmarket..'" AND sold = false'
	, function(item)
        if blackmarket[1] ~= nil then
			cb(blackmarket)
		else
			TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Mặt hàng này không còn bán trên chợ", 5000, 'error')
		end
    end)

	-- MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_blackmarket WHERE id = @id AND item_id = @item_id AND sold = false', {
	-- 	['@id'] = id,
	-- 	['@item_id'] = blackmarket,
	-- }, function(blackmarket)
	-- 	if blackmarket[1] ~= nil then
	-- 		cb(blackmarket)
	-- 	else
	-- 		TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
	-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "This item is no longer for sale", 5000, 'error')
	-- 	end
	-- end)
end)

RegisterServerEvent("okokMarketplace:buyVehicle")
AddEventHandler("okokMarketplace:buyVehicle", function(veh)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)
	-- local xTarget = ESX.GetPlayerFromIdentifier(veh[1].author_identifier)
	local xTarget = Framework.Functions.GetPlayerByCitizenId(veh[1].author_identifier)
	-- local money = xPlayer.getAccount('bank').money
	local money = xPlayer.PlayerData.money.bank
	local price = tonumber(veh[1].price)

	if money >= price then
		Framework.Functions.ExecuteSql(false, 'UPDATE okokmarketplace_vehicles SET sold = 1 WHERE plate = "'..veh[1].plate..'" AND sold = 0')
		-- xPlayer.Functions.RemoveMoney('bank', price)
		xPlayer.Functions.RemoveMoney('bank', price, "buy-vehicle-"..veh[1].label)
		-- MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
		-- 	['@plate'] = veh[1].plate,
		-- 	['@owner'] = xPlayer.PlayerData.citizenid,
		-- })

		Framework.Functions.ExecuteSql(true, "UPDATE characters_vehicles SET citizenid = '"..xPlayer.PlayerData.citizenid.."' WHERE `plate` = '"..PlateEscapeSqli(veh[1].plate).."'")
	
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã mua phương tiện "..veh[1].label.." ("..veh[1].plate..")", 5000, 'success')
		TriggerClientEvent('okokMarketplace:updateVehiclesDropdown', xPlayer.PlayerData.source)
		TriggerClientEvent('okokMarketplace:updateVehicles', xPlayer.PlayerData.source)

		if xTarget ~= nil then
			TriggerClientEvent('okokNotify:Alert', xTarget.PlayerData.source, "THÔNG BÁO", "Bạn đã bán thành công phương tiện "..veh[1].label.." ("..veh[1].plate..")", 5000, 'success')
		end

		if Webhook ~= '' then
			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
			local data = {
				playerid = xPlayer.PlayerData.source,
				identifier = identifierlist.license:gsub("license2:", ""),
				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
				type = "buy",
				action = "Bought a vehicle",
				item = veh[1].label.." ("..veh[1].plate..")",
				price = veh[1].price,
				desc = veh[1].description,
				from = veh[1].author_name.." ("..veh[1].author_identifier..")",
				title = "MARKETPLACE - Vehicles",
			}
			discordWenhook(data)
		end
		-- MySQL.Async.execute('UPDATE okokmarketplace_vehicles SET sold = 1 WHERE plate = @plate AND sold = 0', {['@plate'] = veh[1].plate},
		-- function (rowsChanged)
		-- 	if rowsChanged > 0 then
		-- 		xPlayer.Functions.RemoveMoney('bank', price)
		-- 		MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
		-- 			['@plate'] = veh[1].plate,
		-- 			['@owner'] = xPlayer.PlayerData.citizenid,
		-- 		})
		-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You bought the vehicle "..veh[1].label.." ("..veh[1].plate..")", 5000, 'success')
		-- 		TriggerClientEvent('okokMarketplace:updateVehiclesDropdown', xPlayer.PlayerData.source)
		-- 		TriggerClientEvent('okokMarketplace:updateVehicles', xPlayer.PlayerData.source)
		-- 		if xTarget ~= nil then
		-- 			TriggerClientEvent('okokNotify:Alert', xTarget.PlayerData.source, "THÔNG BÁO", "You sold the vehicle "..veh[1].label.." ("..veh[1].plate..")", 5000, 'success')
		-- 		end
		-- 		if Webhook ~= '' then
		-- 			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 			local data = {
		-- 				playerid = xPlayer.PlayerData.source,
		-- 				identifier = identifierlist.license:gsub("license2:", ""),
		-- 				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 				type = "buy",
		-- 				action = "Bought a vehicle",
		-- 				item = veh[1].label.." ("..veh[1].plate..")",
		-- 				price = veh[1].price,
		-- 				desc = veh[1].description,
		-- 				from = veh[1].author_name.." ("..veh[1].author_identifier..")",
		-- 				title = "MARKETPLACE - Vehicles",
		-- 			}
		-- 			discordWenhook(data)
		-- 		end
		-- 	else
		-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Something went wrong, please try again later!", 5000, 'error')
		-- 	end
		-- end)
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You don't have enough money to buy this vehicle", 5000, 'error')
	end
end)

RegisterServerEvent("okokMarketplace:buyItem")
AddEventHandler("okokMarketplace:buyItem", function(item)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)
	local xTarget = Framework.Functions.GetPlayerByCitizenId(item[1].author_identifier)
	local money = xPlayer.PlayerData.money.bank
	local price = tonumber(item[1].price)

	if money >= price then
		Framework.Functions.ExecuteSql(false, 'UPDATE okokmarketplace_items SET sold = 1 WHERE id = "'..item[1].id..'" AND item_id = "'..item[1].item_id..'" AND sold = 0')
		-- xPlayer.Functions.RemoveMoney('bank', price)
		xPlayer.Functions.RemoveMoney('bank', price, "buy-item-"..item[1].label)
		-- MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
		-- 	['@plate'] = veh[1].plate,
		-- 	['@owner'] = xPlayer.PlayerData.citizenid,
		-- })

		xPlayer.Functions.RemoveMoney('bank', price)
		xPlayer.Functions.AddItem(item[1].item_id, item[1].amount)

		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã mua vật phẩm "..item[1].label.." (x"..item[1].amount..")", 5000, 'success')
		TriggerClientEvent('okokMarketplace:updateItemsDropdown', xPlayer.PlayerData.source)
		TriggerClientEvent('okokMarketplace:updateItems', xPlayer.PlayerData.source)
		if xTarget ~= nil then
			TriggerClientEvent('okokNotify:Alert', xTarget.PlayerData.source, "THÔNG BÁO", "Bạn đã bán vật phẩm "..item[1].label.." (x"..item[1].amount..")", 5000, 'success')
		end
		if Webhook ~= '' then
			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
			local data = {
				playerid = xPlayer.PlayerData.source,
				identifier = identifierlist.license:gsub("license2:", ""),
				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
				type = "buy",
				action = "Bought an item",
				item = item[1].label.." (x"..item[1].amount..")",
				price = item[1].price,
				desc = item[1].description,
				from = item[1].author_name.." ("..item[1].author_identifier..")",
				title = "MARKETPLACE - Items",
			}
			discordWenhook(data)
		end

		-- MySQL.Async.execute('UPDATE okokmarketplace_items SET sold = 1 WHERE id = @id AND item_id = @item_id AND sold = 0', {
		-- 	['@id'] = item[1].id,
		-- 	['@item_id'] = item[1].item_id,
		-- },function (rowsChanged)
		-- 	if rowsChanged > 0 then
		-- 		xPlayer.Functions.RemoveMoney('bank', price)
		-- 		xPlayer.Functions.AddItem(item[1].item_id, item[1].amount)

		-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You bought the item "..item[1].label.." (x"..item[1].amount..")", 5000, 'success')
		-- 		TriggerClientEvent('okokMarketplace:updateItemsDropdown', xPlayer.PlayerData.source)
		-- 		TriggerClientEvent('okokMarketplace:updateItems', xPlayer.PlayerData.source)
		-- 		if xTarget ~= nil then
		-- 			TriggerClientEvent('okokNotify:Alert', xTarget.PlayerData.source, "THÔNG BÁO", "You sold the item "..item[1].label.." (x"..item[1].amount..")", 5000, 'success')
		-- 		end
		-- 		if Webhook ~= '' then
		-- 			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 			local data = {
		-- 				playerid = xPlayer.PlayerData.source,
		-- 				identifier = identifierlist.license:gsub("license2:", ""),
		-- 				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 				type = "buy",
		-- 				action = "Bought an item",
		-- 				item = item[1].label.." (x"..item[1].amount..")",
		-- 				price = item[1].price,
		-- 				desc = item[1].description,
		-- 				from = item[1].author_name.." ("..item[1].author_identifier..")",
		-- 				title = "MARKETPLACE - Items",
		-- 			}
		-- 			discordWenhook(data)
		-- 		end
		-- 	else
		-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Something went wrong, please try again later!", 5000, 'error')
		-- 	end
		-- end)
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn không đủ tiền!", 5000, 'error')
	end
end)

RegisterServerEvent("okokMarketplace:buyBlackmarket")
AddEventHandler("okokMarketplace:buyBlackmarket", function(blackmarket)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)
	local xTarget = Framework.Functions.GetPlayerByCitizenId(item[1].author_identifier)
	local money
	local price = tonumber(blackmarket[1].price)

	if Config.UseDirtyMoneyOnBlackmarket then
		-- money = xPlayer.getAccount('black_money').money
		-- TODO: handle black money in pepe framework or use bank money
		money = xPlayer.PlayerData.money.bank
	else
		money = xPlayer.PlayerData.money.bank
	end

	if money >= price then
		if blackmarket[1].type == "item" and xPlayer.Functions.AddItem(blackmarket[1].item_id, blackmarket[1].amount) then
			-- xPlayer.Functions.AddItem(blackmarket[1].item_id, blackmarket[1].amount)
			if Config.UseDirtyMoneyOnBlackmarket then
				-- xPlayer.Functions.RemoveMoney('black_money', price)
				-- TODO : handle black money in pepe framework
				xPlayer.Functions.RemoveMoney('bank', price)
			else
				xPlayer.Functions.RemoveMoney('bank', price)
			end

			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã mua vật phẩm "..blackmarket[1].label, 5000, 'success')
			TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
			TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
			if xTarget ~= nil then
				TriggerClientEvent('okokNotify:Alert', xTarget.PlayerData.source, "THÔNG BÁO", "Bạn đã bán vật phẩm "..blackmarket[1].label, 5000, 'success')
			end
			if Webhook ~= '' then
				local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
				local data = {
					playerid = xPlayer.PlayerData.source,
					identifier = identifierlist.license:gsub("license2:", ""),
					discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
					type = "buy",
					action = "Bought an item",
					item = blackmarket[1].label.." (x"..blackmarket[1].amount..")",
					price = blackmarket[1].price,
					desc = blackmarket[1].description,
					from = blackmarket[1].author_name.." ("..blackmarket[1].author_identifier..")",
					title = "MARKETPLACE - Blackmarket",
				}
				discordWenhook(data)
			end

			-- MySQL.Async.execute('UPDATE okokmarketplace_blackmarket SET sold = 1 WHERE id = @id AND item_id = @item_id AND sold = 0', {
			-- 	['@id'] = blackmarket[1].id,
			-- 	['@item_id'] = blackmarket[1].item_id,
			-- },function (rowsChanged)
			-- 	if rowsChanged > 0 then
			-- 		xPlayer.Functions.AddItem(blackmarket[1].item_id, blackmarket[1].amount)
			-- 		if Config.UseDirtyMoneyOnBlackmarket then
			-- 			xPlayer.Functions.RemoveMoney('black_money', price)
			-- 		else
			-- 			xPlayer.Functions.RemoveMoney('bank', price)
			-- 		end

			-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You bought the item "..blackmarket[1].label, 5000, 'success')
			-- 		TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
			-- 		TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
			-- 		if xTarget ~= nil then
			-- 			TriggerClientEvent('okokNotify:Alert', xTarget.PlayerData.source, "THÔNG BÁO", "You sold the item "..blackmarket[1].label, 5000, 'success')
			-- 		end
			-- 		if Webhook ~= '' then
			-- 			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
			-- 			local data = {
			-- 				playerid = xPlayer.PlayerData.source,
			-- 				identifier = identifierlist.license:gsub("license2:", ""),
			-- 				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
			-- 				type = "buy",
			-- 				action = "Bought an item",
			-- 				item = blackmarket[1].label.." (x"..blackmarket[1].amount..")",
			-- 				price = blackmarket[1].price,
			-- 				desc = blackmarket[1].description,
			-- 				from = blackmarket[1].author_name.." ("..blackmarket[1].author_identifier..")",
			-- 				title = "MARKETPLACE - Blackmarket",
			-- 			}
			-- 			discordWenhook(data)
			-- 		end
			-- 	else
			-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Something went wrong, please try again later!", 5000, 'error')
			-- 	end
			-- end)
		elseif blackmarket[1].type == "weapon" then-- and not xPlayer.hasWeapon(blackmarket[1].item_id) then
			-- MySQL.Async.execute('UPDATE okokmarketplace_blackmarket SET sold = 1 WHERE id = @id AND item_id = @item_id AND sold = 0', {
			-- 	['@id'] = blackmarket[1].id,
			-- 	['@item_id'] = blackmarket[1].item_id,
			-- },function (rowsChanged)
			-- 	if rowsChanged > 0 then
			-- 		xPlayer.addWeapon(blackmarket[1].item_id, blackmarket[1].amount)
			-- 		if Config.UseDirtyMoneyOnBlackmarket then
			-- 			xPlayer.Functions.RemoveMoney('black_money', price)
			-- 		else
			-- 			xPlayer.Functions.RemoveMoney('bank', price)
			-- 		end

			-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You bought the item "..blackmarket[1].label, 5000, 'success')
			-- 		TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
			-- 		TriggerClientEvent('okokMarketplace:updateBlackmarket', xPlayer.PlayerData.source)
			-- 		if xTarget ~= nil then
			-- 			TriggerClientEvent('okokNotify:Alert', xTarget.PlayerData.source, "THÔNG BÁO", "You sold the item "..blackmarket[1].label, 5000, 'success')
			-- 		end
			-- 		if Webhook ~= '' then
			-- 			local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
			-- 			local data = {
			-- 				playerid = xPlayer.PlayerData.source,
			-- 				identifier = identifierlist.license:gsub("license2:", ""),
			-- 				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
			-- 				type = "buy",
			-- 				action = "Bought an item",
			-- 				item = blackmarket[1].label.." (x"..blackmarket[1].amount..")",
			-- 				price = blackmarket[1].price,
			-- 				desc = blackmarket[1].description,
			-- 				from = blackmarket[1].author_name.." ("..blackmarket[1].author_identifier..")",
			-- 				title = "MARKETPLACE - Blackmarket",
			-- 			}
			-- 			discordWenhook(data)
			-- 		end
			-- 	else
			-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Something went wrong, please try again later!", 5000, 'error')
			-- 	end
			-- end)
		else
			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Túi đã đầy! Không thể mua vật phẩm này", 5000, 'error')
		end
	else
		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn không đủ tiền!", 5000, 'error')
	end
end)

RegisterServerEvent("okokMarketplace:removeMyAd")
AddEventHandler("okokMarketplace:removeMyAd", function(item)
	local _source = source
	local xPlayer = Framework.Functions.GetPlayer(_source)

	if item.plate then
		Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_vehicles WHERE item_id = "'..item.item_id..'" AND id = "'..item.id..'"'
		, function(veh)
			Framework.Functions.ExecuteSql(true, 'DELETE FROM okokmarketplace_vehicles WHERE item_id = "'..veh[1].item_id..'" AND id = "'..veh[1].id..'"')
			if veh[1].sold then
				xPlayer.Functions.AddMoney('bank', tonumber(veh[1].price))
				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã nhận được "..veh[1].price.." $", 5000, 'success')
				if Webhook ~= '' then
					local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
					local data = {
						playerid = xPlayer.PlayerData.source,
						identifier = identifierlist.license:gsub("license2:", ""),
						discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
						type = "claim",
						action = "Claimed an Ad",
						item = veh[1].label.." ("..veh[1].plate..")",
						price = veh[1].price,
						desc = veh[1].description,
						title = "MARKETPLACE - Vehicles",
					}
					discordWenhook(data)
				end
			else
				
				Framework.Functions.ExecuteSql(true, "UPDATE characters_vehicles SET citizenid = '"..veh[1].author_identifier.."' WHERE `plate` = '"..PlateEscapeSqli(veh[1].plate).."'")

				-- MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
				-- 	['@plate'] = veh[1].plate,
				-- 	['@owner'] = veh[1].author_identifier,
				-- })

				TriggerClientEvent('okokMarketplace:updateVehiclesDropdown', xPlayer.PlayerData.source)
				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã huỷ bán mặt hàng "..veh[1].label.." ("..veh[1].plate..")", 5000, 'success')
				if Webhook ~= '' then
					local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
					local data = {
						playerid = xPlayer.PlayerData.source,
						identifier = identifierlist.license:gsub("license2:", ""),
						discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
						type = "cancel",
						action = "Canceled an Ad",
						item = veh[1].label.." ("..veh[1].plate..")",
						price = veh[1].price,
						desc = veh[1].description,
						title = "MARKETPLACE - Vehicles",
					}
					discordWenhook(data)
				end
			end
		end)

		-- MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_vehicles WHERE item_id = @item_id AND id = @id', {
		-- 	['@item_id'] = item.item_id,
		-- 	['@id'] = item.id,
		-- }, function(veh)
		-- 	MySQL.Async.execute('DELETE FROM okokmarketplace_vehicles WHERE item_id = @item_id AND id = @id', {
		-- 		['@id'] = veh[1].id,
		-- 		['@item_id'] = veh[1].item_id,
		-- 	},function (rowDeleted)
		-- 		if rowDeleted > 0 then
		-- 			if veh[1].sold then
		-- 				xPlayer.Functions.AddMoney('bank', tonumber(veh[1].price))
		-- 				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You claimed "..veh[1].price.." $", 5000, 'success')
		-- 				if Webhook ~= '' then
		-- 					local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 					local data = {
		-- 						playerid = xPlayer.PlayerData.source,
		-- 						identifier = identifierlist.license:gsub("license2:", ""),
		-- 						discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 						type = "claim",
		-- 						action = "Claimed an Ad",
		-- 						item = veh[1].label.." ("..veh[1].plate..")",
		-- 						price = veh[1].price,
		-- 						desc = veh[1].description,
		-- 						title = "MARKETPLACE - Vehicles",
		-- 					}
		-- 					discordWenhook(data)
		-- 				end
		-- 			else
		-- 				MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
		-- 					['@plate'] = veh[1].plate,
		-- 					['@owner'] = veh[1].author_identifier,
		-- 				})
		-- 				TriggerClientEvent('okokMarketplace:updateVehiclesDropdown', xPlayer.PlayerData.source)
		-- 				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You canceled the AD "..veh[1].label.." ("..veh[1].plate..")", 5000, 'success')
		-- 				if Webhook ~= '' then
		-- 					local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 					local data = {
		-- 						playerid = xPlayer.PlayerData.source,
		-- 						identifier = identifierlist.license:gsub("license2:", ""),
		-- 						discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 						type = "cancel",
		-- 						action = "Canceled an Ad",
		-- 						item = veh[1].label.." ("..veh[1].plate..")",
		-- 						price = veh[1].price,
		-- 						desc = veh[1].description,
		-- 						title = "MARKETPLACE - Vehicles",
		-- 					}
		-- 					discordWenhook(data)
		-- 				end
		-- 			end
		-- 		else
		-- 			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Something went wrong, please try again later!", 5000, 'error')
		-- 		end
		-- 	end)
		-- end)
	elseif item.type then
		Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_blackmarket WHERE item_id = "'..item.item_id..'" AND id = "'..item.id..'"'
		, function(blackmarket)
			local canCarry = true

			if not blackmarket[1].sold then
				if blackmarket[1].type == "weapon" then -- and xPlayer.hasWeapon(blackmarket[1].item_id) then
					canCarry = false
					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Túi đã đầy, không thể nhận lại vật phẩm", 5000, 'error')
				elseif blackmarket[1].type == "item" and not xPlayer.Functions.AddItem(blackmarket[1].item_id, tonumber(blackmarket[1].amount)) then
					canCarry = false
					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Túi đã đầy, không thể nhận lại vật phẩm", 5000, 'error')
				end
			end

			if canCarry then
				Framework.Functions.ExecuteSql(false, 'DELETE FROM okokmarketplace_blackmarket WHERE item_id = "'..blackmarket[1].item_id..'" AND id = "'..blackmarket[1].id..'"')
				
				if blackmarket[1].sold then
					xPlayer.Functions.AddMoney('bank', tonumber(blackmarket[1].price), "cancel-blackmarket-ad"..item.item_id)
					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn nhận được "..blackmarket[1].price.." $", 5000, 'success')
					if Webhook ~= '' then
						local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
						local data = {
							playerid = xPlayer.PlayerData.source,
							identifier = identifierlist.license:gsub("license2:", ""),
							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
							type = "claim",
							action = "Claimed an Ad",
							item = blackmarket[1].label.." (x"..blackmarket[1].amount..")",
							price = blackmarket[1].price,
							desc = blackmarket[1].description,
							title = "MARKETPLACE - Blackmarket",
						}
						discordWenhook(data)
					end
				else
					-- if blackmarket[1].type == "weapon" then
					-- 	xPlayer.addWeapon(blackmarket[1].item_id, 1)
					-- elseif blackmarket[1].type == "item" then
					-- 	xPlayer.Functions.AddItem(blackmarket[1].item_id, tonumber(blackmarket[1].amount))
					-- end
					TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã huỷ bán mặt hàng "..blackmarket[1].label.." (x"..blackmarket[1].amount..")", 5000, 'success')
					if Webhook ~= '' then
						local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
						local data = {
							playerid = xPlayer.PlayerData.source,
							identifier = identifierlist.license:gsub("license2:", ""),
							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
							type = "cancel",
							action = "Canceled an Ad",
							item = blackmarket[1].label.." (x"..blackmarket[1].amount..")",
							price = blackmarket[1].price,
							desc = blackmarket[1].description,
							title = "MARKETPLACE - Blackmarket",
						}
						discordWenhook(data)
					end
				end
			end

		end)
		
		-- MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_blackmarket WHERE item_id = @item_id AND id = @id', {
		-- 	['@item_id'] = item.item_id,
		-- 	['@id'] = item.id,
		-- }, function(blackmarket)
		-- 	local canCarry = true

		-- 	if not blackmarket[1].sold then
		-- 		if blackmarket[1].type == "weapon" and xPlayer.hasWeapon(blackmarket[1].item_id) then
		-- 			canCarry = false
		-- 			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You don't have enough space to carry this item", 5000, 'error')
		-- 		elseif blackmarket[1].type == "item" and not xPlayer.Functions.AddItem(blackmarket[1].item_id, tonumber(blackmarket[1].amount)) then
		-- 			canCarry = false
		-- 			TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You don't have enough space to carry this item", 5000, 'error')
		-- 		end
		-- 	end

		-- 	if canCarry then
		-- 		MySQL.Async.execute('DELETE FROM okokmarketplace_blackmarket WHERE item_id = @item_id AND id = @id', {
		-- 			['@id'] = blackmarket[1].id,
		-- 			['@item_id'] = blackmarket[1].item_id,
		-- 		},function (rowDeleted)
		-- 			if rowDeleted > 0 then
		-- 				if blackmarket[1].sold then
		-- 					xPlayer.Functions.AddMoney('bank', tonumber(blackmarket[1].price))
		-- 					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You claimed "..blackmarket[1].price.." $", 5000, 'success')
		-- 					if Webhook ~= '' then
		-- 						local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 						local data = {
		-- 							playerid = xPlayer.PlayerData.source,
		-- 							identifier = identifierlist.license:gsub("license2:", ""),
		-- 							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 							type = "claim",
		-- 							action = "Claimed an Ad",
		-- 							item = blackmarket[1].label.." (x"..blackmarket[1].amount..")",
		-- 							price = blackmarket[1].price,
		-- 							desc = blackmarket[1].description,
		-- 							title = "MARKETPLACE - Blackmarket",
		-- 						}
		-- 						discordWenhook(data)
		-- 					end
		-- 				else
		-- 					if blackmarket[1].type == "weapon" then
		-- 						xPlayer.addWeapon(blackmarket[1].item_id, 1)
		-- 					elseif blackmarket[1].type == "item" then
		-- 						xPlayer.Functions.AddItem(blackmarket[1].item_id, tonumber(blackmarket[1].amount))
		-- 					end
		-- 					TriggerClientEvent('okokMarketplace:updateBlackmarketDropdown', xPlayer.PlayerData.source)
		-- 					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You canceled the AD "..blackmarket[1].label.." (x"..blackmarket[1].amount..")", 5000, 'success')
		-- 					if Webhook ~= '' then
		-- 						local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 						local data = {
		-- 							playerid = xPlayer.PlayerData.source,
		-- 							identifier = identifierlist.license:gsub("license2:", ""),
		-- 							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 							type = "cancel",
		-- 							action = "Canceled an Ad",
		-- 							item = blackmarket[1].label.." (x"..blackmarket[1].amount..")",
		-- 							price = blackmarket[1].price,
		-- 							desc = blackmarket[1].description,
		-- 							title = "MARKETPLACE - Blackmarket",
		-- 						}
		-- 						discordWenhook(data)
		-- 					end
		-- 				end
		-- 			else
		-- 				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Something went wrong, please try again later!", 5000, 'error')
		-- 			end
		-- 		end)
		-- 	end
		-- end)
	else
		Framework.Functions.ExecuteSql(false, 'SELECT * FROM okokmarketplace_items WHERE item_id = "'..item.item_id..'" AND id = "'..item.id..'"'
		, function(items)
			Framework.Functions.ExecuteSql(false, 'DELETE FROM okokmarketplace_items WHERE item_id = "'..items[1].item_id..'" AND id = "'..items[1].id..'"')
			
			if items[1].sold then
				xPlayer.Functions.AddMoney('bank', tonumber(items[1].price))
				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã nhận được "..items[1].price.." $", 5000, 'success')
				if Webhook ~= '' then
					local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
					local data = {
						playerid = xPlayer.PlayerData.source,
						identifier = identifierlist.license:gsub("license2:", ""),
						discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
						type = "claim",
						action = "Claimed an Ad",
						item = items[1].label.." (x"..items[1].amount..")",
						price = items[1].price,
						desc = items[1].description,
						title = "MARKETPLACE - Items",
					}
					discordWenhook(data)
				end
			else
				if xPlayer.Functions.AddItem(items[1].item_id, tonumber(items[1].amount)) then
					-- xPlayer.Functions.AddItem(items[1].item_id, tonumber(items[1].amount))
					TriggerClientEvent('okokMarketplace:updateItemsDropdown', xPlayer.PlayerData.source)
					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Bạn đã huỷ bán mặt hàng "..items[1].label.." (x"..items[1].amount..")", 5000, 'success')
					if Webhook ~= '' then
						local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
						local data = {
							playerid = xPlayer.PlayerData.source,
							identifier = identifierlist.license:gsub("license2:", ""),
							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
							type = "cancel",
							action = "Canceled an Ad",
							item = items[1].label.." (x"..items[1].amount..")",
							price = items[1].price,
							desc = items[1].description,
							title = "MARKETPLACE - Items",
						}
						discordWenhook(data)
					end
				else
					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Túi đã đầy, không thể nhận lại vật phẩm", 5000, 'error')
				end
			end
			
		end)

		-- MySQL.Async.fetchAll('SELECT * FROM okokmarketplace_items WHERE item_id = @item_id AND id = @id', {
		-- 	['@item_id'] = item.item_id,
		-- 	['@id'] = item.id,
		-- }, function(items)
		-- 	if xPlayer.Functions.AddItem(items[1].item_id, tonumber(items[1].amount)) then
		-- 		MySQL.Async.execute('DELETE FROM okokmarketplace_items WHERE item_id = @item_id AND id = @id', {
		-- 			['@id'] = items[1].id,
		-- 			['@item_id'] = items[1].item_id,
		-- 		},function (rowDeleted)
		-- 			if rowDeleted > 0 then
		-- 				if items[1].sold then
		-- 					xPlayer.Functions.AddMoney('bank', tonumber(items[1].price))
		-- 					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You claimed "..items[1].price.." $", 5000, 'success')
		-- 					if Webhook ~= '' then
		-- 						local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 						local data = {
		-- 							playerid = xPlayer.PlayerData.source,
		-- 							identifier = identifierlist.license:gsub("license2:", ""),
		-- 							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 							type = "claim",
		-- 							action = "Claimed an Ad",
		-- 							item = items[1].label.." (x"..items[1].amount..")",
		-- 							price = items[1].price,
		-- 							desc = items[1].description,
		-- 							title = "MARKETPLACE - Items",
		-- 						}
		-- 						discordWenhook(data)
		-- 					end
		-- 				else
		-- 					xPlayer.Functions.AddItem(items[1].item_id, tonumber(items[1].amount))
		-- 					TriggerClientEvent('okokMarketplace:updateItemsDropdown', xPlayer.PlayerData.source)
		-- 					TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You canceled the AD "..items[1].label.." (x"..items[1].amount..")", 5000, 'success')
		-- 					if Webhook ~= '' then
		-- 						local identifierlist = ExtractIdentifiers(xPlayer.PlayerData.source)
		-- 						local data = {
		-- 							playerid = xPlayer.PlayerData.source,
		-- 							identifier = identifierlist.license:gsub("license2:", ""),
		-- 							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
		-- 							type = "cancel",
		-- 							action = "Canceled an Ad",
		-- 							item = items[1].label.." (x"..items[1].amount..")",
		-- 							price = items[1].price,
		-- 							desc = items[1].description,
		-- 							title = "MARKETPLACE - Items",
		-- 						}
		-- 						discordWenhook(data)
		-- 					end
		-- 				end
		-- 			else
		-- 				TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "Something went wrong, please try again later!", 5000, 'error')
		-- 			end
		-- 		end)
		-- 	else
		-- 		TriggerClientEvent('okokNotify:Alert', xPlayer.PlayerData.source, "THÔNG BÁO", "You don't have enough space to carry this item", 5000, 'error')
		-- 	end
		-- end)
	end
	TriggerClientEvent('okokMarketplace:updateMyAds', xPlayer.PlayerData.source)
end)

-------------------------- IDENTIFIERS

function ExtractIdentifiers(id)
	local identifiers = {
		steam = "",
		ip = "",
		discord = "",
		license = "",
		xbl = "",
		live = ""
	}

	for i = 0, GetNumPlayerIdentifiers(id) - 1 do
		local playerID = GetPlayerIdentifier(id, i)

		if string.find(playerID, "steam") then
			identifiers.steam = playerID
		elseif string.find(playerID, "ip") then
			identifiers.ip = playerID
		elseif string.find(playerID, "discord") then
			identifiers.discord = playerID
		elseif string.find(playerID, "license") then
			identifiers.license = playerID
		elseif string.find(playerID, "xbl") then
			identifiers.xbl = playerID
		elseif string.find(playerID, "live") then
			identifiers.live = playerID
		end
	end

	return identifiers
end

-------------------------- WEBHOOK

function discordWenhook(data)
	local color = '65352'
	local category = 'test'

	local information = {}

	if data.type == 'add' then
		color = Config.AddAdColor
	elseif data.type == 'buy' then
		color = Config.BuyItemColor
		information = {
			{
				["color"] = color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Item:** '..data.item..'\n**Price:** '..data.price..'\n**Description:** '..data.desc..'\n**From:** '..data.from..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'cancel' then
		color = Config.RemoveAdColor
	elseif data.type == 'claim' then
		color = Config.ClaimAdColor
	end
	
	information = {
		{
			["color"] = color,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = data.title,
			["description"] = '**Action:** '..data.action..'\n**Item:** '..data.item..'\n**Price:** '..data.price..'\n**Description:** '..data.desc..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}

	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end


function PlateEscapeSqli(str)
	-- if str:len() <= 8 then 
	 local replacements = { ['"'] = '\\"', ["'"] = "\\'", ["\\"] = "", ["/"] = "", ["@"] = "", ["-"] = ""}
	 return str:gsub( "['\"]", replacements)
	-- end
end