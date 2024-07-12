/obj/item/beach_ball
	name = "beach ball"
	icon = 'icons/misc/beach.dmi'
	icon_state = "ball"
	item_state = "beachball"
	density = FALSE
	anchored = FALSE
	w_class = 1.0
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT

/obj/item/beach_ball/afterattack(atom/target, mob/user)
	user.drop_item()
	src.throw_at(target, throw_range, throw_speed)