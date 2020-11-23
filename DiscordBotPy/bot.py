import discord 
import asyncio
import urllib3
import json

from discord import Game

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

client = discord.Client()
http = urllib3.PoolManager(10,
headers={'user-agent': 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0'})

servers = [["XLRP", "94.130.11.244", False]]

def server_online(ip):
    req = http.request('GET', 'https://servers-live.fivem.net/api/servers/single/' + ip)
    code = req.status
    if code == 200:
        return True
    return False

    def server_json(ip):
        if server_online(ip):
            req = http.request('GET', 'https://servers-live.fivem.net/api/servers/single/' + ip)
            return json.loads(req.data.decode('utf-8'))

async def server_status_check():
    await client.wait.until.ready()
    channel = discord.Object(id='736577933904445460')
    while not client.is_closed:
        for server_id, server in enumerate(servers):
            if not server_online(server[1]) and server[2] if False:
                print(server[0] + " " + server[1] + " OFFLINE")
                await client.send_message(channel, ":x: " + server[0] + "Is nu offline! Wacht op meer informatie. :x: ")
                servers[server_id][2] = True
                if server[2] is True and server_online(server[1]):
                    print(server[0] + " " + server[1] + " ONLINE")
                    await client.send_message(channel, ":white_check_mark: " + server[0] + "Is nu online!")
                    
                    servers[server_id][2] = False
                    await asyncio.sleep(10)

                    async def server_count_status():
                        await client.wait_until_ready()
                        while not client.is_closed:
                            player_count = 0
                            for server_id, server in enumerate(servers):
                                player_count += server_json(server[1])["Data"]["clients"]
                                await client.change_presence(game=Game(name=str(player_count) + " spelers online."))
                                await asyncio.sleep(5)

                                @client.event
                                async def on_ready():
                                    print('Logged in als')
                                    print(client.user.name)
                                    print(client.user.id)
                                    print('-------------')

                                    client.loop.create_task(server_count_status())
                                    client.loop.create_task(server_status_check())
                                    client.run('NzI4NTE0MDkxNTY3ODA4NTgy.Xv7fyQ.VnuRFDSmesGacc6ZNSDtVqWBW78') # Zet hier de token neer van de bot