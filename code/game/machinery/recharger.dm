//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/recharger
	name = "recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 4
	//active_power_usage = 250
	var/power_rating = 15000	//15 kW
	var/obj/item/weapon/charging = null

/obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(issilicon(user))
		return

	if(istype(G, /obj/item/weapon/gun/energy) || istype(G, /obj/item/weapon/melee/baton) || istype(G, /obj/item/weapon/cell))
		if(charging)
			return

		// Checks to make sure he's not in space doing it, and that the area got proper power.
		var/area/a = get_area(src)
		if(!isarea(a))
			to_chat(user, SPAN_WARNING("The [name] blinks red as you try to insert the item!"))
			return
		if(a.power_equip == 0)
			to_chat(user, SPAN_WARNING("The [name] blinks red as you try to insert the item!"))
			return

		if(istype(G, /obj/item/weapon/gun/energy/gun/nuclear) || istype(G, /obj/item/weapon/gun/energy/crossbow))
			to_chat(user, SPAN_NOTICE("Your gun's recharge port was removed to make room for a miniaturized reactor."))
			return
		if(istype(G, /obj/item/weapon/gun/energy/staff))
			return
		user.drop_item()
		G.loc = src
		charging = G
		use_power = 2
		update_icon()

	else if(istype(G, /obj/item/weapon/wrench))
		if(charging)
			to_chat(user, SPAN_WARNING("Remove [charging] first!"))
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)

/obj/machinery/recharger/attack_hand(mob/user as mob)
	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		charging.loc = loc
		charging = null
		use_power = 1
		update_icon()

/obj/machinery/recharger/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/recharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		return

	if(charging)
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(!E.power_supply.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "recharger1"
				var/charge_used = E.power_supply.give(power_rating * CELLRATE)
				use_power(charge_used/CELLRATE)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			if(!B.bcell.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "recharger1"
				var/charge_used = B.bcell.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/weapon/cell))
			var/obj/item/weapon/cell/C = charging
			if(!C.fully_charged())
				icon_state = "recharger1"
				var/charge_used = C.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "recharger2"
			return

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(istype(charging, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/E = charging
		if(E.power_supply)
			E.power_supply.emp_act(severity)

	else if(istype(charging, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = charging
		//B.charges = 0
		if(B.bcell)
			B.bcell.charge = 0
	..(severity)

//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
/obj/machinery/recharger/update_icon()
	if(charging)
		icon_state = "recharger1"
	else
		icon_state = "recharger0"

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	power_rating = 25000	//25 kW, It's more specialized than the standalone recharger but more powerful

/obj/machinery/recharger/wallcharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		return

	if(charging)
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(!E.power_supply.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "wrecharger1"
				var/charge_used = E.power_supply.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "wrecharger2"
			return
		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			if(!B.bcell.fully_charged()) //Because otherwise it takes two minutes to fully charge due to 15k cells. - Neerti
				icon_state = "wrecharger1"
				var/charge_used = B.bcell.give(power_rating * CELLRATE)
				use_power(charge_used / CELLRATE)
			else
				icon_state = "wrecharger2"

/obj/machinery/recharger/wallcharger/update_icon()
	if(charging)
		icon_state = "wrecharger1"
	else
		icon_state = "wrecharger0"