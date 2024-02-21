/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/stool/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/structures/beds.dmi'
	icon_state = "bed"
	var/mob/living/buckled_mob

/obj/structure/stool/bed/psych
	name = "psych bed"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"

/obj/structure/stool/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon_state = "abed"

/obj/structure/stool/bed/Destroy()
	unbuckle()
	return ..()

/obj/structure/stool/bed/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/stool/bed/attack_hand(mob/user as mob)
	manual_unbuckle(user)
	return

/obj/structure/stool/bed/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

/obj/structure/stool/bed/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
	return

/obj/structure/stool/bed/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(
					SPAN_INFO("[buckled_mob.name] was unbuckled by [user.name]!"),
					"You were unbuckled from [src] by [user.name].",
					"You hear metal clanking."
				)
			else
				buckled_mob.visible_message(
					SPAN_INFO("[buckled_mob.name] unbuckled \himself!"),
					"You unbuckle yourself from [src].",
					"You hear metal clanking."
				)
			unbuckle()
			src.add_fingerprint(user)
	return

/obj/structure/stool/bed/proc/buckle_mob(mob/M as mob, mob/user as mob)
	if(!global.PCticker)
		to_chat(user, "You can't buckle anyone in before the game starts.")
	if(!ismob(M) || !in_range(src, user) || M.loc != src.loc || user.restrained() || user.lying || user.stat || M.buckled || ispAI(user))
		return

	if(isslime(M))
		to_chat(user, "The [M] is too squishy to buckle in.")
		return

	unbuckle()

	if(M == usr)
		M.visible_message(
			SPAN_INFO("[M.name] buckles in!"),
			"You buckle yourself to [src].",
			"You hear metal clanking."
		)
	else
		M.visible_message(
			SPAN_INFO("[M.name] is buckled in to [src] by [user.name]!"),
			"You are buckled in to [src] by [user.name].",
			"You hear metal clanking."
		)
	M.buckled = src
	M.loc = src.loc
	M.set_dir(src.dir)
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/*
 * Roller beds
 */
/obj/structure/stool/bed/roller
	name = "roller bed"
	icon_state = "roller_down"
	anchored = FALSE

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/structures/beds.dmi'
	icon_state = "roller_folded"
	w_class = 4.0 // Can't be put in backpacks. Oh well.

/obj/item/roller/attack_self(mob/user)
	var/obj/structure/stool/bed/roller/R = new /obj/structure/stool/bed/roller(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/stool/bed/roller/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = src.loc
		else
			buckled_mob = null

/obj/structure/stool/bed/roller/buckle_mob(mob/M as mob, mob/user as mob)
	if(!ismob(M) || !in_range(src, user) || M.loc != src.loc || user.restrained() || user.lying || user.stat || M.buckled || ispAI(user))
		return
	M.pixel_y = 6
	density = TRUE
	icon_state = "roller_up"
	..()
	return

/obj/structure/stool/bed/roller/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.pixel_y = 0
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.buckled = null
			buckled_mob.update_canmove()
			buckled_mob = null
	density = FALSE
	icon_state = "roller_down"
	..()
	return

/obj/structure/stool/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		if(buckled_mob)
			return 0
		visible_message("[usr] collapses \the [src.name].")
		new/obj/item/roller(get_turf(src))
		spawn(0)
			qdel(src)
		return