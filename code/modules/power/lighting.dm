// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)

// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3

// Fixture construction stage values.
#define LIGHT_STAGE_ONE 1
#define LIGHT_STAGE_TWO 2
#define LIGHT_STAGE_THREE 3

// Lighting modes.
#define LIGHT_MODE_EMERGENCY "emergency_lighting"

var/global/list/light_type_cache = list()
/proc/get_light_type_instance(light_type)
	. = light_type_cache[light_type]
	if(!.)
		. = new light_type
		light_type_cache[light_type] = .

/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	layer = 5
	var/stage = LIGHT_STAGE_ONE
	var/fixture_type = /obj/machinery/light
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null

/obj/machinery/light_construct/New(atom/newloc, obj/machinery/light/fixture = null)
	..(newloc)
	if(fixture)
		fixture_type = fixture.type
		fixture.transfer_fingerprints_to(src)
		set_dir(fixture.dir)
		stage = LIGHT_STAGE_TWO
	update_icon()

/obj/machinery/light_construct/update_icon()
	switch(stage)
		if(LIGHT_STAGE_ONE)
			icon_state = "tube-construct-stage1"
		if(LIGHT_STAGE_TWO)
			icon_state = "tube-construct-stage2"
		if(LIGHT_STAGE_THREE)
			icon_state = "tube-empty"

/obj/machinery/light_construct/examine()
	..()
	if(!(usr in view(2)))
		return
	switch(src.stage)
		if(LIGHT_STAGE_ONE)
			to_chat(usr, "It's an empty frame.")
		if(LIGHT_STAGE_TWO)
			to_chat(usr, "It's wired.")
		if(LIGHT_STAGE_THREE)
			to_chat(usr, "The casing is closed.")

/obj/machinery/light_construct/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(istype(W, /obj/item/weapon/wrench))
		if(src.stage == LIGHT_STAGE_ONE)
			playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
			to_chat(usr, "You begin deconstructing [src].")
			if(!do_after(usr, 30))
				return
			new /obj/item/stack/sheet/metal(get_turf(src.loc), sheets_refunded)
			user.visible_message(
				"[user.name] deconstructs [src].",
				"You deconstruct [src].",
				"You hear a noise."
			)
			playsound(src, 'sound/items/Deconstruct.ogg', 75, 1)
			qdel(src)
		if(src.stage == LIGHT_STAGE_TWO)
			to_chat(usr, "You have to remove the wires first.")
			return

		if(src.stage == LIGHT_STAGE_THREE)
			to_chat(usr, "You have to unscrew the case first.")
			return

	if(istype(W, /obj/item/weapon/wirecutters))
		if(src.stage != LIGHT_STAGE_TWO)
			return
		src.stage = LIGHT_STAGE_ONE
		src.update_icon()
		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message(
			"[user.name] removes the wiring from [src].",
			"You remove the wiring from [src].",
			"You hear a noise."
		)
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		return

	if(istype(W, /obj/item/stack/cable_coil))
		if(src.stage != LIGHT_STAGE_ONE)
			return
		var/obj/item/stack/cable_coil/coil = W
		coil.use(1)
		src.update_icon()
		src.stage = LIGHT_STAGE_TWO
		user.visible_message(
			"[user.name] adds wires to [src].",
			"You add wires to [src]."
		)
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		if(src.stage == LIGHT_STAGE_TWO)
			src.update_icon()
			src.stage = LIGHT_STAGE_THREE
			user.visible_message(
				"[user.name] closes [src]'s casing.",
				"You close [src]'s casing.",
				"You hear a noise."
			)
			playsound(src, 'sound/items/Screwdriver.ogg', 75, 1)

			var/obj/machinery/light/newlight = new fixture_type(src.loc, src)
			newlight.set_dir(src.dir)
			src.transfer_fingerprints_to(newlight)
			qdel(src)
			return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	layer = 5
	stage = LIGHT_STAGE_ONE
	fixture_type = /obj/machinery/light/small
	sheets_refunded = 1

/obj/machinery/light_construct/small/update_icon()
	switch(stage)
		if(LIGHT_STAGE_ONE)
			icon_state = "bulb-construct-stage1"
		if(LIGHT_STAGE_TWO)
			icon_state = "bulb-construct-stage2"
		if(LIGHT_STAGE_THREE)
			icon_state = "bulb-empty"

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = 5					// They were appearing under mobs which is a little weird - Ostaf
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	var/on = 0					// 1 if on, 0 if off
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/weapon/light/tube		// the type of light item
	var/construct_type = /obj/machinery/light_construct
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode

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
	light_type = /obj/item/weapon/light/bulb
	construct_type = /obj/machinery/light_construct/small

// the smaller emergency bulb light fixture
/obj/machinery/light/small/emergency
	name = "small emergency light fixture"
	light_type = /obj/item/weapon/light/bulb/red

/obj/machinery/light/spot
	name = "spotlight"
	light_type = /obj/item/weapon/light/tube/large

// create a new lighting fixture
/obj/machinery/light/New(atom/newloc, obj/machinery/light_construct/construct = null)
	..(newloc)
	if(construct)
		status = LIGHT_EMPTY
		construct_type = construct.type
		construct.transfer_fingerprints_to(src)
		set_dir(construct.dir)
	else
		var/obj/item/weapon/light/L = get_light_type_instance(light_type)
		update_from_bulb(L)
		if(prob(L.broken_chance))
			broken(1)

/obj/machinery/light/initialize()
	..()
	on = powered()
	update(0)

/obj/machinery/light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
	return ..()

/obj/machinery/light/update_icon()
	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0
	return

// update lighting
/obj/machinery/light/proc/update(trigger = 1)
	update_icon()
	if(on)
		use_power = 2
		var/changed = 0
		if(current_mode && (current_mode in lighting_modes))
			changed = set_light(arglist(lighting_modes[current_mode]))
		else
			changed = set_light(brightness_range, brightness_power, brightness_color)

		if(trigger && changed)
			switch_check()
	else
		use_power = 0
		set_light(0)

	active_power_usage = ((light_range + light_power) * 10)

/obj/machinery/light/proc/switch_check()
	if(status != LIGHT_OK)
		return //already busted

	switchcount++
	if(rigged)
		log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
		message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

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

// examine verb
/obj/machinery/light/examine()
	var/fitting = get_fitting_name()
	if(usr && !usr.stat)
		switch(status)
			if(LIGHT_OK)
				to_chat(usr, "[desc] It is turned [on? "on" : "off"].")
			if(LIGHT_EMPTY)
				to_chat(usr, "[desc] The [fitting] has been removed.")
			if(LIGHT_BURNED)
				to_chat(usr, "[desc] The [fitting] is burnt out.")
			if(LIGHT_BROKEN)
				to_chat(usr, "[desc] The [fitting] has been smashed.")

/obj/machinery/light/proc/get_fitting_name()
	var/obj/item/weapon/light/L = light_type
	return initial(L.name)

/obj/machinery/light/proc/update_from_bulb(obj/item/weapon/light/L)
	status = L.status
	switchcount = L.switchcount
	rigged = L.rigged
	brightness_range = L.brightness_range
	brightness_power = L.brightness_power
	brightness_color = L.brightness_color
	lighting_modes = L.lighting_modes.Copy()

/obj/machinery/light/proc/insert_bulb(obj/item/weapon/light/L)
	update_from_bulb(L)
	qdel(L)

	on = powered()
	update()

	if(on && rigged)
		log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
		message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")
		explode()

/obj/machinery/light/proc/remove_bulb()
	. = new light_type(src.loc, src)

	switchcount = 0
	status = LIGHT_EMPTY
	update()

// attack with item - insert light (if right type), otherwise try to break the light
/obj/machinery/light/attackby(obj/item/W, mob/user)
	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/weapon/light))
		if(status != LIGHT_EMPTY)
			to_chat(user, "There is a [get_fitting_name()] already inserted.")
			return
		if(!istype(W, light_type))
			to_chat(user, "This type of light requires a [get_fitting_name()].")
			return

		to_chat(user, "You insert [W].")
		insert_bulb(W)
		src.add_fingerprint(user)

	// attempt to break the light
	//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N
	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)
		if(prob(1 + W.force * 5))
			to_chat(user, "You hit the light, and it smashes!")
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message(
					"[user.name] smashed the light!", 3,
					"You hear a tinkle of breaking glass", 2
				)
			if(on && (W.flags & CONDUCT))
				//if(!user.mutations & COLD_RESISTANCE)
				if(prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			to_chat(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/weapon/screwdriver)) //If it's a screwdriver open it.
			playsound(src, 'sound/items/Screwdriver.ogg', 75, 1)
			user.visible_message(
				"[user.name] opens [src]'s casing.",
				"You open [src]'s casing.",
				"You hear a noise."
			)
			new construct_type(src.loc, src)
			qdel(src)
			return

		to_chat(user, "You stick \the [W] into the light socket!")
		if(powered() && (W.flags & CONDUCT))
			var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			//if(!user.mutations & COLD_RESISTANCE)
			if(prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/powered()
	var/area/A = get_area(src)
	return A && A.lightswitch && ..(power_channel)

/obj/machinery/light/proc/flicker(amount = rand(10, 20))
	if(flickering)
		return
	flickering = 1
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
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)
	return

/obj/machinery/light/attack_animal(mob/living/M)
	if(M.melee_damage_upper == 0)
		return
	if(status == LIGHT_EMPTY || status == LIGHT_BROKEN)
		to_chat(M, SPAN_WARNING("That object is useless to you."))
		return
	else if(status == LIGHT_OK || status == LIGHT_BURNED)
		for(var/mob/O in viewers(src))
			O.show_message(
				SPAN_WARNING("[M.name] smashed the light!"), 3,
				"You hear a tinkle of breaking glass", 2
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
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))
			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 1

		if(prot > 0 || (COLD_RESISTANCE in user.mutations))
			to_chat(user, "You remove the light [get_fitting_name()].")
		else if(TK in user.mutations)
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

// break the light and make sparks if was on

/obj/machinery/light/proc/broken(skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	on = 1
	update()

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
#define LIGHTING_POWER_FACTOR 20		//20W per unit luminosity

/obj/machinery/light/process()
	if(on)
		use_power(light_range * LIGHTING_POWER_FACTOR, LIGHT)

// called when area power state changes
/obj/machinery/light/power_change()
	spawn(10)
		seton(powered())

// called when on fire
/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))		//0% at <400C, 100% at >500C
		broken()

// explode the light
/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
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

// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type
/obj/item/weapon/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = 1
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	m_amt = 60
	var/rigged = 0		// true if rigged to explode
	var/broken_chance = 2

	var/brightness_range = 2 //how much light it gives off
	var/brightness_power = 1
	var/brightness_color = "#FFFFFF"
	var/list/lighting_modes = list()

/obj/item/weapon/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	g_amt = 100

	brightness_range = 6
	brightness_power = 2
	brightness_color = "#FFFFFF"
	lighting_modes = list(
		LIGHT_MODE_EMERGENCY = list(l_range = 3, l_power = 1, l_color = "#d13e43"), 
	)

/obj/item/weapon/light/tube/large
	w_class = 2
	name = "large light tube"
	broken_chance = 5

	brightness_range = 8
	brightness_power = 2

/obj/item/weapon/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	g_amt = 100

	brightness_range = 4
	brightness_power = 2
	brightness_color = "#a0a080"
	lighting_modes = list(
		LIGHT_MODE_EMERGENCY = list(l_range = 4, l_power = 1, l_color = "#d13e43"),
	)

/obj/item/weapon/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	g_amt = 100

	brightness_range = 4
	brightness_power = 2

/obj/item/weapon/light/bulb/red
	color = "#d13e43"
	brightness_color = "#d13e43"

/obj/item/weapon/light/throw_impact(atom/hit_atom)
	..()
	shatter()

// update the icon state and description of the light
/obj/item/weapon/light/update_icon()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			desc = "A broken [name]."

/obj/item/weapon/light/New(atom/newloc, obj/machinery/light/fixture = null)
	..()
	if(fixture)
		status = fixture.status
		rigged = fixture.rigged
		switchcount = fixture.switchcount
		fixture.transfer_fingerprints_to(src)

		//shouldn't be necessary to copy these unless someone varedits stuff, but just in case
		brightness_range = fixture.brightness_range
		brightness_power = fixture.brightness_power
		brightness_color = fixture.brightness_color
		lighting_modes = fixture.lighting_modes.Copy()
	update_icon()

// attack bulb/tube with object
// if a syringe, can inject plasma to make it explode
/obj/item/weapon/light/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = I

		to_chat(user, "You inject the solution into the [src].")

		if(S.reagents.has_reagent("plasma", 5))
			log_admin("LOG: [user.name] ([user.ckey]) injected a light with plasma, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with plasma, rigging it to explode.")
			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm
/obj/item/weapon/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != "hurt")
		return

	shatter()

/obj/item/weapon/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message(
			SPAN_WARNING("[name] shatters."),
			SPAN_WARNING("You hear a small glass object shatter.")
		)
		status = LIGHT_BROKEN
		force = 5
		sharp = 1
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		update_icon()

#undef LIGHT_MODE_EMERGENCY

#undef LIGHT_STAGE_ONE
#undef LIGHT_STAGE_TWO
#undef LIGHT_STAGE_THREE

#undef LIGHT_OK
#undef LIGHT_EMPTY
#undef LIGHT_BROKEN
#undef LIGHT_BURNED