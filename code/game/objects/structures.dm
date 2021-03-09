/obj/structure
	icon = 'icons/obj/structures.dmi'
	var/breakable
	var/parts

/obj/structure/proc/destroy()
	if(parts)
		new parts(loc)
	density = 0
	qdel(src)

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			visible_message("<span class='danger'>[user] smashes the [src] apart!</span>")
			destroy()
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				visible_message("<span class='danger'>[H] slices [src] apart!</span>")
				destroy()

/obj/structure/attack_animal(mob/living/user)
	if(breakable)
		if(user.wall_smash)
			visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
			destroy()

/obj/structure/attack_paw(mob/user)
	if(breakable) attack_hand(user)

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
	destroy(src)

/obj/structure/attack_tk()
	return