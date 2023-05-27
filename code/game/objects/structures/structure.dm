/obj/structure
	icon = 'icons/obj/structures/structures.dmi'
	var/climbable
	var/breakable
	var/parts

/obj/structure/New()
	. = ..()
	if(climbable)
		verbs += /obj/structure/proc/do_climb

/obj/structure/Destroy()
	if(parts)
		new parts(loc)
	return ..()

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
			visible_message(SPAN_DANGER("[user] smashes the [src] apart!"))
			qdel(src)
		else if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				visible_message(SPAN_DANGER("[H] slices [src] apart!"))
				qdel(src)

/obj/structure/attack_animal(mob/living/user)
	if(breakable)
		if(user.wall_smash)
			visible_message(SPAN_DANGER("[user] smashes [src] apart!"))
			qdel(src)

/obj/structure/attack_paw(mob/user)
	if(breakable)
		attack_hand(user)

/obj/structure/blob_act()
	if(prob(50))
		qdel(src)

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/meteorhit(obj/O as obj)
	qdel(src)

/obj/structure/proc/do_climb()
	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	if(!can_touch(usr) || !climbable)
		return

	usr.visible_message(SPAN_WARNING("[usr] starts climbing onto \the [src]!"))

	if(!do_after(usr, 50))
		return

	usr.loc = get_turf(src)
	if(get_turf(usr) == get_turf(src))
		usr.visible_message(SPAN_WARNING("[usr] climbs onto \the [src]!"))

/obj/structure/proc/structure_shaken()
	for(var/mob/living/M in get_turf(src))
		if(M.lying)
			return //No spamming this on people.

		M.Weaken(5)
		to_chat(M, SPAN_WARNING("You topple as \the [src] moves under you!"))

		if(prob(25))
			var/damage = rand(15, 30)
			var/mob/living/carbon/human/H = M
			if(!istype(M))
				to_chat(H, SPAN_WARNING("You land heavily!"))
				M.adjustBruteLoss(damage)
				return

			var/datum/organ/external/affecting

			switch(pick(list("ankle", "wrist", "head", "knee", "elbow")))
				if("ankle")
					affecting = H.get_organ(pick("l_foot", "r_foot"))
				if("knee")
					affecting = H.get_organ(pick("l_leg", "r_leg"))
				if("wrist")
					affecting = H.get_organ(pick("l_hand", "r_hand"))
				if("elbow")
					affecting = H.get_organ(pick("l_arm", "r_arm"))
				if("head")
					affecting = H.get_organ("head")

			if(affecting)
				to_chat(M, SPAN_WARNING("You land heavily on your [affecting.display_name]!"))
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, SPAN_WARNING("You land heavily!"))
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(mob/user)
	if(!user)
		return 0
	if(user.stat || user.restrained() || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if(issilicon(user))
		to_chat(user, SPAN_NOTICE("You need hands for this."))
		return 0
	return 1