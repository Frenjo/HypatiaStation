// Ported 'shuttles' module from Heaven's Gate - NSS Eternal, 24/11/2019...
// (THIS FILE IS TWEAKED A LOT RATHER THAN ACTUALLY PORTED DIRECTLY, BUT IS STILL LIKE 85 - 95% PORTED)
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.
#define SUPPLY_STATION_AREATYPE "/area/supply/station" //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/supply/dock"	//Type of the supply shuttle area for dock

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
	//luminosity = 1
	//lighting_use_dynamic = 0
	requires_power = 0

/area/supply/dock
	name = "supply shuttle"
	icon_state = "shuttle3"
	//luminosity = 1
	//lighting_use_dynamic = 0
	requires_power = 0

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

// PLASTIC FLAPS AND SUPPLY COMPUTERS MOVED TO /code/game/machinery/computer/supply.dm -Frenjo

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
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
	var/list/supply_packs = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/ferry/supply/shuttle

	New()
		ordernum = rand(1, 9000)

	//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcomm and the station
	proc/process()
		for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs))
			var/datum/supply_packs/P = new typepath()
			supply_packs[P.name] = P

		spawn(0)
			set background = 1
			while(1)
				if(processing)
					iteration++
					points += points_per_process

				sleep(processing_interval)

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
	proc/forbidden_atoms_check(atom/A)
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
	proc/sell()
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
	proc/buy()
		if(!shoppinglist.len)
			return

		var/area/area_shuttle = shuttle.get_location_area()
		if(!area_shuttle)
			return

		var/list/clear_turfs = list()

		for(var/turf/T in area_shuttle)
			if(T.density || T.contents.len)
				continue
			clear_turfs += T

		for(var/S in shoppinglist)
			if(!clear_turfs.len)
				break
			var/i = rand(1, clear_turfs.len)
			var/turf/pickedloc = clear_turfs[i]
			clear_turfs.Cut(i, i + 1)

			var/datum/supply_order/SO = S
			var/datum/supply_packs/SP = SO.object

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

			var/list/contains
			if(istype(SP, /datum/supply_packs/randomised))
				var/datum/supply_packs/randomised/SPR = SP
				contains = list()
				if(SPR.contains.len)
					for(var/j = 1, j <= SPR.num_contained, j++)
						contains += pick(SPR.contains)
			else
				contains = SP.contains

			for(var/typepath in contains)
				if(!typepath)
					continue
				var/atom/B2 = new typepath(A)
				if(SP.amount && B2:amount)
					B2:amount = SP.amount
				slip.info += "<li>[B2.name]</li>" //add the item to the manifest

			//manifest finalisation
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
			if(SP.contraband)
				slip.loc = null	//we are out of blanks for Form #44-D Ordering Illicit Drugs.

		shoppinglist.Cut()
		return