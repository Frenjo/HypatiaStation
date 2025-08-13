// Beach
/area/away_mission/beach
	name = "Beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = FALSE
	var/sound/mysound = null

/area/away_mission/beach/New()
	..()
	var/sound/S = new/sound()
	mysound = S
	S.file = 'sound/ambience/beach/shore.ogg'
	S.repeat = 1
	S.wait = 0
	S.channel = 123
	S.volume = 100
	S.priority = 255
	S.status = SOUND_UPDATE
	process()

/area/away_mission/beach/Entered(atom/movable/Obj, atom/OldLoc)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_UPDATE
			SOUND_TO(Obj, mysound)
	return

/area/away_mission/beach/Exited(atom/movable/Obj)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			SOUND_TO(Obj, mysound)

/area/away_mission/beach/proc/process()
	set background = BACKGROUND_ENABLED

	var/sound/S = null
	var/sound_delay = 0
	if(prob(25))
		S = sound(file = pick('sound/ambience/beach/seag1.ogg', 'sound/ambience/beach/seag2.ogg', 'sound/ambience/beach/seag3.ogg'), volume = 100)
		sound_delay = rand(0, 50)

	for(var/mob/living/carbon/human/H in src)
//		if(H.s_tone > -55)	//ugh...nice/novel idea but please no.
//			H.s_tone--
//			H.update_body()
		if(H.client)
			mysound.status = SOUND_UPDATE
			SOUND_TO(H, mysound)
			if(S)
				spawn(sound_delay)
					SOUND_TO(H, S)
	spawn(60)
		.()