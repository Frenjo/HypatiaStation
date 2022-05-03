//BASKETBALL OBJECTS
// Basketball
/obj/item/weapon/beach_ball/holoball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = 4 //Stops people from hiding it in their bags/pockets

// Basketball Hoop
/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!."
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = 1
	density = 1
	throwpass = 1

/obj/structure/holohoop/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/grab) && get_dist(src, user) < 2)
		var/obj/item/weapon/grab/G = W
		if(G.state < 2)
			to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message(SPAN_WARNING("[G.assailant] dunks [G.affecting] into the [src]!"), 3)
		qdel(W)
		return
	else if(istype(W, /obj/item) && get_dist(src, user) < 2)
		user.drop_item(src)
		visible_message(SPAN_INFO("[user] dunks [W] into the [src]!"), 3)
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(istype(mover, /obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.loc = src.loc
			visible_message(SPAN_INFO("Swish! \the [I] lands in \the [src]."), 3)
		else
			visible_message(SPAN_WARNING("\the [I] bounces off of \the [src]'s rim!"), 3)
		return 0
	else
		return ..(mover, target, height, air_group)