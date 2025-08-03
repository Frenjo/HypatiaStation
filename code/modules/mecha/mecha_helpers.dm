////////////////////////
////// Helpers /////////
////////////////////////
/obj/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return TRUE

/obj/mecha/proc/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/high(src)

/obj/mecha/proc/add_cabin()
	cabin_air = new /datum/gas_mixture()
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.adjust_multi(
		/decl/xgm_gas/oxygen, O2STANDARD * cabin_air.volume / (R_IDEAL_GAS_EQUATION * cabin_air.temperature),
		/decl/xgm_gas/nitrogen, N2STANDARD * cabin_air.volume / (R_IDEAL_GAS_EQUATION * cabin_air.temperature)
	)
	return cabin_air

/obj/mecha/proc/add_radio()
	radio = new /obj/item/radio(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = 1

/obj/mecha/proc/check_for_support()
	if(locate(/obj/structure/grille, orange(1, src)) || locate(/obj/structure/lattice, orange(1, src)) || locate(/turf/open, orange(1, src)))
		return TRUE
	return FALSE

/obj/mecha/get_examine_text(mob/user)
	. = ..()
	var/integrity = health / initial(health) * 100
	switch(integrity)
		if(85 to 100)
			. += SPAN_INFO("It's fully intact.")
		if(65 to 85)
			. += SPAN_INFO("It's slightly damaged.")
		if(45 to 65)
			. += SPAN_INFO("It's badly damaged.")
		if(25 to 45)
			. += SPAN_WARNING("It's heavily damaged.")
		else
			. += SPAN_DANGER("It's falling apart.")

	if(length(equipment))
		. += SPAN_INFO_B("It's equipped with:")
		for_no_type_check(var/obj/item/mecha_equipment/equip, equipment)
			. += SPAN_INFO("[html_icon(equip)] [equip]")

/obj/mecha/proc/drop_item()//Derpfix, but may be useful in future for engineering exosuits.
	return

/obj/mecha/hear_talk(mob/speaker, text, verbage, speaking, alt_name, italics)
	if(speaker == occupant && radio.broadcasting)
		radio.talk_into(speaker, text)
	occupant.hear_say(text, verbage, speaking, alt_name, italics, speaker)