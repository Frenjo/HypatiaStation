/obj/item/gun/rocketlauncher
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"

	w_class = 4
	obj_flags = OBJ_FLAG_CONDUCT
	item_flags = ITEM_FLAG_HAS_USE_DELAY
	slot_flags = null
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 8)

	throw_speed = 2
	throw_range = 10

	var/missile_speed = 2
	var/missile_range = 30
	var/max_rockets = 1
	var/list/rockets = list()

	var/projectile = /obj/item/missile

/obj/item/gun/rocketlauncher/examine()
	set src in view()
	..()
	if(!(usr in view(2)) && usr != loc)
		return
	to_chat(usr, SPAN_INFO("[length(rockets)] / [max_rockets] rockets."))

/obj/item/gun/rocketlauncher/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/ammo_casing/rocket))
		if(length(rockets) < max_rockets)
			user.drop_item()
			I.loc = src
			rockets += I
			to_chat(user, SPAN_INFO("You put the rocket in [src]."))
			to_chat(user, SPAN_INFO("[length(rockets)] / [max_rockets] rockets."))
		else
			to_chat(usr, SPAN_WARNING("[src] cannot hold more rockets."))

/obj/item/gun/rocketlauncher/can_fire()
	return length(rockets)

/obj/item/gun/rocketlauncher/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(length(rockets))
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new projectile(user.loc)
		playsound(user.loc, 'sound/effects/bang.ogg', 50, 1)
		M.primed = 1
		M.throw_at(target, missile_range, missile_speed)
		message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([name]).")
		log_game("[key_name_admin(user)] used a rocket launcher ([name]).")
		rockets.Remove(I)
		qdel(I)
		return
	else
		to_chat(usr, SPAN_WARNING("[src] is empty."))