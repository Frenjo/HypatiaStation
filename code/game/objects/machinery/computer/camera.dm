//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/security
	name = "security camera console"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"

	light_color = "#a91515"

	circuit = /obj/item/circuitboard/security

	var/obj/machinery/camera/current = null
	var/last_pic = 1.0
	var/list/network = list("SS13")
	var/mapping = 0//For the overview file, interesting bit of code.

/obj/machinery/computer/security/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/security/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/computer/security/check_eye(mob/user)
	if ((get_dist(user, src) > 1 || !( user.canmove ) || user.blinded || !( current ) || !( current.status )) && (!issilicon(user)))
		return null
	user.reset_view(current)
	return 1

/obj/machinery/computer/security/attack_hand(mob/user)
	if (src.z > 6)
		user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return
	if(stat & (NOPOWER|BROKEN))	return

	if(!isAI(user))
		user.set_machine(src)

	var/list/L = list()
	for_no_type_check(var/obj/machinery/camera/C, global.CTcameranet.cameras)
		L.Add(C)

	camera_sort(L)

	var/list/D = list()
	D["Cancel"] = "Cancel"
	for(var/obj/machinery/camera/C in L)
		if(can_access_camera(C))
			D[text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))] = C

	var/t = input(user, "Which camera should you change to?") as null|anything in D
	if(!t)
		user.unset_machine()
		return 0

	var/obj/machinery/camera/C = D[t]

	if(t == "Cancel")
		user.unset_machine()
		return 0

	if(C)
		switch_to_camera(user, C)
		spawn(5)
			attack_hand(user)
	return

/obj/machinery/computer/security/proc/can_access_camera(obj/machinery/camera/C)
	var/list/shared_networks = src.network & C.network
	if(length(shared_networks))
		return 1
	return 0

/obj/machinery/computer/security/proc/switch_to_camera(mob/user, obj/machinery/camera/C)
	if((get_dist(user, src) > 1 || user.machine != src || user.blinded || !user.canmove || !C.can_use()) && !isAI(user))
		if(!C.can_use() && !isAI(user))
			src.current = null
		return 0
	else
		if(isAI(user))
			var/mob/living/silicon/ai/A = user
			A.eyeobj.setLoc(GET_TURF(C))
			A.client.eye = A.eyeobj
		else
			src.current = C
			use_power(50)
		return 1

//Camera control: moving.
/obj/machinery/computer/security/proc/jump_on_click(mob/user, A)
	if(user.machine != src)
		return
	var/obj/machinery/camera/jump_to
	if(istype(A, /obj/machinery/camera))
		jump_to = A
	else if(ismob(A))
		if(ishuman(A))
			jump_to = locate() in A:head
		else if(isrobot(A))
			jump_to = A:camera
	else if(isobj(A))
		jump_to = locate() in A
	else if(isturf(A))
		var/best_dist = INFINITY
		var/area/camera_area = GET_AREA(A)
		for(var/obj/machinery/camera/camera in camera_area.machines_list)
			if(!camera.can_use())
				continue
			if(!can_access_camera(camera))
				continue
			var/dist = get_dist(camera, A)
			if(dist < best_dist)
				best_dist = dist
				jump_to = camera
	if(isnull(jump_to))
		return
	if(can_access_camera(jump_to))
		switch_to_camera(user, jump_to)

//Camera control: mouse.
/atom/DblClick()
	..()
	if(istype(usr.machine, /obj/machinery/computer/security))
		var/obj/machinery/computer/security/console = usr.machine
		console.jump_on_click(usr, src)
//Camera control: arrow keys.
/mob/Move(n, direct)
	if(istype(machine, /obj/machinery/computer/security))
		var/obj/machinery/computer/security/console = machine
		var/turf/T = GET_TURF(console.current)
		for(var/i; i < 10; i++)
			T = get_step(T, direct)
		console.jump_on_click(src, T)
		return
	return ..(n, direct)

/obj/machinery/computer/security/telescreen
	name = "telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"
	network = list("thunder")
	density = FALSE

/obj/machinery/computer/security/telescreen/update_icon()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	return

/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/machines/status_display.dmi'
	icon_state = "entertainment"

/obj/machinery/computer/security/wooden_tv
	name = "security cameras"
	desc = "An old TV hooked into the stations camera network."
	icon_state = "security_det"


/obj/machinery/computer/security/mining
	name = "mining outpost camera console"
	desc = "Used to access the various cameras on the outpost."
	icon_state = "miningcameras"
	network = list("MINE")

/obj/machinery/computer/security/engineering
	name = "engineering camera console"
	desc = "Used to monitor fires and breaches."
	icon_state = "engineeringcameras"
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")

/obj/machinery/computer/security/nuclear
	name = "mission monitor"
	desc = "Used to access the built-in cameras in helmets."
	icon_state = "syndicam"
	network = list("NUKE")
