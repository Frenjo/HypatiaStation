// Phazon Chassis
/datum/construction/mecha_chassis/phazon
	result = /datum/construction/reversible/mecha/combat/phazon
	steps = list(
		list("key" = /obj/item/mecha_part/part/phazon_torso),
		list("key" = /obj/item/mecha_part/part/phazon_left_arm),
		list("key" = /obj/item/mecha_part/part/phazon_right_arm),
		list("key" = /obj/item/mecha_part/part/phazon_left_leg),
		list("key" = /obj/item/mecha_part/part/phazon_right_leg),
		list("key" = /obj/item/mecha_part/part/phazon_head)
	)

// Phazon
/datum/construction/reversible/mecha/combat/phazon
	result = /obj/mecha/combat/phazon

	base_icon = "phazon"

	central_circuit = /obj/item/circuitboard/mecha/phazon/main
	peripherals_circuit = /obj/item/circuitboard/mecha/phazon/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/phazon/targeting

	scanning_module = /obj/item/stock_part/scanning_module/hyperphasic
	scanning_module_name = /obj/item/stock_part/scanning_module/hyperphasic::name
	capacitor = /obj/item/stock_part/capacitor/hyper
	capacitor_name = /obj/item/stock_part/capacitor/hyper::name

	internal_armour = /obj/item/stack/sheet/plasteel
	external_armour = /obj/item/mecha_part/part/phazon_armour

/datum/construction/reversible/mecha/combat/phazon/get_other_steps()
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

/datum/construction/reversible/mecha/combat/phazon/spawn_result()
	. = ..()
	feedback_inc("mecha_phazon_created", 1)