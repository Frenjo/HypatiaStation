///////////////////////////////
//CABLE STRUCTURE
///////////////////////////////

////////////////////////////////
// Definitions
///////////////////////////////

/* Cable directions (d1 and d2)

  9   1   5
	\ | /
  8 - 0 - 4
	/ | \
  10  2   6

If d1 = 0 and d2 = 0, there's no cable
If d1 = 0 and d2 = dir, it's a O-X cable, getting from the center of the tile to dir (knot cable)
If d1 = dir1 and d2 = dir2, it's a full X-X cable, getting from dir1 to dir2
By design, d1 is the smallest direction and d2 is the highest
*/
/obj/structure/cable
	level = 1
	anchored = TRUE

	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer"
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"

	layer = 2.44 //Just below unary stuff, which is at 2.45 and above pipes, which are at 2.4

	color = COLOR_RED

	var/datum/powernet/powernet

	var/d1 = 0
	var/d2 = 1

	var/obj/structure/powerswitch/power_switch

/obj/structure/cable/yellow
	color = COLOR_YELLOW

/obj/structure/cable/green
	color = COLOR_GREEN

/obj/structure/cable/blue
	color = COLOR_BLUE

/obj/structure/cable/pink
	color = COLOR_PINK

/obj/structure/cable/orange
	color = COLOR_ORANGE

/obj/structure/cable/cyan
	color = COLOR_CYAN

/obj/structure/cable/white
	color = COLOR_WHITE

/obj/structure/cable/initialise()
	. = ..()

	// ensure d1 & d2 reflect the icon_state for entering and exiting cable
	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact

	if(level == 1)
		hide(T.intact)
	GLOBL.cable_list.Add(src) //add it to the global cable list

/obj/structure/cable/Destroy()					// called when a cable is deleted
	if(isnotnull(powernet))
		cut_cable_from_powernet()				// update the powernets
	GLOBL.cable_list.Remove(src)				//remove it from global cable list
	return ..()									// then go ahead and delete the cable

///////////////////////////////////
// General procedures
///////////////////////////////////

//If underfloor, hide the cable
/obj/structure/cable/hide(i)
	if(level == 1 && isturf(loc))
		invisibility = i ? 101 : 0
	updateicon()

/obj/structure/cable/proc/updateicon()
	if(invisibility)
		icon_state = "[d1]-[d2]-f"
	else
		icon_state = "[d1]-[d2]"

// returns the powernet this cable belongs to
/obj/structure/cable/proc/get_powernet()			//TODO: remove this as it is obsolete
	return powernet

//Telekinesis has no effect on a cable
/obj/structure/cable/attack_tk(mob/user)
	return

// Items usable on a cable:
//   - Wirecutters: cut it duh!
//   - Cable coil: merge cables
//   - Multitool: get the power currently passing through the cable
//
/obj/structure/cable/attackby(obj/item/W, mob/user)
	var/turf/T = src.loc
	if(T.intact)
		return

	if(iswirecutter(W))
///// Z-Level Stuff
		if(src.d1 == 12 || src.d2 == 12)
			to_chat(user, SPAN_WARNING("You must cut this cable from above."))
			return
///// Z-Level Stuff

//		if(power_switch)
//			user << "\red This piece of cable is tied to a power switch. Flip the switch to remove it."
//			return

		if(shock(user, 50))
			return

		if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
			new/obj/item/stack/cable_coil(T, 2, color)
		else
			new/obj/item/stack/cable_coil(T, 1, color)

		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_WARNING("[user] cuts the cable."), 1)

///// Z-Level Stuff
		if(src.d1 == 11 || src.d2 == 11)
			var/turf/controllerlocation = locate(1, 1, z)
			for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
				if(controller.down)
					var/turf/below = locate(src.x, src.y, controller.down_target)
					for(var/obj/structure/cable/c in below)
						if(c.d1 == 12 || c.d2 == 12)
							qdel(c)
///// Z-Level Stuff
		investigate_log("was cut by [key_name(usr, usr.client)] in [user.loc.loc]", "wires")

		qdel(src)

		return	// not needed, but for clarity


	else if(iscable(W))
		var/obj/item/stack/cable_coil/coil = W
		if(coil.amount < 1)
			to_chat(user, "Not enough cable.")
			return
		coil.cable_join(src, user)

	else if(ismultitool(W))
		if(powernet && (powernet.avail > 0))		// is it powered?
			to_chat(user, SPAN_WARNING("[powernet.avail]W in power network."))
		else
			to_chat(user, SPAN_WARNING("The cable is not powered."))

		shock(user, 5, 0.2)

	else
		if(HAS_OBJ_FLAGS(W, OBJ_FLAG_CONDUCT))
			shock(user, 50, 0.7)

	src.add_fingerprint(user)

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if(electrocute_mob(user, powernet, src, siemens_coeff))
		make_sparks(5, TRUE, src)
		return 1
	else
		return 0

//explosion handling
/obj/structure/cable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)

		if(3.0)
			if(prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)
	return

/obj/structure/cable/proc/cableColor(colorC)
	var/color_n = "#DD0000"
	if(colorC)
		color_n = colorC
	color = color_n

/////////////////////////////////////////////////
// Cable laying helpers
////////////////////////////////////////////////

//handles merging diagonally matching cables
//for info: direction^3 is flipping horizontally, direction^12 is flipping vertically
/obj/structure/cable/proc/mergeDiagonalsNetworks(direction)
	//search for and merge diagonally matching cables from the first direction component (north/south)
	var/turf/T  = get_step(src, direction&3)//go north/south

	for(var/obj/structure/cable/C in T)
		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == (direction^3) || C.d2 == (direction^3)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet, C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

	//the same from the second direction component (east/west)
	T  = get_step(src, direction & 12)//go east/west

	for(var/obj/structure/cable/C in T)
		if(!C)
			continue

		if(src == C)
			continue
		if(C.d1 == (direction^12) || C.d2 == (direction^12)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet, C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the given direction
/obj/structure/cable/proc/mergeConnectedNetworks(direction)
	var/fdir = (!direction)? 0 : turn(direction, 180) //flip the direction, to match with the source position on its turf

	if(!(d1 == direction || d2 == direction)) //if the cable is not pointed in this direction, do nothing
		return

	var/turf/TB  = get_step(src, direction)

	for(var/obj/structure/cable/C in TB)
		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == fdir || C.d2 == fdir) //we've got a matching cable in the neighbor turf
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the source turf
/obj/structure/cable/proc/mergeConnectedNetworksOnTurf()
	var/list/to_connect = list()

	if(!powernet) //if we somehow have no powernet, make one (should not happen for cables)
		var/datum/powernet/newPN = new()
		newPN.add_cable(src)

	//first let's add turf cables to our powernet
	//then we'll connect machines on turf with a node cable is present
	for(var/AM in loc)
		if(istype(AM, /obj/structure/cable))
			var/obj/structure/cable/C = AM
			if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) //only connected if they have a common direction
				if(C.powernet == powernet)	continue
				if(C.powernet)
					merge_powernets(powernet, C.powernet)
				else
					powernet.add_cable(C) //the cable was powernetless, let's just add it to our powernet

		else if(istype(AM, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/N = AM
			if(!N.terminal)
				continue // APC are connected through their terminal

			if(N.terminal.powernet == powernet)
				continue

			to_connect += N.terminal //we'll connect the machines after all cables are merged

		else if(istype(AM, /obj/machinery/power)) //other power machines
			var/obj/machinery/power/M = AM

			if(M.powernet == powernet)
				continue

			to_connect += M //we'll connect the machines after all cables are merged

	//now that cables are done, let's connect found machines
	for(var/obj/machinery/power/PM in to_connect)
		if(!PM.connect_to_network())
			PM.disconnect_from_network() //if we somehow can't connect the machine to the new powernet, remove it from the old nonetheless

//////////////////////////////////////////////
// Powernets handling helpers
//////////////////////////////////////////////

//if powernetless_only = 1, will only get connections without powernet
/obj/structure/cable/proc/get_connections(powernetless_only = 0)
	. = list()	// this will be a list of all connected power objects
	var/turf/T

///// Z-Level Stuff
	if(d1 == 11 || d1 == 12)
		var/turf/controllerlocation = locate(1, 1, z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.up && d1 == 12)
				T = locate(src.x, src.y, controller.up_target)
				if(T)
					. += power_list(T, src, 11, 1)
			if(controller.down && d1 == 11)
				T = locate(src.x, src.y, controller.down_target)
				if(T)
					. += power_list(T, src, 12, 1)
///// Z-Level Stuff
	//get matching cables from the first direction
	else if(d1) //if not a node cable
		T = get_step(src, d1)
		if(T)
			. += power_list(T, src, turn(d1, 180), powernetless_only) //get adjacents matching cables

	if(d1 & (d1 - 1)) //diagonal direction, must check the 4 possibles adjacents tiles
		T = get_step(src, d1 & 3) // go north/south
		if(T)
			. += power_list(T, src, d1 ^ 3, powernetless_only) //get diagonally matching cables
		T = get_step(src, d1 & 12) // go east/west
		if(T)
			. += power_list(T, src, d1 ^ 12, powernetless_only) //get diagonally matching cables

	. += power_list(loc, src, d1, powernetless_only) //get on turf matching cables

///// Z-Level Stuff
	if(d2 == 11 || d2 == 12)
		var/turf/controllerlocation = locate(1, 1, z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.up && d2 == 12)
				T = locate(src.x, src.y, controller.up_target)
				if(T)
					. += power_list(T, src, 11, 1)
			if(controller.down && d2 == 11)
				T = locate(src.x, src.y, controller.down_target)
				if(T)
					. += power_list(T, src, 12, 1)
///// Z-Level Stuff
	else
		//do the same on the second direction (which can't be 0)
		T = get_step(src, d2)
		if(T)
			. += power_list(T, src, turn(d2, 180), powernetless_only) //get adjacents matching cables

		if(d2 & (d2 - 1)) //diagonal direction, must check the 4 possibles adjacents tiles
			T = get_step(src, d2 & 3) // go north/south
			if(T)
				. += power_list(T, src, d2 ^ 3, powernetless_only) //get diagonally matching cables
			T = get_step(src, d2 & 12) // go east/west
			if(T)
				. += power_list(T, src, d2 ^ 12, powernetless_only) //get diagonally matching cables
		. += power_list(loc, src, d2, powernetless_only) //get on turf matching cables

//should be called after placing a cable which extends another cable, creating a "smooth" cable that no longer terminates in the centre of a turf.
//needed as this can, unlike other placements, disconnect cables
/obj/structure/cable/proc/denode()
	var/turf/T1 = loc
	if(!T1)
		return

	var/list/powerlist = power_list(T1, src, 0, 0) //find the other cables that ended in the centre of the turf, with or without a powernet
	if(length(powerlist))
		var/datum/powernet/PN = new()
		propagate_network(powerlist[1], PN) //propagates the new powernet beginning at the source cable

		if(PN.is_empty()) //can happen with machines made nodeless when smoothing cables
			qdel(PN) // qdel

// cut the cable's powernet at this cable and updates the powergrid
/obj/structure/cable/proc/cut_cable_from_powernet()
	var/turf/T1 = loc
	var/list/P_list
	if(!T1)
		return
	if(d1)
		T1 = get_step(T1, d1)
		P_list = power_list(T1, src, turn(d1, 180), 0, cable_only = 1)	// what adjacently joins on to cut cable...

	P_list += power_list(loc, src, d1, 0, cable_only = 1)//... and on turf


	if(!length(P_list))//if nothing in both list, then the cable was a lone cable, just delete it and its powernet
		powernet.remove_cable(src)

		for(var/obj/machinery/power/P in T1)//check if it was powering a machine
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network (and delete powernet)
		return

	// remove the cut cable from its turf and powernet, so that it doesn't get count in propagate_network worklist
	loc = null
	powernet.remove_cable(src) //remove the cut cable from its powernet

	var/datum/powernet/newPN = new()// creates a new powernet...
	propagate_network(P_list[1], newPN)//... and propagates it to the other side of the cable

	// Disconnect machines connected to nodes
	if(d1 == 0) // if we cut a node (O-X) cable
		for(var/obj/machinery/power/P in T1)
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network

///////////////////////////////////////////////
// The cable coil object, used for laying cable
///////////////////////////////////////////////

////////////////////////////////
// Definitions
////////////////////////////////
#define MAXCOIL 30

/obj/item/stack/cable_coil
	name = "cable coil"
	desc = "A coil of power cable."
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"

	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	tool_flags = TOOL_FLAG_CABLE_COIL

	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_RED
	item_color = COLOR_RED
	throwforce = 10
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	matter_amounts = alist(/decl/material/steel = 50, /decl/material/plastic = 20)
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")

/obj/item/stack/cable_coil/suicide_act(mob/user)
	if(locate(/obj/structure/stool) in user.loc)
		user.visible_message("<span class='suicide'>[user] is making a noose with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	else
		user.visible_message("<span class='suicide'>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/stack/cable_coil/New(loc, length = MAXCOIL, param_color = null)
	..()
	src.amount = length
	if(param_color)
		item_color = param_color
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()

///////////////////////////////////
// General procedures
///////////////////////////////////

//you can use wires to heal robotics
/obj/item/stack/cable_coil/attack(mob/M, mob/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/S = H.get_organ(user.zone_sel.selecting)
		if(!(S.status & ORGAN_ROBOT) || user.a_intent != "help")
			return ..()

		if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
			if(M == user)
				to_chat(user, SPAN_WARNING("You can't repair damage to your own body - it's against OH&S."))
				return

		if(S.burn_dam > 0 && use(1))
			S.heal_damage(0, 15, 0, 1)
			user.visible_message(SPAN_WARNING("\The [user] repairs some burn damage on \the [M]'s [S.display_name] with \the [src]."))
			return
		else
			to_chat(user, "Nothing to fix!")

	else
		return ..()

/obj/item/stack/cable_coil/update_icon()
	if(!item_color)
		item_color = pick(COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_ORANGE, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
	color = item_color
	if(amount == 1)
		icon_state = "coil1"
		name = "cable piece"
	else if(amount == 2)
		icon_state = "coil2"
		name = "cable piece"
	else
		icon_state = "coil"
		name = "cable coil"

/obj/item/stack/cable_coil/examine()
	set src in view(1)

	if(amount == 1)
		to_chat(usr, "A short piece of power cable.")
	else if(amount == 2)
		to_chat(usr, "A piece of power cable.")
	else
		to_chat(usr, "A coil of power cable. There are [amount] lengths of cable in the coil.")

/obj/item/stack/cable_coil/verb/make_restraint()
	set category = PANEL_OBJECT
	set name = "Make Cable Restraints"
	var/mob/M = usr

	if(ishuman(M) && !M.restrained() && !M.stat && !M.paralysis && ! M.stunned)
		if(!isturf(usr.loc))
			return
		if(src.amount <= 14)
			to_chat(usr, SPAN_WARNING("You need at least 15 lengths to make restraints!"))
			return
		var/obj/item/handcuffs/cable/B = new /obj/item/handcuffs/cable(usr.loc)
		B.icon_state = "cuff_[item_color]"
		to_chat(usr, SPAN_INFO("You wind some cable together to make some restraints."))
		src.use(15)
	else
		to_chat(usr, SPAN_INFO("You cannot do that."))

// Items usable on a cable coil:
//	- Wirecutters: cut them duh!
//	- Cable coil: merge cables
/obj/item/stack/cable_coil/attackby(obj/item/W, mob/user)
	if(iswirecutter(W) && src.amount > 1)
		src.amount--
		new/obj/item/stack/cable_coil(user.loc, 1, item_color)
		to_chat(user, SPAN_NOTICE("You cut a piece off the cable coil."))
		src.update_icon()
		return

	else if(iscable(W))
		var/obj/item/stack/cable_coil/C = W

		if(C.amount >= MAXCOIL)
			to_chat(user, SPAN_NOTICE("The coil is too long, you cannot add any more cable to it."))
			return

		if(C.amount + src.amount <= MAXCOIL)
			to_chat(user, SPAN_NOTICE("You join the cable coils together."))
			C.add(src.amount) // give it cable
			src.use(src.amount) // make sure this one cleans up right
		else
			var/amt = MAXCOIL - C.amount
			to_chat(user, SPAN_NOTICE("You transfer [amt] length\s of cable from one coil to the other."))
			C.add(amt)
			src.use(amt)

		return
	..()

/obj/item/stack/cable_coil/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		var/obj/item/stack/cable_coil/F = new /obj/item/stack/cable_coil(user, 1, color)
		F.copy_evidences(src)
		user.put_in_hands(F)
		src.add_fingerprint(user)
		F.add_fingerprint(user)
		use(1)
	else
		..()
	return

//remove cables from the stack
/obj/item/stack/cable_coil/use(used)
	. = ..()
	update_icon()

//add cables to the stack
/obj/item/stack/cable_coil/add(extra)
	. = ..()
	update_icon()

///////////////////////////////////////////////
// Cable laying procedures
//////////////////////////////////////////////

// called when cable_coil is clicked on a turf/open/floor
/obj/item/stack/cable_coil/proc/turf_place(turf/open/floor/F, mob/user)
	if(!isturf(user.loc))
		return

	if(amount < 1) // Out of cable
		to_chat(user, "There is no cable left.")
		return

	if(get_dist(F,user) > 1) // Too far
		to_chat(user, "You can't lay cable at a place that far away.")

	if(F.intact)		// if floor is intact, complain
		to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
		return

	else
		var/dirn

		if(user.loc == F)
			dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, user)

		for(var/obj/structure/cable/LC in F)
			if((LC.d1 == dirn && LC.d2 == 0) || (LC.d2 == dirn && LC.d1 == 0))
				to_chat(user, SPAN_WARNING("There's already a cable at that position."))
				return
///// Z-Level Stuff
		// check if the target is open space
		if(isopenspace(F))
			for(var/obj/structure/cable/LC in F)
				if((LC.d1 == dirn && LC.d2 == 11) || (LC.d2 == dirn && LC.d1 == 11))
					to_chat(user, SPAN_WARNING("There's already a cable at that position."))
					return

			var/turf/open/floor/open/temp = F
			var/obj/structure/cable/C = new(F)
			var/obj/structure/cable/D = new(temp.floorbelow)

			C.cableColor(item_color)

			C.d1 = 11
			C.d2 = dirn
			C.add_fingerprint(user)
			C.updateicon()

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			D.cableColor(item_color)

			D.d1 = 12
			D.d2 = 0
			D.add_fingerprint(user)
			D.updateicon()

			PN.add_cable(D)

			D.mergeConnectedNetworksOnTurf()

		// do the normal stuff
		else
///// Z-Level Stuff
			for(var/obj/structure/cable/LC in F)
				if((LC.d1 == dirn && LC.d2 == 0) || (LC.d2 == dirn && LC.d1 == 0))
					to_chat(user, "There's already a cable at that position.")
					return

			var/obj/structure/cable/C = new(F)

			C.cableColor(item_color)

			//set up the new cable
			C.d1 = 0 //it's a O-X node cable
			C.d2 = dirn
			C.add_fingerprint(user)
			C.updateicon()

			//create a new powernet with the cable, if needed it will be merged later
			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2) //merge the powernet with adjacents powernets
			C.mergeConnectedNetworksOnTurf() //merge the powernet with on turf powernets

			if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)

			use(1)
			if(C.shock(user, 50))
				if(prob(50)) //fail
					new/obj/item/stack/cable_coil(C.loc, 1, C.color)
					qdel(C)

// called when cable_coil is click on an installed obj/cable
// or click on a turf that already contains a "node" cable
/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)
	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || T.intact)		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if(U == T) //if clicked on the turf we're standing on, try to put a cable in the direction we're facing
		turf_place(T,user)
		return

	var/dirn = get_dir(C, user)

	// one end of the clicked cable is pointing towards us
	if(C.d1 == dirn || C.d2 == dirn)
		if(U.intact)						// can't place a cable if the floor is complete
			to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					to_chat(user, "There's already a cable at that position.")
					return

			var/obj/structure/cable/NC = new(U)
			NC.cableColor(item_color)

			NC.d1 = 0
			NC.d2 = fdirn
			NC.add_fingerprint()
			NC.updateicon()

			//create a new powernet with the cable, if needed it will be merged later
			var/datum/powernet/newPN = new()
			newPN.add_cable(NC)

			NC.mergeConnectedNetworks(NC.d2) //merge the powernet with adjacents powernets
			NC.mergeConnectedNetworksOnTurf() //merge the powernet with on turf powernets

			if(NC.d2 & (NC.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				NC.mergeDiagonalsNetworks(NC.d2)

			use(1)
			if(NC.shock(user, 50))
				if(prob(50)) //fail
					new/obj/item/stack/cable_coil(NC.loc, 1, NC.color)
					qdel(NC)

			return
	// existing cable doesn't point at our position, so see if it's a stub
	else if(C.d1 == 0)
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T)		// check to make sure there's no matching cable
			if(LC == C)			// skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1))	// make sure no cable matches either direction
				to_chat(user, "There's already a cable at that position.")
				return


		C.cableColor(item_color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.updateicon()

		C.mergeConnectedNetworks(C.d1) //merge the powernets...
		C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
		C.mergeConnectedNetworksOnTurf()

		if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d1)

		if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d2)

		use(1)
		if(C.shock(user, 50))
			if(prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				qdel(C)
				return

		C.denode()// this call may have disconnected some cables that terminated on the centre of the turf, if so split the powernets.
		return

//////////////////////////////
// Misc.
/////////////////////////////

/obj/item/stack/cable_coil/cut
	item_state = "coil2"

/obj/item/stack/cable_coil/cut/New(loc)
	..()
	src.amount = rand(1,2)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()

/obj/item/stack/cable_coil/yellow
	color = COLOR_YELLOW
	item_color = COLOR_YELLOW

/obj/item/stack/cable_coil/blue
	color = COLOR_BLUE
	item_color = COLOR_BLUE

/obj/item/stack/cable_coil/green
	color = COLOR_GREEN
	item_color = COLOR_GREEN

/obj/item/stack/cable_coil/pink
	color = COLOR_PINK
	item_color = COLOR_PINK

/obj/item/stack/cable_coil/orange
	color = COLOR_ORANGE
	item_color = COLOR_ORANGE

/obj/item/stack/cable_coil/cyan
	color = COLOR_CYAN
	item_color = COLOR_CYAN

/obj/item/stack/cable_coil/white
	color = COLOR_WHITE
	item_color = COLOR_WHITE

/obj/item/stack/cable_coil/random/initialise()
	. = ..()
	item_color = pick(COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)

#undef MAXCOIL