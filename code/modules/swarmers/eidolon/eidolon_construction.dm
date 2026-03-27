// Eidolon Chassis
/datum/component/construction/mecha_chassis/eidolon
	result = /datum/component/construction/reversible/mecha/special/eidolon
	steps = list(
		list("key" = /obj/item/mecha_part/part/eidolon/torso),
		list("key" = /obj/item/mecha_part/part/eidolon/head),
		list("key" = /obj/item/mecha_part/part/eidolon/left_arm),
		list("key" = /obj/item/mecha_part/part/eidolon/right_arm),
		list("key" = /obj/item/mecha_part/part/eidolon/left_leg),
		list("key" = /obj/item/mecha_part/part/eidolon/right_leg)
	)

// Eidolon
/datum/component/construction/reversible/mecha/special/eidolon
	result = /obj/mecha/combat/eidolon/salvaged

	base_icon_state = "eidolon"

	central_circuit = /obj/item/circuitboard/mecha/eidolon/main
	peripherals_circuit = /obj/item/circuitboard/mecha/eidolon/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/eidolon/targeting

	scanning_module = /obj/item/stock_part/scanning_module/adv
	capacitor = /obj/item/stock_part/capacitor/adv

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/eidolon/armour

/datum/component/construction/reversible/mecha/special/eidolon/spawn_result()
	. = ..()
	feedback_inc("mecha_eidolon_created", 1)