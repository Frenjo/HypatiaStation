// AI MOVEMENT

// The AI's "eye". Described in mobs/dead/ai_eye.dm.
/mob/living/silicon/ai
	var/mob/dead/ai_eye/eyeobj
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = TRUE

// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	. = ..()
	eyeobj = new /mob/dead/ai_eye()
	eyeobj.ai = src
	eyeobj.name = "[name] (AI Eye)" // Give it a name

/mob/living/silicon/ai/initialise()
	. = ..()
	eyeobj.loc = loc

/mob/living/silicon/ai/Destroy()
	if(isnotnull(eyeobj))
		eyeobj.ai = null
		QDEL_NULL(eyeobj) // No AI, no Eye
	return ..()

/atom/proc/move_camera_by_click()
	if(isAI(usr))
		var/mob/living/silicon/ai/ai = usr
		if(ai.client.eye == ai.eyeobj)
			ai.cameraFollow = null
			ai.eyeobj.setLoc(src)

// This will move the AIEye. It will also cause lights near the eye to light up, if toggled.
// This is handled in the proc below this one.
/client/proc/AIMove(n, direct, mob/living/silicon/ai/user)
	var/initial = initial(user.sprint)
	var/max_sprint = 50

	if(user.cooldown && user.cooldown < world.timeofday) // 3 seconds
		user.sprint = initial

	for(var/i = 0; i < max(user.sprint, initial); i += 20)
		var/turf/step = GET_TURF(get_step(user.eyeobj, direct))
		if(isnotnull(step))
			user.eyeobj.setLoc(step)

	user.cooldown = world.timeofday + 5
	if(user.acceleration)
		user.sprint = min(user.sprint + 0.5, max_sprint)
	else
		user.sprint = initial

	user.cameraFollow = null

	//user.unset_machine() //Uncomment this if it causes problems.
	//user.lightNearbyCamera()

// Return to the Core.
/mob/living/silicon/ai/verb/core()
	set category = PANEL_AI_COMMANDS
	set name = "AI Core"

	view_core()

/mob/living/silicon/ai/proc/view_core()
	current = null
	cameraFollow = null
	unset_machine()

	if(isnotnull(eyeobj) && isnotnull(loc))
		eyeobj.loc = loc
	else
		to_chat(src, "ERROR: Eyeobj not found. Creating new eye...")
		eyeobj = new /mob/dead/ai_eye(loc)
		eyeobj.ai = src
		eyeobj.name = "[name] (AI Eye)" // Give it a name

	if(isnotnull(client?.eye))
		client.eye = src
	for_no_type_check(var/datum/camera_chunk/c, eyeobj.visible_camera_chunks)
		c.remove(eyeobj)

/mob/living/silicon/ai/verb/toggle_acceleration()
	set category = PANEL_AI_COMMANDS
	set name = "Toggle Camera Acceleration"

	acceleration = !acceleration
	to_chat(usr, "Camera acceleration has been toggled [acceleration ? "on" : "off"].")