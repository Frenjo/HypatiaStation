/mob/living/simple/hostile
	faction = "hostile"
	stop_automated_movement_when_pulled = FALSE

	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/atom/target
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/move_to_delay = 4 //delay for the automated movement.
	var/list/friends = list()
	var/vision_range = 9
	var/break_stuff_probability = 10
	var/destroy_surroundings = 1

	var/ranged_cooldown = 0 // The current cooldown of our ranged attacks.
	var/max_ranged_cooldown = 3 // The maximum cooldown of our ranged attacks, in Life() ticks.

/mob/living/simple/hostile/Life()
	. = ..()
	if(ranged)
		ranged_cooldown--

/mob/living/simple/hostile/can_attack(atom/target_atom)
	if(!..())
		return FALSE
	if(isliving(target_atom))
		var/mob/living/L = target_atom
		if(L.faction == faction && !attack_same)
			return FALSE
		else if(L in friends)
			return FALSE
	return TRUE

/mob/living/simple/hostile/proc/FindTarget()
	var/atom/T = null
	stop_automated_movement = FALSE
	for(var/atom/A in list_targets())
		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(!can_attack(A))
			continue

		if(isliving(A))
			T = A
			break

		else if(ismecha(A)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if(M.occupant)
				stance = HOSTILE_STANCE_ATTACK
				T = M
				break

		if(istype(A, /obj/machinery/bot))
			var/obj/machinery/bot/B = A
			if(B.health > 0)
				stance = HOSTILE_STANCE_ATTACK
				T = B
				break
	return T

/mob/living/simple/hostile/proc/Found(atom/A)
	return

/mob/living/simple/hostile/proc/give_target(new_target)
	target = new_target
	if(isnotnull(target))
		stance = HOSTILE_STANCE_ATTACK

/mob/living/simple/hostile/proc/go_to(the_target, delay)
	walk_to(src, the_target, 1, delay)

/mob/living/simple/hostile/proc/MoveToTarget()
	stop_automated_movement = 1
	if(isnull(target) || !can_attack(target))
		stance = HOSTILE_STANCE_IDLE
	if(target in list_targets())
		if(ranged)
			if(get_dist(src, target) <= 6 && ranged_cooldown <= 0)
				OpenFire(target)
			else
				walk_to(src, target, 1, move_to_delay)
		else
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(src, target, 1, move_to_delay)

/mob/living/simple/hostile/proc/AttackTarget()
	stop_automated_movement = 1
	if(isnull(target) || !can_attack(target))
		LoseTarget()
		return 0
	if(!(target in list_targets()))
		LostTarget()
		return 0
	if(get_dist(src, target) <= 1)	//Attacking
		AttackingTarget()
		return 1

/mob/living/simple/hostile/proc/AttackingTarget()
	if(!Adjacent(target))
		return
	if(isliving(target))
		var/mob/living/L = target
		L.attack_animal(src)
		return L
	if(ismecha(target))
		var/obj/mecha/M = target
		M.attack_animal(src)
		return M
	if(istype(target, /obj/machinery/bot))
		var/obj/machinery/bot/B = target
		B.attack_animal(src)

/mob/living/simple/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target = null
	walk(src, 0)

/mob/living/simple/hostile/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)

/mob/living/simple/hostile/proc/list_targets(override = -1)
	// Allows you to override how much the mob can see. Defaults to vision_range if none is entered.
	if(override == -1)
		override = vision_range

	var/list/L = hearers(src, override)
	for_no_type_check(var/obj/mecha/M, GLOBL.mechas_list)
		// Will check the distance before checking the line of sight, if the distance is small enough.
		if(get_dist(M, src) <= override && can_see(src, M, override))
			L.Add(M)
	return L

/mob/living/simple/hostile/Die()
	. = ..()
	walk(src, 0)

/mob/living/simple/hostile/Life()
	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0

	if(!stat)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				if(destroy_surroundings)
					DestroySurroundings()
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				if(destroy_surroundings)
					DestroySurroundings()
				AttackTarget()

/mob/living/simple/hostile/proc/OpenFire(new_target)
	var/atom/target = new_target
	visible_message(SPAN_WARNING("<b>[src]</b> fires at \the [target]!"), SPAN_WARNING("You fire at \the [target]!"))

	var/tturf = GET_TURF(target)
	if(rapid)
		spawn(1)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(GET_TURF(src))
		spawn(4)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(GET_TURF(src))
		spawn(6)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(GET_TURF(src))
	else
		Shoot(tturf, src.loc, src)
		if(casingtype)
			new casingtype

	ranged_cooldown = max_ranged_cooldown
	stance = HOSTILE_STANCE_IDLE
	return

/mob/living/simple/hostile/proc/Shoot(target, start, user, bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(GET_TURF(src))
	playsound(user, projectilesound, 100, 1)
	if(isnull(A))
		return

	if(!isturf(target))
		qdel(A)
		return
	A.current = target
	A.starting = GET_TURF(src)
	A.original = GET_TURF(target)
	A.yo = target:y - start:y
	A.xo = target:x - start:x
	spawn(0)
		A.process()

/mob/living/simple/hostile/proc/DestroySurroundings()
	if(prob(break_stuff_probability))
		for(var/dir in GLOBL.cardinal) // North, South, East, West
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_animal(src)

/mob/living/simple/hostile/RangedAttack(atom/new_target, params) // Player firing.
	if(ranged && ranged_cooldown <= 0)
		target = new_target
		OpenFire(new_target)