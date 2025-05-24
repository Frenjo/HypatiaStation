GLOBAL_BYOND_NEW(mob/dview/dview_mob)

// Version of view() which ignores darkness, because BYOND doesn't have it.
/proc/dview(range = world.view, centre, invis_flags = 0)
	if(!centre)
		return

	dview_mob.forceMove(centre)

	dview_mob.see_invisible = invis_flags

	. = view(range, dview_mob)
	dview_mob.forceMove(null)

/mob/dview
	invisibility = INVISIBILITY_MAXIMUM
	density = FALSE
	anchored = TRUE

	see_in_dark = 1e6

	atom_flags = ATOM_FLAG_UNSIMULATED

/mob/dview/New()
	SHOULD_CALL_PARENT(FALSE)
	return // do nothing. we don't want to be in any mob lists; we're a dummy not a mob.