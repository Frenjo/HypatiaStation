// Ripley Chassis
/datum/construction/mecha/ripley_chassis
	steps = list(
		list("key" = /obj/item/mecha_part/part/ripley_torso),		//1
		list("key" = /obj/item/mecha_part/part/ripley_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/ripley_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/ripley_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/ripley_right_leg)	//5
	)

/datum/construction/mecha/ripley_chassis/custom_action(step, atom/used_atom, mob/user)
	user.visible_message(
		SPAN_NOTICE("[user] connects \the [used_atom] to \the [holder]."),
		SPAN_NOTICE("You connect \the [used_atom] to \the [holder].")
	)
	holder.overlays.Add(used_atom.icon_state + "+o")
	qdel(used_atom)
	return TRUE

/datum/construction/mecha/ripley_chassis/action(atom/used_atom, mob/user)
	return check_all_steps(used_atom, user)

/datum/construction/mecha/ripley_chassis/spawn_result()
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
			"key" = /obj/item/circuitboard/mecha/ripley/peripherals,
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
			"key" = /obj/item/circuitboard/mecha/ripley/main,
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

/datum/construction/reversible/mecha/ripley/action(atom/used_atom, mob/user)
	return check_step(used_atom, user)

/datum/construction/reversible/mecha/ripley/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message(
				SPAN_NOTICE("[user] connects \the [holder]'s hydraulic systems."),
				SPAN_NOTICE("You connect \the [holder]'s hydraulic systems.")
			)
			holder.icon_state = "ripley1"
		if(13)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] activates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You activate [holder] hydraulic systems.")
				)
				holder.icon_state = "ripley2"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You disconnect \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "ripley0"
		if(12)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adds wiring to \the [holder]."),
					SPAN_NOTICE("You add wiring to \the [holder].")
				)
				holder.icon_state = "ripley3"
			else
				user.visible_message(
					SPAN_NOTICE("[user] deactivates \the [holder]'s hydraulic systems."),
					SPAN_NOTICE("You deactivate \the [holder]'s hydraulic systems.")
				)
				holder.icon_state = "ripley1"
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] adjusts \the [holder]'s wiring."),
					SPAN_NOTICE("You adjust \the [holder]'s wiring.")
				)
				holder.icon_state = "ripley4"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the wiring from \the [holder]."),
					SPAN_NOTICE("You remove the wiring from \the [holder].")
				)
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "ripley2"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the central control module into \the [holder]."),
					SPAN_NOTICE("You install the central control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "ripley5"
			else
				user.visible_message(
					SPAN_NOTICE("[user] disconnects \the [holder]'s wiring."),
					SPAN_NOTICE("You disconnect \the [holder]'s wiring.")
				)
				holder.icon_state = "ripley3"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s mainboard."),
					SPAN_NOTICE("You secure \the [holder]'s mainboard.")
				)
				holder.icon_state = "ripley6"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the central control module from \the [holder]."),
					SPAN_NOTICE("You remove the central control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/ripley/main(GET_TURF(holder))
				holder.icon_state = "ripley4"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."),
					SPAN_NOTICE("You install the peripherals control module into \the [holder].")
				)
				qdel(used_atom)
				holder.icon_state = "ripley7"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s mainboard."),
					SPAN_NOTICE("You unfasten \the [holder]'s mainboard.")
				)
				holder.icon_state = "ripley5"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You secure \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "ripley8"
			else
				user.visible_message(
					SPAN_NOTICE("[user] removes the peripherals control module from \the [holder]."),
					SPAN_NOTICE("You remove the peripherals control module from \the [holder].")
				)
				new /obj/item/circuitboard/mecha/ripley/peripherals(GET_TURF(holder))
				holder.icon_state = "ripley6"
		if(6)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the internal armor layer on \the [holder]."),
					SPAN_NOTICE("You install the internal armor layer on \the [holder].")
				)
				holder.icon_state = "ripley9"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s peripherals control module."),
					SPAN_NOTICE("You unfasten \the [holder]'s peripherals control module.")
				)
				holder.icon_state = "ripley7"
		if(5)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s internal armor layer."),
					SPAN_NOTICE("You secure \the [holder]'s internal armor layer.")
				)
				holder.icon_state = "ripley10"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the internal armor layer from \the [holder]."),
					SPAN_NOTICE("You pry the internal armor layer from \the [holder].")
				)
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "ripley8"
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] welds the internal armor layer to \the [holder]."),
					SPAN_NOTICE("You weld the the internal armor layer to \the [holder].")
				)
				holder.icon_state = "ripley11"
			else
				user.visible_message(
					SPAN_NOTICE("[user] unfastens \the [holder]'s internal armor layer."),
					SPAN_NOTICE("You unfasten \the [holder]'s internal armor layer.")
				)
				holder.icon_state = "ripley9"
		if(3)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] installs the external reinforced armor layer on \the [holder]."),
					SPAN_NOTICE("You install the external reinforced armor layer on \the [holder].")
				)
				holder.icon_state = "ripley12"
			else
				user.visible_message(
					SPAN_NOTICE("[user] cuts the internal armor layer from \the [holder]."),
					SPAN_NOTICE("You cut the internal armor layer from \the [holder].")
				)
				holder.icon_state = "ripley10"
		if(2)
			if(diff == FORWARD)
				user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]'s external reinforced armor layer."),
					SPAN_NOTICE("You secure \the [holder]'s external reinforced armor layer.")
				)
				holder.icon_state = "ripley13"
			else
				user.visible_message(
					SPAN_NOTICE("[user] pries the external armor layer from \the [holder]."),
					SPAN_NOTICE("You pry the external armor layer from \the [holder].")
				)
				new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				holder.icon_state = "ripley11"
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
				holder.icon_state = "ripley12"
	return TRUE

/datum/construction/reversible/mecha/ripley/spawn_result()
	. = ..()
	feedback_inc("mecha_ripley_created", 1)