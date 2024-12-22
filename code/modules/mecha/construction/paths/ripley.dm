// Ripley Chassis
/datum/construction/mecha/chassis/ripley
	steps = list(
		list("key" = /obj/item/mecha_part/part/ripley_torso),		//1
		list("key" = /obj/item/mecha_part/part/ripley_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/ripley_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/ripley_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/ripley_right_leg)	//5
	)

/datum/construction/mecha/chassis/ripley/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/ripley(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "ripley0"
	const_holder.density = TRUE
	const_holder.overlays.len = 0
	spawn()
		qdel(src)

// Ripley
/datum/construction/reversible/mecha/ripley
	result = /obj/mecha/working/ripley
	steps = list(
		//1
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_WRENCHED
			),
		//2
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = MECHA_DESC_EXTERNAL_ARMOUR_INSTALLED
		),
		//3
		list(
			"key" = /obj/item/stack/sheet/plasteel,
			"backkey" = /obj/item/weldingtool,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WELDED
		),
		//4
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WRENCHED
		),
		//5
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_INSTALLED
		),
		//6
		list(
			"key" = /obj/item/stack/sheet/steel,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_INSTALLED
		),
		//8
		list(
			"key" = /obj/item/circuitboard/mecha/ripley/peripherals,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_CENTRAL_MODULE_SECURED
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = MECHA_DESC_CENTRAL_MODULE_INSTALLED
		),
		//10
		list(
			"key" = /obj/item/circuitboard/mecha/ripley/main,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_WIRING_ADJUSTED
		),
		//11
		list(
			"key" = /obj/item/wirecutters,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_WIRING_ADDED
		),
		//12
		list(
			"key" = /obj/item/stack/cable_coil,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_HYDRAULICS_ACTIVE
		),
		//13
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/wrench,
			"desc" = MECHA_DESC_HYDRAULICS_CONNECTED
		),
		//14
		list(
			"key" = /obj/item/wrench,
			"desc" = MECHA_DESC_HYDRAULICS_DISCONNECTED
		)
	)

/datum/construction/reversible/mecha/ripley/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	switch(index)
		if(14)
			MECHA_CONNECT_HYDRAULICS
			holder.icon_state = "ripley1"
		if(13)
			if(diff == FORWARD)
				MECHA_ACTIVATE_HYDRAULICS
				holder.icon_state = "ripley2"
			else
				MECHA_DISCONNECT_HYDRAULICS
				holder.icon_state = "ripley0"
		if(12)
			if(diff == FORWARD)
				MECHA_ADD_WIRING
				holder.icon_state = "ripley3"
			else
				MECHA_DEACTIVATE_HYDRAULICS
				holder.icon_state = "ripley1"
		if(11)
			if(diff == FORWARD)
				MECHA_ADJUST_WIRING
				holder.icon_state = "ripley4"
			else
				MECHA_REMOVE_WIRING
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "ripley2"
		if(10)
			if(diff == FORWARD)
				MECHA_INSTALL_CENTRAL_MODULE
				qdel(used_atom)
				holder.icon_state = "ripley5"
			else
				MECHA_DISCONNECT_WIRING
				holder.icon_state = "ripley3"
		if(9)
			if(diff == FORWARD)
				MECHA_SECURE_CENTRAL_MODULE
				holder.icon_state = "ripley6"
			else
				MECHA_REMOVE_CENTRAL_MODULE
				new /obj/item/circuitboard/mecha/ripley/main(GET_TURF(holder))
				holder.icon_state = "ripley4"
		if(8)
			if(diff == FORWARD)
				MECHA_INSTALL_PERIPHERAL_MODULE
				qdel(used_atom)
				holder.icon_state = "ripley7"
			else
				MECHA_UNSECURE_CENTRAL_MODULE
				holder.icon_state = "ripley5"
		if(7)
			if(diff == FORWARD)
				MECHA_SECURE_PERIPHERAL_MODULE
				holder.icon_state = "ripley8"
			else
				MECHA_REMOVE_PERIPHERAL_MODULE
				new /obj/item/circuitboard/mecha/ripley/peripherals(GET_TURF(holder))
				holder.icon_state = "ripley6"
		if(6)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
				holder.icon_state = "ripley9"
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
				holder.icon_state = "ripley7"
		if(5)
			if(diff == FORWARD)
				MECHA_SECURE_INTERNAL_ARMOUR
				holder.icon_state = "ripley10"
			else
				MECHA_REMOVE_INTERNAL_ARMOUR
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "ripley8"
		if(4)
			if(diff == FORWARD)
				MECHA_WELD_INTERNAL_ARMOUR
				holder.icon_state = "ripley11"
			else
				MECHA_UNSECURE_INTERNAL_ARMOUR
				holder.icon_state = "ripley9"
		if(3)
			if(diff == FORWARD)
				MECHA_INSTALL_EXTERNAL_ARMOUR
				holder.icon_state = "ripley12"
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
				holder.icon_state = "ripley10"
		if(2)
			if(diff == FORWARD)
				MECHA_SECURE_EXTERNAL_ARMOUR
				holder.icon_state = "ripley13"
			else
				MECHA_REMOVE_EXTERNAL_ARMOUR
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "ripley11"
		if(1)
			if(diff == FORWARD)
				MECHA_WELD_EXTERNAL_ARMOUR
			else
				MECHA_UNSECURE_EXTERNAL_ARMOUR
				holder.icon_state = "ripley12"
	return TRUE

/datum/construction/reversible/mecha/ripley/spawn_result()
	. = ..()
	feedback_inc("mecha_ripley_created", 1)