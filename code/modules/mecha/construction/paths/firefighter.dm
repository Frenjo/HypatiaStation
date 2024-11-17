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
			"key" = /obj/item/stack/sheet/plasteel,
			"backkey" = /obj/item/crowbar,
			"desc" = "The external armor is being installed."
		),
		//4
		list(
			"key" = /obj/item/stack/sheet/plasteel,
			"backkey" = /obj/item/weldingtool,
			"desc" = "The internal armor is welded."
		),
		//5
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "The internal armor is wrenched."
		),
		//6
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "The internal armor is installed."
		),

		//7
		list(
			"key" = /obj/item/stack/sheet/plasteel,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The peripherals control module is secured."
		),
		//8
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "The peripherals control module is installed."
		),
		//9
		list(
			"key" = /obj/item/circuitboard/mecha/ripley/peripherals,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The central control module is secured."
		),
		//10
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "The central control module is installed."
		),
		//11
		list(
			"key" = /obj/item/circuitboard/mecha/ripley/main,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The wiring is adjusted."
		),
		//12
		list(
			"key" = /obj/item/wirecutters,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The wiring is added."
		),
		//13
		list(
			"key" = /obj/item/stack/cable_coil,
			"backkey" = /obj/item/screwdriver,
			"desc" = "The hydraulic systems are active."
		),
		//14
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/wrench,
			"desc" = "The hydraulic systems are connected."
		),
		//15
		list(
			"key" = /obj/item/wrench,
			"desc" = "The hydraulic systems are disconnected."
		)
	)

/datum/construction/reversible/mecha/firefighter/action(atom/used_atom, mob/user)
	return check_step(used_atom, user)

/datum/construction/reversible/mecha/firefighter/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(15)
			user.visible_message(
				SPAN_NOTICE("[user] connects \the [holder]'s hydraulic systems."),
				SPAN_NOTICE("You connect \the [holder]'s hydraulic systems.")
			)
			holder.icon_state = "fireripley1"
		if(14)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] activates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You activate [holder] hydraulic systems.")
				)
				holder.icon_state = "fireripley2"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You disconnect \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "fireripley0"
		if(13)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adds wiring to \the [holder]."),
					SPAN_NOTICE("You add wiring to \the [holder].")
				)
				holder.icon_state = "fireripley3"
			else
				user.visible_message(
					SPAN_NOTICE("[user] deactivates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You deactivate \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "fireripley1"
		if(12)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adjusts \the [holder]'s wiring."),
					SPAN_NOTICE("You adjust \the [holder]'s wiring.")
				)
				holder.icon_state = "fireripley4"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the wiring from \the [holder]."),
					SPAN_NOTICE("You remove the wiring from \the [holder].")
				)
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "fireripley2"
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the central control module into \the [holder]."),
					SPAN_NOTICE("You install the central control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "fireripley5"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s wiring."),
					SPAN_NOTICE("You disconnect \the [holder]'s wiring.")
				)
				holder.icon_state = "fireripley3"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s mainboard."),
					SPAN_NOTICE("You secure \the [holder]'s mainboard.")
				)
				holder.icon_state = "fireripley6"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the central control module from \the [holder]."),
					SPAN_NOTICE("You remove the central control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/ripley/main(GET_TURF(holder))
				holder.icon_state = "fireripley4"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."),
					SPAN_NOTICE("You install the peripherals control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "fireripley7"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s mainboard."),
					SPAN_NOTICE("You unfasten \the [holder]'s mainboard.")
				)
				holder.icon_state = "fireripley5"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You secure \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "fireripley8"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the peripherals control module from \the [holder]."),
					SPAN_NOTICE("You remove the peripherals control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/ripley/peripherals(GET_TURF(holder))
				holder.icon_state = "fireripley6"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the internal armor layer on \the [holder]."),
					SPAN_NOTICE("You install the internal armor layer on \the [holder].")
				)
				holder.icon_state = "fireripley9"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You unfasten \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "fireripley7"

		if(6)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s internal armor layer."),
					SPAN_NOTICE("You secure \the [holder]'s internal armor layer.")
				)
				holder.icon_state = "fireripley10"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the internal armor layer from \the [holder]."),
					SPAN_NOTICE("You pry the internal armor layer from \the [holder].")
				)
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "fireripley8"
		if(5)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] welds the internal armor layer to \the [holder]."),
					SPAN_NOTICE("You weld the the internal armor layer to \the [holder].")
				)
				holder.icon_state = "fireripley11"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s internal armor layer."),
					SPAN_NOTICE("You unfasten \the [holder]'s internal armor layer.")
				)
				holder.icon_state = "fireripley9"
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] starts to install the external armor layer on \the [holder]."),
					SPAN_NOTICE("You start to install the external armor layer on \the [holder].")
				)
				holder.icon_state = "fireripley12"
			else
				user.visible_message(
					SPAN_NOTICE("[user] cuts the internal armor layer from \the [holder]."),
					SPAN_NOTICE("You cut the internal armor layer from \the [holder].")
				)
				holder.icon_state = "fireripley10"
		if(3)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the external reinforced armor layer on \the [holder]."),
					SPAN_NOTICE("You install the external reinforced armor layer on \the [holder].")
				)
				holder.icon_state = "fireripley13"
			else
				user.visible_message(
					"[user] removes the external armor from [holder].",
					"You remove the external armor from [holder]."
				)
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "fireripley11"
		if(2)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s external reinforced armor layer."),
					SPAN_NOTICE("You secure \the [holder]'s external reinforced armor layer.")
				)
				holder.icon_state = "fireripley14"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the external armor layer from \the [holder]."),
					SPAN_NOTICE("You pry the external armor layer from \the [holder].")
				)
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "fireripley12"
		if(1)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] welds the external armor layer to \the [holder]."),
					SPAN_NOTICE("You weld the external armor layer to \the [holder].")
				)
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s external armor layer."),
					SPAN_NOTICE("You unfasten \the [holder]'s external armor layer.")
				)
				holder.icon_state = "fireripley13"
	return TRUE

/datum/construction/reversible/mecha/firefighter/spawn_result()
	. = ..()
	feedback_inc("mecha_firefighter_created", 1)