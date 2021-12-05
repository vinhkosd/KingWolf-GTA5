Framework= nil
local Rentals = {}
local RentCount = {}
local RentalPlate = 10000
--form bs KWX-50000
TriggerEvent('Framework:GetObject', function(obj) Framework= obj end)

RegisterServerEvent('kingwolf-rentcar:server:CheckRental')
AddEventHandler('kingwolf-rentcar:server:CheckRental', function()
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    if RentalPlate >= 99999 then
        TriggerClientEvent("Framework:Notify", src, "Đã hết xe thuê cho đợt hôm nay!!", "error", 5000)
    else
        -- if Rentals[CitizenId] ~= nil then
        --     TriggerClientEvent("Framework:Notify", src, "Vui lòng trả xe bạn đã thuê trước khi thuê xe mới!!", "error", 5000)
        -- else
            if RentCount[CitizenId] == nil then
                RentCount[CitizenId] = 0
            end
            local payCash = RentCount[CitizenId] * 500 + Config.PayAmount
            if Player.Functions.RemoveMoney("cash", payCash) then
                RentCount[CitizenId] = RentCount[CitizenId] + 1
                TriggerClientEvent("kingwolf-rentcar:client:spawn:vehicle", src)
            else
                TriggerClientEvent("Framework:Notify", src, "Bạn không đủ tiền thuê xe ("..payCash.."$)!!", "error", 5000)
            end
        -- end
    end
end)

RegisterServerEvent('kingwolf-rentcar:server:ReturnPay')
AddEventHandler('kingwolf-rentcar:server:ReturnPay', function(PlateText, damage)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if Rentals[CitizenId] ~= nil and Rentals[CitizenId] == PlateText then
        TriggerClientEvent("kingwolf-rentcar:client:despawn:vehicle", src)
        TriggerClientEvent("Framework:Notify", src, "Trả xe thành công!!", "success", 5000)
        Rentals[CitizenId] = nil
        
        if damage >= 90.0 then
            local returnCash = RentCount[CitizenId] * Config.ReturnPay
            Player.Functions.AddMoney("cash", returnCash)
        else
            local returnCash = RentCount[CitizenId] * math.floor(damage)
            Player.Functions.AddMoney("cash", returnCash)
        end
    else
        TriggerClientEvent("Framework:Notify", src, "Đây không phải xe thuê của bạn!!", "error", 5000)
    end
end)

Framework.Functions.CreateCallback('kingwolf-rentcar:server:registerPlate', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    RentalPlate = RentalPlate + 1
        local PlateText = "FKW"..RentalPlate
        Rentals[CitizenId] = PlateText
        cb(PlateText)
end)