// Durand Chassis
/datum/construction/mecha_chassis/durand
	result = /datum/construction/reversible/mecha/combat/durand
	steps = list(
		list("key" = /obj/item/mecha_part/part/durand/torso),
		list("key" = /obj/item/mecha_part/part/durand/head),
		list("key" = /obj/item/mecha_part/part/durand/left_arm),
		list("key" = /obj/item/mecha_part/part/durand/right_arm),
		list("key" = /obj/item/mecha_part/part/durand/left_leg),
		list("key" = /obj/item/mecha_part/part/durand/right_leg)
	)

// Durand
/datum/construction/reversible/mecha/combat/durand
	result = /obj/mecha/combat/durand

	base_icon_state = "durand"

	central_circuit = /obj/item/circuitboard/mecha/durand/main
	peripherals_circuit = /obj/item/circuitboard/mecha/durand/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/durand/targeting

	scanning_module = /obj/item/stock_part/scanning_module/adv
	capacitor = /obj/item/stock_part/capacitor/adv

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/durand/armour

/datum/construction/reversible/mecha/combat/durand/get_other_steps()
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

/datum/construction/reversible/mecha/combat/durand/spawn_result()
	. = ..()
	feedback_inc("mecha_durand_created", 1)