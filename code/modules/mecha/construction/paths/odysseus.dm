// Odysseus Chassis
/datum/construction/mecha/chassis/odysseus
	steps = list(
		list("key" = /obj/item/mecha_part/part/odysseus_torso),	//1
		list("key" = /obj/item/mecha_part/part/odysseus_head),		//2
		list("key" = /obj/item/mecha_part/part/odysseus_left_arm),	//3
		list("key" = /obj/item/mecha_part/part/odysseus_right_arm),//4
		list("key" = /obj/item/mecha_part/part/odysseus_left_leg),	//5
		list("key" = /obj/item/mecha_part/part/odysseus_right_leg)	//6
	)

/datum/construction/mecha/chassis/odysseus/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/odysseus(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "odysseus0"
	const_holder.density = TRUE
	spawn()
		qdel(src)

// Odysseus
/datum/construction/reversible/mecha/odysseus
	result = /obj/mecha/medical/odysseus
	steps = list(
		//1
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "The external carapace is wrenched."
		),
		//2
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "The external carapace is installed."
		),
		//3
		list(
			"key" = /obj/item/mecha_part/part/odysseus_carapace,
			"backkey" = /obj/item/weldingtool,
			"desc" = "The internal armour is welded."
		),
		//4
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "The internal armour is wrenched."
		),
		//5
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "The internal armour is installed."
		),
		//6
		list(
			"key" = /obj/item/stack/sheet/steel,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The peripherals control module is secured."
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "The peripherals control module is installed."
		),
		//8
		list(
			"key" = /obj/item/circuitboard/mecha/odysseus/peripherals,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The central control module is secured."
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "The central control module is installed."
		),
		//10
		list(
			"key" = /obj/item/circuitboard/mecha/odysseus/main,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The wiring is adjusted."
		),
		//11
		list(
			"key" = /obj/item/wirecutters,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The wiring is added."
		),
		//12
		list(
			"key" = /obj/item/stack/cable_coil,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The hydraulic systems are active."
		),
		//13
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/wrench,
			"desc" = "The hydraulic systems are connected."
		),
		//14
		list(
			"key" = /obj/item/wrench,
			"desc" = "The hydraulic systems are disconnected."
		)
	)

/datum/construction/reversible/mecha/odysseus/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message(
				SPAN_NOTICE("[user] connects \the [holder]'s hydraulic systems."),
				SPAN_NOTICE("You connect \the [holder]'s hydraulic systems.")
			)
			holder.icon_state = "odysseus1"
		if(13)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] activates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You activate [holder] hydraulic systems.")
				)
				holder.icon_state = "odysseus2"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You disconnect \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "odysseus0"
		if(12)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adds wiring to \the [holder]."),
					SPAN_NOTICE("You add wiring to \the [holder].")
				)
				holder.icon_state = "odysseus3"
			else
				user.visible_message(
					SPAN_NOTICE("[user] deactivates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You deactivate \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "odysseus1"
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adjusts \the [holder]'s wiring."),
					SPAN_NOTICE("You adjust \the [holder]'s wiring.")
				)
				holder.icon_state = "odysseus4"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the wiring from \the [holder]."),
					SPAN_NOTICE("You remove the wiring from \the [holder].")
				)
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "odysseus2"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the central control module into \the [holder]."),
					SPAN_NOTICE("You install the central control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "odysseus5"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s wiring."),
					SPAN_NOTICE("You disconnect \the [holder]'s wiring.")
				)
				holder.icon_state = "odysseus3"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s mainboard."),
					SPAN_NOTICE("You secure \the [holder]'s mainboard.")
				)
				holder.icon_state = "odysseus6"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the central control module from \the [holder]."),
					SPAN_NOTICE("You remove the central control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/odysseus/main(GET_TURF(holder))
				holder.icon_state = "odysseus4"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."),
					SPAN_NOTICE("You install the peripherals control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "odysseus7"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s mainboard."),
					SPAN_NOTICE("You unfasten \the [holder]'s mainboard.")
				)
				holder.icon_state = "odysseus5"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You secure \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "odysseus8"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the peripherals control module from \the [holder]."),
					SPAN_NOTICE("You remove the peripherals control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/odysseus/peripherals(GET_TURF(holder))
				holder.icon_state = "odysseus6"
		if(6)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the internal armour layer on \the [holder]."),
					SPAN_NOTICE("You install the internal armour layer on \the [holder].")
				)
				holder.icon_state = "odysseus9"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You unfasten \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "odysseus7"
		if(5)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s internal armour layer."),
					SPAN_NOTICE("You secure \the [holder]'s internal armour layer.")
				)
				holder.icon_state = "odysseus10"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the internal armour layer from \the [holder]."),
					SPAN_NOTICE("You pry the internal armour layer from \the [holder].")
				)
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "odysseus8"
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] welds the internal armour layer to \the [holder]."),
					SPAN_NOTICE("You weld the the internal armour layer to \the [holder].")
				)
				holder.icon_state = "odysseus11"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s internal armour layer."),
					SPAN_NOTICE("You unfasten \the [holder]'s internal armour layer.")
				)
				holder.icon_state = "odysseus9"
		if(3)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the external carapace on \the [holder]."),
					SPAN_NOTICE("You install the external carapace on \the [holder].")
				)
				holder.icon_state = "odysseus12"
			else
				user.visible_message(
					SPAN_NOTICE("[user] cuts the internal armour layer from \the [holder]."),
					SPAN_NOTICE("You cut the internal armour layer from \the [holder].")
				)
				holder.icon_state = "odysseus10"
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s external carapace."),
					SPAN_NOTICE("You secure \the [holder]'s external carapace.")
				)
				holder.icon_state = "odysseus13"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the external carapace from \the [holder]."),
					SPAN_NOTICE("You pry the external carapace from \the [holder].")
				)
				new /obj/item/mecha_part/part/odysseus_carapace(GET_TURF(holder))
				holder.icon_state = "odysseus11"
		if(1)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] welds the external carapace to \the [holder]."),
					SPAN_NOTICE("You weld the external carapace to \the [holder].")
				)
				holder.icon_state = "odysseus14"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s external carapace."),
					SPAN_NOTICE("You unfasten \the [holder]'s external carapace.")
				)
				holder.icon_state = "odysseus12"
	return TRUE

/datum/construction/reversible/mecha/odysseus/spawn_result()
	. = ..()
	feedback_inc("mecha_odysseus_created", 1)