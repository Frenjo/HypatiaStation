/obj/effect/blob/core
	name = "blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_core"
	health = 200
	brute_resist = 2
	fire_resist = 2

/obj/effect/blob/core/New(loc, h = 200)
	GLOBL.blobs.Add(src)
	GLOBL.blob_cores.Add(src)
	GLOBL.processing_objects.Add(src)
	. = ..(loc, h)

/obj/effect/blob/core/Destroy()
	GLOBL.blob_cores.Remove(src)
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/effect/blob/core/update_icon()
	if(health <= 0)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
		return
	return

/obj/effect/blob/core/run_action()
	Pulse(0, 1)
	Pulse(0, 2)
	Pulse(0, 4)
	Pulse(0, 8)
	//Should have the fragments in here somewhere
	return 1

/obj/effect/blob/core/proc/create_fragments(wave_size = 1)
	var/list/candidates = list()
	for(var/mob/dead/observer/G in GLOBL.player_list)
		if(G.client.prefs.be_special & BE_ALIEN)
			if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
				candidates += G.key

	if(length(candidates))
		for(var/i = 0 to wave_size)
			var/mob/living/blob/B = new/mob/living/blob(src.loc)
			B.key = pick(candidates)
			candidates -= B.key

/*
/obj/effect/blob/core/Pulse(pulse = 0, origin_dir = 0)//Todo: Fix spaceblob expand
	set background = BACKGROUND_ENABLED
	if(pulse > 20)	return
	//Looking for another blob to pulse
	var/list/dirs = list(1,2,4,8)
	dirs.Remove(origin_dir)//Dont pulse the guy who pulsed us
	for(var/i = 1 to 4)
		if(!length(dirs))
			break
		var/dirn = pick(dirs)
		dirs.Remove(dirn)
		var/turf/T = get_step(src, dirn)
		var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
		if(!B)
			expand(T)//No blob here so try and expand
			return
		B.Pulse((pulse+1),get_dir(src.loc,T))
		return
	return
*/