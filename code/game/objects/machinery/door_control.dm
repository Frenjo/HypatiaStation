/obj/machinery/door_control
	name = "remote door-control"
	desc = "It controls doors, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	desc = "A remote control-switch for a door."
	anchored = TRUE

	power_channel = ENVIRON
	power_usage = list(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 4
	)

	var/id = null
	var/range = 10
	var/normaldoorcontrol = FALSE
	var/desiredstate = 0 // Zero is closed, 1 is open.
	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties

	*/

	var/exposedwires = FALSE
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

/obj/machinery/door_control/attack_ai(mob/user as mob)
	if(wires & 2)
		return src.attack_hand(user)
	else
		to_chat(user, "Error, no route to host.")

/obj/machinery/door_control/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door_control/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	req_access = list()
	req_one_access = list()
	playsound(src, "sparks", 100, 1)
	emagged = TRUE
	return TRUE

/obj/machinery/door_control/attackby(obj/item/W, mob/user as mob)
	/* For later implementation
	if (istype(W, /obj/item/screwdriver))
	{
		if(wiresexposed)
			icon_state = "doorctrl0"
			wiresexposed = 0

		else
			icon_state = "doorctrl-open"
			wiresexposed = 1

		return
	}
	*/
	if(istype(W, /obj/item/detective_scanner))
		return

	return attack_hand(user)

/obj/machinery/door_control/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	if(stat & (NOPOWER | BROKEN))
		return

	if(!allowed(user) && (wires & 1))
		FEEDBACK_ACCESS_DENIED(user)
		flick("doorctrl-denied", src)
		return

	use_power(5)
	icon_state = "doorctrl1"
	add_fingerprint(user)

	if(normaldoorcontrol)
		for(var/obj/machinery/door/airlock/D in range(range))
			if(D.id_tag == src.id)
				if(specialfunctions & OPEN)
					if(D.density)
						spawn(0)
							D.open()
							return
					else
						spawn(0)
							D.close()
							return
				if(desiredstate == 1)
					if(specialfunctions & IDSCAN)
						D.aiDisabledIdScanner = TRUE
					if(specialfunctions & BOLTS)
						D.locked = TRUE
						D.update_icon()
					if(specialfunctions & SHOCK)
						D.secondsElectrified = -1
					if(specialfunctions & SAFE)
						D.safe = FALSE
				else
					if(specialfunctions & IDSCAN)
						D.aiDisabledIdScanner = FALSE
					if(specialfunctions & BOLTS)
						if(!D.isWireCut(4) && D.arePowerSystemsOn())
							D.locked = FALSE
							D.update_icon()
					if(specialfunctions & SHOCK)
						D.secondsElectrified = 0
					if(specialfunctions & SAFE)
						D.safe = TRUE

	else
		for(var/obj/machinery/door/poddoor/M in world)
			if(M.id == src.id)
				if(M.density)
					spawn(0)
						M.open()
						return
				else
					spawn(0)
						M.close()
						return

	desiredstate = !desiredstate
	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = "doorctrl0"

/obj/machinery/door_control/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"


/obj/machinery/driver_button
	name = "mass driver button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mass driver."
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 4
	)

	var/id = null
	var/active = FALSE

/obj/machinery/driver_button/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/driver_button/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/driver_button/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/detective_scanner))
		return
	return attack_hand(user)

/obj/machinery/driver_button/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	if(stat & (NOPOWER | BROKEN))
		return
	if(active)
		return
	add_fingerprint(user)

	use_power(5)

	active = TRUE
	icon_state = "launcheract"

	for(var/obj/machinery/door/poddoor/M in world)
		if(M.id == src.id)
			spawn(0)
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in world)
		if(M.id == src.id)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/poddoor/M in world)
		if(M.id == src.id)
			spawn(0)
				M.close()
				return

	icon_state = "launcherbtt"
	active = FALSE
	return