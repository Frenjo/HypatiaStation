

/mob/living/simple/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_holder/food/snacks/carpmeat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bites"
	attack_sound = 'sound/weapons/melee/bite.ogg'

	// Space carp aren't affected by atmos.
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0

	break_stuff_probability = 2

	faction = "carp"

/mob/living/simple/hostile/carp/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple/hostile/carp/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"nashes at [.]")

/mob/living/simple/hostile/carp/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))