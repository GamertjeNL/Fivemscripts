if not LoadResourceFile(GetCurrentResourceName(), "players.json") then
    SaveResourceFile(GetCurrentResourceName(), "players.json", "{}", -1)
end

Citizen.CreateThread(function()
    while GetConvar('rcon_password', nil) ~= nil do
        local buffer = GetConsoleBuffer()

        for i=0, GetNumPlayerIndices() -1 do
            local player = GetPlayerFromIndex(i)
            if IsPlayerAuthed(player) then
                TriggerClientEvent("console:SetAuth", player, true)
                TriggerClientEvent("console:UpdateConsoleBuffer", player, buffer)
            else
                TriggerClientEvent("console:SetAuth", player, false)
            end
        end

        Citizen.Wait(500)
    end
    print('^1Geen rcon wachtwoord (ingame console): ^3Geen rcon wachtwoord gevonden in de server.cfg^7')
end)

RegisterServerEvent("console:ExecuteConsoleCommand")
AddEventHandler("console:ExecuteConsoleCommand", function(cmd)
    if IsPlayerAuthed(source) then
        ExecuteCommand(cmd)
        if not IsPrincipalAceAllowed('resource.'..GetCurrentResourceName(), 'command') then
            print('^1Controleer even als add ^3add_ace resource.'..GetCurrentResourceName()..' command allow^1 in je server.cfg staat.^7')
        end
    end
end)

RegisterServerEvent("console:CheckPasssword")
AddEventHandler("console:CheckPasssword", function(pwd)
    if GetConvar('rcon_password', nil) == pwd then
        local players = json.decode(LoadResourceFile(GetCurrentResourceName(), "players.json"))
        if players == nil then
            players = {}
        end
        
        players[GetSteamHex(source)] = pwd
        SaveResourceFile(GetCurrentResourceName(), "players.json", json.encode(players), -1)
        --TriggerClientEvent("console:SetAuth", source, true)
    else
        TriggerClientEvent("console:ErrorMsg", source, 'Geen rcon wachtwoord')
    end
end)

function IsPlayerAuthed(player)
    local players = json.decode(LoadResourceFile(GetCurrentResourceName(), "players.json"))
    if players == nil then
        players = {}
    end

    local hex = GetSteamHex(player)
    if hex ~= nil then 
        if players[hex] == GetConvar('rcon_password', nil) then
            return true
        end
    end
    return false
end

function GetSteamHex(player)
    local hex = nil
    for i=0, GetNumPlayerIdentifiers(player)-1 do
        local id = GetPlayerIdentifier(player, i)

        if string.find(id, "steam:") then
            hex = id
            break;
        end
    end
    return hex;
end