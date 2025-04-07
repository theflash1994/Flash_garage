ESX = exports.es_extended:getSharedObject()
local garageNPCs = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

OpenGarageMenu = function()
    local currentGarage = cachedData["currentGarage"]

    if not currentGarage then return end

    HandleCamera(currentGarage, true)

    ESX.TriggerServerCallback("garage:fetchPlayerVehicles", function(fetchedVehicles)
        local menuElements = {}
        local impound = ''

        ESX.TriggerServerCallback("garage:fetchJob2Vehicles", function(fetchedVehicles2)
            for key, vehicleData in ipairs(fetchedVehicles2) do
                local vehicleProps = vehicleData["props"]
                
                if vehicleData['pound'] then
                    impound = ' | FAZIONE | SEQUESTRATO'
                else
                    impound = ' | FAZIONE'
                end
    
                table.insert(menuElements, {
                    ["label"] = " Targa: " .. vehicleData["plate"] .. " | " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleData.props.model)) .. " " .. impound,
                    ["vehicle"] = vehicleData
                })
            end
    ------------------------------------------------------------------------------------------------
            for key, vehicleData in ipairs(fetchedVehicles) do
                local vehicleProps = vehicleData["props"]
                
                if vehicleData['pound'] then
                    impound = ' | SEQUESTRATO'
                else
                    impound = ''
                end

                table.insert(menuElements, {
                    ["label"] = " Targa: " .. vehicleData["plate"] .. " | " .. GetLabelText(GetDisplayNameFromVehicleModel(vehicleData.props.model)) .. " " .. impound,
                    ["vehicle"] = vehicleData
                })
            end

            if #menuElements == 0 then
                table.insert(menuElements, {
                    ["label"] = "Nessun veicolo in questo Garage"
                })
            elseif #menuElements > 0 then
                SpawnLocalVehicle(menuElements[1]["vehicle"]["props"], currentGarage)
            end

            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_garage_menu", {
                ["title"] = "Garage - " .. currentGarage,
                ["align"] = GarageCFG.AlignMenu,
                ["elements"] = menuElements
            }, function(menuData, menuHandle)
                local currentVehicle = menuData.current.vehicle

                if currentVehicle then
                    menuHandle.close()

                    if DoesEntityExist(cachedData["vehicle"]) then
                        DeleteEntity(cachedData["vehicle"])
                        Citizen.Wait(50)
                    end
                    
                    local fuori = false
                    for veh in EnumerateVehicles() do
                        if veh == -1 then
                            fuori = false
                        else
                            if ESX.Game.GetVehicleProperties(veh).plate == currentVehicle.plate then    
                                local vehCoords, pCoords = GetEntityCoords(veh), GetEntityCoords(PlayerPedId())
                                -- print(ESX.Game.GetVehicleProperties(veh).plate.. ' - '.. GetDistanceBetweenCoords(vehCoords, pCoords, true) ..' Metri')
                                fuori = true
                            end
                        end
                    end
                    if fuori == true then
                        HandleCamera(currentGarage, false)
                        ESX.ShowNotification("Il veicolo è già fuori")
                    elseif not currentVehicle.pound then
                        local spawnpoint = GarageCFG.Garages[cachedData["currentGarage"]]["positions"]["vehicle"]
                        if not ESX.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
                            HandleCamera(currentGarage, false)
                            ESX.ShowNotification("Sposta il veicolo che occupa l\'uscita del veicolo.")
                        else
                            SpawnVehicle(currentVehicle.props)
                        end
                    else
                        HandleCamera(currentGarage, false)
                        ESX.ShowNotification("Il Veicolo è sequestrato")
                    end 

                end
            end, function(menuData, menuHandle)
                HandleCamera(currentGarage, false)

                menuHandle.close()
            end, function(menuData, menuHandle)
                local currentVehicle = menuData["current"]["vehicle"]

                if currentVehicle and not currentVehicle['pound'] then
                    SpawnLocalVehicle(currentVehicle["props"])
                else
                    DeleteEntity(cachedData["vehicle"])
                end
            end)
        end, currentGarage, ESX.PlayerData.job.name)
    end, currentGarage)
end

SpawnVehicle = function(vehicleProps)
    local spawnpoint = GarageCFG.Garages[cachedData["currentGarage"]]["positions"]["vehicle"]
    
    -- Controlla se il veicolo è già fuori
    local plate = vehicleProps["plate"]
    local isVehicleOut = false
    
    -- Normalizza la targa per il confronto (rimuovi spazi, converti in maiuscolo)
    local normalizedPlate = string.gsub(plate, "%s", ""):upper()
    
    -- Cerca tra tutti i veicoli nel mondo
    for veh in EnumerateVehicles() do
        if DoesEntityExist(veh) then
            -- Ottieni la targa del veicolo e normalizzala
            local vehPlate = GetVehicleNumberPlateText(veh)
            if vehPlate then
                vehPlate = string.gsub(vehPlate, "%s", ""):upper()
                
                -- Confronta le targhe
                if vehPlate == normalizedPlate then
                    isVehicleOut = true
                    local vehCoords = GetEntityCoords(veh)
                    
                    -- Imposta un waypoint alla posizione del veicolo
                    SetNewWaypoint(vehCoords.x, vehCoords.y)
                    
                    -- Mostra notifica e interrompi la funzione
                    ESX.ShowNotification("Il veicolo è già fuori. Un waypoint è stato impostato sulla mappa.")
                    
                    -- Chiudi l'interfaccia e la camera
                    HandleCamera(cachedData["currentGarage"], false)
                    SetNuiFocus(false, false)
                    SendNUIMessage({
                        type = "close"
                    })
                    
                    return
                end
            end
        end
    end
    
    -- Se il veicolo non è fuori, continua con lo spawn
    WaitForModel(vehicleProps["model"])
    
    -- Rimuovi il veicolo locale se esiste
    if DoesEntityExist(cachedData["vehicle"]) then
        DeleteEntity(cachedData["vehicle"])
        cachedData["vehicle"] = nil
    end
    
    -- Verifica che il punto di spawn sia libero
    if not ESX.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
        ESX.ShowNotification("Sposta il veicolo che occupa l\'uscita del veicolo.")
        HandleCamera(cachedData["currentGarage"], false)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "close"
        })
        return
    end
    
    -- Verifica che il modello sia valido
    if not IsModelValid(vehicleProps["model"]) then
        ESX.ShowNotification("Modello del veicolo non valido.")
        HandleCamera(cachedData["currentGarage"], false)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "close"
        })
        return
    end
    
    -- Spawn del veicolo con gestione degli errori
    local success, errorMsg = pcall(function()
        ESX.Game.SpawnVehicle(vehicleProps["model"], spawnpoint["position"], spawnpoint["heading"], function(yourVehicle)
            if DoesEntityExist(yourVehicle) then
                SetVehicleProperties(yourVehicle, vehicleProps)
                NetworkFadeInEntity(yourVehicle, true, true)
                SetModelAsNoLongerNeeded(vehicleProps["model"])
                TriggerServerEvent('mlmloggr', vehicleProps.plate)
                TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)
                SetEntityAsMissionEntity(yourVehicle, true, true)
            else
                ESX.ShowNotification("Errore durante lo spawn del veicolo.")
            end
            
            HandleCamera(cachedData["currentGarage"], false)
            SetNuiFocus(false, false)
            
            SendNUIMessage({
                type = "close"
            })
        end)
    end)
    
    -- Gestione degli errori durante lo spawn
    if not success then
        print("^1Errore durante lo spawn del veicolo: " .. tostring(errorMsg) .. "^7")
        ESX.ShowNotification("Si è verificato un errore durante lo spawn del veicolo.")
        HandleCamera(cachedData["currentGarage"], false)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "close"
        })
    end
end

SpawnLocalVehicle = function(vehicleProps, garage)
    local spawnpoint = GarageCFG.Garages[garage or cachedData["currentGarage"]]["positions"]["vehicle"]

    WaitForModel(vehicleProps["model"])

    if DoesEntityExist(cachedData["vehicle"]) then
        DeleteEntity(cachedData["vehicle"])
    end
    
    if not ESX.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
        ESX.ShowNotification("Sposta il veicolo che occupa l\'uscita del veicolo.")
        return
    end
    
    if not IsModelValid(vehicleProps["model"]) then
        return
    end

    ESX.Game.SpawnLocalVehicle(vehicleProps["model"], spawnpoint["position"], spawnpoint["heading"], function(yourVehicle)
        if DoesEntityExist(yourVehicle) then
            cachedData["vehicle"] = yourVehicle
            SetVehicleProperties(yourVehicle, vehicleProps)
            SetModelAsNoLongerNeeded(vehicleProps["model"])
        end
    end)
end


PutInVehicle = function()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())

	if DoesEntityExist(vehicle) then
		local vehicleProps = GetVehicleProperties(vehicle)

		ESX.TriggerServerCallback("garage:validateVehicle", function(valid)
			if valid then
				ESX.Game.DeleteVehicle(vehicle)
                TriggerServerEvent('mlmloggr2', vehicleProps.plate)
			else
				ESX.ShowNotification("Non sei il proprietario di questo veicolo")
			end

		end, vehicleProps, cachedData["currentGarage"])
	end
end

SetVehicleProperties = function(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

    if vehicleProps["colore1r"] then
        SetVehicleCustomPrimaryColour(vehicle, vehicleProps["colore1r"], vehicleProps["colore1g"], vehicleProps["colore1b"])
    end
    if vehicleProps["colore2r"] then
        SetVehicleCustomSecondaryColour(vehicle, vehicleProps["colore2r"], vehicleProps["colore2g"], vehicleProps["colore2b"])
    end

    SetVehicleLivery(vehicle, vehicleProps["livrea"])
    SetVehicleMod(vehicle, 48, vehicleProps["livrea2"], false)

    SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
    
    -- Gestione del carburante con controllo degli errori
    local fuelLevel = vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 100.0
    
    -- Usa un approccio più sicuro con pcall per evitare errori
    local fuelSet = false
    
    if GetResourceState('LegacyFuel') == 'started' then
        -- Prova a usare LegacyFuel
        local success = pcall(function()
            exports['LegacyFuel']:SetFuel(vehicle, fuelLevel)
        end)
        fuelSet = success
    end
    
    if not fuelSet and GetResourceState('ox_fuel') == 'started' then
        -- Prova a usare ox_fuel
        local success = pcall(function()
            exports['ox_fuel']:SetFuel(vehicle, fuelLevel)
        end)
        fuelSet = success
    end
    
    if not fuelSet and GetResourceState('ps-fuel') == 'started' then
        -- Prova a usare ps-fuel
        local success = pcall(function()
            exports['ps-fuel']:SetFuel(vehicle, fuelLevel)
        end)
        fuelSet = success
    end
    
    -- Se nessun sistema di carburante è stato utilizzato con successo, usa il sistema nativo
    if not fuelSet then
        SetVehicleFuelLevel(vehicle, fuelLevel)
    end

    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end

        for id = 1, 13 do
            local windowId = IsVehicleWindowIntact(vehicle, id)

            if windowId ~= nil then
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
            end
        end
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end

        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        
        -- Gestione del carburante con controllo degli errori
        local fuelLevel = 100.0 -- Valore predefinito
        local fuelFound = false
        
        -- Usa un approccio più sicuro con pcall per evitare errori
        if GetResourceState('LegacyFuel') == 'started' then
            -- Prova a usare LegacyFuel
            local success, result = pcall(function()
                return exports['LegacyFuel']:GetFuel(vehicle)
            end)
            if success then
                fuelLevel = result
                fuelFound = true
            end
        end
        
        if not fuelFound and GetResourceState('ox_fuel') == 'started' then
            -- Prova a usare ox_fuel
            local success, result = pcall(function()
                return exports['ox_fuel']:GetFuel(vehicle)
            end)
            if success then
                fuelLevel = result
                fuelFound = true
            end
        end
        
        if not fuelFound and GetResourceState('ps-fuel') == 'started' then
            -- Prova a usare ps-fuel
            local success, result = pcall(function()
                return exports['ps-fuel']:GetFuel(vehicle)
            end)
            if success then
                fuelLevel = result
                fuelFound = true
            end
        end
        
        -- Se nessun sistema di carburante è stato utilizzato con successo, usa il sistema nativo
        if not fuelFound then
            fuelLevel = GetVehicleFuelLevel(vehicle)
        end
        
        vehicleProps["fuelLevel"] = fuelLevel

        local r1,g1,b1 = GetVehicleCustomPrimaryColour(vehicle)
        vehicleProps["colore1r"] = r1
        vehicleProps["colore1g"] = g1
        vehicleProps["colore1b"] = b1

        local r2,g2,b2 = GetVehicleCustomSecondaryColour(vehicle)
        vehicleProps["colore2r"] = r2
        vehicleProps["colore2g"] = g2
        vehicleProps["colore2b"] = b2

        vehicleProps["livrea"] = GetVehicleLivery(vehicle)
        vehicleProps["livrea2"] = GetVehicleMod(vehicle, 48)

        return vehicleProps
    end
end

HandleAction = function(action)
    if action == "menu" then
        OpenGarageMenu()
    elseif action == "vehicle" then
        PutInVehicle()
    end
end

-- telecamera automatica senza specificarla in config
HandleCamera = function(garage, toggle)
    local Camerapos = GarageCFG.Garages[garage]["camera"]
    local vehiclePosition = GarageCFG.Garages[garage]["positions"]["vehicle"]["position"]
    local vehicleHeading = GarageCFG.Garages[garage]["positions"]["vehicle"]["heading"]
    
    if not Camerapos then 
        -- Se non c'è configurazione della telecamera, creiamo una telecamera dinamica
        if toggle then
            -- Crea una telecamera temporanea
            if cachedData["cam"] then
                DestroyCam(cachedData["cam"])
            end
            
            cachedData["cam"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            
            -- Calcola una posizione ottimale per la telecamera basata sull'heading del veicolo
            -- Questo posizionerà la telecamera davanti al veicolo, leggermente spostata di lato
            local headingRad = math.rad(vehicleHeading)
            local camDistance = 6.0  -- Distanza dalla posizione di spawn
            local camHeight = 1.5    -- Altezza della telecamera
            local camOffset = 2.0    -- Offset laterale
            
            local camPos = vector3(
                vehiclePosition.x - (math.sin(headingRad) * camDistance) + (math.cos(headingRad) * camOffset),
                vehiclePosition.y - (math.cos(headingRad) * camDistance) - (math.sin(headingRad) * camOffset),
                vehiclePosition.z + camHeight
            )
            
            SetCamCoord(cachedData["cam"], camPos.x, camPos.y, camPos.z)
            
            -- Punta la telecamera verso il veicolo con un leggero angolo verso il basso
            PointCamAtCoord(cachedData["cam"], 
                vehiclePosition.x, 
                vehiclePosition.y, 
                vehiclePosition.z + 0.5  -- Punta leggermente più in alto del centro del veicolo
            )
            
            SetCamActive(cachedData["cam"], true)
            RenderScriptCams(1, 1, 750, 1, 1)
            
            -- Aggiungiamo un effetto di transizione fluida
            SetCamFov(cachedData["cam"], 60.0)  -- Campo visivo più stretto per vedere meglio il veicolo
            
            Citizen.Wait(500)
        else
            -- Disattiva la telecamera temporanea
            if cachedData["cam"] then
                DestroyCam(cachedData["cam"])
            end
            
            if DoesEntityExist(cachedData["vehicle"]) then
                DeleteEntity(cachedData["vehicle"])
            end
            
            RenderScriptCams(0, 1, 750, 1, 0)
        end
        
        return 
    end

    -- Il resto della funzione rimane invariato per i garage con telecamera configurata
    if not toggle then
        if cachedData["cam"] then
            DestroyCam(cachedData["cam"])
        end
        
        if DoesEntityExist(cachedData["vehicle"]) then
            DeleteEntity(cachedData["vehicle"])
        end

        RenderScriptCams(0, 1, 750, 1, 0)

        return
    end

    if cachedData["cam"] then
        DestroyCam(cachedData["cam"])
    end

    cachedData["cam"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(cachedData["cam"], Camerapos["x"], Camerapos["y"], Camerapos["z"])
    SetCamRot(cachedData["cam"], Camerapos["rotationX"], Camerapos["rotationY"], Camerapos["rotationZ"])
    SetCamActive(cachedData["cam"], true)

    RenderScriptCams(1, 1, 750, 1, 1)

    Citizen.Wait(500)
end

DrawScriptMarker = function(markerData)
    if not HasStreamedTextureDictLoaded("marker") then
        RequestStreamedTextureDict("marker", true)
        while not HasStreamedTextureDictLoaded("marker") do
            Wait(1)
        end
    else
        DrawMarker(9, markerData["pos"].x,markerData["pos"].y,markerData["pos"].z+1 or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, 0.0, 90.0, 0.0, 0.75, 0.75, 0.75, 255, 255, 255, 255,false, false, 2, true, "marker", "marker", false)
    end
    -- DrawMarker(markerData["type"] or 1,    vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

WaitForModel = function(model)
    local DrawScreenText = function(text, red, green, blue, alpha)
        SetTextFont(4)
        SetTextScale(0.0, 0.5)
        SetTextColour(red, green, blue, alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
    
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.5, 0.5)
    end

    if not IsModelValid(model) then
        return ESX.ShowNotification("Questo modello non e\' presente in questa citta\'.")
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
        DisableAllControlActions(0)
        EnableControlAction(0, 194, true)

		DrawScreenText("Caricando l\'auto " .. GetLabelText(GetDisplayNameFromVehicleModel(model)) .. "...", 255, 255, 255, 150)
	end
end

Citizen.CreateThread(function()
	for k,v in pairs(GarageCFG.nomiveicoli) do
		AddTextEntry(k, v)
	end
end)

RegisterCommand("garagemenu", function()
    menugarage()
end)

RegisterNetEvent("garage:garagemenu")
AddEventHandler("garage:garagemenu", function()
    menugarage()
end)

function menugarage()
    ESX.TriggerServerCallback('itzmoretta:garagea', function(itzmorettagaragea)
    Citizen.Wait(50)
        local elements = {}

		for k,v in ipairs(itzmorettagaragea) do
            table.insert(elements, {
                icon = 'fas fa-car',
                label     =  v.moretarga .. ' | ' .. GetLabelText(GetDisplayNameFromVehicleModel(json.decode(v.moremodello).model)) .. ' | Garage ' .. v.moregarage .. ' |',
                garage = v.moregarage
            })
		end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = 'Menu Garage',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
                SetNewWaypoint(GarageCFG.Garages[data.current.garage]['positions']['menu']['position'].x, GarageCFG.Garages[data.current.garage]['positions']['menu']['position'].y)
                ESX.ShowNotification('GPS Impostato al garage '..data.current.garage..'')
                menu.close()
		end, function(data, menu)
			menu.close()
		end)
          
    end)
end


RegisterCommand('trovaveicolo', function(source, args, rawCommand)
    ESX.TriggerServerCallback('reyzen_thomas:getpex', function(isadm)
        if args[1] and isadm == true then
            local targa = args[1]
            for veh in EnumerateVehicles() do
                if ESX.Game.GetVehicleProperties(veh).plate == targa then    
                    local vehCoords = GetEntityCoords(veh)
                    print(vehCoords)
                    SetNewWaypoint(vehCoords.x, vehCoords.y)
                end
            end
        end
    end)
end, false)


RegisterNetEvent("reyzen_garage:aprimenuveicolifaz")
AddEventHandler("reyzen_garage:aprimenuveicolifaz", function()
    ESX.TriggerServerCallback('garage:fetchJob2VehiclesAll', function(itzmorettagaragea)
        Citizen.Wait(50)
        local elements = {}

		for k,v in ipairs(itzmorettagaragea) do
            table.insert(elements, {
                label     =  v.moretarga .. ' | ' .. GetLabelText(GetDisplayNameFromVehicleModel(json.decode(v.moremodello).model)) .. ' | Garage ' .. v.moregarage .. ' |',
                garage = v.moregarage
            })
		end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = 'Menu Garage',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
                SetNewWaypoint(GarageCFG.Garages[data.current.garage]['positions']['menu']['position'].x, GarageCFG.Garages[data.current.garage]['positions']['menu']['position'].y)
                ESX.ShowNotification('GPS Impostato al garage '..data.current.garage..'')
                menu.close()
		end, function(data, menu)
			menu.close()
		end)
          
    end, ESX.PlayerData.job2.name)
end)

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}
  
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
    disposeFunc(iter)
    return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
    repeat
    coroutine.yield(id)
    next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
end)
end

function EnumerateObjects()
return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

ESX = exports["es_extended"]:getSharedObject()

cachedData = {}


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

-- Variabile globale per tenere traccia degli NPC

-- Funzione DrawText3D standard
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

-- Funzione per creare gli NPC
function CreateGarageNPC(garage, position, heading)
    -- Carica il modello del ped
    local model = GetHashKey(GarageCFG.NPCModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
    
    -- Crea il ped
    local ped = CreatePed(4, model, position.x, position.y, position.z - 1.0, heading or 0.0, false, true)
    
    -- Imposta attributi del ped
    SetEntityHeading(ped, heading or 0.0)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    
    -- Imposta animazione/scenario
    if GarageCFG.NPCScenario then
        TaskStartScenarioInPlace(ped, GarageCFG.NPCScenario, 0, true)
    end
    
    -- Aggiungi blip se necessario
    local blip = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blip, 291)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.3)
    SetBlipColour(blip, 29)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Garage")
    EndTextCommandSetBlipName(blip)
    
    -- Salva il ped nella tabella
    garageNPCs[garage] = {
        ped = ped,
        blip = blip
    }
    
    -- Se stiamo usando ox_target, aggiungi l'opzione di interazione
    if GarageCFG.InteractionSystem == "ox_target" and GetResourceState('ox_target') == 'started' then
        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'garage_' .. garage,
                icon = 'fas fa-car',
                label = 'Accedi al Garage',
                onSelect = function()
                    cachedData["currentGarage"] = garage
                    HandleAction("menu")
                end,
                canInteract = function()
                    return true
                end,
                distance = GarageCFG.InteractionDistance
            }
        })
    end
    
    return ped
end

-- Funzione per eliminare gli NPC quando lo script viene fermato
function DeleteGarageNPCs()
    for garage, data in pairs(garageNPCs) do
        if DoesEntityExist(data.ped) then
            -- Se stiamo usando ox_target, rimuovi l'opzione di interazione
            if GarageCFG.InteractionSystem == "ox_target" and GetResourceState('ox_target') == 'started' then
                exports.ox_target:removeLocalEntity(data.ped, 'garage_' .. garage)
            end
            
            DeleteEntity(data.ped)
        end
        if data.blip ~= nil then
            RemoveBlip(data.blip)
        end
    end
    garageNPCs = {}
end

-- Evento per eliminare gli NPC quando la risorsa viene fermata
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteGarageNPCs()
    end
end)

-- Thread principale per gestire sia i marker che gli NPC
-- Funzione per disegnare testo 3D
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local px, py, pz = table.unpack(GetGameplayCamCoords())
        
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

-- Tabella per memorizzare gli NPC creati
garageNPCs = {}

-- Funzione per creare un NPC del garage
function CreateGarageNPC(garage, position, heading)
    -- Carica il modello dell'NPC
    local modelHash = GetHashKey(GarageCFG.NPCModel)
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(1)
    end
    
    -- Crea il ped
    local ped = CreatePed(4, modelHash, position.x, position.y, position.z - 1.0, heading, false, true)
    
    -- Imposta attributi del ped
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    
    -- Imposta l'animazione/scenario
    if GarageCFG.NPCScenario then
        TaskStartScenarioInPlace(ped, GarageCFG.NPCScenario, 0, true)
    end
    
    -- Memorizza l'NPC nella tabella
    garageNPCs[garage] = {
        ped = ped,
        position = position
    }
    
    -- Rilascia il modello
    SetModelAsNoLongerNeeded(modelHash)
    
    return ped
end

-- Thread principale per i garage
Citizen.CreateThread(function()
    local CanDraw = function(action)
        if action == "vehicle" then
            if IsPedInAnyVehicle(PlayerPedId()) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
        return true
    end

    local GetDisplayText = function(action, garage)
        if not GarageCFG.Labels[action] then GarageCFG.Labels[action] = action end
        return string.format(GarageCFG.Labels[action], action == "vehicle" and GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) or garage)
    end

    -- Crea i blip per tutti i garage
    for garage, garageData in pairs(GarageCFG.Garages) do
        if not garageData["fazione"] then
            local garageBlip = AddBlipForCoord(garageData["positions"]["menu"]["position"])
            SetBlipSprite(garageBlip, 291)
            SetBlipDisplay(garageBlip, 4)
            SetBlipScale(garageBlip, 0.3)
            SetBlipColour(garageBlip, 29)
            SetBlipAsShortRange(garageBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Garage")
            EndTextCommandSetBlipName(garageBlip)
        end
    end

    -- Se usiamo gli NPC, creiamoli per ogni garage
    if GarageCFG.UseNPC then
        for garage, garageData in pairs(GarageCFG.Garages) do
            local menuPos = garageData["positions"]["menu"]["position"]
            local heading = garageData["positions"]["menu"]["heading"] or 0.0
            
            -- Crea l'NPC per questo garage
            CreateGarageNPC(garage, menuPos, heading)
        end
    end

    -- Scegli il sistema di marker in base alla configurazione
    if GarageCFG.MarkerSystem == "gridsystem" then
        -- Registra i marker usando gridsystem
        for garage, garageData in pairs(GarageCFG.Garages) do
            for action, actionData in pairs(garageData["positions"]) do
                -- Registra sempre i marker "vehicle" e i marker "menu" solo se non usiamo NPC
                if action == "vehicle" or (action == "menu" and not GarageCFG.UseNPC) then
                    TriggerEvent('gridsystem:registerMarker', {
                        name = "garage" .. actionData["position"].x,
                        pos = vector3(actionData["position"].x, actionData["position"].y, actionData["position"].z-0.01),
                        size = vector3(1.2, 1.2, 1.2),
                        scale = vector3(0.8, 0.8, 0.8),
                        type = 2, -- Type Marker
                        control = 'E',
                        rotate = 90.0,
                        rotate2 = 0.0,
                        shouldBob = false,
                        shouldRotate = true,
                        color = { r = 255, g = 255, b = 255 }, -- Color Marker
                        trasparent = 255,
                        msg = action == "menu" and 'GARAGE' or 'DEPOSITA VEICOLO',
                        customt = 'garage',
                        action = function()
                            cachedData["currentGarage"] = garage
                            HandleAction(action)
                        end
                    })
                end
            end
        end
    else
        -- Usa il sistema di marker standard
        Citizen.CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local sleep = 1000
                local isInMarker, currentAction, currentGarage = false, nil, nil

                for garage, garageData in pairs(GarageCFG.Garages) do
                    for action, actionData in pairs(garageData["positions"]) do
                        -- Gestisci i marker "vehicle" e i marker "menu" solo se non usiamo NPC
                        if action == "vehicle" or (action == "menu" and not GarageCFG.UseNPC) then
                            local distance = #(playerCoords - actionData["position"])
                            
                            -- Se il giocatore è abbastanza vicino, disegna il marker
                            if distance < GarageCFG.DefaultMarker.drawDistance then
                                sleep = 0
                                
                                if CanDraw(action) then
                                    DrawMarker(
                                        GarageCFG.DefaultMarker.type,
                                        actionData["position"],
                                        0.0, 0.0, 0.0, -- dir
                                        0.0, 0.0, 0.0, -- rot
                                        GarageCFG.DefaultMarker.size,
                                        GarageCFG.DefaultMarker.color.r, GarageCFG.DefaultMarker.color.g, GarageCFG.DefaultMarker.color.b, GarageCFG.DefaultMarker.color.a,
                                        GarageCFG.DefaultMarker.bobUpAndDown, GarageCFG.DefaultMarker.faceCamera, 2, GarageCFG.DefaultMarker.rotate
                                    )
                                    
                                    -- Se il giocatore è molto vicino, mostra il testo 3D
                                    if distance < GarageCFG.DefaultMarker.interactionDistance then
                                        isInMarker = true
                                        currentAction = action
                                        currentGarage = garage
                                        
                                        -- Mostra testo 3D
                                        local text = action == "menu" and "Premi ~b~E~w~ per aprire il garage" or "Premi ~b~E~w~ per depositare il veicolo"
                                        DrawText3D(actionData["position"].x, actionData["position"].y, actionData["position"].z + 1.0, text)
                                        
                                        -- Controlla se il giocatore preme E
                                        if IsControlJustReleased(0, 38) then -- E key
                                            cachedData["currentGarage"] = garage
                                            HandleAction(action)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                Citizen.Wait(sleep)
            end
        end)
    end
end)

-- Thread separato per l'interazione con gli NPC usando DrawText3D
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Se non usiamo gli NPC o stiamo usando ox_target, salta questo thread
        if not GarageCFG.UseNPC or GarageCFG.InteractionSystem == "ox_target" then
            Citizen.Wait(1000)
            goto continue
        end
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearNPC = false
        
        for garage, data in pairs(garageNPCs) do
            if DoesEntityExist(data.ped) then
                local pedCoords = GetEntityCoords(data.ped)
                local distance = #(playerCoords - pedCoords)
                
                if distance < GarageCFG.InteractionDistance then
                    isNearNPC = true
                    
                    -- Usa DrawText3D per mostrare il testo sopra l'NPC
                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, "Premi [E] per accedere al garage")
                    
                    -- Controlla se il giocatore preme E
                    if IsControlJustReleased(0, 38) then -- E key
                        cachedData["currentGarage"] = garage
                        HandleAction("menu")
                    end
                end
            end
        end
        
        -- Se non siamo vicini a nessun NPC, attendiamo più a lungo per risparmiare risorse
        if not isNearNPC then
            Citizen.Wait(500)
        end
        
        ::continue::
    end
end)

-- Supporto per ox_target se configurato
if GarageCFG.InteractionSystem == "ox_target" and GarageCFG.UseNPC then
    Citizen.CreateThread(function()
        -- Attendi che ox_target sia caricato
        while GetResourceState('ox_target') ~= 'started' do
            Citizen.Wait(100)
        end
        
        -- Aggiungi opzioni di ox_target per ogni NPC
        for garage, data in pairs(garageNPCs) do
            if DoesEntityExist(data.ped) then
                exports.ox_target:addLocalEntity(data.ped, {
                    {
                        name = 'garage_npc_' .. garage,
                        icon = 'fas fa-car',
                        label = 'Accedi al Garage',
                        onSelect = function()
                            cachedData["currentGarage"] = garage
                            HandleAction("menu")
                        end
                    }
                })
            end
        end
    end)
end


-- nuovo menu

-- Funzione per aprire la NUI
function OpenGarageNUI(garage)
    SetNuiFocus(true, true)
    
    ESX.TriggerServerCallback("garage:fetchPlayerVehicles", function(fetchedVehicles)
        local vehicleList = {}
        
        ESX.TriggerServerCallback("garage:fetchJob2Vehicles", function(fetchedVehicles2)
            for key, vehicleData in ipairs(fetchedVehicles2) do
                local vehicleProps = vehicleData["props"]
                
                -- Ottieni il nome del modello
                local displayName = GetDisplayNameFromVehicleModel(vehicleData.props.model)
                
                -- Prova a ottenere il nome leggibile
                local vehicleName = GetLabelText(displayName)
                
                -- Se il nome è NULL o vuoto, usa alternative
                if vehicleName == "NULL" or vehicleName == "" then
                    -- Prima controlla se esiste nella tabella di configurazione
                    if GarageCFG.nomiveicoli[displayName] then
                        vehicleName = GarageCFG.nomiveicoli[displayName]
                    else
                        -- Altrimenti usa il displayName e formattalo per renderlo più leggibile
                        vehicleName = displayName:gsub("^%l", string.upper) -- Rende maiuscola la prima lettera
                        vehicleName = vehicleName:gsub("_", " ") -- Sostituisce underscore con spazi
                    end
                end
                
                table.insert(vehicleList, {
                    plate = vehicleData["plate"],
                    label = vehicleName,
                    props = vehicleData["props"],
                    pound = vehicleData["pound"] == 1,
                    isFaction = true
                })
            end
            
            for key, vehicleData in ipairs(fetchedVehicles) do
                local vehicleProps = vehicleData["props"]
                
                -- Ottieni il nome del modello
                local displayName = GetDisplayNameFromVehicleModel(vehicleData.props.model)
                
                -- Prova a ottenere il nome leggibile
                local vehicleName = GetLabelText(displayName)
                
                -- Se il nome è NULL o vuoto, usa alternative
                if vehicleName == "NULL" or vehicleName == "" then
                    -- Prima controlla se esiste nella tabella di configurazione
                    if GarageCFG.nomiveicoli[displayName] then
                        vehicleName = GarageCFG.nomiveicoli[displayName]
                    else
                        -- Altrimenti usa il displayName e formattalo per renderlo più leggibile
                        vehicleName = displayName:gsub("^%l", string.upper) -- Rende maiuscola la prima lettera
                        vehicleName = vehicleName:gsub("_", " ") -- Sostituisce underscore con spazi
                    end
                end
                
                table.insert(vehicleList, {
                    plate = vehicleData["plate"],
                    label = vehicleName,
                    props = vehicleData["props"],
                    pound = vehicleData["pound"] == 1,
                    isFaction = false
                })
            end
            
            SendNUIMessage({
                type = "open",
                garage = garage,
                vehicles = vehicleList
            })
            
            if #vehicleList > 0 then
                SpawnLocalVehicle(vehicleList[1].props, garage)
            end
            
        end, garage, ESX.PlayerData.job.name)
    end, garage)
end

-- Modifica la funzione OpenGarageMenu per usare la NUI
OpenGarageMenu = function()
    local currentGarage = cachedData["currentGarage"]
    if not currentGarage then return end
    HandleCamera(currentGarage, true)
    
    -- Usa la nuova funzione NUI invece del menu ESX
    OpenGarageNUI(currentGarage)
end

-- Aggiungi i callback NUI
RegisterNUICallback('changeVehicle', function(data, cb)
    if data.vehicleProps then
        local currentGarage = cachedData["currentGarage"]
        
        -- Prima rimuovi il veicolo locale se esiste
        if DoesEntityExist(cachedData["vehicle"]) then
            DeleteEntity(cachedData["vehicle"])
            cachedData["vehicle"] = nil
            -- Attendi un momento per assicurarsi che il veicolo sia stato rimosso
            Citizen.Wait(50)
        end
        
        SpawnLocalVehicle(data.vehicleProps, currentGarage)
    end
    
    cb('ok')
end)

RegisterNUICallback('takeVehicle', function(data, cb)
    local currentGarage = cachedData["currentGarage"]
    
    -- Prima rimuovi il veicolo locale se esiste
    if DoesEntityExist(cachedData["vehicle"]) then
        DeleteEntity(cachedData["vehicle"])
        cachedData["vehicle"] = nil
        -- Attendi un momento per assicurarsi che il veicolo sia stato rimosso
        Citizen.Wait(50)
    end
    
    local spawnpoint = GarageCFG.Garages[currentGarage]["positions"]["vehicle"]
    if not ESX.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
        ESX.ShowNotification("Sposta il veicolo che occupa l\'uscita del veicolo.")
        cb('error')
        return
    end
    
    SpawnVehicle(data.props)
    
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    -- Disattiva il focus NUI
    SetNuiFocus(false, false)
    
    -- Gestisci la camera
    if cachedData["currentGarage"] then
        HandleCamera(cachedData["currentGarage"], false)
    end
    
    -- Elimina il veicolo se esiste
    if DoesEntityExist(cachedData["vehicle"]) then
        DeleteEntity(cachedData["vehicle"])
        cachedData["vehicle"] = nil
    end
    
    -- Invia un messaggio alla NUI per assicurarsi che sia nascosta
    SendNUIMessage({
        type = "close"
    })
    
    -- Risposta al callback
    cb('ok')

end)


-- Modifica la funzione PutInVehicle per chiudere la NUI se aperta
PutInVehicle = function()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())

    if DoesEntityExist(vehicle) then
        local vehicleProps = GetVehicleProperties(vehicle)

        ESX.TriggerServerCallback("garage:validateVehicle", function(valid)
            if valid then
                ESX.Game.DeleteVehicle(vehicle)
                TriggerServerEvent('mlmloggr2', vehicleProps.plate)
                
                -- Chiudi la NUI se è aperta
                SendNUIMessage({
                    type = "close"
                })
                SetNuiFocus(false, false)
            else
                ESX.ShowNotification("Non sei il proprietario di questo veicolo")
            end

        end, vehicleProps, cachedData["currentGarage"])
    end
end

-- Aggiungi un comando per testare la NUI
RegisterCommand('testgarage', function()
    if cachedData["currentGarage"] then
        OpenGarageNUI(cachedData["currentGarage"])
    else
        ESX.ShowNotification("Non sei vicino a un garage")
    end
end, false)

-- Aggiungi un handler per chiudere la NUI con ESC
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 177) then -- ESC key
            SendNUIMessage({
                type = "close"
            })
            SetNuiFocus(false, false)
            
            if cachedData["currentGarage"] then
                HandleCamera(cachedData["currentGarage"], false)
            end
            
            if DoesEntityExist(cachedData["vehicle"]) then
                DeleteEntity(cachedData["vehicle"])
            end
        end
    end
end)
