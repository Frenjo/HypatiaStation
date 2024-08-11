//This is so damaged or burnt tiles or platings don't get remembered as the default tile
var/list/icons_to_ignore_at_floor_init = list(
	"damaged1", "damaged2", "damaged3", "damaged4",
	"damaged5", "panelscorched", "floorscorched1", "floorscorched2", "platingdmg1", "platingdmg2",
	"platingdmg3", "plating", "light_on", "light_on_flicker1", "light_on_flicker2",
	"light_on_clicker3", "light_on_clicker4", "light_on_clicker5", "light_broken",
	"light_on_broken", "light_off", "wall_thermite", "grass1", "grass2", "grass3", "grass4",
	"asteroid", "asteroid_dug",
	"asteroid0", "asteroid1", "asteroid2","asteroid3","asteroid4",
	"asteroid5", "asteroid6", "asteroid7", "asteroid8", "asteroid9", "asteroid10", "asteroid11", "asteroid12",
	"oldburning", "light-on-r", "light-on-y", "light-on-g", "light-on-b", "wood", "wood-broken", "carpet",
	"carpetcorner", "carpetside", "carpet", "ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5",
	"ironsand6", "ironsand7", "ironsand8", "ironsand9", "ironsand10", "ironsand11",
	"ironsand12", "ironsand13", "ironsand14", "ironsand15"
)

var/list/plating_icons = list(
	"plating", "platingdmg1", "platingdmg2", "platingdmg3", "asteroid", "asteroid_dug",
	"ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5", "ironsand6", "ironsand7",
	"ironsand8", "ironsand9", "ironsand10", "ironsand11",
	"ironsand12", "ironsand13", "ironsand14", "ironsand15"
)
var/list/wood_icons = list("wood", "wood-broken")

/turf/open/floor
	//Note to coders, the 'intact' var can no longer be used to determine if the floor is a plating or not.
	//Use the is_plating(), is_plasteel_floor() and is_light_floor() procs instead. --Errorage
	name = "floor"
	icon = 'icons/turf/floors.dmi'

	thermal_conductivity = 0.040
	heat_capacity = 10000

	explosion_resistance = 1

	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"

	var/lava = 0
	var/broken = 0
	var/burnt = 0
	var/mineral = /decl/material/steel
	var/tile_path = null

/turf/open/floor/New()
	. = ..()
	if(icon_state in icons_to_ignore_at_floor_init) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

/turf/open/floor/initialise()
	. = ..()
	update_special()
	update_icon()

//turf/open/floor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
//	if ((istype(mover, /obj/machinery/vehicle) && !(src.burnt)))
//		if (!( locate(/obj/machinery/mass_driver, src) ))
//			return 0
//	return ..()

/*
 * update_special()
 * This is used for special floor functionality such as carpet connections and siding on grass.
 */
/turf/open/floor/proc/update_special()
	return

/turf/open/floor/proc/update_icon()
	SHOULD_CALL_PARENT(TRUE)

	if(lava)
		return FALSE
	return TRUE

/turf/open/floor/proc/gets_drilled()
	return

/turf/open/floor/proc/break_tile_to_plating()
	make_plating()
	break_tile()

/turf/open/floor/proc/break_tile()
	SHOULD_CALL_PARENT(TRUE)

	if(broken)
		return FALSE
	broken = TRUE
	return TRUE

/turf/open/floor/proc/burn_tile()
	SHOULD_CALL_PARENT(TRUE)

	if(broken || burnt)
		return FALSE
	burnt = TRUE
	return TRUE

/*
 * Wrapper for ChangeTurf() which handles various floor-specific updates.
 */
/turf/open/floor/proc/make_floor(turf/open/floor/type_path)
	RETURN_TYPE(type_path)

	set_light(0)
	var/old_icon = icon_regular_floor
	var/old_dir = dir
	var/turf/open/floor/new_floor = ChangeTurf(type_path)
	new_floor.set_light(0)
	new_floor.icon_regular_floor = old_icon
	new_floor.set_dir(old_dir)
	new_floor.update_special()
	new_floor.update_icon()
	return new_floor

/turf/open/floor/proc/make_plating()
	RETURN_TYPE(/turf/open/floor/plating/metal)

	return make_floor(/turf/open/floor/plating/metal)