-- Config --
misTxtDis = "~g~Admin area is gemaakt door William, ~w~We doen niet RP in deze area"
blipRadius = 250.0
blipCol = 2
blipName = "Admin Area"

-- Code -- 
local blip = nil
local radiusBlip = nil

function missionTextDisplay(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")