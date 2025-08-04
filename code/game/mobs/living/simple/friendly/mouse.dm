/mob/living/simple/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small, disease-ridden rodent."
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	pass_flags = PASS_FLAG_TABLE
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	small = 1
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	meat_type = /obj/item/reagent_holder/food/snacks/meat
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "stamps on the"
	density = FALSE
	var/body_color //brown, gray and white, leave blank for random
	layer = MOB_LAYER
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1

/mob/living/simple/mouse/Life()
	..()
	if(!stat && prob(speak_chance))
		for(var/mob/M in view())
			SOUND_TO(M, 'sound/effects/mousesqueek.ogg')

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		stat = UNCONSCIOUS
		icon_state = "mouse_[body_color]_sleep"
		wander = FALSE
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			stat = CONSCIOUS
			icon_state = "mouse_[body_color]"
			wander = TRUE
		else if(prob(5))
			emote("snuffles")

/mob/living/simple/mouse/New()
	..()
	name = "[name] ([rand(1, 1000)])"
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."


/mob/living/simple/mouse/proc/splat()
	src.health = 0
	src.stat = DEAD
	src.icon_dead = "mouse_[body_color]_splat"
	src.icon_state = "mouse_[body_color]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

/mob/living/simple/mouse/start_pulling(atom/movable/AM)//Prevents mouse from pulling things
	to_chat(src, SPAN_WARNING("You are too small to pull anything."))

/mob/living/simple/mouse/Crossed(atom/movable/AM)
	if(ishuman(AM))
		if(!stat)
			var/mob/M = AM
			to_chat(M, SPAN_INFO("[icon2html(src, M)] Squeek!"))
			SOUND_TO(M, 'sound/effects/mousesqueek.ogg')
	..()

/mob/living/simple/mouse/Die()
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time
	..()

/*
 * Mouse types
 */

/mob/living/simple/mouse/white
	body_color = "white"
	icon_state = "mouse_white"

/mob/living/simple/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"

/mob/living/carbon/alien/can_use_vents()
	return