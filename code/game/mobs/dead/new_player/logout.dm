/mob/dead/new_player/Logout()
	ready = FALSE

	// see login.dm
	if(isnotnull(my_client))
		my_client.screen.Remove(GLOBL.splashscreen)
		my_client = null

	..()
	if(!spawning) //Here so that if they are spawning and log out, the other procs can play out and they will have a mob to come back to.
		key = null //We null their key before deleting the mob, so they are properly kicked out.
		qdel(src)