/mob/living/simple/hostile/asteroid/basilisk
	name = "basilisk"
	desc = "A territorial beast, covered in a thick shell that absorbs energy. Its stare causes victims to freeze from the inside."

	icon = 'icons/mob/simple/mining.dmi'
	icon_state = "basilisk"
	icon_living = "basilisk"
	icon_aggro = "basilisk_alert"
	icon_dead = "basilisk_dead"

	move_to_delay = 20
	projectiletype = /obj/item/projectile/temp/basilisk
	projectilesound = 'sound/weapons/melee/pierce.ogg'
	ranged = TRUE
	ranged_message = "stares"
	throw_message = "rebounds off its hard shell to no effect"
	vision_range = 2
	speed = 3

	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bites into"
	a_intent = "harm"
	attack_sound = 'sound/weapons/melee/bladeslice.ogg'

/mob/living/simple/hostile/asteroid/basilisk/death(gibbed)
	. = ..()
	for(var/i = 0, i < 2, i++) // Drops some diamonds on death.
		new /obj/item/ore/diamond(loc)

/mob/living/simple/hostile/asteroid/basilisk/give_target(new_target)
	target = new_target
	if(isnull(target))
		return

	aggro()
	stance = HOSTILE_STANCE_ATTACK
	if(isliving(target))
		var/mob/living/L = target
		if(L.bodytemperature > 261)
			L.bodytemperature = 261
			visible_message(SPAN_DANGER("\The [src]'s stare chills \the [L] to the bone!"))

/obj/item/projectile/temp/basilisk
	name = "freezing blast"
	temperature = 50