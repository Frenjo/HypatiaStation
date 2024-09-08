/*
 * Supply Process
 */
PROCESS_DEF(supply)
	name = "Supply"
	schedule_interval = 30 SECONDS

	// Supply points
	var/points = 50
	var/points_per_process = 1
	var/points_per_slip = 2
	var/points_per_crate = 5
	var/plasma_per_point = 2 // 2 plasma for 1 point.

	// Control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()

	// Shuttle movement
	var/movetime = 2 MINUTES
	var/datum/shuttle/ferry/supply/shuttle

/datum/process/supply/setup()
	ordernum = rand(1, 9000)
	shuttle = global.PCshuttle.shuttles["Supply"]

// Handles supply point regeneration.
/datum/process/supply/do_work()
	points += points_per_process

// To stop things being sent to centcom which should not be sent to centcom.
// Recursively checks for these types.
// Returns TRUE if there's a forbidden atom.
/datum/process/supply/proc/forbidden_atoms_check(atom/A)
	if(isliving(A))
		return TRUE
	if(istype(A, /obj/item/disk/nuclear))
		return TRUE
	if(istype(A, /obj/machinery/nuclearbomb))
		return TRUE
	if(istype(A, /obj/item/radio/beacon))
		return TRUE

	for(var/i = 1, i <= length(A.contents), i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return TRUE
	return FALSE

// Selling.
/datum/process/supply/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(isnull(area_shuttle))
		return

	var/plasma_count = 0

	for(var/atom/movable/MA in area_shuttle)
		if(MA.anchored)
			continue

		// Must be in a crate!
		if(istype(MA, /obj/structure/closet/crate))
			callHook("sell_crate", list(MA, area_shuttle))

			points += points_per_crate
			var/find_slip = 1

			for(var/atom in MA)
				// Sell manifests
				var/atom/A = atom
				if(find_slip && istype(A, /obj/item/paper/manifest))
					var/obj/item/paper/slip = A
					if(length(slip.stamped)) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
						points += points_per_slip
						find_slip = 0
					continue

				// Sell plasma
				if(istype(A, /obj/item/stack/sheet/plasma))
					var/obj/item/stack/sheet/plasma/P = A
					plasma_count += P.amount

		qdel(MA)

	if(plasma_count)
		points += Floor(plasma_count / plasma_per_point)

// Buying.
/datum/process/supply/proc/buy()
	if(!length(shoppinglist))
		return

	var/area/area_shuttle = shuttle.get_location_area()
	if(isnull(area_shuttle))
		return

	var/list/clear_turfs = list()

	for_no_type_check(var/turf/T, area_shuttle.turf_list)
		if(T.density)
			continue
		var/contcount
		for_no_type_check(var/atom/movable/mover, T)
			if(istype(mover, /atom/movable/lighting_overlay))
				continue
			if(istype(mover, /obj/machinery/light))
				continue
			contcount++
		if(contcount)
			continue
		clear_turfs.Add(T)

	for(var/S in shoppinglist)
		if(!length(clear_turfs))
			break
		var/i = rand(1, length(clear_turfs))
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i, i + 1)

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/structure/O = new SP.containertype(pickedloc)
		O.name = "[SP.containername] [SO.comment ? "([SO.comment])":"" ]"

		//supply manifest generation begin
		var/obj/item/paper/manifest/slip = new /obj/item/paper/manifest(O)
		slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
		slip.info +="Order #[SO.ordernum]<br>"
		slip.info +="Destination: [GLOBL.current_map.station_name]<br>"
		slip.info +="[length(shoppinglist)] PACKAGES IN THIS SHIPMENT<br>"
		slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			O.req_access = list()
			O.req_access.Add(text2num(SP.access))

		var/list/spawned = SP.spawn_contents(O)
		for(var/atom/content in spawned)
			slip.info += "<li>[content.name]</li>" //add the item to the manifest
		slip.info += "</ul><br>"
		slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
		if(SP.contraband)
			slip.loc = null	//we are out of blanks for Form #44-D Ordering Illicit Drugs.

	shoppinglist.Cut()

// Supply manifest
/obj/item/paper/manifest
	name = "Supply Manifest"