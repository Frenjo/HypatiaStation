// Firefighter Chassis
/datum/construction/mecha/chassis/firefighter
	steps = list(
		list("key" = /obj/item/mecha_part/part/ripley_torso),		//1
		list("key" = /obj/item/mecha_part/part/ripley_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/ripley_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/ripley_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/ripley_right_leg),	//5
		list("key" = /obj/item/clothing/suit/fire)					//6
	)

/datum/construction/mecha/chassis/firefighter/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/firefighter(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "fireripley0"
	const_holder.density = TRUE
	spawn()
		qdel(src)

// Firefighter
/datum/construction/reversible/mecha/firefighter
	result = /obj/mecha/working/ripley/firefighter
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
			"back_key" = /obj/item/crowbar,
			"desc" = "The external armour is partially installed."
		),
		//4
		list(
			"key" = /obj/item/stack/sheet/plasteel,
			"back_key" = /obj/item/weldingtool,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WELDED
		),
		//5
		list(
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_WRENCHED
		),
		//6
		list(
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar,
			"desc" = MECHA_DESC_INTERNAL_ARMOUR_INSTALLED
		),

		//7
		list(
			"key" = /obj/item/stack/sheet/plasteel,
			"back_key" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED
		)
	)

	central_circuit = /obj/item/circuitboard/mecha/ripley/main
	peripherals_circuit = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/construction/reversible/mecha/firefighter/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	switch(index)
		if(15)
			MECHA_CONNECT_HYDRAULICS
			holder.icon_state = "fireripley1"
		if(14)
			if(diff == FORWARD)
				MECHA_ACTIVATE_HYDRAULICS
				holder.icon_state = "fireripley2"
			else
				MECHA_DISCONNECT_HYDRAULICS
				holder.icon_state = "fireripley0"
		if(13)
			if(diff == FORWARD)
				MECHA_ADD_WIRING
				holder.icon_state = "fireripley3"
			else
				MECHA_DEACTIVATE_HYDRAULICS
				holder.icon_state = "fireripley1"
		if(12)
			if(diff == FORWARD)
				MECHA_ADJUST_WIRING
				holder.icon_state = "fireripley4"
			else
				MECHA_REMOVE_WIRING
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "fireripley2"
		if(11)
			if(diff == FORWARD)
				MECHA_INSTALL_CENTRAL_MODULE
				qdel(used_atom)
				holder.icon_state = "fireripley5"
			else
				MECHA_DISCONNECT_WIRING
				holder.icon_state = "fireripley3"
		if(10)
			if(diff == FORWARD)
				MECHA_SECURE_CENTRAL_MODULE
				holder.icon_state = "fireripley6"
			else
				MECHA_REMOVE_CENTRAL_MODULE
				new /obj/item/circuitboard/mecha/ripley/main(GET_TURF(holder))
				holder.icon_state = "fireripley4"
		if(9)
			if(diff == FORWARD)
				MECHA_INSTALL_PERIPHERAL_MODULE
				qdel(used_atom)
				holder.icon_state = "fireripley7"
			else
				MECHA_UNSECURE_CENTRAL_MODULE
				holder.icon_state = "fireripley5"
		if(8)
			if(diff == FORWARD)
				MECHA_SECURE_PERIPHERAL_MODULE
				holder.icon_state = "fireripley8"
			else
				MECHA_REMOVE_PERIPHERAL_MODULE
				new /obj/item/circuitboard/mecha/ripley/peripherals(GET_TURF(holder))
				holder.icon_state = "fireripley6"
		if(7)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
				holder.icon_state = "fireripley9"
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
				holder.icon_state = "fireripley7"

		if(6)
			if(diff == FORWARD)
				MECHA_SECURE_INTERNAL_ARMOUR
				holder.icon_state = "fireripley10"
			else
				MECHA_REMOVE_INTERNAL_ARMOUR
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "fireripley8"
		if(5)
			if(diff == FORWARD)
				MECHA_WELD_INTERNAL_ARMOUR
				holder.icon_state = "fireripley11"
			else
				MECHA_UNSECURE_INTERNAL_ARMOUR
				holder.icon_state = "fireripley9"
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] partially installs the external armour layer on \the [holder]."),
					SPAN_NOTICE("You partially install the external armour layer on \the [holder].")
				)
				holder.icon_state = "fireripley12"
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
				holder.icon_state = "fireripley10"
		if(3)
			if(diff == FORWARD)
				MECHA_INSTALL_EXTERNAL_ARMOUR
				holder.icon_state = "fireripley13"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the partial external armour layer from \the [holder]."),
					SPAN_NOTICE("You remove the partial external armour layer from \the [holder].")
				)
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "fireripley11"
		if(2)
			if(diff == FORWARD)
				MECHA_SECURE_EXTERNAL_ARMOUR
				holder.icon_state = "fireripley14"
			else
				MECHA_REMOVE_EXTERNAL_ARMOUR
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "fireripley12"
		if(1)
			if(diff == FORWARD)
				MECHA_WELD_EXTERNAL_ARMOUR
			else
				MECHA_UNSECURE_EXTERNAL_ARMOUR
				holder.icon_state = "fireripley13"
	return TRUE

/datum/construction/reversible/mecha/firefighter/spawn_result()
	. = ..()
	feedback_inc("mecha_firefighter_created", 1)