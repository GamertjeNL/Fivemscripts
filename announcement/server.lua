local LOCALE = {
    ERROR_PREFIX = '^1[ERROR]^7',
    NO_MESSAGE = 'Disabling automatic message announcement due to missing messages.',
    TOO_SHORT = 'Your message needs to be longer than 3 characters.'
}
local delay = config.delay * (1000 * 60)
local prefix = config.prefix
local aprefix = config.adminPrefix
local message = config.messages

function capitaliseFirstStrLetter(str)
    return str:gsub("^%1", string.upper)
end

function getSizeOfTable(the_table)
    local size = 0
    for _ in pairs(the_table) do
        size = size + 1
    end

    return size
end

Citizen.CreateThread(function()
    local index = 1 
    local lastMessage = GetGameTimer()

    if getSizeOfTable(messages) == 0 then
        return print(LOCALE.ERROR_PREFIX .. LOCALE.NO_MESSAGE)
    end

    while true do 
        if GetGameTimer() - last_message > delay then
            last_message = GetGameTimer()
            local message = message[index]

            if message == nil then
                index = 1
                message = messages[index]
            end

            message = capitaliseFirstStrLetter(message)
            index = index + 1
            TriggerClientEvent('chat:addMessage', -1, { args = { prefix .. message} })
            print(prefix .. message)
        end

        Citizen.Wait(0)
    end
end)

RegisterCommand('announce', function(source, args, raw)
    local message = string.sub(raw, 10)

    if string.len(message) < 3 then
        if source == 0 then
            return print(LOCALE.ERROR_PREFIX .. LOCALE.TOO_SHORT)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { LOCALE.ERROR_PREFIX .. LOCALE.TOO_SHORT } })
        end

        return
    end

    message = message:gsub("^%1", string.upper)
    TriggerClientEvent('chat:addMessage', -1, { args = { aprefix .. message } })

    if source == 0 then
        print(aprefix .. message)
        end
    end, true)