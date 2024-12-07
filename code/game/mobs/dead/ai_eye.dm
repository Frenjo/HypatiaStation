// AI EYE
//
// An invisible (no icon) mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.
/mob/dead/ai_eye
	name = "Inactive AI Eye"
	icon = 'icons/obj/machines/status_display.dmi' // For AI friend secret shh :o

	mouse_opacity = FALSE

	universal_speak = FALSE
	see_in_dark = 7

	var/list/datum/camera_chunk/visible_camera_chunks = list()
	var/mob/living/silicon/ai/ai = null

/mob/dead/ai_eye/examinate(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents

/mob/dead/ai_eye/point(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents

/mob/dead/ai_eye/examine(mob/user)

// Use this when setting the aiEye's location.
// It will also stream the chunk that the new loc is in.
/mob/dead/ai_eye/proc/setLoc(T)
	if(isnotnull(ai))
		if(!isturf(ai.loc))
			return
		T = GET_TURF(T)
		loc = T
		global.CTcameranet.visibility(src)
		if(isnotnull(ai.client))
			ai.client.eye = src
		//Holopad
		if(istype(ai.current, /obj/machinery/hologram/holopad))
			var/obj/machinery/hologram/holopad/H = ai.current
			H.move_hologram()