Config = {} 
Config.UseESX = true
Config.DrawDistance       = 15.0 -- Distancia para ver el marker
Config.EnableBlips        = false -- Desactivar blip
Config.MarkerType         = 1    -- Cambiar marker
Config.MarkerColor        = { r = 0, g = 255, b = 255 } -- Cambiar el color del marker

Config.Locale             = 'en' -- Lenguaje
Config.CooldownMinutes    = 0 -- Minutos despues de desguazar 1 coche para poder hacer otro.

Config.CallCops           = false -- Para activar alertas a la policia.
Config.CallCopsPercent    = 1 -- (min1) Porcentaje de llamada a la policia=100%, 2=50%, 3=33%, 4=25%, 5=20%.
Config.CopsRequired       = 1 -- Policias requeridos

Config.NPCEnable          = true -- Para spawnear un NPC en la tienda.
Config.NPCHash			      = 68070371 -- Hash del npc tienda.
Config.NPCHash1			      = 1657546978 -- Hash del npc chatarrero.
Config.NPCShop	          = { x = -195.04, y = 6264.96, z = 30.49, h = 54.0 } -- Localización del NPC
Config.chatarrero	          = {  x = -556.08, y = -1694.79, z = 18.23} -- Localización del NPC

Config.GiveBlack          = false -- Dar dinero negro

-- Segundos de cada parte
--  1000 = 1 segundo
Config.DoorOpenFrontLeftTime      = 5000
Config.DoorBrokenFrontLeftTime    = 5000
Config.DoorOpenFrontRightTime     = 5000
Config.DoorBrokenFrontRightTime   = 5000
Config.DoorOpenRearLeftTime       = 5000
Config.DoorBrokenRearLeftTime     = 5000
Config.DoorOpenRearRightTime      = 5000
Config.DoorBrokenRearRightTime    = 5000
Config.DoorOpenHoodTime           = 5000
Config.DoorBrokenHoodTime         = 5000
Config.DoorOpenTrunkTime          = 5000
Config.DoorBrokenTrunkTime        = 5000
Config.DeletingVehicleTime        = 5000

Config.Zones = {
    Chopshop = {coords = vector3(-556.08, -1694.79, 18.23), name = _U('map_blip'), color = 49, sprite = 225, radius = 100.0, Pos = { x = -556.08, y = -1694.79, z = 18.23}, Size  = { x = 2.0, y = 2.0, z = 0.5 }, },
    Shop = {coords = vector3(-195.04, 6264.96, 30.49), name = _U('map_blip_shop'), color = 50, sprite = 120, radius = 25.0, Pos = { x = -195.04, y = 6264.96, z = 30.49}, Size  = { x = 1.0, y = 1.0, z = 0.2 }, },
}

Config.Items = {
    "bateria",
    "puerta",
    "llanta",
    "airbag",
    "radio",
    "capo"
}
Config.PumpModels = {
	[342457267] = true,
	[277255495] = true,
	[232216084] = true,
	[1158698200] = true,
	[-204842037] = true,
	[-60739707] = true,
	[-530738665] = true
}

Config.Itemsprice = {
    bateria = 150,
    puerta = 150,
    llanta = 200,
    radio= 150,
    capo = 250,
    airbag = 500
}

Config.Spawn = {
	unspawn = {coords = vector3(-534.53, -1717.0, 18.12)},
}