/proc/christmas_game_start()
	for(var/obj/structure/flora/tree/pine/xmas in GLOBL.movable_atom_list)
		if(isnotstationlevel(xmas.z))
			continue
		for(var/turf/open/floor/T in RANGE_TURFS(xmas, 1))
			for(var/i = 1, i <= rand(1, 5), i++)
				new /obj/item/a_gift(T)
	//for(var/mob/living/simple/corgi/Ian/Ian in mob_list)
	//	Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))

/proc/christmas_event()
	for(var/obj/structure/flora/tree/pine/xmas in GLOBL.movable_atom_list)
		var/mob/living/simple/hostile/tree/evil_tree = new /mob/living/simple/hostile/tree(xmas.loc)
		evil_tree.icon_state = xmas.icon_state
		evil_tree.icon_living = evil_tree.icon_state
		evil_tree.icon_dead = evil_tree.icon_state
		evil_tree.icon_gib = evil_tree.icon_state
		qdel(xmas)

/obj/item/toy/xmas_cracker
	name = "xmas cracker"
	icon = 'icons/obj/christmas.dmi'
	icon_state = "cracker"
	desc = "Directions for use: Requires two people, one to pull each end."
	var/cracked = 0

/obj/item/toy/xmas_cracker/attack(mob/target, mob/user)
	if(!cracked && ishuman(target) && (target.stat == CONSCIOUS) && !target.get_active_hand())
		target.visible_message(SPAN_NOTICE("[user] and [target] pop \an [src]! *pop*"), SPAN_NOTICE("You pull \an [src] with [target]! *pop*"), SPAN_NOTICE("You hear a *pop*."))
		var/obj/item/paper/Joke = new /obj/item/paper(user.loc)
		Joke.name = "[pick("awful", "terrible", "unfunny")] joke"
		Joke.info = pick("What did one snowman say to the other?\n\n<i>'Is it me or can you smell carrots?'</i>",
			"Why couldn't the snowman get laid?\n\n<i>He was frigid!</i>",
			"Where are santa's helpers educated?\n\n<i>Nowhere, they're ELF-taught.</i>",
			"What happened to the man who stole advent calanders?\n\n<i>He got 25 days.</i>",
			"What does Santa get when he gets stuck in a chimney?\n\n<i>Claus-trophobia.</i>",
			"Where do you find chili beans?\n\n<i>The north pole.</i>",
			"What do you get from eating tree decorations?\n\n<i>Tinsilitis!</i>",
			"What do snowmen wear on their heads?\n\n<i>Ice caps!</i>",
			"Why is Christmas just like life on ss13?\n\n<i>You do all the work and the fat guy gets all the credit.</i>",
			"Why doesn�t Santa have any children?\n\n<i>Because he only comes down the chimney.</i>")
		new /obj/item/clothing/head/festive(target.loc)
		user.update_icons()
		cracked = 1
		icon_state = "cracker1"
		var/obj/item/toy/xmas_cracker/other_half = new /obj/item/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(user, 'sound/effects/snap.ogg', 50, 1)
		return 1
	return ..()

/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon_state = "xmashat"
	desc = "A crappy paper hat that you are REQUIRED to wear."
	inv_flags = null