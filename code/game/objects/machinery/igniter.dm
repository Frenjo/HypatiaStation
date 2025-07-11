/obj/machinery/igniter
	name = "igniter"
	desc = "It's useful for igniting plasma."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "igniter1"
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 4
	)

	var/id = null
	var/on = TRUE

/obj/machinery/igniter/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/igniter/attack_paw(mob/user)
	if(IS_GAME_MODE(/datum/game_mode/monkey))
		return src.attack_hand(user)
	return

/obj/machinery/igniter/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(user)

	use_power(50)
	src.on = !src.on
	src.icon_state = "igniter[src.on]"
	return

/obj/machinery/igniter/process()	//ugh why is this even in process()?
	if(src.on && !(stat & NOPOWER))
		var/turf/location = src.loc
		if(isturf(location))
			location.hotspot_expose(1000, 500, 1)
	return 1

/obj/machinery/igniter/New()
	..()
	icon_state = "igniter[on]"

/obj/machinery/igniter/power_change()
	if(!(stat & NOPOWER))
		icon_state = "igniter[src.on]"
	else
		icon_state = "igniter0"

// Wall mounted remote-control igniter.
/obj/machinery/sparker
	name = "mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "migniter"
	anchored = TRUE

	var/id = null
	var/disable = FALSE
	var/last_spark = 0
	var/base_state = "migniter"

/obj/machinery/sparker/New()
	..()

/obj/machinery/sparker/power_change()
	if(powered() && disable == 0)
		stat &= ~NOPOWER
		icon_state = "[base_state]"
//		src.sd_SetLuminosity(2)
	else
		stat |= ~NOPOWER
		icon_state = "[base_state]-p"
//		src.sd_SetLuminosity(0)

/obj/machinery/sparker/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/detective_scanner))
		return
	if(isscrewdriver(W))
		add_fingerprint(user)
		src.disable = !src.disable
		if(src.disable)
			user.visible_message(
				SPAN_WARNING("[user] has disabled the [src]!"),
				SPAN_WARNING("You disable the connection to the [src].")
			)
			icon_state = "[base_state]-d"
		if(!src.disable)
			user.visible_message(
				SPAN_WARNING("[user] has reconnected the [src]!"),
				SPAN_WARNING("You fix the connection to the [src].")
			)
			if(src.powered())
				icon_state = "[base_state]"
			else
				icon_state = "[base_state]-p"

/obj/machinery/sparker/attack_ai()
	if(src.anchored)
		return src.ignite()
	else
		return

/obj/machinery/sparker/proc/ignite()
	if(!powered())
		return

	if(src.disable || (src.last_spark && world.time < src.last_spark + 50))
		return

	flick("[base_state]-spark", src)
	make_sparks(2, TRUE, src)
	src.last_spark = world.time
	use_power(1000)
	var/turf/location = src.loc
	if(isturf(location))
		location.hotspot_expose(1000, 500, 1)
	return 1

/obj/machinery/sparker/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	ignite()
	..(severity)


/obj/machinery/ignition_switch
	name = "ignition switch"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mounted igniter."
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 4
	)

	var/id = null
	var/active = FALSE

/obj/machinery/ignition_switch/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/ignition_switch/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/ignition_switch/attackby(obj/item/W, mob/user)
	return src.attack_hand(user)

/obj/machinery/ignition_switch/attack_hand(mob/user)
	if(stat & (NOPOWER | BROKEN))
		return
	if(active)
		return

	use_power(5)

	active = TRUE
	icon_state = "launcheract"

	FOR_MACHINES_TYPED(sparky, /obj/machinery/sparker)
		if(sparky.id == src.id)
			spawn(0)
				sparky.ignite()

	FOR_MACHINES_TYPED(ignis, /obj/machinery/igniter)
		if(ignis.id == src.id)
			use_power(50)
			ignis.on = !ignis.on
			ignis.icon_state = "igniter[ignis.on]"

	sleep(50)

	icon_state = "launcherbtt"
	active = FALSE
	return