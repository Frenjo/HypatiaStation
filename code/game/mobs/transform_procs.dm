/mob/living/carbon/human/proc/monkeyize()
	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		if(W == wear_uniform) // will be torn
			continue
		drop_from_inventory(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = FALSE
	stunned = 1
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in organs)
		qdel(t)
	var/atom/movable/overlay/animation = new /atom/movable/overlay(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null

	if(!species.primitive) //If the creature in question has no primitive set, this is going to be messy.
		gib()
		return

	var/mob/living/carbon/monkey/O = null

	O = new species.primitive(loc)

	O.dna = dna.Clone()
	O.dna.SetSEState(GLOBL.dna_data.monkey_block, 1)
	O.dna.SetSEValueRange(GLOBL.dna_data.monkey_block, 0xDAC, 0xFFF)
	O.forceMove(loc)
	O.viruses = viruses
	O.a_intent = "hurt"

	for(var/datum/disease/D in O.viruses)
		D.affected_mob = O

	if(client)
		client.mob = O
	if(mind)
		mind.transfer_to(O)

	to_chat(O, "You are now [O].")

	spawn(0)//To prevent the proc from returning null.
		qdel(src)
	qdel(animation)

	return O

/mob/dead/new_player/AIize()
	spawning = TRUE
	return ..()

/mob/living/carbon/human/AIize()
	if(monkeyizing)
		return
	for(var/t in organs)
		qdel(t)

	return ..()

/mob/living/carbon/AIize()
	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	return ..()

/mob/proc/AIize()
	if(client)
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // stop the jams for AIs
	var/mob/living/silicon/ai/O = new(loc, BASE_LAW_TYPE, , 1)//No MMI but safety is in effect.
	O.invisibility = 0
	O.aiRestorePowerRoutine = AI_POWER_RESTORATION_OFF

	if(mind)
		mind.transfer_to(O)
		O.mind.original = O
	else
		O.key = key

	var/obj/loc_landmark
	for(var/obj/effect/landmark/start/sloc in GLOBL.landmark_list)
		if(sloc.name != "AI")
			continue
		if(locate(/mob/living) in sloc.loc)
			continue
		loc_landmark = sloc
	if(!loc_landmark)
		for_no_type_check(var/obj/effect/landmark/tripai, GLOBL.landmark_list)
			if(tripai.name == "tripai")
				if(locate(/mob/living) in tripai.loc)
					continue
				loc_landmark = tripai
	if(!loc_landmark)
		to_chat(O, "Oh god sorry we can't find an unoccupied AI spawn location, so we're spawning you on top of someone.")
		for(var/obj/effect/landmark/start/sloc in GLOBL.landmark_list)
			if(sloc.name == "AI")
				loc_landmark = sloc

	O.forceMove(loc_landmark.loc)
	for(var/obj/item/radio/intercom/comm in O.loc)
		comm.ai += O

	to_chat(O, "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
	to_chat(O, "<B>To look at other parts of the station, click on yourself to get a camera menu.</B>")
	to_chat(O, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	to_chat(O, "To use something, simply click on it.")
	to_chat(O, {"Use say ":b to speak to your cyborgs through binary."})
	if(!(O.mind in global.PCticker?.mode?.malf_ai))
		O.show_laws()
		to_chat(O, "<b>These laws may be changed by other players, or by you being the traitor.</b>")

	O.job = "AI"

	O.rename_self("ai", 1)
	. = O
	qdel(src)

//human -> robot
/mob/living/carbon/human/proc/Robotize()
	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in organs)
		qdel(t)

	var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(loc)

	O.gender = gender
	O.invisibility = 0

	if(mind)	//TODO
		mind.transfer_to(O)
		if(O.mind.assigned_role == "Cyborg")
			O.mind.original = O
		else if(mind && mind.special_role)
			O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")
	else
		O.key = key

	O.forceMove(loc)
	O.job = "Cyborg"
	if(O.mind.assigned_role == "Cyborg")
		if(O.mind.role_alt_title == "Android")
			O.mmi = new /obj/item/mmi/posibrain(O)
		if(O.mind.role_alt_title == "Robot")
			O.mmi = new /obj/item/mmi/posibrain(O)	//Ravensdale wants a circuit based brain for another robot class, this is a placeholder.
	else
		O.mmi = new /obj/item/mmi(O)
		O.mmi.transfer_identity(src)	//Does not transfer key/client.

	O.namepick()

	spawn(0)//To prevent the proc from returning null.
		qdel(src)
	return O

//human -> alien
/mob/living/carbon/human/proc/Alienize()
	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in organs)
		qdel(t)

	var/alien_caste = pick("Hunter", "Sentinel", "Drone")
	var/mob/living/carbon/human/new_xeno = create_new_xenomorph(alien_caste, loc)

	new_xeno.a_intent = "hurt"
	new_xeno.key = key

	to_chat(new_xeno, "<B>You are now an alien.</B>")
	spawn(0)//To prevent the proc from returning null.
		qdel(src)
	return

/mob/living/carbon/human/proc/slimeize(adult as num, reproduce as num)
	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in organs)
		qdel(t)

	var/mob/living/carbon/slime/new_slime
	if(reproduce)
		var/number = pick(14;2, 3, 4)	//reproduce (has a small chance of producing 3 or 4 offspring)
		var/list/babies = list()
		for(var/i = 1, i <= number, i++)
			var/mob/living/carbon/slime/M = new/mob/living/carbon/slime(loc)
			M.nutrition = round(nutrition/number)
			step_away(M, src)
			babies += M
		new_slime = pick(babies)
	else
		if(adult)
			new_slime = new /mob/living/carbon/slime/adult(loc)
		else
			new_slime = new /mob/living/carbon/slime(loc)
	new_slime.a_intent = "hurt"
	new_slime.key = key

	to_chat(new_slime, "<B>You are now a slime. Skreee!</B>")
	spawn(0)//To prevent the proc from returning null.
		qdel(src)
	return

/mob/living/carbon/human/proc/corgize()
	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in organs)	//this really should not be necessary
		qdel(t)

	var/mob/living/simple/corgi/new_corgi = new /mob/living/simple/corgi(loc)
	new_corgi.a_intent = "hurt"
	new_corgi.key = key

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
	spawn(0)//To prevent the proc from returning null.
		qdel(src)
	return

/mob/living/carbon/human/Animalize()
	var/list/mobtypes = typesof(/mob/living/simple)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

	if(!safe_animal(mobpath))
		to_chat(usr, SPAN_WARNING("Sorry but this mob type is currently unavailable."))
		return

	if(monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)

	regenerate_icons()
	monkeyizing = 1
	canmove = FALSE
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	for(var/t in organs)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = "hurt"

	to_chat(new_mob, "You suddenly feel more... animalistic.")
	spawn()
		qdel(src)
	return

/mob/proc/Animalize()
	var/list/mobtypes = typesof(/mob/living/simple)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

	if(!safe_animal(mobpath))
		to_chat(usr, SPAN_WARNING("Sorry but this mob type is currently unavailable."))
		return

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = "hurt"
	to_chat(new_mob, "You feel more... animalistic.")

	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldnt be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(MP)
//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return 0	//Sanity, this should never happen.

	if(ispath(MP, /mob/living/simple/space_worm))
		return 0 //Unfinished. Very buggy, they seem to just spawn additional space worms everywhere and eating your own tail results in new worms spawning.

	if(ispath(MP, /mob/living/simple/construct/behemoth))
		return 0 //I think this may have been an unfinished WiP or something. These constructs should really have their own class simple_animal/construct/subtype

	if(ispath(MP, /mob/living/simple/construct/armoured))
		return 0 //Verbs do not appear for players. These constructs should really have their own class simple_animal/construct/subtype

	if(ispath(MP, /mob/living/simple/construct/wraith))
		return 0 //Verbs do not appear for players. These constructs should really have their own class simple_animal/construct/subtype

	if(ispath(MP, /mob/living/simple/construct/builder))
		return 0 //Verbs do not appear for players. These constructs should really have their own class simple_animal/construct/subtype

//Good mobs!
	if(ispath(MP, /mob/living/simple/cat))
		return 1
	if(ispath(MP, /mob/living/simple/corgi))
		return 1
	if(ispath(MP, /mob/living/simple/crab))
		return 1
	if(ispath(MP, /mob/living/simple/hostile/carp))
		return 1
	if(ispath(MP, /mob/living/simple/mushroom))
		return 1
	if(ispath(MP, /mob/living/simple/shade))
		return 1
	if(ispath(MP, /mob/living/simple/tomato))
		return 1
	if(ispath(MP, /mob/living/simple/mouse))
		return 1 //It is impossible to pull up the player panel for mice (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple/hostile/bear))
		return 1 //Bears will auto-attack mobs, even if they're player controlled (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple/parrot))
		return 1 //Parrots are no longer unfinished! -Nodrak

	//Not in here? Must be untested!
	return 0