/obj/item/mmi/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/items/assemblies/assemblies.dmi'
	icon_state = "posibrain"

	matter_amounts = /datum/design/posibrain::materials
	origin_tech = /datum/design/posibrain::req_tech

	var/searching = 0

/obj/item/mmi/posibrain/New()
	brainmob = new /mob/living/brain(src)
	brainmob.name = "[pick(list("PBU", "HIU", "SINA", "ARMA", "OSI"))]-[rand(100, 999)]"
	brainmob.real_name = brainmob.name
	brainmob.forceMove(src)
	brainmob.container = src
	brainmob.stat = 0
	brainmob.silent = 0
	GLOBL.dead_mob_list.Remove(brainmob)
	. = ..()

/obj/item/mmi/posibrain/attack_self(mob/user)
	if(isnotnull(brainmob) && isnull(brainmob.key) && !searching)
		// Starts the process of searching for a new user.
		to_chat(user, SPAN_INFO("You carefully locate the manual activation switch and start the positronic brain's boot process."))
		icon_state = "posibrain-searching"
		searching = TRUE
		request_player()
		spawn(1 MINUTE)
			reset_search()

/obj/item/mmi/posibrain/proc/request_player()
	for(var/mob/dead/ghost/O in GLOBL.player_list)
		if(O.has_enabled_antagHUD && CONFIG_GET(/decl/configuration_entry/antag_hud_restricted))
			continue
		if(jobban_isbanned(O, "pAI"))
			continue
		if(O.client?.prefs.be_special & BE_PAI)
			question(O.client)

/obj/item/mmi/posibrain/proc/question(client/C)
	set waitfor = FALSE

	if(isnull(C))
		return
	var/response = alert(C, "Someone is requesting a personality for a positronic brain. Would you like to play as one?", "Positronic brain request", "Yes", "No", "Never for this round")
	if(isnull(C) || brainmob.key || !searching)
		return // Handles logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
	if(response == "Yes")
		transfer_personality(C.mob)
	else if(response == "Never for this round")
		C.prefs.be_special ^= BE_PAI

/obj/item/mmi/posibrain/transfer_identity(mob/living/carbon/H)
	name = "positronic brain ([H])"
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	if(isnotnull(brainmob.mind))
		brainmob.mind.assigned_role = "Positronic Brain"
	if(isnotnull(H.mind))
		H.mind.transfer_to(brainmob)
	to_chat(brainmob, SPAN_INFO("You feel slightly disoriented. That's normal when you're just a metal cube."))
	icon_state = "posibrain-occupied"

/obj/item/mmi/posibrain/proc/transfer_personality(mob/candidate)
	searching = FALSE
	brainmob.mind = candidate.mind
	//src.brainmob.key = candidate.key
	brainmob.ckey = candidate.ckey
	name = "positronic brain ([brainmob.name])"

	to_chat(brainmob, "<b>You are a positronic brain, brought into existence on [station_name()].</b>")
	to_chat(brainmob, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(brainmob, "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>")
	to_chat(brainmob, "<b>Use say :b to speak to other artificial intelligences.</b>")
	brainmob.mind.assigned_role = "Positronic Brain"

	var/turf/T = GET_TURF(src)
	T.visible_message(SPAN_INFO("The positronic brain chimes quietly."))
	icon_state = "posibrain-occupied"

/obj/item/mmi/posibrain/proc/reset_search() // We give the players sixty seconds to decide, then reset the timer.
	if(isnotnull(brainmob?.key))
		return

	searching = FALSE
	icon_state = "posibrain"

	var/turf/T = GET_TURF(src)
	T.visible_message(SPAN_INFO("The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?"))

// This is the exact same as /mob/living/get_examine_header().
/obj/item/mmi/posibrain/get_examine_header()
	. = list()
	. += SPAN_INFO_B("*---------*")
	. += SPAN_INFO("This is \icon[src] <em>\a [src]</em>!")
	if(desc)
		. += SPAN_INFO(desc)

/obj/item/mmi/posibrain/get_examine_text()
	SHOULD_CALL_PARENT(FALSE)

	. = list()
	if(brainmob?.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				. += SPAN_INFO("It appears to be in stand-by mode.")
			if(UNCONSCIOUS)
				. += SPAN_WARNING("It doesn't seem to be responsive.")
			if(DEAD)
				. += SPAN("deadsay", "It appears to be completely inactive.")
	else
		. += SPAN("deadsay", "It appears to be completely inactive.")

	. += SPAN_INFO_B("*---------*")