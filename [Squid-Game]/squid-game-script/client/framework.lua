Framework = {}

function Framework.showNotification(message)
    if Config.Framework == "ESX" then
        return ESX.ShowNotification(message)
    elseif Config.Framework == "QB" then
        TriggerEvent('QBCore:Notify', message)
    elseif Config.Framework == "vRP" then
        vRP.notify({message})
    elseif Config.Framework == "pepe" then
        -- TODO: Add your notifications
        TriggerEvent("Framework:Notify", message)
        return true
    else
        TriggerEvent("squidgame:notification", message)
        return true
    end
end