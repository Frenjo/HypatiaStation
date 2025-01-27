//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/recharger
	name = "recharger"
	icon = 'icons/obj/machines/rechargers.dmi'
	icon_state = "recharger0"
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 4,
		USE_POWER_ACTIVE = 250
	)

	var/power_rating = 15000	//15 kW
	var/obj/item/charging = null

/obj/machinery/recharger/attackby(obj/item/G, mob/user)
	if(issilicon(user))
		return

	if(istype(G, /obj/item/gun/energy) || istype(G, /obj/item/melee/baton) || istype(G, /obj/item/cell))
		if(isnotnull(charging))
			return

		// Checks to make sure he's not in space doing it, and that the area got proper power.
		var/area/a = GET_AREA(src)
		if(!isarea(a))
			to_chat(user, SPAN_WARNING("The [name] blinks red as you try to insert the item!"))
			return
		if(!a.powered(EQUIP))
			to_chat(user, SPAN_WARNING("The [name] blinks red as you try to insert the item!"))
			return

		if(istype(G, /obj/item/gun/energy/gun/nuclear) || istype(G, /obj/item/gun/energy/crossbow))
			to_chat(user, SPAN_NOTICE("Your gun's recharge port was removed to make room for a miniaturized reactor."))
			return
		if(istype(G, /obj/item/gun/energy/staff))
			return
		user.drop_item()
		G.forceMove(src)
		charging = G
		update_power_state(USE_POWER_ACTIVE)
		update_icon()

	else if(iswrench(G))
		if(isnotnull(charging))
			to_chat(user, SPAN_WARNING("Remove [charging] first!"))
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)

/obj/machinery/recharger/attack_hand(mob/user)
	add_fingerprint(user)

	if(isnotnull(charging))
		charging.update_icon()
		charging.loc = loc
		charging = null
		update_power_state(USE_POWER_IDLE)
		update_icon()

/obj/machinery/recharger/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/recharger/process()
	if(stat & (BROKEN | NOPOWER) || !anchored)
		return

	if(isnotnull(charging))
		if(istype(charging, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = charging
			if(!E.power_supply.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "recharger1"
				var/charge_used = E.power_supply.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/melee/baton))
			var/obj/item/melee/baton/B = charging
			if(!B.bcell.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "recharger1"
				var/charge_used = B.bcell.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/cell))
			var/obj/item/cell/C = charging
			if(!C.fully_charged())
				icon_state = "recharger1"
				var/charge_used = C.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "recharger2"
			return

/obj/machinery/recharger/emp_act(severity)
	if(stat & (BROKEN | NOPOWER) || !anchored)
		..(severity)
		return

	if(istype(charging, /obj/item/gun/energy))
		var/obj/item/gun/energy/E = charging
		if(E.power_supply)
			E.power_supply.emp_act(severity)

	else if(istype(charging, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = charging
		//B.charges = 0
		if(B.bcell)
			B.bcell.charge = 0
	..(severity)

//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
/obj/machinery/recharger/update_icon()
	if(isnotnull(charging))
		icon_state = "recharger1"
	else
		icon_state = "recharger0"

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/machines/rechargers.dmi'
	icon_state = "wrecharger0"
	power_rating = 25000	//25 kW, It's more specialized than the standalone recharger but more powerful

/obj/machinery/recharger/wallcharger/process()
	if(stat & (BROKEN | NOPOWER) || !anchored)
		return

	if(isnotnull(charging))
		if(istype(charging, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = charging
			if(!E.power_supply.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "wrecharger1"
				var/charge_used = E.power_supply.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "wrecharger2"
			return
		if(istype(charging, /obj/item/melee/baton))
			var/obj/item/melee/baton/B = charging
			if(!B.bcell.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "wrecharger1"
				var/charge_used = B.bcell.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "wrecharger2"

/obj/machinery/recharger/wallcharger/update_icon()
	if(isnotnull(charging))
		icon_state = "wrecharger1"
	else
		icon_state = "wrecharger0"