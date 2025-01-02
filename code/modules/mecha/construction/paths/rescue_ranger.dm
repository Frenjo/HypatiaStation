// Chassis
/datum/construction/mecha_chassis/ripley/rescue_ranger
	result = /datum/construction/reversible/mecha/rescue_ranger

// Rescue Ranger
/datum/construction/reversible/mecha/rescue_ranger
	result = /obj/mecha/working/ripley/rescue_ranger
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
			"key" = /obj/item/stack/sheet/plasteel,
			"amount" = 5,
			"message" = "installed external armour layer",
			"back_key" = /obj/item/weldingtool,
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
			"icon_state" = "rescue_ranger13",
			"key" = /obj/item/weldingtool,
			"message" = "welded external armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour layer"
		)
	)

	base_icon = "ripley"

	central_circuit = /obj/item/circuitboard/mecha/ripley/main
	peripherals_circuit = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/construction/reversible/mecha/rescue_ranger/spawn_result()
	. = ..()
	feedback_inc("mecha_rescue_ranger_created", 1)