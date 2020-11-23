Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = GetPlayerPed(PlayerId())
        local vehLast = GetVehiclePedIsIn(ped, true)
        local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(oed), GetEntityCoords(vehLast), 1)
        local vehLockStat = GetVehicleDoorLockStatus(vehLast)

        if GetVehicleClass(vehLast) == 18 and GetLastPedInVehicleSeat(vehlast, -1) == ped and GetVehicleDoorAngleRatio(vehLast, 0) <= = and GetVehicleDoorAngleRatio(vehLast, 1) <= 0 then
            if distanceToVeh <= 5 then
                if vehLockStat == 2 then
                    SetVehicleDoorsLocked(vehLast, 0)
                    SetVehicleDoorsLockedForAllPlayers(vehlast, false)
                    ShowInfo("jou auto is open")
                end
            else
                if vehLockStat == 1 or vehLockStat == 0 then
                    SetVehicleDoorsLocked(vehLast, 2)
                    SetVehicleDoorsLockedForAllPlayers(vehKast, true)
                    ShowInfo("Je auto is open")
                    end
                end
            end
        end
    end)

    function ShowInfo(text)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(false, false)
    end