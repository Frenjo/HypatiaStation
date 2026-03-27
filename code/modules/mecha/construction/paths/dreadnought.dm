// Dreadnought Chassis
/datum/component/construction/mecha_chassis/ripley/dreadnought
	result = /datum/component/construction/reversible/mecha/dreadnought

// Dreadnought
/datum/component/construction/reversible/mecha/dreadnought
	result = /obj/mecha/working/dreadnought
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
			"icon_state" = "durand15",
			"key" = /obj/item/wrench,
			"message" = "wrenched internal armour layer",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed internal armour layer"
		),
		// 11
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WRENCHED,
			"icon_state" = "durand16",
			"key" = /obj/item/welding_torch,
			"message" = "welded internal armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened internal armour layer"
		),
		// 12
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WELDED,
			"icon_state" = "durand17",
			"key" = /obj/item/stack/sheet/plasteel,
			"amount" = 5,
			"message" = "installed external armour layer",
			"back_key" = /obj/item/welding_torch,
			"back_message" = "cut away internal armour layer"
		),
		// 13
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_INSTALLED,
			"icon_state" = "durand18",
			"key" = /obj/item/wrench,
			"message" = "wrenched external armour layer",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external armour layer"
		),
		// 14
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_WRENCHED,
			"icon_state" = "dreadnought19",
			"key" = /obj/item/welding_torch,
			"message" = "welded external armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour layer"
		)
	)

	base_icon_state = "durand"

	central_circuit = /obj/item/circuitboard/mecha/dreadnought/main
	peripherals_circuit = /obj/item/circuitboard/mecha/dreadnought/peripherals

/datum/component/construction/reversible/mecha/dreadnought/spawn_result()
	. = ..()
	feedback_inc("mecha_dreadnought_created", 1)