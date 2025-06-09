/mob/living/simple/hostile/asteroid/hivelord
	name = "hivelord"
	desc = "A truly alien creature, it is a mass of unknown organic material, constantly fluctuating. When attacking, pieces of it split off and attack in tandem with the original."

	pass_flags = PASS_FLAG_TABLE

	icon_state = "hivelord"
	icon_living = "hivelord"
	icon_dead = "hivelord_dead"

	a_intent = "harm"

	maxHealth = 75
	health = 75

	move_to_delay = 12
	ranged = TRUE
	vision_range = 5
	speed = 3

	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 2
	attacktext = "lashes out at"

	aggro_vision_range = 9
	idle_vision_range = 5
	icon_aggro = "hivelord_alert"
	throw_message = "falls right through the strange body of the"

/mob/living/simple/hostile/asteroid/hivelord/Die()
	new /obj/item/hivelord_core(GET_TURF(src)) // Drops a hivelord core on death.
	. = ..()

/mob/living/simple/hostile/asteroid/hivelord/OpenFire(target_mob)
	var/mob/living/simple/hostile/asteroid/hivelord_brood/brood = new /mob/living/simple/hostile/asteroid/hivelord_brood(GET_TURF(src))
	brood.give_target(target_mob)

/mob/living/simple/hostile/asteroid/hivelord/AttackingTarget()
	. = ..()
	OpenFire()

// Brood
/mob/living/simple/hostile/asteroid/hivelord_brood
	name = "hivelord brood"
	desc = "A fragment of the original Hivelord, rallying behind its original. One isn't much of a threat, but..."

	pass_flags = PASS_FLAG_TABLE

	icon_state = "hivelord_brood"
	icon_living = "hivelord_brood"
	icon_dead = "hivelord_brood"

	a_intent = "harm"

	maxHealth = 1
	health = 1

	move_to_delay = 0
	friendly = "buzzes near"
	vision_range = 10
	speed = 3

	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 2
	attacktext = "slashes"

	icon_aggro = "hivelord_brood"
	throw_message = "falls right through the strange body of the"

/mob/living/simple/hostile/asteroid/hivelord_brood/New()
	. = ..()
	spawn(10 SECONDS)
		qdel(src)

/mob/living/simple/hostile/asteroid/hivelord_brood/Die()
	qdel(src)

// Core
/obj/item/hivelord_core
	name = "hivelord core"
	desc = "All that remains of a hivelord, it seems to be what allows it to break pieces of itself off without being hurt. Its healing properties will soon become inert if not consumed quickly, but try not to think about what you're eating..."
	icon = 'icons/obj/items/food.dmi'
	icon_state = "boiledrorocore"

	item_flags = ITEM_FLAG_NO_BLUDGEON

	origin_tech = alist(/decl/tech/biotech = 3)

	var/inert = FALSE

/obj/item/hivelord_core/initialise()
	. = ..()
	spawn(2 MINUTES)
		inert = TRUE
		desc = "The remains of a hivelord that have become useless, having been left alone too long after being harvested."

/obj/item/hivelord_core/attack(mob/living/target, mob/living/user)
	if(ishuman(target))
		var/mob/living/carbon/human/hugh = target
		if(inert)
			to_chat(user, SPAN_WARNING("\The [src] has become inert, its healing properties are no more."))
			return
		if(hugh.stat == DEAD)
			to_chat(user, SPAN_WARNING("\The [src] is useless on the dead."))
			return
		if(hugh != user)
			user.visible_message(
				SPAN_NOTICE("[user] forces [hugh] to eat \the [src], quickly regenerating all of their injuries!"),
				SPAN_NOTICE("You force [hugh] to eat \the [src], quickly regenerating all of their injuries!"),
				SPAN_INFO("You hear crunching.")
			)
		else
			to_chat(user, SPAN_NOTICE("You chomp into \the [src], barely managing to hold it down, but feel amazingly refreshed in mere moments."))
		playsound(loc,'sound/items/eatfood.ogg', rand(10, 50), TRUE)
		hugh.revive()
		qdel(src)
	. = ..()