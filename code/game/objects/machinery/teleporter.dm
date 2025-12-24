/obj/machinery/computer/teleporter
	name = "teleporter control computer"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_state = "teleport"
	circuit = /obj/item/circuitboard/teleporter
	var/obj/item/locked = null
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set src.locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.

/obj/machinery/computer/teleporter/New()
	src.id = "[rand(1000, 9999)]"
	..()
	return

/obj/machinery/computer/teleporter/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/card/data))
		var/obj/item/card/data/C = I
		if(stat & (NOPOWER|BROKEN) & C.function != "teleporter")
			src.attack_hand()

		var/obj/L = null

		for_no_type_check(var/obj/effect/landmark/sloc, GLOBL.landmark_list)
			if(sloc.name != C.data)
				continue
			if(locate(/mob/living) in sloc.loc)
				continue
			L = sloc
			break

		if(!L)
			L = locate("landmark*[C.data]") // use old stype

		if(istype(L, /obj/effect/landmark) && isturf(L.loc))
			to_chat(usr, "You insert the coordinates into the machine.")
			to_chat(usr, "A message flashes across the screen reminding the traveller that the nuclear authentication disk is to remain on the station at all times.")
			user.drop_item()
			qdel(I)

			if(C.data == "Clown Land")
				//whoops
				for(var/mob/O in hearers(src, null))
					O.show_message(SPAN_WARNING("Incoming bluespace portal detected, unable to lock in."), 2)

				for(var/obj/machinery/teleport/hub/H in range(1))
					var/amount = rand(2, 5)
					for(var/i = 0; i < amount; i++)
						new /mob/living/simple/hostile/carp(GET_TURF(H))
				//
			else
				for(var/mob/O in hearers(src, null))
					O.show_message(SPAN_INFO("Locked In"), 2)
				src.locked = L
				one_time_use = 1

			src.add_fingerprint(usr)
	else
		..()

	return

/obj/machinery/computer/teleporter/attack_paw()
	src.attack_hand()

/obj/machinery/teleport/station/attack_ai()
	src.attack_hand()

/obj/machinery/computer/teleporter/attack_hand()
	if(stat & (NOPOWER|BROKEN))
		return

	var/list/L = list()
	var/list/areaindex = list()

	for(var/obj/item/radio/beacon/R in GLOBL.movable_atom_list)
		var/turf/T = GET_TURF(R)
		if(isnull(T))
			continue
		if(isnotplayerlevel(T.z))
			continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	for(var/obj/item/implant/tracking/I in GLOBL.movable_atom_list)
		if(!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if(M.stat == DEAD)
				if(M.timeofdeath + 6000 < world.time)
					continue
			if(GET_TURF_Z(M) == 2)
				continue
			var/tmpname = M.real_name
			if(areaindex[tmpname])
				tmpname = "[tmpname] ([++areaindex[tmpname]])"
			else
				areaindex[tmpname] = 1
			L[tmpname] = I

	var/desc = input("Please select a location to lock in.", "Locking Computer") in L
	src.locked = L[desc]
	for(var/mob/O in hearers(src, null))
		O.show_message(SPAN_INFO("Locked In"), 2)
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/teleporter/verb/set_id(t as text)
	set category = null
	set name = "Set Teleporter ID"
	set desc = "ID Tag:"
	set src in oview(1)

	if(stat & (NOPOWER|BROKEN) || !isliving(usr))
		return
	if(t)
		src.id = t
	return

/proc/find_loc(obj/R)
	if(!R)
		return null
	var/turf/T = R.loc
	while(!isturf(T))
		T = T.loc
		if(!T || isarea(T))
			return null
	return T

/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/stationobjs.dmi'
	density = TRUE
	anchored = TRUE
	var/lockeddown = 0

/obj/machinery/teleport/hub
	name = "teleporter hub"
	desc = "It's the hub of a teleporting machine."
	icon_state = "tele0"

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 2000
	)

	var/accurate = 0

/obj/machinery/teleport/hub/Bumped(atom/movable/M)
	spawn()
		if(src.icon_state == "tele1")
			teleport(M)
			use_power(5000)
	return

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M)
	var/atom/l = src.loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(!com)
		return
	if(!com.locked)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_WARNING("Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix."))
		return
	if(ismovable(M))
		if(prob(5) && !accurate) //oh dear a problem, put em in deep space
			do_teleport(M, locate(rand((2*TRANSITIONEDGE), world.maxx - (2*TRANSITIONEDGE)), rand((2*TRANSITIONEDGE), world.maxy - (2*TRANSITIONEDGE)), 3), 2)
		else
			do_teleport(M, com.locked) //dead-on precision

		if(com.one_time_use) //Make one-time-use cards only usable one time!
			com.one_time_use = 0
			com.locked = null
	else
		make_sparks(5, TRUE, src)
		for(var/mob/B in hearers(src, null))
			B.show_message(SPAN_INFO("Test fire completed."))
	return
/*
/proc/do_teleport(atom/movable/M, atom/destination, precision)
	if(istype(M, /obj/effect))
		del(M)
		return
	if (istype(M, /obj/item/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>The [] bounces off of the portal!</B>", M.name), 1)
		return
	if(isliving(M))
		var/mob/living/MM = M
		if(MM.check_contents_for(/obj/item/disk/nuclear))
			MM << "\red Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through."
			return
	var/disky = 0
	for (var/atom/O in M.contents) //I'm pretty sure this accounts for the maximum amount of container in container stacking. --NeoFite
		if (istype(O, /obj/item/storage) || istype(O, /obj/item/gift))
			for (var/obj/OO in O.contents)
				if (istype(OO, /obj/item/storage) || istype(OO, /obj/item/gift))
					for (var/obj/OOO in OO.contents)
						if (istype(OOO, /obj/item/disk/nuclear))
							disky = 1
				if (istype(OO, /obj/item/disk/nuclear))
					disky = 1
		if (istype(O, /obj/item/disk/nuclear))
			disky = 1
		if(isliving(O))
			var/mob/living/MM = O
			if(MM.check_contents_for(/obj/item/disk/nuclear))
				disky = 1
	if (disky)
		for(var/mob/P in viewers(M, null))
			P.show_message(text("\red <B>The [] bounces off of the portal!</B>", M.name), 1)
		return

//Bags of Holding cause bluespace teleportation to go funky. --NeoFite
	if(isliving(M))
		var/mob/living/MM = M
		if(MM.check_contents_for(/obj/item/storage/backpack/holding))
			MM << "\red The bluespace interface on your Bag of Holding interferes with the teleport!"
			precision = rand(1,100)
	if (istype(M, /obj/item/storage/backpack/holding))
		precision = rand(1,100)
	for (var/atom/O in M.contents) //I'm pretty sure this accounts for the maximum amount of container in container stacking. --NeoFite
		if (istype(O, /obj/item/storage) || istype(O, /obj/item/gift))
			for (var/obj/OO in O.contents)
				if (istype(OO, /obj/item/storage) || istype(OO, /obj/item/gift))
					for (var/obj/OOO in OO.contents)
						if (istype(OOO, /obj/item/storage/backpack/holding))
							precision = rand(1,100)
				if (istype(OO, /obj/item/storage/backpack/holding))
					precision = rand(1,100)
		if (istype(O, /obj/item/storage/backpack/holding))
			precision = rand(1,100)
		if(isliving(O))
			var/mob/living/MM = O
			if(MM.check_contents_for(/obj/item/storage/backpack/holding))
				precision = rand(1,100)


	var/turf/destturf = GET_TURF(destination)

	var/tx = destturf.x + rand(precision * -1, precision)
	var/ty = destturf.y + rand(precision * -1, precision)

	var/tmploc

	if (ismob(destination.loc)) //If this is an implant.
		tmploc = locate(tx, ty, destturf.z)
	else
		tmploc = locate(tx, ty, destination.z)

	if(tx == destturf.x && ty == destturf.y && (istype(destination.loc, /obj/structure/closet) || istype(destination.loc, /obj/structure/closet/secure)))
		tmploc = destination.loc

	if(tmploc==null)
		return

	M.forceMove(tmploc)
	sleep(2)

	make_sparks(5, TRUE, M)
	return
*/

/obj/machinery/teleport/station
	name = "station"
	desc = "It's the station thingy of a teleport thingy." //seriously, wtf.
	icon_state = "controller"

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 2000
	)

	var/active = 0
	var/engaged = 0

/obj/machinery/teleport/station/attackby(obj/item/W)
	src.attack_hand()

/obj/machinery/teleport/station/attack_paw()
	src.attack_hand()

/obj/machinery/teleport/station/attack_ai()
	src.attack_hand()

/obj/machinery/teleport/station/attack_hand()
	if(engaged)
		src.disengage()
	else
		src.engage()

/obj/machinery/teleport/station/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	var/atom/l = src.loc
	var/atom/com = locate(/obj/machinery/teleport/hub, locate(l.x + 1, l.y, l.z))
	if(com)
		com.icon_state = "tele1"
		use_power(5000)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_INFO("Teleporter engaged!"), 2)
	src.add_fingerprint(usr)
	src.engaged = 1
	return

/obj/machinery/teleport/station/proc/disengage()
	if(stat & (BROKEN|NOPOWER))
		return

	var/atom/l = src.loc
	var/atom/com = locate(/obj/machinery/teleport/hub, locate(l.x + 1, l.y, l.z))
	if(com)
		com.icon_state = "tele0"
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_INFO("Teleporter disengaged!"), 2)
	src.add_fingerprint(usr)
	src.engaged = 0
	return

/obj/machinery/teleport/station/verb/testfire()
	set category = null
	set name = "Test Fire Teleporter"
	set src in oview(1)

	if(stat & (BROKEN|NOPOWER) || !isliving(usr))
		return

	var/atom/l = src.loc
	var/obj/machinery/teleport/hub/com = locate(/obj/machinery/teleport/hub, locate(l.x + 1, l.y, l.z))
	if(com && !active)
		active = 1
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_INFO("Test firing!"), 2)
		com.teleport()
		use_power(5000)

		spawn(30)
			active = 0

	src.add_fingerprint(usr)
	return

/obj/machinery/teleport/station/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "controller-p"
		var/obj/machinery/teleport/hub/com = locate(/obj/machinery/teleport/hub, locate(x + 1, y, z))
		if(com)
			com.icon_state = "tele0"
	else
		icon_state = "controller"

/obj/effect/laser/Bump()
	src.range--
	return

/obj/effect/laser/Move()
	src.range--
	return

/atom/proc/laserhit(obj/L)
	return 1