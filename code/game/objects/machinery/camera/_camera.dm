/obj/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "camera"
	layer = 5

	power_state = USE_POWER_ACTIVE
	power_usage = list(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 10
	)

	var/list/network = list("SS13")
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = TRUE
	var/panel_open = FALSE
	var/invuln = null
	var/bugged = FALSE
	var/obj/item/camera_assembly/assembly = null

	// WIRES
	var/datum/wires/camera/wires = null // Wires datum

	//OTHER
	var/view_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/alarm_on = FALSE
	var/busy = FALSE

/obj/machinery/camera/New()
	wires = new /datum/wires/camera(src)
	assembly = new /obj/item/camera_assembly(src)
	assembly.state = 4
	/* // Use this to look for cameras that have the same c_tag.
	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network & network
		if(C != src && C.c_tag == c_tag && length(tempnetwork))
			world.log << "[c_tag] [x] [y] [z] conflicts with [C.c_tag] [C.x] [C.y] [C.z]"
	*/
	if(!length(network))
		if(loc)
			error("[name] in [GET_AREA(src)] (x:[x] y:[y] z:[z] has errored. [network ? "Empty network list" : "Null network list"]")
		else
			error("[name] in [GET_AREA(src)]has errored. [network ? "Empty network list" : "Null network list"]")
		ASSERT(network)
		ASSERT(length(network))
	..()

/obj/machinery/camera/Destroy()
	deactivate(null, 0) //kick anyone viewing out
	QDEL_NULL(wires)
	if(isnotnull(assembly))
		QDEL_NULL(assembly)
	return ..()

/obj/machinery/camera/emp_act(severity)
	if(!isEmpProof())
		if(prob(100 / severity))
			icon_state = "[initial(icon_state)]emp"
			var/list/previous_network = network
			network = list()
			global.CTcameranet.remove_camera(src)
			stat |= EMPED
			set_light(0)
			triggerCameraAlarm()
			spawn(900)
				network = previous_network
				icon_state = initial(icon_state)
				stat &= ~EMPED
				cancelCameraAlarm()
				if(can_use())
					global.CTcameranet.add_camera(src)
			for(var/mob/O in GLOBL.mob_list)
				if(istype(O.machine, /obj/machinery/computer/security))
					var/obj/machinery/computer/security/S = O.machine
					if(S.current == src)
						O.unset_machine()
						O.reset_view(null)
						to_chat(O, "The screen bursts into static.")
			..()

/obj/machinery/camera/ex_act(severity)
	if(invuln)
		return
	else
		..(severity)
	return

/obj/machinery/camera/blob_act()
	return

/obj/machinery/camera/proc/setViewRange(num = 7)
	view_range = num
	global.CTcameranet.update_visibility(src, 0)

/obj/machinery/camera/proc/shock(mob/living/user)
	if(!istype(user))
		return
	user.electrocute_act(10, src)

/obj/machinery/camera/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return

	if(user.species.can_shred(user))
		status = 0
		visible_message(SPAN_WARNING("\The [user] slashes at [src]!"))
		playsound(src, 'sound/weapons/slash.ogg', 100, 1)
		icon_state = "[initial(icon_state)]1"
		add_hiddenprint(user)
		deactivate(user, 0)

/obj/machinery/camera/attack_tool(obj/item/tool, mob/user)
	// DECONSTRUCTION
	if(isscrewdriver(tool))
		//user << "<span class='notice'>You start to [panel_open ? "close" : "open"] the camera's panel.</span>"
		//if(toggle_panel(user)) // No delay because no one likes screwdrivers trying to be hip and have a duration cooldown
		panel_open = !panel_open
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, panel_open)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		return TRUE

	if(panel_open && (iswirecutter(tool) || ismultitool(tool)))
		interact(user)
		return TRUE

	if(iswelder(tool) && wires.CanDeconstruct())
		var/obj/item/weldingtool/WT = tool
		if(weld(WT, user))
			if(isnotnull(assembly))
				assembly.loc = loc
				assembly.state = 1
			qdel(src)
		return TRUE

	return ..()

/obj/machinery/camera/attackby(obj/item/W, mob/living/user)
	// OTHER
	if((istype(W, /obj/item/paper) || istype(W, /obj/item/pda)) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = null
		var/obj/item/pda/P = null

		var/itemname = ""
		var/info = ""
		if(istype(W, /obj/item/paper))
			X = W
			itemname = X.name
			info = X.info
		else
			P = W
			itemname = P.name
			info = P.notehtml
		to_chat(U, "You hold \a [itemname] up to the camera...")
		for_no_type_check(var/mob/living/silicon/ai/O, GLOBL.ai_list)
			if(!O.client)
				continue
			if(U.name == "Unknown")
				to_chat(O, "<b>[U]</b> holds \a [itemname] up to one of your cameras...")
			else
				to_chat(O, "<b><a href='byond://?src=\ref[O];track2=\ref[O];track=\ref[U]'>[U]</a></b> holds \a [itemname] up to one of your cameras...")
			O << browse("<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>", "window=[itemname]")
		for_no_type_check(var/mob/O, GLOBL.player_list)
			if(istype(O.machine, /obj/machinery/computer/security))
				var/obj/machinery/computer/security/S = O.machine
				if(S.current == src)
					to_chat(O, "[U] holds \a [itemname] up to one of the cameras...")
					O << browse("<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>", "window=[itemname]")
	else if(istype(W, /obj/item/camera_bug))
		if(!can_use())
			to_chat(user, SPAN_INFO("Camera non-functional."))
			return
		if(bugged)
			to_chat(user, SPAN_INFO("Camera bug removed."))
			bugged = 0
		else
			to_chat(user, SPAN_INFO("Camera bugged."))
			bugged = 1
	else if(istype(W, /obj/item/melee/energy/blade))//Putting it here last since it's a special case. I wonder if there is a better way to do these than type casting.
		deactivate(user, 2)//Here so that you can disconnect anyone viewing the camera, regardless if it's on or off.
		make_sparks(5, FALSE, loc)
		playsound(loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(loc, "sparks", 50, 1)
		visible_message(SPAN_INFO("The camera has been sliced apart by [] with an energy blade!"))
		qdel(src)
	else
		..()
	return

/obj/machinery/camera/proc/deactivate(mob/user, choice = 1)
	if(choice == 1)
		status = !status
		if(!status)
			visible_message(SPAN_WARNING("[user] has deactivated [src]!"))
			playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
			icon_state = "[initial(icon_state)]1"
			add_hiddenprint(user)
		else
			visible_message(SPAN_WARNING("[user] has reactivated [src]!"))
			playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
			icon_state = initial(icon_state)
			add_hiddenprint(user)
	// now disconnect anyone using the camera
	//Apparently, this will disconnect anyone even if the camera was re-activated.
	//I guess that doesn't matter since they can't use it anyway?
	for_no_type_check(var/mob/O, GLOBL.player_list)
		if(istype(O.machine, /obj/machinery/computer/security))
			var/obj/machinery/computer/security/S = O.machine
			if(S.current == src)
				O.unset_machine()
				O.reset_view(null)
				to_chat(O, "The screen bursts into static.")

/obj/machinery/camera/proc/triggerCameraAlarm()
	alarm_on = TRUE
	for(var/mob/living/silicon/S in GLOBL.mob_list)
		S.triggerAlarm("Camera", GET_AREA(src), list(src), src)

/obj/machinery/camera/proc/cancelCameraAlarm()
	alarm_on = FALSE
	for(var/mob/living/silicon/S in GLOBL.mob_list)
		S.cancelAlarm("Camera", GET_AREA(src), src)

/obj/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & EMPED)
		return 0
	return 1

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = GET_TURF(src)
	if(isXRay())
		see = range(view_range, pos)
	else
		see = hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/closed/wall/T = null
	for(var/i = 1, i <= 8; i += i)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let me know. -Giacom
			switch(i)
				if(NORTH)
					set_dir(SOUTH)
				if(SOUTH)
					set_dir(NORTH)
				if(WEST)
					set_dir(EAST)
				if(EAST)
					set_dir(WEST)
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(mob/M)
	for(var/obj/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_range_camera(mob/M)
	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/obj/machinery/camera/proc/weld(obj/item/weldingtool/WT, mob/user)
	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	// Do after stuff here
	to_chat(user, SPAN_NOTICE("You start to weld the [src]..."))
	playsound(src, 'sound/items/Welder.ogg', 50, 1)
	WT.eyecheck(user)
	busy = TRUE
	if(do_after(user, 100))
		busy = FALSE
		if(!WT.isOn())
			return 0
		return 1
	busy = FALSE
	return 0

/obj/machinery/camera/interact(mob/living/user)
	if(!panel_open || isAI(user))
		return

	user.set_machine(src)
	wires.Interact(user)