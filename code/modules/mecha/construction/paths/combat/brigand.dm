// Brigand Chassis
/datum/construction/mecha_chassis/durand/brigand
	result = /datum/construction/reversible/mecha/combat/brigand

// Brigand
/datum/construction/reversible/mecha/combat/brigand
	result = /obj/mecha/combat/brigand

	base_icon_state = "durand"

	central_circuit = /obj/item/circuitboard/mecha/brigand/main
	peripherals_circuit = /obj/item/circuitboard/mecha/brigand/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/brigand/targeting

	scanning_module = /obj/item/stock_part/scanning_module/phasic
	capacitor = /obj/item/stock_part/capacitor/super

	internal_armour = /obj/item/stack/sheet/plasteel
	external_armour = /obj/item/mecha_part/part/durand/armour/brigand

/datum/construction/reversible/mecha/combat/brigand/get_other_steps()
	. = ..()
	. += list(
		// 20
		list(
			"desc" = "The external armour plates are wrenched.",
			"icon_state" = "brigand19",
			"key" = /obj/item/weldingtool,
			"message" = "welded external armour plates",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour plates"
		)
	)

/datum/construction/reversible/mecha/combat/brigand/spawn_result()
	. = ..()
	feedback_inc("mecha_brigand_created", 1)