/*
 * Reagent Scanner
 */
/obj/item/reagent_scanner
	name = "reagent scanner"
	desc = "A handheld reagent scanner which identifies chemical agents."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "spectrometer"
	item_state = "analyser"

	w_class = 2
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter_amounts = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 20)
	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/biotech = 2)

	var/details = FALSE
	var/recent_fail = FALSE

/obj/item/reagent_scanner/afterattack(obj/O, mob/user)
	if(!istype(O))
		return
	if(user.stat)
		return
	if(!ishuman(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return
	if(crit_fail)
		to_chat(user, SPAN_WARNING("This device has critically failed and is no longer functional!"))
		return

	if(isnotnull(O.reagents))
		var/dat = ""
		if(length(O.reagents.reagent_list))
			var/one_percent = O.reagents.total_volume / 100
			for(var/datum/reagent/R in O.reagents.reagent_list)
				if(prob(reliability))
					dat += "\n \t \blue [R][details ? ": [R.volume / one_percent]%" : ""]"
					recent_fail = FALSE
				else if(recent_fail)
					crit_fail = TRUE
					dat = null
					break
				else
					recent_fail = TRUE
		if(dat)
			to_chat(user, SPAN_INFO("Chemicals found: [dat]"))
		else
			to_chat(user, SPAN_INFO("No active chemical agents found in [O]."))
	else
		to_chat(user, SPAN_INFO("No significant chemical agents found in [O]."))

/*
 * Advanced Reagent Scanner
 */
/obj/item/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	origin_tech = list(/datum/tech/magnets = 4, /datum/tech/biotech = 2)
	details = TRUE