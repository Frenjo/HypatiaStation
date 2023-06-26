/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)
	if(istype(src, /obj/item/clothing/gloves/boxing))	//quick fix for stunglove overlay not working nicely with boxing gloves.
		to_chat(user, SPAN_NOTICE("That won't work."))	//i'm not putting my lips on that!
		..()
		return

	//add wires
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(clipped)
			to_chat(user, SPAN_NOTICE("The [src] are too badly mangled for wiring."))
			return

		if(wired)
			to_chat(user, SPAN_NOTICE("The [src] are already wired."))
			return

		if(C.amount < 2)
			to_chat(user, SPAN_NOTICE("There is not enough wire to cover the [src]."))
			return

		C.use(2)
		wired = TRUE
		siemens_coefficient = 3.0
		to_chat(user, SPAN_NOTICE("You wrap some wires around the [src]."))
		update_icon()
		return

	//add cell
	else if(istype(W, /obj/item/weapon/cell))
		if(!wired)
			to_chat(user, SPAN_NOTICE("The [src] need to be wired first."))
		else if(!cell)
			user.drop_item()
			W.loc = src
			cell = W
			to_chat(user, SPAN_NOTICE("You attach the [cell] to the [src]."))
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("A [cell] is already attached to the [src]."))

	else if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		//stunglove stuff
		if(cell)
			cell.updateicon()
			to_chat(user, SPAN_NOTICE("You cut the [cell] away from the [src]."))
			cell.loc = get_turf(src.loc)
			cell = null
			update_icon()
			return
		if(wired) //wires disappear into the void because fuck that shit
			wired = FALSE
			siemens_coefficient = initial(siemens_coefficient)
			to_chat(user, SPAN_NOTICE("You cut the wires away from the [src]."))
			update_icon()
			return

		//clipping fingertips
		if(!clipped)
			playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
			user.visible_message(SPAN_WARNING("[user] cuts the fingertips off of the [src]."), SPAN_WARNING("You cut the fingertips off of the [src]."))
			clipped = TRUE
			name = "mangled [name]"
			desc = "[desc]<br>They have had the fingertips cut off of them."
			if("exclude" in species_restricted)
				species_restricted -= SPECIES_SOGHUN
				species_restricted -= SPECIES_TAJARAN
			return
		else
			to_chat(user, SPAN_NOTICE("The [src] have already been clipped!"))
			update_icon()
			return

	..()

/obj/item/clothing/gloves/update_icon()
	..()
	overlays.Cut()
	if(wired)
		overlays += "gloves_wire"
	if(cell)
		overlays += "gloves_cell"