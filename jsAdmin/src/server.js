const root = GetResourcePath(GetCurrentResourceName());
const def_msgs = require(`${root}/src/defaultMsgs.json`)
RegisterCommand("kick", async (source, args) => {
    if (source !== 0) {
        if (!IsPlayerAceAllowed(source, "administrator")) {
            emitNet("js:chatCL", source, { msg: "Dit mag jij niet doen, vraag een stafflid hier naar", color: [255, 0, 0] })
            return
        }
    }
    let id = args[0]
    let reason = args.join(" ").slice(id.length + 1) || def_msgs.kick_message
    if (GetPlayerIdentifier(id) == null) {
        if (source == 0) {
            console.log("Gebruiker bestaat niet.")
        } else {
            emitNet("js:chatCL", source, { msg: `Gebruiker bestaat niet.`, color: [255, 0, 0] })
        }
        return;
    }
    emit("js:chatSV", `${GetPlayerName(id)} is kick voor: ${reason}`, [255, 0, 0])
    DropPlayer(id, reason)
})

RegisterCommand("unban", async (source, args) => {
    // checking if its not the console
    if (source !== 0) {
        if (!IsPlayerAceAllowed(source, "administrator")) {
            emitNet("js:chatCL", source, { msg: "Dit mag jij niet doen, vraag een stafflid hier naar", color: [255, 0, 0] })
            return
        }
    }
    let steadId = args[0]
    let element;
    fs.readFile(`${root}/src/bans.json`, (err, data) => {
        setImmediate(() => {
            if (err) { return emitNet("js:chatCL", source, { msg: "Er is een error opgetreden vraag william#9596 er naar!", color: [255, 0, 0] }) }
            var main = JSON.parse(data)
            main.map(e => {
                if (e.steamid == steadId) {
                    element = e
                }
            })
            let index = main.indexOf(element);
            if (index > -1) {
                main.splice(index, 1)
            } else {
                if (source == 0) {
                    console.log("Gebruiker bestaat niet.")
                } else {
                    emitNet("js:chatCL", source, { msg: `Gebruiker bestaat niet.`, color: [255, 0, 0] })
                }
                return;
            }
            fs.writeFile(`${root}/src/bans.json`, JSON.stringify(main), (err) => {
                if (err) throw err;
                setImmediate(() => {
                    emit("js:chatSV", `${steadId} is geunbant`, [0, 255, 0])
                })
            })
        })
    })
})

RegisterCommand("ban", async (source, args) => {
    if (source !== 0) {
        if (!IsPlayerAceAllowed(source, "administrator")) {
            emitNet("js:chatCL", source, { msg: "Dit mag jij niet doen, vraag een stafflid hier naar", color: [255, 0, 0] })
            return
        }
    }
    var id = args[0]
    var reason = args.join(" ").slice(id.length + 1) || def_msgs.ban_message
    var steamid = GetPlayerIdentifier(id)
    if (id.includes("steam:")) {
        steamid = id;
    }
    fs.readFile(`${root}/src/bans.json`, (err, data) => {
        setImmediate(() => {
            if (err) { return emitNet("js:chatCL", source, { msg: "Er is een error opgetreden vraag william#9596 er naar!", color: [255, 0, 0] }) }
            var main = JSON.parse(data)
            if (steamid == null) {
                if (source == 0) {
                    console.log("Gebruiker bestaat niet..")
                } else {
                    emitNet("js:chatCL", source, { msg: `Gebruiker bestaat niet.`, color: [255, 0, 0] })
                }
                return;
            }
            // check for duplicates
            for (i in main) {
                if (main[i].steamid == steamid) {
                    if (source == 0) {
                        console.log("Gebruiker is al verbannen.")
                    } else {
                        emitNet("js:chatCL", source, { msg: `Gebruiker is al verbannen.`, color: [255, 0, 0] })
                    }
                    return;
                }
                return;
            }
            let entry = {
                "steamid": steamid,
                "reason": reason
            }
            main.push(entry)
            fs.writeFile(`${root}/src/bans.json`, JSON.stringify(main), (err) => {
                setImmediate(() => {
                    emit("js:chatSV", `${GetPlayerName(id) == null ? steamid : GetPlayerName(id)} is verboden ${reason}`, [255, 0, 0])
                    DropPlayer(id, reason)
                    return
                })
            })
            return
        })
    })
})

on('playerConnecting', (name, setKickReason, deferrals) => {
    var steamIdentifier;
    let player = global.source;
    deferrals.defer()
    deferrals.update(`Wij zijn even bans aan door kijken.`)
    for (let i = 0; i < GetNumPlayerIdentifiers(player); i++) {
        let identifier = GetPlayerIdentifier(player, i);
        if (identifier.includes('steam:')) {
            steamIdentifier = identifier;
        }
    }
    fs.readFile(`${root}/src/bans.json`, (err, data) => {
        if (err) throw err;
        setImmediate(() => {
            var main = JSON.parse(data)
            main.map(e => {
                if (e.steamid == steamIdentifier) {
                    deferrals.done(`Je bent verbannen. Reden: ${e.reason}`)
                }
            })
            deferrals.done()
        })
    })


})

// When this runs, it will send to the server hopefully
RegisterNetEvent('js:chatSV');
onNet("js:chatSV", (msg, color) => {
    emitNet("chat:addMessage", -1, {
        args: [msg],
        color: color
    })
    //console.log(msg)
    return
})