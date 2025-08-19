// bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
		attack_dir = get_dir(GET_TURF(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(GET_TURF(user), GET_TURF(attacker))
	else if(damage_source)
		attack_dir = get_dir(GET_TURF(user), GET_TURF(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0