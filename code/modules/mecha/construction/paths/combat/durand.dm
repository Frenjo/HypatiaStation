// Durand Chassis
/datum/construction/mecha_chassis/durand
	result = /datum/construction/reversible/mecha/combat/durand
	steps = list(
		list("key" = /obj/item/mecha_part/part/durand_torso),
		list("key" = /obj/item/mecha_part/part/durand_left_arm),
		list("key" = /obj/item/mecha_part/part/durand_right_arm),
		list("key" = /obj/item/mecha_part/part/durand_left_leg),
		list("key" = /obj/item/mecha_part/part/durand_right_leg),
		list("key" = /obj/item/mecha_part/part/durand_head)
	)

// Durand
/datum/construction/reversible/mecha/combat/durand
	result = /obj/mecha/combat/durand

	base_icon = "durand"

	central_circuit = /obj/item/circuitboard/mecha/durand/main
	peripherals_circuit = /obj/item/circuitboard/mecha/durand/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/durand/targeting

	scanning_module = /obj/item/stock_part/scanning_module/adv
	scanning_module_name = /obj/item/stock_part/scanning_module/adv::name
	capacitor = /obj/item/stock_part/capacitor/adv
	capacitor_name = /obj/item/stock_part/capacitor/adv::name

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/durand_armour

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