// Core areas that are required by basically everything.
// Space
/area/space
	name = "Space"
	icon_state = "dark128"
	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = TRUE
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

/area/space/power_alert()
	return

/area/space/atmos_alert()
	return

/area/space/fire_alert()
	return

/area/space/evac_alert()
	return

/area/space/party_alert()
	return

/area/space/destruct_alert()
	return

// Away Missions
/area/away_mission
	name = "\improper Strange Location"
	icon_state = "away"

// Beach
/area/special/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = FALSE
	requires_power = FALSE

	var/sound/mysound = null

/area/special/beach/New()
	. = ..()
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

/area/special/beach/Entered(atom/movable/Obj, atom/OldLoc)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_UPDATE
			Obj << mysound
	return

/area/special/beach/Exited(atom/movable/Obj)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			Obj << mysound

/area/special/beach/proc/process()
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
	/area/shuttle/transport/centcom,
	/area/shuttle/administration/centcom,
	/area/shuttle/specops/centcom,
))

// Preserved in case these ever get used later. -Frenjo
///area/airtunnel1		// referenced in airtunnel.dm:759
///area/dummy			// Referenced in engine.dm:261
//STATION13