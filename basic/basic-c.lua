RegisterCommand("serverid", function(source)
    chatMessage(GetPlayerServerId(source))
end)

RegisterCommand("name", function(source)
    chatMessage(GetPlayerName(source))
end)

RegisterNetEvent("returnPing")
AddEventHandler("retunPing", function(ping)
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


PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterCommand("baan", function(source, args, raw)
    Show()
end, false)

function Show()
    TriggerEvent('mythic_notify:client:SendAlert', source, { type = 'type', text = "je baan is: ~g~" .. PlayerData.job.label .. " ~s~-~g~ " .. PlayerData.job.grade_label })
end
---------------------------------
function chatMessage(msg)
    TriggerEvent("chatMessage", "", {0,255,0}, msg)
end

local chatEnabled = true

AddEventHandler('chatMessage', function()
    if not chatEnabled then 
        CancelEvent()
    end
end)

RegisterCommand('chat', function()
    chatEnabled = not chatEnabled
    if not chatEnabled then
        TriggerEvent('chatMessage', '', {255,255,255}, 'Chat is ^1uitgezet^0')
    else 
        TriggerEvent('chatMessage', '', {255,255,255}, 'Chat is ^2aangezet^0')
    end
end, false)