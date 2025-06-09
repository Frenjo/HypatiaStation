/mob/living/simple/hostile/asteroid/goliath
	name = "goliath"
	desc = "A massive beast that uses long tentacles to ensare its prey, threatening them is not advised under any conditions."

	icon_state = "goliath"
	icon_living = "goliath"
	icon_dead = "goliath_dead"

	maxHealth = 200
	health = 200

	move_to_delay = 40
	ranged = TRUE
	friendly = "wails at"
	vision_range = 5
	speed = 3

	harm_intent_damage = 0
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "pulverizes"

	icon_aggro = "goliath_alert"

	var/tentacle_recharge = 0

/mob/living/simple/hostile/asteroid/goliath/Die()
	// Drops some hide plates on death.
	new /obj/item/stack/goliath_hide(loc)
	. = ..()

/mob/living/simple/hostile/asteroid/goliath/OpenFire()
	tentacle_recharge--
	if(tentacle_recharge <= 0)
		visible_message(SPAN_WARNING("\The [src] digs its tentacles under \the [target]!"))
		new /obj/effect/goliath_tentacle/original(GET_TURF(target))
		tentacle_recharge = 6

/mob/living/simple/hostile/asteroid/goliath/adjustBruteLoss(damage)
	tentacle_recharge--
	. = ..()

// Tentacle
/obj/effect/goliath_tentacle
	name = "goliath tentacle"
	icon = 'icons/mob/simple/mining.dmi'
	icon_state = "goliath_tentacle"

	anchored = TRUE

/obj/effect/goliath_tentacle/initialise()
	. = ..()
	spawn(20)
		Trip()

/obj/effect/goliath_tentacle/proc/Trip()
	for(var/mob/living/M in loc)
		M.Weaken(5)
		visible_message(SPAN_WARNING("\The [src] knocks \the [M] down!"))
	qdel(src)

/obj/effect/goliath_tentacle/Crossed(atom/movable/mover)
	if(isliving(mover))
		Trip()
		return
	. = ..()

/obj/effect/goliath_tentacle/original/New()
	var/list/directions = GLOBL.cardinal.Copy()
	for(var/counter = 1, counter <= 3, counter++)
		var/spawn_dir = pick(directions)
		directions.Remove(spawn_dir)
		var/turf/T = get_step(src, spawn_dir)
		new /obj/effect/goliath_tentacle(T)
	. = ..()

// Hide
/obj/item/stack/goliath_hide
	name = "goliath hide plates"
	desc = "Pieces of a goliath's rocky hide, these might be able to make something a bit more durable to attack from the local fauna."
	icon = 'icons/obj/items/stacks/mining.dmi'
	icon_state = "goliath_hide"

	item_flags = ITEM_FLAG_NO_BLUDGEON

	origin_tech = alist(/decl/tech/biotech = 3)