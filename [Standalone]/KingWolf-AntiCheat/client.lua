Citizen.CreateThread(
    function()
        Esloadedr = {}
        for fd = 1, GetNumResources() do
            if GetResourceByFindIndex(fd) ~= nil then
                Esloadedr[GetResourceByFindIndex(fd)] = true
            end
        end
        TriggerServerEvent("KingWolf:AntiResourceStops")
        AddEventHandler(
            "KingWolf:client:DetectGodModes",
            function()
                if KingWolfCfg.AntiGodMode then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Citizen.Wait(KingWolfCfg.AntiGodModeTimer)
                                Citizen.Wait((math.random(10, 150)))
                                if GetEntityHealth((PlayerPedId())) > KingWolfCfg.MaxPlayerHealth then
                                    if KingWolfCfg.AntiGodModeBan then
                                        TriggerServerEvent(
                                            "KingWolf:BanPlayers:jjhjxjzj",
                                            "This player tried to set is health above the max health, Player Health: " ..
                                                GetEntityHealth((PlayerPedId()))
                                        )
                                    else
                                        TriggerServerEvent(
                                            "KingWolf:DetectGodMode",
                                            "This player tried to set is health above the max health, Player Health: " ..
                                                GetEntityHealth((PlayerPedId()))
                                        )
                                    end
                                end
                                if GetPlayerInvincible(PlayerId()) then
                                    if KingWolfCfg.AntiGodModeBan then
                                        TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj", "This player tried to enable godmode")
                                    else
                                        TriggerServerEvent("KingWolf:DetectGodMode", "Godmode detected")
                                    end
                                    SetPlayerInvincible(PlayerId(), false)
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.AntiModelChanger then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Citizen.Wait(3000)
                                for fe, fg in ipairs(KingWolfCfg.AntiModelChangerTable) do
                                    if IsPedModel(PlayerPedId(), fg) then
                                        TriggerServerEvent(
                                            "KingWolf:BanPlayers:jjhjxjzj",
                                            "AntiModelChanger: Detected model: " ..
                                                fg ..
                                                    " | This player tried to change model to a blacklisted player model"
                                        )
                                    end
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.ArmourCheck then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Citizen.Wait(5000)
                                if GetPedArmour(PlayerPedId()) > KingWolfCfg.MaxPlayerArmour then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "Armor hacking detected, Player Armor:" .. GetPedArmour(PlayerPedId())
                                    )
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.AntiSpectate then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Wait(3000)
                                if NetworkIsInSpectatorMode() == 1 then
                                    TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj", "This player tried to spectate another player")
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.Basic then
                end
                if KingWolfCfg.AntiFCommands then
                    Citizen.CreateThread(
                        function()
                            cmdo = #GetRegisteredCommands()
                            while true do
                                Citizen.Wait(3000)
                                cmdt = #GetRegisteredCommands()
                                if cmdo ~= nil and cmdt ~= nil and cmdt ~= cmdo then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "AntiFCommands: detected | This player had some weird commands loaded"
                                    )
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.AntiVehicleHashChanger then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Citizen.Wait(3000)
                                if
                                    IsPedSittingInAnyVehicle(PlayerPedId()) and
                                        GetVehiclePedIsUsing(PlayerPedId()) == oldVehicle and
                                        GetEntityModel((GetVehiclePedIsUsing(PlayerPedId()))) ~= oldVehicleModel and
                                        oldVehicleModel ~= nil and
                                        oldVehicleModel ~= 0
                                 then
                                    DeleteVehicle((GetVehiclePedIsUsing(PlayerPedId())))
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "Cheat Engine Vehicle Hash Changer | This player tried to change his vehicle hash"
                                    )
                                    return
                                end
                                oldVehicleModel, oldVehicle =
                                    GetEntityModel((GetVehiclePedIsUsing(PlayerPedId()))),
                                    GetVehiclePedIsUsing(PlayerPedId())
                            end
                        end
                    )
                end
                if KingWolfCfg.AntiDamageModifier then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Citizen.Wait(3000)
                                if
                                    1 < GetPlayerWeaponDamageModifier(PlayerId()) and
                                        GetPlayerWeaponDamageModifier(PlayerId()) ~= 0
                                 then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "AntiDamageModifier: Detected: " ..
                                            tostring((GetPlayerWeaponDamageModifier(PlayerId()))) ..
                                                " | This player tried to change his Weapon Damage"
                                    )
                                elseif
                                    1 < GetPlayerWeaponDefenseModifier(PlayerId()) and
                                        GetPlayerWeaponDefenseModifier(PlayerId()) ~= 0
                                 then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "AntiDamageModifier: Detected: " ..
                                            tostring((GetPlayerWeaponDefenseModifier(PlayerId()))) ..
                                                " | This player tried to change his Weapon Defence"
                                    )
                                elseif
                                    1 < GetPlayerWeaponDefenseModifier_2(PlayerId()) and
                                        GetPlayerWeaponDefenseModifier(PlayerId()) ~= 0
                                 then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "AntiDamageModifier: Detected: " ..
                                            tostring((GetPlayerWeaponDefenseModifier_2(PlayerId()))) ..
                                                " | This player tried to change his Weapon Defence 2"
                                    )
                                elseif
                                    1 < GetPlayerVehicleDamageModifier(PlayerId()) and
                                        GetPlayerVehicleDamageModifier(PlayerId()) ~= 0
                                 then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "AntiDamageModifier: Detected: " ..
                                            tostring((GetPlayerVehicleDamageModifier(PlayerId()))) ..
                                                " | This player tried to change his Vehicle Damage"
                                    )
                                elseif
                                    1 < GetPlayerVehicleDefenseModifier(PlayerId()) and
                                        GetPlayerVehicleDefenseModifier(PlayerId()) ~= 0
                                 then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "AntiDamageModifier: Detected: " ..
                                            tostring((GetPlayerVehicleDefenseModifier(PlayerId()))) ..
                                                " | This player tried to change his Vehicle Defence"
                                    )
                                elseif
                                    1 < GetPlayerMeleeWeaponDefenseModifier(PlayerId()) and
                                        GetPlayerVehicleDefenseModifier(PlayerId()) ~= 0
                                 then
                                    TriggerServerEvent(
                                        "KingWolf:BanPlayers:jjhjxjzj",
                                        "AntiDamageModifier: Detected: " ..
                                            tostring((GetPlayerMeleeWeaponDefenseModifier(PlayerId()))) ..
                                                " | This player tried to change his Melee Defence"
                                    )
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.AntiWeaponManipulator then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Citizen.Wait(3000)
                                if GetSelectedPedWeapon((PlayerPedId())) ~= nil then
                                    WeaponDamages = KingWolfCfg.WeaponDamagesTable
                                    if
                                        KingWolfCfg.AntiWeaponDamageModifier and
                                            WeaponDamages[GetSelectedPedWeapon((PlayerPedId()))] and
                                            math.floor(GetWeaponDamage((GetSelectedPedWeapon((PlayerPedId()))))) >
                                                WeaponDamages[GetSelectedPedWeapon((PlayerPedId()))]
                                     then
                                        TriggerServerEvent(
                                            "KingWolf:BanPlayers:jjhjxjzj",
                                            "Weapon Damage Modified, Weapon Hash: " ..
                                                GetSelectedPedWeapon((PlayerPedId())) ..
                                                    " | This player tried to edit his weapon damage"
                                        )
                                    end
                                    if KingWolfCfg.AntiExplosiveWeapons then
                                        if
                                            GetWeapontypeGroup((GetSelectedPedWeapon((PlayerPedId())))) ~= -1609580060 and
                                                GetWeapontypeGroup((GetSelectedPedWeapon((PlayerPedId())))) ~=
                                                    -728555052
                                         then
                                        end
                                        if GetSelectedPedWeapon((PlayerPedId())) == -1569615261 then
                                            if GetWeaponDamageType((GetSelectedPedWeapon((PlayerPedId())))) ~= 2 then
                                                TriggerServerEvent(
                                                    "KingWolf:BanPlayers:jjhjxjzj",
                                                    "Explosive Melee, Weapon Hash: " ..
                                                        GetSelectedPedWeapon((PlayerPedId())) ..
                                                            " | This player tried to use a explosive melee"
                                                )
                                            end
                                        else
                                            if
                                                GetWeapontypeGroup((GetSelectedPedWeapon((PlayerPedId())))) ~= 416676503 and
                                                    GetWeapontypeGroup((GetSelectedPedWeapon((PlayerPedId())))) ~=
                                                        -957766203 and
                                                    GetWeapontypeGroup((GetSelectedPedWeapon((PlayerPedId())))) ~=
                                                        860033945 and
                                                    GetWeapontypeGroup((GetSelectedPedWeapon((PlayerPedId())))) ~=
                                                        970310034
                                             then
                                            end
                                            if
                                                GetWeapontypeGroup((GetSelectedPedWeapon((PlayerPedId())))) ==
                                                    -1212426201 and
                                                    GetWeaponDamageType((GetSelectedPedWeapon((PlayerPedId())))) ~= 3
                                             then
                                                TriggerServerEvent(
                                                    "KingWolf:BanPlayers:jjhjxjzj",
                                                    "Explosive Weapon, Weapon Hash: " ..
                                                        GetSelectedPedWeapon((PlayerPedId())) ..
                                                            " | This player tried to use a explosive weapon"
                                                )
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.BlacklistWeapon then
                    Citizen.CreateThread(
                        function()
                            while true do
                                Citizen.Wait(2000)
                                for fd, fe in ipairs(KingWolfCfg.BlacklistWeaponTable) do
                                    Citizen.Wait(1)
                                    if HasPedGotWeapon(PlayerPedId(), GetHashKey(fe), false) == 1 then
                                        if KingWolfCfg.DeleteAllWeapon then
                                            RemoveAllPedWeapons(PlayerPedId(), false)
                                            TriggerServerEvent("KingWolf:ServerLogs", fe)
                                        else
                                            RemoveWeaponFromPed(PlayerPedId(), GetHashKey(fe))
                                            TriggerServerEvent("KingWolf:ServerLogs", fe)
                                        end
                                        if KingWolfCfg.WeaponBanPlayer then
                                            TriggerServerEvent(
                                                "KingWolf:BanPlayers:jjhjxjzj",
                                                "BlacklistWeapon: The player has a blacklist gun: " .. fe
                                            )
                                        end
                                    end
                                end
                            end
                        end
                    )
                end
                if KingWolfCfg.AntiNoclip then
                    Citizen.CreateThread(
                        function()
                            Citizen.Wait(10000)
                            while true do
                                Citizen.Wait(0)
                                Wait(3000)
                                if
                                    GetDistanceBetweenCoords(table.unpack(GetEntityCoords(PlayerPedId(), true))) > 200 and
                                        IsPedStill((PlayerPedId())) == IsPedStill((PlayerPedId())) and
                                        GetEntitySpeed((PlayerPedId())) == GetEntitySpeed((PlayerPedId())) and
                                        PlayerPedId() == PlayerPedId()
                                 then
                                    TriggerServerEvent("KingWolf:BanPlayers:jjhjxjzj", "AntiNoclip: This player tried to use noclip")
                                end
                            end
                        end
                    )
                end
            end
        )
    end
)
function EnumerateEntities(a, b, c)
    a = a
    return coroutine.wrap(
        function()
            if va() then
            end
            if va() == 0 then
                vb(va())
                return
            end
            setmetatable(
                {
                    handle = va()
                },
                vc
            )
            repeat
                coroutine.yield(va())
            until not vd(va())
            vb(va())
        end
    )
end
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
RegisterNetEvent("KingWolf:ClearAllPeds")
AddEventHandler(
    "KingWolf:ClearAllPeds",
    function()
        PedStatus = 0
        for fd in EnumeratePeds() do
            PedStatus = PedStatus + 1
            if not IsPedAPlayer(fd) then
                RemoveAllPedWeapons(fd, true)
                DeleteEntity(fd)
            end
        end
    end
)
RegisterNetEvent("KingWolf:ClearAllVehs")
AddEventHandler(
    "KingWolf:ClearAllVehs",
    function()
        for fd in EnumerateVehicles() do
            if not IsPedAPlayer(GetPedInVehicleSeat(fd, math.floor(-1))) then
                SetVehicleHasBeenOwnedByPlayer(fd, false)
                SetEntityAsMissionEntity(fd, false, false)
                DeleteEntity(fd)
                if DoesEntityExist(fd) then
                    DeleteEntity(fd)
                end
            end
        end
    end
)
RegisterNetEvent("KingWolf:ClearAllObjs")
AddEventHandler(
    "KingWolf:ClearAllObjs",
    function()
        objst = 0
        for fd in EnumerateObjects() do
            objst = objst + 1
            DeleteEntity(fd)
        end
    end
)
