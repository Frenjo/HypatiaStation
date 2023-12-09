
/*
	run_armor_check(a,b)
	args
	a:def_zone - What part is getting hit, if null will check entire body
	b:attack_flag - What type of attack, bullet, laser, energy, melee

	Returns
	0 - no block
	1 - halfblock
	2 - fullblock
*/
/mob/living/proc/run_armor_check(def_zone = null, attack_flag = "melee", absorb_text = null, soften_text = null)
	var/armor = getarmor(def_zone, attack_flag)
	var/absorb = 0
	if(prob(armor))
		absorb += 1
	if(prob(armor))
		absorb += 1
	if(absorb >= 2)
		if(absorb_text)
			show_message("[absorb_text]")
		else
			show_message(SPAN_WARNING("Your armor absorbs the blow!"))
		return 2
	if(absorb == 1)
		if(absorb_text)
			show_message("[soften_text]",4)
		else
			show_message(SPAN_WARNING("Your armor softens the blow!"))
		return 1
	return 0

/mob/living/proc/getarmor(def_zone, type)
	return 0

/mob/living/bullet_act(obj/item/projectile/P, def_zone)
	var/obj/item/cloaking_device/C = locate(/obj/item/cloaking_device) in src
	if(C && C.active)
		C.attack_self(src) //Should shut it off
		update_icons()
		to_chat(src, SPAN_INFO("Your [C.name] was disrupted!"))
		Stun(2)

	flash_weak_pain()

	if(istype(get_active_hand(), /obj/item/assembly/signaler))
		var/obj/item/assembly/signaler/signaler = get_active_hand()
		if(signaler.deadman && prob(80))
			src.visible_message(SPAN_WARNING("[src] triggers their deadman's switch!"))
			signaler.signal()

	var/absorb = run_armor_check(def_zone, P.flag)
	if(absorb >= 2)
		P.on_hit(src, 2)
		return 2
	if(!P.nodamage)
		apply_damage(P.damage, P.damage_type, def_zone, absorb, 0, P, sharp = is_sharp(P), edge = has_edge(P))
	P.on_hit(src, absorb)
	return absorb

/mob/living/hitby(atom/movable/AM as mob|obj, speed = 5) //Standardization and logging -Sieve
	if(istype(AM, /obj))
		var/obj/O = AM
		var/zone = ran_zone("chest", 75) //Hits a random part of the body, geared towards the chest
		var/dtype = BRUTE
		if(istype(O, /obj/item))
			var/obj/item/W = O
			dtype = W.damtype
		src.visible_message(SPAN_WARNING("[src] has been hit by [O]."))
		var/armor = run_armor_check(zone, "melee", "Your armor has protected your [zone].", "Your armor has softened hit to your [zone].")
		if(armor < 2)
			apply_damage(O.throwforce * (speed / 5), dtype, zone, armor, O, sharp = is_sharp(O), edge = has_edge(O))

		if(!O.last_fingerprints)
			return

		var/client/assailant = GLOBL.directory[ckey(O.last_fingerprints)]
		if(assailant && assailant.mob && ismob(assailant.mob))
			var/mob/M = assailant.mob

			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a thrown [O], last touched by [M.name] ([assailant.ckey])</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with a thrown [O]</font>")
			if(!istype(src, /mob/living/simple_animal/mouse))
				msg_admin_attack("[src.name] ([src.ckey]) was hit by a thrown [O], last touched by [M.name] ([assailant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

// Begin BS12 momentum-transfer code.

			if(speed >= 20)
				var/obj/item/W = O
				var/momentum = speed/2
				var/dir = get_dir(M, src)

				visible_message("\red [src] staggers under the impact!", "\red You stagger under the impact!")
				src.throw_at(get_edge_target_turf(src, dir), 1, momentum)

				if(isliving(W.loc) && W.sharp) //Projectile is embedded and suitable for pinning.

					if(!ishuman(src)) //Handles embedding for non-humans and simple_animals.
						O.loc = src
						src.embedded += O

					var/turf/T = near_wall(dir, 2)

					if(T)
						src.loc = T
						visible_message(SPAN_WARNING("[src] is pinned to the wall by [O]!"), SPAN_WARNING("You are pinned to the wall by [O]!"))
						src.anchored = TRUE
						src.pinned += O

/mob/living/proc/near_wall(direction, distance = 1)
	var/turf/T = get_step(get_turf(src),direction)
	var/turf/last_turf = src.loc
	var/i = 1

	while(i > 0 && i <= distance)
		if(T.density) //Turf is a wall!
			return last_turf
		i++
		last_turf = T
		T = get_step(T, direction)

	return 0

// End BS12 momentum-transfer code.

/mob/living/proc/IgniteMob()
	if(fire_stacks > 0 && !on_fire)
		on_fire = 1
		src.set_light(3)
		update_fire()

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		src.set_light(0)
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
	fire_stacks = clamp(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

/mob/living/proc/handle_fire()
	if(fire_stacks < 0)
		fire_stacks = max(0, fire_stacks++) //If we've doused ourselves in water to avoid fire, dry off slowly

	if(!on_fire)
		return 1
	else if(fire_stacks <= 0)
		ExtinguishMob() //Fire's been put out.
		return 1

	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.gas[/decl/xgm_gas/oxygen] < 1)
		ExtinguishMob() //If there's no oxygen in the tile we're on, put out the fire
		return 1

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)

/mob/living/fire_act()
	adjust_fire_stacks(0.5)
	IgniteMob()

//Finds the effective temperature that the mob is burning at.
/mob/living/proc/fire_burn_temperature()
	if(fire_stacks <= 0)
		return 0

	//Scale quadratically so that single digit numbers of fire stacks don't burn ridiculously hot.
	return round(FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE * (fire_stacks / FIRE_MAX_FIRESUIT_STACKS) ** 2)