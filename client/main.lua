ESX                             = nil
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isDead                    = false
local CurrentTask               = {}
local menuOpen 				    = false
local wasOpen 				    = false
local pedIsTryingToChopVehicle  = false
local ChoppingInProgress        = false




local spawncamion = { x = -534.53, y = -1717.0, z = 19.12, h = 291.16 }
local venta = { x = -195.04, y = 6264.96, z = 30.49}


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if GetDistanceBetweenCoords(coords, Config.Zones.Shop.coords, true) < 3.0 then
            ESX.ShowHelpNotification(_U('shop_prompt'))

            if IsControlJustReleased(0, 38) then
                wasOpen = true
                OpenShop()
            end
        else
            if wasOpen then
                wasOpen = false
                ESX.UI.Menu.CloseAll()
            end

            Citizen.Wait(500)
        end
    end
end)

function OpenShop()
    local elements = {}
    menuOpen = true
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        local price = Config.Itemsprice[v.name]

        if price and v.count > 0 then
            table.insert(elements, {
                label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('item', ESX.Math.GroupDigits(price))),
                name = v.name,
                price = price,

                -- menu properties
                type = 'slider',
                value = 1,
                min = 1,
                max = v.count
            })
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_shop', {
        title    = _U('shop_title'),
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('esx_chatarrero:sell', data.current.name, data.current.value)
		exports.pNotify:SendNotification({text = "Ve a devolver el camión", type = "success", timeout = 3000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				SetNewWaypoint(spawncamion.x,spawncamion.y)
    end, function(data, menu)
        menu.close()
        menuOpen = false
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)


function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end



function MaxSeats(vehicle)
    local vehpas = GetVehicleNumberOfPassengers(vehicle)
    return vehpas
end

local lastTested = 0
function ChopVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
	local wheels = GetVehicleNumberOfWheels(vehicle)
	local doors = GetNumberOfVehicleDoors(vehicle)
    local seats = MaxSeats(vehicle)
    if seats ~= 0 then
        TriggerEvent('chat:addMessage', { args = { 'No puede haber pasajeros' } })
    elseif
        GetGameTimer() - lastTested > Config.CooldownMinutes * 60000 then
        lastTested = GetGameTimer()
        ESX.TriggerServerCallback('esx_chatarrero:anycops', function(anycops)
            if anycops >= Config.CopsRequired then
                if Config.CallCops then
                    local randomReport = math.random(1, Config.CallCopsPercent)

                    if randomReport == Config.CallCopsPercent then
                        TriggerServerEvent('chopNotify')
                    end
                end
                ChoppingInProgress        = true
				if wheels == 4 then
			    if doors <= 4 then
		        VehiclePartsRemoval1()
                else
				VehiclePartsRemoval()
		        end
                else
                MotoPartsRemoval()
		        end
                if not HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker =  true
                    ChoppingInProgress        = false
                    exports.pNotify:SendNotification({text = "No has dejado los chatarreros terminar.", type = "error", timeout = 4000, layout = "centerRight", queue = "right", killer = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    --SetVehicleAlarmTimeLeft(vehicle, 60000)
                end
            else
                ESX.ShowNotification(_U('not_enough_cops'))
            end
        end)
    else
        local timerNewChop = Config.CooldownMinutes * 60000 - (GetGameTimer() - lastTested)
        exports.pNotify:SendNotification({
            text = "Puedes volver en " ..math.floor(timerNewChop / 60000).. " minutos",
            type = "error",
            timeout = 1000,
            layout = "centerRight",
            queue = "right",
            killer = true,
            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}
        })
    end
end



function VehiclePartsRemoval()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
	
    SetVehicleNumberPlateText(vehicle, "Robado")
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, false)
    if ChoppingInProgress == true then
	puerta1 = CreatePed(1, Config.NPCHash1, -557.17, -1695.32, 18.18, 300.0, false, true)
	SetCurrentPedWeapon(puerta1, -2067956739, true)
	--LoadAnimDict("timetable@gardener@filling_can")
	--TaskPlayAnim(puerta1, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	    TaskStartScenarioInPlace(puerta1, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenFrontLeftTime, "Abriendo puerta delantera izquierda")
        Citizen.Wait(Config.DoorOpenFrontLeftTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 0, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenFrontLeftTime, "Desmontando puerta delantera izquierda")
        Citizen.Wait(Config.DoorBrokenFrontLeftTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
		DeleteEntity(puerta1)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
	puerta2 = CreatePed(1, Config.NPCHash1, -555.32, -1693.7, 18.27, 167.35, false, true)
	SetCurrentPedWeapon(puerta2, -2067956739, true)
	TaskStartScenarioInPlace(puerta2, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenFrontRightTime, "Abriendo puerta delantera derecha")
        Citizen.Wait(Config.DoorOpenFrontRightTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 1, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenFrontRightTime, "Desmontando puerta delantera derecha")
        Citizen.Wait(Config.DoorBrokenFrontRightTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
				DeleteEntity(puerta2)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
	puerta3 = CreatePed(1, Config.NPCHash1, -556.89, -1696.1, 18.17, 320.51, false, true)
	SetCurrentPedWeapon(puerta3, -2067956739, true)
	TaskStartScenarioInPlace(puerta3, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenRearLeftTime, "Abriendo puerta trasera izquierda")
        Citizen.Wait(Config.DoorOpenRearLeftTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 2, false, false)

    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenRearLeftTime, "Desmontando puerta trasera izquierda")
        Citizen.Wait(Config.DoorBrokenRearLeftTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 2, true)
		DeleteEntity(puerta3)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
		puerta4 = CreatePed(1, Config.NPCHash1, -554.94, -1694.58, 18.25, 115.77, false, true)
	SetCurrentPedWeapon(puerta4, -2067956739, true)
	TaskStartScenarioInPlace(puerta4, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenRearRightTime, "Abriendo puerta trasera derecha")
        Citizen.Wait(Config.DoorOpenRearRightTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 3, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenRearRightTime, "Desmontando puerta trasera derecha")
        Citizen.Wait(Config.DoorBrokenRearRightTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 3, true)
		DeleteEntity(puerta4)
		TriggerServerEvent("esx_chatarrero:puerta")
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
	capo = CreatePed(1, Config.NPCHash1, -557.88, -1692.33, 18.27, 221.5, false, true)
	SetCurrentPedWeapon(capo, -2067956739, true)
	TaskStartScenarioInPlace(capo, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenHoodTime, "Abriendo capó")
        Citizen.Wait(Config.DoorOpenHoodTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 4, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenHoodTime, "Desmontando capó")
        Citizen.Wait(Config.DoorBrokenHoodTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),4, true)
				DeleteEntity(capo)
		TriggerServerEvent("esx_chatarrero:capo")
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
	trunk = CreatePed(1, Config.NPCHash1, -554.51, -1697.42, 18.19, 24.23, false, true)
	SetCurrentPedWeapon(trunk, -2067956739, true)
	TaskStartScenarioInPlace(trunk, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenTrunkTime, "Abriendo maletero")
        Citizen.Wait(Config.DoorOpenTrunkTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 5, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenTrunkTime, "Desmontando maletero")
        Citizen.Wait(Config.DoorBrokenTrunkTime)
		DeleteEntity(trunk)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),5, true)
    end
    Citizen.Wait(1000)
    exports['progressBars']:startUI(Config.DeletingVehicleTime, "Terminando de desguazar")
    Citizen.Wait(Config.DeletingVehicleTime)
    if ChoppingInProgress == true then
        DeleteVehicle()
		TriggerServerEvent("esx_chatarrero:piezas")
		TriggerServerEvent("esx_chatarrero:llanta")
        exports.pNotify:SendNotification({text = "Vehiculo desguazado, ahora coge ese camión y ve a vender las piezas. Si no quieres vender la piezas devuelve el camión", type = "success", timeout = 5000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		Spawn()
	SetNewWaypoint(venta.x,venta.y)
	final = CreatePed(1, Config.NPCHash1, -559.57, -1690.93, 18.23, 212.5, false, true)
	SetCurrentPedWeapon(capo, -2067956739, true)
	LoadAnimDict("gestures@m@standing@casual")
	TaskPlayAnim(final, "gestures@m@standing@casual", "gesture_hello", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	    Citizen.Wait(1000)
		DeleteEntity(final)
    end
end




function VehiclePartsRemoval1()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
	
    SetVehicleNumberPlateText(vehicle, "Robado")
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, false)
    if ChoppingInProgress == true then
	puerta1 = CreatePed(1, Config.NPCHash1, -557.17, -1695.32, 18.18, 300.0, false, true)
	SetCurrentPedWeapon(puerta1, -2067956739, true)
	    TaskStartScenarioInPlace(puerta1, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenFrontLeftTime, "Abriendo puerta delantera izquierda")
        Citizen.Wait(Config.DoorOpenFrontLeftTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 0, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenFrontLeftTime, "Desmontando puerta delantera izquierda")
        Citizen.Wait(Config.DoorBrokenFrontLeftTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
		DeleteEntity(puerta1)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
	puerta2 = CreatePed(1, Config.NPCHash1, -555.32, -1693.7, 18.27, 167.35, false, true)
	SetCurrentPedWeapon(puerta2, -2067956739, true)
	TaskStartScenarioInPlace(puerta2, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenFrontRightTime, "Abriendo puerta delantera derecha")
        Citizen.Wait(Config.DoorOpenFrontRightTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 1, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenFrontRightTime, "Desmontando puerta delantera derecha")
        Citizen.Wait(Config.DoorBrokenFrontRightTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
				DeleteEntity(puerta2)
		TriggerServerEvent("esx_chatarrero:puerta2")
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
	capo = CreatePed(1, Config.NPCHash1, -557.88, -1692.33, 18.27, 221.5, false, true)
	SetCurrentPedWeapon(capo, -2067956739, true)
	TaskStartScenarioInPlace(capo, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenHoodTime, "Abriendo capó")
        Citizen.Wait(Config.DoorOpenHoodTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 4, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenHoodTime, "Desmontando capó")
        Citizen.Wait(Config.DoorBrokenHoodTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),4, true)
				DeleteEntity(capo)
		TriggerServerEvent("esx_chatarrero:capo")
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
	trunk = CreatePed(1, Config.NPCHash1, -554.51, -1697.42, 18.19, 24.23, false, true)
	SetCurrentPedWeapon(trunk, -2067956739, true)
	TaskStartScenarioInPlace(trunk, "PROP_HUMAN_BUM_BIN", 0, 1)
        exports['progressBars']:startUI(Config.DoorOpenTrunkTime, "Abriendo maletero")
        Citizen.Wait(Config.DoorOpenTrunkTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 5, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['progressBars']:startUI(Config.DoorBrokenTrunkTime, "Desmontando maletero")
        Citizen.Wait(Config.DoorBrokenTrunkTime)
		DeleteEntity(trunk)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),5, true)
    end
    Citizen.Wait(1000)
    exports['progressBars']:startUI(Config.DeletingVehicleTime, "Terminando de desguazar")
    Citizen.Wait(Config.DeletingVehicleTime)
    if ChoppingInProgress == true then
        DeleteVehicle()
		TriggerServerEvent("esx_chatarrero:piezas")
		TriggerServerEvent("esx_chatarrero:llanta")
        exports.pNotify:SendNotification({text = "Vehiculo desguazado, ahora coge ese camión y ve a vender las piezas. Si no quieres vender la piezas devuelve el camión", type = "success", timeout = 5000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		Spawn()
	SetNewWaypoint(venta.x,venta.y)
	final = CreatePed(1, Config.NPCHash1, -559.57, -1690.93, 18.23, 212.5, false, true)
	SetCurrentPedWeapon(capo, -2067956739, true)
	LoadAnimDict("gestures@m@standing@casual")
	TaskPlayAnim(final, "gestures@m@standing@casual", "gesture_hello", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	    Citizen.Wait(1000)
		DeleteEntity(final)
    end
end



function MotoPartsRemoval()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
	
    SetVehicleNumberPlateText(vehicle, "Robado")
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, false)
    exports['progressBars']:startUI(Config.DeletingVehicleTime, "Desguazando moto")
    Citizen.Wait(Config.DeletingVehicleTime)
    if ChoppingInProgress == true then
        DeleteVehicle()
		TriggerServerEvent("esx_chatarrero:moto")
        exports.pNotify:SendNotification({text = "Vehiculo desguazado, ahora coge ese camión y ve a vender las piezas. Si no quieres vender la piezas devuelve el camión", type = "success", timeout = 5000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		Spawn()
	SetNewWaypoint(venta.x,venta.y)
	final = CreatePed(1, Config.NPCHash1, -559.57, -1690.93, 18.23, 212.5, false, true)
	SetCurrentPedWeapon(capo, -2067956739, true)
	LoadAnimDict("gestures@m@standing@casual")
	TaskPlayAnim(final, "gestures@m@standing@casual", "gesture_hello", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	    Citizen.Wait(1000)
		DeleteEntity(final)
    end
end







function DeleteVehicle()
    if IsDriver() then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            ESX.Game.DeleteVehicle(vehicle)
        end
        --TriggerServerEvent("esx_chatarrero:rewards", rewards)
    end
end

function Spawn()
	Citizen.Wait(0)

	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('mule3')

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	local spawned_car = CreateVehicle(vehicle, spawncamion.x,spawncamion.y,spawncamion.z, spawncamion.h, -534.53, -1717.0, 19.12, 292.16, true, false)

	local plate = ""
    SetVehicleNumberPlateText(spawned_car, plate)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleLivery(spawned_car, 2)
	--SetPedIntoVehicle(myPed, spawned_car, - 1)
	--SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end




AddEventHandler('esx_chatarrero:hasEnteredMarker', function(zone)
    if zone == 'Chopshop' and IsDriver() then
        CurrentAction     = 'Chopshop'
        CurrentActionMsg  = _U('press_to_chop')
        CurrentActionData = {}
    end
end)

AddEventHandler('esx_chatarrero:hasExitedMarker', function(zone)
    if menuOpen then
        ESX.UI.Menu.CloseAll()
    end

    if zone == 'Chopshop' then

        if ChoppingInProgress == true then
            exports.pNotify:SendNotification({text = "Te has alejado de los chatarreros.", type = "error", timeout = 1000, layout = "centerRight", queue = "right", killer = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end
    ChoppingInProgress        = false


    CurrentAction = nil
end)

function CreateBlipCircle(coords, text, radius, color, sprite)

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    if Config.EnableBlips == true then
        for k,zone in pairs(Config.Zones) do
            CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
        end
    end
end)

Citizen.CreateThread(function()
    if Config.NPCEnable == true then
        RequestModel(Config.NPCHash)
        RequestModel(Config.NPCHash1)
        while not HasModelLoaded(Config.NPCHash) do
            Wait(1)
        end
        --PROVIDER
        vendedor = CreatePed(1, Config.NPCHash, Config.NPCShop.x, Config.NPCShop.y, Config.NPCShop.z, Config.NPCShop.h, false, true)
        SetBlockingOfNonTemporaryEvents(vendedor, true)
        SetPedDiesWhenInjured(vendedor, false)
        SetPedCanPlayAmbientAnims(vendedor, true)
        SetPedCanRagdollFromPlayerImpact(vendedor, false)
        SetEntityInvincible(vendedor, true)
        FreezeEntityPosition(vendedor, true)
        TaskStartScenarioInPlace(vendedor, "WORLD_HUMAN_SMOKING", 0, true);
    else
    end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true
        for k,v in pairs(Config.Zones) do
            if Config.MarkerType ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                letSleep = false
            end
        end
        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords      = GetEntityCoords(PlayerPedId())
        local isInMarker  = false
        local currentZone = nil
        local letSleep = true
        for k,v in pairs(Config.Zones) do
            if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                isInMarker  = true
                currentZone = k
            end
        end
        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker = true
            LastZone                = currentZone
            TriggerEvent('esx_chatarrero:hasEnteredMarker', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_chatarrero:hasExitedMarker', LastZone)
        end
    end
end)

-- Key controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            ESX.ShowHelpNotification(CurrentActionMsg)
            if IsControlJustReleased(0, 38) then
                if IsDriver() then
                    if CurrentAction == 'Chopshop' then
                        ChopVehicle()
                    end
                end
                CurrentAction = nil
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
	end
	end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

--Only if Config.CallCops = true
GetPlayerName()


RegisterNetEvent('outlawChopNotify')
AddEventHandler('outlawChopNotify', function(alert)
    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        ESX.ShowAdvancedNotification(_U('911'), _U('chop'), _U('call'), 'CHAR_CALL911', 7)
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local timer = 1 --in minutes - Set the time during the player is outlaw
local blipTime = 35 --in second
local showcopsmisbehave = true --show notification when cops steal too
local timing = timer * 60000 --Don't touche it

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(PlayerPedId(), "IsOutlaw", 1)
            return
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(100)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        if pedIsTryingToChopVehicle then
            DecorSetInt(PlayerPedId(), "IsOutlaw", 2)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave == false then
            elseif PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave then
                TriggerServerEvent('ChoppingInProgressPos', plyPos.x, plyPos.y, plyPos.z)
                TriggerServerEvent('ChopInProgress')
                Wait(3000)
                pedIsTryingToChopVehicle = false
            end
        end
    end
end)

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

RegisterNetEvent('Choplocation')
AddEventHandler('Choplocation', function(tx, ty, tz)
    if PlayerData.job.name == 'police' then
        local transT = 250
        local Blip = AddBlipForCoord(tx, ty, tz)
        SetBlipSprite(Blip,  10)
        SetBlipColour(Blip,  1)
        SetBlipAlpha(Blip,  transT)
        SetBlipAsShortRange(Blip,  false)
        while transT ~= 0 do
            Wait(blipTime * 4)
            transT = transT - 1
            SetBlipAlpha(Blip,  transT)
            if transT == 0 then
                SetBlipSprite(Blip,  2)
                return
            end
        end
    end
end)

RegisterNetEvent('chopEnable')
AddEventHandler('chopEnable', function()
    pedIsTryingToChopVehicle = true
end)

Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)



  local coords = GetEntityCoords(PlayerPedId())
  	local _source = source
  local distance = Vdist(coords.x, coords.y, coords.z, Config.Spawn.unspawn.coords.x, Config.Spawn.unspawn.coords.y, Config.Spawn.unspawn.coords.z)

  if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, Config.Spawn.unspawn.coords.x, Config.Spawn.unspawn.coords.y, Config.Spawn.unspawn.coords.z, true) < 10) then
		local playerPed = PlayerPedId()
         DrawMarker(1, Config.Spawn.unspawn.coords.x, Config.Spawn.unspawn.coords.y, Config.Spawn.unspawn.coords.z, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.6001,255,255,51, 200, 0, 0, 0, 0)


          if GetDistanceBetweenCoords(coords, Config.Spawn.unspawn.coords, true) < 1.5 then
          	StatusReady = true

          	if StatusReady == true  then
            ESX.ShowHelpNotification(('Pulsa E para guardar el camión.'))

            end
            
            if IsControlJustReleased(1,  38) and StatusReady == true  then
	        if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0x85A5B471)  then
             ExecuteCommand('dv')
			 Citizen.Wait(5000)
			 else
			  exports.pNotify:SendNotification({text = "Este vehiculo no es el camion del trabajo", type = "error", timeout = 2000, layout = "centerRight", queue = "right", killer = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
			end         
          end
  end
  end
end
end)