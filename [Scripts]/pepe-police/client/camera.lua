local cameraActive = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local createdCamera = 0


Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(PlayerId())
        local pedPos = GetEntityCoords(ped, false)
        local pedHead = GetEntityRotation(ped, 2)
        if IsControlJustReleased(0, Keys["H"]) then
            print("Vòng xoay: " ..GetEntityRotation(PlayerPedId()))
        end
        if createdCamera ~= 0 then
            local instructions = CreateInstuctionScaleform("instructional_buttons")
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(1.0)

            if Config.SecurityCameras.hideradar then
                DisplayRadar(false)
            end

            -- CLOSE CAMERAS
            if IsControlJustPressed(1, Config.Keys['BACKSPACE']) then
                DoScreenFadeOut(250)
                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end
                CloseSecurityCamera()
                SendNUIMessage({
                    type = "disablecam",
                })
                DoScreenFadeIn(250)
            end

            ---------------------------------------------------------------------------
            -- CAMERA ROTATION CONTROLS
            ---------------------------------------------------------------------------
            if Config.SecurityCameras.cameras[currentCameraIndexIndex].canRotate then
                local getCameraRot = GetCamRot(createdCamera, 2)

                -- ROTATE UP
                if IsControlPressed(0, Config.Keys["W"]) then
                    if getCameraRot.x <= 0.0 then
                        SetCamRot(createdCamera, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                    end
                end

                -- ROTATE DOWN
                if IsControlPressed(0, Config.Keys["S"]) then
                    if getCameraRot.x >= -50.0 then
                        SetCamRot(createdCamera, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                    end
                end

                -- ROTATE LEFT
                if IsControlPressed(0, Config.Keys["A"]) then
                    SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
                end

                -- ROTATE RIGHT
                if IsControlPressed(0, Config.Keys["D"]) then
                    SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
                end
            end
        else
            Citizen.Wait(2000)
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent('pepe-police:client:CameraCommand')
AddEventHandler('pepe-police:client:CameraCommand', function(cameraId)
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)
    local distance = GetDistanceBetweenCoords(plyCoords.x, plyCoords.y,plyCoords.z,438.75601, -992.4405, 30.689327, true)

    --if distance < 4 then
        TriggerEvent('pepe-police:client:ActiveCamera', cameraId)
    --end
end)

RegisterNetEvent('pepe-police:client:ActiveCamera')
AddEventHandler('pepe-police:client:ActiveCamera', function(cameraId)
    if Config.SecurityCameras.cameras[cameraId] ~= nil then
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        SendNUIMessage({
            type = "enablecam",
            label = Config.SecurityCameras.cameras[cameraId].label,
            id = cameraId,
            connected = Config.SecurityCameras.cameras[cameraId].isOnline,
            time = GetCurrentTime(),
        })
        local firstCamx = Config.SecurityCameras.cameras[cameraId].x
        local firstCamy = Config.SecurityCameras.cameras[cameraId].y
        local firstCamz = Config.SecurityCameras.cameras[cameraId].z
        local firstCamr = Config.SecurityCameras.cameras[cameraId].r
        SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
        ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)
        currentCameraIndex = a
        currentCameraIndexIndex = 1
        DoScreenFadeIn(250)
    elseif cameraId == 0 then
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        CloseSecurityCamera()
        SendNUIMessage({
            type = "disablecam",
        })
        DoScreenFadeIn(250)
    else
        Framework.Functions.Notify("Máy ảnh không tồn tại", "error")
    end
end)

RegisterNetEvent('pepe-police:client:DisableAllCameras')
AddEventHandler('pepe-police:client:DisableAllCameras', function()
    for k, v in pairs(Config.SecurityCameras.cameras) do 
        Config.SecurityCameras.cameras[k].isOnline = false
    end
end)

RegisterNetEvent('pepe-police:client:EnableAllCameras')
AddEventHandler('pepe-police:client:EnableAllCameras', function()
    for k, v in pairs(Config.SecurityCameras.cameras) do 
        Config.SecurityCameras.cameras[k].isOnline = true
    end
end)

RegisterNetEvent('pepe-police:client:SetCamera')
AddEventHandler('pepe-police:client:SetCamera', function(key, isOnline)
    Config.SecurityCameras.cameras[key].isOnline = isOnline
end)

---------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------
function GetCurrentTime()
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    if hours < 10 then
        hours = tostring(0 .. GetClockHours())
    end
    if minutes < 10 then
        minutes = tostring(0 .. GetClockMinutes())
    end
    return tostring(hours .. ":" .. minutes)
end

function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Citizen.Wait(250)
    createdCamera = cam
end

function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    if Config.SecurityCameras.hideradar then
        DisplayRadar(true)
    end
    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0*scale, 0.35*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function IsPedAllowed(ped, pedList)
    for i = 1, #pedList do
		if GetHashKey(pedList[i]) == GetEntityModel(ped) then
			return true
		end
	end
    return false
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage("Close Camera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end
