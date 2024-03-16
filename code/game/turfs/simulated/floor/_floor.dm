#define LIGHTFLOOR_ON_BIT 4

#define LIGHTFLOOR_STATE_OK 0
#define LIGHTFLOOR_STATE_FLICKER 1
#define LIGHTFLOOR_STATE_BREAKING 2
#define LIGHTFLOOR_STATE_BROKEN 3
#define LIGHTFLOOR_STATE_BITS 3

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

/turf/simulated/floor
	//Note to coders, the 'intact' var can no longer be used to determine if the floor is a plating or not.
	//Use the is_plating(), is_plasteel_floor() and is_light_floor() procs instead. --Errorage
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"

	thermal_conductivity = 0.040
	heat_capacity = 10000

	explosion_resistance = 1

	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"

	var/lava = 0
	var/broken = 0
	var/burnt = 0
	var/mineral = MATERIAL_METAL
	var/floor_type = /obj/item/stack/tile/plasteel
	var/lightfloor_state // for light floors, this is the state of the tile. 0-7, 0x4 is on-bit - use the helper procs below

/turf/simulated/floor/New()
	. = ..()
	if(icon_state in icons_to_ignore_at_floor_init) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

//turf/simulated/floor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
//	if ((istype(mover, /obj/machinery/vehicle) && !(src.burnt)))
//		if (!( locate(/obj/machinery/mass_driver, src) ))
//			return 0
//	return ..()

/turf/simulated/floor/is_plasteel_floor()
	if(ispath(floor_type, /obj/item/stack/tile/plasteel))
		return 1
	else
		return 0

/turf/simulated/floor/is_plating()
	if(!floor_type)
		return 1
	return 0

/turf/simulated/floor/proc/get_lightfloor_state()
	return lightfloor_state & LIGHTFLOOR_STATE_BITS

/turf/simulated/floor/proc/get_lightfloor_on()
	return lightfloor_state & LIGHTFLOOR_ON_BIT

/turf/simulated/floor/proc/set_lightfloor_state(n)
	lightfloor_state = get_lightfloor_on() | (n & LIGHTFLOOR_STATE_BITS)

/turf/simulated/floor/proc/set_lightfloor_on(n)
	if(n)
		lightfloor_state |= LIGHTFLOOR_ON_BIT
	else
		lightfloor_state &= ~LIGHTFLOOR_ON_BIT

/turf/simulated/floor/proc/update_icon()
	if(lava)
		return

	if(is_plasteel_floor())
		if(!broken && !burnt)
			icon_state = icon_regular_floor
	else if(is_plating())
		if(!broken && !burnt)
			icon_state = icon_plating //Because asteroids are 'platings' too.

	/*spawn(1)
		if(istype(src,/turf/simulated/floor)) //Was throwing runtime errors due to a chance of it changing to space halfway through.
			if(air)
				update_visuals(air)*/

/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/proc/break_tile()
	if(broken)
		return
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1,2,3,4,5)]"
		broken = 1
	else if(is_plating())
		icon_state = "platingdmg[pick(1,2,3)]"
		broken = 1

/turf/simulated/floor/proc/burn_tile()
	if(broken || burnt)
		return
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1,2,3,4,5)]"
		burnt = 1
	else if(is_plasteel_floor())
		icon_state = "floorscorched[pick(1,2)]"
		burnt = 1
	else if(is_plating())
		icon_state = "panelscorched"
		burnt = 1

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating()
	if(!floor_type)
		return
	icon_plating = "plating"
	set_light(0)
	floor_type = null
	intact = 0
	broken = 0
	burnt = 0

	update_icon()
	levelupdate()

//This proc will make the turf a plasteel floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_plasteel_floor(obj/item/stack/tile/plasteel/T = null)
	broken = 0
	burnt = 0
	intact = 1
	set_light(0)
	if(isnotnull(T))
		if(istype(T, /obj/item/stack/tile/plasteel))
			floor_type = T.type
			if(icon_regular_floor)
				icon_state = icon_regular_floor
			else
				icon_state = "floor"
				icon_regular_floor = icon_state
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/plasteel
	icon_state = "floor"
	icon_regular_floor = icon_state

	update_icon()
	levelupdate()

//This proc will make the turf a light floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_light_floor(obj/item/stack/tile/light/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(isnotnull(T))
		if(istype(T, /obj/item/stack/tile/light))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/light

	update_icon()
	levelupdate()

//This proc will make a turf into a grass patch. Fun eh? Insert the grass tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_grass_floor(obj/item/stack/tile/grass/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(isnotnull(T))
		if(istype(T, /obj/item/stack/tile/grass))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/grass

	update_icon()
	levelupdate()

//This proc will make a turf into a wood floor. Fun eh? Insert the wood tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_wood_floor(obj/item/stack/tile/wood/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(isnotnull(T))
		if(istype(T, /obj/item/stack/tile/wood))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/wood

	update_icon()
	levelupdate()

//This proc will make a turf into a carpet floor. Fun eh? Insert the carpet tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_carpet_floor(obj/item/stack/tile/carpet/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(isnotnull(T))
		if(istype(T, /obj/item/stack/tile/carpet))
			floor_type = T.type
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_type = /obj/item/stack/tile/carpet

	update_icon()
	levelupdate()