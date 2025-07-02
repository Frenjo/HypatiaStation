// Originally from code/WorkInProgress/Cael_Aislinn/Supermatter/ZeroPointLaser.dm.
// Moved on 13/06/2023. -Frenjo

//new supermatter lasers
/obj/machinery/zero_point_emitter
	name = "zero-point laser"
	desc = "A super-powerful laser."
	icon = 'icons/obj/engine.dmi'
	icon_state = "laser"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINE)

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 300
	)

	var/active = FALSE
	var/fire_delay = 100
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0

	var/energy = 0.0001
	var/frequency = 1

	var/freq = 10000
	var/id

/obj/machinery/zero_point_emitter/verb/rotate()
	set category = PANEL_OBJECT
	set name = "Rotate"
	set src in oview(1)

	if(anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	set_dir(turn(dir, 90))
	return 1

/obj/machinery/zero_point_emitter/update_icon()
	if(active && !(stat & (NOPOWER | BROKEN)))
		icon_state = "laser"//"emitter_+a"
	else
		icon_state = "laser"//"emitter"

// Commented this out because I got the laser control computer working... Sort of. -Frenjo
/*/obj/machinery/zero_point_emitter/attack_hand(mob/user)
	src.add_fingerprint(user)
	if(state == 2)
		if(!src.locked)
			if(src.active==1)
				src.active = 0
				user << "You turn off the [src]."
				src.use_power = 1
			else
				src.active = 1
				user << "You turn on the [src]."
				src.shot_number = 0
				src.fire_delay = 100
				src.use_power = 2
			update_icon()
		else
			FEEDBACK_CONTROLS_LOCKED(user)
	else
		user << "\red The [src] needs to be firmly secured to the floor first."
		return 1*/

/obj/machinery/zero_point_emitter/emp_act(severity)//Emitters are hardened but still might have issues
	use_power(1000)
/*	if((severity == 1)&&prob(1)&&prob(1))
		if(src.active)
			src.active = 0
			src.use_power = 1	*/
	return 1

/obj/machinery/zero_point_emitter/process()
	if(stat & (NOPOWER | BROKEN))
		return
	if(state != 2)
		active = FALSE
		return
	if(((last_shot + fire_delay) <= world.time) && active)
		last_shot = world.time
		if(shot_number < 3)
			fire_delay = 2
			shot_number ++
		else
			fire_delay = rand(20, 100)
			shot_number = 0
		use_power(1000)
		var/obj/item/projectile/energy/beam/emitter/A = new /obj/item/projectile/energy/beam/emitter(loc)
		playsound(src, 'sound/weapons/gun/emitter2.ogg', 25, 1)
		if(prob(35))
			make_sparks(5, TRUE, src)
		A.set_dir(src.dir)
		A.starting = GET_TURF(src)
		switch(dir)
			if(NORTH)
				A.original = locate(x, y + 1, z)
			if(EAST)
				A.original = locate(x + 1, y, z)
			if(WEST)
				A.original = locate(x - 1, y, z)
			else // Any other
				A.original = locate(x, y - 1, z)
		A.process()

/obj/machinery/zero_point_emitter/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src]'s lock has already been shorted!"))
		return FALSE
	user.visible_message(
		SPAN_WARNING("[user.name] emags \the [src]."),
		SPAN_WARNING("You short out the lock.")
	)
	emagged = TRUE
	locked = FALSE
	return TRUE

/obj/machinery/zero_point_emitter/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		if(active)
			FEEDBACK_TURN_OFF_FIRST(user)
			return
		switch(state)
			if(0)
				state = 1
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message(
					SPAN_NOTICE("[user.name] secures \the [src]'s reinforcing bolts to the floor."),
					SPAN_NOTICE("You secure the external reinforcing bolts to the floor."),
					SPAN_INFO("You hear a ratchet.")
				)
				anchored = TRUE
			if(1)
				state = 0
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message(
					SPAN_NOTICE("[user.name] unsecures \the [src]'s reinforcing bolts from the floor."),
					SPAN_NOTICE("You undo the external reinforcing bolts."),
					SPAN_INFO("You hear a ratchet.")
				)
				anchored = FALSE
			if(2)
				to_chat(user, SPAN_WARNING("\The [src] needs to be unwelded from the floor."))
		return

	if(iswelder(W))
		var/obj/item/weldingtool/WT = W
		if(active)
			FEEDBACK_TURN_OFF_FIRST(user)
			return
		switch(state)
			if(0)
				to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
			if(1)
				if(WT.remove_fuel(0, user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message(
						SPAN_NOTICE("[user.name] starts to weld \the [src] to the floor."),
						SPAN_NOTICE("You start to weld \the [src] to the floor."),
						SPAN_WARNING("You hear welding.")
					)
					if(do_after(user, 20))
						if(isnull(src) || !WT.isOn())
							return
						state = 2
						to_chat(user, SPAN_NOTICE("You weld \the [src] to the floor."))
				else
					return
			if(2)
				if(WT.remove_fuel(0, user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message(
						SPAN_NOTICE("[user.name] starts to cut \the [src] free from the floor."),
						SPAN_NOTICE("You start to cut \the [src] free from the floor."),
						SPAN_WARNING("You hear welding.")
					)
					if(do_after(user, 20))
						if(isnull(src) || !WT.isOn())
							return
						state = 1
						to_chat(user, SPAN_NOTICE("You cut \the [src] free from the floor."))
				else
					return
		return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(emagged)
			FEEDBACK_LOCK_SEEMS_BROKEN(user)
			return
		if(allowed(user))
			if(active)
				locked = !locked
				FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
			else
				locked = FALSE //just in case it somehow gets locked
				FEEDBACK_ONLY_LOCK_CONTROLS_WHEN_ACTIVE(user)
		else
			FEEDBACK_ACCESS_DENIED(user)
		return

	..()

/obj/machinery/zero_point_emitter/power_change()
	..()
	update_icon()

/obj/machinery/zero_point_emitter/Topic(href, href_list)
	..()
	if(href_list["input"] )
		var/i = text2num(href_list["input"])
		var/d = i
		var/new_power = energy + d
		new_power = max(new_power, 0.0001)	//lowest possible value
		new_power = min(new_power, 0.01)	//highest possible value
		energy = new_power
		//
		for_no_type_check(var/obj/machinery/computer/lasercon/comp, GET_MACHINES_TYPED(/obj/machinery/computer/lasercon))
			if(comp.id == id)
				comp.updateDialog()
	else if(href_list["online"] )
		active = !active
		//
		for_no_type_check(var/obj/machinery/computer/lasercon/comp, GET_MACHINES_TYPED(/obj/machinery/computer/lasercon))
			if(comp.id == id)
				comp.updateDialog()
	else if(href_list["freq"] )
		var/amt = text2num(href_list["freq"])
		var/new_freq = frequency + amt
		new_freq = max(new_freq, 1)		//lowest possible value
		new_freq = min(new_freq, 20000)	//highest possible value
		frequency = new_freq
		//
		for_no_type_check(var/obj/machinery/computer/lasercon/comp, GET_MACHINES_TYPED(/obj/machinery/computer/lasercon))
			if(comp.id == id)
				comp.updateDialog()