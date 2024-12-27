// Serenity Chassis
/datum/construction/mecha_chassis/gygax/serenity
	result = /datum/construction/reversible/mecha/serenity

// Serenity
/datum/construction/reversible/mecha/serenity
	result = /obj/mecha/combat/gygax/serenity
	steps = list(
		// 9
		list(
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED,
			"key" = /obj/item/circuitboard/mecha/serenity/medical,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/screwdriver
		),
		// 10
		list(
			"desc" = "The medical module is installed.",
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar
		),
		// 11
		list(
			"desc" = "The medical module is secured.",
			"key" = /obj/item/stock_part/scanning_module/adv,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/screwdriver
		),
		// 12
		list(
			"desc" = "An advanced scanning module is installed.",
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar
		),
		// 13
		list(
			"desc" = "The advanced scanning module is secured.",
			"key" = /obj/item/stock_part/capacitor/adv,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/screwdriver
		),
		// 14
		list(
			"desc" = "An advanced capacitor is installed.",
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar
		),
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
			"key" = /obj/item/mecha_part/part/serenity_carapace,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"back_key" = /obj/item/weldingtool
		),
		// 19
		list(
			"desc" = MECHA_DESC_EXTERNAL_CARAPACE_INSTALLED,
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar
		),
		// 20
		list(
			"desc" = MECHA_DESC_EXTERNAL_CARAPACE_WRENCHED,
			"key" = /obj/item/weldingtool,
			"icon_state" = "serenity19",
			"back_key" = /obj/item/wrench
		)
	)

	base_icon = "gygax"

	central_circuit = /obj/item/circuitboard/mecha/gygax/main
	peripherals_circuit = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/construction/reversible/mecha/serenity/custom_action(diff, obj/item/used_item, mob/living/user)
	if(!..())
		return FALSE

	switch(index)
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the medical control module into \the [holder]."),
					SPAN_NOTICE("You install the medical control module into \the [holder].")
				)
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' medical control module."),
					SPAN_NOTICE("You secure \the [holder]' medical control module.")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the medical control module from \the [holder]."),
					SPAN_NOTICE("You remove the medical control module from \the [holder].")
				)
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs an advanced scanning module to \the [holder]."),
					SPAN_NOTICE("You install an advanced scanning module to \the [holder].")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' medical control module."),
					SPAN_NOTICE("You unfasten \the [holder]' medical control module.")
				)
		if(12)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' advanced scanner module."),
					SPAN_NOTICE("You secure \the [holder]' advanced scanner module.")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the advanced scanning module from \the [holder]."),
					SPAN_NOTICE("You remove the advanced scanning module from \the [holder].")
				)
		if(13)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs an advanced capacitor to \the [holder]."),
					SPAN_NOTICE("You install an advanced capacitor to \the [holder].")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' advanced scanner module."),
					SPAN_NOTICE("You unfasten \the [holder]' advanced scanner module.")
				)
		if(14)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' advanced capacitor."),
					SPAN_NOTICE("You secure \the [holder]' advanced capacitor.")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the advanced capacitor from \the [holder]."),
					SPAN_NOTICE("You remove the advanced capacitor from \the [holder].")
				)
		if(15)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' advanced capacitor."),
					SPAN_NOTICE("You unfasten \the [holder]' advanced capacitor.")
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
				MECHA_INSTALL_EXTERNAL_CARAPACE
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
		if(19)
			if(diff == FORWARD)
				MECHA_SECURE_EXTERNAL_CARAPACE
			else
				MECHA_REMOVE_EXTERNAL_CARAPACE
		if(20)
			if(diff == FORWARD)
				MECHA_WELD_EXTERNAL_CARAPACE
			else
				MECHA_UNSECURE_EXTERNAL_CARAPACE
	return TRUE

/datum/construction/reversible/mecha/serenity/spawn_result()
	. = ..()
	feedback_inc("mecha_serenity_created", 1)