/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "Some blob creature thingy"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	health = 60
	brute_resist = 1
	fire_resist = 2

/obj/effect/blob/shield/update_icon()
	if(health <= 0)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
		return
	return

/obj/effect/blob/shield/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(istype(mover) && mover.checkpass(PASSBLOB))
		return 1
	return 0