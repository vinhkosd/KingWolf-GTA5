Framework= nil
local RentalPlate = 1000
TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

function GetCraftingConfig(ItemId)
    return Config.CraftingItems[ItemId]
end

RegisterServerEvent('kingwolf-pizza:server:CheckRental')
AddEventHandler('kingwolf-pizza:server:CheckRental', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    TriggerClientEvent("kingwolf-pizza:client:spawn:vehicle", src)
end)

Framework.Functions.CreateCallback('kingwolf-pizza:server:registerPlate', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    RentalPlate = RentalPlate + 1
    local PlateText = "PIZA"..RentalPlate
    cb(PlateText)
end)

Framework.Functions.CreateUseableItem("pizzaga", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:eat:pizza', source, item.name, 'sandwich')
        end
    end
end)

Framework.Functions.CreateUseableItem("pizzasalad", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:eat:pizza', source, item.name, 'sandwich')
        end
    end
end)

Framework.Functions.CreateUseableItem("pizzathapcam", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:eat:pizza', source, item.name, 'sandwich')
        end
    end
end)

Framework.Functions.CreateUseableItem("pizzahaisan", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:eat:pizza', source, item.name, 'sandwich')
        end
    end
end)

Framework.Functions.CreateUseableItem("pizzachay", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('pepe-items:client:use:eat:pizza', source, item.name, 'sandwich')
        end
    end
end)

Framework.Commands.Add("needfood", "Khát đói", {}, false, function(source, args)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Player ~= nil then
        local oldHunger = Player.PlayerData.metadata["hunger"] - 20
        local oldThirst = Player.PlayerData.metadata["thirst"] - 20
        Player.Functions.SetMetaData("hunger", oldHunger)
        Player.Functions.SetMetaData("thirst", oldThirst)
        TriggerClientEvent("pepe-hud:client:update:needs", src, 20, 20)
    end
end, "god")

