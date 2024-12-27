////////////////////////////////
///// Construction datums //////
////////////////////////////////
/datum/construction/reversible/mecha
	var/base_icon = null

	var/central_circuit = null
	var/peripherals_circuit = null

/datum/construction/reversible/mecha/New()
	steps = get_frame_steps() + get_circuit_steps() + steps
	. = ..()

/datum/construction/reversible/mecha/proc/get_frame_steps()
	. = list(
		list(
			"desc" = "The hydraulic systems are disconnected.",
			"key" = /obj/item/wrench
		),
		list(
			"desc" = "The hydraulic systems are connected.",
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/wrench
		),
		list(
			"desc" = "The hydraulic systems are active.",
			"key" = /obj/item/stack/cable_coil,
			"amount" = 4,
			"back_key" = /obj/item/screwdriver
		),
		list(
			"desc" = "The wiring is added.",
			"key" = /obj/item/wirecutters,
			"back_key" = /obj/item/screwdriver
		)
	)

/datum/construction/reversible/mecha/proc/get_circuit_steps()
	. = list(
		list(
			"desc" = "The wiring is adjusted.",
			"key" = central_circuit,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/screwdriver
		),
		list(
			"desc" = "The central control module is installed.",
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar
		),
		list(
			"desc" = "The central control module is secured.",
			"key" = peripherals_circuit,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/screwdriver
		),
		list(
			"desc" = "The peripherals control module is installed.",
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar
		)
	)

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

	output_core_feedback(diff, user)

/datum/construction/reversible/mecha/update_holder(step_index)
	. = ..()
	// By default, each step in mech construction has a single icon_state:
	// "[base_icon][index - 1]"
	// For example, Ripley's step 1 icon_state is "ripley0".
	if(!steps[index]["icon_state"] && base_icon)
		holder.icon_state = "[base_icon][index - 1]"

/datum/construction/reversible/mecha/proc/output_core_feedback(diff, mob/living/user)
	switch(index)
		if(1)
			user.visible_message(
				SPAN_NOTICE("[user] connects \the [holder]' hydraulic systems."),
				SPAN_NOTICE("You connect \the [holder]' hydraulic systems.")
			)
		if(2)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] activates \the [holder]' hydraulic systems."),
					SPAN_NOTICE("You activate \the [holder]' hydraulic systems.")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]' hydraulic systems."),
					SPAN_NOTICE("You disconnect \the [holder]' hydraulic systems.")
				)
		if(3)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adds wiring to \the [holder]."),
					SPAN_NOTICE("You add wiring to \the [holder].")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] deactivates \the [holder]' hydraulic systems."),
					SPAN_NOTICE("You deactivate \the [holder]' hydraulic systems.")
				)
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adjusts \the [holder]' wiring."),
					SPAN_NOTICE("You adjust \the [holder]' wiring.")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the wiring from \the [holder]."),
					SPAN_NOTICE("You remove the wiring from \the [holder].")
				)
		if(5)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the central control module into \the [holder]."),
					SPAN_NOTICE("You install the central control module into \the [holder].")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]' wiring."),
					SPAN_NOTICE("You disconnect \the [holder]' wiring.")
				)
		if(6)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' mainboard."),
					SPAN_NOTICE("You secure \the [holder]' mainboard.")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the central control module from \the [holder]."),
					SPAN_NOTICE("You remove the central control module from \the [holder].")
				)
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."),
					SPAN_NOTICE("You install the peripherals control module into \the [holder].")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' mainboard."),
					SPAN_NOTICE("You unfasten \the [holder]' mainboard.")
				)
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' peripherals control module."),
					SPAN_NOTICE("You secure \the [holder]' peripherals control module.")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the peripherals control module from \the [holder]."),
					SPAN_NOTICE("You remove the peripherals control module from \the [holder].")
				)