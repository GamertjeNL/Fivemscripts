RegisterCommand('help', function()
    msg("Discord: invite.gg/zuidlandroleplay.nl")
    msg("Website: www.zuidlandroleplay.nl")
    msg("Ben je hulp nodig, contact ons via /report of via discord")
end, false)

function msg(text)
    TriggerEvent("chatMessage", "[zuidlandroleplay]", {255,0,0}, text)
end