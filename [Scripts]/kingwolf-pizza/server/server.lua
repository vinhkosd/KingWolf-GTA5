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