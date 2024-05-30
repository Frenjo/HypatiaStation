GLOBAL_BYOND_NEW(mob/dview/dview_mob)

// Version of view() which ignores darkness, because BYOND doesn't have it.
/proc/dview(range = world.view, center, invis_flags = 0)
	if(!center)
		return

	dview_mob.loc = center

	dview_mob.see_invisible = invis_flags

	. = view(range, dview_mob)
	dview_mob.loc = null

/mob/dview
	invisibility = INVISIBILITY_MAXIMUM
	density = FALSE

	anchored = TRUE
	simulated = FALSE

	see_in_dark = 1e6

/mob/dview/New()
	SHOULD_CALL_PARENT(FALSE)
	return // do nothing. we don't want to be in any mob lists; we're a dummy not a mob.