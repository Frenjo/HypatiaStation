// Ported 'shuttles' module from Heaven's Gate - NSS Eternal, 24/11/2019...
// (THIS FILE IS TWEAKED A LOT RATHER THAN ACTUALLY PORTED DIRECTLY, BUT IS STILL LIKE 85 - 95% PORTED)
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

//Config stuff
#define SUPPLY_DOCKZ	2		//Z-level of the Dock.
#define SUPPLY_STATIONZ	1		//Z-level of the Station.
#define SUPPLY_STATION_AREATYPE	"/area/supply/station"	//Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE	"/area/supply/dock"		//Type of the supply shuttle area for dock

var/datum/controller/supply/supply_controller = new()

var/list/mechtoys = list(
	/obj/item/toy/prize/ripley,
	/obj/item/toy/prize/fireripley,
	/obj/item/toy/prize/deathripley,
	/obj/item/toy/prize/gygax,
	/obj/item/toy/prize/durand,
	/obj/item/toy/prize/honk,
	/obj/item/toy/prize/marauder,
	/obj/item/toy/prize/seraph,
	/obj/item/toy/prize/mauler,
	/obj/item/toy/prize/odysseus,
	/obj/item/toy/prize/phazon
)

/obj/item/weapon/paper/manifest
	name = "Supply Manifest"


/area/supply/station
	name = "supply shuttle"
	icon_state = "shuttle3"
	requires_power = 0

/area/supply/dock
	name = "supply shuttle"
	icon_state = "shuttle3"
	requires_power = 0

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

// PLASTIC FLAPS AND SUPPLY COMPUTERS MOVED TO /code/game/machinery/computer/supply.dm -Frenjo

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null


/datum/controller/supply
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
	ordernum = rand(1, 9000)

//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcomm and the station
/datum/controller/supply/proc/process()
	points += points_per_process

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/supply/proc/forbidden_atoms_check(atom/A)
	if(isliving(A))
		return 1
	if(istype(A, /obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A, /obj/machinery/nuclearbomb))
		return 1
	if(istype(A, /obj/item/device/radio/beacon))
		return 1

	for(var/i = 1, i <= A.contents.len, i++)
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
					if(slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
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
	if(!shoppinglist.len)
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
		clear_turfs += T

	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break
		var/i = rand(1, clear_turfs.len)
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
		slip.info +="Destination: [station_name]<br>"
		slip.info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
		slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			A:req_access = list()
			A:req_access += text2num(SP.access)

		var/list/spawned = SP.spawn_contents(A)
		for(var/atom/content in spawned)
			slip.info += "<li>[content.name]</li>" //add the item to the manifest
		slip.info += "</ul><br>"
		slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
		if(SP.contraband)
			slip.loc = null	//we are out of blanks for Form #44-D Ordering Illicit Drugs.

	shoppinglist.Cut()
	return

#undef SUPPLY_DOCKZ
#undef SUPPLY_STATIONZ
#undef SUPPLY_STATION_AREATYPE
#undef SUPPLY_DOCK_AREATYPE