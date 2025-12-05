//
// Abstract Class
//

/mob/living/simple/hostile/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage/crate.dmi'
	icon_state = "crate"
	icon_living = "crate"

	meat_type = /obj/item/reagent_holder/food/snacks/carpmeat
	response_help = "touches the"
	response_disarm = "pushes the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 250
	health = 250

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "attacks"
	attack_sound = 'sound/weapons/melee/bite.ogg'

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0

	factions = list("mimic")
	move_to_delay = 8

/mob/living/simple/hostile/mimic/FindTarget()
	. = ..()
	if(.)
		emote("growls at [.]")

/mob/living/simple/hostile/mimic/death()
	..()
	qdel(src)

//
// Crate Mimic
//


// Aggro when you try to open them. Will also pickup loot when spawns and drop it when dies.
/mob/living/simple/hostile/mimic/crate

	attacktext = "bites"

	stop_automated_movement = TRUE
	wander = FALSE
	var/attempt_open = 0

// Pickup loot
/mob/living/simple/hostile/mimic/crate/initialise()
	. = ..()
	for(var/obj/item/I in loc)
		I.forceMove(src)

/mob/living/simple/hostile/mimic/crate/DestroySurroundings()
	..()
	if(prob(90))
		icon_state = "[initial(icon_state)]open"
	else
		icon_state = initial(icon_state)

/mob/living/simple/hostile/mimic/crate/list_targets()
	if(attempt_open)
		return ..()
	return ..(1)

/mob/living/simple/hostile/mimic/crate/FindTarget()
	. = ..()
	if(.)
		trigger()

/mob/living/simple/hostile/mimic/crate/AttackingTarget()
	. = ..()
	if(.)
		icon_state = initial(icon_state)

/mob/living/simple/hostile/mimic/crate/proc/trigger()
	if(!attempt_open)
		visible_message("<b>[src]</b> starts to move!")
		attempt_open = 1

/mob/living/simple/hostile/mimic/crate/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple/hostile/mimic/crate/LoseTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple/hostile/mimic/crate/LostTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple/hostile/mimic/crate/Die()

	var/obj/structure/closet/crate/C = new /obj/structure/closet/crate(GET_TURF(src))
	// Put loot in crate
	for(var/obj/O in src)
		O.forceMove(C)
	..()

/mob/living/simple/hostile/mimic/crate/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(2)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))

//
// Copy Mimic
//

var/global/list/protected_objects = list(/obj/structure/table, /obj/structure/cable, /obj/structure/window)

/mob/living/simple/hostile/mimic/copy

	health = 100
	maxHealth = 100
	var/mob/living/creator = null // the creator
	var/destroy_objects = 0
	var/knockdown_people = 0

/mob/living/simple/hostile/mimic/copy/New(loc, var/obj/copy, var/mob/living/creator)
	..(loc)
	CopyObject(copy, creator)

/mob/living/simple/hostile/mimic/copy/Die()
	var/turf/T = GET_TURF(src)
	for_no_type_check(var/atom/movable/mover, src)
		mover.forceMove(T)
	..()

/mob/living/simple/hostile/mimic/copy/list_targets()
	// Return a list of targets that isn't the creator
	. = ..()
	return . - creator

/mob/living/simple/hostile/mimic/copy/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((isitem(O) || istype(O, /obj/structure)) && !is_type_in_list(O, protected_objects))
		O.forceMove(src)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		icon_living = icon_state

		if(istype(O, /obj/structure))
			health = (anchored * 50) + 50
			destroy_objects = 1
			if(O.density && O.anchored)
				knockdown_people = 1
				melee_damage_lower *= 2
				melee_damage_upper *= 2
		else if(isitem(O))
			var/obj/item/I = O
			health = 15 * I.w_class
			melee_damage_lower = 2 + I.force
			melee_damage_upper = 2 + I.force
			move_to_delay = 2 * I.w_class

		maxHealth = health
		if(creator)
			src.creator = creator
			factions += "\ref[creator]" // very unique
		return 1
	return

/mob/living/simple/hostile/mimic/copy/DestroySurroundings()
	if(destroy_objects)
		..()

/mob/living/simple/hostile/mimic/copy/AttackingTarget()
	. =..()
	if(knockdown_people)
		var/mob/living/L = .
		if(istype(L))
			if(prob(15))
				L.Weaken(1)
				L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))