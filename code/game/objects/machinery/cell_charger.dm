/obj/machinery/cell_charger
	//name = "cell charger"
	//desc = "It charges power cells."
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 60
	)

	var/obj/item/cell/charging = null
	var/chargelevel = -1
	var/power_rating = 40000	//40 kW. A measure of how powerful this charger is for charging cells (this the power drawn when charging)

/obj/machinery/cell_charger/proc/updateicon()
	icon_state = "ccharger[charging ? 1 : 0]"

	if(isnotnull(charging) && !(stat & (BROKEN | NOPOWER)))
		var/newlevel = 	round(charging.percent() * 4.0 / 99)
		//to_world("nl: [newlevel]")
		if(chargelevel != newlevel)
			overlays.Cut()
			overlays.Add("ccharger-o[newlevel]")

			chargelevel = newlevel
	else
		overlays.Cut()

/obj/machinery/cell_charger/examine()
	set src in oview(5)
	..()
	to_chat(usr, "There's [charging ? "a" : "no"] cell in the charger.")
	if(isnotnull(charging))
		to_chat(usr, "Current charge: [charging.charge].")

/obj/machinery/cell_charger/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		if(isnotnull(charging))
			to_chat(user, SPAN_WARNING("Remove the cell first!"))
			return TRUE
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("[user] [anchored ? "attaches" : "detaches"] \the [src] [anchored ? "to" : "from"] the ground."),
			SPAN_NOTICE("You [anchored ? "attach" : "detach"] \the [src] [anchored ? "to" : "from"] the ground."),
			SPAN_INFO("You hear a ratchet.")
		)
		playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
		return TRUE

	return ..()

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/cell) && anchored)
		if(isnotnull(charging))
			to_chat(user, SPAN_WARNING("There is already a cell in the charger."))
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(!a.powered(EQUIP)) // There's no APC in this area, don't try to cheat power!
				to_chat(user, SPAN_WARNING("\The [src] blinks red as you try to insert the cell!"))
				return

			user.drop_item()
			W.forceMove(src)
			charging = W
			user.visible_message(
				SPAN_INFO("[user] inserts a cell into \the [src]."),
				SPAN_INFO("You insert a cell into \the [src].")
			)
			chargelevel = -1
		updateicon()

/obj/machinery/cell_charger/attack_hand(mob/user)
	if(isnotnull(charging))
		user.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.updateicon()

		charging = null
		user.visible_message(
			SPAN_INFO("[user] removes the cell from \the [src]."),
			SPAN_INFO("You remove the cell from \the [src].")
		)
		chargelevel = -1
		updateicon()

/obj/machinery/cell_charger/attack_ai(mob/user)
	return

/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN | NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)

/obj/machinery/cell_charger/process()
	//to_world("ccpt [charging] [stat]")
	if(isnull(charging) || (stat & (BROKEN | NOPOWER)) || !anchored)
		return

	//use_power(200)		//this used to use CELLRATE, but CELLRATE is fucking awful. feel free to fix this properly!
	//charging.give(175)	//inefficiency.
	if(!charging.fully_charged())
		var/charge_used = charging.give(power_rating * CELLRATE)
		use_power(charge_used / CELLRATE) //It's only while charging something, so I'm going to say use_power() is fine here...

	updateicon()