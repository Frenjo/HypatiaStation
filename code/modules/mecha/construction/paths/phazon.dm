// Phazon Chassis
/datum/construction/mecha_chassis/phazon
	result = /datum/construction/reversible/mecha/phazon
	steps = list(
		list("key" = /obj/item/mecha_part/part/phazon_torso),		//1
		list("key" = /obj/item/mecha_part/part/phazon_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/phazon_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/phazon_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/phazon_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/phazon_head)
	)

// Phazon
/datum/construction/reversible/mecha/phazon
	result = /obj/mecha/combat/phazon
	steps = list(
		//1
		list(
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench,
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_WRENCHED
		),
		//2
		list(
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar,
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_INSTALLED
		),
		//3
		list(
			"key" = /obj/item/mecha_part/part/phazon_armour,
			"back_key" = /obj/item/weldingtool,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WELDED
		),
		//4
		list(
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WRENCHED
		),
		//5
		list(
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_INSTALLED
		),
		//6
		list(
			"key" = /obj/item/stack/sheet/plasteel,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The hyper capacitor is secured."
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "A hyper capacitor is installed."
		),
		//8
		list(
			"key" = /obj/item/stock_part/capacitor/hyper,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The hyper-phasic scanning module is secured."
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "A hyper-phasic scanning module is installed."
		),
		//10
		list(
			"key" = /obj/item/stock_part/scanning_module/hyperphasic,
			"back_key" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_TARGETING_MODULE_SECURED
		),
		//11
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = MECHA_DESC_TARGETING_MODULE_INSTALLED
		),
		//12
		list(
			"key" = /obj/item/circuitboard/mecha/phazon/targeting,
			"back_key" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED
		)
	)

	base_icon = "phazon"

	central_circuit = /obj/item/circuitboard/mecha/phazon/main
	peripherals_circuit = /obj/item/circuitboard/mecha/phazon/peripherals

/datum/construction/reversible/mecha/phazon/custom_action(index, diff, obj/item/used_item, mob/living/user)
	if(!..())
		return FALSE

	switch(index)
		if(20)
			MECHA_CONNECT_HYDRAULICS
			holder.icon_state = "phazon1"
		if(19)
			if(diff == FORWARD)
				MECHA_ACTIVATE_HYDRAULICS
				holder.icon_state = "phazon2"
			else
				MECHA_DISCONNECT_HYDRAULICS
				holder.icon_state = "phazon0"
		if(18)
			if(diff == FORWARD)
				MECHA_ADD_WIRING
				holder.icon_state = "phazon3"
			else
				MECHA_DEACTIVATE_HYDRAULICS
				holder.icon_state = "phazon1"
		if(17)
			if(diff == FORWARD)
				MECHA_ADJUST_WIRING
				holder.icon_state = "phazon4"
			else
				MECHA_REMOVE_WIRING
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "phazon2"
		if(16)
			if(diff == FORWARD)
				MECHA_INSTALL_CENTRAL_MODULE
				qdel(used_item)
				holder.icon_state = "phazon5"
			else
				MECHA_DISCONNECT_WIRING
				holder.icon_state = "phazon3"
		if(15)
			if(diff == FORWARD)
				MECHA_SECURE_CENTRAL_MODULE
				holder.icon_state = "phazon6"
			else
				MECHA_REMOVE_CENTRAL_MODULE
				new /obj/item/circuitboard/mecha/phazon/main(GET_TURF(holder))
				holder.icon_state = "phazon4"
		if(14)
			if(diff == FORWARD)
				MECHA_INSTALL_PERIPHERAL_MODULE
				qdel(used_item)
				holder.icon_state = "phazon7"
			else
				MECHA_UNSECURE_CENTRAL_MODULE
				holder.icon_state = "phazon5"
		if(13)
			if(diff == FORWARD)
				MECHA_SECURE_PERIPHERAL_MODULE
				holder.icon_state = "phazon8"
			else
				MECHA_REMOVE_PERIPHERAL_MODULE
				new /obj/item/circuitboard/mecha/phazon/peripherals(GET_TURF(holder))
				holder.icon_state = "phazon6"
		if(12)
			if(diff == FORWARD)
				MECHA_INSTALL_WEAPON_MODULE
				qdel(used_item)
				holder.icon_state = "phazon9"
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
				holder.icon_state = "phazon7"
		if(11)
			if(diff == FORWARD)
				MECHA_SECURE_WEAPON_MODULE
				holder.icon_state = "phazon10"
			else
				MECHA_REMOVE_WEAPON_MODULE
				new /obj/item/circuitboard/mecha/phazon/targeting(GET_TURF(holder))
				holder.icon_state = "phazon8"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs a hyper-phasic scanning module to \the [holder]."),
					SPAN_NOTICE("You install a hyper-phasic scanning module to \the [holder].")
				)
				qdel(used_item)
				holder.icon_state = "phazon11"
			else
				MECHA_UNSECURE_WEAPON_MODULE
				holder.icon_state = "phazon9"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' hyper-phasic scanning module."),
					SPAN_NOTICE("You secure \the [holder]' hyper-phasic scanning module.")
				)
				holder.icon_state = "phazon12"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the hyper-phasic scanning module from \the [holder]."),
					SPAN_NOTICE("You remove the hyper-phasic scanning module from \the [holder].")
				)
				new /obj/item/stock_part/scanning_module/hyperphasic(GET_TURF(holder))
				holder.icon_state = "phazon10"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs a hyper capacitor to \the [holder]."),
					SPAN_NOTICE("You install a hyper capacitor to \the [holder].")
				)
				qdel(used_item)
				holder.icon_state = "phazon13"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' hyper-phasic scanner module."),
					SPAN_NOTICE("You unfasten \the [holder]' hyper-phasic scanner module.")
				)
				holder.icon_state = "phazon11"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' hyper capacitor."),
					SPAN_NOTICE("You secure \the [holder]' hyper capacitor.")
				)
				holder.icon_state = "phazon14"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the hyper capacitor from \the [holder]."),
					SPAN_NOTICE("You remove the hyper capacitor from \the [holder].")
				)
				new /obj/item/stock_part/capacitor/hyper(GET_TURF(holder))
				holder.icon_state = "phazon12"
		if(6)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
				holder.icon_state = "phazon15"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' advanced capacitor."),
					SPAN_NOTICE("You unfasten \the [holder]' advanced capacitor.")
				)
				holder.icon_state = "phazon13"
		if(5)
			if(diff == FORWARD)
				MECHA_SECURE_INTERNAL_ARMOUR
				holder.icon_state = "phazon16"
			else
				MECHA_REMOVE_INTERNAL_ARMOUR
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "phazon14"
		if(4)
			if(diff == FORWARD)
				MECHA_WELD_INTERNAL_ARMOUR
				holder.icon_state = "phazon17"
			else
				MECHA_UNSECURE_INTERNAL_ARMOUR
				holder.icon_state = "phazon15"
		if(3)
			if(diff == FORWARD)
				MECHA_INSTALL_ARMOUR_PLATES
				qdel(used_item)
				holder.icon_state = "phazon18"
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
				holder.icon_state = "phazon16"
		if(2)
			if(diff == FORWARD)
				MECHA_SECURE_ARMOUR_PLATES
				holder.icon_state = "phazon19"
			else
				MECHA_REMOVE_ARMOUR_PLATES
				new /obj/item/mecha_part/part/phazon_armour(GET_TURF(holder))
				holder.icon_state = "phazon17"
		if(1)
			if(diff == FORWARD)
				MECHA_WELD_ARMOUR_PLATES
			else
				MECHA_UNSECURE_ARMOUR_PLATES
				holder.icon_state = "phazon18"
	return TRUE

/datum/construction/reversible/mecha/phazon/spawn_result()
	. = ..()
	feedback_inc("mecha_phazon_created", 1)