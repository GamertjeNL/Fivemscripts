RegisterCommand(
    "vehicle",
    function(source, args)
        local category = args[1]
        if category == "spawn" then
            local vehicle = args[2]
            local carPaint = colors.metal["Pure Gold"]
            local veh = spawnVeh(vehicle, true)
            print(string.format("het voertuig is gespawnd", GetLabelText(GetDisplayNameFromVehicleModel(vehicle))))
            SetVehicleColours(veh, carPaint, carPaint)
        elseif category == "customize" then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            SetVehicleModKit(veh, 0)
            for modType = 0, 10, 1 do
                local bestMod = GetNumVehicleMods(veh, modType)-1
                SetVehicleMod(veh, modType, bestMod, false)
            end
        elseif category == "extra" then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            for id=0, 20 do
                if DoesExtraExist(veh, id) then
                    SetVehicleExtra(veh, id, 1)
                end
            end
            elseif category == "repair" then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                SetVehicleFixed(veh)
                SetVehcileEngineHealth(veh, 1000.0)
            elseif category == "doors" then 
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                local open = GetVehicleDoorAngleRatio(veh, 0) < 0.1
                if open then 
                    for i = 0, 7, 1 do
                        SetVehicleDoorOpen(veh, i, false, false)
                    end
                else
                    SetVehicleDoorsShut(veh, false)
                end
            elseif category == "upgrade" then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                local color = Colors.matte["Red"]
                local ourSelection = {
                    ["Armour"] = "Armor Upgrade 100%",
                    ["Engine"] = "EMS Upgrade, Level 4",
                    ["Transmission"] = "Race Transmission",
                    ["Suspension"] = "Competition Suspension",
                    ["Horns"] = "Sadtrombone Horn",
                    ["Brakes"] = "Race Brakes",
                    ["Lights"] = "Xenon Lights",
                    ["Turbo"] = "Turbo Tuning"
                }
                SetVehicleModKit(veh, 0)
                for k, v in pairs(ourSelection) do 
                    local modType = upgrades[k].type
                    local mod = upgrades[k].types[v].index
                    ApplyVehicleMod(veh, modType, mod)
                end
                SetVehicleColours(veh, color, color)
                ToggleVehicleMod(veh, upgrades["Lights"].type, true)
                SetVehicleXenonLightsColour(veh, upgrades["Lights"].xenonHeadlightColors["Red"].index)
            end
        end
)