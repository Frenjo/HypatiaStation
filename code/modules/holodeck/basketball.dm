//BASKETBALL OBJECTS
// Basketball
/obj/item/beach_ball/holoball
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
	anchored = TRUE
	density = TRUE
	throwpass = 1

/obj/structure/holohoop/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	if(get_dist(src, user) > 2)
		return FALSE
	if(grab.state < 2)
		to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
		return TRUE
	grabbed.forceMove(loc)
	grabbed.Weaken(5)
	visible_message(SPAN_WARNING("[user] dunks \the [grabbed] into \the [src]!"))
	qdel(grab)
	return TRUE

/obj/structure/holohoop/attack_by(obj/item/I, mob/user)
	if(get_dist(src, user) > 2)
		return ..()
	user.drop_item(src)
	visible_message(SPAN_INFO("[user] dunks \the [I] into \the [src]!"))
	return TRUE

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(isitem(mover) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.forceMove(loc)
			visible_message(SPAN_INFO("Swish! \the [I] lands in \the [src]."), 3)
		else
			visible_message(SPAN_WARNING("\the [I] bounces off of \the [src]'s rim!"), 3)
		return FALSE
	else
		return ..(mover, target, height, air_group)