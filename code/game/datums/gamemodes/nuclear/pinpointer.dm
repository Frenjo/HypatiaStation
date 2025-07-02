/obj/item/pinpointer
	name = "pinpointer"
	desc = "A GPS pinpointer used for locating nuclear authentication disks."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "pinoff"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	w_class = 2.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	matter_amounts = alist(/decl/material/plastic = 500, /decl/material/glass = 50)

	var/active = FALSE
	var/atom/thing_to_find = null

/obj/item/pinpointer/initialise()
	. = ..()
	thing_to_find = locate(/obj/item/disk/nuclear)

/obj/item/pinpointer/Destroy()
	thing_to_find = null
	return ..()

/obj/item/pinpointer/examine()
	. = ..()
	for_no_type_check(var/obj/machinery/nuclearbomb/bomb, GET_MACHINES_TYPED(/obj/machinery/nuclearbomb))
		if(bomb.timing)
			to_chat(usr, SPAN_DANGER("Extreme danger. Arming signal detected. Time remaining: [bomb.timeleft]."))

/obj/item/pinpointer/attack_self()
	active = !active
	if(active)
		START_PROCESSING(PCobj, src)
		to_chat(usr, SPAN_INFO("You activate the pinpointer."))
	else
		icon_state = "pinoff"
		to_chat(usr, SPAN_INFO("You deactivate the pinpointer."))

/obj/item/pinpointer/process()
	if(!active)
		return PROCESS_KILL
	if(isnull(thing_to_find) || GET_TURF_Z(thing_to_find) != GET_TURF_Z(src))
		icon_state = "pinonnull"
		return

	dir = get_dir(src, thing_to_find)
	switch(get_dist(src, thing_to_find))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"

/obj/item/pinpointer/advanced
	name = "advanced pinpointer"
	desc = "A larger version of the normal pinpointer, this unit features a helpful quantum entanglement detection system to locate various objects that do not broadcast a locator signal."

/obj/item/pinpointer/advanced/verb/toggle_mode()
	set category = PANEL_OBJECT
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	active = FALSE
	icon_state = "pinoff"
	thing_to_find = null

	switch(alert("Please select the mode you want to put the pinpointer in.", "Pinpointer Mode Select", "Location", "Disk Recovery", "Other Signature"))
		if("Location")
			var/targetX = input(usr, "Please input the x coordinate to search for.", "Location?", "") as num
			if(!targetX || !(usr in view(1, src)))
				return
			var/targetY = input(usr, "Please input the y coordinate to search for.", "Location?", "") as num
			if(!targetY || !(usr in view(1, src)))
				return
			var/turf/currentZ = GET_TURF(src)
			thing_to_find = locate(targetX, targetY, currentZ.z)
			to_chat(usr, SPAN_INFO("You set the pinpointer to locate \[[targetX],[targetY]\]."))
			return attack_self()

		if("Disk Recovery")
			thing_to_find = locate(/obj/item/disk/nuclear)
			return attack_self()

		if("Other Signature")
			switch(alert("Search for item signature or DNA fragment?", "Signature Mode Select", "", "Item", "DNA"))
				if("Item")
					var/datum/objective/steal/temp_objective
					temp_objective = temp_objective // To suppress a 'variable defined but not used' error.
					var/target_item = input("Select item to search for.", "Item Mode Select","") as null | anything in temp_objective.possible_items
					if(!target_item)
						return
					thing_to_find = locate(temp_objective.possible_items[target_item])
					if(isnull(thing_to_find))
						to_chat(usr, SPAN_WARNING("Failed to locate [target_item]!"))
						return
					to_chat(usr, SPAN_INFO("You set the pinpointer to locate [target_item]."))
				if("DNA")
					var/dna_string = input("Input DNA string to search for.", "Please Enter String.", "")
					if(!dna_string)
						return
					for(var/mob/living/carbon/M in GLOBL.mob_list)
						if(isnull(M.dna))
							continue
						if(M.dna.unique_enzymes == dna_string)
							thing_to_find = M
							break
			return attack_self()

///////////////////////
//nuke op pinpointers//
///////////////////////
#define PINPOINTER_MODE_DISK 0
#define PINPOINTER_MODE_SHUTTLE 1
/obj/item/pinpointer/nukeop
	name = "\improper Syndicate pinpointer"
	desc = "A Syndicate-issue version of the normal pinpointer, this unit is capable of locating both nuclear authentication disks and nearby Syndicate shuttles."

	var/mode = PINPOINTER_MODE_DISK

/obj/item/pinpointer/nukeop/attack_self(mob/user)
	active = !active
	if(active)
		START_PROCESSING(PCobj, src)
		switch(mode)
			if(PINPOINTER_MODE_DISK)
				thing_to_find = locate(/obj/item/disk/nuclear)
				to_chat(user, SPAN_NOTICE("Authentication disk locator active."))
			if(PINPOINTER_MODE_SHUTTLE)
				thing_to_find = locate(/obj/machinery/computer/shuttle_control/multi/syndicate)
				to_chat(user, SPAN_NOTICE("Shuttle locator active."))
	else
		icon_state = "pinoff"
		to_chat(usr, SPAN_INFO("You deactivate the pinpointer."))

/obj/item/pinpointer/nukeop/process()
	if(!active)
		return PROCESS_KILL
	if(isnull(thing_to_find) || GET_TURF_Z(thing_to_find) != GET_TURF_Z(src))
		icon_state = "pinonnull"
		return

	if(global.bomb_set && mode != PINPOINTER_MODE_SHUTTLE) // If the bomb is armed while we're active
		mode = PINPOINTER_MODE_SHUTTLE
		thing_to_find = locate(/obj/machinery/computer/shuttle_control/multi/syndicate)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1) // Plays a beep.
		loc.visible_message(SPAN_NOTICE("Shuttle locator active.")) // Displays a message.
	else if(!global.bomb_set && mode != PINPOINTER_MODE_DISK) // If the bomb is disarmed while we're active.
		mode = PINPOINTER_MODE_DISK
		thing_to_find = locate(/obj/item/disk/nuclear)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1) // Plays a beep.
		loc.visible_message(SPAN_NOTICE("Authentication disk locator active.")) // Displays a message.

	dir = get_dir(src, thing_to_find)
	switch(get_dist(src, thing_to_find))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
#undef PINPOINTER_MODE_SHUTTLE
#undef PINPOINTER_MODE_DISK