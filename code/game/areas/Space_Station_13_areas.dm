// Core areas that are required by basically everything.
// Space
/area/space
	name = "Space"
	icon_state = "dark128"
	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list(
		'sound/ambience/ambispace.ogg',
		'sound/music/title2.ogg',
		'sound/music/space.ogg',
		'sound/music/main.ogg',
		'sound/music/traitor.ogg'
	)

/area/space/updateicon()
	return

/area/space/poweralert()
	return

/area/space/atmosalert()
	return

/area/space/firealert()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return

/area/space/destructalert()
	return

/area/arrival
	requires_power = FALSE

/area/arrival/start
	name = "\improper Arrival Area"
	icon_state = "start"

/area/admin
	name = "\improper Admin room"
	icon_state = "start"
	dynamic_lighting = 0

// Away Missions
/area/awaymission
	name = "\improper Strange Location"
	icon_state = "away"

// Beach
/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = FALSE
	var/sound/mysound = null

/area/beach/New()
	..()
	var/sound/S = new/sound()
	mysound = S
	S.file = 'sound/ambience/shore.ogg'
	S.repeat = 1
	S.wait = 0
	S.channel = 123
	S.volume = 100
	S.priority = 255
	S.status = SOUND_UPDATE
	process()

/area/beach/Entered(atom/movable/Obj, atom/OldLoc)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_UPDATE
			Obj << mysound
	return

/area/beach/Exited(atom/movable/Obj)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			Obj << mysound

/area/beach/proc/process()
	set background = BACKGROUND_ENABLED

	var/sound/S = null
	var/sound_delay = 0
	if(prob(25))
		S = sound(file = pick('sound/ambience/seag1.ogg', 'sound/ambience/seag2.ogg', 'sound/ambience/seag3.ogg'), volume = 100)
		sound_delay = rand(0, 50)

	for(var/mob/living/carbon/human/H in src)
//		if(H.s_tone > -55)	//ugh...nice/novel idea but please no.
//			H.s_tone--
//			H.update_body()
		if(H.client)
			mysound.status = SOUND_UPDATE
			H << mysound
			if(S)
				spawn(sound_delay)
					H << S
	spawn(60)
		.()

/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
GLOBAL_GLOBL_LIST_INIT(centcom_areas, list(
	/area/centcom,
	/area/shuttle/escape/centcom,
	/area/shuttle/escape_pod1/centcom,
	/area/shuttle/escape_pod2/centcom,
	/area/shuttle/escape_pod3/centcom,
	/area/shuttle/escape_pod5/centcom,
	/area/shuttle/transport1/centcom,
	/area/shuttle/administration/centcom,
	/area/shuttle/specops/centcom,
))

//SPACE STATION 13
GLOBAL_GLOBL_LIST_INIT(the_station_areas, list(
	/area/shuttle/arrival,
	/area/shuttle/escape/station,
	/area/shuttle/escape_pod1/station,
	/area/shuttle/escape_pod2/station,
	/area/shuttle/escape_pod3/station,
	/area/shuttle/escape_pod5/station,
	/area/shuttle/mining/station,
	/area/shuttle/transport1/station,
//	/area/shuttle/transport2/station,
	/area/shuttle/prison/station,
	/area/shuttle/administration/station,
	/area/shuttle/specops/station,
	/area/atmos,
	/area/maintenance,
	/area/hallway,
	/area/bridge,
	/area/crew_quarters,
	/area/holodeck,
	/area/mint,
	/area/library,
	/area/chapel,
	/area/lawoffice,
	/area/engine,
	/area/solar,
	/area/assembly,
	/area/teleporter,
	/area/medical,
	/area/security,
	/area/quartermaster,
	/area/janitor,
	/area/hydroponics,
	/area/toxins,
	/area/storage,
	/area/construction,
	/area/ai_monitored/storage/eva, //do not try to simplify to "/area/ai_monitored" --rastaf0
	/area/ai_monitored/storage/secure,
	/area/ai_monitored/storage/emergency,
	/area/turret_protected/ai_upload, //do not try to simplify to "/area/turret_protected" --rastaf0
	/area/turret_protected/ai_upload_foyer,
	/area/turret_protected/ai,
))

// Preserved in case these ever get used later. -Frenjo
/area/airtunnel1		// referenced in airtunnel.dm:759
/area/dummy				// Referenced in engine.dm:261
//STATION13