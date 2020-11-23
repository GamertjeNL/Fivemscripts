Registercommand('help', function()
    msg("discord: https://discord.gg/JnE3BEJ")
    msg("heb je een report dat kan via /report <id> <reden>")

end,false)

function msg(text)
    TriggerEvent("chatMessage", "[harderwijkrp]", {255,0,0}, text)
end