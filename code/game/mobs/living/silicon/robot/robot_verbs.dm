/*
 * Robot Verbs
 */

/*
 * Namepick
 */
/mob/living/silicon/robot/verb/namepick()
	set category = "Robot Commands"
	set name = "Namepick"

	if(custom_name)
		return 0

	spawn(0)
		var/newname
		newname = input(src,"You are a robot. Enter a name, or leave blank for the default name.", "Name change","") as text
		if(newname != "")
			custom_name = newname

		updatename()
		updateicon()

/*
 * Self Diagnosis
 */
/mob/living/silicon/robot/verb/self_diagnosis()
	set category = "Robot Commands"
	set name = "Self Diagnosis"

	if(!is_component_functioning("diagnosis unit"))
		to_chat(src, SPAN_WARNING("Your self-diagnosis component isn't functioning."))

	var/dat = "<HEAD><TITLE>[name] Self-Diagnosis Report</TITLE></HEAD><BODY>\n"
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		dat += "<b>[C.name]</b><br><table><tr><td>Power consumption</td><td>[C.energy_consumption]</td></tr><tr><td>Brute Damage:</td><td>[C.brute_damage]</td></tr><tr><td>Electronics Damage:</td><td>[C.electronics_damage]</td></tr><tr><td>Powered:</td><td>[(!C.energy_consumption || C.is_powered()) ? "Yes" : "No"]</td></tr><tr><td>Toggled:</td><td>[ C.toggled ? "Yes" : "No"]</td></table><br>"
	SHOW_BROWSER(src, dat, "window=robotdiagnosis")

/*
 * Toggle Component
 */
/mob/living/silicon/robot/verb/toggle_component()
	set category = "Robot Commands"
	set name = "Toggle Component"
	set desc = "Toggle a component, conserving power."

	var/list/installed_components = list()
	for(var/V in components)
		if(V == "power cell")
			continue
		var/datum/robot_component/C = components[V]
		if(C.installed == 1)
			installed_components.Add(V)

	var/toggle = input(src, "Which component do you want to toggle?", "Toggle Component") as null | anything in installed_components
	if(isnull(toggle))
		return

	var/datum/robot_component/C = components[toggle]
	C.toggled = !C.toggled
	to_chat(src, SPAN_WARNING("You [C.toggled ? "enable" : "disable"] [C.name]."))

/*
 * Reset Identity Codes
 */
/mob/living/silicon/robot/proc/reset_identity_codes()
	set category = "Robot Commands"
	set name = "Reset Identity Codes"
	set desc = "Scrambles your security and identification codes and resets your current buffers. Unlocks you, permanently severs you from your AI and the robotics console and will deactivate your camera system."

	if(isnotnull(src))
		unlink_self()
		to_chat(src, "Buffers flushed and reset. Camera system shutdown. All systems operational.")
		verbs.Remove(/mob/living/silicon/robot/proc/reset_identity_codes)

/mob/living/silicon/robot/proc/unlink_self()
	if(isnotnull(connected_ai))
		connected_ai = null
	lawupdate = FALSE
	lockcharge = 0
	canmove = TRUE
	scrambledcodes = TRUE

	// Disconnect it's camera so it's not so easily tracked.
	if(isnotnull(camera))
		camera.network = list()
		global.CTcameranet.remove_camera(camera)

/*
 * Activate Held Object
 */
/mob/living/silicon/robot/mode()
	set category = PANEL_IC
	set name = "Activate Held Object"
	set src = usr

	var/obj/item/W = get_active_hand()
	if(isnotnull(W))
		W.attack_self(src)

/*
 * Set Pose
 */
/mob/living/silicon/robot/verb/pose()
	set category = PANEL_IC
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."

	pose = copytext(sanitize(input(usr, "This is [src]. It is...", "Pose", null) as text), 1, MAX_MESSAGE_LEN)

/*
 * Set Flavour Text
 */
/mob/living/silicon/robot/verb/set_flavour()
	set category = PANEL_IC
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."

	flavor_text = copytext(sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null) as text), 1)