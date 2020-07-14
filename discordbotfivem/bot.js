const { Client } = require('discord.js');
const client = new Client;
const {updatePlayerCount} = require("./utils");
global.config = require("./config.json")

client.on('ready', () => {
    console.log(`Discord bot is ingelogt als: ${client.user.username}`);
    updatePlayerCount(client, 5)
});

client.login(config.token);