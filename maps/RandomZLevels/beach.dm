// Beach
/area/awaymission/beach
	name = "Beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = FALSE
	var/sound/mysound = null

/area/awaymission/beach/New()
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

/area/awaymission/beach/Entered(atom/movable/Obj, atom/OldLoc)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_UPDATE
			Obj << mysound
	return

/area/awaymission/beach/Exited(atom/movable/Obj)
	if(ismob(Obj))
		if(Obj:client)
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			Obj << mysound

/area/awaymission/beach/proc/process()
	set background = 1

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