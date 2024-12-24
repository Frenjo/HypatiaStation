// Serenity Chassis
/datum/construction/mecha/chassis/serenity
	steps = list(
		list("key" = /obj/item/mecha_part/part/gygax_torso),		//1
		list("key" = /obj/item/mecha_part/part/gygax_left_arm),		//2
		list("key" = /obj/item/mecha_part/part/gygax_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/gygax_left_leg),		//4
		list("key" = /obj/item/mecha_part/part/gygax_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/gygax_head)
	)

/datum/construction/mecha/chassis/serenity/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/serenity(const_holder)
	const_holder.icon = 'icons/obj/mecha/mech_construction.dmi'
	const_holder.icon_state = "gygax0"
	const_holder.density = TRUE
	spawn()
		qdel(src)

// Serenity
/datum/construction/reversible/mecha/serenity
	result = /obj/mecha/combat/gygax/serenity
	steps = list(
		//1
		list(
			"key" = /obj/item/weldingtool,
			"back_key" = /obj/item/wrench,
			"desc" = MECHA_DESC_EXTERNAL_CARAPACE_WRENCHED
		),
		//2
		list(
			"key" = /obj/item/wrench,
			"back_key" = /obj/item/crowbar,
			"desc" = MECHA_DESC_EXTERNAL_CARAPACE_INSTALLED
		),
		//3
		list(
			"key" = /obj/item/mecha_part/part/serenity_carapace,
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
			"desc" = "The advanced capacitor is secured."
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "An advanced capacitor is installed."
		),
		//8
		list(
			"key" = /obj/item/stock_part/capacitor/adv,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The advanced scanning module is secured."
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "An advanced scanning module is installed."
		),
		//10
		list(
			"key" = /obj/item/stock_part/scanning_module/adv,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The medical module is secured."
		),
		//11
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "The medical module is installed."
		),
		//12
		list(
			"key" = /obj/item/circuitboard/mecha/serenity/medical,
			"back_key" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED
		)
	)

	central_circuit = /obj/item/circuitboard/mecha/gygax/main
	peripherals_circuit = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/construction/reversible/mecha/serenity/custom_action(index, diff, atom/used_atom, mob/user)
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
				user.visible_message(
					SPAN_NOTICE("[user] installs the medical control module into \the [holder]."),
					SPAN_NOTICE("You install the medical control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "gygax9"
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
				holder.icon_state = "gygax7"
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' medical control module."),
					SPAN_NOTICE("You secure \the [holder]' medical control module.")
				)
				holder.icon_state = "gygax10"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the medical control module from \the [holder]."),
					SPAN_NOTICE("You remove the medical control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/serenity/medical(GET_TURF(holder))
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
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' medical control module."),
					SPAN_NOTICE("You unfasten \the [holder]' medical control module.")
				)
				holder.icon_state = "gygax9"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' advanced scanner module."),
					SPAN_NOTICE("You secure \the [holder]' advanced scanner module.")
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
					SPAN_NOTICE("[user] unfastens \the [holder]' advanced scanner module."),
					SPAN_NOTICE("You unfasten \the [holder]' advanced scanner module.")
				)
				holder.icon_state = "gygax11"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' advanced capacitor."),
					SPAN_NOTICE("You secure \the [holder]' advanced capacitor.")
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
					SPAN_NOTICE("[user] unfastens \the [holder]' advanced capacitor."),
					SPAN_NOTICE("You unfasten \the [holder]' advanced capacitor.")
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
				MECHA_INSTALL_EXTERNAL_CARAPACE
				qdel(used_atom)
				holder.icon_state = "gygax18"
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
				holder.icon_state = "gygax16"
		if(2)
			if(diff == FORWARD)
				MECHA_SECURE_EXTERNAL_CARAPACE
				holder.icon_state = "serenity19"
			else
				MECHA_REMOVE_EXTERNAL_CARAPACE
				new /obj/item/mecha_part/part/serenity_carapace(GET_TURF(holder))
				holder.icon_state = "gygax17"
		if(1)
			if(diff == FORWARD)
				MECHA_WELD_EXTERNAL_CARAPACE
			else
				MECHA_UNSECURE_EXTERNAL_CARAPACE
				holder.icon_state = "gygax18"
	return TRUE

/datum/construction/reversible/mecha/serenity/spawn_result()
	. = ..()
	feedback_inc("mecha_serenity_created", 1)