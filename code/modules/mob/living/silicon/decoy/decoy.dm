/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = TRUE // -- TLE
	canmove = FALSE

/mob/living/silicon/decoy/New()
	src.icon = 'icons/mob/AI.dmi'
	src.icon_state = "ai"
	src.anchored = TRUE
	src.canmove = FALSE