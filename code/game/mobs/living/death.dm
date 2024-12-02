/mob/living/death(gibbed, deathmessage = "seizes up and falls limp...")
	dizziness = 0
	jitteriness = 0
	. = ..()

// This is the proc for gibbing a mob.
// added different sort of gibs and animations. N
/mob/living/proc/gib(anim = "gibbed-m", do_gibs)
	death(TRUE)
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	update_canmove()

	var/atom/movable/overlay/animation = new /atom/movable/overlay(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	if(do_gibs)
		gibs(loc, viruses, dna)

	GLOBL.dead_mob_list.Remove(src)
	spawn(15)
		if(animation)
			qdel(animation)
		if(src)
			qdel(src)

// This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
// Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
// Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/living/proc/dust(anim = "dust-m", remains = /obj/effect/decal/cleanable/ash)
	death(TRUE)
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/atom/movable/overlay/animation = new /atom/movable/overlay(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	new remains(loc)

	GLOBL.dead_mob_list.Remove(src)
	spawn(15)
		if(animation)
			qdel(animation)
		if(src)
			qdel(src)