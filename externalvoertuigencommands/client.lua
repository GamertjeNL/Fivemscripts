-----------------------------------------------------
-- External voertuigen commands, gemaakt door William
-----------------------------------------------------

--- Config ---

usingKeyPress = false 
togKey = 38 -- E

--- code ---

function ShowInfo(text)
    BeginTextCommandTheFeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandTheFeedPostTicker(false, false)
end

RegisterCommand("trunk", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 5

    if IsPedInAnyVehicle((ped), false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Voertuig] ~g~Kofferbak is dicht.")
        else
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Voertuig] ~g~Kofferbak is open")
        end
    else
        if distanceToVeh < 6 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Voertuig] ~g~Kofferbak is dicht")
            else 
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Voertuig] ~g~Kofferbak is open.")
            end 
        else
            ShowInfo("[Voertuig] ~y~Je bent te ver van het voertuig.")
        end
    end
end)

RegisterCommand("hood", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 4

    if IsPedInAnyVehicle((ped), false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Voertuig] ~g~moterkap is dicht.")
        else
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Voertuig] ~g~moterkap is open")
        end
    else
        if distanceToVeh < 4 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Voertuig] ~g~moterkap is dicht")
            else 
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Voertuig] ~g~moterkap is open.")
            end 
        else
            ShowInfo("[Voertuig] ~y~Je bent te ver van het voertuig.")
        end
    end
end)

RegisterCommand("deur", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)

    if args[1] == "1" then -- Voordeur links
        door = 0
    elseif args[2] == "2" then -- Voordeur rechts
        door = 1
    elseif args[3] == "3" then -- Achterdeur links
        door = 2
    elseif args[4] == "4" then -- Achterdeur Rechts
        door = 3
    else 
        door = nil
        ShowInfo("Gebruik: ~n~~b~/deur [deur]")
        ShowInfo("~y~mogelijke deuren:")
        ShowInfo("1: Voordeur links~n~2: Voordeur Rechts")
        ShowInfo("3: Achterdeur Links~n~4: Achterdeur rechts")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(vhe, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
                ShowInfo("[Voertuig] ~g~Deur dicht")
            else 
                SetVehicleDoorOpen(veh, door, false, false)
                ShowInfo("[Voertuig] ~g~Deur opgeopend")
            end
        else
            if distanceToVeh < 4 then
                if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                    SetVehicleDoorShut(vehLast, door, false)
                    ShowInfo("[Voertuig] ~g~Door dicht")
                else 
                    SetVehicleDoorOpen(vehLast, door, false, false)
                    ShowInfo("[Voertuig] ~g~Deur geopend")
                end
                else
                    ShowInfo("[Voertuig] ~y~Je bent te ver van het voertuig.")
                end
            end
        end
    end
end)

if usingKeyPress then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsUsing(ped)
            local vehLast = GetPlayersLastVehicle()
            local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
            local door = 5
            if IsControlPressed(1, 224) and IsControlJustPressed(1, togKey) then
                if not IsPedInAnyVehicle(ped, false) then
                    if distanceToVeh < 4 then
                        if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                            SetVehicleDoorShut(vehLast, door, false)
                            ShowInfo("[Voertuig] ~g~Kofferbak is dicht")
                        else
                            SetVehicleDoorOpen(vehLast, door, false)
                            ShowInfo("[Voertuig] ~g~Kofferbak is geopend")
                        end 
                    else
                        ShowInfo("[Voertuig] ~y~ Je bent te ver van het voertuig")
                    end
                end
            end
        end
    end)
end