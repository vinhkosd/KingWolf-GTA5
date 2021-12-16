Framework= nil
local RentalPlate = 100
TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

function GetCraftingConfig(ItemId)
    return Config.CraftingItems[ItemId]
end

RegisterServerEvent('kingwolf-trada:server:CheckRental')
AddEventHandler('kingwolf-trada:server:CheckRental', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    TriggerClientEvent("kingwolf-trada:client:spawn:vehicle", src)
end)

Framework.Functions.CreateCallback('kingwolf-trada:server:registerPlate', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    RentalPlate = RentalPlate + 1
    local PlateText = "TRADA"..RentalPlate
    cb(PlateText)
end)

Framework.Functions.CreateUseableItem("thuoc-lao", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:tra-da:thuoc-lao', source, true)
        end
    end
end)

Framework.Functions.CreateUseableItem("orange-juice", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:tra-da:drink', source, item.name, 'water')
        end
    end
end)

Framework.Functions.CreateUseableItem("bottle-water", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:tra-da:drink', source, item.name, 'water')
        end
    end
end)

Framework.Functions.CreateUseableItem("fruit-plate", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:tra-da:drink', source, item.name, 'water')
        end
    end
end)

Framework.Functions.CreateUseableItem("ice-scream", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:tra-da:drink', source, item.name, 'Cup')
        end
    end
end)

RegisterServerEvent('kingwolf-trada:server:GetWater')
AddEventHandler('kingwolf-trada:server:GetWater', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if Player.Functions.AddItem('water-bucket', 2) then
		TriggerClientEvent("Framework:Notify", src, "Lấy nước thành công!", "Success", 4000)
		TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items['water-bucket'], "add")
	else
		TriggerClientEvent("Framework:Notify", src, "Túi của bạn đã đầy!!", "error", 5000)
	end
end)