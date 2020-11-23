ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then 
    TriggerEvent('esx_service:activateService', 'fire', Config.MaxInService)
end

RegisterServerEvent('esx_firejob:revive')
AddEventHandler('esx_firejob:revive', function(target)
    TriggerEvent('esx_firejob:revive', target)
end)

TriggerEvent('esx_phone:registerNumber', 'fire', _U('alert_fire'), true, true)
TriggerEvent('esx_socierty:registerSociey', 'fire', 'fire', 'society_fire', 'society_fire', 'society_fire', {type = 'public'})

RegisterServerEvent()