//goat
/mob/living/simple/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_holder/food/snacks/meat
	meat_amount = 4
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	faction = "goat"
	attacktext = "kicks"
	health = 40
	melee_damage_lower = 1
	melee_damage_upper = 5
	var/datum/reagents/udder = null

/mob/living/simple/hostile/retaliate/goat/New()
	udder = new(50)
	udder.my_atom = src
	..()

/mob/living/simple/hostile/retaliate/goat/Life()
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!length(enemies) && prob(1))
			Retaliate()

		if(length(enemies) && prob(10))
			enemies = list()
			LoseTarget()
			src.visible_message("\blue [src] calms down.")

		if(stat == CONSCIOUS)
			if(udder && prob(5))
				udder.add_reagent("milk", rand(5, 10))

		if(locate(/obj/effect/spacevine) in loc)
			var/obj/effect/spacevine/SV = locate(/obj/effect/spacevine) in loc
			qdel(SV)
			if(prob(10))
				say("Nom")

		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/effect/spacevine) in step)
						Move(step)

/mob/living/simple/hostile/retaliate/goat/Retaliate()
	..()
	src.visible_message("\red [src] gets an evil-looking gleam in their eye.")

/mob/living/simple/hostile/retaliate/goat/Move()
	..()
	if(!stat)
		if(locate(/obj/effect/spacevine) in loc)
			var/obj/effect/spacevine/SV = locate(/obj/effect/spacevine) in loc
			qdel(SV)
			if(prob(10))
				say("Nom")

/mob/living/simple/hostile/retaliate/goat/attackby(obj/item/O, mob/user)
	if(stat == CONSCIOUS && istype(O, /obj/item/reagent_holder/glass))
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/obj/item/reagent_holder/glass/G = O
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			user << "\red The [O] is full."
		if(!transfered)
			user << "\red The udder is dry. Wait a bit longer..."
	else
		..()