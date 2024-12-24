// Archambeau Chassis
/datum/construction/mecha/chassis/archambeau
	steps = list(
		list("key" = /obj/item/mecha_part/part/durand_torso),		//1
		list("key" = /obj/item/mecha_part/part/durand_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/durand_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/durand_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/durand_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/durand_head)
	)

/datum/construction/mecha/chassis/archambeau/spawn_result()
	. = ..(/datum/construction/reversible/mecha/archambeau, "durand0")

// Durand
/datum/construction/reversible/mecha/archambeau
	result = /obj/mecha/combat/durand/archambeau
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
			"key" = /obj/item/mecha_part/part/archambeau_armour,
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
			"desc" = "The super capacitor is secured."
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "A super capacitor is installed."
		),
		//8
		list(
			"key" = /obj/item/stock_part/capacitor/super,
			"back_key" = /obj/item/screwdriver,
			"desc" = "The phasic scanning module is secured."
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"back_key" = /obj/item/crowbar,
			"desc" = "A phasic scanning module is installed."
		),
		//10
		list(
			"key" = /obj/item/stock_part/scanning_module/phasic,
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
			"key" = /obj/item/circuitboard/mecha/archambeau/targeting,
			"back_key" = /obj/item/screwdriver,
			"desc" = MECHA_DESC_PERIPHERAL_MODULE_SECURED
		)
	)

	central_circuit = /obj/item/circuitboard/mecha/archambeau/main
	peripherals_circuit = /obj/item/circuitboard/mecha/archambeau/peripherals

/datum/construction/reversible/mecha/archambeau/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	switch(index)
		if(20)
			MECHA_CONNECT_HYDRAULICS
			holder.icon_state = "durand1"
		if(19)
			if(diff == FORWARD)
				MECHA_ACTIVATE_HYDRAULICS
				holder.icon_state = "durand2"
			else
				MECHA_DISCONNECT_HYDRAULICS
				holder.icon_state = "durand0"
		if(18)
			if(diff == FORWARD)
				MECHA_ADD_WIRING
				holder.icon_state = "durand3"
			else
				MECHA_DEACTIVATE_HYDRAULICS
				holder.icon_state = "durand1"
		if(17)
			if(diff == FORWARD)
				MECHA_ADJUST_WIRING
				holder.icon_state = "durand4"
			else
				MECHA_REMOVE_WIRING
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "durand2"
		if(16)
			if(diff == FORWARD)
				MECHA_INSTALL_CENTRAL_MODULE
				qdel(used_atom)
				holder.icon_state = "durand5"
			else
				MECHA_DISCONNECT_WIRING
				holder.icon_state = "durand3"
		if(15)
			if(diff == FORWARD)
				MECHA_SECURE_CENTRAL_MODULE
				holder.icon_state = "durand6"
			else
				MECHA_REMOVE_CENTRAL_MODULE
				new /obj/item/circuitboard/mecha/archambeau/main(GET_TURF(holder))
				holder.icon_state = "durand4"
		if(14)
			if(diff == FORWARD)
				MECHA_INSTALL_PERIPHERAL_MODULE
				qdel(used_atom)
				holder.icon_state = "durand7"
			else
				MECHA_UNSECURE_CENTRAL_MODULE
				holder.icon_state = "durand5"
		if(13)
			if(diff == FORWARD)
				MECHA_SECURE_PERIPHERAL_MODULE
				holder.icon_state = "durand8"
			else
				MECHA_REMOVE_PERIPHERAL_MODULE
				new /obj/item/circuitboard/mecha/archambeau/peripherals(GET_TURF(holder))
				holder.icon_state = "durand6"
		if(12)
			if(diff == FORWARD)
				MECHA_INSTALL_WEAPON_MODULE
				qdel(used_atom)
				holder.icon_state = "durand9"
			else
				MECHA_UNSECURE_PERIPHERAL_MODULE
				holder.icon_state = "durand7"
		if(11)
			if(diff == FORWARD)
				MECHA_SECURE_WEAPON_MODULE
				holder.icon_state = "durand10"
			else
				MECHA_REMOVE_WEAPON_MODULE
				new /obj/item/circuitboard/mecha/archambeau/targeting(GET_TURF(holder))
				holder.icon_state = "durand8"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs a phasic scanning module to \the [holder]."),
					SPAN_NOTICE("You install a phasic scanning module to \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "durand11"
			else
				MECHA_UNSECURE_WEAPON_MODULE
				holder.icon_state = "durand9"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' phasic scanner module."),
					SPAN_NOTICE("You secure \the [holder]' phasic scanner module.")
				)
				holder.icon_state = "durand12"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the phasic scanning module from \the [holder]."),
					SPAN_NOTICE("You remove the phasic scanning module from \the [holder].")
				)
				new /obj/item/stock_part/scanning_module/phasic(GET_TURF(holder))
				holder.icon_state = "durand10"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs a super capacitor to \the [holder]."),
					SPAN_NOTICE("You install a super capacitor to \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "durand13"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]' phasic scanner module."),
					SPAN_NOTICE("You unfasten \the [holder]' phasic scanner module.")
				)
				holder.icon_state = "durand11"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' super capacitor."),
					SPAN_NOTICE("You secure \the [holder]' super capacitor.")
				)
				holder.icon_state = "durand14"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the super capacitor from \the [holder]."),
					SPAN_NOTICE("You remove the super capacitor from \the [holder].")
				)
				new /obj/item/stock_part/capacitor/super(GET_TURF(holder))
				holder.icon_state = "durand12"
		if(6)
			if(diff == FORWARD)
				MECHA_INSTALL_INTERNAL_ARMOUR
				holder.icon_state = "durand15"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s advanced capacitor."),
					SPAN_NOTICE("You unfasten \the [holder]'s advanced capacitor.")
				)
				holder.icon_state = "durand13"
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
				MECHA_INSTALL_ARMOUR_PLATES
				qdel(used_atom)
				holder.icon_state = "durand18"
			else
				MECHA_UNWELD_INTERNAL_ARMOUR
				holder.icon_state = "durand16"
		if(2)
			if(diff == FORWARD)
				MECHA_SECURE_ARMOUR_PLATES
				holder.icon_state = "archambeau19"
			else
				MECHA_REMOVE_ARMOUR_PLATES
				new /obj/item/mecha_part/part/archambeau_armour(GET_TURF(holder))
				holder.icon_state = "durand17"
		if(1)
			if(diff == FORWARD)
				MECHA_WELD_ARMOUR_PLATES
			else
				MECHA_UNSECURE_ARMOUR_PLATES
				holder.icon_state = "durand18"
	return TRUE

/datum/construction/reversible/mecha/archambeau/spawn_result()
	. = ..()
	feedback_inc("mecha_archambeau_created", 1)