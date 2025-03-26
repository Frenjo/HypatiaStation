/*
 * This is the verb mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
 */
/mob/living/verb/ghost()
	set category = PANEL_OOC
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat == DEAD)
		ghostize(1)
	else
		var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to play this round for another 30 minutes! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		if(response != "Ghost")
			return	//didn't want to ghost after-all
		resting = TRUE
		var/mob/dead/ghost/ghost = ghostize(0)	//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		ghost.timeofdeath = world.time	// Because the living mob won't have a time of death and we want the respawn timer to work properly.

/mob/living/verb/cancel_camera()
	set category = PANEL_OOC
	set name = "Cancel Camera View"

	reset_view(null)
	unset_machine()
	if(src:cameraFollow)
		src:cameraFollow = null