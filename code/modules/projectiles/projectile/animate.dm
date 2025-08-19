/obj/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"

	damage = 0
	damage_type = BURN
	nodamage = TRUE
	flag = "energy"

/obj/projectile/animate/Bump(atom/change)
	if((isitem(change) || istype(change, /obj/structure)) && !is_type_in_list(change, protected_objects))
		var/obj/O = change
		new /mob/living/simple/hostile/mimic/copy(O.loc, O, firer)
	. = ..()