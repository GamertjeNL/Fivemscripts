const { Client } = require('discord.js');
const client = new Client;
const {updatePlayerCount} = require("./utils/")
global.config = require("./config.json")

client.on('ready', () => {
    console.log(`Discord bot is ingelogt als: ${client.user.tag}`);
    updatePlayerCount(client, 5)
    //this will update the bot's activity every 5 seconds
});

client.login(config.token);