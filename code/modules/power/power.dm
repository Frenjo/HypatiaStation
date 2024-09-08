//////////////////////////////
// POWER MACHINERY BASE CLASS
//////////////////////////////

/////////////////////////////
// Definitions
/////////////////////////////

/obj/machinery/power
	name = null
	icon = 'icons/obj/power.dmi'
	anchored = TRUE

	power_state = USE_POWER_OFF

	var/datum/powernet/powernet = null

/obj/machinery/power/Destroy()
	disconnect_from_network()
	disconnect_terminal()
	return ..()

///////////////////////////////
// General procedures
//////////////////////////////

// common helper procs for all power machines
/obj/machinery/power/proc/add_avail(amount)
	if(isnotnull(powernet))
		powernet.newavail += amount

/obj/machinery/power/proc/draw_power(amount)
	return isnotnull(powernet) ? powernet.draw_power(amount) : 0

/obj/machinery/power/proc/surplus()
	return isnotnull(powernet) ? powernet.avail - powernet.load : 0

/obj/machinery/power/proc/avail()
	return isnotnull(powernet) ? powernet.avail : 0

/obj/machinery/power/proc/disconnect_terminal() // machines without a terminal will just return, no harm no fowl.
	return

// returns true if the area has power on given channel (or doesn't require power).
/obj/machinery/proc/powered(chan = -1) // defaults to power_channel
	if(isnull(loc))
		return 0

	//Don't do this. It allows machines that set use_power to 0 when off (many machines) to
	//be turned on again and used after a power failure because they never gain the NOPOWER flag.
	//if(!use_power)
	//	return 1

	var/area/A = loc.loc		// make sure it's in an area
	if(!isarea(A))
		return 0				// if not, then not powered
	if(chan == -1)
		chan = power_channel
	return A.powered(chan) // return power status of the area

// increment the power usage stats for an area
/obj/machinery/proc/use_power(amount, chan = -1) // defaults to power_channel
	var/area/A = GET_AREA(src)		// make sure it's in an area
	if(!isarea(A))
		return
	if(chan == -1)
		chan = power_channel
	A.use_power(amount, chan)

// called whenever the power settings of the containing area change
/obj/machinery/proc/power_change()	// by default, check equipment channel & set flag, can override if needed
	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

// connect the machine to a powernet if a node cable is present on the turf
/obj/machinery/power/proc/connect_to_network()
	var/turf/T = loc
	if(!istype(T))
		return 0

	var/obj/structure/cable/C = T.get_cable_node() //check if we have a node cable on the machine turf, the first found is picked
	if(isnull(C?.powernet))
		return 0

	C.powernet.add_machine(src)
	return 1

// remove and disconnect the machine from its current powernet
/obj/machinery/power/proc/disconnect_from_network()
	if(isnull(powernet))
		return 0
	powernet.remove_machine(src)
	return 1

// attach a wire to a power machine - leads from the turf you are standing on
//almost never called, overwritten by all power machines but terminal and generator
/obj/machinery/power/attackby(obj/item/W, mob/user)
	if(iscable(W))
		var/obj/item/stack/cable_coil/coil = W
		var/turf/T = user.loc

		if(T.intact || !istype(T, /turf/open/floor))
			return

		if(!in_range(src, user))
			return

		coil.turf_place(T, user)
		return
	else
		..()
	return

///////////////////////////////////////////
// Powernet handling helpers
//////////////////////////////////////////

//returns all the cables WITHOUT a powernet in neighbors turfs,
//pointing towards the turf the machine is located at
/obj/machinery/power/proc/get_connections()
	. = list()

	var/cdir
	var/turf/T

	for(var/card in GLOBL.cardinal)
		T = get_step(loc, card)
		cdir = get_dir(T, loc)

		for(var/obj/structure/cable/C in T)
			if(C.powernet)
				continue
			if(C.d1 == cdir || C.d2 == cdir)
				. += C
	return .

//returns all the cables in neighbors turfs,
//pointing towards the turf the machine is located at
/obj/machinery/power/proc/get_marked_connections()
	. = list()

	var/cdir
	var/turf/T

	for(var/card in GLOBL.cardinal)
		T = get_step(loc, card)
		cdir = get_dir(T, loc)

		for(var/obj/structure/cable/C in T)
			if(C.d1 == cdir || C.d2 == cdir)
				. += C
	return .

//returns all the NODES (O-X) cables WITHOUT a powernet in the turf the machine is located at
/obj/machinery/power/proc/get_indirect_connections()
	. = list()
	for(var/obj/structure/cable/C in loc)
		if(isnotnull(C.powernet))
			continue
		if(C.d1 == 0) // the cable is a node cable
			. += C
	return .

///////////////////////////////////////////
// GLOBAL PROCS for powernets handling
//////////////////////////////////////////

// returns a list of all power-related objects (nodes, cable, junctions) in turf,
// excluding source, that match the direction d
// if unmarked==1, only return those with no powernet
/proc/power_list(turf/T, source, d, unmarked=0, cable_only = 0)
	. = list()
	var/fdir = (!d)? 0 : turn(d, 180)			// the opposite direction to d (or 0 if d==0)
///// Z-Level Stuff
	var/Zdir
	if(d == 11)
		Zdir = 11
	else if(d == 12)
		Zdir = 12
	else
		Zdir = 999
///// Z-Level Stuff
//	world.log << "d=[d] fdir=[fdir]"
	for(var/AM in T)
		if(AM == source)
			continue			//we don't want to return source

		if(!cable_only && istype(AM, /obj/machinery/power))
			var/obj/machinery/power/P = AM
			if(P.powernet == 0)
				continue		// exclude APCs which have powernet=0

			if(!unmarked || !P.powernet)		//if unmarked=1 we only return things with no powernet
				if(d == 0)
					. += P

		else if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM

			if(!unmarked || !C.powernet)
///// Z-Level Stuff
				if(C.d1 == fdir || C.d2 == fdir || C.d1 == Zdir || C.d2 == Zdir)
///// Z-Level Stuff
					. += C
				else if(C.d1 == d || C.d2 == d)
					. += C
	return .

/hook/startup/proc/buildPowernets()
	return makepowernets()

// rebuild all power networks from scratch - only called at world creation or by the admin verb
/proc/makepowernets()
	for(var/datum/powernet/PN in GLOBL.powernets)
		qdel(PN)
	GLOBL.powernets.Cut()

	for_no_type_check(var/obj/structure/cable/PC, GLOBL.cable_list)
		if(isnull(PC.powernet))
			var/datum/powernet/NewPN = new /datum/powernet()
			NewPN.add_cable(PC)
			propagate_network(PC, PC.powernet)
	return 1

//remove the old powernet and replace it with a new one throughout the network.
/proc/propagate_network(obj/O, datum/powernet/PN)
	//world.log << "propagating new network"
	var/list/worklist = list()
	var/list/found_machines = list()
	var/index = 1
	var/obj/P = null

	worklist += O //start propagating from the passed object

	while(index <= length(worklist)) //until we've exhausted all power objects
		P = worklist[index] //get the next power object found
		index++

		if(istype(P, /obj/structure/cable))
			var/obj/structure/cable/C = P
			if(C.powernet != PN) //add it to the powernet, if it isn't already there
				PN.add_cable(C)
			worklist |= C.get_connections() //get adjacents power objects, with or without a powernet

		else if(P.anchored && istype(P, /obj/machinery/power))
			var/obj/machinery/power/M = P
			found_machines |= M //we wait until the powernet is fully propagates to connect the machines

		else
			continue

	for(var/obj/machinery/power/PM in found_machines)
		if(!PM.connect_to_network()) //couldn't find a node on its turf...
			PM.disconnect_from_network() //... so disconnect if already on a powernet

//Merge two powernets, the bigger (in cable length term) absorbing the other
/proc/merge_powernets(datum/powernet/net1, datum/powernet/net2)
	if(isnull(net1) || isnull(net2)) //if one of the powernet doesn't exist, return
		return

	if(net1 == net2) //don't merge same powernets
		return

	//We assume net1 is larger. If net2 is in fact larger we are just going to make them switch places to reduce on code.
	if(length(net1.cables) < length(net2.cables))	//net2 is larger than net1. Let's switch them around
		var/temp = net1
		net1 = net2
		net2 = temp

	//merge net2 into net1
	for_no_type_check(var/obj/structure/cable/C, net2.cables) //merge cables
		net1.add_cable(C)

	for_no_type_check(var/obj/machinery/power/M, net2.nodes) //merge power machines
		if(!M.connect_to_network())
			M.disconnect_from_network() //if somehow we can't connect the machine to the new powernet, disconnect it from the old nonetheless

	return net1

//Determines how strong could be shock, deals damage to mob, uses power.
//M is a mob who touched wire/whatever
//power_source is a source of electricity, can be powercell, area, apc, cable, powernet or null
//source is an object caused electrocuting (airlock, grille, etc)
//No animations will be performed by this proc.
/proc/electrocute_mob(mob/living/carbon/M, power_source, obj/source, siemens_coeff = 1.0)
	if(ismecha(M.loc))
		return 0	//feckin mechs are dumb
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.insulated)
			return 0
		else if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.siemens_coefficient == 0)
				return 0		//to avoid spamming with insulated glvoes on

	var/area/source_area
	if(isarea(power_source))
		source_area = power_source
		power_source = source_area.get_apc()
	if(istype(power_source, /obj/structure/cable))
		var/obj/structure/cable/Cable = power_source
		power_source = Cable.powernet

	var/datum/powernet/PN
	var/obj/item/cell/cell

	if(istype(power_source, /datum/powernet))
		PN = power_source
	else if(istype(power_source, /obj/item/cell))
		cell = power_source
	else if(istype(power_source, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/apc = power_source
		cell = apc.cell
		if(apc.terminal)
			PN = apc.terminal.powernet
	else if(!power_source)
		return 0
	else
		log_admin("ERROR: /proc/electrocute_mob([M], [power_source], [source]): wrong power_source")
		return 0
	if(!cell && !PN)
		return 0

	var/PN_damage = 0
	var/cell_damage = 0
	if(PN)
		PN_damage = PN.get_electrocute_damage()
	if(cell)
		cell_damage = cell.get_electrocute_damage()

	var/shock_damage = 0
	if(PN_damage >= cell_damage)
		power_source = PN
		shock_damage = PN_damage
	else
		power_source = cell
		shock_damage = cell_damage
	var/drained_hp = M.electrocute_act(shock_damage, source, siemens_coeff) //zzzzzzap!
	var/drained_energy = drained_hp * 20

	if(source_area)
		source_area.use_power(drained_energy)
	else if(istype(power_source, /datum/powernet))
		//var/drained_power = drained_energy/CELLRATE //convert from "joules" to "watts" << apparently this is wrong!
		PN.draw_power(drained_energy)
	else if(istype(power_source, /obj/item/cell))
		cell.use(drained_energy * CELLRATE)
	return drained_energy