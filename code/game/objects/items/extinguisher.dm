/obj/item/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	obj_flags = OBJ_FLAG_CONDUCT
	throwforce = 10
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 10.0
	matter_amounts = list(/decl/material/steel = 90)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")

	var/max_water = 50
	var/last_use = 1.0
	var/safety = 1
	var/sprite_name = "fire_extinguisher"

/obj/item/extinguisher/mini
	name = "fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	throwforce = 2
	w_class = 2.0
	force = 3.0
	matter_amounts = list()
	max_water = 30
	sprite_name = "miniFE"

/obj/item/extinguisher/New()
	create_reagents(max_water)
	reagents.add_reagent("water", max_water)
	..()

/obj/item/extinguisher/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.reagents.total_volume)
	..()
	return

/obj/item/extinguisher/attack_self(mob/user)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	user << "The safety is [safety ? "on" : "off"]."
	return

/obj/item/extinguisher/afterattack(atom/target, mob/user , flag)
	//TODO; Add support for reagents in water.
	if(istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(src, target) <= 1)
		var/obj/o = target
		o.reagents.trans_to(src, 50)
		user << "\blue \The [src] is now refilled"
		playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	if(!safety)
		if(src.reagents.total_volume < 1)
			usr << "\red \The [src] is empty."
			return

		if(world.time < src.last_use + 20)
			return

		src.last_use = world.time

		playsound(src, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(src,target)

		if(usr.buckled && isobj(usr.buckled) && !usr.buckled.anchored)
			spawn(0)
				var/obj/B = usr.buckled
				var/movementdirection = turn(direction, 180)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(1)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(1)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(1)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(2)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(2)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(3)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(3)
				B.Move(get_step(usr, movementdirection), movementdirection)
				sleep(3)
				B.Move(get_step(usr, movementdirection), movementdirection)

		var/turf/T = GET_TURF(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))

		var/list/the_targets = list(T, T1, T2)

		for(var/a = 0, a < 5, a++)
			spawn(0)
				var/obj/effect/water/W = new /obj/effect/water(GET_TURF(src))
				var/turf/my_target = pick(the_targets)
				if(isnull(W))
					return
				W.create_reagents(5)
				if(isnull(W) || isnull(src))
					return
				src.reagents.trans_to(W, 1)
				for(var/b = 0, b < 5, b++)
					step_towards(W, my_target)
					if(isnull(W))
						return
					var/turf/W_turf = GET_TURF(W)
					W.reagents.reaction(W_turf)
					for_no_type_check(var/atom/movable/mover, W_turf)
						if(isnull(W))
							return
						W.reagents.reaction(mover)
						if(isliving(mover)) //For extinguishing mobs on fire
							var/mob/living/M = mover
							M.ExtinguishMob()
					if(W.loc == my_target)
						break
					sleep(2)

		if(isspace(usr.loc) || !usr.lastarea.has_gravity)
			user.inertia_dir = get_dir(target, user)
			step(user, user.inertia_dir)
	else
		return ..()
	return