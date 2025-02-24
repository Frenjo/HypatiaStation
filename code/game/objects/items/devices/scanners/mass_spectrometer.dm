/*
 * Mass Spectrometer
 */
/obj/item/mass_spectrometer
	name = "mass spectrometer"
	desc = "A handheld mass spectrometer which identifies trace chemicals in a blood sample."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "spectrometer"
	item_state = "analyser"

	w_class = 2
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter_amounts = /datum/design/medical/mass_spectrometer::materials
	origin_tech = /datum/design/medical/mass_spectrometer::req_tech

	var/details = FALSE
	var/recent_fail = FALSE

/obj/item/mass_spectrometer/New()
	. = ..()
	create_reagents(5)

/obj/item/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/mass_spectrometer/attack_self(mob/user)
	if(user.stat)
		return
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return
	if(crit_fail)
		to_chat(user, SPAN_WARNING("This device has critically failed and is no longer functional!"))
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
				recent_fail = FALSE
			else
				if(recent_fail)
					crit_fail = TRUE
					reagents.clear_reagents()
					return
				else
					recent_fail = TRUE
		to_chat(user, dat)
		reagents.clear_reagents()

/*
 * Advanced Mass Spectrometer
 */
/obj/item/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	matter_amounts = /datum/design/medical/adv_mass_spectrometer::materials
	origin_tech = /datum/design/medical/adv_mass_spectrometer::req_tech
	details = TRUE