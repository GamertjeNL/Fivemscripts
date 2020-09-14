Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        Citizen.Wait(5*1000)
        
        SetDiscordAppId(714075334625984552)

        -- Waar die gene is.
        SetRichPresence( GetPlayerName(source)  .. " is bij " .. GetStreetNameFormHashKey( GetStreetNameAtCoord(table.unpack(GetEntityCoords(player) ) ) ) )

        SetDiscordRichPresenceAsset("Big")
        SetDiscordRichPresenceAssetText(GetPlayerName(source))

        SetDiscordRichPresenceAssetsmall("HarderwijkRP")
        SetDiscordRichPresenceAssetText("Health: ".. (GetEntityHealth(player) - 100 ) )
    
    end
end)



