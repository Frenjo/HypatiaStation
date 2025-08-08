/*
Creature-level abilities.
*/
/var/global/list/ability_verbs = list()

/*

 Example ability:

/client/proc/test_ability()

	set category = "Ability"
	set name = "Test ability"
	set desc = "An ability for testing."

	// Check if the client has a mob and if the mob is valid and alive.
	if(!mob || !isliving(mob) || mob.stat)
		to_chat(src, SPAN_WARNING("You must be corporeal and alive to do that."))
		return 0

	//Handcuff check.
	if(mob.restrained())
		to_chat(src, SPAN_WARNING("You cannot do this while restrained."))
		return 0

	if(iscarbon(mob))
		var/mob/living/carbon/M = mob
		if(M.handcuffed)
			to_chat(src, SPAN_WARNING("You cannot do this while cuffed."))
			return 0

	to_chat(src, SPAN_INFO("You perform an ability."))

*/

// Added Skrell telepathy. -Frenjo
/client/proc/skrell_remotesay()
	set category = "Abilities"
	set name = "Project Thoughts"
	set desc = "Project words into another individual's mind. May have adverse effects on non-Skrell."

	if(!mob || !isliving(mob) || mob.stat)
		to_chat(src, SPAN_WARNING("You must be corporeal and alive to do that."))
		return 0

	var/list/creatures = list()
	for(var/mob/living/carbon/C in view(src))
		if(!isnull(C.client))
			creatures.Add(C)

	var/mob/target = input("Who do you want to project your words to?") as null | anything in creatures
	if(isnull(target))
		return

	mob.visible_message(
		SPAN_INFO("[mob] focuses intently on [target]."),
		SPAN_INFO("You focus intently on [target].")
	)

	var/intensity = input("How intense do you want the projection to be?") in list(1, 2, 3)
	var/say = input("What do you wish to say?")

	if(target.get_species() == SPECIES_SKRELL)
		to_chat(target, SPAN_INFO("You hear [mob]'s words in your mind: [say]"))
	else
		switch(intensity)
			if(1)
				to_chat(target, SPAN_WARNING("You feel an ache in your head."))
				to_chat(target, SPAN_INFO("You hear words in your mind: [say]"))
			if(2)
				to_chat(target, SPAN_DANGER("You feel a pressure between your eyes."))
				to_chat(target, SPAN_INFO("You hear words in your mind: [say]"))
			if(3)
				to_chat(target, SPAN_DANGER("You feel a pressure between your eyes."))
				to_chat(target, SPAN_INFO_B("You hear words in your mind: [say]"))
				if(ishuman(target))
					var/mob/living/carbon/human/H = target
					H.visible_message(
						SPAN_WARNING("[target]'s nose begins to bleed."),
						SPAN_WARNING("Your nose begins to bleed...")
					)
					H.drip(3)

	to_chat(mob, SPAN_INFO("You project your words into [target]: [say]"))

	for(var/mob/dead/ghost/G in GLOBL.dead_mob_list)
		to_chat(G, "<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")