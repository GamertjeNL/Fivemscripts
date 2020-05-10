RegisterNetEvent("js:chatCL")
onNet("js:chatCL", (obj) => {
    emit("chat:addMessage", {
        args: [obj.msg],
        color:obj.color
    })
    console.log(obj.msg)
    return
})



setImmediate(() => {
    emit('chat:addSuggestion', '/kick', 'admin command kick iemand', [
        { name: "id", help: "De speler zijn id" }
    ]);
    emit('chat:addSuggestion', '/unban', 'Unban iemand Admin command', [
        { name: "Steam ID", help:"ex: steam:110000110ba80e2" }
    ]);
    emit('chat:addSuggestion', '/ban', 'ban Iemand Admin Command', [
        { name: "id", help: "Iemand zijn server id" }
    ]);
});