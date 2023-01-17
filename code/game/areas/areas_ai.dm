// AI Monitored
/area/ai_monitored
	name = "AI Monitored Area"

	var/obj/machinery/camera/motioncamera = null

/area/ai_monitored/initialize()
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

//AI
/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected
	name = "Turret Protected Area"
	icon_state = "ai"

/area/turret_protected/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = list(
		'sound/ambience/ambimalf.ogg'
	)

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list(
		'sound/ambience/ambimalf.ogg'
	)

/area/turret_protected/ai
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"
	ambience = list(
		'sound/ambience/ambimalf.ogg'
	)

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

/area/turret_protected/NewAIMain
	name = "\improper AI Main New"
	icon_state = "storage"