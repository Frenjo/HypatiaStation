//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/mmi
	name = "man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	icon = 'icons/obj/items/assemblies/assemblies.dmi'
	icon_state = "mmi_empty"

	matter_amounts = /datum/design/medical/mmi::materials
	origin_tech = /datum/design/medical/mmi::req_tech

	req_access = list(ACCESS_ROBOTICS)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = FALSE
	var/mob/living/brain/brainmob = null // The current occupant.

/obj/item/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	QDEL_NULL(brainmob)
	return ..()

/obj/item/mmi/attack_by(obj/item/I, mob/user)
	if(isnull(brainmob) && istype(I, /obj/item/brain)) //Time to stick a brain in it --NEO
		var/obj/item/brain/brain = I
		if(isnull(brain.brainmob))
			to_chat(user, SPAN_WARNING("You aren't sure where this brain came from, but you're pretty sure it's useless."))
			return TRUE

		user.visible_message(
			SPAN_INFO("[user] sticks \a [brain] into \the [src]."),
			SPAN_INFO("You stick \the [brain] into \the [src].")
		)

		brainmob = brain.brainmob
		brain.brainmob = null
		brainmob.forceMove(src)
		brainmob.container = src
		brainmob.stat = 0
		GLOBL.dead_mob_list.Remove(brainmob)//Update dem lists
		GLOBL.living_mob_list.Add(brainmob)

		user.drop_item()
		qdel(brain)

		name = "man-machine interface: [brainmob.real_name]"
		icon_state = "mmi_full"

		locked = TRUE

		feedback_inc("cyborg_mmis_filled", 1)
		return TRUE

	if(isnotnull(brainmob) && (istype(I, /obj/item/card/id) || istype(I, /obj/item/pda)))
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] the brain holder."))
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	if(isnotnull(brainmob))
		I.attack(brainmob, user) //Oh noooeeeee
		return TRUE

	return ..()

/obj/item/mmi/attack_self(mob/user)
	if(isnull(brainmob))
		to_chat(user, SPAN_WARNING("You upend the MMI, but there's nothing in it."))
		return

	if(locked)
		to_chat(user, SPAN_WARNING("You upend the MMI, but the brain is clamped into place."))
		return

	to_chat(user, SPAN_INFO("You upend the MMI, spilling the brain onto the floor."))
	var/obj/item/brain/brain = new /obj/item/brain(user.loc)
	brainmob.container = null // Reset brainmob mmi var.
	brainmob.forceMove(brain) // Throw mob into brain.
	GLOBL.living_mob_list.Remove(brainmob) // Get outta here
	brain.brainmob = brainmob // Set the brain to use the brainmob
	brainmob = null // Set mmi brainmob var to null

	icon_state = "mmi_empty"
	name = initial(name)

/obj/item/mmi/emp_act(severity)
	if(isnull(brainmob))
		return

	switch(severity)
		if(1)
			brainmob.emp_damage += rand(20, 30)
		if(2)
			brainmob.emp_damage += rand(10, 20)
		if(3)
			brainmob.emp_damage += rand(0, 10)
	..()

/obj/item/mmi/proc/transfer_identity(mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new /mob/living/brain(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	name = "man-machine interface: [brainmob.real_name]"
	icon_state = "mmi_full"
	locked = TRUE

/obj/item/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."

	matter_amounts = /datum/design/medical/mmi_radio::materials
	origin_tech = /datum/design/medical/mmi_radio::req_tech

	var/obj/item/radio/radio = null // Let's give it a radio.

/obj/item/mmi/radio_enabled/New()
	. = ..()
	radio = new /obj/item/radio(src) // Spawns a radio inside the MMI.
	radio.broadcasting = TRUE // So it's broadcasting from the start.

// Allows the brain to toggle the radio functions.
/obj/item/mmi/radio_enabled/verb/toggle_broadcasting()
	set category = "MMI"
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set popup_menu = FALSE
	set src = usr.loc // In user location, or in MMI in this case.

	if(brainmob.stat )// Only the brainmob will trigger these so no further check is necessary.
		to_chat(brainmob, SPAN_WARNING("You can't do that while incapacitated or dead."))

	radio.broadcasting = !radio.broadcasting
	to_chat(brainmob, SPAN_INFO("Radio is [radio.broadcasting ? "now" : "no longer"] broadcasting."))

/obj/item/mmi/radio_enabled/verb/toggle_listening()
	set category = "MMI"
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set popup_menu = FALSE
	set src = usr.loc

	if(brainmob.stat)
		to_chat(brainmob, SPAN_WARNING("You can't do that while incapacitated or dead."))

	radio.listening = !radio.listening
	to_chat(brainmob, SPAN_INFO("Radio is [radio.listening ? "now" : "no longer"] receiving."))

// Digital
/obj/item/mmi/digital
	var/searching = FALSE

/obj/item/mmi/digital/initialise()
	. = ..()
	brainmob = new /mob/living/brain(src)
	brainmob.forceMove(src)
	brainmob.container = src
	brainmob.stat = CONSCIOUS
	brainmob.silent = FALSE
	GLOBL.dead_mob_list.Remove(brainmob)

/obj/item/mmi/digital/attack_self(mob/user)
	if(isnotnull(brainmob) && isnull(brainmob.key) && !searching)
		// Starts the process of searching for a new user.
		to_chat(user, SPAN_INFO("You carefully locate the manual activation switch and start the [src]'s boot process."))
		searching = TRUE
		request_player()
		spawn(1 MINUTE)
			reset_search()

/obj/item/mmi/digital/proc/request_player()
	for(var/mob/dead/ghost/O in GLOBL.player_list)
		if(O.has_enabled_antagHUD && CONFIG_GET(/decl/configuration_entry/antag_hud_restricted))
			continue
		if(jobban_isbanned(O, "pAI"))
			continue
		if(O.client?.prefs.be_special & BE_PAI)
			question(O.client)

/obj/item/mmi/digital/proc/question(client/C)
	set waitfor = FALSE

	if(isnull(C))
		return
	var/response = alert(C, "Someone is requesting a personality for a synthetic brain. Would you like to play as one?", "Synthetic brain request", "Yes", "No", "Never for this round")
	if(isnull(C) || brainmob.key || !searching)
		return // Handles logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
	if(response == "Yes")
		transfer_personality(C.mob)
	else if(response == "Never for this round")
		C.prefs.be_special ^= BE_PAI

/obj/item/mmi/digital/transfer_identity(mob/living/carbon/H)
	name = "[name] ([H])"
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	if(isnotnull(H.mind))
		H.mind.transfer_to(brainmob)

/obj/item/mmi/digital/proc/transfer_personality(mob/candidate)
	searching = FALSE
	brainmob.mind = candidate.mind
	//src.brainmob.key = candidate.key
	brainmob.ckey = candidate.ckey
	name = "[name] ([brainmob.name])"

	to_chat(brainmob, "<b>You are [brainmob.name], brought into existence on [station_name()].</b>")
	to_chat(brainmob, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(brainmob, "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>")

	var/turf/T = GET_TURF(src)
	T.visible_message(SPAN_INFO("\The [src] chimes quietly."))

/obj/item/mmi/digital/proc/reset_search() // We give the players sixty seconds to decide, then reset the timer.
	if(isnotnull(brainmob?.key))
		return

	searching = FALSE
	icon_state = initial(icon_state)

	var/turf/T = GET_TURF(src)
	T.visible_message(SPAN_INFO("The [src] buzzes quietly, and the golden lights fade away. Perhaps you could try again?"))

/obj/item/mmi/digital/get_examine_header(mob/user)
	. = list()
	. += SPAN_INFO_B("*---------*")
	. += SPAN_INFO("This is [icon2html(src, user)] <em>\a [initial(name)]</em>!")
	if(desc)
		. += SPAN_INFO(desc)

/obj/item/mmi/digital/get_examine_text()
	SHOULD_CALL_PARENT(FALSE)

	. = list()
	if(brainmob?.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				. += SPAN_INFO("It appears to be in stand-by mode.")
			if(UNCONSCIOUS)
				. += SPAN_WARNING("It doesn't seem to be responsive.")
			if(DEAD)
				. += SPAN_DEADSAY("It appears to be completely inactive.")
	else
		. += SPAN_DEADSAY("It appears to be completely inactive.")

	. += SPAN_INFO_B("*---------*")

/obj/item/mmi/digital/positronic
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/items/assemblies/assemblies.dmi'
	icon_state = "posibrain"

	matter_amounts = /datum/design/posibrain::materials
	origin_tech = /datum/design/posibrain::req_tech

/obj/item/mmi/digital/positronic/initialise()
	. = ..()
	brainmob.name = "[pick(list("PBU", "HIU", "SINA", "ARMA", "OSI"))]-[rand(100, 999)]"
	brainmob.real_name = brainmob.name

/obj/item/mmi/digital/positronic/request_player()
	icon_state = "posibrain-searching"
	. = ..()

/obj/item/mmi/digital/positronic/transfer_identity(mob/living/carbon/H)
	. = ..()
	if(isnotnull(brainmob.mind))
		brainmob.mind.assigned_role = "Positronic Brain"
	to_chat(brainmob, SPAN_INFO("You feel slightly disoriented. That's normal when you're just a metal cube."))
	icon_state = "posibrain-occupied"

/obj/item/mmi/digital/positronic/transfer_personality(mob/candidate)
	. = ..()
	brainmob.mind.assigned_role = "Positronic Brain"
	icon_state = "posibrain-occupied"

/obj/item/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	icon = 'icons/obj/items/module.dmi'
	icon_state = "mainboard"

	matter_amounts = /datum/design/robobrain::materials
	origin_tech = /datum/design/robobrain::req_tech

/obj/item/mmi/digital/robot/initialise()
	. = ..()
	brainmob.name = "[pick(list("ADA", "DOS", "GNU", "MAC", "WIN", "NJS", "SKS", "DRD", "IOS", "CRM", "IBM", "TEX", "LVM", "BSD",))]-[rand(1000, 9999)]"
	brainmob.real_name = src.brainmob.name

/obj/item/mmi/digital/robot/transfer_identity(mob/living/carbon/H)
	. = ..()
	if(isnotnull(brainmob.mind))
		brainmob.mind.assigned_role = "Robotic Intelligence Circuit"
	to_chat(brainmob, SPAN_INFO("You feel slightly disoriented. That's normal when you're just a circuit board."))

/obj/item/mmi/digital/robot/transfer_personality(mob/candidate)
	. = ..()
	brainmob.mind.assigned_role = "Robotic Intelligence Circuit"