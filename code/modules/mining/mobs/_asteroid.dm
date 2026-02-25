/mob/living/simple/hostile/asteroid
	icon = 'icons/mob/simple/mining.dmi'

	vision_range = 2
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	unsuitable_atoms_damage = 15
	factions = list("mining")
	wall_smash = 1
	minbodytemp = 0
	heat_damage_per_tick = 20
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "strikes"

	var/aggro_vision_range = 8
	var/idle_vision_range = null
	var/icon_aggro = null
	var/ranged_message = "fires"
	var/throw_message = "bounces off of"

/mob/living/simple/hostile/asteroid/New()
	idle_vision_range = vision_range
	. = ..()

/mob/living/simple/hostile/asteroid/give_target(new_target)
	target = new_target
	if(isnotnull(target))
		aggro()
		stance = HOSTILE_STANCE_ATTACK

/mob/living/simple/hostile/asteroid/LoseTarget()
	. = ..()
	lose_aggro()

/mob/living/simple/hostile/asteroid/LostTarget()
	. = ..()
	lose_aggro()

/mob/living/simple/hostile/asteroid/proc/aggro()
	vision_range = aggro_vision_range
	icon_state = icon_aggro

/mob/living/simple/hostile/asteroid/proc/lose_aggro()
	vision_range = idle_vision_range
	icon_state = icon_living

/mob/living/simple/hostile/asteroid/adjustBruteLoss(damage)
	. = ..(damage)
	if(stance == HOSTILE_STANCE_IDLE)
		aggro()
		give_target(FindTarget())
	if(stance == HOSTILE_STANCE_ATTACK) // No more pulling a mob forever and having a second player attack it, it can switch targets now.
		if(isnotnull(target) && prob(25))
			give_target(FindTarget())

/mob/living/simple/hostile/asteroid/bullet_act(obj/projectile/bullet)
	if(bullet.damage < 30)
		visible_message(SPAN_DANGER("\The [bullet] had no effect on \the [src]!"))
		return
	. = ..()

//ALL THIS SHIT IS FOR TRACKING PEOPLE AND TARGETTING//

/mob/living/simple/hostile/asteroid/FindTarget()
	RETURN_TYPE(/atom)

	var/list/atom/possible_targets = list()
	stop_automated_movement = FALSE
	for_no_type_check(var/atom/A, list_targets())
		if(Found(A)) // Just in case people want to override targetting IE: Mouse sees cheese.
			break
		if(can_attack(A)) // Can we attack it?
			possible_targets.Add(A)
			continue
	return pick_target(possible_targets) // We now have a target.

/mob/living/simple/hostile/asteroid/proc/pick_target(list/atom/possible_targets)
	RETURN_TYPE(/atom)

	if(isnotnull(target))
		for_no_type_check(var/atom/A, possible_targets)
			var/target_dist = get_dist(src, target)
			var/possible_target_distance = get_dist(src, A)
			if(target_dist < possible_target_distance)
				possible_targets.Remove(A)
	if(!length(possible_targets))
		return
	return pick(possible_targets)

/mob/living/simple/hostile/asteroid/can_attack(atom/target_atom)
	if(see_invisible < target_atom.invisibility)
		return FALSE
	if(isliving(target_atom))
		var/mob/living/L = target_atom
		if(L.stat != CONSCIOUS || L.is_same_faction(factions) && !attack_same)
			return FALSE
		if(L in friends)
			return FALSE
		return TRUE
	if(ismecha(target_atom))
		var/obj/mecha/M = target_atom
		if(isnotnull(M.occupant))
			return TRUE
	return FALSE

//END SHIT FOR TRACKING PEOPLE AND TARGETTING//

/mob/living/simple/hostile/asteroid/Die()
	lose_aggro()
	. = ..()

/mob/living/simple/hostile/asteroid/MoveToTarget()
	stop_automated_movement = TRUE
	if(isnull(target) || !can_attack(target))
		LoseTarget()
	if(target in list_targets())
		if(get_dist(src, target) >= 2 && ranged)
			OpenFire(target)
		go_to(target, move_to_delay)
		if(isturf(loc) && target.Adjacent(src))	//Attacking
			AttackingTarget()
		return
	LostTarget()

/mob/living/simple/hostile/asteroid/OpenFire(the_target)
	var/fire_at = the_target
	visible_message("\red <b>[src]</b> [ranged_message] at \the [fire_at]!")

	var/turf/target_turf = GET_TURF(fire_at)
	if(rapid)
		spawn(0.1 SECONDS)
			Shoot(target_turf, loc, src)
			if(isnotnull(casingtype))
				new casingtype(GET_TURF(src))
		spawn(0.4 SECONDS)
			Shoot(target_turf, loc, src)
			if(isnotnull(casingtype))
				new casingtype(GET_TURF(src))
		spawn(0.6 SECONDS)
			Shoot(target_turf, loc, src)
			if(isnotnull(casingtype))
				new casingtype(GET_TURF(src))
	else
		Shoot(target_turf, loc, src)
		if(isnotnull(casingtype))
			new casingtype(GET_TURF(src))

/mob/living/simple/hostile/asteroid/hitby(atom/movable/mover)
	if(isitem(mover))
		var/obj/item/T = mover
		if(T.throwforce <= 15)//No floor tiling them to death, wiseguy
			visible_message(SPAN_NOTICE("\The [T] [throw_message] \the [src]!"))
			aggro()
			return
	. = ..()