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
			"desc" = "The external armor is wrenched."
			),
		//2
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "The external armor is installed."
		),
		//3
		list(
			"key" = /obj/item/mecha_part/part/gygax_armour,
			"backkey" = /obj/item/weldingtool,
			"desc" = "The internal armor is welded."
		),
		//4
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "The internal armor is wrenched."
		),
		//5
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "The internal armor is installed."
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
			"desc" = "The targeting module is secured."
		),
		//11
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "The targeting module is installed."
		),
		//12
		list(
			"key" = /obj/item/circuitboard/mecha/gygax/targeting,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The peripherals control module is secured."
		),
		//13
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "The peripherals control module is installed."
		),
		//14
		list(
			"key" = /obj/item/circuitboard/mecha/gygax/peripherals,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The central control module is secured."
		),
		//15
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "The central control module is installed."
		),
		//16
		list(
			"key" = /obj/item/circuitboard/mecha/gygax/main,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The wiring is adjusted."
		),
		//17
		list(
			"key" = /obj/item/wirecutters,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The wiring is added."
		),
		//18
		list(
			"key" = /obj/item/stack/cable_coil,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The hydraulic systems are active."
		),
		//19
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/wrench,
			"desc" = "The hydraulic systems are connected."
		),
		//20
		list(
			"key" = /obj/item/wrench,
			"desc" = "The hydraulic systems are disconnected."
		)
	)

/datum/construction/reversible/mecha/gygax/action(atom/used_atom, mob/user)
	return check_step(used_atom, user)

/datum/construction/reversible/mecha/gygax/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(20)
			user.visible_message(
				SPAN_NOTICE("[user] connects \the [holder]'s hydraulic systems."),
				SPAN_NOTICE("You connect \the [holder]'s hydraulic systems.")
			)
			holder.icon_state = "gygax1"
		if(19)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] activates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You activate [holder] hydraulic systems.")
				)
				holder.icon_state = "gygax2"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You disconnect \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "gygax0"
		if(18)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adds wiring to \the [holder]."),
					SPAN_NOTICE("You add wiring to \the [holder].")
				)
				holder.icon_state = "gygax3"
			else
				user.visible_message(
					SPAN_NOTICE("[user] deactivates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You deactivate \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "gygax1"
		if(17)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adjusts \the [holder]'s wiring."),
					SPAN_NOTICE("You adjust \the [holder]'s wiring.")
				)
				holder.icon_state = "gygax4"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the wiring from \the [holder]."),
					SPAN_NOTICE("You remove the wiring from \the [holder].")
				)
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "gygax2"
		if(16)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the central control module into \the [holder]."),
					SPAN_NOTICE("You install the central control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "gygax5"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s wiring."),
					SPAN_NOTICE("You disconnect \the [holder]'s wiring.")
				)
				holder.icon_state = "gygax3"
		if(15)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s mainboard."),
					SPAN_NOTICE("You secure \the [holder]'s mainboard.")
				)
				holder.icon_state = "gygax6"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the central control module from \the [holder]."),
					SPAN_NOTICE("You remove the central control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/gygax/main(GET_TURF(holder))
				holder.icon_state = "gygax4"
		if(14)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."),
					SPAN_NOTICE("You install the peripherals control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "gygax7"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s mainboard."),
					SPAN_NOTICE("You unfasten \the [holder]'s mainboard.")
				)
				holder.icon_state = "gygax5"
		if(13)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You secure \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "gygax8"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the peripherals control module from \the [holder]."),
					SPAN_NOTICE("You remove the peripherals control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/gygax/peripherals(GET_TURF(holder))
				holder.icon_state = "gygax6"
		if(12)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the weapon control module into \the [holder]."),
					SPAN_NOTICE("You install the weapon control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "gygax9"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You unfasten \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "gygax7"
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s weapon control module."),
					SPAN_NOTICE("You secure \the [holder]'s weapon control module.")
				)
				holder.icon_state = "gygax10"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the weapon control module from \the [holder]."),
					SPAN_NOTICE("You remove the weapon control module from \the [holder].")
				)
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
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s weapon control module."),
					SPAN_NOTICE("You unfasten \the [holder]'s weapon control module.")
				)
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
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s internal armor layer."),
					SPAN_NOTICE("You secure \the [holder]'s internal armor layer.")
				)
				holder.icon_state = "gygax15"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s advanced capacitor."),
					SPAN_NOTICE("You unfasten \the [holder]'s advanced capacitor.")
				)
				holder.icon_state = "gygax13"
		if(5)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s internal armor layer."),
					SPAN_NOTICE("You secure \the [holder]'s internal armor layer.")
				)
				holder.icon_state = "gygax16"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the internal armor layer from \the [holder]."),
					SPAN_NOTICE("You pry the internal armor layer from \the [holder].")
				)
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "gygax14"
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] welds the internal armor layer to \the [holder]."),
					SPAN_NOTICE("You weld the the internal armor layer to \the [holder].")
				)
				holder.icon_state = "gygax17"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s internal armor layer."),
					SPAN_NOTICE("You unfasten \the [holder]'s internal armor layer.")
				)
				holder.icon_state = "gygax15"
		if(3)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs armour plates on \the [holder]."),
					SPAN_NOTICE("You install armour plates on \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "gygax18"
			else
				user.visible_message(
					SPAN_NOTICE("[user] cuts the internal armor layer from \the [holder]."),
					SPAN_NOTICE("You cut the internal armor layer from \the [holder].")
				)
				holder.icon_state = "gygax16"
		if(2)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s armour plates."),
					SPAN_NOTICE("You secure \the [holder]'s armour plates.")
				)
				holder.icon_state = "gygax19"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the armour plates from \the [holder]."),
					SPAN_NOTICE("You pry the armour plates from \the [holder].")
				)
				new /obj/item/mecha_part/part/gygax_armour(GET_TURF(holder))
				holder.icon_state = "gygax17"
		if(1)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] welds the armour plates to \the [holder]."),
					SPAN_NOTICE("You weld the armour plates to \the [holder].")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s armour plates."),
					SPAN_NOTICE("You unfasten \the [holder]'s armour plates.")
				)
				holder.icon_state = "gygax18"
	return TRUE

/datum/construction/reversible/mecha/gygax/spawn_result()
	. = ..()
	feedback_inc("mecha_gygax_created", 1)