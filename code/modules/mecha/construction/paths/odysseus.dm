// Odysseus Chassis
/datum/construction/mecha_chassis/odysseus
	result = /datum/construction/reversible/mecha/odysseus
	steps = list(
		list("key" = /obj/item/mecha_part/part/odysseus/torso),
		list("key" = /obj/item/mecha_part/part/odysseus/head),
		list("key" = /obj/item/mecha_part/part/odysseus/left_arm),
		list("key" = /obj/item/mecha_part/part/odysseus/right_arm),
		list("key" = /obj/item/mecha_part/part/odysseus/left_leg),
		list("key" = /obj/item/mecha_part/part/odysseus/right_leg)
	)

// Odysseus
/datum/construction/reversible/mecha/odysseus
	result = /obj/mecha/medical/odysseus
	steps = list(
		// 9
		list(
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED,
			"key" = /obj/item/stack/sheet/steel,
			"amount" = 5,
			"message" = "installed internal armour layer",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened peripherals control module"
		),
		// 10
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_INSTALLED,
			"key" = /obj/item/wrench,
			"message" = "wrenched internal armour layer",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed internal armour layer"
		),
		// 11
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WRENCHED,
			"key" = /obj/item/weldingtool,
			"message" = "welded internal armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened internal armour layer"
		),
		// 12
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WELDED,
			"key" = /obj/item/mecha_part/part/odysseus/carapace,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed external carapace",
			"back_key" = /obj/item/weldingtool,
			"back_message" = "cut away internal armour layer"
		),
		// 13
		list(
			"desc" = "The external carapace is installed.",
			"key" = /obj/item/wrench,
			"message" = "wrenched external carapace",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external carapace"
		),
		// 14
		list(
			"desc" = "The external carapace is wrenched.",
			"key" = /obj/item/weldingtool,
			"message" = "welded external carapace",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external carapace"
		)
	)

	base_icon_state = "odysseus"

	central_circuit = /obj/item/circuitboard/mecha/odysseus/main
	peripherals_circuit = /obj/item/circuitboard/mecha/odysseus/peripherals

/datum/construction/reversible/mecha/odysseus/spawn_result()
	. = ..()
	feedback_inc("mecha_odysseus_created", 1)