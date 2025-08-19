/*
 * AI Verbs
 */
GLOBAL_GLOBL_LIST_INIT(ai_verbs_default, list(
	/mob/living/silicon/ai/proc/ai_call_shuttle,
	/mob/living/silicon/ai/proc/ai_cancel_call,
	/mob/living/silicon/ai/proc/ai_network_change,
	/mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_hologram_change,

	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/toggle_camera_light
))

/mob/living/silicon/ai/proc/add_ai_verbs()
	verbs |= GLOBL.ai_verbs_default

/mob/living/silicon/ai/proc/remove_ai_verbs()
	verbs.Remove(GLOBL.ai_verbs_default)

/*
 * Set AI Core Display
 */
/mob/living/silicon/ai/verb/pick_icon()
	set category = PANEL_AI_COMMANDS
	set name = "Set AI Core Display"

	if(stat || aiRestorePowerRoutine)
		return

	if(!custom_sprite) //Check to see if custom sprite time, checking the appopriate file to change a var
		var/file = file2text("config/custom_sprites.txt")
		var/lines = splittext(file, "\n")

		for(var/line in lines)
		// split & clean up
			var/list/Entry = splittext(line, ":")
			for(var/i in 1 to length(Entry))
				Entry[i] = trim(Entry[i])

			if(length(Entry) < 2)
				continue;

			if(Entry[1] == ckey && Entry[2] == real_name)
				custom_sprite = TRUE //They're in the list? Custom sprite time
				icon = 'icons/mob/silicon/custom-synthetic.dmi'

		//if(icon_state == initial(icon_state))
	var/icontype = ""
	if(custom_sprite)
		icontype = ("Custom")//automagically selects custom sprite if one is available
	else
		icontype = input("Select an icon!", "AI", null, null) in list("Monochrome", "Blue", "Inverted", "Text", "Smiley", "Angry", "Dorf", "Matrix", "Bliss", "Firewall", "Green", "Red", "Static", "Triumvirate", "Triumvirate Static")

	switch(icontype)
		if("Custom") icon_state = "[ckey]-ai"
		if("Clown") icon_state = "ai-clown2"
		if("Monochrome") icon_state = "ai-mono"
		if("Inverted") icon_state = "ai-u"
		if("Firewall") icon_state = "ai-magma"
		if("Green") icon_state = "ai-wierd"
		if("Red") icon_state = "ai-red"
		if("Static") icon_state = "ai-static"
		if("Text") icon_state = "ai-text"
		if("Smiley") icon_state = "ai-smiley"
		if("Matrix") icon_state = "ai-matrix"
		if("Angry") icon_state = "ai-angryface"
		if("Dorf") icon_state = "ai-dorf"
		if("Bliss") icon_state = "ai-bliss"
		if("Triumvirate") icon_state = "ai-triumvirate"
		if("Triumvirate Static") icon_state = "ai-triumvirate-malf"
		else icon_state = "ai"

/*
 * Call Emergency Shuttle
 */
/mob/living/silicon/ai/proc/ai_call_shuttle()
	set category = PANEL_AI_COMMANDS
	set name = "Call Emergency Shuttle"

	if(stat == DEAD)
		to_chat(src, "You can't call the shuttle because you are dead!")
		return

	if(isAI(usr))
		var/mob/living/silicon/ai/AI = src
		if(AI.control_disabled)
			to_chat(usr, SPAN_WARNING("Wireless control is disabled!"))
			return

	var/confirm = alert("Are you sure you want to call the shuttle?", "Confirm Shuttle Call", "Yes", "No")

	if(confirm == "Yes")
		call_shuttle_proc(src)

/*
 * Cancel Emergency Shuttle
 *
 * This one appears to be unimplemented as it's name is missing.
 */
/mob/living/silicon/ai/proc/ai_cancel_call()
	set category = PANEL_AI_COMMANDS

	if(stat == DEAD)
		to_chat(src, "You can't send the shuttle back because you are dead!")
		return

	if(isAI(usr))
		var/mob/living/silicon/ai/AI = src
		if(AI.control_disabled)
			to_chat(src, "Wireless control is disabled!")
			return

	cancel_call_proc(src)

/*
 * Cancel Camera View
 */
/mob/living/silicon/ai/cancel_camera()
	set category = PANEL_AI_COMMANDS
	set name = "Cancel Camera View"

	//cameraFollow = null
	view_core()

/*
 * Jump To Network
 *
 * Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm.
 * Adds in /mob/living/silicon/ai/proc/ai_network_change() instead.
 * Addition by Mord_Sith to define AI's network change ability.
 */
/mob/living/silicon/ai/proc/ai_network_change()
	set category = PANEL_AI_COMMANDS
	set name = "Jump To Network"

	unset_machine()
	cameraFollow = null
	var/list/cameralist = list()

	if(usr.stat == DEAD)
		to_chat(usr, "You can't change your camera network because you are dead!")
		return

	var/mob/living/silicon/ai/U = usr

	for_no_type_check(var/obj/machinery/camera/C, global.CTcameranet.cameras)
		if(!C.can_use())
			continue

		var/list/tempnetwork = difflist(C.network, GLOBL.restricted_camera_networks, 1)
		if(length(tempnetwork))
			for(var/i in tempnetwork)
				cameralist[i] = i
	var/old_network = network
	network = input(U, "Which network would you like to view?") as null | anything in cameralist

	if(isnull(U.eyeobj))
		U.view_core()
		return

	if(isnull(network))
		network = old_network // If nothing is selected
	else
		for_no_type_check(var/obj/machinery/camera/C, global.CTcameranet.cameras)
			if(!C.can_use())
				continue
			if(network in C.network)
				U.eyeobj.setLoc(GET_TURF(C))
				break

	to_chat(src, SPAN_INFO("Switched to [network] camera network."))
//End of code by Mord_Sith

/*
 * Choose Module (Malfunction)
 */
/mob/living/silicon/ai/proc/choose_modules()
	set category = PANEL_MALFUNCTION
	set name = "Choose Module"

	malf_picker.use(src)

/*
 * AI Status
 */
/mob/living/silicon/ai/proc/ai_statuschange()
	set category = PANEL_AI_COMMANDS
	set name = "AI Status"

	if(usr.stat == DEAD)
		to_chat(usr, "You cannot change your emotional status because you are dead!")
		return

	var/list/ai_emotions = list(
		"Very Happy", "Happy", "Neutral", "Unsure", "Confused", "Sad",
		"BSOD", "Blank", "Problems?", "Awesome", "Dorfy", "Facepalm", "Friend Computer"
	)
	if(ckey == "serithi")
		ai_emotions.Add("Tribunal", "Tribunal Malfunctioning")
	var/emote = input("Please, select a status!", "AI Status", null, null) in ai_emotions

	var/obj/machinery/computer/communications/comms = pick(GLOBL.communications_consoles)
	if(emote == "Friend Computer")
		comms?.post_status("friend_computer")
	else
		comms?.post_status("ai_emotion", emote)

/*
 * Change Hologram
 */
//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set category = PANEL_AI_COMMANDS
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?", , "Crew Member", "Unique") == "Crew Member")
		var/list/personnel_list = list()

		for_no_type_check(var/datum/data/record/t, GLOBL.data_core.locked) // Look in data core locked.
			personnel_list["[t.fields["name"]]: [t.fields["rank"]]"] = t.fields["image"] // Pull names, rank, and image.

		if(length(personnel_list))
			input = input("Select a crew member:") as null|anything in personnel_list
			var/icon/character_icon = personnel_list[input]
			if(isnotnull(character_icon))
				qdel(holo_icon) // Clear old icon so we're not storing it in memory.
				holo_icon = getHologramIcon(icon(character_icon))
		else
			alert("No suitable records found. Aborting.")

	else
		var/list/icon_list = list(
			"default",
			"floating face"
		)
		input = input("Please select a hologram:") as null | anything in icon_list
		if(isnotnull(input))
			qdel(holo_icon)
			switch(input)
				if("default")
					holo_icon = getHologramIcon(icon('icons/mob/silicon/AI.dmi', "holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('icons/mob/silicon/AI.dmi', "holo2"))

/*
 * Return To Main Core (Malfunction)
 */
/mob/living/silicon/ai/proc/corereturn()
	set category = PANEL_MALFUNCTION
	set name = "Return To Main Core"

	var/obj/machinery/power/apc/apc = loc
	if(!istype(apc))
		to_chat(src, SPAN_INFO("You are already in your main core."))
		return

	apc.malfvacate()

/*
 * Toggle Camera Light
 *
 * Toggles the luminosity and applies it by re-entereing the camera.
 */
/mob/living/silicon/ai/proc/toggle_camera_light()
	set category = PANEL_AI_COMMANDS
	set name = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."

	camera_light_on = !camera_light_on
	to_chat(src, "Camera lights [camera_light_on ? "activated" : "deactivated"].")
	if(!camera_light_on)
		if(isnotnull(current))
			//current.SetLuminosity(0)
			current.set_light(0)
			current = null
	else
		lightNearbyCamera()

// Handles camera lighting, when toggled.
// It will get the nearest camera from the eyeobj, lighting it.
/mob/living/silicon/ai/proc/lightNearbyCamera()
	if(camera_light_on && camera_light_on < world.timeofday)
		if(isnotnull(current))
			var/obj/machinery/camera/camera = near_range_camera(eyeobj)
			if(isnotnull(camera) && current != camera)
				//current.SetLuminosity(0)
				current.set_light(0)
				if(!camera.light_disabled)
					current = camera
					//current.SetLuminosity(AI_CAMERA_LUMINOSITY)
					current.set_light(AI_CAMERA_LUMINOSITY)
				else
					current = null
			else if(isnull(camera))
				//current.SetLuminosity(0)
				current.set_light(0)
				current = null
		else
			var/obj/machinery/camera/camera = near_range_camera(eyeobj)
			if(isnotnull(camera) && !camera.light_disabled)
				current = camera
				//current.SetLuminosity(AI_CAMERA_LUMINOSITY)
				current.set_light(AI_CAMERA_LUMINOSITY)
		camera_light_on = world.timeofday + 1 * 20 // Update the light every 2 seconds.