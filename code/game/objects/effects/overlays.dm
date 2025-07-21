/obj/effect/overlay
	name = "overlay"

	var/i_attached //Added for possible image attachments to objects. For hallucinations and the like.


/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name = "beam"
	icon = 'icons/effects/beam.dmi'
	icon_state = "b_beam"

	var/tmp/atom/BeamSource

/obj/effect/overlay/beam/initialise()
	. = ..()
	spawn(1 SECOND)
		qdel(src)


/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	layer = 5
	anchored = TRUE


/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	layer = 5
	anchored = TRUE


/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"