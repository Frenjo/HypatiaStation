/obj/structure/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/structures/chairs.dmi'
	icon_state = "stool"
	anchored = TRUE
	pressure_resistance = 15

/obj/structure/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(5))
				qdel(src)
				return
	return

/obj/structure/stool/blob_act()
	if(prob(75))
		new /obj/item/stack/sheet/steel(loc)
		qdel(src)

/obj/structure/stool/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/wrench))
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/steel(loc)
		qdel(src)
	return

/obj/structure/stool/MouseDrop(atom/over_object)
	if(ishuman(over_object))
		var/mob/living/carbon/human/H = over_object
		if(H == usr && !H.restrained() && !H.stat && in_range(src, over_object))
			var/obj/item/stool/S = new/obj/item/stool()
			S.origin = src
			src.loc = S
			H.put_in_hands(S)
			H.visible_message(
				SPAN_WARNING("[H] grabs [src] from the floor!"),
				SPAN_WARNING("You grab [src] from the floor!")
			)

/obj/item/stool
	name = "stool"
	desc = "Uh-hoh, bar is heating up."
	icon = 'icons/obj/structures/chairs.dmi'
	icon_state = "stool"
	force = 10
	throwforce = 10
	w_class = 5.0
	var/obj/structure/stool/origin = null

/obj/item/stool/attack_self(mob/user)
	..()
	origin.loc = get_turf(src)
	user.u_equip(src)
	user.visible_message(
		SPAN_INFO("[user] puts [src] down."),
		SPAN_INFO("You put [src] down.")
	)
	qdel(src)

/obj/item/stool/attack(mob/M, mob/user)
	if(prob(5) && isliving(M))
		user.visible_message(SPAN_WARNING("[user] breaks [src] over [M]'s back!"))
		user.u_equip(src)
		new /obj/item/stack/sheet/steel(get_turf(src))
		qdel(src)
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()