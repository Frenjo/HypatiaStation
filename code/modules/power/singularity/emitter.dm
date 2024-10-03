//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/power/emitter
	name = "emitter"
	desc = "It is a heavy duty industrial laser."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINE_EQUIP)

	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 300
	)

	var/active = 0
	var/powered = 0
	var/fire_delay = 100
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0

	var/fire_mode = GUN_MODE_BEAM

/obj/machinery/power/emitter/initialise()
	. = ..()
	if(state == 2 && anchored)
		connect_to_network()

/obj/machinery/power/emitter/Destroy()
	message_admins("Emitter deleted at ([x],[y],[z] - <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("Emitter deleted at ([x],[y],[z])")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	return ..()

/*
// Pulse fire mode for emitters doesn't actually work yet, I'll re-enable this later. -Frenjo
/obj/machinery/power/emitter/AltClick(mob/user)
	if(!src.locked)
		if(fire_mode == GUN_MODE_BEAM)
			fire_mode = GUN_MODE_PULSE
		else
			fire_mode = GUN_MODE_BEAM
		to_chat(user, "You toggle the emitter's fire mode to [fire_mode == GUN_MODE_BEAM ? "beam" : "pulse"].")
	else
		FEEDBACK_CONTROLS_LOCKED(user)
	return
*/

/obj/machinery/power/emitter/verb/rotate()
	set category = PANEL_OBJECT
	set name = "Rotate"
	set src in oview(1)

	if(src.anchored || usr.stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/machinery/power/emitter/update_icon()
	var/active_power_usage = power_usage[USE_POWER_ACTIVE]
	if(active && powernet && avail((fire_mode == GUN_MODE_BEAM) ? active_power_usage : active_power_usage / 2))
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/power/emitter/attack_hand(mob/user)
	src.add_fingerprint(user)
	if(state == 2)
		if(!powernet)
			to_chat(user, "The emitter isn't connected to a wire.")
			return 1
		if(!src.locked)
			if(src.active == 1)
				src.active = 0
				to_chat(user, "You turn off the [src].")
				message_admins("Emitter turned off by [key_name(user, user.client)](<A href='byond://?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Emitter turned off by [user.ckey]([user]) in ([x],[y],[z])")
				investigate_log("turned <font color='red'>off</font> by [user.key]","singulo")
			else
				src.active = 1
				to_chat(user, "You turn on the [src].")
				src.shot_number = 0
				src.fire_delay = 100
				message_admins("Emitter turned on by [key_name(user, user.client)](<A href='byond://?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Emitter turned on by [user.ckey]([user]) in ([x],[y],[z])")
				investigate_log("turned <font color='green'>on</font> by [user.key]","singulo")
			update_icon()
		else
			FEEDBACK_CONTROLS_LOCKED(user)
	else
		to_chat(user, SPAN_WARNING("The [src] needs to be firmly secured to the floor first."))
		return 1

/obj/machinery/power/emitter/emp_act(severity)	//Emitters are hardened but still might have issues
//	add_load(1000)
/*	if((severity == 1)&&prob(1)&&prob(1))
		if(src.active)
			src.active = 0
			src.use_power = 1	*/
	return 1

/obj/machinery/containment_field/meteorhit()
	return 0

/obj/machinery/power/emitter/process()
	if(stat & BROKEN)
		return

	var/active_power_usage = power_usage[USE_POWER_ACTIVE]
	if(src.state != 2 || (!powernet && active_power_usage))
		src.active = 0
		update_icon()
		return

	if(((src.last_shot + src.fire_delay) <= world.time) && src.active == 1)
		var/actual_load = draw_power((fire_mode == GUN_MODE_BEAM) ? active_power_usage : active_power_usage / 2)
		if(actual_load >= active_power_usage) //does the laser have enough power to shoot?
			if(!powered)
				powered = 1
				update_icon()
				investigate_log("regained power and turned <font color='green'>on</font>", "singulo")
		else
			if(powered)
				powered = 0
				update_icon()
				investigate_log("lost power and turned <font color='red'>off</font>", "singulo")
			return

		src.last_shot = world.time
		if(src.shot_number < 3)
			src.fire_delay = 2
			src.shot_number ++
		else
			src.fire_delay = rand(20, 100)
			src.shot_number = 0

		var/obj/item/projectile/energy/A
		switch(fire_mode)
			if(GUN_MODE_BEAM)
				A = new /obj/item/projectile/energy/beam/emitter(src.loc)
			if(GUN_MODE_PULSE)
				A = new /obj/item/projectile/energy/pulse/emitter(src.loc)
		if(!A)
			return // Something went very wrong.

		playsound(src, 'sound/weapons/emitter.ogg', 25, 1)
		if(prob(35))
			make_sparks(5, TRUE, src)
		A.set_dir(src.dir)
		switch(dir)
			if(NORTH)
				A.yo = 20
				A.xo = 0
			if(EAST)
				A.yo = 0
				A.xo = 20
			if(WEST)
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
		A.process()	//TODO: Carn: check this out

/obj/machinery/power/emitter/attack_emag(obj/item/card/emag/emag, mob/user, uses)
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

/obj/machinery/power/emitter/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		if(active)
			FEEDBACK_TURN_OFF_FIRST(user)
			return TRUE
		switch(state)
			if(0)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [src] to the floor."),
					SPAN_NOTICE("You secure the external reinforcing bolts to the floor."),
					SPAN_INFO("You hear a ratchet.")
				)
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				anchored = TRUE
				state = 1
			if(1)
				user.visible_message(
					SPAN_NOTICE("[user] unsecures \the [src]'s reinforcing bolts from the floor."),
					SPAN_NOTICE("You undo the external reinforcing bolts."),
					SPAN_INFO("You hear a ratchet.")
				)
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				anchored = FALSE
				state = 0
			if(2)
				to_chat(user, SPAN_WARNING("\The [src] needs to be unwelded from the floor."))
		return TRUE

	if(iswelder(tool))
		var/obj/item/weldingtool/welder = tool
		if(active)
			FEEDBACK_TURN_OFF_FIRST(user)
			return TRUE
		switch(state)
			if(0)
				to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
			if(1)
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
							state = 2
							connect_to_network()
				else
					return
			if(2)
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
							state = 1
							disconnect_from_network()
				else
					return
		return TRUE

	return ..()

/obj/machinery/power/emitter/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/pda))
		if(emagged)
			FEEDBACK_LOCK_SEEMS_BROKEN(user)
			return TRUE
		if(allowed(user))
			if(active)
				locked = !locked
				FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
			else
				locked = 0 //just in case it somehow gets locked
				FEEDBACK_ONLY_LOCK_CONTROLS_WHEN_ACTIVE(user)
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE
	return ..()