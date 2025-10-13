// Clarke chassis
/datum/construction/mecha_chassis/clarke
	result = /datum/construction/reversible/mecha/clarke
	steps = list(
		list("key" = /obj/item/mecha_part/part/clarke/torso),
		list("key" = /obj/item/mecha_part/part/clarke/left_arm),
		list("key" = /obj/item/mecha_part/part/clarke/right_arm),
		list("key" = /obj/item/mecha_part/part/clarke/treads)
	)

// Clarke
/datum/construction/reversible/mecha/clarke
	result = /obj/mecha/working/clarke
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

	base_icon_state = "clarke"

	central_circuit = /obj/item/circuitboard/mecha/clarke/main
	peripherals_circuit = /obj/item/circuitboard/mecha/clarke/peripherals

/datum/construction/reversible/mecha/clarke/spawn_result()
	. = ..()
	feedback_inc("mecha_clarke_created", 1)