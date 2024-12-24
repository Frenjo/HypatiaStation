// Dreadnought Chassis
/datum/construction/mecha/chassis/dreadnought
	steps = list(
		list("key" = /obj/item/mecha_part/part/ripley_torso),		//1
		list("key" = /obj/item/mecha_part/part/ripley_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/ripley_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/ripley_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/ripley_right_leg)	//5
	)

/datum/construction/mecha/chassis/dreadnought/spawn_result()
	. = ..(/datum/construction/reversible/mecha/dreadnought, "durand0")

// Dreadnought
/datum/construction/reversible/mecha/dreadnought
	result = /obj/mecha/working/dreadnought
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
			"key" = /obj/item/stack/sheet/plasteel,
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
			"key" = /obj/item/stack/sheet/steel,
			"back_key" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED
		)
	)

	central_circuit = /obj/item/circuitboard/mecha/dreadnought/main
	peripherals_circuit = /obj/item/circuitboard/mecha/dreadnought/peripherals

/datum/construction/reversible/mecha/dreadnought/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	switch(index)
		if(14)
			MECHA_CONNECT_HYDRAULICS
			holder.icon_state = "durand1"
		if(13)
			if(diff == FORWARD)
				MECHA_ACTIVATE_HYDRAULICS
				holder.icon_state = "durand2"
			else
				MECHA_DISCONNECT_HYDRAULICS
				holder.icon_state = "durand0"
		if(12)
			if(diff == FORWARD)
				MECHA_ADD_WIRING
				holder.icon_state = "durand3"
			else
				MECHA_DEACTIVATE_HYDRAULICS
				holder.icon_state = "durand1"
		if(11)
			if(diff == FORWARD)
				MECHA_ADJUST_WIRING
				holder.icon_state = "durand4"
			else
				MECHA_REMOVE_WIRING
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "durand2"
		if(10)
			if(diff == FORWARD)
				MECHA_INSTALL_CENTRAL_MODULE
				qdel(used_atom)
				holder.icon_state = "durand5"
			else
				MECHA_DISCONNECT_WIRING
				holder.icon_state = "durand3"
		if(9)
			if(diff == FORWARD)
				MECHA_SECURE_CENTRAL_MODULE
				holder.icon_state = "durand6"
			else
				MECHA_REMOVE_CENTRAL_MODULE
				new /obj/item/circuitboard/mecha/dreadnought/main(GET_TURF(holder))
				holder.icon_state = "durand4"
		if(8)
			if(diff == FORWARD)
				MECHA_INSTALL_PERIPHERAL_MODULE
				qdel(used_atom)
				holder.icon_state = "durand7"
			else
				MECHA_UNSECURE_CENTRAL_MODULE
				holder.icon_state = "durand5"
		if(7)
			if(diff == FORWARD)
				MECHA_SECURE_PERIPHERAL_MODULE
				holder.icon_state = "durand8"
			else
				MECHA_REMOVE_PERIPHERAL_MODULE
				new /obj/item/circuitboard/mecha/dreadnought/peripherals(GET_TURF(holder))
				holder.icon_state = "durand6"
		if(6)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
				holder.icon_state = "durand15"
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
				holder.icon_state = "durand7"
		if(5)
			if(diff == FORWARD)
				MECHA_SECURE_INTERNAL_ARMOUR
				holder.icon_state = "durand16"
			else
				MECHA_REMOVE_INTERNAL_ARMOUR
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "durand14"
		if(4)
			if(diff == FORWARD)
				MECHA_WELD_INTERNAL_ARMOUR
				holder.icon_state = "durand17"
			else
				MECHA_UNSECURE_INTERNAL_ARMOUR
				holder.icon_state = "durand15"
		if(3)
			if(diff == FORWARD)
				MECHA_INSTALL_EXTERNAL_ARMOUR
				holder.icon_state = "durand18"
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
				holder.icon_state = "durand16"
		if(2)
			if(diff == FORWARD)
				MECHA_SECURE_EXTERNAL_ARMOUR
				holder.icon_state = "dreadnought19"
			else
				MECHA_REMOVE_EXTERNAL_ARMOUR
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "durand17"
		if(1)
			if(diff == FORWARD)
				MECHA_WELD_EXTERNAL_ARMOUR
			else
				MECHA_UNSECURE_EXTERNAL_ARMOUR
				holder.icon_state = "durand18"
	return TRUE

/datum/construction/reversible/mecha/dreadnought/spawn_result()
	. = ..()
	feedback_inc("mecha_dreadnought_created", 1)