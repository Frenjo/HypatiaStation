/obj/structure/swarmer
	icon = 'icons/obj/structures/swarmer.dmi'

	luminosity = TRUE
	light_range = 2

	var/health = 30

/obj/structure/swarmer/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		qdel(src)

/obj/structure/swarmer/bullet_act(obj/item/projectile/bullet)
	if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
		take_damage(bullet.damage)
	. = ..()

/obj/structure/swarmer/attack_weapon(obj/item/W, mob/user)
	. = ..()
	if(!.)
		return FALSE
	take_damage(W.force)
	return TRUE

/obj/structure/swarmer/trap
	name = "swarmer trap"
	desc = "A quickly assembled electric trap. Will not retain its form if damaged enough."
	icon_state = "trap"

	light_color = "#03FCEF"

	health = 10

/obj/structure/swarmer/trap/Crossed(atom/movable/mover)
	if(isliving(mover))
		var/mob/living/alive = mover
		if(!HAS_PASS_FLAGS(mover, PASS_FLAG_SWARMER))
			alive.electrocute_act(0, src, 1, 1)
			qdel(src)
	. = ..()

/obj/structure/swarmer/barricade
	name = "swarmer barricade"
	desc = "A quickly assembled energy barricade. Will not retain its form if damaged enough, but disabler pulses and swarmers pass right through."
	icon_state = "barricade"
	density = TRUE
	anchored = TRUE

	light_color = "#01ACFE"

	health = 50

/obj/structure/swarmer/barricade/CanPass(atom/movable/mover)
	if(HAS_PASS_FLAGS(mover, PASS_FLAG_SWARMER))
		return TRUE
	return ..()