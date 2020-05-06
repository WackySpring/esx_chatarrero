

ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if GetCurrentResourceName() == 'esx_chatarrero' then


  print("\n".. " Cargado correctamente. Editado por WackySpring e Ikarus ")

    ESX.RegisterServerCallback('esx_chatarrero:anycops',function(source, cb)
        local anycops = 0
        local playerList = GetPlayers()
        for i=1, #playerList, 1 do
            local _source = playerList[i]
            local xPlayer = ESX.GetPlayerFromId(_source)
            local playerjob = xPlayer.job.name
            if playerjob == 'police' then
                anycops = anycops + 1
            end
        end
        cb(anycops)
    end)

    --[[RegisterServerEvent("esx_chatarrero:rewards")
    AddEventHandler("esx_chatarrero:rewards", function(rewards)
        --Rewards()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if not xPlayer then return; end
        for k,v in pairs(Config.Items) do
            local randomCount = math.random(0, 3)
            if xPlayer.getInventoryItem(v).count >= xPlayer.getInventoryItem(v).limit then
                TriggerClientEvent('esx:showNotification', source, '~r~No puedes llevar más encima')
            else
                xPlayer.addInventoryItem(v, randomCount)
            end
        end

    end)]]
	
	RegisterServerEvent('esx_chatarrero:puerta')
    AddEventHandler('esx_chatarrero:puerta', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('puerta')
	math.randomseed(GetGameTimer())
	
		if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, ('Ya tienes todas las puertas.'))
	else

		xPlayer.addInventoryItem('puerta',math.random(2, 4))
	end
end)

	RegisterServerEvent('esx_chatarrero:puerta2')
    AddEventHandler('esx_chatarrero:puerta2', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('puerta')
	math.randomseed(GetGameTimer())

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, ('Ya tienes todas las puertas.'))
	else
     xPlayer.addInventoryItem('puerta',math.random(1, 2))
	end
end)





	RegisterServerEvent('esx_chatarrero:moto')
    AddEventHandler('esx_chatarrero:moto', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('bateria')
	local xItem1 = xPlayer.getInventoryItem('llanta')
	local xItem2 = xPlayer.getInventoryItem('radio')

	math.randomseed(GetGameTimer())

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, ('Ya tienes una batería'))
	else
   xPlayer.addInventoryItem('bateria',math.random(0, 1))
		end

	
	
		if xItem1.limit ~= -1 and (xItem1.count + 1) > xItem1.limit then
		TriggerClientEvent('esx:showNotification', source, ('No puedes llevar más llantas'))
	else
      xPlayer.addInventoryItem('llanta',math.random(1, 2))
		end
	
			if xItem2.limit ~= -1 and (xItem2.count + 1) > xItem2.limit then
		TriggerClientEvent('esx:showNotification', source, ('No puedes llevar más radios'))
	else
       xPlayer.addInventoryItem('radio',math.random(0, 1))
	end

end)









	RegisterServerEvent('esx_chatarrero:capo')
    AddEventHandler('esx_chatarrero:capo', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('capo')
	math.randomseed(GetGameTimer())
	local percent = math.random(1, 10)

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, ('Ya tienes un capó.'))
	else
	
    xPlayer.addInventoryItem('capo',math.random(0, 1))
	end
end)

	RegisterServerEvent('esx_chatarrero:piezas')
    AddEventHandler('esx_chatarrero:piezas', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('bateria')
	local xItem1 = xPlayer.getInventoryItem('airbag')
	local xItem2 = xPlayer.getInventoryItem('radio')

	math.randomseed(GetGameTimer())
		local percent = math.random(1, 10)

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, ('Ya tienes una batería'))
	else
   xPlayer.addInventoryItem('bateria',math.random(0, 1))
		end

	
	
		if xItem1.limit ~= -1 and (xItem1.count + 1) > xItem1.limit then
		TriggerClientEvent('esx:showNotification', source, ('No puedes llevar más airbags'))
	else
      xPlayer.addInventoryItem('airbag',math.random(1, 2))
		end
	
			if xItem2.limit ~= -1 and (xItem2.count + 1) > xItem2.limit then
		TriggerClientEvent('esx:showNotification', source, ('No puedes llevar más radios'))
	else
       xPlayer.addInventoryItem('radio',math.random(0, 1))
	end

end)

	RegisterServerEvent('esx_chatarrero:llanta')
    AddEventHandler('esx_chatarrero:llanta', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('llanta')
	math.randomseed(GetGameTimer())

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, ('Ya tienes todas las llantas.'))
	else

		xPlayer.addInventoryItem('llanta',math.random(2, 4))
	end
	
end)


    RegisterServerEvent('chopNotify')
    AddEventHandler('chopNotify', function()
        TriggerClientEvent("chopEnable", source)
    end)


    RegisterServerEvent('ChopInProgress')
    AddEventHandler('ChopInProgress', function()
        TriggerClientEvent("outlawChopNotify", -1, "")
    end)

    RegisterServerEvent('ChoppingInProgressPos')
    AddEventHandler('ChoppingInProgressPos', function(gx, gy, gz)
        TriggerClientEvent('Choplocation', -1, gx, gy, gz)
    end)


    RegisterServerEvent('esx_chatarrero:sell')
    AddEventHandler('esx_chatarrero:sell', function(itemName, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        local price = Config.Itemsprice[itemName]
        local xItem = xPlayer.getInventoryItem(itemName)


        if xItem.count < amount then
            TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
            return
        end

        price = ESX.Math.Round(price * amount)

        if Config.GiveBlack then
            xPlayer.addAccountMoney('black_money', price)
        else
            xPlayer.addMoney(price)
        end

        xPlayer.removeInventoryItem(xItem.name, amount)

        TriggerClientEvent('esx:showNotification', source, _U('sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
    end)
else
    print("\n###############################")
    print("\n No cambies el nombre... Ahora:  ".. GetCurrentResourceName() .. " . Debe ser: ".. 'esx_chatarrero'.. " para que funcione correctamente")
    print("\n###############################")

end
