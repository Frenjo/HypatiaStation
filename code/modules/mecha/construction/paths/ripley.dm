// Ripley Chassis
/datum/construction/mecha_chassis/ripley
	result = /datum/construction/reversible/mecha/ripley
	steps = list(
		list("key" = /obj/item/mecha_part/part/ripley/torso),
		list("key" = /obj/item/mecha_part/part/ripley/left_arm),
		list("key" = /obj/item/mecha_part/part/ripley/right_arm),
		list("key" = /obj/item/mecha_part/part/ripley/left_leg),
		list("key" = /obj/item/mecha_part/part/ripley/right_leg)
	)

// Ripley
/datum/construction/reversible/mecha/ripley
	result = /obj/mecha/working/ripley
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
			"key" = /obj/item/welding_torch,
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
			"back_key" = /obj/item/welding_torch,
			"back_message" = "cut away internal armour layer"
		),
		// 13
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_INSTALLED,
			"key" = /obj/item/wrench,
			"message" = "wrenched external armour layer",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external armour layer"
		),
		// 14
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_WRENCHED,
			"key" = /obj/item/welding_torch,
			"message" = "welded external armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour layer"
		)
	)

	base_icon_state = "ripley"

	central_circuit = /obj/item/circuitboard/mecha/ripley/main
	peripherals_circuit = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/construction/reversible/mecha/ripley/spawn_result()
	. = ..()
	feedback_inc("mecha_ripley_created", 1)