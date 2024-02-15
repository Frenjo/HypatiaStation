/*
 * Reagent Scanner
 */
/obj/item/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "spectrometer"
	item_state = "analyser"
	w_class = 2.0
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter_amounts = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 20)
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_BIOTECH = 2)

	var/details = 0
	var/recent_fail = 0

/obj/item/reagent_scanner/afterattack(obj/O, mob/user as mob)
	if(user.stat)
		return
	if(!(ishuman(usr) || global.CTticker) && global.CTticker.mode.name != "monkey")
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return
	if(!istype(O))
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
					recent_fail = 0
				else if(recent_fail)
					crit_fail = 1
					dat = null
					break
				else
					recent_fail = 1
		if(dat)
			to_chat(user, SPAN_INFO("Chemicals found: [dat]"))
		else
			to_chat(user, SPAN_INFO("No active chemical agents found in [O]."))
	else
		to_chat(user, SPAN_INFO("No significant chemical agents found in [O]."))

	return

/*
 * Advanced Reagent Scanner
 */
/obj/item/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_BIOTECH = 2)