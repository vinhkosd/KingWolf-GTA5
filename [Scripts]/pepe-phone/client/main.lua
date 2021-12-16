Framework = nil
takePhoto = false
frontCam = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local PlayerJob = {}

phoneProp = 0
local phoneModel = `prop_npc_phone_02`

PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    Mails = {},
    Adverts = {},
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
}

RegisterNetEvent('pepe-phone:client:RaceNotify')
AddEventHandler('pepe-phone:client:RaceNotify', function(message)
    if PhoneData.isOpen then
        print('lekker racen')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Racing",
                text = message,
                icon = "fas fa-flag-checkered",
                color = "#353b48",
                timeout = 1500,
            },
        })
    end
end)


-- RegisterNetEvent('pepe-phone:client:salaris')
-- AddEventHandler('pepe-phone:client:salaris')
--     if PhoneData.isOpen then
--         print('geld gekregen')
--     else
--         SendNUIMessage({
--             action = "PhoneNotification",
--             PhoneNotify = {
--                 title = "Racing",
--                 text = "test",
--                 icon = "fas fa-flag-checkered",
--                 color = "#353b48",
--                 timeout = 1500,
--             },
--         })
--     end
-- end)

RegisterNetEvent('pepe-phone:client:addNotification')
AddEventHandler('pepe-phone:client:addNotification', function(message)
    if PhoneData.isOpen then
        -- print('lekker racen')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Thông báo",
                text = message,
                icon = "fas fa-flag-checkered",
                color = "#353b48",
                timeout = 2000,
            },
        })
    end
end)



RegisterNetEvent('pepe-phone:client:AddRecentCall')
AddEventHandler('pepe-phone:client:AddRecentCall', function(data, time, type)
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    })
    TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    SendNUIMessage({ 
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    if JobInfo.name == "police" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    elseif PlayerJob.name == "police" and JobInfo.name == "unemployed" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    end

    PlayerJob = JobInfo
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background

    PhoneData.MetaData.background = background
    TriggerServerEvent('pepe-phone:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local isLoggedIn = false

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.OpenPhone) then
            if not PhoneData.isOpen then
                local IsHandcuffed = false
                if not IsHandcuffed then
                    OpenPhone()
                else
                    SendNUIMessage({
                        action = "PhoneNotification",
                        PhoneNotify = {
                            title = "Cài đặt",
                            text = "Không thể thực hiện hành động",
                            icon = "fa fa-cog",
                            color = "white",
                            timeout = 1500,
                        },
                    })
                end
            end
        end
        Citizen.Wait(3)
    end
end)

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        if isLoggedIn then
            Framework.Functions.TriggerCallback('pepe-phone:server:GetPhoneData', function(pData)   
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
                    PhoneData.Contacts = pData.PlayerContacts
                end

                if pData.Cars ~= nil and next(pData.Cars) ~= nil then
                    PhoneData.Cars = pData.Cars
                end

                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
                SendNUIMessage({
                    action = "RefreshAutoscout",
                    Cars = PhoneData.Cars
                })
            end)
        end
    end
end)

function LoadPhone()
    isLoggedIn = true
    Framework.Functions.TriggerCallback('pepe-phone:server:GetPhoneData', function(pData)
        PlayerJob = Framework.Functions.GetPlayerData().job
        PhoneData.PlayerData = Framework.Functions.GetPlayerData()
        local PhoneMeta = PhoneData.PlayerData.metadata["phone"]
        PhoneData.MetaData = PhoneMeta

        if pData.InstalledApps ~= nil and next(pData.InstalledApps) ~= nil then
            for k, v in pairs(pData.InstalledApps) do
                local AppData = Config.StoreApps[v.app]
                Config.PhoneApplications[v.app] = {
                    app = v.app,
                    color = AppData.color,
                    icon = AppData.icon,
                    tooltipText = AppData.title,
                    tooltipPos = "right",
                    job = AppData.job,
                    blockedjobs = AppData.blockedjobs,
                    slot = AppData.slot,
                    Alerts = 0,
                }
            end
        end

        if PhoneMeta.profilepicture == nil then
            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = PhoneMeta.profilepicture
        end

        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do 
                Config.PhoneApplications[k].Alerts = v 
            end
        end

        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then 
            PhoneData.MentionedTweets = pData.MentionedTweets 
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
            PhoneData.Contacts = pData.PlayerContacts
        end

        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end

            PhoneData.Chats = Chats
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end

        if pData.Tweets ~= nil and next(pData.Tweets) ~= nil then
            PhoneData.Tweets = pData.Tweets
        end

        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end

        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end

        if pData.Cars ~= nil and next(pData.Cars) ~= nil then
            PhoneData.Cars = pData.Cars
        end

        if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
            PhoneData.CryptoTransactions = pData.CryptoTransactions
        end

        SendNUIMessage({ 
            action = "LoadPhoneData", 
            PhoneData = PhoneData, 
            PlayerData = PhoneData.PlayerData,
            PlayerJob = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications 
        })
    end)
end

Citizen.CreateThread(function()
    Wait(500)
    LoadPhone()
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    PhoneData = {
        MetaData = {},
        isOpen = false,
        PlayerData = nil,
        Contacts = {},
        Tweets = {},
        MentionedTweets = {},
        Hashtags = {},
        Chats = {},
        Invoices = {},
        CallData = {},
        RecentCalls = {},
        Garage = {},
        Mails = {},
        Adverts = {},
        GarageVehicles = {},
        AnimationData = {
            lib = nil,
            anim = nil,
        },
        SuggestedContacts = {},
        CryptoTransactions = {},
    }

    isLoggedIn = false
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    LoadPhone()
end)

RegisterNUICallback('HasPhone', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:HasPhone', function(HasPhone)
        cb(HasPhone)
    end)
end)

function OpenPhone()
   Framework.Functions.TriggerCallback('pepe-phone:server:HasPhone', function(HasPhone)
       if HasPhone then
            PhoneData.PlayerData = Framework.Functions.GetPlayerData()
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open",
                Tweets = PhoneData.Tweets,
                AppData = Config.PhoneApplications,
                CallData = PhoneData.CallData,
                PlayerData = PhoneData.PlayerData,
            })
            PhoneData.isOpen = true

            if not PhoneData.CallData.InCall then
                DoPhoneAnimation('cellphone_text_in')
            else
                DoPhoneAnimation('cellphone_call_to_text')
            end

            SetTimeout(250, function()
                newPhoneProp()
            end)
    
            Framework.Functions.TriggerCallback('pepe-phone:server:GetGarageVehicles', function(vehicles)
                PhoneData.GarageVehicles = vehicles
            end)
        else
            Framework.Functions.Notify("Bạn không có điện thoại", "error")
        end
   end)
end

function OpenPhoneWithNoTimeOut()
    Framework.Functions.TriggerCallback('pepe-phone:server:HasPhone', function(HasPhone)
        if HasPhone then
             PhoneData.PlayerData = Framework.Functions.GetPlayerData()
             SetNuiFocus(true, true)
             SendNUIMessage({
                 action = "open",
                 Tweets = PhoneData.Tweets,
                 AppData = Config.PhoneApplications,
                 CallData = PhoneData.CallData,
                 PlayerData = PhoneData.PlayerData,
             })
             PhoneData.isOpen = true
 
             if not PhoneData.CallData.InCall then
                 DoPhoneAnimation('cellphone_text_in')
             else
                 DoPhoneAnimation('cellphone_call_to_text')
             end
 
            --  SetTimeout(250, function()
                 newPhoneProp()
            --  end)
     
             Framework.Functions.TriggerCallback('pepe-phone:server:GetGarageVehicles', function(vehicles)
                 PhoneData.GarageVehicles = vehicles
             end)
         else
             Framework.Functions.Notify("Bạn không có điện thoại", "error")
         end
    end)
 end

function ClosePhone() 
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        -- SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        -- end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    -- SetTimeout(150, function()
        PhoneData.isOpen = false
    -- end)
end

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetTimeout(150, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId
    TriggerServerEvent('pepe-phone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('pepe-phone:client:UpdateMails')
AddEventHandler('pepe-phone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNetEvent('pepe-phone:client:UpdateBills')
AddEventHandler('pepe-phone:client:UpdateBills', function(NewData)
    PhoneData.Invoices = NewData
end)

RegisterNUICallback('AcceptMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('pepe-phone:server:ClearButtonData', data.mailId)
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('pepe-phone:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local number = data.number

    Framework.Functions.TriggerCallback('pepe-phone:server:GetPicture', function(picture)
        cb(picture)
    end, number)
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:GetInvoiceData', function(InvoiceData)
        cb(InvoiceData)
    end)
end)

function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            table.insert(ReorganizedChats, chat)
        end
    end
    PhoneData.Chats = ReorganizedChats
end

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType
    local Ped = GetPlayerPed(-1)
    local Pos = GetEntityCoords(Ped)
    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)
    if PhoneData.Chats[NumberKey] ~= nil then
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = "Chia sẻ vị trí",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })

            end
            TriggerServerEvent('pepe-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        else
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatDate].messages, {
                    message = "Chia sẻ vị trí",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('pepe-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end
    else
        table.insert(PhoneData.Chats, {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        })
        NumberKey = GetKeyByNumber(ChatNumber)
        table.insert(PhoneData.Chats[NumberKey].messages, {
            date = ChatDate,
            messages = {},
        })
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {},
            })
        elseif ChatType == "location" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = "Chia sẻ vị trí",
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            })
        end
        TriggerServerEvent('pepe-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)
    end
    Framework.Functions.TriggerCallback('pepe-phone:server:GetContactPicture', function(Chat)
        SendNUIMessage({
            action = "UpdateChat",
            chatData = Chat,
            chatNumber = ChatNumber,
        })
    end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
end)

RegisterNUICallback('SendTikkie', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType
    local Ped = GetPlayerPed(-1)
    local Pos = GetEntityCoords(Ped)
    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)
    if PhoneData.Chats[NumberKey] ~= nil then
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            end
            TriggerServerEvent('pepe-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        else
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            end
            TriggerServerEvent('pepe-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end
    else
        table.insert(PhoneData.Chats, {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        })
        NumberKey = GetKeyByNumber(ChatNumber)
        table.insert(PhoneData.Chats[NumberKey].messages, {
            date = ChatDate,
            messages = {},
        })
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.citizenid,
                type = ChatType,
                data = {},
            })
        end
        TriggerServerEvent('pepe-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)
    end
    --TriggerServerEvent('pepe-phone:server:send:tikkie')
    Framework.Functions.TriggerCallback('pepe-phone:server:GetContactPicture', function(Chat)
        SendNUIMessage({
            action = "UpdateChat",
            chatData = Chat,
            chatNumber = ChatNumber,
        })
    end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
end)



RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y
    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Whatsapp",
            text = "Vị trí được đặt!",
            icon = "fab fa-whatsapp",
            color = "#25D366",
            timeout = 1500,
        },
    })
end)

RegisterNetEvent('pepe-phone:client:UpdateMessages')
AddEventHandler('pepe-phone:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local Sender = IsNumberInContacts(SenderNumber)

    local NumberKey = GetKeyByNumber(SenderNumber)

    if New then
        PhoneData.Chats[NumberKey] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            Unread = nil,
            messages = ChatMessages
        }

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                print('Tin nhắn mới')
            else
                print('Tin nhắn mới')
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            Framework.Functions.TriggerCallback('pepe-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Whatsapp",
                    text = "Tin nhắn mới từ "..IsNumberInContacts(SenderNumber).."!",
                    icon = "fab fa-whatsapp",
                    color = "#25D366",
                    timeout = 1500,
                },
            })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                print('Tin nhắn mới')
            else
                print('Tin nhắn mới')
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)
            
            Wait(100)
            Framework.Functions.TriggerCallback('pepe-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Whatsapp",
                    text = "Bạn có một tin nhắn WhatsApp mới",
                    -- text = "Nieuw bericht van "..IsNumberInContacts(SenderNumber).."!",
                    icon = "fab fa-whatsapp",
                    color = "#25D366",
                    timeout = 1500,
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "whatsapp")
        end
    end
end)

RegisterNetEvent("pepe-phone-new:client:BankNotify")
AddEventHandler("pepe-phone-new:client:BankNotify", function(text)
    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = "Ngân hàng", 
            content = text, 
            icon = "fas fa-university", 
            timeout = 3500, 
            color = "#ff002f",
        },
    })
end)

RegisterNetEvent('pepe-phone:client:NewMailNotify')
AddEventHandler('pepe-phone:client:NewMailNotify', function(MailData)
    if PhoneData.isOpen then
        print('Thư điện tử mới')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Mail",
                text = "Bạn đã nhận được một thư mới",
                icon = "fas fa-envelope",
                color = "#ff002f",
                timeout = 1500,
            },
        })
    end
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "mail")
end)

RegisterNUICallback('PostAdvert', function(data)
    TriggerServerEvent('pepe-phone:server:AddAdvert', data.message)
end)

RegisterNUICallback('SellVehicle', function(data)
    TriggerServerEvent('pepe-phone:server:sellVehicle', data.plate, data.price)
end)

RegisterNUICallback('BuyVehicle', function(data)
    TriggerServerEvent('pepe-phone:server:buy:chosen:vehicle', data.plate, data.citizenid, data.price)
end)

RegisterNetEvent('pepe-phone:client:send:email:bought:vehicle')
AddEventHandler('pepe-phone:client:send:email:bought:vehicle', function(Plate)
    local Player = Framework.Functions.GetPlayerData()
    SetTimeout(math.random(4500, 8000), function()
        TriggerServerEvent('pepe-phone:server:sendNewMail', {
            sender = "Autoscout24",
            subject = "Xe mới đã mua!",
            message = "Về việc " .. Player.charinfo.firstname .. " " .. Player.charinfo.lastname .. ",<br /><br />Bạn đã mua một chiếc xe mới <br><br>biển số xe: <b>" .. Plate .. "</b> <br><br>Chúng tôi chúc bạn nhiều cây số an toàn!<br /><br />Trân trọng,<br />Autoscout24",
            button = {}
        })
    end)
end)

RegisterNetEvent('pepe-phone:client:send:email:sold:vehicle')
AddEventHandler('pepe-phone:client:send:email:sold:vehicle', function(SellPrice, VehiclePlate)
    SetTimeout(math.random(4500, 8000), function()
        TriggerServerEvent('pepe-phone:server:sendNewMail', {
            sender = "Autoscout24",
            subject = "Quảng cáo của bạn",
            message = "Chào bạn,<br/><br/>Bạn sẽ nhận được một e-mail của quảng cáo gần đây của bạn.<br><br>Biển số xe: <strong>" ..VehiclePlate.. "</strong> <br>Giá bán: <strong>$"..SellPrice.. '</strong><br><br>Xe của bạn đã được bán thành công và số tiền được viết trên ngân hàng của bạn.<br><br>Sincerely,<br>Autoscout24',
            button = {}
        })
    end)
end)

RegisterNetEvent('pepe-phone:client:UpdateAdverts')
AddEventHandler('pepe-phone:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts

    if PhoneData.isOpen then
        print('Quảng cáo mới')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Quảng cáo",
                text = "Quảng cáo mới được đăng",
                icon = "fas fa-ad",
                color = "#ff8f1a",
                timeout = 2500,
            },
        })
    end

    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAutoscout', function()
    Framework.Functions.TriggerCallback('pepe-phone:server:load:autoscout', function(Data)
        SendNUIMessage({
            action = "RefreshAutoscout",
            Cars = Data
        })
    end)
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    local ChatKey = GetKeyByNumber(chat)

    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "whatsapp", newAlerts)

        PhoneData.Chats[ChatKey].Unread = 0

        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end
end)

RegisterNUICallback('CreateInvoice', function(data, cb)
    local id = tonumber(data.id)
    local amount = tonumber(data.amount)
    local description = data.description
    local injectCharacterFilter = description
    injectCharacterFilter=injectCharacterFilter:gsub("%a", "")
    injectCharacterFilter=(injectCharacterFilter:gsub("%s", ""))
    injectCharacterFilter=(injectCharacterFilter:gsub("%d", ""))
	injectCharacterFilter=(injectCharacterFilter:gsub("%-", ""))

    if injectCharacterFilter ~= "" then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Cảnh báo",
                text = "Không thể tạo hoá đơn, nội dung không hợp lệ!",
                icon = "fa fa-cog",
                color = "red",
                timeout = 4000,
            },
        })
        cb(false)
        return false
	end

    Framework.Functions.TriggerCallback('pepe-phone:server:CreateInvoice', function(Success)
        cb(Success)
    end, id, amount, description)
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId
    local SenderCitizenId = data.SenderCitizenId
    local injectCharacterFilter = invoiceId
    injectCharacterFilter=injectCharacterFilter:gsub("%a", "")
    injectCharacterFilter=(injectCharacterFilter:gsub("%s", ""))
    injectCharacterFilter=(injectCharacterFilter:gsub("%d", ""))
	injectCharacterFilter=(injectCharacterFilter:gsub("%-", ""))

    if injectCharacterFilter ~= "" then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Cảnh báo",
                text = "Không thể thanh toán hoá đơn, vui lòng liên hệ Admin!",
                icon = "fa fa-cog",
                color = "red",
                timeout = 4000,
            },
        })
        cb(false)
        return false
	end

    Framework.Functions.TriggerCallback('pepe-phone:server:PayInvoice', function(CanPay, Invoices)
        if CanPay then PhoneData.Invoices = Invoices end
        cb(CanPay)
    end, sender, amount, invoiceId, SenderCitizenId)
end)

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId
    local SenderCitizenId = data.SenderCitizenId
    local injectCharacterFilter = invoiceId
    injectCharacterFilter=injectCharacterFilter:gsub("%a", "")
    injectCharacterFilter=(injectCharacterFilter:gsub("%s", ""))
    injectCharacterFilter=(injectCharacterFilter:gsub("%d", ""))
	injectCharacterFilter=(injectCharacterFilter:gsub("%-", ""))

    if injectCharacterFilter ~= "" then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Cảnh báo",
                text = "Không thể thanh toán hoá đơn, vui lòng liên hệ Admin!",
                icon = "fa fa-cog",
                color = "red",
                timeout = 4000,
            },
        })
        cb(false)
        return false
	end

    Framework.Functions.TriggerCallback('pepe-phone:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId, SenderCitizenId)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('pepe-phone:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

local function escape_str(s)
	return s
end

function GenerateTweetId()
    local tweetId = "TWEET-"..math.random(11111111, 99999999)
    return tweetId
end

RegisterNetEvent('pepe-phone:client:UpdateHashtags')
AddEventHandler('pepe-phone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture

    PhoneData.MetaData.profilepicture = pf
    
    TriggerServerEvent('pepe-phone:server:SaveMetaData', PhoneData.MetaData)
end)

local patt = "[?!@#]"

RegisterNUICallback('PostNewTweet', function(data, cb)
    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        message = escape_str(data.Message),
        time = data.Date,
        tweetId = GenerateTweetId(),
        picture = data.Picture,
        imageurl = data.ImageUrl,
        anonymous = data.Anonymous,
    }

    local TwitterMessage = data.Message
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")

    for i = 2, #Hashtag, 1 do
        local Handle = Hashtag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local InvalidSymbol = string.match(Handle, patt)
            if InvalidSymbol then
                Handle = Handle:gsub("%"..InvalidSymbol, "")
            end
            TriggerServerEvent('pepe-phone:server:UpdateHashtags', Handle, TweetMessage)
        end
    end

    for i = 2, #MentionTag, 1 do
        local Handle = MentionTag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local Fullname = Handle:split("_")
            local Firstname = Fullname[1]
            table.remove(Fullname, 1)
            local Lastname = table.concat(Fullname, " ")

            if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                    TriggerServerEvent('pepe-phone:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                else
                    SetTimeout(2500, function()
                        print('Bạn không thể đề cập đến chính mình')
                    end)
                end
            end
        end
    end    
   table.insert(PhoneData.Tweets, TweetMessage)
   Citizen.Wait(100)
   cb(PhoneData.Tweets)
   TriggerServerEvent('pepe-phone:server:UpdateTweets', PhoneData.Tweets, TweetMessage)      
end)

RegisterNetEvent('pepe-phone:client:post:tweet:event')
AddEventHandler('pepe-phone:client:post:tweet:event', function(Message, Time, Type)
    local TweetMessage = {
        firstName = 'None',
        lastName = 'None',
        message = escape_str(Message),
        time = Time,
        tweetId = GenerateTweetId(),
        picture = nil,
        imageurl = nil,
        anonymous = true,
    }
    table.insert(PhoneData.Tweets, TweetMessage)
    Citizen.Wait(100)
    TriggerServerEvent('pepe-phone:server:UpdateTweets', PhoneData.Tweets, TweetMessage, Type) 
end)

RegisterNetEvent('pepe-phone:client:NotEnoughBits')
AddEventHandler('pepe-phone:client:NotEnoughBits', function(amount, newmoney)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Twitter", 
            text = "Bạn không có đủ bit để tweet nặc danh", 
            icon = "fab fa-twitter",
            color = "#1DA1F2",
        },
    })
end)

RegisterNetEvent('pepe-phone:client:TransferMoney')
AddEventHandler('pepe-phone:client:TransferMoney', function(amount, newmoney)
    PhoneData.PlayerData.money.bank = newmoney
    if PhoneData.isOpen then
        print('Tiền ít')
        SendNUIMessage({ action = "UpdateBank", NewBalance = PhoneData.PlayerData.money.bank })
    else
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Ngân hàng", text = "Có $"..amount.." Nhận được!", icon = "fas fa-university", color = "#8c7ae6", }, })
    end
end)

RegisterNetEvent('pepe-phone:client:UpdateTweets')
AddEventHandler('pepe-phone:client:UpdateTweets', function(src, Tweets, NewTweetData, Type)
    PhoneData.Tweets = Tweets
    if PhoneData ~= nil and PhoneData.PlayerData ~= nil then
      local MyPlayerId = PhoneData.PlayerData.source
       if src ~= MyPlayerId then
          local titel = "Tweet mới (@"..NewTweetData.firstName..")"
              if not PhoneData.isOpen then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = titel, 
                        text = NewTweetData.message, 
                        icon = "fab fa-twitter",
                        color = "#1DA1F2",
                    },
                })
              end
        else
            print('Tweet đặt')
        end
  end
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNetEvent('pepe-phone:client:GetMentioned')
AddEventHandler('pepe-phone:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    if not PhoneData.isOpen then
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Bạn được đề cập trong một tweet!", text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    else
        print('pingfuck')
    end
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = escape_str(TweetMessage.message), time = TweetMessage.time, picture = TweetMessage.picture, anonymous = TweetMessage.anonymous, imageurl =  TweetMessage.imageurl}
    table.insert(PhoneData.MentionedTweets, TweetMessage)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = "RefreshAppAlerts",
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end)
end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

RegisterNUICallback('TransferMoney', function(data, cb)
    data.amount = tonumber(data.amount)
    if tonumber(PhoneData.PlayerData.money.bank) >= data.amount then
        local amaountata = PhoneData.PlayerData.money.bank - data.amount
        TriggerServerEvent('pepe-phone:server:TransferMoney', data.iban, data.amount)
        local cbdata = {
            CanTransfer = true,
            NewAmount = amaountata 
        }
        cb(cbdata)
    else
        local cbdata = {
            CanTransfer = false,
            NewAmount = nil,
        }
        cb(cbdata)
    end
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:GetContactPictures', function(Chats)
        cb(Chats)
    end, PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:GetCallState', function(CanCall, IsOnline)
        local status = { 
            CanCall = CanCall, 
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous)
        end
    end, data.ContactData)
end)

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

CallContact = function(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)

    TriggerServerEvent('pepe-phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('pepe-phone:server:SetCallState', true)
    
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerEvent("pepe-sound:client:play", "death", 0.1) 
                else
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end

CancelCall = function()
    TriggerServerEvent('pepe-phone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        -- exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
        
		exports["mumble-voip"]:removePlayerFromCall(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('pepe-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Điện thoại", 
                text = "Cuộc gọi đã bị chấm dứt", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })         
    else
        print('sadfuck')

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('pepe-phone:client:CancelCall')
AddEventHandler('pepe-phone:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        --exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
		exports["mumble-voip"]:SetCallChannel(0)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('pepe-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Điện thoại", 
                text = "Cuộc gọi đã bị chấm dứt", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })          
    else
        print('sadfuck')

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('pepe-phone:client:GetCalled')
AddEventHandler('pepe-phone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall
    }

    if AnonymousCall then
        CallData.name = "Anoniem"
    end

    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('pepe-phone:server:SetCallState', true)

    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerEvent("pepe-sound:client:play", "phone-ringing", 0.2)
                    
                    if not PhoneData.isOpen then
                        SendNUIMessage({
                            action = "IncomingCallAlert",
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = false,
                            AnonymousCall = AnonymousCall,
                        })
                    end
                else
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    TriggerServerEvent('pepe-phone:server:AddRecentCall', "missed", CallData)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                SendNUIMessage({
                    action = "IncomingCallAlert",
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                    AnonymousCall = AnonymousCall,
                })
                TriggerServerEvent('pepe-phone:server:AddRecentCall', "missed", CallData)
                break
            end
        else
            TriggerServerEvent('pepe-phone:server:AddRecentCall', "missed", CallData)
            break
        end
    end
end)


RegisterNetEvent('pepe-phone:client:CallContact')
AddEventHandler('pepe-phone:client:CallContact', function(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)

    TriggerServerEvent('pepe-phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('pepe-phone:server:SetCallState', true)
    
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerEvent("pepe-sound:client:play", "death", 0.1) 
                else
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end)
RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('pepe-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        TriggerServerEvent('pepe-phone:server:AnswerCall', PhoneData.CallData)

        -- exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Telefoon')
        exports["mumble-voip"]:SetCallChannel(PhoneData.CallData.CallId, 'Phone')
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Điện thoại", 
                text = "Bạn không có cuộc gọi đến...", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end

RegisterNetEvent('pepe-phone:client:AnswerCall')
AddEventHandler('pepe-phone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('pepe-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        -- exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Telefoon')
        exports["mumble-voip"]:SetCallChannel(PhoneData.CallData.CallId, 'Phone')
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Điện thoại", 
                text = "Bạn không có cuộc gọi đến ...", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end)

-- AddEventHandler('onResourceStop', function(resource)
--     if resource == GetCurrentResourceName() then
--         -- SetNuiFocus(false, false)
--     end
-- end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:FetchResult', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('GetPizzaItems', function(data, cb)
    local searchData = {}
    local ConfigItems = exports['kingwolf-pizza']:GetItems()
    for i = 1, #ConfigItems.items do
        local item = ConfigItems.items[i]
        item.amount = 50
        local itemInfo = Framework.Shared.Items[item.name:lower()]
        table.insert(searchData, {
            label = itemInfo["name"],
            name = item.name,
            amount = item.amount,
            price = item.price
        })
    end

    
    cb(searchData)
end)

RegisterNUICallback('OpenBikeFood', function(data, cb)
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetTimeout(150, function()
        PhoneData.isOpen = false
    end)
    TriggerEvent('kingwolf-shopping:client:openMenu')
    cb({})
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:GetVehicleSearchResults', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = Framework.Functions.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)
	local modelname = GetDisplayNameFromVehicleModel(model)

    Framework.Functions.TriggerCallback('kingwolf-common:server:getPlateOwner', function(plateInfo)
        print(json.encode(plateInfo))
        if plateInfo ~= nil then
            print(json.encode(plateInfo))
            plateInfo.label = modelname
            cb(plateInfo)
        else
            Framework.Functions.TriggerCallback('pepe-phone:server:ScanPlate', function(result)
                result.label = modelname
                cb(result)
            end, plate)
        end
    end, plate)    
end)

RegisterNetEvent('pepe-phone:client:addPoliceAlert')
AddEventHandler('pepe-phone:client:addPoliceAlert', function(alertData)
    if PlayerJob.name == 'police' and PlayerJob.onduty then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords

    Framework.Functions.Notify('vị trí GPS bộ: '..data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data

    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)

function GetClosestPlayer()
    local closestPlayers = Framework.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end
	return closestPlayer, closestDistance
end

RegisterNetEvent('pepe-phone:client:GiveContactDetails')
AddEventHandler('pepe-phone:client:GiveContactDetails', function()
    local ped = GetPlayerPed(-1)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local PlayerId = GetPlayerServerId(player)
        TriggerServerEvent('pepe-phone:server:GiveContactDetails', PlayerId)
    else
        Framework.Functions.Notify("Không ai gần đó!", "error")
    end
end)

-- Citizen.CreateThread(function()
--     Wait(1000)
--     TriggerServerEvent('pepe-phone:server:GiveContactDetails', 1)
-- end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            if PhoneData.isOpen then
                print('contant verwijderd')
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Điện thoại",
                        text = "Bạn đã gỡ bỏ " ..data.CurrentContactName.. "", 
                        icon = "fa fa-phone-alt",
                        color = "#04b543",
                        timeout = 1500,
                    },
                })
            end
            break
        end
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('pepe-phone:server:RemoveContact', Name, Number)
end)

RegisterNetEvent('pepe-phone:client:AddNewSuggestion')
AddEventHandler('pepe-phone:client:AddNewSuggestion', function(SuggestionData)
    table.insert(PhoneData.SuggestedContacts, SuggestionData)

    if PhoneData.isOpen then
        print('nieuw contact')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Điện thoại",
                text = "Bạn có gợi ý liên hệ mới!", 
                icon = "fa fa-phone-alt",
                color = "#04b543",
                timeout = 1500,
            },
        })
    end

    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    TriggerServerEvent('pepe-phone:server:SetPhoneAlerts', "phone", Config.PhoneApplications["phone"].Alerts)
end)

-- RegisterNUICallback('GetCryptoData', function(data, cb)
--     Framework.Functions.TriggerCallback('qb-crypto:server:GetCryptoData', function(CryptoData)
--         cb(CryptoData)
--     end, data.crypto)
-- end)

-- RegisterNUICallback('BuyCrypto', function(data, cb)
--     Framework.Functions.TriggerCallback('qb-crypto:server:BuyCrypto', function(CryptoData)
--         cb(CryptoData)
--     end, data)
-- end)

-- RegisterNUICallback('SellCrypto', function(data, cb)
--     Framework.Functions.TriggerCallback('qb-crypto:server:SellCrypto', function(CryptoData)
--         cb(CryptoData)
--     end, data)
-- end)

-- RegisterNUICallback('TransferCrypto', function(data, cb)
--     Framework.Functions.TriggerCallback('qb-crypto:server:TransferCrypto', function(CryptoData)
--         cb(CryptoData)
--     end, data)
-- end)

RegisterNetEvent('pepe-phone:client:RemoveBankMoney')
AddEventHandler('pepe-phone:client:RemoveBankMoney', function(amount)
    if PhoneData.isOpen then
        print('geld afgeschreven')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Ngân hàng",
                text = "Có $"..amount..",- loại bỏ khỏi ngân hàng của bạn!", 
                icon = "fas fa-university", 
                color = "#ff002f",
                timeout = 3500,
            },
        })
    end
end)

RegisterNetEvent('pepe-phone:client:induty')
AddEventHandler('pepe-phone:client:induty', function(alert)

    if PhoneData.isOpen then
        --print('Nieuwe melding')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Thời gian làm việc",
                text = "Bạn đang làm việc", 
                icon = "fas fa-clock",
                color = "#ffffff",
                timeout = 1500,
            },
        })
    end

    --print('test')
end)

RegisterNetEvent('pepe-phone:client:offduty')
AddEventHandler('pepe-phone:client:offduty', function(alert)

    if PhoneData.isOpen then
        --print('Nieuwe melding')
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Thời gian làm việc",
                text = "Bạn đang hết ca làm", 
                icon = "fas fa-clock",
                color = "#ffffff",
                timeout = 1500,
            },
        })
    end

    --print('test')
end)
RegisterNetEvent('pepe-phone:client:AddTransaction')
AddEventHandler('pepe-phone:client:AddTransaction', function(SenderData, TransactionData, Message, Title)
    local Data = {
        TransactionTitle = Title,
        TransactionMessage = Message,
    }
    
    table.insert(PhoneData.CryptoTransactions, Data)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Crypto",
                text = Message, 
                icon = "fas fa-chart-pie",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Crypto",
                content = Message, 
                icon = "fas fa-chart-pie",
                timeout = 3500, 
                color = "#04b543",
            },
        })
    end

    SendNUIMessage({
        action = "UpdateTransactions",
        CryptoTransactions = PhoneData.CryptoTransactions
    })

    TriggerServerEvent('pepe-phone:server:AddTransaction', Data)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('GetPlayerKeys', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:GetHouseKeys', function(Keys)
        cb(Keys)
    end)
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('pepe-housing:server:remove:house:key', data.HouseData.name, data.HolderData.citizenid)
end)

RegisterNUICallback('SetHouseLocation', function(data, cb)
    SetNewWaypoint(data.HouseData.HouseData['Coords']['Enter']['X'], data.HouseData.HouseData['Coords']['Enter']['Y'])
    Framework.Functions.Notify("Your GPS is set to " .. data.HouseData.HouseData['Adres'] .. "!", "info")
end)

RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('TransferCid', function(data, cb)
    local TransferedCid = data.newBsn
    Framework.Functions.TriggerCallback('pepe-phone:server:TransferCid', function(CanTransfer)
        cb(CanTransfer)
    end, TransferedCid, data.HouseData)
end)

RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = GetPlayerPed(-1)
    SetNewWaypoint(data.coords.x, data.coords.y)
    Framework.Functions.Notify('GPS is set!', 'success')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]
    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    Framework.Functions.Notify('GPS được đặt.!', 'success')
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    Framework.Functions.TriggerCallback('pepe-phone:server:GetCurrentLawyers', function(lawyers)
        cb(lawyers)
    end)
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

RegisterNUICallback('takePhoto', function(data, cb)
    ClosePhone()
	CreateMobilePhone(1)
    CellCamActivate(true, true)
    takePhoto = true
    Citizen.Wait(0)
    if hasFocus == true then
        SetNuiFocus(false, false)
        hasFocus = false
    end
        while takePhoto do
        Citizen.Wait(0)

        if IsControlJustPressed(1, 27) then -- Toogle Mode
            frontCam = not frontCam
            CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then -- CANCEL
            DestroyMobilePhone()
            CellCamActivate(false, false)
            cb("")
            takePhoto = false
            OpenPhoneWithNoTimeOut()
        break
        elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC 
            exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/902420053788606545/VmKmBcQXHKli8owTNlKlBbx6YGvgzShl5ry1YjKr3c-B4bSps9hkTXnQEjJk_yZYtXt5", "files[]", function(data)
                -- cb(data)
                local resp = json.decode(data)
                DestroyMobilePhone()
                CellCamActivate(false, false)
                cb(resp.attachments[1].url)
                OpenPhoneWithNoTimeOut()
            end)
            
            takePhoto = false
        end
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
    end
    Citizen.Wait(1000)
    -- PhonePlayAnim('text', false, true)
end)

RegisterNUICallback('OpenInvoiceMenu', function(data, cb)
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetTimeout(150, function()
        PhoneData.isOpen = false
    end)

    TriggerEvent("okokBilling:client:openMenu")
end)