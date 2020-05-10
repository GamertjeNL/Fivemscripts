RegisterCommand("jschat", async (source, args) => {
    let argSring = args.join(" ")
    emitNet("js:chat", (argSring ? argSring : "Nothing.."), [0,255,0])
    return
})