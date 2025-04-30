/obj/mecha/working
	internal_damage_threshold = 60

	excluded_equipment = list(
		/obj/item/mecha_equipment/medical,
		/obj/item/mecha_equipment/weapon
	)

	var/list/cargo = list()
	var/cargo_capacity = 5

/obj/mecha/working/initialise()
	. = ..()
	if(GET_TURF_Z(src) != 2)
		new /obj/item/mecha_part/tracking(src)

/obj/mecha/working/Destroy()
	if(!isemptylist(cargo))
		var/turf/T = GET_TURF(src)
		for(var/obj/O in cargo) // Dumps contents of stored cargo.
			O.forceMove(T)
			cargo.Remove(O)
			T.Entered(O)
	return ..()

/*
/obj/mecha/working/melee_action(atom/target)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = pick(oview(1,src))
	if(selected_tool)
		selected_tool.action(target)
	return
*/

/obj/mecha/working/range_action(atom/target)
	return

/*
/obj/mecha/working/get_stats_part()
	. = ..()
	. += "<b>[name] Tools:</b><div style=\"margin-left: 15px;\">"
	if(length(equipment))
		for(var/obj/item/mecha_equipment/MT in equipment)
			. += "[selected == MT?  "<b>" : "<a href='byond://?src=\ref[src];select_equip=\ref[MT]'>"][MT.get_equip_info()][selected == MT ? "</b>" : "</a>"]<br>"
	else
		. += "None"
	. += "</div>"
*/