/var/const/MAX_CHICKENS = 50
GLOBAL_GLOBL_INIT(chicken_count, 0)

// Chickens
/mob/living/simple/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	pass_flags = PASS_FLAG_TABLE
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	speak_chance = 2
	turns_per_move = 3
	meat_type = /obj/item/reagent_holder/food/snacks/meat
	meat_amount = 2
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 10
	var/eggsleft = 0
	var/body_color
	small = 1

/mob/living/simple/chicken/New()
	..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "chicken_[body_color]"
	icon_living = "chicken_[body_color]"
	icon_dead = "chicken_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOBL.chicken_count += 1

/mob/living/simple/chicken/Die()
	..()
	GLOBL.chicken_count -= 1

/mob/living/simple/chicken/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_holder/food/snacks/grown/wheat)) //feedin' dem chickens
		if(!stat && eggsleft < 8)
			user.visible_message(
				SPAN_INFO("[user] feeds \the [I] to \the [src]! It clucks happily."),
				SPAN_INFO("You feed \the [I] to \the [src]! It clucks happily."),
				SPAN_INFO("You hear rustling, followed by a chicken clucking happily.")
			)
			user.drop_item()
			qdel(I)
			eggsleft += rand(1, 4)
			//to_world(eggsleft)
		else
			to_chat(user, SPAN_INFO("\The [src] doesn't seem hungry..."))
		return TRUE

	return ..()

/mob/living/simple/chicken/Life()
	. =..()
	if(!.)
		return
	if(!stat && prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/reagent_holder/food/snacks/egg/E = new /obj/item/reagent_holder/food/snacks/egg(GET_TURF(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(GLOBL.chicken_count < MAX_CHICKENS && prob(10))
			START_PROCESSING(PCobj, E)

/obj/item/reagent_holder/food/snacks/egg/var/amount_grown = 0
/obj/item/reagent_holder/food/snacks/egg/process()
	if(!isturf(loc))
		return PROCESS_KILL
	amount_grown += rand(1,2)
	if(amount_grown >= 100)
		visible_message("[src] hatches with a quiet cracking sound.")
		new /mob/living/simple/chick(GET_TURF(src))
		qdel(src)
		return PROCESS_KILL

// Chicks
/mob/living/simple/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps")
	emote_see = list("pecks at the ground","flaps its tiny wings")
	speak_chance = 2
	turns_per_move = 2
	meat_type = /obj/item/reagent_holder/food/snacks/meat
	meat_amount = 1
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 1
	var/amount_grown = 0
	small = 1

/mob/living/simple/chick/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple/chick/Life()
	. =..()
	if(!.)
		return
	if(!stat)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple/chicken(src.loc)
			qdel(src)