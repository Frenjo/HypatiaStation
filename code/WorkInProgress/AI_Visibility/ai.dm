
/mob/aiEye
	var/list/visibleCameraChunks = list()
	var/mob/ai = null
	density = FALSE

/mob/living/silicon/ai/var/mob/aiEye/eyeobj = new()

/mob/living/silicon/ai/New()
	..()
	eyeobj.ai = src
	spawn(20)
		freelook()

/mob/living/silicon/ai/death(gibbed)
	if(client && client.eye == eyeobj)
		for(var/datum/camerachunk/c in eyeobj.visibleCameraChunks)
			c.remove(eyeobj)
		client.eye = src
	return ..(gibbed)

/mob/living/silicon/ai/verb/freelook()
	set category = PANEL_AI_COMMANDS
	set name = "freelook"

	current = null	//cancel camera view first, it causes problems
	cameraFollow = null
	if(!eyeobj)	//if it got deleted somehow (like an admin trying to fix things <.<')
		eyeobj = new()
		eyeobj.ai = src
	client.eye = eyeobj
	eyeobj.forceMove(loc)
	cameranet.visibility(eyeobj)

/mob/aiEye/Move()
	. = ..()
	if(.)
		cameranet.visibility(src)

/client/AIMove(n, direct, var/mob/living/silicon/ai/user)
	if(eye == user.eyeobj)
		user.eyeobj.forceMove(get_step(user.eyeobj, direct))
		cameranet.visibility(user.eyeobj)

	else
		return ..()

/turf/move_camera_by_click()
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		if(AI.client.eye == AI.eyeobj)
			return
	return ..()

/mob/living/silicon/ai/attack_ai(var/mob/user as mob)
	if (user != src)
		return

	if (stat == 2)
		return

	var/list/L = list()
	for(var/obj/machinery/camera/C in GLOBL.machines)
		L.Add(C)

	camera_sort(L)
	L = camera_network_sort(L)

	var/list/D = list()
	for (var/obj/machinery/camera/C in L)
		if ( C.network in src.networks )
			D[text("[]: [][]", C.network, C.c_tag, (C.status ? null : " (Deactivated)"))] = C
	D["Cancel"] = "Cancel"

	var/t = input(user, "Which camera should you change to?") as null|anything in D

	if (!t || t == "Cancel")
		return 0

	var/obj/machinery/camera/C = D[t]

	eyeobj.forceMove(C.loc)
	cameranet.visibility(eyeobj)

	return

/mob/living/silicon/ai/cancel_camera()
	set category = PANEL_OOC
	set name = "Cancel Camera View"

	reset_view(null)
	machine = null

/mob/living/silicon/ai/reset_view(atom/A)
	if (client)
		if(!eyeobj)
			eyeobj = new()
			eyeobj.ai = src

		client.eye = eyeobj
		client.perspective = EYE_PERSPECTIVE

		if(ismovable(A))
			eyeobj.forceMove(locate(A.x, A.y, A.z))

		else
			eyeobj.forceMove(locate(src.x, src.y, src.z))

		cameranet.visibility(eyeobj)
