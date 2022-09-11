/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual teleport routine at the start of the game.*/
/var/global/list/teleportlocs = list()
/var/global/list/ghostteleportlocs = list()

/hook/startup/proc/setupTeleportLocs()
	for(var/area/a in world)
		if(istype(a, /area/shuttle) || istype(a, /area/syndicate_station) || istype(a, /area/wizard_station))
			continue
		if(global.teleportlocs.Find(a.name))
			continue
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isStationLevel(picked.z))
			global.teleportlocs += a.name
			global.teleportlocs[a.name] = a
	global.teleportlocs = sortAssoc(global.teleportlocs)
	return 1

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/a in world)
		if(global.ghostteleportlocs.Find(a.name))
			continue
		if(istype(a, /area/turret_protected/aisat) || istype(a, /area/derelict) || istype(a, /area/tdome))
			global.ghostteleportlocs += a.name
			global.ghostteleportlocs[a.name] = a
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isPlayerLevel(picked.z))
			global.ghostteleportlocs += a.name
			global.ghostteleportlocs[a.name] = a
	global.ghostteleportlocs = sortAssoc(global.ghostteleportlocs)
	return 1