
//spawns one of the specified animal type
/obj/effect/landmark/animal_spawner
	icon_state = "x3"
	var/spawn_type
	var/mob/living/spawned_animal
	invisibility = INVISIBILITY_MAXIMUM

/obj/effect/landmark/animal_spawner/initialise()
	. = ..()
	if(!spawn_type)
		var/new_type = pick(subtypesof(/obj/effect/landmark/animal_spawner))
		new new_type(GET_TURF(src))
		qdel(src)
	spawned_animal = new spawn_type(GET_TURF(src))
	START_PROCESSING(PCobj, src)

/obj/effect/landmark/animal_spawner/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/landmark/animal_spawner/process()
	//if any of our animals are killed, spawn new ones
	if(!spawned_animal || spawned_animal.stat == DEAD)
		spawned_animal = new spawn_type(src)
		//after a random timeout, and in a random position (6-30 seconds)
		spawn(rand(1200,2400))
			spawned_animal.forceMove(locate(src.x + rand(-12,12), src.y + rand(-12,12), src.z))

/obj/effect/landmark/animal_spawner/Destroy()
	spawned_animal = null
	return ..()

/obj/effect/landmark/animal_spawner/panther
	name = "panther spawner"
	spawn_type = /mob/living/simple/hostile/panther

/obj/effect/landmark/animal_spawner/parrot
	name = "parrot spawner"
	spawn_type = /mob/living/simple/parrot

/obj/effect/landmark/animal_spawner/monkey
	name = "monkey spawner"
	spawn_type = /mob/living/carbon/monkey

/obj/effect/landmark/animal_spawner/snake
	name = "snake spawner"
	spawn_type = /mob/living/simple/hostile/snake


//*********//
// Panther //
//*********//

/mob/living/simple/hostile/panther
	name = "panther"
	desc = "A long sleek, black cat with sharp teeth and claws."
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther_dead"
	icon_gib = "panther_dead"
	speak_chance = 0
	turns_per_move = 3
	meat_type = /obj/item/reagent_holder/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 50
	health = 50

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "slashes"
	attack_sound = 'sound/weapons/melee/bite.ogg'

	layer = 3.1		//so they can stay hidde under the /obj/structure/bush
	var/stalk_tick_delay = 3

/mob/living/simple/hostile/panther/list_targets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(src, vision_range))
		targets += H
	return targets

/mob/living/simple/hostile/panther/FindTarget()
	. = ..()
	if(.)
		emote("nashes at [.]")

/mob/living/simple/hostile/panther/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))

/mob/living/simple/hostile/panther/AttackTarget()
	..()
	if(stance == HOSTILE_STANCE_ATTACKING && get_dist(src, target))
		stalk_tick_delay -= 1
		if(stalk_tick_delay <= 0)
			forceMove(get_step_towards(src, target))
			stalk_tick_delay = 3

//*******//
// Snake //
//*******//

/mob/living/simple/hostile/snake
	name = "snake"
	desc = "A sinuously coiled, venomous looking reptile."
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake_dead"
	icon_gib = "snake_dead"
	speak_chance = 0
	turns_per_move = 1
	meat_type = /obj/item/reagent_holder/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 25
	health = 25

	harm_intent_damage = 2
	melee_damage_lower = 3
	melee_damage_upper = 10
	attacktext = "bites"
	attack_sound = 'sound/weapons/melee/bite.ogg'

	layer = 3.1		//so they can stay hidde under the /obj/structure/bush
	var/stalk_tick_delay = 3

/mob/living/simple/hostile/snake/list_targets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(src, vision_range))
		targets += H
	return targets

/mob/living/simple/hostile/snake/FindTarget()
	. = ..()
	if(.)
		emote("hisses wickedly")

/mob/living/simple/hostile/snake/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		L.apply_damage(rand(3,12), TOX)

/mob/living/simple/hostile/snake/AttackTarget()
	..()
	if(stance == HOSTILE_STANCE_ATTACKING && get_dist(src, target))
		stalk_tick_delay -= 1
		if(stalk_tick_delay <= 0)
			forceMove(get_step_towards(src, target))
			stalk_tick_delay = 3