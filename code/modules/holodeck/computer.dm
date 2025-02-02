/obj/machinery/computer/holodeck_control
	name = "holodeck control computer"
	desc = "A computer used to control a nearby holodeck."
	icon_state = "holocontrol"

	var/area/linked_holodeck = null
	var/area/target = null
	var/active = 0
	var/list/holographic_items = list()
	var/damaged = 0
	var/last_change = 0

/obj/machinery/computer/holodeck_control/New()
	. = ..()
	linked_holodeck = locate(/area/special/holodeck/alpha)
	//if(linkedholodeck)
	//	target = locate(/area/special/holodeck/source_emptycourt)
	//	if(target)
	//		loadProgram(target)

//This could all be done better, but it works for now.
/obj/machinery/computer/holodeck_control/Destroy()
	emergencyShutdown()
	linked_holodeck = null
	target = null
	return ..()

/obj/machinery/computer/holodeck_control/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/holodeck_control/attack_paw(mob/user)
	return

/obj/machinery/computer/holodeck_control/attack_hand(mob/user)
	if(..())
		return
	user.set_machine(src)

	var/dat

	dat += "<B>Holodeck Control System</B><BR>"
	dat += "<HR>Current Loaded Programs:<BR>"

	dat += "<A href='byond://?src=\ref[src];emptycourt=1'>((Empty Court)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];boxingcourt=1'>((Boxing Court)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];basketball=1'>((Basketball Court)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];thunderdomecourt=1'>((Thunderdome Court)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];beach=1'>((Beach)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];desert=1'>((Desert)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];space=1'>((Space)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];picnicarea=1'>((Picnic Area)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];snowfield=1'>((Snow Field)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];theatre=1'>((Theatre)</font>)</A><BR>"
	dat += "<A href='byond://?src=\ref[src];meetinghall=1'>((Meeting Hall)</font>)</A><BR>"
//	dat += "<A href='byond://?src=\ref[src];turnoff=1'>((Shutdown System)</font>)</A><BR>"

	dat += "Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.<BR>"

	if(emagged)
		dat += "<A href='byond://?src=\ref[src];burntest=1'>(<font color=red>Begin Atmospheric Burn Simulation</font>)</A><BR>"
		dat += "Ensure the holodeck is empty before testing.<BR>"
		dat += "<BR>"
		dat += "<A href='byond://?src=\ref[src];wildlifecarp=1'>(<font color=red>Begin Wildlife Simulation</font>)</A><BR>"
		dat += "Ensure the holodeck is empty before testing.<BR>"
		dat += "<BR>"
		if(issilicon(user))
			dat += "<A href='byond://?src=\ref[src];AIoverride=1'>(<font color=green>Re-Enable Safety Protocols?</font>)</A><BR>"
		dat += "Safety Protocols are <font color=red> DISABLED </font><BR>"
	else
		if(issilicon(user))
			dat += "<A href='byond://?src=\ref[src];AIoverride=1'>(<font color=red>Override Safety Protocols?</font>)</A><BR>"
		dat += "<BR>"
		dat += "Safety Protocols are <font color=green> ENABLED </font><BR>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/holodeck_control/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || issilicon(usr))
		usr.set_machine(src)

		if(href_list["emptycourt"])
			target = locate(/area/special/holodeck/source/empty_court)
			if(target)
				loadProgram(target)

		else if(href_list["boxingcourt"])
			target = locate(/area/special/holodeck/source/boxing_court)
			if(target)
				loadProgram(target)

		else if(href_list["basketball"])
			target = locate(/area/special/holodeck/source/basketball_court)
			if(target)
				loadProgram(target)

		else if(href_list["thunderdomecourt"])
			target = locate(/area/special/holodeck/source/thunderdome_court)
			if(target)
				loadProgram(target)

		else if(href_list["beach"])
			target = locate(/area/special/holodeck/source/beach)
			if(target)
				loadProgram(target)

		else if(href_list["desert"])
			target = locate(/area/special/holodeck/source/desert)
			if(target)
				loadProgram(target)

		else if(href_list["space"])
			target = locate(/area/special/holodeck/source/space)
			if(target)
				loadProgram(target)

		else if(href_list["picnicarea"])
			target = locate(/area/special/holodeck/source/picnic_area)
			if(target)
				loadProgram(target)

		else if(href_list["snowfield"])
			target = locate(/area/special/holodeck/source/snow_field)
			if(target)
				loadProgram(target)

		else if(href_list["theatre"])
			target = locate(/area/special/holodeck/source/theatre)
			if(target)
				loadProgram(target)

		else if(href_list["meetinghall"])
			target = locate(/area/special/holodeck/source/meeting_hall)
			if(target)
				loadProgram(target)

		else if(href_list["turnoff"])
			target = locate(/area/special/holodeck/source/plating)
			if(target)
				loadProgram(target)

		else if(href_list["burntest"])
			if(!emagged)
				return
			target = locate(/area/special/holodeck/source/burn_test)
			if(target)
				loadProgram(target)

		else if(href_list["wildlifecarp"])
			if(!emagged)
				return
			target = locate(/area/special/holodeck/source/wildlife)
			if(target)
				loadProgram(target)

		else if(href_list["AIoverride"])
			if(!issilicon(usr))
				return
			emagged = !emagged
			if(emagged)
				message_admins("[key_name_admin(usr)] overrode the holodeck's safeties")
				log_game("[key_name(usr)] overrided the holodeck's safeties")
			else
				message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
				log_game("[key_name(usr)] restored the holodeck's safeties")

		add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/holodeck_control/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	to_chat(user, SPAN_WARNING("You vastly increase projector power and override the safety and security protocols."))
	to_chat(user, SPAN_WARNING("Warning. Automatic shutoff and derezzing protocols have been corrupted. Please call NanoTrasen maintenance and do not use the simulator."))
	playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
	emagged = TRUE
	log_game("[key_name(usr)] emagged the Holodeck Control Computer")
	updateUsrDialog()
	return TRUE

// Warning, commenting this can have consequences. For example, deconstructing the computer may cause holographic eswords to never derez!
/obj/machinery/computer/holodeck_control/attack_tool(obj/item/tool, mob/user)
	SHOULD_CALL_PARENT(FALSE)

	return FALSE

/obj/machinery/computer/holodeck_control/meteorhit(obj/O)
	emergencyShutdown()
	..()

/obj/machinery/computer/holodeck_control/emp_act(severity)
	emergencyShutdown()
	..()

/obj/machinery/computer/holodeck_control/ex_act(severity)
	emergencyShutdown()
	..()

/obj/machinery/computer/holodeck_control/blob_act()
	emergencyShutdown()
	..()

/obj/machinery/computer/holodeck_control/process()
	for(var/item in holographic_items) // do this first, to make sure people don't take items out when power is down.
		if(!(GET_TURF(item) in linked_holodeck))
			derez(item, 0)

	if(!..())
		return
	if(active)
		if(!checkInteg(linked_holodeck))
			damaged = 1
			target = locate(/area/special/holodeck/source/plating)
			if(target)
				loadProgram(target)
			active = 0
			for(var/mob/M in range(10, src))
				M.show_message("The holodeck overloads!")

			for_no_type_check(var/turf/T, linked_holodeck.turf_list)
				if(prob(30))
					make_sparks(2, TRUE, T)
				T.ex_act(3)
				T.hotspot_expose(1000, 500, 1)

/obj/machinery/computer/holodeck_control/proc/derez(obj/obj, silent = 1)
	holographic_items.Remove(obj)

	if(obj == null)
		return

	if(isobj(obj))
		var/mob/M = obj.loc
		if(ismob(M))
			M.u_equip(obj)
			M.update_icons()	//so their overlays update

	if(!silent)
		var/obj/oldobj = obj
		visible_message("The [oldobj.name] fades away!")
	qdel(obj)

/obj/machinery/computer/holodeck_control/proc/checkInteg(area/A)
	for_no_type_check(var/turf/T, A.turf_list)
		if(isspace(T))
			return 0
	return 1

/obj/machinery/computer/holodeck_control/proc/togglePower(toggleOn = 0)
	if(toggleOn)
		var/area/targetsource = locate(/area/special/holodeck/source/empty_court)
		holographic_items = targetsource.copy_contents_to(linked_holodeck)

		spawn(30)
			for(var/obj/effect/landmark/L in linked_holodeck)
				if(L.name == "Atmospheric Test Start")
					spawn(20)
						var/turf/T = GET_TURF(L)
						make_sparks(2, TRUE, T)
						if(isnotnull(T))
							T.temperature = 5000
							T.hotspot_expose(50000, 50000,1)

		active = 1
	else
		for(var/item in holographic_items)
			derez(item)
		var/area/targetsource = locate(/area/special/holodeck/source/plating)
		targetsource.copy_contents_to(linked_holodeck , 1)
		active = 0

/obj/machinery/computer/holodeck_control/proc/loadProgram(area/A)
	if(world.time < (last_change + 25))
		if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
			return
		for(var/mob/M in range(3, src))
			M.show_message("\b ERROR. Recalibrating projection apparatus.")
			last_change = world.time
			return

	last_change = world.time
	active = 1

	for(var/item in holographic_items)
		derez(item)

	for(var/obj/effect/decal/cleanable/blood/B in linked_holodeck)
		qdel(B)

	for(var/mob/living/simple/hostile/carp/C in linked_holodeck)
		qdel(C)

	holographic_items = A.copy_contents_to(linked_holodeck, 1)

	if(emagged)
		for(var/obj/item/holo/esword/H in linked_holodeck)
			H.damtype = BRUTE

	spawn(30)
		for(var/obj/effect/landmark/L in linked_holodeck)
			if(L.name == "Atmospheric Test Start")
				spawn(20)
					var/turf/T = GET_TURF(L)
					make_sparks(2, TRUE, T)
					if(isnotnull(T))
						T.temperature = 5000
						T.hotspot_expose(50000, 50000, 1)
			if(L.name == "Holocarp Spawn")
				new /mob/living/simple/hostile/carp(L.loc)

/obj/machinery/computer/holodeck_control/proc/emergencyShutdown()
	//Get rid of any items
	for(var/item in holographic_items)
		derez(item)
	//Turn it back to the regular non-holographic room
	target = locate(/area/special/holodeck/source/plating)
	if(target)
		loadProgram(target)

	var/area/targetsource = locate(/area/special/holodeck/source/plating)
	targetsource.copy_contents_to(linked_holodeck, 1)
	active = 0