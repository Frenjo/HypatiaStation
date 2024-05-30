//the core [tokamaka generator] big funky solenoid, it generates an EM field

/*
when the core is turned on, it generates [creates] an electromagnetic field
the em field attracts plasma, and suspends it in a controlled torus (doughnut) shape, oscillating around the core

the field strength is directly controllable by the user
field strength = sqrt(energy used by the field generator)

the size of the EM field = field strength / k
(k is an arbitrary constant to make the calculated size into tilewidths)

1 tilewidth = below 5T
3 tilewidth = between 5T and 12T
5 tilewidth = between 10T and 25T
7 tilewidth = between 20T and 50T
(can't go higher than 40T)

energy is added by a gyrotron, and lost when plasma escapes
energy transferred from the gyrotron beams is reduced by how different the frequencies are (closer frequencies = more energy transferred)

frequency = field strength * (stored energy / stored moles of plasma) * x
(where x is an arbitrary constant to make the frequency something realistic)
the gyrotron beams' frequency and energy are hardcapped low enough that they won't heat the plasma much

energy is generated in considerable amounts by fusion reactions from injected particles
fusion reactions only occur when the existing energy is above a certain level, and it's near the max operating level of the gyrotron. higher energy reactions only occur at higher energy levels
a small amount of energy constantly bleeds off in the form of radiation

the field is constantly pulling in plasma from the surrounding [local] atmosphere
at random intervals, the field releases a random percentage of stored plasma in addition to a percentage of energy as intense radiation

the amount of plasma is a percentage of the field strength, increased by frequency
*/

/*
- VALUES -

max volume of plasma storeable by the field = the total volume of a number of tiles equal to the (field tilewidth)^2

*/

#define MAX_FIELD_FREQ 1000
#define MIN_FIELD_FREQ 1
#define MAX_FIELD_STR 1000
#define MIN_FIELD_STR 1

#define RUST_STATE_ZERO 0
#define RUST_STATE_ONE 1
#define RUST_STATE_TWO 2

/obj/machinery/power/rust_core
	name = "RUST Tokamak core"
	desc = "Enormous solenoid for generating extremely high power electromagnetic fields"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "core0"
	anchored = FALSE
	density = TRUE

	power_state = USE_POWER_IDLE
	power_usage = list(
		USE_POWER_IDLE = 50,
		USE_POWER_ACTIVE = 500 //multiplied by field strength
	)

	req_access = list(ACCESS_ENGINE)

	var/obj/effect/rust_em_field/owned_field
	var/field_strength = 1//0.01
	var/field_frequency = 1
	var/id_tag = "allan, don't forget to set the ID of this one too"

	var/cached_power_avail = 0

	var/state = RUST_STATE_ZERO
	var/locked = 1
	var/remote_access_enabled = 1

/obj/machinery/power/rust_core/process()
	if(stat & BROKEN || !powernet)
		Shutdown()

	cached_power_avail = avail()
	//luminosity = round(owned_field.field_strength/10)
	//luminosity = max(luminosity,1)

/obj/machinery/power/rust_core/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	user.visible_message(
		SPAN_WARNING("[user] emags \the [src]."),
		SPAN_WARNING("You short out the lock on \the [src].")
	)
	emagged = TRUE
	locked = FALSE
	return TRUE

/obj/machinery/power/rust_core/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		if(isnotnull(owned_field))
			FEEDBACK_TURN_OFF_FIRST(user)
			return TRUE

		switch(state)
			if(RUST_STATE_ZERO)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [src]'s reinforcing bolts to the floor."),
					SPAN_NOTICE("You secure the external reinforcing bolts to the floor."),
					SPAN_INFO("You hear a ratchet.")
				)
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				state = RUST_STATE_ONE
				anchored = TRUE
			if(RUST_STATE_ONE)
				user.visible_message(
					SPAN_NOTICE("[user] unsecures \the [src]'s reinforcing bolts from the floor."),
					SPAN_NOTICE("You undo the external reinforcing bolts."),
					SPAN_INFO("You hear a ratchet.")
				)
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				state = RUST_STATE_ZERO
				anchored = FALSE
			if(RUST_STATE_TWO)
				to_chat(user, SPAN_WARNING("\The [src] needs to be unwelded from the floor."))
		return TRUE

	if(iswelder(tool))
		var/obj/item/weldingtool/welder = tool
		if(isnotnull(owned_field))
			FEEDBACK_TURN_OFF_FIRST(user)
			return TRUE

		switch(state)
			if(RUST_STATE_ZERO)
				to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
			if(RUST_STATE_ONE)
				if(welder.remove_fuel(0, user))
					user.visible_message(
						SPAN_NOTICE("[user] starts to weld \the [src] to the floor."),
						SPAN_NOTICE("You start to weld \the [src] to the floor."),
						SPAN_WARNING("You hear welding.")
					)
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					if(do_after(user, 2 SECONDS))
						if(isnotnull(src) && welder.welding)
							user.visible_message(
								SPAN_NOTICE("[user] welds \the [src] to the floor."),
								SPAN_NOTICE("You weld \the [src] to the floor.")
							)
							state = RUST_STATE_TWO
							connect_to_network()
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			if(RUST_STATE_TWO)
				if(welder.remove_fuel(0, user))
					user.visible_message(
						SPAN_NOTICE("[user] starts to cut \the [src] free from the floor."),
						SPAN_NOTICE("You start to cut \the [src] free from the floor."),
						SPAN_WARNING("You hear welding.")
					)
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					if(do_after(user, 2 SECONDS))
						if(isnotnull(src) && welder.welding)
							user.visible_message(
								SPAN_NOTICE("[user] cuts \the [src] free from the floor."),
								SPAN_NOTICE("You cut \the [src] free from the floor.")
							)
							state = RUST_STATE_ONE
							disconnect_from_network()
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
		return TRUE

	return ..()

/obj/machinery/power/rust_core/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/pda))
		if(emagged)
			FEEDBACK_LOCK_SEEMS_BROKEN(user)
			return TRUE
		if(allowed(user))
			if(owned_field)
				locked = !locked
				FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
			else
				locked = FALSE //just in case it somehow gets locked
				to_chat(user, SPAN_WARNING("The controls can only be locked when \the [src] is online."))
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	return ..()

/obj/machinery/power/rust_core/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/power/rust_core/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/power/rust_core/interact(mob/user)
	if(stat & BROKEN)
		user.unset_machine()
		user << browse(null, "window=core_gen")
		return
	if(!issilicon(user) && !in_range(src, user))
		user.unset_machine()
		user << browse(null, "window=core_gen")
		return

	var/dat = ""
	if(stat & NOPOWER || locked || state != RUST_STATE_TWO)
		dat += "<i>The console is dark and nonresponsive.</i>"
	else
		dat += "<b>RUST Tokamak pattern Electromagnetic Field Generator</b><br>"
		dat += "<b>Device ID tag: </b> [id_tag ? id_tag : "UNSET"] <a href='byond:://?src=\ref[src];new_id_tag=1'>\[Modify\]</a><br>"
		dat += "<a href='byond:://?src=\ref[src];toggle_active=1'>\[[owned_field ? "Deactivate" : "Activate"]\]</a><br>"
		dat += "<a href='byond:://?src=\ref[src];toggle_remote=1'>\[[remote_access_enabled ? "Disable remote access to this device" : "Enable remote access to this device"]\]</a><br>"
		dat += "<hr>"
		dat += "<b>Field strength:</b> [field_strength]Wm^3<br>"
		dat += "<a href='byond:://?src=\ref[src];str=-1000'>\[----\]</a> \
		<a href='byond:://?src=\ref[src];str=-100'>\[--- \]</a> \
		<a href='byond:://?src=\ref[src];str=-10'>\[--  \]</a> \
		<a href='byond:://?src=\ref[src];str=-1'>\[-   \]</a> \
		<a href='byond:://?src=\ref[src];str=1'>\[+   \]</a> \
		<a href='byond:://?src=\ref[src];str=10'>\[++  \]</a> \
		<a href='byond:://?src=\ref[src];str=100'>\[+++ \]</a> \
		<a href='byond:://?src=\ref[src];str=1000'>\[++++\]</a><br>"

		dat += "<b>Field frequency:</b> [field_frequency]MHz<br>"
		dat += "<a href='byond:://?src=\ref[src];freq=-1000'>\[----\]</a> \
		<a href='byond:://?src=\ref[src];freq=-100'>\[--- \]</a> \
		<a href='byond:://?src=\ref[src];freq=-10'>\[--  \]</a> \
		<a href='byond:://?src=\ref[src];freq=-1'>\[-   \]</a> \
		<a href='byond:://?src=\ref[src];freq=1'>\[+   \]</a> \
		<a href='byond:://?src=\ref[src];freq=10'>\[++  \]</a> \
		<a href='byond:://?src=\ref[src];freq=100'>\[+++ \]</a> \
		<a href='byond:://?src=\ref[src];freq=1000'>\[++++\]</a><br>"

		var/font_colour = "green"
		var/active_power_usage = power_usage[USE_POWER_ACTIVE]
		if(cached_power_avail < active_power_usage)
			font_colour = "red"
		else if(cached_power_avail < active_power_usage * 2)
			font_colour = "orange"
		dat += "<b>Power status:</b> <font color=[font_colour]>[active_power_usage]/[cached_power_avail] W</font><br>"

	user << browse(dat, "window=core_gen;size=500x300")
	onclose(user, "core_gen")
	user.set_machine(src)

/obj/machinery/power/rust_core/Topic(href, href_list)
	if(href_list["str"])
		var/dif = text2num(href_list["str"])
		field_strength = min(max(field_strength + dif, MIN_FIELD_STR), MAX_FIELD_STR)
		power_usage[USE_POWER_ACTIVE] = 5 * field_strength	//change to 500 later
		if(owned_field)
			owned_field.ChangeFieldStrength(field_strength)

	if(href_list["freq"])
		var/dif = text2num(href_list["freq"])
		field_frequency = min(max(field_frequency + dif, MIN_FIELD_FREQ), MAX_FIELD_FREQ)
		if(owned_field)
			owned_field.ChangeFieldFrequency(field_frequency)

	if(href_list["toggle_active"])
		if(!Startup())
			Shutdown()

	if(href_list["toggle_remote"])
		remote_access_enabled = !remote_access_enabled

	if(href_list["new_id_tag"])
		if(usr)
			id_tag = input("Enter a new ID tag", "Tokamak core ID tag", id_tag) as text|null

	if(href_list["close"])
		usr << browse(null, "window=core_gen")
		usr.unset_machine()

	if(href_list["extern_update"])
		var/obj/machinery/computer/rust_core_control/C = locate(href_list["extern_update"])
		if(C)
			C.updateDialog()

	src.updateDialog()

/obj/machinery/power/rust_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(src.loc)
	owned_field.ChangeFieldStrength(field_strength)
	owned_field.ChangeFieldFrequency(field_frequency)
	icon_state = "core1"
	//luminosity = 1
	light_range = 1
	update_power_state(USE_POWER_ACTIVE)
	return 1

/obj/machinery/power/rust_core/proc/Shutdown()
	//todo: safety checks for field status
	if(owned_field)
		icon_state = "core0"
		qdel(owned_field)
		//luminosity = 0
		light_range = 0
		update_power_state(USE_POWER_IDLE)

/obj/machinery/power/rust_core/proc/AddParticles(name, quantity = 1)
	if(owned_field)
		owned_field.AddParticles(name, quantity)
		return 1
	return 0

/obj/machinery/power/rust_core/bullet_act(obj/item/projectile/Proj)
	if(owned_field)
		return owned_field.bullet_act(Proj)
	return 0

#undef RUST_STATE_ZERO
#undef RUST_STATE_ONE
#undef RUST_STATE_TWO

#undef MAX_FIELD_FREQ
#undef MIN_FIELD_FREQ
#undef MAX_FIELD_STR
#undef MIN_FIELD_STR