

/obj/item/projectile/jungle_spear
	damage = 10
	damage_type = TOX
	icon_state = "bullet"

/obj/effect/jungle_tribe_spawn
	name = "campfire"
	desc = "Looks cosy, in an alien sort of way."
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "campfire"
	anchored = TRUE
	var/list/tribesmen = list()
	var/list/enemy_players = list()
	var/tribe_type = 1

/obj/effect/jungle_tribe_spawn/New()
	tribe_type = rand(1, 5)

	var/num_tribesmen = rand(3, 6)
	for(var/i = 0, i < num_tribesmen, i++)
		var/mob/living/simple/hostile/tribesman/T = new(src.loc)
		T.my_type = tribe_type
		T.x += rand(-6, 6)
		T.y += rand(-6, 6)
		tribesmen += T

/obj/effect/jungle_tribe_spawn/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/effect/jungle_tribe_spawn/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/jungle_tribe_spawn/process()
	set background = BACKGROUND_ENABLED
	for(var/mob/living/simple/hostile/tribesman/T in tribesmen)
		if(T.stat == DEAD)
			tribesmen.Remove(T)
			spawn(rand(50, 300))
				var/mob/living/simple/hostile/tribesman/B = new(src.loc)
				B.my_type = tribe_type
				B.x += rand(-4, 4)
				B.y += rand(-4, 4)
				tribesmen += B


/mob/living/simple/hostile/tribesman
	name = "tribesman"
	desc = "A noble savage, doesn't seem to know what to make of you."
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "native1"
	icon_living = "native1"
	icon_dead = "native1_dead"
	speak_chance = 25
	speak = list("Rong a'hu dong'a sik?", "Ahi set mep'a teth.", "Ohen nek'ti ep esi.")
	speak_emote = list("chatters")
	emote_hear = list("chatters to themselves", "chatters away at something", "whistles")
	emote_see = list("bends down to examine something")
	melee_damage_lower = 5
	melee_damage_upper = 15
	turns_per_move = 1
	stop_automated_movement_when_pulled = 0
	var/my_type = 1

/mob/living/simple/hostile/tribesman/New()
	if(prob(33))
		ranged = 1

	spawn(8)
		icon_state = "native[my_type]"
		icon_living = "native[my_type]"
		icon_dead = "native[my_type]_dead"

/mob/living/simple/hostile/tribesman/ListTargets()
	var/list/targets = list()
	for(var/mob/living/simple/hostile/H in view(src, 10))
		if(istype(H, /mob/living/simple/hostile/tribesman))
			continue
		targets += H
	return targets

/mob/living/simple/hostile/tribesman/FindTarget()
	. = ..()
	if(.)
		emote("waves a spear at [.]")

/mob/living/simple/hostile/tribesman/OpenFire(target_mob)
	visible_message(SPAN_WARNING("\red <b>[src]</b> throws a spear at [target_mob]!"), 1)
	flick(src, "native[my_type]_act")

	var/tturf = GET_TURF(target_mob)
	Shoot(tturf, src.loc, src)
