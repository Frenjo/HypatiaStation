/mob/living/simple/hostile/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pushes the"
	response_disarm = "shoves"
	response_harm = "hits the"
	speed = 4
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "slashes"
	attack_sound = 'sound/weapons/melee/bladeslice.ogg'

	min_oxy = 5
	max_tox = 1
	max_co2 = 5
	unsuitable_atoms_damage = 15

	factions = list("pirate")

	var/corpse = /obj/effect/landmark/mobcorpse/pirate
	var/weapon1 = /obj/item/melee/energy/sword/pirate

/mob/living/simple/hostile/pirate/ranged
	name = "Pirate Gunner"
	icon_state = "pirateranged"
	icon_living = "pirateranged"
	icon_dead = "piratemelee_dead"
	projectilesound = 'sound/weapons/gun/laser.ogg'
	ranged = 1
	rapid = 1
	projectiletype = /obj/projectile/energy/beam/laser
	corpse = /obj/effect/landmark/mobcorpse/pirate/ranged
	weapon1 = /obj/item/gun/energy/laser


/mob/living/simple/hostile/pirate/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	qdel(src)
	return