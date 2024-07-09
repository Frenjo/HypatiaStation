/*
 * AI Monitored & Turret Protected Areas
 *
 * I kept these together because they always were, also why not?
 */
// AI Monitored
/area/ai_monitored
	name = "AI Monitored Area"

	var/obj/machinery/camera/motioncamera = null

/area/ai_monitored/initialise()
	. = ..()
	// locate and store the motioncamera
	// spawn on a delay to let turfs/objs load
	for(var/obj/machinery/camera/M in src)
		if(M.isMotion())
			motioncamera = M
			M.area_motion = src
			return

/area/ai_monitored/Entered(atom/movable/O)
	. = ..()
	if(ismob(O) && motioncamera)
		motioncamera.newTarget(O)

/area/ai_monitored/Exited(atom/movable/O)
	if(ismob(O) && motioncamera)
		motioncamera.lostTarget(O)

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

// Turret Protected
/area/turret_protected
	name = "Turret Protected Area"
	icon_state = "ai"

/area/turret_protected/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = list(
		'sound/ambience/ambimalf.ogg'
	)
	area_flags = AREA_FLAG_IS_SURGE_PROTECTED

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list(
		'sound/ambience/ambimalf.ogg'
	)
	area_flags = AREA_FLAG_IS_SURGE_PROTECTED

/area/turret_protected/ai_chamber
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"
	ambience = list(
		'sound/ambience/ambimalf.ogg'
	)
	area_flags = AREA_FLAG_IS_SURGE_PROTECTED

// These two are just grouped here as they're right next to /area/turret_protected/ai_upload_foyer.
/area/turret_protected/cyborg_station
	name = "\improper Cyborg Station"
	icon_state = "tcomsatcham"

/area/turret_protected/messaging_server
	name = "\improper Messaging Server Room"
	icon_state = "server"

/*
// These are unused, but are kept because I may re-add the AI satellite later.
/area/turret_protected/aisat
	name = "\improper AI Satellite"

/area/turret_protected/aisat_interior
	name = "\improper AI Satellite"

/area/turret_protected/AIsatextFP
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = FALSE

/area/turret_protected/AIsatextFS
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = FALSE

/area/turret_protected/AIsatextAS
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = FALSE

/area/turret_protected/AIsatextAP
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = FALSE
*/