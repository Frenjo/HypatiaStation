/* Teleportation devices.
 * Contains:
 *		Locator
 *		Hand-tele
 */

/*
 * Locator
 */
/obj/item/locator
	name = "locator"
	desc = "Used to track those with locater implants."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "locator"

	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 2.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	matter_amounts = alist(/decl/material/plastic = 400)
	origin_tech = alist(/decl/tech/magnets = 1)

	var/temp = null
	var/frequency = 1451
	var/broadcasting = null
	var/listening = 1.0

/obj/item/locator/attack_self(mob/user)
	user.set_machine(src)
	var/dat
	if(src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = {"
<B>Persistent Signal Locator</B><HR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

<A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"}

	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/locator/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained())
		return
	if(GET_TURF_Z(usr) == 2)	//What turf is the user on? //If turf was not found or they're on z level 2.
		to_chat(usr, "The [src] is malfunctioning.")
		return
	if((usr.contents.Find(src) ||(in_range(src, usr) && isturf(src.loc))))
		usr.set_machine(src)
		if(href_list["refresh"])
			src.temp = "<B>Persistent Signal Locator</B><HR>"
			var/turf/sr = GET_TURF(src)

			if(isnotnull(sr))
				src.temp += "<B>Located Beacons:</B><BR>"

				for(var/obj/item/radio/beacon/W in GLOBL.movable_atom_list)
					if(W.frequency == src.frequency)
						var/turf/tr = GET_TURF(W)
						if(tr?.z == sr.z)
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if(direct < 5)
								direct = "very strong"
							else
								if(direct < 10)
									direct = "strong"
								else
									if(direct < 20)
										direct = "weak"
									else
										direct = "very weak"
							src.temp += "[W.code]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>Extraneous Signals:</B><BR>"
				for(var/obj/item/implant/tracking/W in GLOBL.movable_atom_list)
					if(!W.implanted || !(isorgan(W.loc) || ismob(W.loc)))
						continue
					else
						var/mob/M = W.loc
						if(M.stat == DEAD)
							if(M.timeofdeath + 6000 < world.time)
								continue

					var/turf/tr = GET_TURF(W)
					if(tr?.z == sr.z)
						var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
						if(direct < 20)
							if(direct < 5)
								direct = "very strong"
							else
								if(direct < 10)
									direct = "strong"
								else
									direct = "weak"
							src.temp += "[W.id]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>You are at \[[sr.x],[sr.y],[sr.z]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
			else
				src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
		else
			if(href_list["freq"])
				src.frequency += text2num(href_list["freq"])
				src.frequency = sanitize_frequency(src.frequency)
			else
				if(href_list["temp"])
					src.temp = null
		if(ismob(src.loc))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return

/*
 * Hand Teleporter
 */
/obj/item/hand_teleporter
	name = "hand teleporter"
	desc = "A portable item using bluespace technology."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = 5
	w_class = 2.0
	throw_speed = 3
	throw_range = 5
	matter_amounts = alist(/decl/material/plastic = 10000)
	origin_tech = alist(/decl/tech/magnets = 1, /decl/tech/bluespace = 3)

/obj/item/hand_teleporter/attack_self(mob/user)
	var/turf/current_location = GET_TURF(user)//What turf is the user on?
	if(isnull(current_location) || current_location.z == 2 || current_location.z >= 7)//If turf was not found or they're on z level 2 or >7 which does not currently exist.
		to_chat(user, SPAN_NOTICE("\The [src] is malfunctioning."))
		return
	var/list/L = list()
	for(var/obj/machinery/teleport/hub/R in GLOBL.machines)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if(istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	var/list/turfs = list()
	for_no_type_check(var/turf/T, RANGE_TURFS(src, 10))
		if(T.x > world.maxx - 8 || T.x < 8)
			continue	//putting them at the edge is dumb
		if(T.y > world.maxy - 8 || T.y < 8)
			continue
		turfs += T
	if(length(turfs))
		L["None (Dangerous)"] = pick(turfs)
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	if((user.get_active_hand() != src || user.stat || user.restrained()))
		return
	var/count = 0	//num of portals from this teleport in world
	for(var/obj/effect/portal/PO in GLOBL.movable_atom_list)
		if(PO.creator == src)
			count++
	if(count >= 3)
		user.show_message(SPAN_NOTICE("\The [src] is recharging!"))
		return
	var/T = L[t1]
	for(var/mob/O in hearers(user, null))
		O.show_message(SPAN_NOTICE("Locked In."), 2)
	var/obj/effect/portal/P = new /obj/effect/portal(GET_TURF(src))
	P.target = T
	P.creator = src
	src.add_fingerprint(user)
	return