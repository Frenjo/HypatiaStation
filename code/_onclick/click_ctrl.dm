/*
 * Ctrl click
 * For most objects, pull
*/
/mob/proc/CtrlClickOn(atom/A)
	A.CtrlClick(src)
	return

/atom/proc/CtrlClick(mob/user)
	return

/atom/movable/CtrlClick(mob/user)
	if(Adjacent(user))
		user.start_pulling(src)