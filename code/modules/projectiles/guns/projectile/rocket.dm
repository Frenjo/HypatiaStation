/obj/item/weapon/gun/rocketlauncher
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	flags = CONDUCT | USEDELAY
	slot_flags = 0
	origin_tech = list(RESEARCH_TECH_COMBAT = 8, RESEARCH_TECH_MATERIALS = 5)

	var/missile_speed = 2
	var/missile_range = 30
	var/max_rockets = 1
	var/list/rockets = list()

	var/projectile = /obj/item/missile

/obj/item/weapon/gun/rocketlauncher/examine()
	set src in view()
	..()
	if(!(usr in view(2)) && usr != src.loc)
		return
	to_chat(usr, SPAN_INFO("[rockets.len] / [max_rockets] rockets."))

/obj/item/weapon/gun/rocketlauncher/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			user.drop_item()
			I.loc = src
			rockets += I
			to_chat(user, SPAN_INFO("You put the rocket in [src]."))
			to_chat(user, SPAN_INFO("[rockets.len] / [max_rockets] rockets."))
		else
			to_chat(usr, SPAN_WARNING("[src] cannot hold more rockets."))

/obj/item/weapon/gun/rocketlauncher/can_fire()
	return rockets.len

/obj/item/weapon/gun/rocketlauncher/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new projectile(user.loc)
		playsound(user.loc, 'sound/effects/bang.ogg', 50, 1)
		M.primed = 1
		M.throw_at(target, missile_range, missile_speed)
		message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]).")
		log_game("[key_name_admin(user)] used a rocket launcher ([src.name]).")
		rockets -= I
		qdel(I)
		return
	else
		to_chat(usr, SPAN_WARNING("[src] is empty."))