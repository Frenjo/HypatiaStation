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
	if(!mob || !istype(mob,/mob/living) || mob.stat)
		src << "\red You must be corporeal and alive to do that."
		return 0

	//Handcuff check.
	if(mob.restrained())
		src << "\red You cannot do this while restrained."
		return 0

	if(istype(mob,/mob/living/carbon))
		var/mob/living/carbon/M = mob
		if(M.handcuffed)
			src << "\red You cannot do this while cuffed."
			return 0

	src << "\blue You perform an ability."

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
	for(var/mob/living/carbon/h in view(src))
		creatures += h

	var/mob/target = input("Who do you want to project your words to?") as null | anything in creatures

	if(isnull(target))
		return

	mob.visible_message(
		SPAN_INFO("[mob.real_name] focuses intently on [target.real_name]."),
		SPAN_WARNING("You focus intently on [target.real_name].")
	)

	var/intensity = input("How intense do you want the projection to be?") in list(1, 2, 3)
	var/say = input("What do you wish to say?")

	if(target.get_species() == SPECIES_SKRELL)
		target.show_message(SPAN_INFO("You hear [mob.real_name]'s words in your mind: [say]"))
	else
		switch(intensity)
			if(1)
				target.show_message(SPAN_DANGER("You feel an ache in your head."))
				target.show_message(SPAN_INFO("You hear words in your mind: [say]"))
			if(2)
				target.show_message(SPAN_DANGER("You feel a pressure between your eyes."))
				target.show_message(SPAN_INFO("You hear words in your mind: [say]"))
			if(3)
				target.show_message(SPAN_DANGER("You feel a pressure between your eyes."))
				target.show_message(SPAN_INFO_B("You hear words in your mind: [say]"))
				if(ishuman(target))
					var/mob/living/carbon/human/h = target
					h.visible_message(
						SPAN_DANGER("[target.real_name]'s nose begins to bleed."),
						SPAN_DANGER("Your nose begins to bleed...")
					)
					h.drip(3)

	mob.show_message(SPAN_INFO("You project your words into [target.real_name]: [say]"))

	for(var/mob/dead/observer/G in world)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")