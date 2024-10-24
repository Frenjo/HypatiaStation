//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/interior.dmi'
	icon_state = "door1"

	anchored = TRUE
	opacity = TRUE
	density = TRUE

	layer = 2.7
	var/open_layer = 2.7
	var/closed_layer = 3.1

	var/secondsElectrified = 0
	var/visible = TRUE
	var/p_open = FALSE
	var/operating = 0
	var/autoclose = FALSE
	var/glass = FALSE
	var/normalspeed = TRUE
	var/heat_proof = FALSE // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0

	var/block_air_zones = TRUE // If TRUE, air zones cannot merge across the door even when it is opened.

	//Multi-tile doors
	dir = EAST
	var/width = 1

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer // Above most items if closed.
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(GET_TURF(src))
	else
		layer = open_layer // Under all objects if opened.
		explosion_resistance = 0

	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles(need_rebuild = 1)

/obj/machinery/door/Destroy()
	density = FALSE
	update_nearby_tiles()
	return ..()

//process()
	//return

/obj/machinery/door/Bumped(atom/AM)
	if(p_open || operating)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10)
			return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && !M.small)
			bumpopen(M)
		return

	if(istype(AM, /obj/machinery/bot))
		var/obj/machinery/bot/bot = AM
		if(check_access(bot.botcard))
			if(density)
				open()
		return

	if(ismecha(AM))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (allowed(mecha.occupant) || check_access_list(mecha.operation_req_access)))
				open()
			else
				flick("door_deny", src)
		return

/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group)
		return !block_air_zones
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return !opacity
	return !density

/obj/machinery/door/proc/bumpopen(mob/user)
	if(operating)
		return
	if(user.last_airflow > world.time - global.vsc.airflow_delay) //Fakkit
		return
	add_fingerprint(user)
	if(!requiresID())
		user = null

	if(density)
		if(allowed(user))
			open()
		else
			flick("door_deny", src)

/obj/machinery/door/meteorhit(obj/M)
	open()

/obj/machinery/door/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/door/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/door/attack_hand(mob/user)
	return attackby(user, user)

/obj/machinery/door/attack_tk(mob/user)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(operating == -1)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	if(!density)
		to_chat(user, SPAN_WARNING("The door must be closed for you to do that."))
		return FALSE

	FEEDBACK_EMAG_GENERIC(user)
	flick("door_spark", src)
	sleep(0.6 SECONDS)
	open()
	operating = -1
	return TRUE

/obj/machinery/door/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/detective_scanner))
		return TRUE
	return ..()

/obj/machinery/door/attackby(obj/item/I, mob/user)
	if(operating || isrobot(user))
		return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.
	add_fingerprint(user)
	if(!Adjacent(user))
		user = null
	if(!requiresID())
		user = null
	if(density && istype(I, /obj/item/melee/energy/blade))
		flick("door_spark", src)
		sleep(6)
		open()
		operating = -1
		return 1
	if(allowed(user))
		if(density)
			open()
		else
			close()
		return
	if(density)
		flick("door_deny", src)

/obj/machinery/door/blob_act()
	if(prob(40))
		qdel(src)

/obj/machinery/door/emp_act(severity)
	if(prob(20 / severity) && (istype(src, /obj/machinery/door/airlock) || istype(src, /obj/machinery/door/window)))
		open()
	if(prob(40 / severity))
		if(secondsElectrified == 0)
			secondsElectrified = -1
			spawn(300)
				secondsElectrified = 0
	..()

/obj/machinery/door/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(25))
				qdel(src)
		if(3.0)
			if(prob(80))
				make_sparks(2, TRUE, src)

/obj/machinery/door/update_icon()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"

/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("deny")
			flick("door_deny", src)

/obj/machinery/door/proc/open()
	if(!density)
		return 1
	if(operating > 0)
		return
	if(!global.PCticker)
		return 0
	if(!operating)
		operating = 1

	do_animate("opening")
	icon_state = "door0"
	set_opacity(0)
	//sleep(10)
	sleep(7) // Makes doors open slightly quicker. -Frenjo
	layer = open_layer
	density = FALSE
	explosion_resistance = 0
	update_icon()
	set_opacity(0)
	update_nearby_tiles()

	if(operating)
		operating = 0

	if(autoclose  && normalspeed)
		spawn(150)
			autoclose()
	if(autoclose && !normalspeed)
		spawn(5)
			autoclose()

	return 1

/obj/machinery/door/proc/close()
	if(density)
		return 1
	if(operating > 0)
		return
	operating = 1

	do_animate("closing")
	density = TRUE
	explosion_resistance = initial(explosion_resistance)
	layer = closed_layer
	//sleep(10)
	sleep(7) // Makes doors close slightly quicker. -Frenjo
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	operating = 0
	update_nearby_tiles()

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(isnotnull(fire))
		qdel(fire)

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/proc/update_nearby_tiles(need_rebuild)
	if(!global.PCair)
		return 0

	for_no_type_check(var/turf/open/turf, locs)
		update_heat_protection(turf)
		global.PCair.mark_for_update(turf)

	return 1

/obj/machinery/door/proc/update_heat_protection(turf/open/source)
	if(istype(source))
		if(density && (opacity || heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/proc/autoclose()
	var/obj/machinery/door/airlock/A = src
	if(!A.density && !A.operating && !A.locked && !A.welded && A.autoclose)
		close()

/obj/machinery/door/Move(new_loc, new_dir)
	update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/morgue.dmi'