// Powersink - used to drain station power

/obj/item/powersink
	desc = "A nulling power sink which drains energy from electrical systems."
	name = "power sink"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "powersink0"
	item_state = "electronic"
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = OBJ_FLAG_CONDUCT
	throwforce = 5
	throw_speed = 1
	throw_range = 2
	matter_amounts = alist(/decl/material/steel = 750)
	origin_tech = alist(/decl/tech/power_storage = 3, /decl/tech/syndicate = 5)

	var/drain_rate = 600000		// amount of power to drain per tick
	var/power_drained = 0 		// has drained this much power
	var/max_power = 1e8		// maximum power that can be drained before exploding
	var/mode = 0		// 0 = off, 1=clamped (off), 2=operating

	var/obj/structure/cable/attached		// the attached cable

/obj/item/powersink/Destroy()
	UNREGISTER_POWER_ITEM(src)
	attached = null
	return ..()

/obj/item/powersink/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		switch(mode)
			if(0)
				var/turf/T = loc
				if(isturf(T) && !T.intact)
					attached = locate() in T
					if(isnull(attached))
						to_chat(user, SPAN_WARNING("No exposed cable here to attach to."))
						return TRUE
					anchored = TRUE
					mode = 1
					user.visible_message(
						SPAN_NOTICE("[user] attaches \the [src] to \the [attached]."),
						SPAN_NOTICE("You attach \the [src] to \the [attached]."),
						SPAN_INFO("You hear someone using a screwdriver.")
					)
					return TRUE
				to_chat(user, SPAN_WARNING("\The [src] must be placed over an exposed cable to attach to it."))
				return TRUE

			if(2)
				STOP_PROCESSING(PCobj, src) // Now the power sink actually stops draining the station's power if you unhook it. --NeoFite
				UNREGISTER_POWER_ITEM(src)
				anchored = FALSE
				mode = 0
				user.visible_message(
					SPAN_NOTICE("[user] detaches \the [src] from \the [attached]."),
					SPAN_NOTICE("You detach \the [src] from \the [attached]."),
					SPAN_INFO("You hear someone using a screwdriver.")
				)
				set_light(0)
				icon_state = "powersink0"
				return TRUE

	return ..()

/obj/item/powersink/attack_paw()
	return

/obj/item/powersink/attack_ai()
	return

/obj/item/powersink/attack_hand(mob/user)
	if(mode == 0)
		return ..()

	switch(mode)
		if(1)
			user.visible_message(
				SPAN_INFO("[user] activates \the [src]!"),
				SPAN_INFO("You activate \the [src]!")
			)
			mode = 2
			icon_state = "powersink1"
			START_PROCESSING(PCobj, src)
			REGISTER_POWER_ITEM(src)

		if(2) //This switch option wasn't originally included. It exists now. --NeoFite
			user.visible_message(
				SPAN_INFO("[user] deactivates \the [src]!"),
				SPAN_INFO("You deactivate \the [src]!")
			)
			mode = 1
			set_light(0)
			icon_state = "powersink0"
			STOP_PROCESSING(PCobj, src)
			UNREGISTER_POWER_ITEM(src)

/obj/item/powersink/pwr_drain()
	if(!attached)
		return 0
	var/datum/powernet/attached_powernet = attached.get_powernet()
	if(isnotnull(attached_powernet))
		return 1

	set_light(12)

	// found a powernet, so drain up to max power from it
	var/drained = attached_powernet.draw_power(drain_rate)

	// if tried to drain more than available on powernet
	// now look for APCs and drain their cells
	if(drained < drain_rate)
		for(var/obj/machinery/power/terminal/T in attached_powernet.nodes)
			if(istype(T.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = T.master
				if(A.operating && A.cell)
					A.cell.charge = max(0, A.cell.charge - 50)
					power_drained += 50

	return 1

/obj/item/powersink/process()
	if(power_drained > max_power * 0.95)
		playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
	if(power_drained >= max_power)
		explosion(loc, 3, 6, 9, 12)
		qdel(src)