////////////////////////////////////////
////////  Health related procs  ////////
////////////////////////////////////////
/obj/mecha/proc/take_damage(amount, type = "brute")
	if(amount)
		var/damage = absorb_damage(amount, type)
		health -= damage
		update_health()
		occupant_message(SPAN_DANGER("Taking damage!"))
		log_append_to_last("Took [damage] points of damage. Damage type: \"[type]\".", 1)

/obj/mecha/proc/absorb_damage(damage, damage_type)
	var/coefficient = 1
	if(damage_absorption[damage_type])
		coefficient = damage_absorption[damage_type]
	return damage * coefficient

/obj/mecha/proc/update_health()
	if(src.health > 0)
		src.spark_system.start()
	else
		qdel(src)

/obj/mecha/hitby(atom/movable/A) //wrapper
	log_message("Hit by [A].", 1)

	var/deflection_chance = deflect_chance
	var/damage_coefficient = 1
	var/deflect_tracking_beacons = FALSE
	for(var/obj/item/mecha_part/equipment/ranged_armour_booster/booster in equipment)
		if(booster.projectile_react())
			deflection_chance *= booster.deflect_coeff
			damage_coefficient *= booster.damage_coeff
			deflect_tracking_beacons = TRUE
			break

	if(istype(A, /obj/item/mecha_part/tracking))
		if(!deflect_tracking_beacons)
			A.forceMove(src)
			visible_message("The [A] fastens firmly to [src].")
			return
		else
			deflection_chance = 100 // The tracking beacon will bounce off.

	if(prob(deflection_chance) || ismob(A))
		occupant_message(SPAN_INFO("\The [A] bounces off the armour."))
		visible_message("\The [A] bounces off \the [src] armour.")
		log_append_to_last("Armour saved.")
		if(isliving(A))
			var/mob/living/M = A
			M.take_organ_damage(10)
	else if(isobj(A))
		var/obj/O = A
		if(O.throwforce)
			take_damage(round(O.throwforce * damage_coefficient))
			check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))

/obj/mecha/bullet_act(obj/item/projectile/bullet) //wrapper
	log_message("Hit by projectile. Type: [bullet.name]([bullet.flag]).", 1)
	var/deflection_chance = deflect_chance
	var/damage_coefficient = 1
	for(var/obj/item/mecha_part/equipment/ranged_armour_booster/booster in equipment)
		if(booster.projectile_react())
			deflection_chance *= booster.deflect_coeff
			damage_coefficient *= booster.damage_coeff
			break

	if(prob(deflection_chance))
		occupant_message(SPAN_INFO("The armour deflects the incoming projectile."))
		visible_message("\The [src] armour deflects the projectile.")
		log_append_to_last("Armour saved.")
		return

	var/ignore_threshold
	if(bullet.flag == "taser")
		use_power(200)
		return
	if(istype(bullet, /obj/item/projectile/energy/beam/pulse))
		ignore_threshold = 1
	take_damage(round(bullet.damage * damage_coefficient), bullet.flag)
	check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), ignore_threshold)
	bullet.on_hit(src)

/obj/mecha/ex_act(severity)
	src.log_message("Affected by explosion of severity: [severity].", 1)
	if(prob(src.deflect_chance))
		severity++
		src.log_append_to_last("Armor saved, changing severity to [severity].")
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(30))
				qdel(src)
			else
				src.take_damage(initial(src.health)/2)
				src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), 1)
		if(3.0)
			if(prob(5))
				qdel(src)
			else
				src.take_damage(initial(src.health)/5)
				src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), 1)
	return

/*Will fix later -Sieve
/obj/mecha/attack_blob(mob/user)
	src.log_message("Attack by blob. Attacker - [user].",1)
	if(!prob(src.deflect_chance))
		src.take_damage(6)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1, -1)
		user << "\red You smash at the armored suit!"
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("\red The [user] smashes against [src.name]'s armor!", 1)
	else
		src.log_append_to_last("Armor saved.")
		playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1, -1)
		user << "\green Your attack had no effect!"
		src.occupant_message("\blue The [user]'s attack is stopped by the armor.")
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("\blue The [user] rebounds off the [src.name] armor!", 1)
	return
*/

//TODO
/obj/mecha/meteorhit()
	return ex_act(rand(1, 3))//should do for now

/obj/mecha/emp_act(severity)
	if(get_charge())
		use_power((cell.charge / 2) / severity)
		take_damage(50 / severity, "energy")
	src.log_message("EMP detected", 1)
	check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), 1)
	return

/obj/mecha/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > src.max_temperature)
		src.log_message("Exposed to dangerous temperature.", 1)
		src.take_damage(5, "fire")
		src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL))
	return

///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////
/obj/mecha/proc/check_for_internal_damage(list/possible_int_damage, ignore_threshold = null)
	if(!islist(possible_int_damage) || isemptylist(possible_int_damage))
		return
	if(prob(20))
		if(ignore_threshold || src.health * 100 / initial(src.health) < src.internal_damage_threshold)
			for(var/T in possible_int_damage)
				if(internal_damage & T)
					possible_int_damage -= T
			var/int_dam_flag = safepick(possible_int_damage)
			if(int_dam_flag)
				set_internal_damage(int_dam_flag)
	if(prob(5))
		if(ignore_threshold || src.health * 100 / initial(src.health) < src.internal_damage_threshold)
			var/obj/item/mecha_part/equipment/destr = safepick(equipment)
			if(isnotnull(destr))
				qdel(destr)

/obj/mecha/proc/set_internal_damage(int_dam_flag)
	internal_damage |= int_dam_flag
	pr_internal_damage.start()
	log_append_to_last("Internal damage of type [int_dam_flag].", 1)
	occupant << sound('sound/machines/warning-buzzer.ogg', wait = 0)

/obj/mecha/proc/clear_internal_damage(int_dam_flag)
	internal_damage &= ~int_dam_flag
	switch(int_dam_flag)
		if(MECHA_INT_TEMP_CONTROL)
			occupant_message("<font color='blue'><b>Life support system reactivated.</b></font>")
			pr_int_temp_processor.start()
		if(MECHA_INT_FIRE)
			occupant_message("<font color='blue'><b>Internal fire extinquished.</b></font>")
		if(MECHA_INT_TANK_BREACH)
			occupant_message("<font color='blue'><b>Damaged internal tank has been sealed.</b></font>")