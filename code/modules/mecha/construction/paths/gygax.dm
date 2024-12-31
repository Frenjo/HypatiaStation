// Gygax Chassis
/datum/construction/mecha_chassis/gygax
	result = /datum/construction/reversible/mecha/gygax
	steps = list(
		list("key" = /obj/item/mecha_part/part/gygax_torso),
		list("key" = /obj/item/mecha_part/part/gygax_left_arm),
		list("key" = /obj/item/mecha_part/part/gygax_right_arm),
		list("key" = /obj/item/mecha_part/part/gygax_left_leg),
		list("key" = /obj/item/mecha_part/part/gygax_right_leg),
		list("key" = /obj/item/mecha_part/part/gygax_head)
	)

// Gygax
/datum/construction/reversible/mecha/gygax
	result = /obj/mecha/combat/gygax
	steps = list(
		// 15
		list(
			"desc" = "The advanced capacitor is secured.",
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
			"key" = /obj/item/mecha_part/part/gygax_armour,
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
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench
		)
	)

	base_icon = "gygax"

	central_circuit = /obj/item/circuitboard/mecha/gygax/main
	peripherals_circuit = /obj/item/circuitboard/mecha/gygax/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/gygax/targeting

	scanning_module = /obj/item/stock_part/scanning_module/adv
	scanning_module_name = /obj/item/stock_part/scanning_module/adv::name
	capacitor = /obj/item/stock_part/capacitor/adv
	capacitor_name = /obj/item/stock_part/capacitor/adv::name

/datum/construction/reversible/mecha/gygax/custom_action(diff, obj/item/used_item, mob/living/user)
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

/datum/construction/reversible/mecha/gygax/spawn_result()
	. = ..()
	feedback_inc("mecha_gygax_created", 1)