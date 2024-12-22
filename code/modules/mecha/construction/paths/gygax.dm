// Gygax Chassis
/datum/construction/mecha/chassis/gygax
	steps = list(
		list("key" = /obj/item/mecha_part/part/gygax_torso),		//1
		list("key" = /obj/item/mecha_part/part/gygax_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/gygax_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/gygax_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/gygax_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/gygax_head)
	)

/datum/construction/mecha/chassis/gygax/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/gygax(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "gygax0"
	const_holder.density = TRUE
	spawn()
		qdel(src)

// Gygax
/datum/construction/reversible/mecha/gygax
	result = /obj/mecha/combat/gygax
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
			"key" = /obj/item/mecha_part/part/gygax_armour,
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
			"desc" = "The advanced capacitor is secured."
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "An advanced capacitor is installed."
		),
		//8
		list(
			"key" = /obj/item/stock_part/capacitor/adv,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The advanced scanning module is secured."
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "An advanced scanning module is installed."
		),
		//10
		list(
			"key" = /obj/item/stock_part/scanning_module/adv,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_TARGETING_MODULE_SECURED
		),
		//11
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = MECHA_DESC_TARGETING_MODULE_INSTALLED
		),
		//12
		list(
			"key" = /obj/item/circuitboard/mecha/gygax/targeting,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED
		),
		//13
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_INSTALLED
		),
		//14
		list(
			"key" = /obj/item/circuitboard/mecha/gygax/peripherals,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_CENTRAL_MODULE_SECURED
		),
		//15
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = MECHA_DESC_CENTRAL_MODULE_INSTALLED
		),
		//16
		list(
			"key" = /obj/item/circuitboard/mecha/gygax/main,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_WIRING_ADJUSTED
		),
		//17
		list(
			"key" = /obj/item/wirecutters,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_WIRING_ADDED
		),
		//18
		list(
			"key" = /obj/item/stack/cable_coil,
			"backkey" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_HYDRAULICS_ACTIVE
		),
		//19
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/wrench,
			"desc" = MECHA_DESC_HYDRAULICS_CONNECTED
		),
		//20
		list(
			"key" = /obj/item/wrench,
			"desc" = MECHA_DESC_HYDRAULICS_DISCONNECTED
		)
	)

/datum/construction/reversible/mecha/gygax/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	switch(index)
		if(20)
			MECHA_CONNECT_HYDRAULICS
			holder.icon_state = "gygax1"
		if(19)
			if(diff == FORWARD)
				MECHA_ACTIVATE_HYDRAULICS
				holder.icon_state = "gygax2"
			else
				MECHA_DISCONNECT_HYDRAULICS
				holder.icon_state = "gygax0"
		if(18)
			if(diff == FORWARD)
				MECHA_ADD_WIRING
				holder.icon_state = "gygax3"
			else
				MECHA_DEACTIVATE_HYDRAULICS
				holder.icon_state = "gygax1"
		if(17)
			if(diff == FORWARD)
				MECHA_ADJUST_WIRING
				holder.icon_state = "gygax4"
			else
				MECHA_REMOVE_WIRING
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "gygax2"
		if(16)
			if(diff == FORWARD)
				MECHA_INSTALL_CENTRAL_MODULE
				qdel(used_atom)
				holder.icon_state = "gygax5"
			else
				MECHA_DISCONNECT_WIRING
				holder.icon_state = "gygax3"
		if(15)
			if(diff == FORWARD)
				MECHA_SECURE_CENTRAL_MODULE
				holder.icon_state = "gygax6"
			else
				MECHA_REMOVE_CENTRAL_MODULE
				new /obj/item/circuitboard/mecha/gygax/main(GET_TURF(holder))
				holder.icon_state = "gygax4"
		if(14)
			if(diff == FORWARD)
				MECHA_INSTALL_PERIPHERAL_MODULE
				qdel(used_atom)
				holder.icon_state = "gygax7"
			else
				MECHA_UNSECURE_CENTRAL_MODULE
				holder.icon_state = "gygax5"
		if(13)
			if(diff == FORWARD)
				MECHA_SECURE_PERIPHERAL_MODULE
				holder.icon_state = "gygax8"
			else
				MECHA_REMOVE_PERIPHERAL_MODULE
				new /obj/item/circuitboard/mecha/gygax/peripherals(GET_TURF(holder))
				holder.icon_state = "gygax6"
		if(12)
			if(diff == FORWARD)
				MECHA_INSTALL_WEAPON_MODULE
				qdel(used_atom)
				holder.icon_state = "gygax9"
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
				holder.icon_state = "gygax7"
		if(11)
			if(diff == FORWARD)
				MECHA_SECURE_WEAPON_MODULE
				holder.icon_state = "gygax10"
			else
				MECHA_REMOVE_WEAPON_MODULE
				new /obj/item/circuitboard/mecha/gygax/targeting(GET_TURF(holder))
				holder.icon_state = "gygax8"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs an advanced scanning module to \the [holder]."),
					SPAN_NOTICE("You install an advanced scanning module to \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "gygax11"
			else
				MECHA_UNSECURE_WEAPON_MODULE
				holder.icon_state = "gygax9"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s advanced scanner module."),
					SPAN_NOTICE("You secure \the [holder]'s advanced scanner module.")
				)
				holder.icon_state = "gygax12"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the advanced scanning module from \the [holder]."),
					SPAN_NOTICE("You remove the advanced scanning module from \the [holder].")
				)
				new /obj/item/stock_part/scanning_module/adv(GET_TURF(holder))
				holder.icon_state = "gygax10"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs an advanced capacitor to \the [holder]."),
					SPAN_NOTICE("You install an advanced capacitor to \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "gygax13"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s advanced scanner module."),
					SPAN_NOTICE("You unfasten \the [holder]'s advanced scanner module.")
				)
				holder.icon_state = "gygax11"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s advanced capacitor."),
					SPAN_NOTICE("You secure \the [holder]'s advanced capacitor.")
				)
				holder.icon_state = "gygax14"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the advanced capacitor from \the [holder]."),
					SPAN_NOTICE("You remove the advanced capacitor from \the [holder].")
				)
				new /obj/item/stock_part/capacitor/adv(GET_TURF(holder))
				holder.icon_state = "gygax12"
		if(6)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
				holder.icon_state = "gygax15"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s advanced capacitor."),
					SPAN_NOTICE("You unfasten \the [holder]'s advanced capacitor.")
				)
				holder.icon_state = "gygax13"
		if(5)
			if(diff == FORWARD)
				MECHA_SECURE_INTERNAL_ARMOUR
				holder.icon_state = "gygax16"
			else
				MECHA_REMOVE_INTERNAL_ARMOUR
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "gygax14"
		if(4)
			if(diff == FORWARD)
				MECHA_WELD_INTERNAL_ARMOUR
				holder.icon_state = "gygax17"
			else
				MECHA_UNSECURE_INTERNAL_ARMOUR
				holder.icon_state = "gygax15"
		if(3)
			if(diff == FORWARD)
				MECHA_INSTALL_ARMOUR_PLATES
				qdel(used_atom)
				holder.icon_state = "gygax18"
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
				holder.icon_state = "gygax16"
		if(2)
			if(diff == FORWARD)
				MECHA_SECURE_ARMOUR_PLATES
				holder.icon_state = "gygax19"
			else
				MECHA_REMOVE_ARMOUR_PLATES
				new /obj/item/mecha_part/part/gygax_armour(GET_TURF(holder))
				holder.icon_state = "gygax17"
		if(1)
			if(diff == FORWARD)
				MECHA_WELD_ARMOUR_PLATES
			else
				MECHA_UNSECURE_ARMOUR_PLATES
				holder.icon_state = "gygax18"
	return TRUE

/datum/construction/reversible/mecha/gygax/spawn_result()
	. = ..()
	feedback_inc("mecha_gygax_created", 1)