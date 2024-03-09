/obj/effect/decal/point
	name = "arrow"
	desc = "It's an arrow hanging in mid-air. There may be a wizard about."
	icon = 'icons/mob/screen/screen1.dmi'
	icon_state = "arrow"
	plane = UNLIT_EFFECTS_PLANE
	anchored = TRUE

// Used for spray that you spray at walls, tables, hydrovats etc
/obj/effect/decal/spraystill
	density = FALSE
	anchored = TRUE
	layer = 50

//Used by spraybottles.
/obj/effect/decal/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE