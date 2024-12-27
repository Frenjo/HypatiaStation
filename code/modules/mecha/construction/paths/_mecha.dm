////////////////////////////////
///// Construction datums //////
////////////////////////////////
/datum/construction/reversible/mecha
	var/base_icon = null

	var/central_circuit = null
	var/peripherals_circuit = null

/datum/construction/reversible/mecha/New()
	steps += get_circuit_steps()
	steps += get_frame_steps()
	. = ..()
	holder.icon_state = "[base_icon]0"

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

/datum/construction/reversible/mecha/custom_action(index, diff, obj/item/used_item, mob/living/user)
	if(iswelder(used_item))
		var/obj/item/weldingtool/W = used_item
		if(!W.remove_fuel(0, user))
			return FALSE
		playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
	else if(iswrench(used_item))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(isscrewdriver(used_item))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(iswirecutter(used_item))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(iscable(used_item))
		var/obj/item/stack/cable_coil/C = used_item
		if(C.amount < 4)
			to_chat(user, SPAN_WARNING("There's not enough cable to finish the task."))
			return FALSE
		C.use(4)
		playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_item, /obj/item/stack))
		var/obj/item/stack/S = used_item
		if(S.amount < 5)
			to_chat(user, SPAN_WARNING("There's not enough material in this stack."))
			return FALSE
		S.use(5)
	return TRUE

/datum/construction/reversible/mecha/action(obj/item/used_item, mob/living/user)
	return check_step(used_item, user)