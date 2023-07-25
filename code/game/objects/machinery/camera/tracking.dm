/mob/living/silicon/ai/proc/get_camera_list()
	if(stat == DEAD)
		return

	var/list/L = list()
	for(var/obj/machinery/camera/C in global.CTcameranet.cameras)
		L.Add(C)

	camera_sort(L)

	var/list/T = list()
	T["Cancel"] = "Cancel"
	for(var/obj/machinery/camera/C in L)
		var/list/tempnetwork = C.network & network
		if(length(tempnetwork))
			T[text("[][]", C.c_tag, (C.can_use() ? null : " (Deactivated)"))] = C

	track = new()
	track.cameras = T
	return T


/mob/living/silicon/ai/proc/ai_camera_list(camera in get_camera_list())
	set category = "AI Commands"
	set name = "Show Camera List"

	if(stat == DEAD)
		src << "You can't list the cameras because you are dead!"
		return

	if(!camera || camera == "Cancel")
		return 0

	var/obj/machinery/camera/C = track.cameras[camera]
	track = null
	eyeobj.setLoc(C)

	return

// Used to allow the AI is write in mob names/camera name from the CMD line.
/datum/trackable
	var/list/names = list()
	var/list/namecounts = list()
	var/list/humans = list()
	var/list/others = list()
	var/list/cameras = list()

/mob/living/silicon/ai/proc/trackable_mobs()
	if(usr.stat == DEAD)
		return list()

	var/datum/trackable/TB = new()
	for(var/mob/living/M in GLOBL.mob_list)
		// Easy checks first.
		// Don't detect mobs on CentCom. Since the wizard den is on CentCom, we only need this.
		var/turf/T = get_turf(M)
		if(!T)
			continue
		if(T.z == 2)
			continue
		if(T.z > 6)
			continue
		if(M == usr)
			continue
		if(M.invisibility)//cloaked
			continue
		if(M.digitalcamo)
			continue

		// Human check
		var/human = 0
		if(ishuman(M))
			human = 1
			var/mob/living/carbon/human/H = M
			//Cameras can't track people wearing an agent card or a ninja hood.
			if(istype(H.wear_id?.get_id(), /obj/item/card/id/syndicate))
				continue
			if(istype(H.head, /obj/item/clothing/head/helmet/space/space_ninja))
				continue

		 // Now, are they viewable by a camera? (This is last because it's the most intensive check)
		if(!near_camera(M))
			continue

		var/name = M.name
		if(name in TB.names)
			TB.namecounts[name]++
			name = text("[] ([])", name, TB.namecounts[name])
		else
			TB.names.Add(name)
			TB.namecounts[name] = 1
		if(human)
			TB.humans[name] = M
		else
			TB.others[name] = M

	var/list/targets = sortList(TB.humans) + sortList(TB.others)
	track = TB
	return targets

/mob/living/silicon/ai/proc/ai_camera_track(target_name in trackable_mobs())
	set category = "AI Commands"
	set name = "Track With Camera"
	set desc = "Select who you would like to track."

	if(stat == DEAD)
		src << "You can't track with camera because you are dead!"
		return
	if(!target_name)
		cameraFollow = null

	var/mob/target = (isnull(track.humans[target_name]) ? track.others[target_name] : track.humans[target_name])
	track = null
	ai_actual_track(target)

/mob/living/silicon/ai/proc/ai_actual_track(mob/living/target as mob)
	if(!istype(target))
		return
	var/mob/living/silicon/ai/U = usr

	U.cameraFollow = target
	//U << text("Now tracking [] on camera.", target.name)
	//if (U.machine == null)
	//	U.machine = U
	U << "Now tracking [target.name] on camera."

	spawn (0)
		while(U.cameraFollow == target)
			if(U.cameraFollow == null)
				return
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(istype(H.wear_id?.get_id(), /obj/item/card/id/syndicate))
					U << "Follow camera mode terminated."
					U.cameraFollow = null
					return
				if(istype(H.head, /obj/item/clothing/head/helmet/space/space_ninja))
					U << "Follow camera mode terminated."
					U.cameraFollow = null
					return
				if(H.digitalcamo)
					U << "Follow camera mode terminated."
					U.cameraFollow = null
					return

			if(istype(target.loc,/obj/effect/dummy))
				U << "Follow camera mode ended."
				U.cameraFollow = null
				return

			if(!near_camera(target))
				U << "Target is not near any active cameras."
				sleep(100)
				continue

			if(U.eyeobj)
				U.eyeobj.setLoc(get_turf(target))
			else
				view_core()
				return
			sleep(10)

/proc/near_camera(mob/living/M)
	if(!isturf(M.loc))
		return 0
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(!(R.camera && R.camera.can_use()) && !global.CTcameranet.checkCameraVis(M))
			return 0
	else if(!global.CTcameranet.checkCameraVis(M))
		return 0
	return 1

/obj/machinery/camera/attack_ai(var/mob/living/silicon/ai/user as mob)
	if(!istype(user))
		return
	if(!can_use())
		return
	user.eyeobj.setLoc(get_turf(src))


/mob/living/silicon/ai/attack_ai(var/mob/user as mob)
	ai_camera_list()

/proc/camera_sort(list/L)
	var/obj/machinery/camera/a
	var/obj/machinery/camera/b

	for(var/i = length(L), i > 0, i--)
		for(var/j = 1 to i - 1)
			a = L[j]
			b = L[j + 1]
			if(a.c_tag_order != b.c_tag_order)
				if(a.c_tag_order > b.c_tag_order)
					L.Swap(j, j + 1)
			else
				if(sorttext(a.c_tag, b.c_tag) < 0)
					L.Swap(j, j + 1)
	return L
