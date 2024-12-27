// Chassis
/datum/construction/mecha_chassis/ripley/rescue_ranger
	result = /datum/construction/reversible/mecha/rescue_ranger

// Rescue Ranger
/datum/construction/reversible/mecha/rescue_ranger
	result = /obj/mecha/working/ripley/rescue_ranger
	steps = list(
		// 9
		list(
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED,
			"key" = /obj/item/stack/sheet/steel,
			"amount" = 5,
			"back_key" = /obj/item/screwdriver
		),
		// 10
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_INSTALLED,
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar
		),
		// 11
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WRENCHED,
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench
		),
		// 12
		list(
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WELDED,
			"key" = /obj/item/stack/sheet/plasteel,
			"amount" = 5,
			"back_key" = /obj/item/weldingtool
		),
		// 13
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_INSTALLED,
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar
		),
		// 14
		list(
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_WRENCHED,
			"icon_state" = "rescue_ranger13",
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench
		)
	)

	base_icon = "ripley"

	central_circuit = /obj/item/circuitboard/mecha/ripley/main
	peripherals_circuit = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/construction/reversible/mecha/rescue_ranger/custom_action(diff, obj/item/used_item, mob/living/user)
	if(!..())
		return FALSE

	switch(index)
		if(9)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
		if(10)
			if(diff == FORWARD)
				MECHA_SECURE_INTERNAL_ARMOUR
			else
				MECHA_REMOVE_INTERNAL_ARMOUR
		if(11)
			if(diff == FORWARD)
				MECHA_WELD_INTERNAL_ARMOUR
			else
				MECHA_UNSECURE_INTERNAL_ARMOUR
		if(12)
			if(diff == FORWARD)
				MECHA_INSTALL_EXTERNAL_ARMOUR
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
		if(13)
			if(diff == FORWARD)
				MECHA_SECURE_EXTERNAL_ARMOUR
			else
				MECHA_REMOVE_EXTERNAL_ARMOUR
		if(14)
			if(diff == FORWARD)
				MECHA_WELD_EXTERNAL_ARMOUR
			else
				MECHA_UNSECURE_EXTERNAL_ARMOUR
	return TRUE

/datum/construction/reversible/mecha/rescue_ranger/spawn_result()
	. = ..()
	feedback_inc("mecha_rescue_ranger_created", 1)