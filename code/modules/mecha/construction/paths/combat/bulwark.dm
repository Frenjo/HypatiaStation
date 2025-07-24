// Bulwark Chassis
/datum/construction/mecha_chassis/ripley/bulwark
	result = /datum/construction/reversible/mecha/combat/bulwark

// Bulwark
/datum/construction/reversible/mecha/combat/bulwark
	result = /obj/mecha/working/dreadnought/bulwark

	base_icon_state = "durand"

	central_circuit = /obj/item/circuitboard/mecha/dreadnought/main
	peripherals_circuit = /obj/item/circuitboard/mecha/dreadnought/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/bulwark/targeting

	scanning_module = /obj/item/stock_part/scanning_module/adv
	capacitor = /obj/item/stock_part/capacitor/adv

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/durand/armour

/datum/construction/reversible/mecha/combat/bulwark/get_other_steps()
	. = ..()
	. += list(
		// 20
		list(
			"desc" = "The external armour plates are wrenched.",
			"icon_state" = "bulwark19",
			"key" = /obj/item/weldingtool,
			"message" = "welded external armour plates",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour plates"
		)
	)

/datum/construction/reversible/mecha/combat/bulwark/spawn_result()
	. = ..()
	feedback_inc("mecha_bulwark_created", 1)