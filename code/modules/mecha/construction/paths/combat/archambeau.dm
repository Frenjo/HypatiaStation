// Archambeau Chassis
/datum/construction/mecha_chassis/durand/archambeau
	result = /datum/construction/reversible/mecha/combat/archambeau

// Archambeau
/datum/construction/reversible/mecha/combat/archambeau
	result = /obj/mecha/combat/durand/archambeau

	base_icon = "durand"

	central_circuit = /obj/item/circuitboard/mecha/archambeau/main
	peripherals_circuit = /obj/item/circuitboard/mecha/archambeau/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/archambeau/targeting

	scanning_module = /obj/item/stock_part/scanning_module/phasic
	scanning_module_name = /obj/item/stock_part/scanning_module/phasic::name
	capacitor = /obj/item/stock_part/capacitor/super
	capacitor_name = /obj/item/stock_part/capacitor/super::name

	internal_armour = /obj/item/stack/sheet/steel
	external_armour = /obj/item/mecha_part/part/archambeau_armour

/datum/construction/reversible/mecha/combat/archambeau/get_other_steps()
	. = ..()
	. += list(
		// 20
		list(
			"desc" = "The external armour plates are wrenched.",
			"icon_state" = "archambeau19",
			"key" = /obj/item/weldingtool,
			"message" = "welded external armour plates",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour plates"
		)
	)

/datum/construction/reversible/mecha/combat/archambeau/spawn_result()
	. = ..()
	feedback_inc("mecha_archambeau_created", 1)