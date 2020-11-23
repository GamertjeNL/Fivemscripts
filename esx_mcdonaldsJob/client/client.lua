ESX = nil

local currentPlayerJobName  = 'none'
local PlayerData = {}
local jobTitle = 'McDonalds'

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
        print("ESX.GetPlayerData().job = nil, wachten tot niet nul ..")
		Citizen.Wait(100)
	end

    if ESX.GetPlayerData().job.name ~= nil then
        print(Config.Prefix.."ESX.GetPlayerData().job.name ~= nil Jobnaam instellen")
        currentPlayerJobName = ESX.GetPlayerData().job.name
        print(Config.Prefix.."Job Name has been set to: "..currentPlayerJobName)
    else
        print(Config.Prefix.."^1ESX.GetPlayerData().job.name == nil Kan taaknaam niet instellen!")
    end

	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

local isInMarker = false
local menuIsOpen = false
local vehcileMenuIsOpen = false
local hintToDisplay = _U('NoHintError')
local displayHint = false
local currentZone = 'none'
local currentJob = 'none'
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

local blipM
local blipJ

local playerBusy = false

local hasStartedBlips = false

local mealInvent = 0

--Press [E] Buttons
Citizen.CreateThread(function()
	while true do																
		Citizen.Wait(2)					
		if not menuIsOpen then
			local playerCoords = GetEntityCoords(GetPlayerPed(-1))
            if currentPlayerJobName ~= nil and currentPlayerJobName == 'McDonalds' and playerBusy == false then														
			    if  playerIsInside(playerCoords, Config.JobMenuCoords, Config.JobMarkerDistance) then 				
			        isInMarker = true
			        displayHint = true																
			        hintToDisplay = _U('JobListMarker')									
			        currentZone = 'JobList'	
                elseif  playerIsInside(playerCoords, Config.CookBurgerCoords, Config.JobMarkerDistance) and currentJob == 'cook' and invBurger <= 1 then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('CookBurger')									
			    	currentZone = 'Burger'																
			    elseif  playerIsInside(playerCoords, Config.CookFriesCoords, Config.JobMarkerDistance) and currentJob == 'cook' and invFries <= 1 then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('CookFries')									
			    	currentZone = 'Fries'																
			    elseif  playerIsInside(playerCoords, Config.CookDrinkCoords, Config.JobMarkerDistance) and currentJob == 'cook' and invDrink <= 1 then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('GetDrink')									
			    	currentZone = 'Drink'																
			    elseif  playerIsInside(playerCoords, Config.CookPrepareCoords, Config.JobMarkerDistance) and currentJob == 'cook' and invBurger >= 1 and invDrink >= 1 and invFries >= 1 then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('MakeMeal')									
			    	currentZone = 'Prepare'		    
			    elseif  playerIsInside(playerCoords, Config.CashTakeOrder, Config.JobMarkerDistance) and currentJob == 'cashier' and hasTakenOrder == false then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('TakeOrder')									
			    	currentZone = 'cOrder'	
                elseif  playerIsInside(playerCoords, Config.CashTakeOrder1, Config.JobMarkerDistance) and currentJob == 'cashier' and hasTakenOrder == false then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('TakeOrder')									
			    	currentZone = 'cOrder'
                elseif  playerIsInside(playerCoords, Config.CashTakeOrder2, Config.JobMarkerDistance) and currentJob == 'cashier' and hasTakenOrder == false then 				
                    isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('TakeOrder')									
			    	currentZone = 'cOrder'
			    elseif  playerIsInside(playerCoords, Config.CashCollectMeal, Config.JobMarkerDistance) and currentJob == 'cashier' and hasOrder == false and hasTakenOrder == true then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('GrabOrder')								
			    	currentZone = 'cCollect'	
                elseif  deliveryCoords ~= nil and playerIsInside(playerCoords, deliveryCoords, Config.JobExtendedDistance) and currentJob == 'cashier' and isDelivering then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('GiveOrder')									
			    	currentZone = 'cDeliver'
                elseif  playerIsInside(playerCoords, Config.CashCollectMeal, Config.JobMarkerDistance) and currentJob == 'deliv' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('TakeDeliv')									
			    	currentZone = 'dCollect'
                elseif  dDeliveryCoords ~= nil and playerIsInside(playerCoords, dDeliveryCoords, Config.JobExtendedDistance) and currentJob == 'deliv' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('GiveDeliv')									
			    	currentZone = 'dDeliver'
                elseif  dDeliveryCoords == nil and currentJob == 'deliv' and dHasOrder then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('DelivError')								
			    	currentZone = 'dDeliver'
                elseif  playerIsInside(playerCoords, Config.DeliveryCarSpawnMarker, Config.JobMarkerDistance) and currentJob == 'deliv' then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('GetCar')									
			    	currentZone = 'dCarSpawn'
                elseif  playerIsInside(playerCoords, Config.DeliveryCarDespawn, Config.JobExtendedDistance) and currentJob == 'deliv' and driverHasCar then 				
			    	isInMarker = true
			    	displayHint = true																
			    	hintToDisplay = _U('ReturnCar')									
			    	currentZone = 'dCarDespawn'
                else
			    	isInMarker = false
			    	displayHint = false
			    	hintToDisplay = _U('NoHintError')
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
    if currentPlayerJobName ~= 'none' then
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
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)		
    playerData = xPlayer
    currentPlayerData = xPlayer
    if Config == nil then
        print(Config.Prefix.."Kon Config niet laden")
    else
        if Config.EnableBlips == true then
            while currentPlayerData.job == jobTitle and jBlipsCreated == 0 do
                refreshBlips()
                Citizen.Wait(100)
            end
        end
    end								
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    currentPlayerJobName = job.name
    if job.name == jobTitle then 
        onDuty = true
    else
        onDuty = false
    end
    refreshBlips()						
end)
--Hint to Display
Citizen.CreateThread(function()
    while true do										
    Citizen.Wait(1)
        if displayHint and playerBusy == false then							
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
        if not playerBusy then
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
                        print(Config.Prefix.."^2dDeliveryCoords zijn NIL! Kan geen markering maken!")
                    end
                end
                displayMarker(Config.DeliveryCarSpawnMarker)
                if driverHasCar == true then
                    destroyMarker(Config.DeliveryCarDespawn)
                end
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
        exports.pNotify:SendNotification({text = _U('BurgerError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        --Alerts | alert | notice | info | success | error 
        playerIsBusy(true)
        startAnim("misscarsteal2fixer", "confused_a")
        exports.pNotify:SendNotification({text = _U('BurgerNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CookBurgerTime, _U('BurgerBar'))
        Citizen.Wait(Config.CookBurgerTime)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_burger')
        exports.pNotify:SendNotification({text = _U('BurgerNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invBurger = invBurger + 1
        playerIsBusy(false)
    end
end

function getFries()
    if invFries >= 2 then
        exports.pNotify:SendNotification({text = _U('FriesError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        playerIsBusy(true)
        --Alerts | alert | notice | info | success | error 
        startAnim("mp_common", "givetake1_a")
        exports.pNotify:SendNotification({text = _U('FriesNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CookFriesTime, _('FriesBar'))
        Citizen.Wait(Config.CookFriesTime)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_fries')
        exports.pNotify:SendNotification({text = _U('FriesNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invFries = invFries + 1
        playerIsBusy(false)
    end
end

function getDrink()
    if invDrink >= 2 then
        exports.pNotify:SendNotification({text = _U('DrinkError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        playerIsBusy(true)
        --Alerts | alert | notice | info | success | error 
        startAnim("mp_common", "givetake1_a")
        exports.pNotify:SendNotification({text = _U('DrinkNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CookDrinkTime, _U('DrinkBar'))
        Citizen.Wait(Config.CookDrinkTime)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_drink')
        exports.pNotify:SendNotification({text = _U('DrinkNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
        invDrink = invDrink + 1
        playerIsBusy(false)
    end
end

RegisterNetEvent("dgrp_mcdonalds:setInvent")
AddEventHandler("dgrp_mcdonalds:setInvent", function(amount)
    mealInvent = amount
end)

function prepareMeal()
    if Config.EnableMealInventory == true then
        if invBurger > 0 and invDrink > 0 and invFries > 0 then
            --Alerts | alert | notice | info | success | error 
            playerIsBusy(true)
            startAnim("misscarsteal2fixer", "confused_a")
            exports.pNotify:SendNotification({text = _U('MealNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CookPrepareTime, _U('MealBar'))
            Citizen.Wait(Config.CookPrepareTime)
            ClearPedTasks(PlayerPedId())
            exports.pNotify:SendNotification({text = _U('MealNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invBurger = invBurger - 1
            invDrink = invDrink - 1
            invFries = invFries - 1
            mealsMade = mealsMade + 1
            TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_burger')
            TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_drink')
            TriggerServerEvent("dgrp_mcdonalds:removeItem", 'mcdonalds_fries')
            TriggerServerEvent("dgrp_mcdonalds:addToMealInvent")
            if Config.EnableMoreWorkMorePay == true then
                bonus = 1 * mealsMade
                payBonus = Config.CashJobPay * bonus
                TriggerServerEvent("dgrp_mcdonalds:getPaid", payBonus)
                if mealsMade > 1 then
                    ESX.ShowNotification('~b~Je hebt een ~g~bonus~b~ ontvangen voor opeenvolgend werk. ga zo door! Bonus: ~g~x'..bonus)
                end
                ESX.ShowNotification('~b~Je bent betaald ~g~+$'..payBonus..'~b~.')
            else
                TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.CookJobPay)
                ESX.ShowNotification('~b~Je bent betaald ~g~+$'..Config.CookJobPay..'~b~.')
            end
            playerIsBusy(false)
        else
            exports.pNotify:SendNotification({text = _U('MealError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports.pNotify:SendNotification({text = "Je hebt momenteel x"..invBurger.." Fresh Burger(s), x"..invDrink.." Fresh Drink(s) and x"..invFries.." Fresh Fries", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    else
        if invBurger > 0 and invDrink > 0 and invFries > 0 then
            --Alerts | alert | notice | info | success | error 
            playerIsBusy(true)
            startAnim("misscarsteal2fixer", "confused_a")
            exports.pNotify:SendNotification({text = _U('MealNotifStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CookPrepareTime, _U('MealBar'))
            Citizen.Wait(Config.CookPrepareTime)
            ClearPedTasks(PlayerPedId())
            exports.pNotify:SendNotification({text = _U('MealNotifFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
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
                    ESX.ShowNotification('~b~Je hebt een ~g~bonus~b~ ontvangen voor opeenvolgend werk. ga zo door! Bonus: ~g~x'..bonus)
                end
                ESX.ShowNotification('~b~Je bent betaald ~g~+$'..payBonus..'~b~.')
            else
                TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.CookJobPay)
                ESX.ShowNotification('~b~Je bent betaald ~g~+$'..Config.CookJobPay..'~b~.')
            end
            playerIsBusy(false)
        else
            exports.pNotify:SendNotification({text = _U('MealError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports.pNotify:SendNotification({text = "Je hebt momenteel x"..invBurger.." Fresh Burger(s), x"..invDrink.." Fresh Drink(s) and x"..invFries.." Fresh Fries", type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end
end

function takeOrder()
    if hasTakenOrder == false then
        --Alerts | alert | notice | info | success | error 
        playerIsBusy(true)
        exports.pNotify:SendNotification({text = _U('CashStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        exports['progressBars']:startUI(Config.CashOrderTime, _U('CashBar'))
        startAnim("mp_common", "givetake1_a")
        local tempTime = Config.CashOrderTime / 2
        Citizen.Wait(tempTime)
        ClearPedTasks(PlayerPedId())
        startAnim("mp_take_money_mg", "stand_cash_in_bag_loop")
        Citizen.Wait(tempTime)
        ClearPedTasks(PlayerPedId())
        exports.pNotify:SendNotification({text = _U('CashFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})        
        hasTakenOrder = true
        playerIsBusy(false)
    else
        exports.pNotify:SendNotification({text = _U('CashError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})       
    end    
end

function pickupOrder()
    if Config.EnableMealInventory == true then
        if hasOrder == false and hasTakenOrder == true then
            if mealInvent > 0 then
                TriggerServerEvent("dgrp_mcdonalds:removeFromMealInvent")
                playerIsBusy(true)
                exports.pNotify:SendNotification({text = _U('PickupStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                exports['progressBars']:startUI(Config.CashMealTime, _U('PickupBar'))
                startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
                Citizen.Wait(4000)
                ClearPedTasks(PlayerPedId())
                startAnim("misscarsteal2fixer", "confused_a")
                Citizen.Wait(Config.CashMealTime - 4000)
                ClearPedTasks(PlayerPedId())
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
                exports.pNotify:SendNotification({text = _U('PickupFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
                invMeal = invMeal + 1
                hasOrder = true
                setDelivery()
                playerIsBusy(false)
            else
                exports.pNotify:SendNotification({text = _U('PickupError3'), type = "error", timeout = 5000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        elseif hasOrder == true and hasTakenOrder == true then
            exports.pNotify:SendNotification({text = _U('PickupError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        elseif hasTakenOrder == false and hasOrder == false then
            exports.pNotify:SendNotification({text = _U('PickupError1'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            exports.pNotify:SendNotification({text = _U('PickupError2'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    else
        if hasOrder == false and hasTakenOrder == true then
            playerIsBusy(true)
            exports.pNotify:SendNotification({text = _U('PickupStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CashMealTime, _U('PickupBar'))
            startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
            Citizen.Wait(4000)
            ClearPedTasks(PlayerPedId())
            startAnim("misscarsteal2fixer", "confused_a")
            Citizen.Wait(Config.CashMealTime - 4000)
            ClearPedTasks(PlayerPedId())
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
            exports.pNotify:SendNotification({text = _U('PickupFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invMeal = invMeal + 1
            hasOrder = true
            setDelivery()
            playerIsBusy(false)
        elseif hasOrder == true and hasTakenOrder == true then
            exports.pNotify:SendNotification({text = _U('PickupError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        elseif hasTakenOrder == false and hasOrder == false then
            exports.pNotify:SendNotification({text = _U('PickupError1'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            exports.pNotify:SendNotification({text = _U('PickupError2'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end
end

function setDelivery()
    repeat
    deliveryPoint = math.random(1, #Config.cashDeliveryPoints)
	until deliveryPoint ~= lastDelivery
	deliveryCoords = Config.cashDeliveryPoints[deliveryPoint]
  	taskPoints['delivery'] = { x = deliveryCoords.x, y = deliveryCoords.y, z = deliveryCoords.z}
	lastDelivery = deliveryPoint
    isDelivering = true
    setGPS(deliveryCoords)
    exports.pNotify:SendNotification({text = _U('Table')..deliveryPoint, type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end

function deliverOrder()
    playerIsBusy(true)
    local tempTime = Config.CashDelivTime / 2
    exports.pNotify:SendNotification({text = _U('GiveStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    exports['progressBars']:startUI(Config.CashDelivTime, _U('GiveBar'))
    startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
    Citizen.Wait(tempTime)
    ClearPedTasks(PlayerPedId())
    startAnim("mp_common", "givetake1_a")
    Citizen.Wait(tempTime)
    ClearPedTasks(PlayerPedId())
    exports.pNotify:SendNotification({text = _U('GiveFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
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
    playerIsBusy(false)
    hasOrder = false
    hasTakenOrder = false
    isDelivering = false
    deliveryCoords = nil
end

function pickupDelivery()
    if Config.EnableMealInventory == true then
        if mealInvent > 0 then
            if dHasOrder == false then
                TriggerServerEvent("dgrp_mcdonalds:removeFromMealInvent")
                playerIsBusy(true)
                startAnim("misscarsteal2fixer", "confused_a")
                exports.pNotify:SendNotification({text = _U('PickupStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                exports['progressBars']:startUI(Config.CashMealTime, "Collecting McDonalds Order")
                Citizen.Wait(Config.CashMealTime)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
                exports.pNotify:SendNotification({text = _U('PickupFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
                invMeal = invMeal + 1
                dHasOrder = true
                setDriveDelivery()
                playerIsBusy(false)
            elseif dHasOrder == true then
                exports.pNotify:SendNotification({text = _U('PickupError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                exports.pNotify:SendNotification({text = _U('PickupError2'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        else
            exports.pNotify:SendNotification({text = _U('PickupError3'), type = "error", timeout = 5000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    else
        if dHasOrder == false then
            playerIsBusy(true)
            startAnim("misscarsteal2fixer", "confused_a")
            exports.pNotify:SendNotification({text = _U('PickupStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            exports['progressBars']:startUI(Config.CashMealTime, "Collecting McDonalds Order")
            Citizen.Wait(Config.CashMealTime)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("dgrp_mcdonalds:addItem", 'mcdonalds_meal')
            exports.pNotify:SendNotification({text = _U('PickupFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
            invMeal = invMeal + 1
            dHasOrder = true
            setDriveDelivery()
            playerIsBusy(false)
        elseif dHasOrder == true then
            exports.pNotify:SendNotification({text = _U('PickupError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            exports.pNotify:SendNotification({text = _U('PickupError2'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end
end

function setDriveDelivery()
    repeat
    deliveryPoint = math.random(1, #Config.driveDeliveryPoints)
	until deliveryPoint ~= lastDelivery
	dDeliveryCoords = Config.driveDeliveryPoints[deliveryPoint]
	lastDelivery = deliveryPoint
    isDriveDelivering = true
    setGPS(dDeliveryCoords)
    exports.pNotify:SendNotification({text = _U('DelivNotif'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end

function isMyCar()
	return currentPlate == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function openWorkVehicleMenu()
    if driverHasCar == true then
        replaceLostCar(true)
        exports.pNotify:SendNotification({text = _U('CarError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        openVehicleMenu()
        exports.pNotify:SendNotification({text = _U('CarChoose'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function replaceLostCar(bool)
    if bool == true then
        ESX.Game.DeleteVehicle(currentCar)			
        driverHasCar = false
        exports.pNotify:SendNotification({text = _U('CarError1'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        ESX.UI.CloseAll()
    end
end

function openVehicleMenu()
    vehicleMenuIsOpen = true
    playerIsBusy(true)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'VehicleList',			
        {
        title    = _U('CarTitle'),	
        elements = {
            {label = _U('CarVan')..Config.VanDepositAmount, value = 'van'},		
            {label = _U('CarBike')..Config.BikeDepositAmount, value = 'bike'}
        }
    },
    function(data, menu)									
        if data.current.value == 'van' then	
            menu.close()
	        vehicleMenuIsOpen = false
            playerIsBusy(false)
            spawnVehicle(Config.CarToSpawn, Config.VanDepositAmount)  
            if Config.PayDeposit == true then
                exports.pNotify:SendNotification({text = _U('DepositNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                paidDeposit = Config.VanDepositAmount
            else
                exports.pNotify:SendNotification({text = _U('SpawnedNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            end

        end
        if data.current.value == 'bike' then
            menu.close()
	        vehicleMenuIsOpen = false
            playerIsBusy(false)
            spawnVehicle(Config.BikeToSpawn, Config.BikeDepositAmount)  
            if Config.PayDeposit == true then
                exports.pNotify:SendNotification({text = _U('DepositNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
                paidDeposit = Config.BikeDepositAmount
            else
                exports.pNotify:SendNotification({text = _U('SpawnedNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            end
        end
        menu.close()
	    vehicleMenuIsOpen = false
        playerIsBusy(false)
    end,
        function(data, menu)
        menu.close()
	    vehicleMenuIsOpen = false
        playerIsBusy(false)
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
        exports.pNotify:SendNotification({text = _U('DespawnedNotif'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    else
        exports.pNotify:SendNotification({text = _U('ReturnError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
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
    exports.pNotify:SendNotification({text = _U('GiveStart'), type = "info", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    exports['progressBars']:startUI(Config.CashDelivTime, _U('GiveBar'))
    FreezeEntityPosition(playerPed, true)
    Citizen.Wait(Config.CashDelivTime)
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(PlayerPedId())
    exports.pNotify:SendNotification({text = _U('GiveFinish'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})    
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
        ESX.ShowNotification('~b~Je bent betaald~g~+$'..payBonus..'~b~.')
    else
        TriggerServerEvent("dgrp_mcdonalds:getPaid", Config.DelivJobPay)
        ESX.ShowNotification('~b~Je bent betaald ~g~+$'..Config.DelivJobPay..'~b~.')
    end

    dHasOrder = false
    isDriveDelivering = false
    dDeliveryCoords = nil
end

function deleteBlips()
    RemoveBlip(blipM)
    RemoveBlip(blipJ)
    showingBlips = false
    if Config.EnableBlips == true and showingBlips == false then
        refreshBlips()
    elseif showingBlips == false and Config.EnableBlips == false then
        deleteBlips()
    end
end

function refreshBlips()
    if showingBlips == false then
        blipM = AddBlipForCoord(Config.blipLocationM.x, Config.blipLocationM.y)
        SetBlipSprite(blipM, Config.blipIDM)
        SetBlipDisplay(blipM, 6)
        SetBlipScale(blipM, Config.blipScaleM)
        SetBlipColour(blipM, Config.blipColorM)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(_U('McDonaldsBlip'))
        EndTextCommandSetBlipName(blipM)
        if currentPlayerJobName ~= nil then
            if currentPlayerJobName == jobTitle and Config.EnableJobBlip == false then
                blipJ = AddBlipForCoord(Config.blipLocationJ.x, Config.blipLocationJ.y)
                SetBlipSprite(blipJ, Config.blipIDJ)
                SetBlipDisplay(blipJ, 6)
                SetBlipScale(blipJ, Config.blipScaleJ)
                SetBlipColour(blipJ, Config.blipColorJ)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(_U('McDonaldsJobBlip'))
                EndTextCommandSetBlipName(blipJ)
            elseif Config.EnableJobBlip == true then
                local blipJ = AddBlipForCoord(Config.blipLocationJ.x, Config.blipLocationJ.y)
                mBlipsCreated = mBlipsCreated + 1
                SetBlipSprite(blipJ, Config.blipIDJ)
                SetBlipDisplay(blipJ, 6)
                SetBlipScale(blipJ, Config.blipScaleJ)
                SetBlipColour(blipJ, Config.blipColorJ)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(_U('McDonaldsJobBlip'))
                EndTextCommandSetBlipName(blipJ)
            end
        end
        showingBlips = true
    else
        deleteBlips()
    end
end

function playerIsBusy(bool)
    if bool == true then
        FreezeEntityPosition(playerPed, true)
        playerBusy = true
    else
        FreezeEntityPosition(playerPed, false)
        playerBusy = false
    end
end

function displayMarker(coords)
    if playerBusy == false then
        DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false) 
    end
end

function deliveryMarker(coords)
    if playerBusy == false then
        DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
        DrawMarker(29, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
    end
end

function deliveryDMarker(coords)
    if playerBusy == false then
        DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.5, Config.JobMarkerColor.r, Config.JobMarkerColor.g, Config.JobMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
        DrawMarker(29, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.JobMarkerColor.a, true, true, 2, false, false, false, false)
    end
end

function destroyMarker(coords)
    if playerBusy == false then
        DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 200, true, true, 2, false, false, false, false)
        DrawMarker(36, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.CarDespawnMarkerColor.r, Config.CarDespawnMarkerColor.g, Config.CarDespawnMarkerColor.b, Config.CarDespawnMarkerColor.a, true, true, 2, false, false, false, false)
    end
end

--Select McDonalds Job
function openMenu()									
    menuIsOpen = true
    playerIsBusy(true)
    ESX.UI.Menu.CloseAll()										
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'JobList',			
        {
        title    = _U('ListingTitle'),	
        description = "Created by DefectGaming's FuryFight3r",
        elements = {
            {label = _U('Cashier'), value = 'cashier'},		
            {label = _U('Cook'), value = 'cook'},
            {label = _U('Deliv'), value = 'deliv'}
        }
    },
    function(data, menu)									
        if data.current.value == 'cashier' then			
            if currentJob == 'cashier' then
                exports.pNotify:SendNotification({text = _U('CashierError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                currentJob = 'cashier'
                --Change Job Grade Here
                exports.pNotify:SendNotification({text = _U('CashierSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
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
                exports.pNotify:SendNotification({text = _U('CookError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                currentJob = 'cook'
                --Change Job Grade Here
                exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
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
                exports.pNotify:SendNotification({text = _U('DriverError'), type = "error", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                currentJob = 'deliv'
                --Change Job Grade Here
                exports.pNotify:SendNotification({text = _U('DriverSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
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
        playerIsBusy(false)
    end,
        function(data, menu)
        menu.close()
	    menuIsOpen = false
        playerIsBusy(false)
    end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

Citizen.CreateThread(function()
    if Config.EnableStuckCommand == true then
        RegisterCommand("mcstuck", function()
            playerIsBusy(false)
        end)
    end

    if Config.EnableCookCommand == true then
        RegisterCommand("mccook", function()
            currentJob = 'cook'
            --Change Job Grade Here
            exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            onDuty = true
            isDelivering = false
            invMeal = 0
            invBurger = 0
            invDrink = 0
            invFries = 0
            hasOrder = false
            hasTakenOrder = false
        end)
    end

    if Config.EnableCashCommand == true then
        RegisterCommand("mccash", function()
            currentJob = 'cashier'
            --Change Job Grade Here
            exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            onDuty = true
            isDelivering = false
            invMeal = 0
            invBurger = 0
            invDrink = 0
            invFries = 0
            hasOrder = false
            hasTakenOrder = false
        end)
    end

    if Config.EnableDelivCommand == true then
        RegisterCommand("mcdeliv", function()
            currentJob = 'deliv'
            --Change Job Grade Here
            exports.pNotify:SendNotification({text = _U('CookSuccess'), type = "success", timeout = 2000, layout = "centerLeft", queue = "left", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}}) 
            onDuty = true
            isDelivering = false
            invMeal = 0
            invBurger = 0
            invDrink = 0
            invFries = 0
            hasOrder = false
            hasTakenOrder = false
        end)
    end

end)

--Testing Commands

RegisterCommand("order", function()
    Citizen.CreateThread(function()
        takeOrder()
        TriggerEvent("chat:addMessage", {args={Config.Prefix.."Maaltijd bestellen"}}) 
    end)
end)

RegisterCommand("addMeal", function()
    Citizen.CreateThread(function()
        TriggerServerEvent("dgrp_mcdonalds:addToMealInvent")
        TriggerEvent("chat:addMessage", {args={Config.Prefix.."Maaltijd toevoegen aan Kitchen Invetory"}}) 
    end)
end)

function dPrint(msg)
    print(""..Config.Prefix..""..msg..".")
end