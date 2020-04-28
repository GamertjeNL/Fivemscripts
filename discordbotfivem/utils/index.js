module.exports = {
    /**
     * updatePlayerCount
     * Constanty update the player count
     * @param {object}  *Client The client of the bot
     * @param {number} * seconds the integer amount for the derivate of # of time it refreshes the bot's activity
     * ```js
     * const {updatePlayerCount} = require("./utils/")
     * const { Client } = require('discord.js');
     * const client = new Client;
     * updatePlayerCount(client, 10)
     * // this will update the bot's activity every 10 seconds
     * ````
     */
    updatePlayerCount: (client, seconds) => {
        const interval = setInterval(function setStatus(){
            status = `${GetNumPlayerIndices()} speler(s)`
            //console.log(status)
            client.user.setActivity(status, {type: 'WATCHING'})
            return setStatus;
        }(), seconds * 1000)
    }
}