/turf/simulated/floor/airless
	icon_state = "floor"
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/airless/New()
	..()
	name = "floor"

/turf/simulated/floor/airless/ceiling
	icon_state = "rockvault"

/turf/simulated/floor/light
	name = "Light floor"
	light_range = 5
	icon_state = "light_on"
	floor_type = /obj/item/stack/tile/light

/turf/simulated/floor/light/New()
	var/n = name //just in case commands rename it in the ..() call
	..()
	spawn(4)
		if(src)
			update_icon()
			name = n


/turf/simulated/floor/wood
	name = "floor"
	icon_state = "wood"
	floor_type = /obj/item/stack/tile/wood

/turf/simulated/floor/vault
	icon_state = "rockvault"

/turf/simulated/floor/vault/New(location, type)
	..()
	icon_state = "[type]vault"

/turf/simulated/wall/vault
	icon_state = "rockvault"

/turf/simulated/wall/vault/New(location, type)
	..()
	icon_state = "[type]vault"

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/engine/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		to_chat(user, SPAN_INFO("Removing rods..."))
		playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/simulated/floor)
			var/turf/simulated/floor/F = src
			F.make_plating()
			return

/turf/simulated/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

// ATMOSPHERICS TANK FLOORS
// Added these for the atmos tanks. -Frenjo
// Vacuum
/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// Oxygen
/turf/simulated/floor/engine/oxygen
	name = "o2 floor"
	oxygen = 100000
	nitrogen = 0

// Nitrogen
/turf/simulated/floor/engine/nitrogen
	name = "n2 floor"
	oxygen = 0
	nitrogen = 100000

// Air
/turf/simulated/floor/engine/air
	name = "air floor"
	oxygen = 2644
	nitrogen = 10580

// Hydrogen
/turf/simulated/floor/engine/hydrogen
	name = "h2 floor"
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/engine/hydrogen/New()
	..()
	assume_gas(GAS_HYDROGEN, 70000)

// Carbon Dioxide
/turf/simulated/floor/engine/co2
	name = "co2 floor"
	oxygen = 0
	nitrogen = 0
	carbon_dioxide = 50000

// Plasma
/turf/simulated/floor/engine/plasma
	name = "plasma floor"
	oxygen = 0
	nitrogen = 0
	toxins = 70000

// Oxygen Agent-B
/turf/simulated/floor/engine/oxygen_agent_b
	name = "o2a-b floor"
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/engine/oxygen_agent_b/New()
	..()
	assume_gas(GAS_OXYGEN_AGENT_B, 2000)

// Nitrous Oxide
/turf/simulated/floor/engine/n2o
	name = "n2o floor"
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/engine/n2o/New()
	..()
	assume_gas(GAS_SLEEPING_AGENT, 2000)
// END ATMOSPHERICS TANK FLOORS

/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	floor_type = null
	intact = 0

/turf/simulated/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/plating/airless/New()
	..()
	name = "plating"

/turf/simulated/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/simulated/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"


/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = TRUE
	density = TRUE
	blocks_air = 1

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/floor4	// Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"			// Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/floor/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/simulated/floor/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "Water"
	icon_state = "water"

/turf/simulated/floor/beach/water/New()
	..()
	overlays += image("icon" = 'icons/misc/beach.dmi', "icon_state" = "water5", "layer" = MOB_LAYER + 0.1)

/turf/simulated/floor/grass
	name = "Grass patch"
	icon_state = "grass1"
	floor_type = /obj/item/stack/tile/grass

/turf/simulated/floor/grass/New()
	icon_state = "grass[pick("1","2","3","4")]"
	..()
	spawn(4)
		if(src)
			update_icon()
			for(var/direction in cardinal)
				if(istype(get_step(src, direction), /turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src, direction)
					FF.update_icon() //so siding get updated properly

/turf/simulated/floor/carpet
	name = "Carpet"
	icon_state = "carpet"
	floor_type = /obj/item/stack/tile/carpet

/turf/simulated/floor/carpet/New()
	if(!icon_state)
		icon_state = "carpet"
	..()
	spawn(4)
		if(src)
			update_icon()
			for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
				if(istype(get_step(src, direction), /turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src, direction)
					FF.update_icon() //so siding get updated properly


/turf/simulated/floor/plating/ironsand/New()
	..()
	name = "Iron Sand"
	icon_state = "ironsand[rand(1, 15)]"

/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/plating/snow/ex_act(severity)
	return