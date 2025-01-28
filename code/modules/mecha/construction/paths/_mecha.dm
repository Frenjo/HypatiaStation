////////////////////////////////
///// Construction datums //////
////////////////////////////////
/datum/construction/reversible/mecha
	var/base_icon_state = null

	var/central_circuit = null
	var/peripherals_circuit = null

/datum/construction/reversible/mecha/New()
	steps = get_frame_steps() + get_circuit_steps() + get_stock_part_steps() + get_other_steps() + steps
	. = ..()

/datum/construction/reversible/mecha/proc/get_frame_steps()
	RETURN_TYPE(/list)

	. = list(
		list(
			"desc" = "The hydraulic systems are disconnected.",
			"key" = /obj/item/wrench,
			"message" = "connected hydraulic systems"
		),
		list(
			"desc" = "The hydraulic systems are connected.",
			"key" = /obj/item/screwdriver,
			"message" = "activated hydraulic systems",
			"back_key" = /obj/item/wrench,
			"back_message" = "disconnected hydraulic systems"
		),
		list(
			"desc" = "The hydraulic systems are active.",
			"key" = /obj/item/stack/cable_coil,
			"amount" = 4,
			"message" = "added wiring",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "deactivated hydraulic systems"
		),
		list(
			"desc" = "The wiring is added.",
			"key" = /obj/item/wirecutters,
			"message" = "adjusted wiring",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "removed wiring"
		)
	)

/datum/construction/reversible/mecha/proc/get_circuit_steps()
	RETURN_TYPE(/list)

	. = list(
		list(
			"desc" = "The wiring is adjusted.",
			"key" = central_circuit,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed central control module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "disconnected wiring"
		),
		list(
			"desc" = "The central control module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured central control module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed central control module"
		),
		list(
			"desc" = "The central control module is secured.",
			"key" = peripherals_circuit,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed peripherals control module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened central control module"
		),
		list(
			"desc" = "The peripherals control module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured peripherals control module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed peripherals control module"
		)
	)

/datum/construction/reversible/mecha/proc/get_stock_part_steps()
	RETURN_TYPE(/list)

	. = list()

/datum/construction/reversible/mecha/proc/get_other_steps()
	RETURN_TYPE(/list)

	. = list()

/datum/construction/reversible/mecha/custom_action(diff, obj/item/used_item, mob/living/user)
	var/target_index = index + diff
	var/list/current_step = steps[index]
	var/list/target_step

	if(target_index > 0 && target_index <= length(steps))
		target_step = steps[target_index]

	. = TRUE

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
		if(C.amount < current_step["amount"])
			to_chat(user, SPAN_WARNING("There's not enough cable to finish the task."))
			return FALSE
		C.use(current_step["amount"])
		playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_item, /obj/item/stack))
		var/obj/item/stack/S = used_item
		if(S.amount < current_step["amount"])
			to_chat(user, SPAN_WARNING("There's not enough material in this stack."))
			return FALSE
		S.use(current_step["amount"])

	if(diff == FORWARD && current_step["action"] == CONSTRUCTION_ACTION_DELETE)
		qdel(used_item)

	if(. && diff == BACKWARD && isnotnull(target_step) && !target_step["no_refund"])
		var/target_step_key = target_step["key"]
		if(target_step["action"] == CONSTRUCTION_ACTION_DELETE)
			new target_step_key(GET_TURF(holder))
		else if(ispath(target_step_key, target_step["amount"]))
			new target_step_key(GET_TURF(holder), target_step["amount"])

	var/list/step = steps[index]
	var/message = null
	if(diff == FORWARD && isnotnull(step["message"]))
		message = step["message"]
	else if(diff == BACKWARD && isnotnull(step["back_message"]))
		message = step["back_message"]
	if(isnotnull(message))
		holder.balloon_alert_visible(message)

/datum/construction/reversible/mecha/update_holder(step_index)
	. = ..()
	// By default, each step in mech construction has a single icon_state:
	// "[base_icon_state][index - 1]"
	// For example, Ripley's step 1 icon_state is "ripley0".
	if(!steps[index]["icon_state"] && base_icon_state)
		holder.icon_state = "[base_icon_state][index - 1]"