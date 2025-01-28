// Firefighter Chassis
/datum/construction/mecha_chassis/firefighter
	result = /datum/construction/reversible/mecha/firefighter
	steps = list(
		list("key" = /obj/item/mecha_part/part/ripley/torso),
		list("key" = /obj/item/mecha_part/part/ripley/left_arm),
		list("key" = /obj/item/mecha_part/part/ripley/right_arm),
		list("key" = /obj/item/mecha_part/part/ripley/left_leg),
		list("key" = /obj/item/mecha_part/part/ripley/right_leg),
		list("key" = /obj/item/clothing/suit/fire)
	)

// Firefighter
/datum/construction/reversible/mecha/firefighter
	result = /obj/mecha/working/ripley/firefighter
	steps = list(
		// 9
		list(
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED,
			"key" = /obj/item/stack/sheet/plasteel,
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
			"back_message" = "removed internal armour layer",
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
			"key" = /obj/item/stack/sheet/plasteel,
			"amount" = 5,
			"message" = "installed external armour layer",
			"back_key" = /obj/item/weldingtool,
			"back_message" = "cut away internal armour layer"
		),
		// 13
		list(
			"desc" = "The external armour layer is partially installed.",
			"key" = /obj/item/stack/sheet/plasteel,
			"amount" = 5,
			"message" = "reinforced external armour layer",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external armour layer"
		),
		// 14
		list(
			"desc" = "The external armour layer is fully installed.",
			"key" = /obj/item/wrench,
			"message" = "wrenched external armour layer",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external armour layer"
		),
		// 15
		list(
			"desc" = "The external reinforced armour layer is secured.",
			"key" = /obj/item/weldingtool,
			"message" = "welded external armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour layer"
		)
	)

	base_icon_state = "fireripley"

	central_circuit = /obj/item/circuitboard/mecha/ripley/main
	peripherals_circuit = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/construction/reversible/mecha/firefighter/spawn_result()
	. = ..()
	feedback_inc("mecha_firefighter_created", 1)