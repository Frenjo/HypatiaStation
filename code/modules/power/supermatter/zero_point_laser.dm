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

	power_usage = list(
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
	set name = "Rotate"
	set category = "Object"
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
/*/obj/machinery/zero_point_emitter/attack_hand(mob/user as mob)
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
			user << "\red The controls are locked!"
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
		playsound(src, 'sound/weapons/emitter2.ogg', 25, 1)
		if(prob(35))
			var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread()
			s.set_up(5, 1, src)
			s.start()
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

/obj/machinery/zero_point_emitter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/wrench))
		if(active)
			to_chat(user, "Turn off the [src] first.")
			return
		switch(state)
			if(0)
				state = 1
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message(
					"[user.name] secures [name] to the floor.",
					"You secure the external reinforcing bolts to the floor.",
					"You hear a ratchet."
				)
				anchored = TRUE
			if(1)
				state = 0
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message(
					"[user.name] unsecures [name] reinforcing bolts from the floor.",
					"You undo the external reinforcing bolts.",
					"You hear a ratchet."
				)
				anchored = FALSE
			if(2)
				to_chat(user, SPAN_WARNING("The [name] needs to be unwelded from the floor."))
		return

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(active)
			to_chat(user, "Turn off the [src] first.")
			return
		switch(state)
			if(0)
				to_chat(user, SPAN_WARNING("The [name] needs to be wrenched to the floor."))
			if(1)
				if(WT.remove_fuel(0, user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message(
						"[user.name] starts to weld the [name] to the floor.",
						"You start to weld the [src] to the floor.",
						"You hear welding."
					)
					if(do_after(user, 20))
						if(isnull(src) || !WT.isOn())
							return
						state = 2
						to_chat(user, "You weld the [src] to the floor.")
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			if(2)
				if(WT.remove_fuel(0, user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message(
						"[user.name] starts to cut the [name] free from the floor.",
						"You start to cut the [src] free from the floor.",
						"You hear welding."
					)
					if(do_after(user, 20))
						if(isnull(src) || !WT.isOn())
							return
						state = 1
						to_chat(user, "You cut the [src] free from the floor.")
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/device/pda))
		if(emagged)
			to_chat(user, SPAN_WARNING("The lock seems to be broken."))
			return
		if(allowed(user))
			if(active)
				locked = !locked
				to_chat(user, "The controls are now [locked ? "locked" : "unlocked"].")
			else
				locked = FALSE //just in case it somehow gets locked
				to_chat(user, SPAN_WARNING("The controls can only be locked when the [src] is online."))
		else
			FEEDBACK_ACCESS_DENIED(user)
		return

	if(istype(W, /obj/item/card/emag) && !emagged)
		locked = FALSE
		emagged = TRUE
		user.visible_message(
			"[user.name] emags the [name].",
			SPAN_WARNING("You short out the lock.")
		)
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
		for(var/obj/machinery/computer/lasercon/comp in world)
			if(comp.id == id)
				comp.updateDialog()
	else if(href_list["online"] )
		active = !active
		//
		for(var/obj/machinery/computer/lasercon/comp in world)
			if(comp.id == id)
				comp.updateDialog()
	else if(href_list["freq"] )
		var/amt = text2num(href_list["freq"])
		var/new_freq = frequency + amt
		new_freq = max(new_freq, 1)		//lowest possible value
		new_freq = min(new_freq, 20000)	//highest possible value
		frequency = new_freq
		//
		for(var/obj/machinery/computer/lasercon/comp in world)
			if(comp.id == id)
				comp.updateDialog()