/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual teleport routine at the start of the game.*/
GLOBAL_GLOBL_LIST_NEW(teleportlocs)
GLOBAL_GLOBL_LIST_NEW(ghostteleportlocs)

/hook/startup/proc/setup_teleport_locs()
	. = TRUE
	for_no_type_check(var/area/a, GLOBL.area_list)
		if(istype(a, /area/shuttle) || istype(a, /area/enemy/wizard_station))
			continue
		if(GLOBL.teleportlocs.Find(a.name))
			continue
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isstationlevel(picked.z))
			GLOBL.teleportlocs.Add(a.name)
			GLOBL.teleportlocs[a.name] = a
	GLOBL.teleportlocs = sortAssoc(GLOBL.teleportlocs)

/hook/startup/proc/setup_ghost_teleport_locs()
	. = TRUE
	for_no_type_check(var/area/a, GLOBL.area_list)
		if(GLOBL.ghostteleportlocs.Find(a.name))
			continue
		if(/*istype(a, /area/turret_protected/aisat) ||*/ istype(a, /area/external/abandoned/derelict) || istype(a, /area/centcom/tdome))
			GLOBL.ghostteleportlocs.Add(a.name)
			GLOBL.ghostteleportlocs[a.name] = a
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isplayerlevel(picked.z))
			GLOBL.ghostteleportlocs.Add(a.name)
			GLOBL.ghostteleportlocs[a.name] = a
	GLOBL.ghostteleportlocs = sortAssoc(GLOBL.ghostteleportlocs)