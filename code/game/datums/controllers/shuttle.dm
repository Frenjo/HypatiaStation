// Ported 'shuttles' module from Heaven's Gate - NSS Eternal, 22/11/2019...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

/*
 * Shuttle Controller
 */
CONTROLLER_DEF(shuttle)
	name = "Shuttle"

	var/list/shuttles	//maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles	//simple list of shuttles, for processing

/datum/controller/shuttle/New()
	. = ..()
	shuttles = list()
	process_shuttles = list()

	var/datum/shuttle/ferry/shuttle

	// Arrivals shuttle
	shuttle = new /datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/arrival/station)
	shuttle.area_offsite = locate(/area/shuttle/arrival/centcom)
	shuttle.area_transition = locate(/area/shuttle/arrival/transit)
	shuttle.docking_controller_tag = "arrival_shuttle"
	shuttle.dock_target_station = "arrivalshuttle_dock"
	shuttle.dock_target_offsite = "arrivalshuttle_centcomdock"
	shuttle.transit_direction = WEST
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-15, 15) // Since it ends up docking ass-backwards, this gives it a bit of "manoeuvring time".
	shuttles["Arrival"] = shuttle
	process_shuttles.Add(shuttle)

	// Escape shuttle and pods
	shuttle = new /datum/shuttle/ferry/emergency()
	shuttle.location = 1
	shuttle.warmup_time = 7 // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/escape/centcom)
	shuttle.area_station = locate(/area/shuttle/escape/station)
	shuttle.area_transition = locate(/area/shuttle/escape/transit)
	shuttle.docking_controller_tag = "escape_shuttle"
	shuttle.dock_target_station = "escapeshuttle_dock"
	shuttle.dock_target_offsite = "escapeshuttle_centcomdock"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	shuttles["Escape"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod1/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod1/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod1/transit)
	shuttle.docking_controller_tag = "escape_pod_1"
	shuttle.dock_target_station = "escape_pod_1_berth"
	shuttle.dock_target_offsite = "escape_pod_1_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 1"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod2/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod2/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod2/transit)
	shuttle.docking_controller_tag = "escape_pod_2"
	shuttle.dock_target_station = "escape_pod_2_berth"
	shuttle.dock_target_offsite = "escape_pod_2_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 2"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod3/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod3/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod3/transit)
	shuttle.docking_controller_tag = "escape_pod_3"
	shuttle.dock_target_station = "escape_pod_3_berth"
	shuttle.dock_target_offsite = "escape_pod_3_recovery"
	shuttle.transit_direction = EAST
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 3"] = shuttle
	process_shuttles.Add(shuttle)

	//There is no pod 4, apparently.

	shuttle = new /datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod5/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod5/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod5/transit)
	shuttle.docking_controller_tag = "escape_pod_5"
	shuttle.dock_target_station = "escape_pod_5_berth"
	shuttle.dock_target_offsite = "escape_pod_5_recovery"
	shuttle.transit_direction = EAST //should this be WEST? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	shuttles["Escape Pod 5"] = shuttle
	process_shuttles.Add(shuttle)

	//give the emergency shuttle controller it's shuttles
	global.CTemergency.shuttle = shuttles["Escape"]
	global.CTemergency.escape_pods = list(
		shuttles["Escape Pod 1"],
		shuttles["Escape Pod 2"],
		shuttles["Escape Pod 3"],
		shuttles["Escape Pod 5"],
		shuttles["Arrival"], // This is really hacky but okay.
	)

	// Supply shuttle
	shuttle = new /datum/shuttle/ferry/supply()
	shuttle.location = 1
	shuttle.warmup_time = 7 // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/supply/centcom)
	shuttle.area_station = locate(/area/shuttle/supply/station)
	shuttle.docking_controller_tag = "supply_shuttle"
	shuttle.dock_target_station = "cargo_bay"
	shuttles["Supply"] = shuttle
	process_shuttles.Add(shuttle)

	// Admin shuttles.
	shuttle = new /datum/shuttle/ferry()
	shuttle.location = 1
	shuttle.warmup_time = 7 // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/transport1/centcom)
	shuttle.area_station = locate(/area/shuttle/transport1/station)
	shuttle.docking_controller_tag = "centcom_shuttle"
	shuttle.dock_target_station = "centcomshuttle_dock_airlock"
	shuttle.dock_target_offsite = "centcomshuttle_bay"
	shuttles["CentCom"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry()
	shuttle.location = 1
	shuttle.warmup_time = 7 //want some warmup time so people can cancel. // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/administration/centcom)
	shuttle.area_station = locate(/area/shuttle/administration/station)
	shuttle.docking_controller_tag = "admin_shuttle"
	shuttle.dock_target_station = "adminshuttle_dock_airlock"
	shuttle.dock_target_offsite = "adminshuttle_bay_airlock"
	shuttles["Administration"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry()
	shuttle.area_offsite = locate(/area/shuttle/alien/base)
	shuttle.area_station = locate(/area/shuttle/alien/mine)
	shuttles["Alien"] = shuttle
	process_shuttles.Add(shuttle)

	// Public shuttles

	// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
	shuttle = new /datum/shuttle/ferry()
	shuttle.location = 0
	shuttle.warmup_time = 7 //want some warmup time so people can cancel. // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/engineering/outpost)
	shuttle.area_station = locate(/area/shuttle/engineering/station)
	shuttle.docking_controller_tag = "engineering_shuttle"
	shuttle.dock_target_station = "engineeringshuttle_dock_airlock"
	shuttle.dock_target_offsite = "engineeringshuttle_outpost_airlock"
	shuttles["Engineering"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry()
	shuttle.warmup_time = 7 // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/mining/outpost)
	shuttle.area_station = locate(/area/shuttle/mining/station)
	shuttle.docking_controller_tag = "mining_shuttle"
	shuttle.dock_target_station = "miningshuttle_dock_airlock"
	shuttle.dock_target_offsite = "miningshuttle_outpost_airlock"
	shuttles["Mining"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry()
	shuttle.warmup_time = 7 // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/research/outpost)
	shuttle.area_station = locate(/area/shuttle/research/station)
	shuttle.docking_controller_tag = "research_shuttle"
	shuttle.dock_target_station = "researchshuttle_dock_airlock"
	shuttle.dock_target_offsite = "researchshuttle_dock_outpost"
	shuttles["Research"] = shuttle
	process_shuttles.Add(shuttle)

	shuttle = new /datum/shuttle/ferry()
	shuttle.warmup_time = 7 // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	shuttle.area_offsite = locate(/area/shuttle/prison/prison)
	shuttle.area_station = locate(/area/shuttle/prison/station)
	shuttle.docking_controller_tag = "prison_shuttle"
	shuttle.dock_target_station = "prisonshuttle_dock_airlock"
	shuttle.dock_target_offsite = "prisonshuttle_sat_airlock"
	shuttles["Prison"] = shuttle
	process_shuttles.Add(shuttle)

	// ERT Shuttle
	var/datum/shuttle/ferry/multidock/specops/ert = new /datum/shuttle/ferry/multidock/specops()
	ert.location = 0
	ert.warmup_time = 7 // Edited the warmup as 10 seconds seems a bit long. -Frenjo
	ert.area_offsite = locate(/area/shuttle/specops/station)	//centcom is the home station, the Exodus is offsite
	ert.area_station = locate(/area/shuttle/specops/centcom)
	ert.docking_controller_tag = "specopsshuttle_port"
	ert.docking_controller_tag_station = "specopsshuttle_port"
	ert.docking_controller_tag_offsite = "specopsshuttle_fore"
	ert.dock_target_station = "specopsshuttle_dock_centcom"
	ert.dock_target_offsite = "specopsshuttle_dock_airlock"
	shuttles["Special Operations"] = ert
	process_shuttles.Add(ert)

	//Vox Shuttle.
	var/datum/shuttle/multi_shuttle/vox_shuttle = new /datum/shuttle/multi_shuttle()
	vox_shuttle.origin = locate(/area/shuttle/vox/station)

	vox_shuttle.destinations = list(
		"Fore Starboard Solars" = locate(/area/vox_station/northeast_solars),
		"Fore Port Solars" = locate(/area/vox_station/northwest_solars),
		"Aft Starboard Solars" = locate(/area/vox_station/southeast_solars),
		"Aft Port Solars" = locate(/area/vox_station/southwest_solars),
		"Mining asteroid" = locate(/area/vox_station/mining)
	)

	vox_shuttle.announcer = "NSV Icarus"
	vox_shuttle.arrival_message = "Attention [GLOBL.current_map.station_name], we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	vox_shuttle.departure_message = "Your guests are pulling away, [GLOBL.current_map.station_name] - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	vox_shuttle.interim = locate(/area/vox_station/transit)

	vox_shuttle.warmup_time = 0
	shuttles["Vox Skipjack"] = vox_shuttle

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/mercenary_shuttle = new /datum/shuttle/multi_shuttle()
	mercenary_shuttle.origin = locate(/area/syndicate_station/start)

	mercenary_shuttle.destinations = list(
		"Northwest of the station" = locate(/area/syndicate_station/northwest),
		"North of the station" = locate(/area/syndicate_station/north),
		"Northeast of the station" = locate(/area/syndicate_station/northeast),
		"Southwest of the station" = locate(/area/syndicate_station/southwest),
		"South of the station" = locate(/area/syndicate_station/south),
		"Southeast of the station" = locate(/area/syndicate_station/southeast),
		"Telecoms Satellite" = locate(/area/syndicate_station/commssat),
		"Mining Asteroid" = locate(/area/syndicate_station/mining),
		/*"Arrivals dock" = locate(/area/syndicate_station/arrivals_dock),*/
	)

	mercenary_shuttle.announcer = "NSV Icarus"
	mercenary_shuttle.arrival_message = "Attention, [GLOBL.current_map.station_name], you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	mercenary_shuttle.departure_message = "Your visitors are on their way out of the system, [GLOBL.current_map.station_name], burning delta-v like it's nothing. Good riddance."
	mercenary_shuttle.interim = locate(/area/syndicate_station/transit)

	mercenary_shuttle.warmup_time = 0
	shuttles["Mercenary"] = mercenary_shuttle

/datum/controller/shuttle/process()
	//process ferry shuttles
	for(var/datum/shuttle/ferry/shuttle in process_shuttles)
		if(shuttle.process_state)
			shuttle.process()

//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/controller/shuttle/proc/setup_shuttle_docks()
	var/datum/shuttle/shuttle
	var/datum/shuttle/ferry/multidock/multidock
	var/list/dock_controller_map = list()	//so we only have to iterate once through each list

	//multidock shuttles
	var/list/dock_controller_map_station = list()
	var/list/dock_controller_map_offsite = list()

	for(var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		if(!isnull(shuttle.docking_controller_tag))
			dock_controller_map[shuttle.docking_controller_tag] = shuttle
		if(istype(shuttle, /datum/shuttle/ferry/multidock))
			multidock = shuttle
			dock_controller_map_station[multidock.docking_controller_tag_station] = multidock
			dock_controller_map_offsite[multidock.docking_controller_tag_offsite] = multidock

	//escape pod arming controllers
	var/datum/shuttle/ferry/escape_pod/pod
	var/list/pod_controller_map = list()
	for(var/datum/shuttle/ferry/escape_pod/P in global.CTemergency.escape_pods)
		if(!isnull(P.dock_target_station))
			pod_controller_map[P.dock_target_station] = P

	//search for the controllers, if we have one.
	if(length(dock_controller_map))
		for(var/obj/machinery/embedded_controller/radio/C in GLOBL.machines)	//only radio controllers are supported at the moment
			if(istype(C.program, /datum/computer/file/embedded_program/docking))
				if(C.id_tag in dock_controller_map)
					shuttle = dock_controller_map[C.id_tag]
					shuttle.docking_controller = C.program
					dock_controller_map.Remove(C.id_tag)

					//escape pods
					if(istype(C, /obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod) && istype(shuttle, /datum/shuttle/ferry/escape_pod))
						var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/EPC = C
						EPC.pod = shuttle

				if(C.id_tag in dock_controller_map_station)
					multidock = dock_controller_map_station[C.id_tag]
					if(istype(multidock))
						multidock.docking_controller_station = C.program
						dock_controller_map_station.Remove(C.id_tag)
				if(C.id_tag in dock_controller_map_offsite)
					multidock = dock_controller_map_offsite[C.id_tag]
					if(istype(multidock))
						multidock.docking_controller_offsite = C.program
						dock_controller_map_offsite.Remove(C.id_tag)

				//escape pods
				if(C.id_tag in pod_controller_map)
					pod = pod_controller_map[C.id_tag]
					if(istype(C.program, /datum/computer/file/embedded_program/docking/simple/escape_pod/))
						pod.arming_controller = C.program

	//sanity check
	if(length(dock_controller_map) || length(dock_controller_map_station) || length(dock_controller_map_offsite))
		var/dat = ""
		for(var/dock_tag in dock_controller_map + dock_controller_map_station + dock_controller_map_offsite)
			dat += "\"[dock_tag]\", "
		to_world(SPAN_DANGER("Warning: shuttles with docking tags [dat] could not find their controllers!"))

	//makes all shuttles docked to something at round start go into the docked state
	for(var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		shuttle.dock()
		CHECK_TICK