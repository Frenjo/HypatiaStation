/turf/open/floor/reinforced/attack_paw(mob/user)
	return src.attack_hand(user)

/turf/open/floor/reinforced/attack_hand(mob/user)
	if(!user.canmove || user.restrained() || !user.pulling)
		return
	if(user.pulling.anchored)
		return
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/open/floor/reinforced/ex_act(severity)
	switch(severity)
		if(1.0)
			ChangeTurf(/turf/space)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				ChangeTurf(/turf/space)
				qdel(src)
				return
		else
	return

/turf/open/floor/reinforced/blob_act()
	if(prob(25))
		ChangeTurf(/turf/space)
		qdel(src)
		return
	return