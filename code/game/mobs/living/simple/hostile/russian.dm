/mob/living/simple/hostile/russian
	name = "Russian"
	desc = "For the Motherland!"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes the"
	response_disarm = "shoves the"
	response_harm = "hits the"
	speed = 4
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "punches"
	a_intent = "harm"

	unsuitable_atoms_damage = 15
	faction = "russian"
	status_flags = CANPUSH

	var/corpse = /obj/effect/landmark/mobcorpse/russian
	var/weapon1 = /obj/item/kitchenknife

/mob/living/simple/hostile/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"
	corpse = /obj/effect/landmark/mobcorpse/russian/ranged
	weapon1 = /obj/item/gun/projectile/mateba
	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/gun/gunshot.ogg'
	casingtype = /obj/item/ammo_casing/a357


/mob/living/simple/hostile/russian/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	qdel(src)
	return