// Durand
/datum/construction/reversible/mecha/durand
	result = /obj/mecha/combat/durand
	steps = list(
		//1
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "External armor is wrenched."
		),
		//2
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "External armor is installed."
		),
		//3
		list(
			"key" = /obj/item/mecha_part/part/durand_armour,
			"backkey" = /obj/item/weldingtool,
			"desc" = "Internal armor is welded."
		),
		//4
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "Internal armor is wrenched."
		),
		//5
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "Internal armor is installed."
		),
		//6
		list(
			"key" = /obj/item/stack/sheet/steel,
			"backkey" = /obj/item/screwdriver,
			"desc" = "Advanced capacitor is secured."
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "Advanced capacitor is installed."
		),
		//8
		list(
			"key" = /obj/item/stock_part/capacitor/adv,
			"backkey" = /obj/item/screwdriver,
			"desc" = "Advanced scanner module is secured."
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "Advanced scanner module is installed."
		),
		//10
		list(
			"key" = /obj/item/stock_part/scanning_module/adv,
			"backkey" = /obj/item/screwdriver,
			"desc" = "Targeting module is secured."
		),
		//11
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "Targeting module is installed."
		),
		//12
		list(
			"key" = /obj/item/circuitboard/mecha/durand/targeting,
			"backkey" = /obj/item/screwdriver,
			"desc" = "Peripherals control module is secured."
		),
		//13
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "Peripherals control module is installed."
		),
		//14
		list(
			"key" = /obj/item/circuitboard/mecha/durand/peripherals,
			"backkey" = /obj/item/screwdriver,
			"desc" = "Central control module is secured."
		),
		//15
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "Central control module is installed."
		),
		//16
		list(
			"key" = /obj/item/circuitboard/mecha/durand/main,
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

/datum/construction/reversible/mecha/durand/action(atom/used_atom, mob/user)
	return check_step(used_atom, user)

/datum/construction/reversible/mecha/durand/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(20)
			user.visible_message(
				"[user] connects [holder] hydraulic systems.",
				"You connect [holder] hydraulic systems."
			)
			holder.icon_state = "durand1"
		if(19)
			if(diff == FORWARD)
				user.visible_message(
					"[user] activates [holder] hydraulic systems.",
					"You activate [holder] hydraulic systems."
				)
				holder.icon_state = "durand2"
			else
				user.visible_message(
					"[user] disconnects [holder] hydraulic systems.",
					"You disconnect [holder] hydraulic systems."
				)
				holder.icon_state = "durand0"
		if(18)
			if(diff == FORWARD)
				user.visible_message(
					"[user] adds the wiring to [holder].",
					"You add the wiring to [holder]."
				)
				holder.icon_state = "durand3"
			else
				user.visible_message(
					"[user] deactivates [holder] hydraulic systems.",
					"You deactivate [holder] hydraulic systems."
				)
				holder.icon_state = "durand1"
		if(17)
			if(diff == FORWARD)
				user.visible_message(
					"[user] adjusts the wiring of [holder].",
					"You adjust the wiring of [holder]."
				)
				holder.icon_state = "durand4"
			else
				user.visible_message(
					"[user] removes the wiring from [holder].",
					"You remove the wiring from [holder]."
				)
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "durand2"
		if(16)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs the central control module into [holder].",
					"You install the central computer mainboard into [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "durand5"
			else
				user.visible_message(
					"[user] disconnects the wiring of [holder].",
					"You disconnect the wiring of [holder]."
				)
				holder.icon_state = "durand3"
		if(15)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures the mainboard.",
					"You secure the mainboard."
				)
				holder.icon_state = "durand6"
			else
				user.visible_message(
					"[user] removes the central control module from [holder].",
					"You remove the central computer mainboard from [holder]."
				)
				new /obj/item/circuitboard/mecha/durand/main(GET_TURF(holder))
				holder.icon_state = "durand4"
		if(14)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs the peripherals control module into [holder].",
					"You install the peripherals control module into [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "durand7"
			else
				user.visible_message(
					"[user] unfastens the mainboard.",
					"You unfasten the mainboard."
				)
				holder.icon_state = "durand5"
		if(13)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures the peripherals control module.",
					"You secure the peripherals control module."
				)
				holder.icon_state = "durand8"
			else
				user.visible_message(
					"[user] removes the peripherals control module from [holder].",
					"You remove the peripherals control module from [holder]."
				)
				new /obj/item/circuitboard/mecha/durand/peripherals(GET_TURF(holder))
				holder.icon_state = "durand6"
		if(12)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs the weapon control module into [holder].",
					"You install the weapon control module into [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "durand9"
			else
				user.visible_message(
					"[user] unfastens the peripherals control module.",
					"You unfasten the peripherals control module."
				)
				holder.icon_state = "durand7"
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures the weapon control module.",
					"You secure the weapon control module."
				)
				holder.icon_state = "durand10"
			else
				user.visible_message(
					"[user] removes the weapon control module from [holder].",
					"You remove the weapon control module from [holder]."
				)
				new /obj/item/circuitboard/mecha/durand/targeting(GET_TURF(holder))
				holder.icon_state = "durand8"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs advanced scanner module to [holder].",
					"You install advanced scanner module to [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "durand11"
			else
				user.visible_message(
					"[user] unfastens the weapon control module.",
					"You unfasten the weapon control module."
				)
				holder.icon_state = "durand9"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures the advanced scanner module.",
					"You secure the advanced scanner module."
				)
				holder.icon_state = "durand12"
			else
				user.visible_message(
					"[user] removes the advanced scanner module from [holder].",
					"You remove the advanced scanner module from [holder]."
				)
				new /obj/item/stock_part/scanning_module/adv(GET_TURF(holder))
				holder.icon_state = "durand10"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs advanced capacitor to [holder].",
					"You install advanced capacitor to [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "durand13"
			else
				user.visible_message(
					"[user] unfastens the advanced scanner module.",
					"You unfasten the advanced scanner module."
				)
				holder.icon_state = "durand11"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures the advanced capacitor.",
					"You secure the advanced capacitor."
				)
				holder.icon_state = "durand14"
			else
				user.visible_message(
					"[user] removes the advanced capacitor from [holder].",
					"You remove the advanced capacitor from [holder]."
				)
				new /obj/item/stock_part/capacitor/adv(GET_TURF(holder))
				holder.icon_state = "durand12"
		if(6)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs internal armor layer to [holder].",
					"You install internal armor layer to [holder]."
				)
				holder.icon_state = "durand15"
			else
				user.visible_message(
					"[user] unfastens the advanced capacitor.",
					"You unfasten the advanced capacitor."
				)
				holder.icon_state = "durand13"
		if(5)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures internal armor layer.",
					"You secure internal armor layer."
				)
				holder.icon_state = "durand16"
			else
				user.visible_message(
					"[user] pries internal armor layer from [holder].",
					"You pry internal armor layer from [holder]."
				)
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "durand14"
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					"[user] welds internal armor layer to [holder].",
					"You weld the internal armor layer to [holder]."
				)
				holder.icon_state = "durand17"
			else
				user.visible_message(
					"[user] unfastens the internal armor layer.",
					"You unfasten the internal armor layer."
				)
				holder.icon_state = "durand15"
		if(3)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs Durand Armour Plates to [holder].",
					"You install Durand Armour Plates to [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "durand18"
			else
				user.visible_message(
					"[user] cuts internal armor layer from [holder].",
					"You cut the internal armor layer from [holder]."
				)
				holder.icon_state = "durand16"
		if(2)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures Durand Armour Plates.",
					"You secure Durand Armour Plates."
				)
				holder.icon_state = "durand19"
			else
				user.visible_message(
					"[user] pries Durand Armour Plates from [holder].",
					"You pry Durand Armour Plates from [holder]."
				)
				new /obj/item/mecha_part/part/durand_armour(GET_TURF(holder))
				holder.icon_state = "durand17"
		if(1)
			if(diff == FORWARD)
				user.visible_message(
					"[user] welds Durand Armour Plates to [holder].",
					"You weld Durand Armour Plates to [holder]."
				)
			else
				user.visible_message(
					"[user] unfastens Durand Armour Plates.",
					"You unfasten Durand Armour Plates."
				)
				holder.icon_state = "durand18"
	return TRUE

/datum/construction/reversible/mecha/durand/spawn_result()
	. = ..()
	feedback_inc("mecha_durand_created", 1)

// Odysseus
/datum/construction/reversible/mecha/odysseus
	result = /obj/mecha/medical/odysseus
	steps = list(
		//1
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "External armor is wrenched."
		),
		//2
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "External armor is installed."
		),
		//3
		list(
			"key" = /obj/item/stack/sheet/plasteel,
			"backkey" = /obj/item/weldingtool,
			"desc" = "Internal armor is welded."
		),
		//4
		list(
			"key" = /obj/item/weldingtool,
			"backkey" = /obj/item/wrench,
			"desc" = "Internal armor is wrenched."
		),
		//5
		list(
			"key" = /obj/item/wrench,
			"backkey" = /obj/item/crowbar,
			"desc" = "Internal armor is installed."
		),
		//6
		list(
			"key" = /obj/item/stack/sheet/steel,
			"backkey" = /obj/item/screwdriver,
			"desc" = "Peripherals control module is secured."
		),
		//7
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "Peripherals control module is installed."
		),
		//8
		list(
			"key" = /obj/item/circuitboard/mecha/odysseus/peripherals,
			"backkey" = /obj/item/screwdriver,
			"desc" = "Central control module is secured."
		),
		//9
		list(
			"key" = /obj/item/screwdriver,
			"backkey" = /obj/item/crowbar,
			"desc" = "Central control module is installed."
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

/datum/construction/reversible/mecha/odysseus/action(atom/used_atom, mob/user)
	return check_step(used_atom, user)

/datum/construction/reversible/mecha/odysseus/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message(
				"[user] connects [holder] hydraulic systems.",
				"You connect [holder] hydraulic systems."
			)
			holder.icon_state = "odysseus1"
		if(13)
			if(diff == FORWARD)
				user.visible_message(
					"[user] activates [holder] hydraulic systems.",
					"You activate [holder] hydraulic systems."
				)
				holder.icon_state = "odysseus2"
			else
				user.visible_message(
					"[user] disconnects [holder] hydraulic systems.",
					"You disconnect [holder] hydraulic systems."
				)
				holder.icon_state = "odysseus0"
		if(12)
			if(diff == FORWARD)
				user.visible_message(
					"[user] adds the wiring to [holder].",
					"You add the wiring to [holder]."
				)
				holder.icon_state = "odysseus3"
			else
				user.visible_message(
					"[user] deactivates [holder] hydraulic systems.",
					"You deactivate [holder] hydraulic systems."
				)
				holder.icon_state = "odysseus1"
		if(11)
			if(diff == FORWARD)
				user.visible_message(
					"[user] adjusts the wiring of [holder].",
					"You adjust the wiring of [holder]."
				)
				holder.icon_state = "odysseus4"
			else
				user.visible_message(
					"[user] removes the wiring from [holder].",
					"You remove the wiring from [holder]."
				)
				new /obj/item/stack/cable_coil(GET_TURF(holder), 4)
				holder.icon_state = "odysseus2"
		if(10)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs the central control module into [holder].",
					"You install the central computer mainboard into [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "odysseus5"
			else
				user.visible_message(
					"[user] disconnects the wiring of [holder].",
					"You disconnect the wiring of [holder]."
				)
				holder.icon_state = "odysseus3"
		if(9)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures the mainboard.",
					"You secure the mainboard."
				)
				holder.icon_state = "odysseus6"
			else
				user.visible_message(
					"[user] removes the central control module from [holder].",
					"You remove the central computer mainboard from [holder]."
				)
				new /obj/item/circuitboard/mecha/odysseus/main(GET_TURF(holder))
				holder.icon_state = "odysseus4"
		if(8)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs the peripherals control module into [holder].",
					"You install the peripherals control module into [holder]."
				)
				qdel(used_atom)
				holder.icon_state = "odysseus7"
			else
				user.visible_message(
					"[user] unfastens the mainboard.",
					"You unfasten the mainboard."
				)
				holder.icon_state = "odysseus5"
		if(7)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures the peripherals control module.",
					"You secure the peripherals control module."
				)
				holder.icon_state = "odysseus8"
			else
				user.visible_message(
					"[user] removes the peripherals control module from [holder].",
					"You remove the peripherals control module from [holder]."
				)
				new /obj/item/circuitboard/mecha/odysseus/peripherals(GET_TURF(holder))
				holder.icon_state = "odysseus6"
		if(6)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs internal armor layer to [holder].",
					"You install internal armor layer to [holder]."
				)
				holder.icon_state = "odysseus9"
			else
				user.visible_message(
					"[user] unfastens the peripherals control module.",
					"You unfasten the peripherals control module."
				)
				holder.icon_state = "odysseus7"
		if(5)
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures internal armor layer.",
					"You secure internal armor layer."
				)
				holder.icon_state = "odysseus10"
			else
				user.visible_message(
					"[user] pries internal armor layer from [holder].",
					"You pry internal armor layer from [holder]."
				)
				new /obj/item/stack/sheet/steel(GET_TURF(holder), 5)
				holder.icon_state = "odysseus8"
		if(4)
			if(diff == FORWARD)
				user.visible_message(
					"[user] welds internal armor layer to [holder].",
					"You weld the internal armor layer to [holder]."
				)
				holder.icon_state = "odysseus11"
			else
				user.visible_message(
					"[user] unfastens the internal armor layer.",
					"You unfasten the internal armor layer."
				)
				holder.icon_state = "odysseus9"
		if(3)
			if(diff == FORWARD)
				user.visible_message(
					"[user] installs [used_atom] layer to [holder].",
					"You install external reinforced armor layer to [holder]."
				)

				holder.icon_state = "odysseus12"
			else
				user.visible_message(
					"[user] cuts internal armor layer from [holder].",
					"You cut the internal armor layer from [holder]."
				)
				holder.icon_state = "odysseus10"
			if(diff == FORWARD)
				user.visible_message(
					"[user] secures external armor layer.",
					"You secure external reinforced armor layer."
				)
				holder.icon_state = "odysseus13"
			else
				var/obj/item/stack/sheet/plasteel/MS = new /obj/item/stack/sheet/plasteel(GET_TURF(holder), 5)
				user.visible_message(
					"[user] pries [MS] from [holder].",
					"You pry [MS] from [holder]."
				)
				holder.icon_state = "odysseus11"
		if(1)
			if(diff == FORWARD)
				user.visible_message(
					"[user] welds external armor layer to [holder].",
					"You weld external armor layer to [holder]."
				)
				holder.icon_state = "odysseus14"
			else
				user.visible_message(
					"[user] unfastens the external armor layer.",
					"You unfasten the external armor layer."
				)
				holder.icon_state = "odysseus12"
	return TRUE

/datum/construction/reversible/mecha/odysseus/spawn_result()
	. = ..()
	feedback_inc("mecha_odysseus_created", 1)