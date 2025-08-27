// Phazon Chassis
/datum/component/construction/mecha_chassis/phazon
	result = /datum/component/construction/reversible/mecha/special/phazon
	steps = list(
		list("key" = /obj/item/mecha_part/part/phazon/torso),
		list("key" = /obj/item/mecha_part/part/phazon/head),
		list("key" = /obj/item/mecha_part/part/phazon/left_arm),
		list("key" = /obj/item/mecha_part/part/phazon/right_arm),
		list("key" = /obj/item/mecha_part/part/phazon/left_leg),
		list("key" = /obj/item/mecha_part/part/phazon/right_leg)
	)

// Phazon
/datum/component/construction/reversible/mecha/special/phazon
	result = /obj/mecha/combat/phazon

	base_icon_state = "phazon"

	central_circuit = /obj/item/circuitboard/mecha/phazon/main
	peripherals_circuit = /obj/item/circuitboard/mecha/phazon/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/phazon/targeting

	scanning_module = /obj/item/stock_part/scanning_module/hyperphasic
	capacitor = /obj/item/stock_part/capacitor/hyper

	internal_armour = /obj/item/stack/sheet/plasteel
	external_armour = /obj/item/mecha_part/part/phazon/armour

/datum/component/construction/reversible/mecha/special/phazon/spawn_result()
	. = ..()
	feedback_inc("mecha_phazon_created", 1)