
/turf/open/jungle
	var/bushes_spawn = 1
	var/plants_spawn = 1
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "grass1"
	var/icon_spawn_state = "grass1"
	//luminosity = 3
	light_range = 3

/turf/open/jungle/New()
	icon_state = icon_spawn_state

	if(plants_spawn && prob(40))
		if(prob(90))
			var/image/I
			if(prob(35))
				I = image('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi', "plant[rand(1,7)]")
			else
				if(prob(30))
					I = image('icons/obj/flora/ausflora.dmi', "reedbush_[rand(1,4)]")
				else if(prob(33))
					I = image('icons/obj/flora/ausflora.dmi', "leafybush_[rand(1,3)]")
				else if(prob(50))
					I = image('icons/obj/flora/ausflora.dmi', "fernybush_[rand(1,3)]")
				else
					I = image('icons/obj/flora/ausflora.dmi', "stalkybush_[rand(1,3)]")
			I.pixel_x = rand(-6, 6)
			I.pixel_y = rand(-6, 6)
			overlays += I
		else
			var/obj/structure/jungle_plant/J = new(src)
			J.pixel_x = rand(-6, 6)
			J.pixel_y = rand(-6, 6)
	if(bushes_spawn && prob(90))
		new /obj/structure/bush(src)

/turf/open/jungle/clear
	bushes_spawn = 0
	plants_spawn = 0
	icon_state = "grass_clear"
	icon_spawn_state = "grass3"

/turf/open/jungle/path
	bushes_spawn = 0
	name = "wet grass"
	desc = "thick, long wet grass"
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "grass_path"
	icon_spawn_state = "grass2"

/turf/open/jungle/path/New()
	..()
	for(var/obj/structure/bush/B in src)
		qdel(B)

/turf/open/jungle/proc/Spread(probability, prob_loss = 50)
	if(probability <= 0)
		return

	//to_world("\blue Spread([probability])")
	for(var/turf/open/jungle/J in orange(1, src))
		if(!J.bushes_spawn)
			continue

		var/turf/open/jungle/P = null
		if(J.type == src.type)
			P = J
		else
			P = new src.type(J)

		if(P && prob(probability))
			P.Spread(probability - prob_loss)

/turf/open/jungle/impenetrable
	bushes_spawn = 0
	icon_state = "grass_impenetrable"
	icon_spawn_state = "grass1"

/turf/open/jungle/impenetrable/New()
	..()
	var/obj/structure/bush/B = new /obj/structure/bush(src)
	B.indestructible = 1

//copy paste from asteroid mineral turfs
/turf/open/jungle/rock
	bushes_spawn = 0
	plants_spawn = 0
	density = TRUE
	name = "rock wall"
	icon = 'icons/turf/walls/rocks_ores.dmi'
	icon_state = "rock"
	icon_spawn_state = "rock"

/turf/open/jungle/rock/New()
	spawn(1)
		var/turf/T
		if(!istype(get_step(src, NORTH), /turf/open/jungle/rock) && !istype(get_step(src, NORTH), /turf/closed/wall/reinforced/riveted))
			T = get_step(src, NORTH)
			if(T)
				T.overlays += image(icon, "rock_side_s")
		if(!istype(get_step(src, SOUTH), /turf/open/jungle/rock) && !istype(get_step(src, SOUTH), /turf/closed/wall/reinforced/riveted))
			T = get_step(src, SOUTH)
			if(T)
				T.overlays += image(icon, "rock_side_n", layer = 6)
		if(!istype(get_step(src, EAST), /turf/open/jungle/rock) && !istype(get_step(src, EAST), /turf/closed/wall/reinforced/riveted))
			T = get_step(src, EAST)
			if(T)
				T.overlays += image(icon, "rock_side_w", layer = 6)
		if(!istype(get_step(src, WEST), /turf/open/jungle/rock) && !istype(get_step(src, WEST), /turf/closed/wall/reinforced/riveted))
			T = get_step(src, WEST)
			if(T)
				T.overlays += image(icon, "rock_side_e", layer = 6)

/turf/open/jungle/water
	bushes_spawn = 0
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/misc/beach.dmi'
	icon_state = "water"
	icon_spawn_state = "water"

/turf/open/jungle/water/New()
	..()
	for(var/obj/structure/bush/B in src)
		qdel(B)

/turf/open/jungle/water/Entered(atom/movable/O)
	..()
	if(isliving(O))
		var/mob/living/M = O
		//slip in the murky water if we try to run through it
		if(prob(10 + (IS_RUNNING(M) ? 40 : 0)))
			to_chat(M, pick(SPAN_INFO("You slip on something slimy."), SPAN_INFO("You fall over into the murk.")))
			M.Stun(2)
			M.Weaken(1)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25))
			to_chat(M, SPAN_INFO("You feel something slithering around your legs."))
			if(prob(50))
				spawn(rand(25, 50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_WARNING("Something sharp bites you!"), SPAN_WARNING("Sharp teeth grab hold of you!"), SPAN_WARNING("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0, 1), BRUTE, sharp = 1)
			if(prob(50))
				spawn(rand(25, 50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_WARNING("Something sharp bites you!"), SPAN_WARNING("Sharp teeth grab hold of you!"), SPAN_WARNING("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0, 1), BRUTE, sharp = 1)
			if(prob(50))
				spawn(rand(25, 50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_WARNING("Something sharp bites you!"), SPAN_WARNING("Sharp teeth grab hold of you!"), SPAN_WARNING("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0, 1), BRUTE, sharp = 1)
			if(prob(50))
				spawn(rand(25, 50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_WARNING("Something sharp bites you!"), SPAN_WARNING("Sharp teeth grab hold of you!"), SPAN_WARNING("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0, 1), BRUTE, sharp = 1)

/turf/open/jungle/water/deep
	plants_spawn = 0
	density = TRUE
	icon_state = "water2"
	icon_spawn_state = "water2"

/turf/open/jungle/temple_wall
	name = "temple wall"
	desc = ""
	density = TRUE
	icon = 'icons/turf/walls.dmi'
	icon_state = "plasma0"
	var/mineral = /decl/material/plasma
