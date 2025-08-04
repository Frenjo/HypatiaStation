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

	var/obj/item/udder/udder = null

/mob/living/simple/cow/New()
	. = ..()
	udder = new /obj/item/udder(src)

/mob/living/simple/cow/attack_by(obj/item/I, mob/user)
	if(stat == CONSCIOUS && istype(I, /obj/item/reagent_holder/glass))
		udder.milk_animal(I, user)
		return TRUE
	return ..()

/mob/living/simple/cow/Life()
	. = ..()
	if(stat == CONSCIOUS)
		udder.generate_milk()

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
				to_chat(M, pick(responses))
	else
		..()

// The cow's udder.
/obj/item/udder
	name = "cow udder"

	var/mob/owner = null

/obj/item/udder/New(loc)
	. = ..(loc)
	create_reagents(50)
	owner = loc

/obj/item/udder/proc/generate_milk()
	if(prob(5))
		reagents.add_reagent("milk", rand(5, 10))

/obj/item/udder/proc/milk_animal(obj/item/I, mob/user)
	user.visible_message(
		SPAN_INFO("[user] milks \the [src] into \the [I]."),
		SPAN_INFO("You milk \the [src] into \the [I].")
	)
	var/obj/item/reagent_holder/glass/G = I
	var/transfered = reagents.trans_to(G, rand(5, 10))
	if(G.reagents.total_volume >= G.volume)
		to_chat(user, SPAN_WARNING("\The [I] is full."))
	if(!transfered)
		to_chat(user, SPAN_WARNING("\The [src] is dry. Wait a bit longer..."))