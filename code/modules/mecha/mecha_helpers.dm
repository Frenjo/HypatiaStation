////////////////////////
////// Helpers /////////
////////////////////////
/obj/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

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

/obj/mecha/proc/add_iterators()
	pr_int_temp_processor = new /datum/global_iterator/mecha_preserve_temp(list(src))
	pr_inertial_movement = new /datum/global_iterator/mecha_inertial_movement(null, 0)
	pr_give_air = new /datum/global_iterator/mecha_tank_give_air(list(src))
	pr_internal_damage = new /datum/global_iterator/mecha_internal_damage(list(src), 0)

/obj/mecha/proc/do_after(delay)
	sleep(delay)
	return isnotnull(src)

/obj/mecha/proc/enter_after(delay, mob/user, numticks = 5)
	var/delayfraction = delay / numticks
	var/turf/T = user.loc
	for(var/i = 0, i < numticks, i++)
		sleep(delayfraction)
		if(isnull(src) || isnull(user) || !user.canmove || !(user.loc == T))
			return 0
	return 1

/obj/mecha/proc/check_for_support()
	if(locate(/obj/structure/grille, orange(1, src)) || locate(/obj/structure/lattice, orange(1, src)) || locate(/turf/open, orange(1, src)))
		return TRUE
	return FALSE

/obj/mecha/examine()
	set src in view()
	..()
	var/integrity = health / initial(health) * 100
	switch(integrity)
		if(85 to 100)
			usr << "It's fully intact."
		if(65 to 85)
			usr << "It's slightly damaged."
		if(45 to 65)
			usr << "It's badly damaged."
		if(25 to 45)
			usr << "It's heavily damaged."
		else
			usr << "It's falling apart."
	if(length(equipment))
		usr << "It's equipped with:"
		for(var/obj/item/mecha_part/equipment/ME in equipment)
			usr << "\icon[ME] [ME]"
	return

/obj/mecha/proc/drop_item()//Derpfix, but may be useful in future for engineering exosuits.
	return

/obj/mecha/hear_talk(mob/M, text)
	if(M == occupant && radio.broadcasting)
		radio.talk_into(M, text)