/*
 * Tanks
 */
#define TANK_MAX_RELEASE_PRESSURE (3 * ONE_ATMOSPHERE)
#define TANK_DEFAULT_RELEASE_PRESSURE 24

/obj/item/tank
	name = "tank"
	icon = 'icons/obj/atmospherics/tank.dmi'

	obj_flags = OBJ_FLAG_CONDUCT
	pressure_resistance = ONE_ATMOSPHERE * 5

	w_class = 3
	slot_flags = SLOT_BACK

	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 4

	var/datum/gas_mixture/air_contents = null
	var/distribute_pressure = ONE_ATMOSPHERE
	var/integrity = 3
	var/volume = 70
	var/manipulated_by = null	// Used by _onclick/hud/screen_objects.dm internals to determine if someone has messed with our tank or not.
								// If they have and we haven't scanned it with the PDA or gas analyser then we might just breath whatever they put in it.

	// The /decl/xgm_gas/X typepath of the gas which should trigger low air warnings.
	var/alert_gas_type = null
	// The amount of gas below which low air warnings will be triggered.
	var/alert_gas_amount = null

/obj/item/tank/New()
	. = ..()

	air_contents = new /datum/gas_mixture()
	air_contents.volume = volume //liters
	air_contents.temperature = T20C

/obj/item/tank/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/item/tank/Destroy()
	if(isnotnull(air_contents))
		QDEL_NULL(air_contents)
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/tank/process()
	//Allow for reactions
	air_contents.react()
	check_status()

/obj/item/tank/get_examine_text(mob/user)
	. = ..()
	var/obj/holder = src
	if(istype(loc, /obj/item/assembly))
		holder = loc
	if(!in_range(src, user))
		if(holder == src)
			. += SPAN_INFO("If you want any more information you'll need to get closer.")
		return

	var/celsius_temperature = air_contents.temperature-T0C
	var/descriptive = ""

	if(celsius_temperature < 20)
		descriptive = "cold"
	else if(celsius_temperature < 40)
		descriptive = "room temperature"
	else if(celsius_temperature < 80)
		descriptive = "lukewarm"
	else if(celsius_temperature < 100)
		descriptive = "warm"
	else if(celsius_temperature < 300)
		descriptive = "hot"
	else
		descriptive = "furiously hot"
	. += SPAN_INFO("It feels <em>[descriptive]</em>.")

	if(loc != user || isnull(alert_gas_type) || isnull(alert_gas_amount))
		return
	if(air_contents.gas[alert_gas_type] < alert_gas_amount)
		. += SPAN_DANGER("The meter indicates you are almost out of air!")
		SOUND_TO(user, 'sound/effects/alert.ogg')

/obj/item/tank/blob_act()
	if(prob(50))
		var/turf/location = loc
		if(!isturf(location))
			qdel(src)

		if(isnotnull(air_contents))
			location.assume_air(air_contents)

		qdel(src)

/obj/item/tank/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/gas_analyser))
		atmos_scan(tool, user, src)
		return TRUE
	return ..()

/obj/item/tank/attackby(obj/item/W, mob/user)
	. = ..()

	if(istype(loc, /obj/item/assembly))
		icon = loc

	if(istype(W, /obj/item/latexballon))
		var/obj/item/latexballon/LB = W
		LB.blow(src)
		add_fingerprint(user)

	if(istype(W, /obj/item/assembly_holder))
		bomb_assemble(W, user)

/obj/item/tank/attack_self(mob/user)
	if(isnull(air_contents))
		return

	ui_interact(user)

/obj/item/tank/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	var/using_internal = FALSE
	if(iscarbon(loc))
		var/mob/living/carbon/carbon = loc
		if(carbon.internal == src)
			using_internal = TRUE

	// this is the data which will be sent to the ui
	var/alist/data = alist(
		"tankPressure" = round(air_contents.return_pressure()),
		"releasePressure" = round(distribute_pressure),
		"defaultReleasePressure" = round(TANK_DEFAULT_RELEASE_PRESSURE),
		"maxReleasePressure" = round(TANK_MAX_RELEASE_PRESSURE),
		"valveOpen" = using_internal,
		"maskConnected" = FALSE
	)
	if(iscarbon(loc))
		var/mob/living/carbon/carbon = loc
		if(carbon.internal == src || (isnotnull(carbon.wear_mask) && HAS_ITEM_FLAGS(carbon.wear_mask, ITEM_FLAG_AIRTIGHT)))
			data["maskConnected"] = TRUE

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new /datum/nanoui(user, src, ui_key, "tanks.tmpl", "Tank", 500, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update()

/obj/item/tank/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE
	if(user.stat|| user.restrained())
		return FALSE
	if(loc != user)
		return FALSE

	if(topic.has("dist_p"))
		switch(topic.get("dist_p"))
			if("reset")
				distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
			if("max")
				distribute_pressure = TANK_MAX_RELEASE_PRESSURE
			else
				var/cp = topic.get_num("dist_p")
				distribute_pressure += cp
		distribute_pressure = min(max(round(distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)

	if(topic.has("stat") && iscarbon(user))
		var/mob/living/carbon/carbon = user
		if(carbon.internal == src)
			carbon.internal = null
			carbon.internals.icon_state = "internal0"
			to_chat(user, SPAN_INFO("You close the tank release valve."))
			carbon.internals?.icon_state = "internal0"
		else
			if(isnotnull(carbon.wear_mask) && HAS_ITEM_FLAGS(carbon.wear_mask, ITEM_FLAG_AIRTIGHT))
				carbon.internal = src
				to_chat(user, SPAN_INFO("You open \the [src] valve."))
				carbon.internals?.icon_state = "internal1"
			else
				to_chat(user, SPAN_INFO("You need something to connect to \the [src]."))

	add_fingerprint(user)

/obj/item/tank/remove_air(amount)
	return air_contents.remove(amount)

/obj/item/tank/return_air()
	return air_contents

/obj/item/tank/assume_air(datum/gas_mixture/giver)
	air_contents.merge(giver)

	check_status()
	return 1

/obj/item/tank/proc/remove_air_volume(volume_to_return)
	if(isnull(air_contents))
		return null

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < distribute_pressure)
		distribute_pressure = tank_pressure

	var/moles_needed = distribute_pressure * volume_to_return / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

	return remove_air(moles_needed)

//Handle exploding, leaking, and rupturing of the tank
/obj/item/tank/proc/check_status()
	if(isnull(air_contents))
		return 0

	var/pressure = air_contents.return_pressure()
	if(pressure > TANK_FRAGMENT_PRESSURE)
		if(!istype(loc, /obj/item/transfer_valve))
			message_admins("Explosive tank rupture! last key to touch the tank was [last_fingerprints].")
			log_game("Explosive tank rupture! last key to touch the tank was [last_fingerprints].")
		//to_world("\blue[x],[y] tank is exploding: [pressure] kPa")
		//Give the gas a chance to build up more pressure through reacting
		air_contents.react()
		air_contents.react()
		air_contents.react()
		pressure = air_contents.return_pressure()
		var/range = (pressure - TANK_FRAGMENT_PRESSURE) / TANK_FRAGMENT_SCALE
		range = min(range, GLOBL.max_explosion_range)		// was 8 - - - Changed to a configurable define -- TLE
		var/turf/epicenter = GET_TURF(src)

		//to_world("\blue Exploding Pressure: [pressure] kPa, intensity: [range]")

		explosion(epicenter, round(range * 0.25), round(range * 0.5), round(range), round(range * 1.5))
		qdel(src)

	else if(pressure > TANK_RUPTURE_PRESSURE)
		//to_world("\blue[x],[y] tank is rupturing: [pressure] kPa, integrity [integrity]")
		if(integrity <= 0)
			var/turf/open/T = GET_TURF(src)
			if(!istype(T))
				return
			T.assume_air(air_contents)
			playsound(src, 'sound/effects/spray.ogg', 10, 1, -3)
			qdel(src)
		else
			integrity--

	else if(pressure > TANK_LEAK_PRESSURE)
		//to_world("\blue[x],[y] tank is leaking: [pressure] kPa, integrity [integrity]")
		if(integrity <= 0)
			var/turf/open/T = GET_TURF(src)
			if(!istype(T))
				return
			var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(0.25)
			T.assume_air(leaked_gas)
		else
			integrity--

	else if(integrity < 3)
		integrity++

#undef TANK_MAX_RELEASE_PRESSURE
#undef TANK_DEFAULT_RELEASE_PRESSURE