// Gygax Chassis
/datum/construction/mecha_chassis/gygax
	result = /datum/construction/reversible/mecha/combat/gygax
	steps = list(
		list("key" = /obj/item/mecha_part/part/gygax/torso),
		list("key" = /obj/item/mecha_part/part/gygax/head),
		list("key" = /obj/item/mecha_part/part/gygax/left_arm),
		list("key" = /obj/item/mecha_part/part/gygax/right_arm),
		list("key" = /obj/item/mecha_part/part/gygax/left_leg),
		list("key" = /obj/item/mecha_part/part/gygax/right_leg)
	)

// Gygax
/datum/construction/reversible/mecha/combat/gygax
	result = /obj/mecha/combat/gygax

	base_icon_state = "gygax"

	central_circuit = /obj/item/circuitboard/mecha/gygax/main
	peripherals_circuit = /obj/item/circuitboard/mecha/gygax/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/gygax/targeting

	scanning_module = /obj/item/stock_part/scanning_module/adv
	scanning_module_name = /obj/item/stock_part/scanning_module/adv::name
	capacitor = /obj/item/stock_part/capacitor/adv
	capacitor_name = /obj/item/stock_part/capacitor/adv::name

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/gygax/armour

/datum/construction/reversible/mecha/combat/gygax/get_other_steps()
	. = ..()
	. += list(
		// 20
		list(
			"desc" = "The external armour plates are wrenched.",
			"key" = /obj/item/weldingtool,
			"message" = "welded external armour plates",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour plates"
		)
	)

/datum/construction/reversible/mecha/combat/gygax/spawn_result()
	. = ..()
	feedback_inc("mecha_gygax_created", 1)