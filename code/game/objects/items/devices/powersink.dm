// Powersink - used to drain station power

/obj/item/device/powersink
	desc = "A nulling power sink which drains energy from electrical systems."
	name = "power sink"
	icon_state = "powersink0"
	item_state = "electronic"
	w_class = 4.0
	flags = CONDUCT
	throwforce = 5
	throw_speed = 1
	throw_range = 2
	matter_amounts = list(MATERIAL_METAL = 750, "waste" = 750)
	origin_tech = list(RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_SYNDICATE = 5)

	var/drain_rate = 600000		// amount of power to drain per tick
	var/power_drained = 0 		// has drained this much power
	var/max_power = 1e8		// maximum power that can be drained before exploding
	var/mode = 0		// 0 = off, 1=clamped (off), 2=operating

	var/obj/structure/cable/attached		// the attached cable

/obj/item/device/powersink/Destroy()
	GLOBL.processing_objects.Remove(src)
	GLOBL.processing_power_items.Remove(src)
	return ..()

/obj/item/device/powersink/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(mode == 0)
			var/turf/T = loc
			if(isturf(T) && !T.intact)
				attached = locate() in T
				if(!attached)
					to_chat(user, "No exposed cable here to attach to.")
					return
				else
					anchored = TRUE
					mode = 1
					to_chat(user, "You attach the device to the cable.")
					for(var/mob/M in viewers(user))
						if(M == user)
							continue
						to_chat(M, "[user] attaches the power sink to the cable.")
					return
			else
				to_chat(user, "Device must be placed over an exposed cable to attach to it.")
				return
		else
			if(mode == 2)
				GLOBL.processing_objects.Remove(src) // Now the power sink actually stops draining the station's power if you unhook it. --NeoFite
				GLOBL.processing_power_items.Remove(src)
			anchored = FALSE
			mode = 0
			to_chat(user, "You detach the device from the cable.")
			for(var/mob/M in viewers(user))
				if(M == user)
					continue
				to_chat(M, "[user] detaches the power sink from the cable.")
			set_light(0)
			icon_state = "powersink0"

			return
	else
		..()

/obj/item/device/powersink/attack_paw()
	return

/obj/item/device/powersink/attack_ai()
	return

/obj/item/device/powersink/attack_hand(mob/user)
	switch(mode)
		if(0)
			..()

		if(1)
			to_chat(user, "You activate the device!")
			for(var/mob/M in viewers(user))
				if(M == user)
					continue
				to_chat(M, "[user] activates the power sink!")
			mode = 2
			icon_state = "powersink1"
			GLOBL.processing_objects.Add(src)
			GLOBL.processing_power_items.Add(src)

		if(2)	//This switch option wasn't originally included. It exists now. --NeoFite
			to_chat(user, "You deactivate the device!")
			for(var/mob/M in viewers(user))
				if(M == user)
					continue
				to_chat(M, "[user] deactivates the power sink!")
			mode = 1
			set_light(0)
			icon_state = "powersink0"
			GLOBL.processing_objects.Remove(src)
			GLOBL.processing_power_items.Remove(src)

/obj/item/device/powersink/pwr_drain()
	if(!attached)
		return 0

	var/datum/powernet/PN = attached.get_powernet()
	if(!PN)
		return 1

	set_light(12)

	// found a powernet, so drain up to max power from it
	var/drained = PN.draw_power(drain_rate)

	// if tried to drain more than available on powernet
	// now look for APCs and drain their cells
	if(drained < drain_rate)
		for(var/obj/machinery/power/terminal/T in PN.nodes)
			if(istype(T.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = T.master
				if(A.operating && A.cell)
					A.cell.charge = max(0, A.cell.charge - 50)
					power_drained += 50

	return 1

/obj/item/device/powersink/process()
	if(power_drained > max_power * 0.95)
		playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
	if(power_drained >= max_power)
		explosion(src.loc, 3,6,9,12)
		qdel(src)