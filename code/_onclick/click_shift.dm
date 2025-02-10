/*
 * Shift click
 * For most mobs, examine.
 * This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	if(user.client?.eye == user)
		examine(user)
		user.face_atom(src)
	return