/*
 * Alt click
 * Used for some AI things.
 * Used to toggle firing modes of energy weapons and emitters.
*/
/mob/proc/AltClickOn(atom/A)
	A.AltClick(src)
	return

/atom/proc/AltClick(mob/user)
	var/turf/T = GET_TURF(src)
	if(T?.Adjacent(user))
		if(user.listed_turf == T)
			user.listed_turf = null
		else
			user.listed_turf = T
			user.client.statpanel = T.name