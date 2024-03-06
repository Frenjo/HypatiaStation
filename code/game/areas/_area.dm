/*
 * Area
 *
 * This file is a mass merge of area.dm, areas.dm and lighting_area.dm.
 *
 * This folder contains a list of definitions for all the areas in your station.
 *
 * Areas are organised into files by category or descriptor, and the format for adding new areas is as follows:
 *	/area/CATEGORY/OR/DESCRIPTOR/NAME	(you can make as many subdivisions as you want)
 *		name = "NICE NAME"			(not required but makes things really nice)
 *		icon = "ICON FILENAME"		(defaults to areas.dmi)
 *		icon_state = "NAME OF ICON"	(defaults to "unknown" (blank))
 *		requires_power = FALSE		(defaults to TRUE)
 *
 * I love places that make you realise how tiny you and your problems are. ~ Anonymous
*/
/area
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = DEFAULT_PLANE
	layer = DEFAULT_AREA_LAYER
	mouse_opacity = FALSE
	level = null

	/*
	 * Unique ID
	 */
	var/static/static_uid = 0
	var/uid

	/*
	 * Misc
	 */
	// Stores area-specific bitflag values.
	// Overridden on subtypes or manipulated with *_AREA_FLAGS(AREA, FLAGS) macros.
	var/area_flags
	var/turf/base_turf // The base turf type of the area, which can be used to override the z-level's base turf.

	/*
	 * Alerts / Alarms
	 */
	var/power_alarm = 1
	var/atmos_alarm = 0
	var/list/all_doors = list() // Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area.
	var/air_doors_activated = FALSE
	var/fire_alarm = FALSE
	var/evac_alarm = FALSE
	var/party_alarm = FALSE
	var/destruct_alarm = FALSE // Added this to make use of unused sprites. -Frenjo

	/*
	 * Power
	 */
	var/requires_power = TRUE
	var/always_unpowered = FALSE
	var/obj/machinery/power/apc/apc = null
	var/power_equip = TRUE
	var/power_light = TRUE
	var/power_environ = TRUE
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	/*
	 * Light Switch / Gravity
	 */
	var/lightswitch = TRUE
	var/has_gravity = TRUE

	/*
	 * Ambience
	 */
	var/list/ambience = list(
		'sound/ambience/ambigen1.ogg',
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/ambigen5.ogg',
		'sound/ambience/ambigen6.ogg',
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg',
		'sound/ambience/ambigen14.ogg'
	)

/area/New()
	icon_state = ""
	uid = ++static_uid

	. = ..()
	GLOBL.area_list.Add(src)

/area/initialise()
	. = ..()
	if(!requires_power || isnull(apc))
		power_light = FALSE		//rastaf0
		power_equip = FALSE		//rastaf0
		power_environ = FALSE	//rastaf0
	power_change()		// all machines set to current power level, also updates lighting icon

/area/proc/updateicon()
	if((fire_alarm || evac_alarm || party_alarm || destruct_alarm) && ((!requires_power) ? (!requires_power) : power_environ))
		if(fire_alarm && !evac_alarm && !party_alarm && !destruct_alarm)
			icon_state = "blue"
		else if(atmos_alarm && !fire_alarm && !evac_alarm && !party_alarm && !destruct_alarm)
			icon_state = "bluenew"
		else if(evac_alarm && !fire_alarm && !party_alarm && !destruct_alarm)
			icon_state = "red"
		else if(party_alarm && !fire_alarm && !evac_alarm && !destruct_alarm)
			icon_state = "party"
		else if(destruct_alarm && !fire_alarm && !party_alarm)
			icon_state = "_rednew"
		else
			icon_state = "blue-red"
	else
	//	new lighting behaviour with obj lights
		icon_state = null

/area/Entered(A)
	var/musVolume = 25
	var/sound = 'sound/ambience/ambigen1.ogg'

	if(!isliving(A))
		return

	var/mob/living/L = A
	if(isnull(L.ckey))
		return

	if(isnull(L.lastarea))
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if(!oldarea.has_gravity && newarea.has_gravity && IS_RUNNING(L)) // Being ready when you change areas gives you a chance to avoid falling all together.
		thunk(L)

	L.lastarea = newarea

	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks!
	// Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(isnull(L?.client) || !(L.client.prefs.toggles & SOUND_AMBIENCE))
		return

	if(!L.client.ambience_playing)
		L.client.ambience_playing = TRUE
		L << sound('sound/ambience/shipambience.ogg', repeat = TRUE, wait = FALSE, channel = 2, volume = 35)

	if(length(ambience) && prob(35))
		sound = pick(ambience)

		if(world.time > L.client.played + 600)
			L << sound(sound, repeat = FALSE, wait = FALSE, channel = 1, volume = musVolume)
			L.client.played = world.time

/area/proc/gravitychange(gravitystate = FALSE, area/A)
	A.has_gravity = gravitystate
	if(gravitystate)
		for(var/mob/living/carbon/human/M in A)
			thunk(M)

/area/proc/thunk(mob)
	if(isspace(get_turf(mob))) // Can't fall onto nothing.
		return

	if(ishuman(mob)) // Only humans can wear magboots, so we give them a chance to.
		var/mob/living/carbon/human/human = mob
		if(istype(human.shoes, /obj/item/clothing/shoes/magboots) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP))
			return
		if(IS_RUNNING(human)) // Only clumsy humans can fall on their asses.
			human.AdjustStunned(5)
			human.AdjustWeakened(5)
		else
			human.AdjustStunned(2)
			human.AdjustWeakened(2)

	to_chat(mob, "Gravity!")