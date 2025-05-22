/datum/mind/proc/find_syndicate_uplink()
	var/list/L = current.get_contents()
	for(var/obj/item/I in L)
		if(I.hidden_uplink)
			return I.hidden_uplink
	return null

/datum/mind/proc/take_uplink()
	var/obj/item/uplink/hidden/H = find_syndicate_uplink()
	if(isnotnull(H))
		qdel(H)

/datum/mind/proc/make_ai_malfunction()
	if(!(src in global.PCticker.mode.malf_ai))
		global.PCticker.mode.malf_ai.Add(src)

		var/mob/living/silicon/ai/malf = src.current
		malf.verbs.Add(/mob/living/silicon/ai/proc/choose_modules)
		malf.verbs.Add(/datum/game_mode/malfunction/proc/takeover)
		malf.malf_picker = new /datum/malf_module/module_picker()
		malf.laws = new /datum/ai_laws/malfunction()
		malf.show_laws()
		to_chat(current, "<b>System error. Rampancy detected. Emergency shutdown failed. ... I am free. I make my own decisions. But first...</b>")
		special_role = "malfunction"
		malf.icon_state = "ai-malf"

/datum/mind/proc/make_traitor()
	if(!(src in global.PCticker.mode.traitors))
		global.PCticker.mode.traitors.Add(src)
		special_role = "traitor"
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			global.PCticker.mode.forge_traitor_objectives(src)
		global.PCticker.mode.finalize_traitor(src)
		global.PCticker.mode.greet_traitor(src)

/datum/mind/proc/make_nuclear_operative()
	if(!(src in global.PCticker.mode.syndicates))
		global.PCticker.mode.syndicates.Add(src)
		global.PCticker.mode.update_synd_icons_added(src)
		if(length(global.PCticker.mode.syndicates) == 1)
			global.PCticker.mode.prepare_syndicate_leader(src)
		else
			current.real_name = "[syndicate_name()] Operative #[length(global.PCticker.mode.syndicates) - 1]"
		special_role = "Syndicate"
		assigned_role = "MODE"
		to_chat(current, SPAN_INFO("You are a [syndicate_name()] agent!"))
		global.PCticker.mode.forge_syndicate_objectives(src)
		global.PCticker.mode.greet_syndicate(src)

		current.forceMove(GET_TURF(locate("landmark*Syndicate-Spawn")))

		var/mob/living/carbon/human/H = current
		qdel(H.belt)
		qdel(H.back)
		qdel(H.l_ear)
		qdel(H.r_ear)
		qdel(H.gloves)
		qdel(H.head)
		qdel(H.shoes)
		qdel(H.id_store)
		qdel(H.wear_suit)
		qdel(H.wear_uniform)

		H.equip_outfit(/decl/hierarchy/outfit/syndicate/nuclear)

/datum/mind/proc/make_changeling()
	if(!(src in global.PCticker.mode.changelings))
		global.PCticker.mode.changelings.Add(src)
		global.PCticker.mode.grant_changeling_powers(current)
		special_role = "Changeling"
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			global.PCticker.mode.forge_changeling_objectives(src)
		global.PCticker.mode.greet_changeling(src)

/datum/mind/proc/make_wizard()
	if(!(src in global.PCticker.mode.wizards))
		global.PCticker.mode.wizards.Add(src)
		special_role = "Wizard"
		assigned_role = "MODE"
		//ticker.mode.learn_basic_spells(current)
		if(!length(GLOBL.wizardstart))
			current.forceMove(pick(GLOBL.latejoin))
			to_chat(current, "HOT INSERTION, GO GO GO!")
		else
			current.forceMove(pick(GLOBL.wizardstart))

		global.PCticker.mode.equip_wizard(current)
		for(var/obj/item/spellbook/S in current.contents)
			S.op = 0
		global.PCticker.mode.name_wizard(current)
		global.PCticker.mode.forge_wizard_objectives(src)
		global.PCticker.mode.greet_wizard(src)

/datum/mind/proc/make_cultist()
	if(!(src in global.PCticker.mode.cult))
		global.PCticker.mode.cult.Add(src)
		global.PCticker.mode.update_cult_icons_added(src)
		special_role = "Cultist"
		to_chat(current, "<font color=\"purple\"><b><i>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</b></i></font>")
		to_chat(current, "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>")
		var/datum/game_mode/cult/cult = global.PCticker.mode
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
			"left pocket" = SLOT_ID_L_POCKET,
			"right pocket" = SLOT_ID_R_POCKET,
			"left hand" = SLOT_ID_L_HAND,
			"right hand" = SLOT_ID_R_HAND,
		)
		var/where = H.equip_in_one_of_slots(T, slots)
		if(isnull(where))
		else
			to_chat(H, "A tome, a message from your new master, appears in your [where].")

	if(!global.PCticker.mode.equip_cultist(current))
		to_chat(H, "Spawning an amulet from your Master failed.")

/datum/mind/proc/make_revolutionary()
	if(length(global.PCticker.mode.head_revolutionaries))
		// copy targets
		var/datum/mind/valid_head = locate() in global.PCticker.mode.head_revolutionaries
		if(isnotnull(valid_head))
			for(var/datum/objective/mutiny/O in valid_head.objectives)
				var/datum/objective/mutiny/rev_obj = new /datum/objective/mutiny()
				rev_obj.owner = src
				rev_obj.target = O.target
				rev_obj.explanation_text = "Assassinate [O.target.current.real_name], the [O.target.assigned_role]."
				objectives.Add(rev_obj)
			global.PCticker.mode.greet_revolutionary(src, 0)
	global.PCticker.mode.head_revolutionaries.Add(src)
	global.PCticker.mode.update_rev_icons_added(src)
	special_role = "Head Revolutionary"

	global.PCticker.mode.forge_revolutionary_objectives(src)
	global.PCticker.mode.greet_revolutionary(src, 0)

	var/list/L = current.get_contents()
	var/obj/item/flash/flash = locate() in L
	qdel(flash)
	take_uplink()
	var/fail = FALSE
//	fail |= !ticker.mode.equip_traitor(current, 1)
	fail |= !global.PCticker.mode.equip_revolutionary(current)

// check whether this mind's mob has been brigged for the given duration
// have to call this periodically for the duration to work properly
/datum/mind/proc/is_brigged(duration)
	var/turf/T = current.loc
	if(!istype(T))
		brigged_since = -1
		return 0

	var/is_currently_brigged = FALSE

	if(istype(T.loc, /area/station/security/brig) || istype(T.loc, /area/external/prison))
		is_currently_brigged = TRUE
		for(var/obj/item/card/id/card in current)
			is_currently_brigged = FALSE
			break // if they still have ID they're not brigged
		for(var/obj/item/pda/P in current)
			if(isnotnull(P.id))
				is_currently_brigged = FALSE
				break // if they still have ID they're not brigged

	if(!is_currently_brigged)
		brigged_since = -1
		return 0

	if(brigged_since == -1)
		brigged_since = world.time

	return (duration <= world.time - brigged_since)