/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/mob/silicon/AI.dmi'//
	icon_state = "ai"
	anchored = TRUE // -- TLE
	canmove = FALSE

/mob/living/silicon/decoy/New()
	SHOULD_CALL_PARENT(FALSE)
	return