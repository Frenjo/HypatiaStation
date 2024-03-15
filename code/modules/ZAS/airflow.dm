/*
Contains helper procs for airflow, handled in /connection_group.
*/

/mob
	var/tmp/last_airflow_stun = 0

/mob/proc/airflow_stun()
	if(stat == DEAD)
		return 0
	if(last_airflow_stun > world.time - global.vsc.airflow_stun_cooldown)
		return 0
	if(!(status_flags & CANSTUN) && !(status_flags & CANWEAKEN))
		to_chat(src, SPAN_INFO("You stay upright as the air rushes past you."))
		return 0
	if(weakened <= 0)
		to_chat(src, SPAN_WARNING("The sudden rush of air knocks you over!"))
	weakened = max(weakened, 5)
	last_airflow_stun = world.time

/mob/living/silicon/airflow_stun()
	return

/mob/living/carbon/metroid/airflow_stun()
	return

/mob/living/carbon/human/airflow_stun()
	if(last_airflow_stun > world.time - global.vsc.airflow_stun_cooldown)
		return 0
	if(buckled)
		return 0
	if(isnotnull(shoes) && HAS_ITEM_FLAGS(shoes, ITEM_FLAG_NO_SLIP))
		return 0
	if(!(status_flags & CANSTUN) && !(status_flags & CANWEAKEN))
		to_chat(src, SPAN_INFO("You stay upright as the air rushes past you."))
		return 0
	if(weakened <= 0)
		to_chat(src, SPAN_WARNING("The sudden rush of air knocks you over!"))
	weakened = max(weakened, rand(1, 5))
	last_airflow_stun = world.time

/atom/movable/proc/check_airflow_movable(n)
	if(anchored && !ismob(src))
		return 0

	if(!isitem(src) && n < global.vsc.airflow_dense_pressure)
		return 0

	return 1

/mob/check_airflow_movable(n)
	if(n < global.vsc.airflow_heavy_pressure)
		return 0
	return 1

/mob/dead/observer/check_airflow_movable()
	return 0

/mob/living/silicon/check_airflow_movable()
	return 0

/obj/item/check_airflow_movable(n)
	. = ..()
	switch(w_class)
		if(2)
			if(n < global.vsc.airflow_lightest_pressure)
				return 0
		if(3)
			if(n < global.vsc.airflow_light_pressure)
				return 0
		if(4, 5)
			if(n < global.vsc.airflow_medium_pressure)
				return 0

/atom/movable/var/tmp/turf/airflow_dest
/atom/movable/var/tmp/airflow_speed = 0
/atom/movable/var/tmp/airflow_time = 0
/atom/movable/var/tmp/last_airflow = 0

/atom/movable/proc/GotoAirflowDest(n)
	if(!airflow_dest)
		return
	if(airflow_speed < 0)
		return
	if(last_airflow > world.time - global.vsc.airflow_delay)
		return
	if(airflow_speed)
		airflow_speed = n / max(get_dist(src, airflow_dest), 1)
		return
	last_airflow = world.time
	if(airflow_dest == loc)
		step_away(src, loc)
	if(ismob(src))
		if(src:status_flags & GODMODE)
			return
		if(ishuman(src))
			if(src:buckled)
				return
			if(src:shoes)
				if(istype(src:shoes, /obj/item/clothing/shoes/magboots))
					if(src:shoes:magpulse)
						return
		to_chat(src, SPAN_WARNING("You are sucked away by airflow!"))
	var/airflow_falloff = 9 - ul_FalloffAmount(airflow_dest) //It's a fast falloff calc.  Very useful.
	if(airflow_falloff < 1)
		airflow_dest = null
		return
	airflow_speed = min(max(n * (9 / airflow_falloff), 1), 9)
	var/xo = airflow_dest.x - src.x
	var/yo = airflow_dest.y - src.y
	var/od = 0
	airflow_dest = null
	if(!density)
		density = TRUE
		od = 1
	while(airflow_speed > 0)
		if(airflow_speed <= 0)
			return
		airflow_speed = min(airflow_speed, 15)
		airflow_speed -= global.vsc.airflow_speed_decay
		if(airflow_speed > 7)
			if(airflow_time++ >= airflow_speed - 7)
				if(od)
					density = FALSE
				sleep(1 * global.PCair.tick_multiplier)
		else
			if(od)
				density = FALSE
			sleep(max(1, 10 - (airflow_speed + 3)) * global.PCair.tick_multiplier)
		if(od)
			density = TRUE
		if((!(src.airflow_dest) || src.loc == src.airflow_dest))
			src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
		if((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
			return
		if(!isturf(loc))
			return
		step_towards(src, src.airflow_dest)
		if(ismob(src) && src:client)
			src:client:move_delay = world.time + global.vsc.airflow_mob_slowdown
	airflow_dest = null
	airflow_speed = 0
	airflow_time = 0
	if(od)
		density = FALSE

/atom/movable/proc/RepelAirflowDest(n)
	if(!airflow_dest)
		return
	if(airflow_speed < 0)
		return
	if(last_airflow > world.time - global.vsc.airflow_delay)
		return
	if(airflow_speed)
		airflow_speed = n / max(get_dist(src, airflow_dest), 1)
		return
	if(airflow_dest == loc)
		step_away(src, loc)
	if(ismob(src))
		var/mob/mob = src
		if(mob.status_flags & GODMODE)
			return
		if(ishuman(mob))
			var/mob/living/carbon/human/human = mob
			if(human.buckled)
				return
			if(isnotnull(human.shoes) && istype(human.shoes, /obj/item/clothing/shoes/magboots) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP))
				return
		to_chat(src, SPAN_WARNING("You are pushed away by airflow!"))
		last_airflow = world.time
	var/airflow_falloff = 9 - ul_FalloffAmount(airflow_dest) //It's a fast falloff calc.  Very useful.
	if(airflow_falloff < 1)
		airflow_dest = null
		return
	airflow_speed = min(max(n * (9 / airflow_falloff), 1), 9)
	var/xo = -(airflow_dest.x - src.x)
	var/yo = -(airflow_dest.y - src.y)
	var/od = 0
	airflow_dest = null
	if(!density)
		density = TRUE
		od = 1
	while(airflow_speed > 0)
		if(airflow_speed <= 0)
			return
		airflow_speed = min(airflow_speed, 15)
		airflow_speed -= global.vsc.airflow_speed_decay
		if(airflow_speed > 7)
			if(airflow_time++ >= airflow_speed - 7)
				sleep(1 * global.PCair.tick_multiplier)
		else
			sleep(max(1,10-(airflow_speed+3)) * global.PCair.tick_multiplier)
		if((!(src.airflow_dest) || src.loc == src.airflow_dest))
			src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
		if((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
			return
		if(!isturf(loc))
			return
		step_towards(src, src.airflow_dest)
		if(ismob(src) && src:client)
			src:client:move_delay = world.time + global.vsc.airflow_mob_slowdown
	airflow_dest = null
	airflow_speed = 0
	airflow_time = 0
	if(od)
		density = FALSE

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		airflow_hit(A)
	else
		airflow_speed = 0
		airflow_time = 0
		. = ..()

/atom/movable/proc/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

/mob/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message(SPAN_DANGER("\The [src] slams into \a [A]!"), 1, SPAN_WARNING("You hear a loud slam!"), 2)
	playsound(src, "smash.ogg", 25, 1, -1)
	weakened = max(weakened, (isitem(A) ? A:w_class : rand(1, 5))) //Heheheh
	. = ..()

/obj/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message(SPAN_DANGER("\The [src] slams into \a [A]!"), 1, SPAN_WARNING("You hear a loud slam!"), 2)
	playsound(src, "smash.ogg", 25, 1, -1)
	. = ..()

/obj/item/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

/mob/living/carbon/human/airflow_hit(atom/A)
//	for(var/mob/M in hearers(src))
//		M.show_message("\red <B>[src] slams into [A]!</B>",1,"\red You hear a loud slam!",2)
	playsound(src, "punch", 25, 1, -1)
	loc:add_blood(src)
	if(src.wear_suit)
		src.wear_suit.add_blood(src)
	if(src.w_uniform)
		src.w_uniform.add_blood(src)
	var/b_loss = airflow_speed * global.vsc.airflow_damage

	var/blocked = run_armor_check("head", "melee")
	apply_damage(b_loss / 3, BRUTE, "head", blocked, 0, "Airflow")

	blocked = run_armor_check("chest", "melee")
	apply_damage(b_loss / 3, BRUTE, "chest", blocked, 0, "Airflow")

	blocked = run_armor_check("groin", "melee")
	apply_damage(b_loss / 3, BRUTE, "groin", blocked, 0, "Airflow")

	if(airflow_speed > 10)
		paralysis += round(airflow_speed * global.vsc.airflow_stun)
		stunned = max(stunned,paralysis + 3)
	else
		stunned += round(airflow_speed * global.vsc.airflow_stun / 2)
	. = ..()

/zone/proc/movables()
	. = list()
	for(var/turf/T in contents)
		for(var/atom/movable/A in T)
			if(A.simulated || A.anchored || istype(A, /obj/effect) || istype(A, /mob/ai_eye))
				continue
			. += A