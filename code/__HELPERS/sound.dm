GLOBAL_GLOBL_LIST_INIT(shatter_sound, list('sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg', 'sound/effects/Glassbr3.ogg'))
GLOBAL_GLOBL_LIST_INIT(explosion_sound, list('sound/effects/Explosion1.ogg', 'sound/effects/Explosion2.ogg'))
GLOBAL_GLOBL_LIST_INIT(spark_sound, list('sound/effects/sparks1.ogg', 'sound/effects/sparks2.ogg', 'sound/effects/sparks3.ogg', 'sound/effects/sparks4.ogg'))
GLOBAL_GLOBL_LIST_INIT(rustle_sound, list(
	'sound/effects/rustle1.ogg', 'sound/effects/rustle2.ogg',
	'sound/effects/rustle3.ogg', 'sound/effects/rustle4.ogg',
	'sound/effects/rustle5.ogg'
))
GLOBAL_GLOBL_LIST_INIT(punch_sound, list('sound/weapons/melee/punch1.ogg', 'sound/weapons/melee/punch2.ogg', 'sound/weapons/melee/punch3.ogg','sound/weapons/melee/punch4.ogg'))
GLOBAL_GLOBL_LIST_INIT(clown_sound, list('sound/effects/clownstep1.ogg', 'sound/effects/clownstep2.ogg'))
GLOBAL_GLOBL_LIST_INIT(swing_hit_sound, list('sound/weapons/melee/genhit1.ogg', 'sound/weapons/melee/genhit2.ogg', 'sound/weapons/melee/genhit3.ogg'))
GLOBAL_GLOBL_LIST_INIT(hiss_sound, list('sound/voice/hiss1.ogg', 'sound/voice/hiss2.ogg', 'sound/voice/hiss3.ogg', 'sound/voice/hiss4.ogg'))
GLOBAL_GLOBL_LIST_INIT(page_sound, list('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg', 'sound/effects/pageturn3.ogg'))
//GLOBAL_GLOBL_LIST_INIT(gun_sound, list('sound/weapons/gun/gunshot.ogg', 'sound/weapons/gun/gunshot2.ogg', 'sound/weapons/gun/gunshot3.ogg', 'sound/weapons/gun/gunshot4.ogg'))

/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global)
	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/frequency = get_rand_frequency() // Same frequency for everybody
	var/turf/turf_source = GET_TURF(source)

 	// Looping through the player list has the added bonus of working for mobs inside containers
	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(isnull(M?.client))
			continue

		var/distance = get_dist(M, turf_source)
		if(distance <= (world.view + extrarange) * 3)
			var/turf/T = GET_TURF(M)

			if(T?.z == turf_source.z)
				//check that the air can transmit sound
				var/datum/gas_mixture/environment = T.return_air()
				if(environment?.return_pressure() < SOUND_MINIMUM_PRESSURE)
					if(distance > 1)
						continue

					var/new_frequency = 32000 + (frequency - 32000) * 0.125	//lower the frequency. very rudimentary
					var/new_volume = vol * 0.15								//muffle the sound, like we're hearing through contact
					M.playsound_local(turf_source, soundin, new_volume, vary, new_frequency, falloff)
				else
					M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff)

var/const/FALLOFF_SOUNDS = 2
var/const/SURROUND_CAP = 255

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff)
	if(isnull(client))
		return

	soundin = get_sfx(soundin)

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol
	S.environment = 2

	if(vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		// 3D sounds, the technology is here!
		var/turf/T = GET_TURF(src)
		S.volume -= get_dist(T, turf_source) * 0.5
		if(S.volume < 0)
			S.volume = 0

		var/dx = turf_source.x - T.x // Hearing from the right/left

		S.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)

		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)

		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	src << S

/mob/living/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff)
	if(ear_deaf > 0)
		return
	. = ..()

/client/proc/playtitlemusic()
	if(isnull(global.PCticker?.lobby_music) || !(prefs.toggles & SOUND_LOBBY))
		return
	global.PCticker.lobby_music.play(src) // MAD JAMS

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if("shatter")
				soundin = pick(GLOBL.shatter_sound)
			if("explosion")
				soundin = pick(GLOBL.explosion_sound)
			if("sparks")
				soundin = pick(GLOBL.spark_sound)
			if("rustle")
				soundin = pick(GLOBL.rustle_sound)
			if("punch")
				soundin = pick(GLOBL.punch_sound)
			if("clownstep")
				soundin = pick(GLOBL.clown_sound)
			if("swing_hit")
				soundin = pick(GLOBL.swing_hit_sound)
			if("hiss")
				soundin = pick(GLOBL.hiss_sound)
			if("pageturn")
				soundin = pick(GLOBL.page_sound)
			//if ("gunshot") soundin = pick(gun_sound)
	return soundin