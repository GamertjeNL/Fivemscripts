ESX = nil

local currentPlayerJobName  = 'none'
local PlayerData
local jobTitle = 'McDonalds'

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
        print("ESX.GetPlayerData().job = nil, waiting until not nil..")
		Citizen.Wait(100)
	end

    if currentPlayerJobName == jobTitle then
        refreshBlips()
    end

	PlayerData = ESX.GetPlayerData()
    currentPlayerData = PlayerData
	refreshBlips()
end)

local isInMarker = false
local menuIsOpen = false
local vehcileMenuIsOpen = false
local hintToDisplay = "no hint to display"
local displayHint = false
local currentZone = 'none'
local currentJob = 'none'
local currentPlayerData = {}
local playerPed = PlayerPedId()

local invDrink = 0
local invBurger = 0
local invFries = 0
local invMeal = 0

local payBonus = 0
local bonus = 1.25

local mealsMade = 0
local customersServed = 0
local ordersDelivered = 0

local paidDeposit = 0

local lastDelivery = 'none'

local showingBlips = false
local hasTakenOrder = false
local hasOrder = false
local isDelivering = false
local isDriveDelivering = false

local dHasTakenOrder = false
local dHasOrder = false
local dIsDelivering = false
local driverHasCar = false

local taskPoints = {}
local Blips = {}
local deliveryCoords
local dDeliveryCoords

--Press [E] Buttons
Citizen.CreateThread(function()
	while true do																
		Citizen.Wait(2)					
		if not menuIsOpen then
			local playerCoords = GetEntityCoords(GetPlayerPed(-1))
            if currentPlayerJobName == jobTitle then
			    if  playerIsInside(playerCoords, Config.JobMenuCoords, Config.JobMarkerDistance) then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Jobmenu te openen."									
			    	currentZone = 'JobList'																
			    elseif  playerIsInside(playerCoords, Config.CookBurgerCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Burger te koken."									
			    	currentZone = 'Burger'																
			    elseif  playerIsInside(playerCoords, Config.CookFriesCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Fries te koken."									
			    	currentZone = 'Fries'																
			    elseif  playerIsInside(playerCoords, Config.CookDrinkCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Drink te krijgen."									
			    	currentZone = 'Drink'																
			    elseif  playerIsInside(playerCoords, Config.CookPrepareCoords, Config.JobMarkerDistance) and currentJob == 'cook' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Maaltijd te bereiden."									
			    	currentZone = 'Prepare'		    
			    elseif  playerIsInside(playerCoords, Config.CashTakeOrder, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om de bestelling op te nemen."									
			    	currentZone = 'cOrder'	
                elseif  playerIsInside(playerCoords, Config.CashTakeOrder1, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om de bestelling op te nemen."									
			    	currentZone = 'cOrder'
                elseif  playerIsInside(playerCoords, Config.CashTakeOrder2, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om de bestelling op te nemen."									
			    	currentZone = 'cOrder'
                elseif  playerIsInside(playerCoords, Config.CashTakeOrder3, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om de bestelling op te nemen."									
			    	currentZone = 'cOrder'
                elseif  playerIsInside(playerCoords, Config.CashTakeOrder4, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om de bestelling op te nemen."									
			    	currentZone = 'cOrder'
                elseif  playerIsInside(playerCoords, Config.CashTakeOrder5, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om de bestelling op te nemen."									
			    	currentZone = 'cOrder'
			    elseif  playerIsInside(playerCoords, Config.CashCollectMeal, Config.JobMarkerDistance) and currentJob == 'cashier' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Meal te verzamelen."									
			    	currentZone = 'cCollect'	
                elseif  deliveryCoords ~= nil and playerIsInside(playerCoords, deliveryCoords, Config.JobExtendedDistance) and currentJob == 'cashier' and isDelivering then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ maaltijd aan de klant te bezorgen."									
			    	currentZone = 'cDeliver'
                elseif  playerIsInside(playerCoords, Config.CashCollectMeal, Config.JobMarkerDistance) and currentJob == 'deliv' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Maaltijd voor bezorging te verzamelen."									
			    	currentZone = 'dCollect'
                elseif  dDeliveryCoords ~= nil and playerIsInside(playerCoords, dDeliveryCoords, Config.JobExtendedDistance) and currentJob == 'deliv' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Maaltijd aan de klant te bezorgen."									
			    	currentZone = 'dDeliver'
                elseif  dDeliveryCoords == nil and currentJob == 'deliv' and dHasOrder then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om af te leveren."									
			    	currentZone = 'dDeliver'
                elseif  playerIsInside(playerCoords, Config.DeliveryCarSpawnMarker, Config.JobMarkerDistance) and currentJob == 'deliv' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Press ~INPUT_CONTEXT~ to open ~y~McDonalds~b~ Work Vehicle Menu."									
			    	currentZone = 'dCarSpawn'
                elseif  playerIsInside(playerCoords, Config.DeliveryCarDespawn, Config.JobExtendedDistance) and currentJob == 'deliv' and driverHasCar then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = "~b~Druk op ~INPUT_CONTEXT~ om ~y~McDonalds~b~ Work Vehicle terug te sturen."									
			    	currentZone = 'dCarDespawn'
                else
			    	isInMarker = false
			    	displayHint = false
			    	hintToDisplay = "No hint to display"
			    	currentZone = 'none'
			    end
			    if IsControlJustReleased(0, 38) and isInMarker then
			    	taskTrigger(currentZone)													
			    	Citizen.Wait(500)
			    end
            end
		end
	end
end)
--Start Blips
Citizen.CreateThread(function()
    if showingBlips == false then
        if Config.EnableBlips == true then
            refreshBlips()
        else
            deleteBlips()
        end
    else
        deleteBlips()
        if Config.EnableBlips == true then
            refreshBlips()
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)		
    playerData = xPlayer
    currentPlayerData = xPlayer
    if Config == nil then
        print("Kon Config niet laden")
    else
        if Config.EnableBlips == true then
            while currentPlayerData.job == jobTitle and jBlipsCreated == 0 do
                refreshBlips()
                Citizen.Wait(100)
            end
        end
    end								
end)

RegisterNetEvent('esx:getJob')
AddEventHandler('esx:getJob', function(job)
    currentPlayerData.job = job
    currentPlayerJobName = job.name
    if job.name == jobTitle then 
        onDuty = true
        print("Speler is begonnen met werken op: "..jobTitle.."")
    else
        onDuty = false
        print("Titel "..jobTitle.." Niet gevonden")
    end
    refreshBlips()						
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    currentPlayerData.job = job
    currentPlayerJobName = job.name
    if job.name == jobTitle then 
        onDuty = true
        print("Speler is begonnen met werken op "..jobTitle..": onDuty = waar")
    else
        onDuty = false
        print("Titel "..jobTitle.." niet gevonden! onDuty = false")
    end
    refreshBlips()						
end)
--Hint to Display
Citizen.CreateThread(function()
    while true do										
    Citizen.Wait(1)
        if displayHint and onDuty then							
            SetTextComponentFormat("STRING")				
            AddTextComponentString(hintToDisplay)			
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)	
        end
    end
end)
--Display Markers
Citizen.CreateThread(function()
	while true do																			
		Citizen.Wait(1)
		local playerCoords = GetEntityCoords(GetPlayerPed(-1))
		if currentPlayerJobName == 'McDonalds' and playerIsInside(playerCoords, Config.JobMenuCoords, 20) then 
			displayMarker(Config.JobMenuCoords)
		end
		if onDuty and currentJob == 'cook' and playerIsInside(playerCoords, Config.JobMenuCoords, 100) then			
			if invBurger < 2 then
                displayMarker(Config.CookBurgerCoords)
            end
            if invDrink < 2 then
                displayMarker(Config.CookDrinkCoords)
            end
            if invFries < 2 then
                displayMarker(Config.CookFriesCoords)
            end
            if invBurger > 0 and invDrink > 0 and invFries > 0 then
                displayMarker(Config.CookPrepareCoords)
            end
		end
		if onDuty and currentJob == 'cashier' and playerIsInside(playerCoords, Config.JobMenuCoords, 100) then 			
			if hasTakenOrder == false then
                displayMarker(Config.CashTakeOrder)
                displayMarker(Config.CashTakeOrder1)
                displayMarker(Config.CashTakeOrder2)
                displayMarker(Config.CashTakeOrder3)
                displayMarker(Config.CashTakeOrder4)
                displayMarker(Config.CashTakeOrder5)
            elseif hasTakenOrder and hasOrder == false then
                displayMarker(Config.CashCollectMeal)
            end
            if isDelivering == true then
                local temp = vector3(deliveryCoords.x,deliveryCoords.y,deliveryCoords.z)
                deliveryMarker(temp)
            end
		end
        if onDuty and currentJob == 'deliv' and playerIsInside(playerCoords, Config.JobMenuCoords, 10000) then
            if dHasOrder == false then
                displayMarker(Config.CashCollectMeal)
            end
            if isDriveDelivering == true then
                if dDeliveryCoords ~= nil then
                    local temp = vector3(dDeliveryCoords.x,dDeliveryCoords.y,dDeliveryCoords.z - 1)
                    deliveryDMarker(temp)
                else
                    print(Config.Prefix.."^2dProblemen met een marker, vraag de dev hier naar.")
                end
            end
            displayMarker(Config.DeliveryCarSpawnMarker)
            if driverHasCar == true then
                destroyMarker(Config.DeliveryCarDespawn)
            end
        end
	end
end)

function playerIsInside(playerCoords, coords, distance) 	
	local vecDiffrence = GetDistanceBetweenCoords(playerCoords, coords.x, coords.y, coords.z, false)
	return vecDiffrence < distance		
end
--Zones
function taskTrigger(zone)				
	if zone == 'JobList' then				
		openMenu()
	elseif zone == 'Burger' then				
		getBurger()
	elseif zone == 'Fries' then	
		getFries()
	elseif zone == 'Drink' then
        getDrink()
    elseif zone == 'Prepare' then
        prepareMeal()
    elseif zone == 'cOrder' then
        takeOrder()
    elseif zone == 'cCollect' then
        pickupOrder()
    elseif zone == 'cDeliver' then
        deliverOrder()
    elseif zone == 'dCollect' then
        pickupDelivery()
    elseif zone == 'dDeliver' then
        driveFromDelivery()
    elseif zone == 'dCarSpawn' then
        openWorkVehicleMenu()
    elseif zone == 'dCarDespawn' then
        deleteCar()
    end
end

function getBurger()
    if invBurger >= 2 then
        exports.pNotify:SendNotification({text = "Je kunt alleen x2 hamburgers meenemen! Overweeg om een ​​hamburger, drankje en friet te gebruiken om een ​​maaltijd te bereiden.", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        --Alerts | alert | notice | info | success | error 
        startAnim("misscarsteal2fixer", "confused_a")
        exports.pNotify:SendNotification({text = "Begonnen met koken McDonalds Burger ...", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CookBurgerTime, "Cooking McDonalds Burger")
	    FreezeEntityPosition(playerPed, true)
        Citizen.Wait(Config.CookBurgerTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_burger')
        exports.pNotify:SendNotification({text = "Klaar met koken McDonalds Burger ...", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invBurger = invBurger + 1
    end
end

function getFries()
    if invFries >= 2 then
        exports.pNotify:SendNotification({text = "Je kunt alleen x2 frietjes meenemen! Overweeg om een ​​hamburger, drankje en friet te gebruiken om een ​​maaltijd te bereiden.", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        --Alerts | alert | notice | info | success | error 
        startAnim("mp_common", "givetake1_a")
        exports.pNotify:SendNotification({text = "Begon met het koken van McDonalds Fries ...", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CookFriesTime, "Cooking McDonalds Fries")
        FreezeEntityPosition(playerPed, true)
        Citizen.Wait(Config.CookFriesTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_fries')
        exports.pNotify:SendNotification({text = "Klaar met koken McDonalds frietjes ...", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invFries = invFries + 1
    end
end

function getDrink()
    if invDrink >= 2 then
        exports.pNotify:SendNotification({text = "Je kunt alleen x2 drankjes meenemen! Overweeg om een ​​hamburger, drankje en friet te gebruiken om een ​​maaltijd te bereiden.", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        --Alerts | alert | notice | info | success | error 
        startAnim("mp_common", "givetake1_a")
        exports.pNotify:SendNotification({text = "Begon met het gieten van McDonalds Drink ...", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CookDrinkTime, "Pouring McDonalds Drink")
        FreezeEntityPosition(playerPed, true)
        Citizen.Wait(Config.CookDrinkTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_drink')
        exports.pNotify:SendNotification({text = "Klaar met het gieten van McDonalds-drank ...", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invDrink = invDrink + 1
    end
end

function prepareMeal()
    if invBurger > 0 and invDrink > 0 and invFries > 0 then
        --Alerts | alert | notice | info | success | error 
        startAnim("misscarsteal2fixer", "confused_a")
        exports.pNotify:SendNotification({text = "Begonnen met het bereiden van McDonalds-maaltijd ...", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CookPrepareTime, "Preparing McDonalds Meal")
        FreezeEntityPosition(playerPed, true)
        Citizen.Wait(Config.CookPrepareTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        exports.pNotify:SendNotification({text = "Klaar met het bereiden van de McDonalds-maaltijd ...", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invBurger = invBurger - 1
        invDrink = invDrink - 1
        invFries = invFries - 1
        mealsMade = mealsMade + 1
        TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_burger')
        TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_drink')
        TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_fries')
        if Config.EnableMoreWorkMorePay == true then
            bonus = 1 * mealsMade
            payBonus = Config.CashJobPay * bonus
            TriggerServerEvent("dgrp_mcdonalds:getPaid", payBonus)
            if mealsMade > 1 then
                ESX.ShowNotification('~b~Je hebt een ~g~bonus~b~ ontvangen voor opeenvolgend werk. ga zo door! Bonus:~g~x'..bonus)
            end
            ESX.ShowNotification('~b~Je bent betaald ~g~+$'..payBonus..'~b~.')
        else
            TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.CookJobPay)
            ESX.ShowNotification('~b~Je bent betaald ~g~+$'..Config.CookJobPay..'~b~.')
        end
    else
        exports.pNotify:SendNotification({text = "Niet genoeg ingrediënten! 1 van elk item nodig!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports.pNotify:SendNotification({text = "Je hebt momenteel x"..invBurger.." Burger(s), x"..invDrink.." Drank (en) en x"..invFries.." Fries", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function takeOrder()
    if hasTakenOrder == false then
        --Alerts | alert | notice | info | success | error 
        
        exports.pNotify:SendNotification({text = "Begon met het nemen van McDonalds Order", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashOrderTime, "Taking McDonalds Order")
        FreezeEntityPosition(playerPed, true)
        startAnim("special_ped@jerome@monologue_7@monologue_7a", "listenlisten_0")
        local tempTime = Config.CashOrderTime / 2
        Citizen.Wait(tempTime)
        ClearPedTasks(PlayerPedId())
        startAnim("mp_common", "givetake1_a")
        Citizen.Wait(tempTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        exports.pNotify:SendNotification({text = "Klaar met het nemen van de McDonalds-bestelling", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})        
        hasTakenOrder = true
    else
        exports.pNotify:SendNotification({text = "U heeft al een bestelling ontvangen", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})       
    end    
end

function pickupOrder()
    if hasOrder == false and hasTakenOrder == true then
        startAnim("misscarsteal2fixer", "confused_a")
        exports.pNotify:SendNotification({text = "Begon met het verzamelen van McDonalds Order", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashMealTime, "Collecting McDonalds Order")
        FreezeEntityPosition(playerPed, true)
        Citizen.Wait(Config.CashMealTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
        exports.pNotify:SendNotification({text = "Klaar met het verzamelen van de McDonalds-bestelling", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invMeal = invMeal + 1
        hasOrder = true
        setDelivery()
    elseif hasOrder == true and hasTakenOrder == true then
        exports.pNotify:SendNotification({text = "U heeft al een maaltijd te bezorgen!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    elseif hasTakenOrder == false and hasOrder == false then
        exports.pNotify:SendNotification({text = "U heeft geen actieve bestellingen!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        exports.pNotify:SendNotification({text = "ERROR: Geef dit door aan de script dev", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function setDelivery()
    repeat
    deliveryPoint = math.random(1, #Config.cashDeliveryPoints)
	until deliveryPoint ~= lastDelivery
    print(Config.Prefix.."Afleverpunt is tabel: "..deliveryPoint)
    print(Config.Prefix.."Laatste afleverpunt was tafel: "..deliveryPoint)
	deliveryCoords = Config.cashDeliveryPoints[deliveryPoint]
    print(Config.Prefix.."Coördinaten zijn vastgesteld op: X:"..deliveryCoords.x..", Y:"..deliveryCoords.y..", Z:"..deliveryCoords.z..".")
	taskPoints['delivery'] = { x = deliveryCoords.x, y = deliveryCoords.y, z = deliveryCoords.z}
	lastDelivery = deliveryPoint
    isDelivering = true
    setGPS(deliveryCoords)
    print(Config.Prefix.."Moet nu bezorgmarkering weergeven")
    exports.pNotify:SendNotification({text = "Breng de bestelling naar de klant op tafel: "..deliveryPoint, type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end

function deliverOrder()
    startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
    exports.pNotify:SendNotification({text = "Begonnen met het geven van klantorder", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    exports['progressBars']:startUI(Config.CashDelivTime, "Opdracht geven aan klant")
    FreezeEntityPosition(playerPed, true)
    Citizen.Wait(Config.CashDelivTime)
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(PlayerPedId())
    exports.pNotify:SendNotification({text = "Klaar met het geven van een bestelling aan de klant", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
    customersServed = customersServed + 1
    RemoveBlip(Blips['deliver'])
    TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_meal')
    if Config.EnableMoreWorkMorePay == true then
        bonus = 1 * customersServed
        payBonus = Config.CashJobPay * bonus
        TriggerServerEvent("dgrp_mcdonalds:getPaid", payBonus)
        if customersServed > 1 then
            ESX.ShowNotification('~b~Je hebt een ~g~bonus~b~ ontvangen voor opeenvolgend werk. ga zo door! Bonus: ~g~x'..bonus)
        end
        ESX.ShowNotification('~b~Je bent betaald ~g~+$'..payBonus..'~b~.')
    else
        TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.CashJobPay)
        ESX.ShowNotification('~b~Je bent betaald ~g~+$'..Config.CashJobPay..'~b~.')
    end

    hasOrder = false
    hasTakenOrder = false
    isDelivering = false
    deliveryCoords = nil
end

function pickupDelivery()
    if dHasOrder == false then
        startAnim("misscarsteal2fixer", "confused_a")
        exports.pNotify:SendNotification({text = "Begon met het verzamelen van McDonalds Order", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashMealTime, "Collecting McDonalds Order")
        FreezeEntityPosition(playerPed, true)
        Citizen.Wait(Config.CashMealTime)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
        exports.pNotify:SendNotification({text = "Klaar met het verzamelen van de McDonalds-bestelling", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invMeal = invMeal + 1
        dHasOrder = true
        setDriveDelivery()
    elseif dHasOrder == true then
        exports.pNotify:SendNotification({text = "U heeft al een maaltijd te bezorgen!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        exports.pNotify:SendNotification({text = "ERROR: Zeg dit tegen de maker van de script", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function setDriveDelivery()
    repeat
    deliveryPoint = math.random(1, #Config.driveDeliveryPoints)
	until deliveryPoint ~= lastDelivery
    print(Config.Prefix.."Afleverpunt is: "..deliveryPoint)
    print(Config.Prefix.."Laatste afleverpunt was: "..deliveryPoint)
	dDeliveryCoords = Config.driveDeliveryPoints[deliveryPoint]
    print(Config.Prefix.."Coördinaten zijn vastgesteld op: X:"..dDeliveryCoords.x..", Y:"..dDeliveryCoords.y..", Z:"..dDeliveryCoords.z..".")
	--taskPoints['delivery'] = { x = deliveryCoords.x, y = deliveryCoords.y, z = deliveryCoords.z}
	lastDelivery = deliveryPoint
    isDriveDelivering = true
    setGPS(dDeliveryCoords)
    print(Config.Prefix.."Should now be displaying Delivery Marker")
    exports.pNotify:SendNotification({text = "Bezorg de bestelling aan de klant", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end

function isMyCar()
	return currentPlate == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function openWorkVehicleMenu()
    if driverHasCar == true then
        replaceLostCar(true)
        exports.pNotify:SendNotification({text = "Het lijkt alsof u uw werkvoertuig bent kwijtgeraakt. U krijgt uw aanbetaling niet terug als u deze vervangt!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        openVehicleMenu()
        exports.pNotify:SendNotification({text = "Kies welk voertuig u wilt.", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function replaceLostCar(bool)
    if bool == true then
        ESX.Game.DeleteVehicle(currentCar)			
        driverHasCar = false
        exports.pNotify:SendNotification({text = "Werkvoertuig vervangen!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        ESX.UI.CloseAll()
    end
end

function openVehicleMenu()
    vehicleMenuIsOpen = true
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'VehicleList',			
        {
        title    = "McDoanalds Work Vehicle Menu",	
        elements = {
            {label = "McDonalds Van - $"..Config.VanDepositAmount, value = 'van'},		
            {label = "McDonalds Bike - $"..Config.BikeDepositAmount, value = 'bike'}
        }
    },
    function(data, menu)									
        if data.current.value == 'van' then	
            menu.close()
	        vehicleMenuIsOpen = false
            spawnVehicle(Config.CarToSpawn, Config.VanDepositAmount)  
            if Config.PayDeposit == true then
                exports.pNotify:SendNotification({text = "U ontvangt uw volledige aanbetaling wanneer u het voertuig veilig terugbrengt.", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                paidDeposit = Config.VanDepositAmount
            else
                exports.pNotify:SendNotification({text = "Voertuig voortgebracht.", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            end

        end
        if data.current.value == 'bike' then
            menu.close()
	        vehicleMenuIsOpen = false
            spawnVehicle(Config.BikeToSpawn, Config.BikeDepositAmount)  
            if Config.PayDeposit == true then
                exports.pNotify:SendNotification({text = "U ontvangt uw volledige aanbetaling wanneer u het voertuig veilig terugbrengt.", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                paidDeposit = Config.BikeDepositAmount
            else
                exports.pNotify:SendNotification({text = "Vehicle Spawned.", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            end
        end
        menu.close()
	    vehicleMenuIsOpen = false
    end,
        function(data, menu)
        menu.close()
	    vehicleMenuIsOpen = false
    end)
end

function spawnVehicle(carToSpawn, depositAmount)
    if Config.PayDeposit == true then
        TriggerServerEvent("dgrp_mcdonalds:payDeposit", depositAmount)
    end
	local vehicleModel = GetHashKey(carToSpawn)	
	RequestModel(vehicleModel)				
	while not HasModelLoaded(vehicleModel) do	
		Citizen.Wait(0)
	end
	currentCar = CreateVehicle(vehicleModel, Config.DeliveryCarSpawn.x, Config.DeliveryCarSpawn.y, Config.DeliveryCarSpawn.z, Config.DeliveryCarSpawn.h, true, false)
	SetVehicleHasBeenOwnedByPlayer(currentCar,  true)														
	SetEntityAsMissionEntity(currentCar,  true,  true)														
	SetVehicleNumberPlateText(currentCar, "MACCAS")								
	local id = NetworkGetNetworkIdFromEntity(currentCar)													
	SetNetworkIdCanMigrate(id, true)																																																
	TaskWarpPedIntoVehicle(GetPlayerPed(-1), currentCar, -1)
    driverHasCar = true
	local props = {																							
		modEngine       = 0,
		modTransmission = 0,
		modSuspension   = 3,
		modTurbo        = true,																				
	}
	ESX.Game.SetVehicleProperties(currentCar, props)
	Wait(1000)																							
	currentPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function deleteCar()
    if isMyCar() == true then
        if Config.PayDeposit == true then
            TriggerServerEvent("dgrp_mcdonalds:returnDeposit", paidDeposit)
            ESX.ShowNotification('~b~Uw aanbetaling is teruggestort ~g~+$'..paidDeposit..'~b~.')
            paidDeposit = 0
        end
    	local entity = GetVehiclePedIsIn(GetPlayerPed(-1), false)	
	    ESX.Game.DeleteVehicle(entity)			
        driverHasCar = false
        exports.pNotify:SendNotification({text = "Werkvoertuig terug!", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        exports.pNotify:SendNotification({text = "Dit is niet het voertuig dat je hebt gekregen!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function setGPS(coords)
	if Blips['deliver'] ~= nil then 	
		RemoveBlip(Blips['deliver'])	
		Blips['deliver'] = nil			
	end
	if coords ~= 0 then
		Blips['deliver'] = AddBlipForCoord(coords.x, coords.y, coords.z)		
		SetBlipRoute(Blips['deliver'], true)								
	end
end

function driveFromDelivery()
 startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
    exports.pNotify:SendNotification({text = "Begonnen met het opnemen van klantorder", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    exports['progressBars']:startUI(Config.CashDelivTime, "Giving Order to Customer")
    FreezeEntityPosition(playerPed, true)
    Citizen.Wait(Config.CashDelivTime)
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(PlayerPedId())
    exports.pNotify:SendNotification({text = "Klaar met het opnemen van een bestelling aan de klant", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
    ordersDelivered = ordersDelivered + 1
    RemoveBlip(Blips['deliver'])
    TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_meal')
    if Config.EnableMoreWorkMorePay == true then
        bonus = 1 * ordersDelivered
        payBonus = Config.DelivJobPay * bonus
        TriggerServerEvent("dgrp_mcdonalds:getPaid", payBonus)
        if customersServed > 1 then
            ESX.ShowNotification('~b~Je hebt een ~g~bonus~b~ ontvangen voor opeenvolgend werk. ga zo door! Bonus: ~g~x'..bonus)
        end
        ESX.ShowNotification('~b~Je bent betaald ~g~+$'..payBonus..'~b~.')
    else
        TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.DelivJobPay)
        ESX.ShowNotification('~b~Je bent betaald ~g~+$'..Config.DelivJobPay..'~b~.')
    end

    dHasOrder = false
    isDriveDelivering = false
    dDeliveryCoords = nil
end

local mBlipsCreated = 0
local jBlipsCreated = 0

function deleteBlips()
    print(Config.Prefix.."Blips verwijderen")
    while blipM ~= nil do
        print(Config.Prefix.."blipM is nog steeds actief en probeert te verwijderen.")
        RemoveBlip(blipM)
        mBlipsCreated = mBlipsCreated - 1
        Citizen.Wait(100)
    end
    while blipJ ~= nil do
        print(Config.Prefix.."blipJ is nog steeds actief en probeert te verwijderen.")
        RemoveBlip(blipJ)
        jBlipsCreated = jBlipsCreated - 1
        Citizen.Wait(100)
    end
    while mBlipsCreated > 1 do
        RemoveBlip(blipM)
        mBlipsCreated = mBlipsCreated - 100
        Citizen.Wait(100)
    end
    while jBlipsCreated > 1 do
        RemoveBlip(blipJ)
        jBlipsCreated = jBlipsCreated - 100
        Citizen.Wait(100)
    end
    showingBlips = false
    if Config.EnableBlips == true and showingBlips == false and mBlipsCreated == 0 and jBlipsCreated == 0 then
        refreshBlips()
    elseif showingBlips == false and blipJ ~= nil and blipM ~= nil then
        deleteBlips()
    end
end

function refreshBlips()
    print(Config.Prefix.."Refreshing Blips")
    if showingBlips == false then
        if mBlipsCreated == 0 then
            print(Config.Prefix.."Momenteel worden Blips = false weergegeven (M Blip maken)")
            local blipM = AddBlipForCoord(Config.blipLocationM.x, Config.blipLocationM.y)

            SetBlipSprite(blipM, Config.blipIDM)
            SetBlipDisplay(blipM, 6)
            SetBlipScale(blipM, Config.blipScaleM)
            SetBlipColour(blipM, Config.blipColorM)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("~y~Mc~r~Donald~y~'~r~s")
            EndTextCommandSetBlipName(blipM)
            mBlipsCreated = mBlipsCreated + 1
        end
        print(Config.Prefix.."De huidige naam van de speler is: "..ESX.GetPlayerData().job.name)
        if ESX.GetPlayerData().job.name == jobTitle and Config.EnableJobBlip == false then
            if jBlipsCreated == 0 then
                print(Config.Prefix.."Functietitel = "..jobTitle.." en Config.EnableJobBlip = false (Job Blip maken)")
                local blipJ = AddBlipForCoord(Config.blipLocationJ.x, Config.blipLocationJ.y)
                jBlipsCreated = jBlipsCreated + 1
                SetBlipSprite(blipJ, Config.blipIDJ)
                SetBlipDisplay(blipJ, 6)
                SetBlipScale(blipJ, Config.blipScaleJ)
                SetBlipColour(blipJ, Config.blipColorJ)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString("~y~Mc~r~Donalds ~y~Job ~r~Selection")
                EndTextCommandSetBlipName(blipJ)
            end
        elseif Config.EnableJobBlip == true then
            if jBlipsCreated == 0 then
                print(Config.Prefix.."Config.EnableJobBlip = true (Taakmarkering weergeven voor ^2IEDEREEN!^4)")
                local blipJ = AddBlipForCoord(Config.blipLocationJ.x, Config.blipLocationJ.y)
                mBlipsCreated = mBlipsCreated + 1
                SetBlipSprite(blipJ, Config.blipIDJ)
                SetBlipDisplay(blipJ, 6)
                SetBlipScale(blipJ, Config.blipScaleJ)
                SetBlipColour(blipJ, Config.blipColorJ)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString("~y~Mc~r~Donalds ~y~Job ~r~Selection")
                EndTextCommandSetBlipName(blipJ)
            end
        end
        showingBlips = true
    else
        print(Config.Prefix.."Momenteel worden Blips = true weergegeven (Blips verwijderen)")
        deleteBlips()
    end
    print(Config.Prefix.."Wordt momenteel weergegeven "..mBlipsCreated.." 'M' Blips en "..jBlipsCreated.." '$' Blips gemaakt")
end

function displayMarker(coords)
            --Type  |X|         Y|      Z|      dX|  dY|  dZ| rX| rY|  rZ|  sX|  sY|  sZ|          R|                          G|                      B|                      A|            Animate|FC| P19|  rot|texDict|texName|ents
	DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false) 
end

function deliveryMarker(coords)
    DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
    DrawMarker(29, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
end

function deliveryDMarker(coords)
    DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.5, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
    DrawMarker(29, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
end

function destroyMarker(coords)
    DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 200, true, true, 2, false, false, false, false)
    DrawMarker(36, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.CarDespawnMarkerColor.r, Config.CarDespawnMarkerColor.g, Config.CarDespawnMarkerColor.b, Config.CarDespawnMarkerColor.a, true, true, 2, false, false, false, false)
end

--Select McDonalds Job
function openMenu()									
    menuIsOpen = true
    ESX.UI.Menu.CloseAll()										
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'JobList',			
        {
        title    = "McDoanalds Job List",	
        description = "Created by DefectGaming",
        elements = {
            {label = "Cashier", value = 'cashier'},		
            {label = "Cook", value = 'cook'},
            {label = "Delivery Driver", value = 'deliv'}
        }
    },
    function(data, menu)									
        if data.current.value == 'cashier' then			
            if currentJob == 'cashier' then
                exports.pNotify:SendNotification({text = "Je bent al een McDonalds-kassier!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                currentJob = 'cashier'
                --Change Job Grade Here
                exports.pNotify:SendNotification({text = "Je bent nu een McDonalds-kassier!", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                onDuty = true
                isDelivering = false
                invMeal = 0
                invBurger = 0
                invDrink = 0
                invFries = 0
                hasOrder = false
                hasTakenOrder = false
            end
        end
        if data.current.value == 'cook' then
            if currentJob == 'cook' then
                exports.pNotify:SendNotification({text = "Je bent al een McDonalds Cook!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                currentJob = 'cook'
                --Change Job Grade Here
                exports.pNotify:SendNotification({text = "Je bent nu een McDonalds Cook!", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                onDuty = true
                isDelivering = false
                invMeal = 0
                invBurger = 0
                invDrink = 0
                invFries = 0
                hasOrder = false
                hasTakenOrder = false
            end   
        end
        if data.current.value == 'deliv' then
            if currentJob == 'deliv' then
                exports.pNotify:SendNotification({text = "Je bent al een bezorger van McDonalds!", type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                currentJob = 'deliv'
                --Change Job Grade Here
                exports.pNotify:SendNotification({text = "U bent nu een bezorger van McDonalds!", type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                onDuty = true
                isDelivering = false
                invMeal = 0
                invBurger = 0
                invDrink = 0
                invFries = 0
                hasOrder = false
                hasTakenOrder = false
            end
        end
        menu.close()
	    menuIsOpen = false
    end,
        function(data, menu)
        menu.close()
	    menuIsOpen = false
    end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end