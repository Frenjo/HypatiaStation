/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/machines/computer.dmi'
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 300,
		USE_POWER_ACTIVE = 300
	)

	var/obj/item/circuitboard/circuit = null //if circuit==null, computer can't disassembly
	var/processing = 0

	var/light_range_on = 3
	var/light_power_on = 1

/obj/machinery/computer/initialise()
	. = ..()
	power_change()

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	return 1

/obj/machinery/computer/meteorhit(obj/O as obj)
	for(var/x in verbs)
		verbs.Remove(x)
	set_broken()
	var/datum/effect/system/smoke_spread/smoke = new /datum/effect/system/smoke_spread()
	smoke.set_up(5, 0, src)
	smoke.start()

/obj/machinery/computer/emp_act(severity)
	if(prob(20 / severity))
		set_broken()
	..()

/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(25))
				qdel(src)
				return
			if(prob(50))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		if(3.0)
			if(prob(25))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		else

/obj/machinery/computer/bullet_act(obj/item/projectile/Proj)
	if(prob(Proj.damage))
		set_broken()
	..()

/obj/machinery/computer/blob_act()
	if (prob(75))
		for(var/x in verbs)
			verbs -= x
		set_broken()
		density = FALSE

/obj/machinery/computer/update_icon()
	..()
	icon_state = initial(icon_state)
	// Broken
	if(stat & BROKEN)
		icon_state += "b"

	// Powered
	else if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/machinery/computer/power_change()
	. = ..()
	update_icon()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on)

/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/screwdriver) && isnotnull(circuit))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe(loc)
			var/obj/item/circuitboard/M = new circuit(A)
			A.circuit = M
			A.anchored = TRUE
			for(var/obj/C in src)
				C.loc = loc
			if(stat & BROKEN)
				FEEDBACK_BROKEN_GLASS_FALLS(user)
				new /obj/item/shard(loc)
				A.state = 3
				A.icon_state = "3"
			else
				FEEDBACK_DISCONNECT_MONITOR(user)
				A.state = 4
				A.icon_state = "4"
			qdel(src)
	else
		attack_hand(user)