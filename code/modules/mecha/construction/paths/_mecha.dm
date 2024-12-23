////////////////////////////////
///// Construction datums //////
////////////////////////////////
/datum/construction/mecha/custom_action(step, atom/used_atom, mob/user)
	if(iswelder(used_atom))
		var/obj/item/weldingtool/W = used_atom
		if(W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return FALSE
	else if(iswrench(used_atom))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(isscrewdriver(used_atom))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(iswirecutter(used_atom))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(iscable(used_atom))
		var/obj/item/stack/cable_coil/C = used_atom
		if(C.amount < 4)
			to_chat(user, SPAN_WARNING("There's not enough cable to finish the task."))
			return FALSE
		C.use(4)
		playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_atom, /obj/item/stack))
		var/obj/item/stack/S = used_atom
		if(S.amount < 5)
			to_chat(user, SPAN_WARNING("There's not enough material in this stack."))
			return FALSE
		S.use(5)
	return TRUE

// Chassis
/datum/construction/mecha/chassis/custom_action(step, atom/used_atom, mob/user)
	user.visible_message(
		SPAN_NOTICE("[user] connects \the [used_atom] to \the [holder]."),
		SPAN_NOTICE("You connect \the [used_atom] to \the [holder].")
	)
	holder.overlays.Add(used_atom.icon_state + "+o")
	user.drop_item()
	qdel(used_atom)
	return TRUE

/datum/construction/mecha/chassis/action(atom/used_atom, mob/user)
	return check_all_steps(used_atom, user)

// Mecha
/datum/construction/reversible/mecha
	var/central_circuit = null
	var/peripherals_circuit = null

/datum/construction/reversible/mecha/New()
	steps += get_circuit_steps()
	steps += get_frame_steps()
	. = ..()

/datum/construction/reversible/mecha/proc/get_circuit_steps()
	. = list(
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "The peripherals control module is installed."
		),
		list(
			"key" = peripherals_circuit,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The central control module is secured."
		),
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "The central control module is installed."
		),
		list(
			"key" = central_circuit,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The wiring is adjusted."
		)
	)

/datum/construction/reversible/mecha/proc/get_frame_steps()
	. = list(
		list(
			"key" = /obj/item/wirecutters,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The wiring is added."
		),
		list(
			"key" = /obj/item/stack/cable_coil,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The hydraulic systems are active."
		),
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/wrench,
			"desc" = "The hydraulic systems are connected."
		),
		list(
			"key" = /obj/item/wrench,
			"desc" = "The hydraulic systems are disconnected."
		)
	)

/datum/construction/reversible/mecha/custom_action(index, diff, atom/used_atom, mob/user)
	if(iswelder(used_atom))
		var/obj/item/weldingtool/W = used_atom
		if(!W.remove_fuel(0, user))
			return FALSE
		playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
	else if(iswrench(used_atom))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(isscrewdriver(used_atom))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(iswirecutter(used_atom))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(iscable(used_atom))
		var/obj/item/stack/cable_coil/C = used_atom
		if(C.amount < 4)
			to_chat(user, SPAN_WARNING("There's not enough cable to finish the task."))
			return FALSE
		C.use(4)
		playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_atom, /obj/item/stack))
		var/obj/item/stack/S = used_atom
		if(S.amount < 5)
			to_chat(user, SPAN_WARNING("There's not enough material in this stack."))
			return FALSE
		S.use(5)
	return TRUE

/datum/construction/reversible/mecha/action(atom/used_atom, mob/user)
	return check_step(used_atom, user)