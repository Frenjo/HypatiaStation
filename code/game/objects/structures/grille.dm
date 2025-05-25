/obj/structure/grille
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	name = "grille"
	icon_state = "grille"
	density = TRUE
	anchored = TRUE
	obj_flags = OBJ_FLAG_CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 2.9
	explosion_resistance = 5

	var/health = 10
	var/destroyed = 0


/obj/structure/grille/ex_act(severity)
	qdel(src)

/obj/structure/grille/blob_act()
	qdel(src)

/obj/structure/grille/meteorhit(obj/M)
	qdel(src)


/obj/structure/grille/Bumped(atom/user)
	if(ismob(user)) shock(user, 70)


/obj/structure/grille/attack_paw(mob/user)
	attack_hand(user)

/obj/structure/grille/attack_hand(mob/user)
	playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)

	var/damage_dealt
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			damage_dealt = 5
			user.visible_message(SPAN_WARNING("[user] mangles [src]."), SPAN_WARNING("You mangle [src]."), "You hear twisting metal.")

	if(!damage_dealt)
		user.visible_message(SPAN_WARNING("[user] kicks [src]."), SPAN_WARNING("You kick [src]."), "You hear twisting metal.")

	if(shock(user, 70))
		return

	if(MUTATION_HULK in user.mutations)
		damage_dealt += 5
	else
		damage_dealt += 1

	health -= damage_dealt
	healthcheck()

/obj/structure/grille/attack_slime(mob/user)
	if(!isslimeadult(user))
		return

	playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
	user.visible_message(SPAN_WARNING("[user] smashes against [src]."), SPAN_WARNING("You smash against [src]."), "You hear twisting metal.")

	health -= rand(2, 3)
	healthcheck()
	return

/obj/structure/grille/attack_animal(mob/living/simple/M)
	if(M.melee_damage_upper == 0)
		return

	playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
	M.visible_message(SPAN_WARNING("[M] smashes against [src]."), SPAN_WARNING("You smash against [src]."), "You hear twisting metal.")

	health -= M.melee_damage_upper
	healthcheck()
	return


/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GRILLE))
		return TRUE
	else
		if(istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return !density

/obj/structure/grille/bullet_act(obj/item/projectile/bullet)
	if(isnull(bullet))
		return
	if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
		health -= bullet.damage * 0.2
		healthcheck()

/obj/structure/grille/attackby(obj/item/W, mob/user)
	if(iswirecutter(W))
		if(!shock(user, 100))
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			new /obj/item/stack/rods(loc, 2)
			qdel(src)
	else if((isscrewdriver(W)) && (isopenturf(loc) || anchored))
		if(!shock(user, 90))
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			anchored = !anchored
			user.visible_message(SPAN_NOTICE("[user] [anchored ? "fastens" : "unfastens"] the grille."), \
								 SPAN_NOTICE("You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor."))
			return

//window placing begin
	else if(istype(W, /obj/item/stack/sheet/glass))
		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if((x == user.x) || (y == user.y)) //Only supposed to work for cardinal directions.
				if(x == user.x)
					if(y > user.y)
						dir_to_set = 2
					else
						dir_to_set = 1
				else if(y == user.y)
					if(x > user.x)
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				to_chat(user, SPAN_NOTICE("You can't reach."))
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
				return
		to_chat(user, SPAN_NOTICE("You start placing the window."))
		if(do_after(user, 20))
			if(!src)
				return //Grille destroyed while waiting
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
					return
			var/obj/structure/window/WD
			if(istype(W, /obj/item/stack/sheet/glass/reinforced))
				WD = new/obj/structure/window/reinforced(loc) //reinforced window
			else
				WD = new/obj/structure/window/basic(loc) //normal window
			WD.set_dir(dir_to_set)
			WD.ini_dir = dir_to_set
			WD.anchored = FALSE
			WD.state = 0
			var/obj/item/stack/ST = W
			ST.use(1)
			to_chat(user, SPAN_NOTICE("You place the [WD] on [src]."))
			WD.update_icon()
		return
//window placing end

	else if(istype(W, /obj/item/shard))
		health -= W.force * 0.1
	else if(!shock(user, 70))
		playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
		switch(W.damtype)
			if("fire")
				health -= W.force
			if("brute")
				health -= W.force * 0.1
	healthcheck()
	..()
	return


/obj/structure/grille/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			icon_state = "brokengrille"
			density = FALSE
			destroyed = 1
			new /obj/item/stack/rods(loc)

		else
			if(health <= -6)
				new /obj/item/stack/rods(loc)
				qdel(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user, prb)
	if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = GET_TURF(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			make_sparks(3, TRUE, src)
			return 1
		else
			return 0
	return 0

/obj/structure/grille/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			health -= 1
			healthcheck()
	..()
