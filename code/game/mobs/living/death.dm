/mob/living/proc/death(gibbed, deathmessage = "seizes up and falls limp...")
	if(stat == DEAD)
		return 0

	if(!gibbed)
		visible_message("<b>\The [name]</b> [deathmessage]")

	stat = DEAD
	dizziness = 0
	jitteriness = 0

	update_canmove()

	layer = MOB_LAYER

	if(blind && client)
		blind.layer = 0

	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	drop_r_hand()
	drop_l_hand()

	if(healths)
		healths.icon_state = "health6"

	timeofdeath = world.time
	if(mind)
		mind.store_memory("Time of death: [worldtime2text()]", 0)
	GLOBL.living_mob_list.Remove(src)

	GLOBL.dead_mob_list |= src

	updateicon()

	global.PCticker?.mode?.check_win()

	return 1

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