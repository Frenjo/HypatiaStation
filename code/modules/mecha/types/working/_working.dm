/obj/mecha/working
	internal_damage_threshold = 60

	var/list/atom/movable/cargo = list()
	var/cargo_capacity = 5

/obj/mecha/working/Destroy()
	if(!isemptylist(cargo))
		for_no_type_check(var/atom/movable/mover, cargo) // Dumps contents of stored cargo.
			mover.forceMove(loc)
			cargo.Remove(mover)
			step_rand(mover)
	return ..()

/obj/mecha/working/Exit(atom/movable/O)
	if(isnotnull(O) && (O in cargo))
		return 0
	return ..()

/obj/mecha/working/get_stats_part()
	. = ..()
	. += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(length(cargo))
		for_no_type_check(var/atom/movable/mover, cargo)
			. += "<a href='byond://?src=\ref[src];drop_from_cargo=\ref[mover]'>Unload</a> : [mover]<br>"
	else
		. += "Nothing"
	. += "</div>"

/obj/mecha/working/Topic(href, href_list)
	. = ..()
	if(href_list["drop_from_cargo"])
		var/atom/movable/mover = locate(href_list["drop_from_cargo"])
		if(isnotnull(mover) && (mover in cargo))
			occupant_message(SPAN_INFO("You unload [mover]."))
			mover.forceMove(GET_TURF(src))
			cargo.Remove(mover)
			log_message("Unloaded [mover]. Cargo compartment capacity: [cargo_capacity - length(cargo)]")