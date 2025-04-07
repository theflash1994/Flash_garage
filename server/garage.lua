ESX = exports['es_extended']:getSharedObject()

UpdateGarage = function(vehicleProps, newGarage)
	local sqlQuery = [[
		UPDATE
			owned_vehicles
		SET
			garage = @garage, vehicle = @newVehicle
		WHERE
			plate = @plate
	]]

	MySQL.Async.execute(sqlQuery, {
		["@plate"] = vehicleProps["plate"],
		["@garage"] = newGarage,
		["@newVehicle"] = json.encode(vehicleProps)
	}, function(rowsChanged)
		if rowsChanged > 0 then
			
		end
	end)
end

ESX.RegisterServerCallback('itzmoretta:garagea', function(source, cb)
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
		['@identifier'] = xPlayer.identifier,
	}, function(result)
		local itzmorettagaragea = {}
		for i=1, #result, 1 do
			table.insert(itzmorettagaragea, {
				moregarage = result[i].garage,
				moreveh = result[i].vehiclename,
				moretarga =  result[i].plate,
				moremodello = result[i].vehicle
			})
		end
		cb(itzmorettagaragea)
	end)
end)

ESX.RegisterServerCallback("garage:fetchJob2VehiclesAll", function(source, cb, job2)
	local lavoro = job2

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @job2', {
		['@job2'] = lavoro,
	}, function(result)
		local itzmorettagaragea = {}
		for i=1, #result, 1 do
			table.insert(itzmorettagaragea, {
				moregarage = result[i].garage,
				moreveh = result[i].vehiclename,
				moretarga =  result[i].plate,
				moremodello = result[i].vehicle
			})
		end
		cb(itzmorettagaragea)
	end)
end)

ESX.RegisterServerCallback('garage:getpex', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getGroup() == 'admin' then
		cb(true)
	else
		cb(false)
	end
end)
	


local cachedData = {}

ESX.RegisterServerCallback("garage:fetchPlayerVehicles", function(source, callback, garage)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local sqlQuery = [[
			SELECT
				plate, vehicle
			FROM
				owned_vehicles
			WHERE
				owner = @cid
		]]

		if garage then
			sqlQuery = [[
				SELECT
					plate, vehicle, pound
				FROM
					owned_vehicles
				WHERE
					owner = @cid and garage = @garage
			]]
		end

		MySQL.Async.fetchAll(sqlQuery, {
			["@cid"] = xPlayer.identifier,
			["@garage"] = garage
		}, function(responses)
			local playerVehicles = {}

			for key, vehicleData in ipairs(responses) do
				table.insert(playerVehicles, {
					["plate"] = vehicleData["plate"],
					["props"] = json.decode(vehicleData["vehicle"]),
					["pound"] = vehicleData["pound"]
				})
			end

			callback(playerVehicles)
		end)
	else
		callback(false)
	end
end)

ESX.RegisterServerCallback("garage:fetchJob2Vehicles", function(source, callback, garage, job2)
	local lavoro = job2

	if garage then
		sqlQuery = [[
			SELECT
				plate, vehicle, pound
			FROM
				owned_vehicles
			WHERE
				owner = @cid and garage = @garage
		]]
	end

	MySQL.Async.fetchAll(sqlQuery, {
		["@cid"] = lavoro,
		["@garage"] = garage
	}, function(responses)
		local playerVehicles = {}

		for key, vehicleData in ipairs(responses) do
			table.insert(playerVehicles, {
				["plate"] = vehicleData["plate"],
				["props"] = json.decode(vehicleData["vehicle"]),
				["pound"] = vehicleData["pound"]
			})
		end

		callback(playerVehicles)
	end)
end)

ESX.RegisterServerCallback("garage:gettaveicolisequestrati", function(source, callback)
	local sqlQuery = [[
		SELECT
			plate
		FROM
			owned_vehicles
		WHERE
			pound = @pound
	]]

	MySQL.Async.fetchAll(sqlQuery, {
		["@pound"] = 1
	}, function(responses)
		local playerVehicles = {}

		for key, vehicleData in ipairs(responses) do
			table.insert(playerVehicles, {
				["plate"] = vehicleData["plate"]
			})
		end

		callback(playerVehicles)
	end)
end)

ESX.RegisterServerCallback("garage:validateVehicle", function(source, callback, vehicleProps, garage)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				owner
			FROM
				owned_vehicles
			WHERE
				plate = @plate
		]]

		MySQL.Async.fetchAll(sqlQuery, {
			["@plate"] = vehicleProps["plate"]
		}, function(responses)
			if responses[1] then
				UpdateGarage(vehicleProps, garage)

				callback(true)
			else
				callback(false)
			end
		end)
	else
		callback(false)
	end
end)

RegisterServerEvent('garage:updatasequestroveicolo')
AddEventHandler('garage:updatasequestroveicolo', function(targa, pound)
	MySQL.Async.execute('UPDATE owned_vehicles SET pound = @pound WHERE plate = @plate', {
		['@pound'] = pound, 
		["@plate"] = targa
	}, function(c2)
	end)
end)

ESX.RegisterCommand('daiveicolofazione', 'admin', function(xPlayer, args, showError)
	local sqlQuery = [[
		UPDATE
			owned_vehicles
		SET
			owner = @owner
		WHERE
			plate = @plate
	]]

	MySQL.Async.execute(sqlQuery, {
		["@plate"] = args.targa,
		["@owner"] = args.job2
	}, function(rowsChanged)
		if rowsChanged > 0 then
			xPlayer.showNotification('Veicolo targato '..args.targa..' assegnato alla fazione '..args.job2)
		end
	end)

	-- xPlayer.showNotification('Veicolo targato '..args.targa..' assegnato alla fazione '..args.job2)
end, false, {help = 'Ritorna il veicolo al garage', validate = true, arguments = {
	{name = 'targa', help = 'TARGA', type = 'any'},
	{name = 'job2', help = 'JOB2', type = 'any'}
}})


RegisterServerEvent('mlmloggr2', function(a)
	ESX.Log('', ('Il giocatore: %s ha depositato il suo veicolo con targa: %s'):format(GetPlayerName(source), a))
end)

RegisterServerEvent('mlmloggr', function(a)
	ESX.Log('', ('Il giocatore: %s ha ritirato il suo veicolo con targa: %s'):format(GetPlayerName(source), a))
end)
