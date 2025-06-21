////////////////////////////////
///// Construction datums //////
////////////////////////////////
/datum/construction/reversible/mecha
	radial_messages = TRUE // Displayed step messages should be visible to those nearby as well as the user.

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

/datum/construction/reversible/mecha/update_holder(step_index)
	. = ..()
	// By default, each step in mech construction has a single icon_state:
	// "[base_icon_state][index - 1]"
	// For example, Ripley's step 1 icon_state is "ripley0".
	if(!steps[index]["icon_state"] && base_icon_state)
		holder.icon_state = "[base_icon_state][index - 1]"