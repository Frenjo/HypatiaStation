/*
 * Large Crate
 */
/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/storage/crate.dmi'
	icon_state = "densecrate"
	density = TRUE

/obj/structure/largecrate/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You need a crowbar to pry this open!"))
	return

/obj/structure/largecrate/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/crowbar))
		new /obj/item/stack/sheet/wood(src)
		var/turf/T = get_turf(src)
		for(var/obj/O in contents)
			O.loc = T
		user.visible_message(
			SPAN_NOTICE("[user] pries \the [src] open."),
			SPAN_NOTICE("You pry open \the [src]."),
			SPAN_NOTICE("You hear splitting wood.")
		)
		qdel(src)
	else
		return attack_hand(user)

/*
 * Mule Crate
 */
/obj/structure/largecrate/mule
	icon_state = "mulecrate"

/*
 * Lisa Crate
 */
/obj/structure/largecrate/lisa
	icon_state = "lisacrate"

/obj/structure/largecrate/lisa/attackby(obj/item/W as obj, mob/user as mob)	//ugly but oh well
	if(istype(W, /obj/item/crowbar))
		new /mob/living/simple_animal/corgi/Lisa(loc)
	..()

/*
 * Cow Crate
 */
/obj/structure/largecrate/cow
	name = "cow crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/cow/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/crowbar))
		new /mob/living/simple_animal/cow(loc)
	..()

/*
 * Goat Crate
 */
/obj/structure/largecrate/goat
	name = "goat crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/goat/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/crowbar))
		new /mob/living/simple_animal/hostile/retaliate/goat(loc)
	..()

/*
 * Chicken Crate
 */
/obj/structure/largecrate/chick
	name = "chicken crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/chick/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/crowbar))
		var/num = rand(4, 6)
		for(var/i = 0, i < num, i++)
			new /mob/living/simple_animal/chick(loc)
	..()

/*
 * Hoverpod Crate
 */
// Ported hoverpod from NSS Eternal. -Frenjo
/obj/structure/largecrate/hoverpod
	name = "\improper Hoverpod assembly crate"
	desc = "It comes in a box for the fabricator's sake. Where does the wood come from? ... And why is it lighter?"
	icon_state = "mulecrate"

/obj/structure/largecrate/hoverpod/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/crowbar))
		var/obj/item/mecha_parts/mecha_equipment/ME
		var/obj/mecha/working/hoverpod/H = new (loc)

		ME = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
		ME.attach(H)
		ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
		ME.attach(H)
	..()