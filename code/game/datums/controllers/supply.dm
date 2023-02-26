/*
 * Supply Controller
 */
CONTROLLER_DEF(supply)
	name = "Supply"

	var/processing = 1
	var/processing_interval = 300
	var/iteration = 0
	//supply points
	var/points = 50
	var/points_per_process = 1
	var/points_per_slip = 2
	var/points_per_crate = 5
	var/plasma_per_point = 2 // 2 plasma for 1 point
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/ferry/supply/shuttle

/datum/controller/supply/New()
	. = ..()
	ordernum = rand(1, 9000)

//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcom and the station
/datum/controller/supply/process()
	points += points_per_process

//To stop things being sent to centcom which should not be sent to centcom. Recursively checks for these types.
/datum/controller/supply/proc/forbidden_atoms_check(atom/A)
	if(isliving(A))
		return 1
	if(istype(A, /obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A, /obj/machinery/nuclearbomb))
		return 1
	if(istype(A, /obj/item/device/radio/beacon))
		return 1

	for(var/i = 1, i <= length(A.contents), i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

//Sellin
/datum/controller/supply/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
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
				if(find_slip && istype(A, /obj/item/weapon/paper/manifest))
					var/obj/item/weapon/paper/slip = A
					if(length(slip.stamped)) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
						points += points_per_slip
						find_slip = 0
					continue

				// Sell plasma
				if(istype(A, /obj/item/stack/sheet/mineral/plasma))
					var/obj/item/stack/sheet/mineral/plasma/P = A
					plasma_count += P.amount

		qdel(MA)

	if(plasma_count)
		points += Floor(plasma_count / plasma_per_point)

//Buyin
/datum/controller/supply/proc/buy()
	if(!length(shoppinglist))
		return

	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		return

	var/list/clear_turfs = list()

	for(var/turf/T in area_shuttle)
		if(T.density)
			continue
		var/contcount
		for(var/atom/A in T.contents)
			if(istype(A, /atom/movable/lighting_overlay))
				continue
			if(istype(A, /obj/machinery/light))
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

		var/atom/A = new SP.containertype(pickedloc)
		A.name = "[SP.containername] [SO.comment ? "([SO.comment])":"" ]"

		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip = new /obj/item/weapon/paper/manifest(A)
		slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
		slip.info +="Order #[SO.ordernum]<br>"
		slip.info +="Destination: [GLOBL.current_map.station_name]<br>"
		slip.info +="[length(shoppinglist)] PACKAGES IN THIS SHIPMENT<br>"
		slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			A:req_access = list()
			A:req_access.Add(text2num(SP.access))

		var/list/spawned = SP.spawn_contents(A)
		for(var/atom/content in spawned)
			slip.info += "<li>[content.name]</li>" //add the item to the manifest
		slip.info += "</ul><br>"
		slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
		if(SP.contraband)
			slip.loc = null	//we are out of blanks for Form #44-D Ordering Illicit Drugs.

	shoppinglist.Cut()
	return

// Supply manifest
/obj/item/weapon/paper/manifest
	name = "Supply Manifest"