--[[
    LiveMap - A LiveMap for FiveM servers
      Copyright (C) 2017  Jordan Dalton
You should have received a copy of the GNU General Public License
along with this program in the file "LICENSE".  If not, see <http://www.gnu.org/licenses/>.
]]

local url = "https://raw.githubusercontent.com/wil2005-development/Fivemscripts/master/discordbotfivem/version.json"
local version = "1.0.0"
local latest = true

local rawData = LoadResourceFile(GetCurrentResourceName(), "version.json")

if not rawData then
print("Ik kan de version.json niet lezen, vraag de maker hier naar!")
else
rawData = json.decode(rawData)
version = rawData["resource"]
end

function checkForUpdate()
PerformHttpRequest(url, function(err, data, headers)
local parsed = json.decode(data)

if (parsed["resource"] ~= version) then
    print("|===================================================|")
    print("|             Discord bot nieuwe update             |")
    print("|    Current : " .. version .. "                    |")
    print("|    Latest  : " .. parsed["resource"] .. "         |")
    print("| Download at: https://github.com/wil2005-development/Fivemscripts |")
    print("|===================================================|")
    latest = false -- Stop running the timeout
end

-- Every 30 minutes, do the check (print the message if it's not up to date)
SetTimeout( 30 * (60*1000), checkForUpdate)

end, "GET", "",  { ["Content-Type"] = 'application/json' })
end

checkForUpdate();