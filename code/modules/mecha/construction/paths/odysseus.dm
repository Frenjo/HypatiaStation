// Odysseus Chassis
/datum/construction/mecha_chassis/odysseus
	result = /datum/construction/reversible/mecha/odysseus
	steps = list(
		list("key" = /obj/item/mecha_part/part/odysseus_torso),	//1
		list("key" = /obj/item/mecha_part/part/odysseus_head),		//2
		list("key" = /obj/item/mecha_part/part/odysseus_left_arm),	//3
		list("key" = /obj/item/mecha_part/part/odysseus_right_arm),//4
		list("key" = /obj/item/mecha_part/part/odysseus_left_leg),	//5
		list("key" = /obj/item/mecha_part/part/odysseus_right_leg)	//6
	)

// Odysseus
/datum/construction/reversible/mecha/odysseus
	result = /obj/mecha/medical/odysseus
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
			"key" = /obj/item/mecha_part/part/odysseus_carapace,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/weldingtool
		),
		// 13
		list(
			"desc" = MECHA_DESC_EXTERNAL_CARAPACE_INSTALLED,
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar
		),
		// 14
		list(
			"desc" = MECHA_DESC_EXTERNAL_CARAPACE_WRENCHED,
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench
		)
	)

	base_icon = "odysseus"

	central_circuit = /obj/item/circuitboard/mecha/odysseus/main
	peripherals_circuit = /obj/item/circuitboard/mecha/odysseus/peripherals

/datum/construction/reversible/mecha/odysseus/custom_action(diff, obj/item/used_item, mob/living/user)
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
				MECHA_INSTALL_EXTERNAL_CARAPACE
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
		if(13)
			if(diff == FORWARD)
				MECHA_SECURE_EXTERNAL_CARAPACE
			else
				MECHA_REMOVE_EXTERNAL_CARAPACE
		if(14)
			if(diff == FORWARD)
				MECHA_WELD_EXTERNAL_CARAPACE
			else
				MECHA_UNSECURE_EXTERNAL_CARAPACE
	return TRUE

/datum/construction/reversible/mecha/odysseus/spawn_result()
	. = ..()
	feedback_inc("mecha_odysseus_created", 1)