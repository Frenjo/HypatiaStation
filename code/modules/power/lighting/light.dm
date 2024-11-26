/proc/get_light_type_instance(light_type)
	. = GLOBL.light_type_cache[light_type]
	if(!.)
		. = new light_type()
		GLOBL.light_type_cache[light_type] = .

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = TRUE
	layer = 5					// They were appearing under mobs which is a little weird - Ostaf

	power_channel = LIGHT // Lights are calc'd via area so they dont need to be in the machine list.
	power_state = USE_POWER_ACTIVE
	power_usage = list(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 20
	)

	var/base_state = "tube"		// base description and icon_state
	var/on = FALSE				// TRUE if on, FALSE if off
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = FALSE
	var/light_type = /obj/item/light/tube		// the type of light item
	var/construct_type = /obj/machinery/light_frame
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = FALSE			// TRUE if rigged to explode

	//default lighting
	var/brightness_range	// luminosity when on, also used in power calculation
	var/brightness_power
	var/brightness_color
	var/list/lighting_modes

	var/current_mode = null

// the smaller bulb light fixture
/obj/machinery/light/small
	name = "small light fixture"
	icon_state = "bulb1"
	base_state = "bulb"
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	construct_type = /obj/machinery/light_frame/small

// the smaller emergency bulb light fixture
/obj/machinery/light/small/emergency
	name = "small emergency light fixture"
	light_type = /obj/item/light/bulb/red

/obj/machinery/light/spot
	name = "spotlight"
	light_type = /obj/item/light/tube/large

// create a new lighting fixture
/obj/machinery/light/New(atom/newloc, obj/machinery/light_frame/construct = null)
	. = ..(newloc)
	if(isnotnull(construct))
		status = LIGHT_EMPTY
		construct_type = construct.type
		construct.transfer_fingerprints_to(src)
		set_dir(construct.dir)
	else
		var/obj/item/light/L = get_light_type_instance(light_type)
		update_from_bulb(L)
		if(prob(L.broken_chance))
			broken(1)

/obj/machinery/light/initialise()
	. = ..()
	on = powered()
	update(0)

/obj/machinery/light/Destroy()
	var/area/A = GET_AREA(src)
	if(isnotnull(A))
		on = FALSE
	return ..()

/obj/machinery/light/update_icon()
	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = FALSE
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = FALSE
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = FALSE
	return

// examine verb
/obj/machinery/light/examine()
	var/fitting = get_fitting_name()
	if(isnotnull(usr) && !usr.stat)
		switch(status)
			if(LIGHT_OK)
				to_chat(usr, "[desc] It is turned [on? "on" : "off"].")
			if(LIGHT_EMPTY)
				to_chat(usr, "[desc] The [fitting] has been removed.")
			if(LIGHT_BURNED)
				to_chat(usr, "[desc] The [fitting] is burnt out.")
			if(LIGHT_BROKEN)
				to_chat(usr, "[desc] The [fitting] has been smashed.")

// attack with item - insert light (if right type), otherwise try to break the light
/obj/machinery/light/attackby(obj/item/W, mob/user)
	//Light replacer code
	if(istype(W, /obj/item/lightreplacer))
		var/obj/item/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/light))
		if(status != LIGHT_EMPTY)
			to_chat(user, "There is a [get_fitting_name()] already inserted.")
			return
		if(!istype(W, light_type))
			to_chat(user, "This type of light requires a [get_fitting_name()].")
			return

		to_chat(user, "You insert [W].")
		insert_bulb(W)
		add_fingerprint(user)

	// attempt to break the light
	//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N
	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)
		if(prob(1 + W.force * 5))
			user.visible_message(
				SPAN_WARNING("[user.name] smashed the light!"),
				"You hit the light, and it smashes!",
				"You hear the tinkle of breaking glass."
			)
			if(on && HAS_OBJ_FLAGS(W, OBJ_FLAG_CONDUCT))
				//if(!user.mutations & MUTATION_COLD_RESISTANCE)
				if(prob(12))
					electrocute_mob(user, GET_AREA(src), src, 0.3)
			broken()

		else
			to_chat(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(isscrewdriver(W)) //If it's a screwdriver open it.
			playsound(src, 'sound/items/Screwdriver.ogg', 75, 1)
			user.visible_message(
				"[user.name] opens [src]'s casing.",
				"You open [src]'s casing.",
				"You hear a noise."
			)
			new construct_type(loc, src)
			qdel(src)
			return

		to_chat(user, "You stick \the [W] into the light socket!")
		if(powered() && HAS_OBJ_FLAGS(W, OBJ_FLAG_CONDUCT))
			make_sparks(3, TRUE, src)
			//if(!user.mutations & MUTATION_COLD_RESISTANCE)
			if(prob(75))
				electrocute_mob(user, GET_AREA(src), src, rand(0.7, 1.0))

// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/powered()
	var/area/A = GET_AREA(src)
	return isnotnull(A) && A.lightswitch && ..(power_channel)

// ai attack - make lights flicker, because why not
/obj/machinery/light/attack_ai(mob/user)
	flicker(1)

/obj/machinery/light/attack_animal(mob/living/M)
	if(M.melee_damage_upper == 0)
		return
	if(status == LIGHT_EMPTY || status == LIGHT_BROKEN)
		to_chat(M, SPAN_WARNING("That object is useless to you."))
		return
	else if(status == LIGHT_OK || status == LIGHT_BURNED)
		M.visible_message(
			SPAN_WARNING("[M.name] smashed the light!"),
			"You hit the light, and it smashes!",
			"You hear the tinkle of breaking glass."
		)
		broken()
	return

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/attack_hand(mob/user)
	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, "There is no [get_fitting_name()] in this light.")
		return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = FALSE

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(isnotnull(H.gloves))
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					prot = (G.max_heat_protection_temperature > 360)
		else
			prot = TRUE

		if(prot || (MUTATION_COLD_RESISTANCE in user.mutations))
			to_chat(user, "You remove the light [get_fitting_name()].")
		else if(MUTATION_TELEKINESIS in user.mutations)
			to_chat(user, "You telekinetically remove the light [get_fitting_name()].")
		else
			to_chat(user, "You try to remove the light [get_fitting_name()], but it's too hot and you don't want to burn your hand.")
			return				// if burned, don't remove the light
	else
		to_chat(user, "You remove the light [get_fitting_name()].")

	// create a light tube/bulb item and put it in the user's hand
	user.put_in_active_hand(remove_bulb())	//puts it in our active hand

/obj/machinery/light/attack_tk(mob/user)
	if(status == LIGHT_EMPTY)
		to_chat(user, "There is no [get_fitting_name()] in this light.")
		return

	to_chat(user, "You telekinetically remove the light [get_fitting_name()].")
	remove_bulb()

// explosion effect
// destroy the whole light fixture or just shatter it
/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(75))
				broken()
		if(3.0)
			if(prob(50))
				broken()
	return

//blob effect
/obj/machinery/light/blob_act()
	if(prob(75))
		broken()

// timed process
// use power
/obj/machinery/light/process()
	if(on)
		use_power(light_range * LIGHT_POWER_FACTOR, LIGHT)

// called when area power state changes
/obj/machinery/light/power_change()
	spawn(10)
		seton(powered())

// called when on fire
/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))	//0% at <400C, 100% at >500C
		broken()

// update lighting
/obj/machinery/light/proc/update(trigger = 1)
	update_icon()
	if(on)
		update_power_state(USE_POWER_ACTIVE)
		var/changed = 0
		if(isnotnull(current_mode) && (current_mode in lighting_modes))
			changed = set_light(arglist(lighting_modes[current_mode]))
		else
			changed = set_light(brightness_range, brightness_power, brightness_color)

		if(trigger && changed)
			switch_check()
	else
		update_power_state(USE_POWER_OFF)
		set_light(0)

	power_usage[USE_POWER_ACTIVE] = ((light_range + light_power) * 10)

/obj/machinery/light/proc/switch_check()
	if(status != LIGHT_OK)
		return //already busted

	switchcount++
	if(rigged)
		log_admin("LOG: Rigged light explosion, last touched by [last_fingerprints]")
		message_admins("LOG: Rigged light explosion, last touched by [last_fingerprints]")

		explode()
	else if(prob(min(60, switchcount * switchcount * 0.01)))
		burn_out()

// attempt to set the light's mode
/obj/machinery/light/proc/set_mode(new_mode)
	if(current_mode != new_mode)
		current_mode = new_mode
		update(0)

// attempt to set the light's emergency lighting
/obj/machinery/light/proc/set_emergency_lighting(enable)
	if(enable)
		if(LIGHT_MODE_EMERGENCY in lighting_modes)
			set_mode(LIGHT_MODE_EMERGENCY)
			power_channel = ENVIRON
	else
		if(current_mode == LIGHT_MODE_EMERGENCY)
			set_mode(null)
			power_channel = initial(power_channel)

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(s)
	on = (s && status == LIGHT_OK)
	update()

/obj/machinery/light/proc/get_fitting_name()
	var/obj/item/light/L = light_type
	return initial(L.name)

/obj/machinery/light/proc/update_from_bulb(obj/item/light/L)
	status = L.status
	switchcount = L.switchcount
	rigged = L.rigged
	brightness_range = L.brightness_range
	brightness_power = L.brightness_power
	brightness_color = L.brightness_color
	lighting_modes = L.lighting_modes.Copy()

/obj/machinery/light/proc/insert_bulb(obj/item/light/L)
	update_from_bulb(L)
	qdel(L)

	on = powered()
	update()

	if(on && rigged)
		log_admin("LOG: Rigged light explosion, last touched by [last_fingerprints]")
		message_admins("LOG: Rigged light explosion, last touched by [last_fingerprints]")
		explode()

/obj/machinery/light/proc/remove_bulb()
	. = new light_type(loc, src)

	switchcount = 0
	status = LIGHT_EMPTY
	update()

/obj/machinery/light/proc/flicker(amount = rand(10, 20))
	if(flickering)
		return
	flickering = TRUE
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(status != LIGHT_OK)
					break
				on = !on
				update(0)
				sleep(rand(5, 15))
			on = (status == LIGHT_OK)
			update(0)
		flickering = FALSE

// break the light and make sparks if was on
/obj/machinery/light/proc/broken(skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			make_sparks(3, TRUE, src)
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	on = TRUE
	update()

// explode the light
/obj/machinery/light/proc/explode()
	var/turf/T = GET_TURF(src)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 0, 2, 2)
		sleep(1)
		qdel(src)

/obj/machinery/light/proc/burn_out()
	status = LIGHT_BURNED
	update_icon()
	set_light(0)