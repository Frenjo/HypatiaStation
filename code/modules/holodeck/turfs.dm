// Contains: Holographic Turfs
// Base
/turf/open/floor/holofloor
	thermal_conductivity = 0

/turf/open/floor/holofloor/attackby(obj/item/W, mob/user)
	return	// HOLOFLOOR DOES NOT GIVE A FUCK

/turf/open/floor/holofloor/burnmix
	name = "burn-mix floor"
	icon_state = "engine"
	initial_gases = list(/decl/xgm_gas/oxygen = 2500, /decl/xgm_gas/plasma = 5000)
	temperature = 370

// Grass
/turf/open/floor/holofloor/grass
	name = "lush grass"
	icon = 'icons/turf/floors/grass.dmi'
	icon_state = "grass1"
	tile_path = /obj/item/stack/tile/grass

/turf/open/floor/holofloor/grass/New()
	icon_state = "grass[pick("1", "2", "3", "4")]"
	..()
	spawn(4)
		update_icon()
		for(var/direction in GLOBL.cardinal)
			if(isfloorturf(get_step(src, direction)))
				var/turf/open/floor/FF = get_step(src, direction)
				FF.update_icon() //so siding get updated properly