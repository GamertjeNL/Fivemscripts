RegisterCommand("serverid", function(source)
    chatMessage(GetPlayerServerId(source))
end)

RegisterCommand("name", function(source)
    chatMessage(GetPlayerName(source))
end)

RegisterNetEvent("returnPing")
AddEventHadler("retunPing", function(ping)
    pingNumber = ping
end)

RegisterCommand("ping", function(source)
    --[[ More examples at https://pastbin.com/A8Ny8AhZ  ]]
    PlaySound(source, "CANCEL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    TriggerEvent("pingping")
    chatMessage(pingNumber)
end)

RegisterCommand("health", function(source, args)
    SetEntityHealth(GetPlayerPed(-1), tonumber(args[1]))
    chatMessage("set health to "..GetEntityhealth(GetPlayerPed(-1)))
end)

---------------------------------
function chatMessage(msg)
    TriggerEvent("chatMessage", "", {0,255,0}, msg)
end