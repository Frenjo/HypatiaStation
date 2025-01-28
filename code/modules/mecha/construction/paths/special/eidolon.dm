// Eidolon chassis
/datum/construction/mecha_chassis/eidolon
	result = /datum/construction/reversible/mecha/special/eidolon
	steps = list(
		list("key" = /obj/item/mecha_part/part/eidolon/torso),
		list("key" = /obj/item/mecha_part/part/eidolon/head),
		list("key" = /obj/item/mecha_part/part/eidolon/left_arm),
		list("key" = /obj/item/mecha_part/part/eidolon/right_arm),
		list("key" = /obj/item/mecha_part/part/eidolon/left_leg),
		list("key" = /obj/item/mecha_part/part/eidolon/right_leg)
	)

/datum/construction/reversible/mecha/special/eidolon
	result = /obj/mecha/combat/eidolon/salvaged

	base_icon_state = "eidolon"

	central_circuit = /obj/item/circuitboard/mecha/eidolon/main
	peripherals_circuit = /obj/item/circuitboard/mecha/eidolon/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/eidolon/targeting

	scanning_module = /obj/item/stock_part/scanning_module/adv
	scanning_module_name = /obj/item/stock_part/scanning_module/adv::name
	capacitor = /obj/item/stock_part/capacitor/adv
	capacitor_name = /obj/item/stock_part/capacitor/adv::name

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/eidolon/armour

/datum/construction/reversible/mecha/special/eidolon/spawn_result()
	. = ..()
	feedback_inc("mecha_eidolon_created", 1)