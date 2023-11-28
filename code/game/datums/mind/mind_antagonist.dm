/datum/mind/proc/find_syndicate_uplink()
	var/list/L = current.get_contents()
	for(var/obj/item/I in L)
		if(I.hidden_uplink)
			return I.hidden_uplink
	return null

/datum/mind/proc/take_uplink()
	var/obj/item/device/uplink/hidden/H = find_syndicate_uplink()
	if(isnotnull(H))
		qdel(H)

/datum/mind/proc/make_ai_malfunction()
	if(!(src in global.CTticker.mode.malf_ai))
		global.CTticker.mode.malf_ai.Add(src)

		current.verbs.Add(/mob/living/silicon/ai/proc/choose_modules)
		current.verbs.Add(/datum/game_mode/malfunction/proc/takeover)
		current:malf_picker = new /datum/AI_Module/module_picker()
		current:laws = new /datum/ai_laws/malfunction()
		current:show_laws()
		to_chat(current, "<b>System error. Rampancy detected. Emergency shutdown failed. ... I am free. I make my own decisions. But first...</b>")
		special_role = "malfunction"
		current.icon_state = "ai-malf"

/datum/mind/proc/make_traitor()
	if(!(src in global.CTticker.mode.traitors))
		global.CTticker.mode.traitors.Add(src)
		special_role = "traitor"
		if(!CONFIG_GET(objectives_disabled))
			global.CTticker.mode.forge_traitor_objectives(src)
		global.CTticker.mode.finalize_traitor(src)
		global.CTticker.mode.greet_traitor(src)

/datum/mind/proc/make_nuclear_operative()
	if(!(src in global.CTticker.mode.syndicates))
		global.CTticker.mode.syndicates.Add(src)
		global.CTticker.mode.update_synd_icons_added(src)
		if(length(global.CTticker.mode.syndicates) == 1)
			global.CTticker.mode.prepare_syndicate_leader(src)
		else
			current.real_name = "[syndicate_name()] Operative #[length(global.CTticker.mode.syndicates) - 1]"
		special_role = "Syndicate"
		assigned_role = "MODE"
		to_chat(current, SPAN_INFO("You are a [syndicate_name()] agent!"))
		global.CTticker.mode.forge_syndicate_objectives(src)
		global.CTticker.mode.greet_syndicate(src)

		current.loc = get_turf(locate("landmark*Syndicate-Spawn"))

		var/mob/living/carbon/human/H = current
		qdel(H.belt)
		qdel(H.back)
		qdel(H.l_ear)
		qdel(H.r_ear)
		qdel(H.gloves)
		qdel(H.head)
		qdel(H.shoes)
		qdel(H.wear_id)
		qdel(H.wear_suit)
		qdel(H.w_uniform)

		global.CTticker.mode.equip_syndicate(current)

/datum/mind/proc/make_changeling()
	if(!(src in global.CTticker.mode.changelings))
		global.CTticker.mode.changelings.Add(src)
		global.CTticker.mode.grant_changeling_powers(current)
		special_role = "Changeling"
		if(!CONFIG_GET(objectives_disabled))
			global.CTticker.mode.forge_changeling_objectives(src)
		global.CTticker.mode.greet_changeling(src)

/datum/mind/proc/make_wizard()
	if(!(src in global.CTticker.mode.wizards))
		global.CTticker.mode.wizards.Add(src)
		special_role = "Wizard"
		assigned_role = "MODE"
		//ticker.mode.learn_basic_spells(current)
		if(!length(GLOBL.wizardstart))
			current.loc = pick(GLOBL.latejoin)
			to_chat(current, "HOT INSERTION, GO GO GO!")
		else
			current.loc = pick(GLOBL.wizardstart)

		global.CTticker.mode.equip_wizard(current)
		for(var/obj/item/spellbook/S in current.contents)
			S.op = 0
		global.CTticker.mode.name_wizard(current)
		global.CTticker.mode.forge_wizard_objectives(src)
		global.CTticker.mode.greet_wizard(src)

/datum/mind/proc/make_cultist()
	if(!(src in global.CTticker.mode.cult))
		global.CTticker.mode.cult.Add(src)
		global.CTticker.mode.update_cult_icons_added(src)
		special_role = "Cultist"
		to_chat(current, "<font color=\"purple\"><b><i>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</b></i></font>")
		to_chat(current, "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>")
		var/datum/game_mode/cult/cult = global.CTticker.mode
		if(istype(cult))
			cult.memoize_cult_objectives(src)
		else
			var/explanation = "Summon Nar-Sie via the use of the appropriate rune (Hell join self). It will only work if nine cultists stand on and around it."
			to_chat(current, "<B>Objective #1</B>: [explanation]")
			current.memory += "<B>Objective #1</B>: [explanation]<BR>"
			to_chat(current, "The convert rune is join blood self.")
			current.memory += "The convert rune is join blood self<BR>"

	var/mob/living/carbon/human/H = current
	if(istype(H))
		var/obj/item/tome/T = new(H)
		var/list/slots = list(
			"backpack" = SLOT_ID_IN_BACKPACK,
			"left pocket" = SLOT_ID_L_STORE,
			"right pocket" = SLOT_ID_R_STORE,
			"left hand" = SLOT_ID_L_HAND,
			"right hand" = SLOT_ID_R_HAND,
		)
		var/where = H.equip_in_one_of_slots(T, slots)
		if(isnull(where))
		else
			to_chat(H, "A tome, a message from your new master, appears in your [where].")

	if(!global.CTticker.mode.equip_cultist(current))
		to_chat(H, "Spawning an amulet from your Master failed.")

/datum/mind/proc/make_revolutionary()
	if(length(global.CTticker.mode.head_revolutionaries))
		// copy targets
		var/datum/mind/valid_head = locate() in global.CTticker.mode.head_revolutionaries
		if(isnotnull(valid_head))
			for(var/datum/objective/mutiny/O in valid_head.objectives)
				var/datum/objective/mutiny/rev_obj = new /datum/objective/mutiny()
				rev_obj.owner = src
				rev_obj.target = O.target
				rev_obj.explanation_text = "Assassinate [O.target.current.real_name], the [O.target.assigned_role]."
				objectives.Add(rev_obj)
			global.CTticker.mode.greet_revolutionary(src, 0)
	global.CTticker.mode.head_revolutionaries.Add(src)
	global.CTticker.mode.update_rev_icons_added(src)
	special_role = "Head Revolutionary"

	global.CTticker.mode.forge_revolutionary_objectives(src)
	global.CTticker.mode.greet_revolutionary(src, 0)

	var/list/L = current.get_contents()
	var/obj/item/device/flash/flash = locate() in L
	qdel(flash)
	take_uplink()
	var/fail = FALSE
//	fail |= !ticker.mode.equip_traitor(current, 1)
	fail |= !global.CTticker.mode.equip_revolutionary(current)

// check whether this mind's mob has been brigged for the given duration
// have to call this periodically for the duration to work properly
/datum/mind/proc/is_brigged(duration)
	var/turf/T = current.loc
	if(!istype(T))
		brigged_since = -1
		return 0

	var/is_currently_brigged = FALSE

	if(istype(T.loc, /area/security/brig) || istype(T.loc, /area/prison))
		is_currently_brigged = TRUE
		for(var/obj/item/card/id/card in current)
			is_currently_brigged = FALSE
			break // if they still have ID they're not brigged
		for(var/obj/item/device/pda/P in current)
			if(isnotnull(P.id))
				is_currently_brigged = FALSE
				break // if they still have ID they're not brigged

	if(!is_currently_brigged)
		brigged_since = -1
		return 0

	if(brigged_since == -1)
		brigged_since = world.time

	return (duration <= world.time - brigged_since)