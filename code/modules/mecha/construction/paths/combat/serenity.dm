// Serenity Chassis
/datum/construction/mecha_chassis/gygax/serenity
	result = /datum/construction/reversible/mecha/combat/serenity

// Serenity
/datum/construction/reversible/mecha/combat/serenity
	result = /obj/mecha/combat/gygax/serenity

	base_icon_state = "gygax"

	central_circuit = /obj/item/circuitboard/mecha/gygax/main
	peripherals_circuit = /obj/item/circuitboard/mecha/gygax/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/serenity/medical
	optional_circuit_name = "medical"

	scanning_module = /obj/item/stock_part/scanning_module/adv
	capacitor = /obj/item/stock_part/capacitor/adv

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/gygax/armour/serenity
	is_external_carapace = TRUE

/datum/construction/reversible/mecha/combat/serenity/get_other_steps()
	. = ..()
	. += list(
		// 20
		list(
			"desc" = "The external carapace is wrenched.",
			"key" = /obj/item/weldingtool,
			"icon_state" = "serenity19",
			"message" = "welded external carapace",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external carapace"
		)
	)

/datum/construction/reversible/mecha/combat/serenity/spawn_result()
	. = ..()
	feedback_inc("mecha_serenity_created", 1)