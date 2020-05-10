RegisterCommand('help', function()
    msg("Discord: discord.gg/hgfh")
    msg("Website: www.google.nl")
    msg("Teamspeak: fdsf")
end, false)

function msg(text)
    TriggerEvent("chatMessage", "[server]", {255,0,0}, text)
end
