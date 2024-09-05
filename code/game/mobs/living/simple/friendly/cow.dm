//cow
/mob/living/simple/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_holder/food/snacks/meat
	meat_amount = 6
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 50
	var/datum/reagents/udder = null

/mob/living/simple/cow/New()
	udder = new(50)
	udder.my_atom = src
	..()

/mob/living/simple/cow/attackby(obj/item/O, mob/user)
	if(stat == CONSCIOUS && istype(O, /obj/item/reagent_holder/glass))
		user.visible_message(SPAN_NOTICE("[user] milks [src] using \the [O]."))
		var/obj/item/reagent_holder/glass/G = O
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_WARNING("The [O] is full."))
		if(!transfered)
			to_chat(user, SPAN_WARNING("The udder is dry. Wait a bit longer..."))
	else
		..()

/mob/living/simple/cow/Life()
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(5))
			udder.add_reagent("milk", rand(5, 10))

/mob/living/simple/cow/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == "disarm" && icon_state != icon_dead)
		M.visible_message(
			SPAN_WARNING("[M] tips over [src]."),
			SPAN_NOTICE("You tip over [src].")
		)
		Weaken(30)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list(
					"[src] looks at you imploringly.",
					"[src] looks at you pleadingly",
					"[src] looks at you with a resigned expression.",
					"[src] seems resigned to its fate."
				)
				M << pick(responses)
	else
		..()