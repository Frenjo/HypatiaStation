/mob/living/simple/hostile/tree
	name = "pine tree"
	desc = "A pissed off tree-like alien. It seems annoyed with the festivities..."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	icon_living = "pine_1"
	icon_dead = "pine_1"
	icon_gib = "pine_1"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_holder/food/snacks/carpmeat
	response_help = "brushes the"
	response_disarm = "pushes the"
	response_harm = "hits the"
	speed = -1
	maxHealth = 250
	health = 250

	pixel_x = -16

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "bites"
	attack_sound = 'sound/weapons/melee/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0

	faction = "carp"

/mob/living/simple/hostile/tree/FindTarget()
	. = ..()
	if(.)
		emote("growls at [.]")

/mob/living/simple/hostile/tree/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))

/mob/living/simple/hostile/tree/death()
	..(null, "is hacked into pieces!")
	new /obj/item/stack/sheet/wood(loc)
	qdel(src)