/*
 * Mass Spectrometer
 */
/obj/item/mass_spectrometer
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	name = "mass-spectrometer"
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "spectrometer"
	item_state = "analyser"
	w_class = 2.0
	flags = CONDUCT | OPENCONTAINER
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter_amounts = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 20)
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_BIOTECH = 2)

	var/details = 0
	var/recent_fail = 0

/obj/item/mass_spectrometer/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/mass_spectrometer/attack_self(mob/user as mob)
	if(user.stat)
		return
	if(crit_fail)
		to_chat(user, SPAN_WARNING("This device has critically failed and is no longer functional!"))
		return
	if(!(ishuman(user) || global.CTticker) && global.CTticker.mode.name != "monkey")
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(!istype(R, /datum/reagent/blood))
				reagents.clear_reagents()
				to_chat(user, SPAN_WARNING("The sample was contaminated! Please insert another sample."))
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat = "Trace Chemicals Found: "
		for(var/R in blood_traces)
			if(prob(reliability))
				if(details)
					dat += "[R] ([blood_traces[R]] units) "
				else
					dat += "[R] "
				recent_fail = 0
			else
				if(recent_fail)
					crit_fail = 1
					reagents.clear_reagents()
					return
				else
					recent_fail = 1
		to_chat(user, dat)
		reagents.clear_reagents()
	return

/*
 * Advanced Mass Spectrometer
 */
/obj/item/mass_spectrometer/adv
	name = "advanced mass-spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_BIOTECH = 2)