/obj/structure/ladder
	name = "ladder"
	desc = "A sturdy metal ladder."
	icon_state = "ladder11"

	var/id = null
	var/height = 0							//the 'height' of the ladder. higher numbers are considered physically higher
	var/obj/structure/ladder/down = null	//the ladder below this one
	var/obj/structure/ladder/up = null		//the ladder above this one

/obj/structure/ladder/initialise()
	. = ..()
	for(var/obj/structure/ladder/L in GLOBL.movable_atom_list)
		if(L.id == id)
			if(L.height == (height - 1))
				down = L
				continue
			if(L.height == (height + 1))
				up = L
				continue

		if(up && down)	//if both our connections are filled
			break
	update_icon()

/obj/structure/ladder/update_icon()
	if(up && down)
		icon_state = "ladder11"

	else if(up)
		icon_state = "ladder10"

	else if(down)
		icon_state = "ladder01"

	else	//wtf make your ladders properly assholes
		icon_state = "ladder00"

/obj/structure/ladder/attack_hand(mob/user)
	if(up && down)
		switch( alert("Go up or down the ladder?", "Ladder", "Up", "Down", "Cancel") )
			if("Up")
				user.visible_message(
					SPAN_NOTICE("[user] climbs up \the [src]!"),
					SPAN_NOTICE("You climb up \the [src]!")
				)
				user.loc = get_turf(up)
				up.add_fingerprint(user)
			if("Down")
				user.visible_message(
					SPAN_NOTICE("[user] climbs down \the [src]!"),
					SPAN_NOTICE("You climb down \the [src]!")
				)
				user.loc = get_turf(down)
				down.add_fingerprint(user)
			if("Cancel")
				return

	else if(up)
		user.visible_message(
			SPAN_NOTICE("[user] climbs up \the [src]!"),
			SPAN_NOTICE("You climb up \the [src]!")
		)
		user.loc = get_turf(up)
		up.add_fingerprint(user)

	else if(down)
		user.visible_message(
			SPAN_NOTICE("[user] climbs down \the [src]!"),
			SPAN_NOTICE("You climb down \the [src]!")
		)
		user.loc = get_turf(down)
		down.add_fingerprint(user)

	add_fingerprint(user)

/obj/structure/ladder/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/ladder/attackby(obj/item/W, mob/user)
	return attack_hand(user)