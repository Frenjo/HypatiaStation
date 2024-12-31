// Archambeau Chassis
/datum/construction/mecha_chassis/durand/archambeau
	result = /datum/construction/reversible/mecha/archambeau

// Durand
/datum/construction/reversible/mecha/archambeau
	result = /obj/mecha/combat/durand/archambeau
	steps = list(
		// 15
		list(
			"desc" = "The super capacitor is secured.",
			"key" = /obj/item/stack/sheet/steel,
			"amount" = 5,
			"back_key" = /obj/item/screwdriver
		),
		// 16
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_INSTALLED,
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar
		),
		// 17
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WRENCHED,
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench
		),
		// 18
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WELDED,
			"key" = /obj/item/mecha_part/part/archambeau_armour,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/weldingtool
		),
		// 19
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_INSTALLED,
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar
		),
		// 20
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_WRENCHED,
			"icon_state" = "archambeau19",
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench
		)
	)

	base_icon = "durand"

	central_circuit = /obj/item/circuitboard/mecha/archambeau/main
	peripherals_circuit = /obj/item/circuitboard/mecha/archambeau/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/archambeau/targeting

	scanning_module = /obj/item/stock_part/scanning_module/phasic
	scanning_module_name = /obj/item/stock_part/scanning_module/phasic::name
	capacitor = /obj/item/stock_part/capacitor/super
	capacitor_name = /obj/item/stock_part/capacitor/super::name

/datum/construction/reversible/mecha/archambeau/custom_action(diff, obj/item/used_item, mob/living/user)
	if(!..())
		return FALSE

	switch(index)
		if(15)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' [capacitor_name]."),
					SPAN_NOTICE("You unfasten \the [holder]' [capacitor_name].")
				)
		if(16)
			if(diff == FORWARD)
				MECHA_SECURE_INTERNAL_ARMOUR
			else
				MECHA_REMOVE_INTERNAL_ARMOUR
		if(17)
			if(diff == FORWARD)
				MECHA_WELD_INTERNAL_ARMOUR
			else
				MECHA_UNSECURE_INTERNAL_ARMOUR
		if(18)
			if(diff == FORWARD)
				MECHA_INSTALL_ARMOUR_PLATES
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
		if(19)
			if(diff == FORWARD)
				MECHA_SECURE_ARMOUR_PLATES
			else
				MECHA_REMOVE_ARMOUR_PLATES
		if(20)
			if(diff == FORWARD)
				MECHA_WELD_ARMOUR_PLATES
			else
				MECHA_UNSECURE_ARMOUR_PLATES
	return TRUE

/datum/construction/reversible/mecha/archambeau/spawn_result()
	. = ..()
	feedback_inc("mecha_archambeau_created", 1)