/* Code for the Wild West map by Brotemis
 * Contains:
 *		Map Areas
 *		Wish Granter
 *		Meat Grinder
 */

/*
 * Map Areas
 */
/area/awaymission/wwmines
	name = "\improper Wild West Mines"
	icon_state = "away1"
	luminosity = 1
	requires_power = FALSE

/area/awaymission/wwgov
	name = "\improper Wild West Mansion"
	icon_state = "away2"
	luminosity = 1
	requires_power = FALSE

/area/awaymission/wwrefine
	name = "\improper Wild West Refinery"
	icon_state = "away3"
	luminosity = 1
	requires_power = FALSE

/area/awaymission/wwvault
	name = "\improper Wild West Vault"
	icon_state = "away3"
	luminosity = 0

/area/awaymission/wwvaultdoors
	name = "\improper Wild West Vault Doors"  // this is to keep the vault area being entirely lit because of requires_power
	icon_state = "away2"
	requires_power = FALSE
	luminosity = 0

/area/awaymission/desert
	name = "Mars"
	icon_state = "away"

/*
 * Wish Granter
 */
/obj/machinery/wish_granter_dark
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "syndbeacon"

	anchored = TRUE
	density = TRUE
	use_power = 0

	var/chargesa = 1
	var/insistinga = 0

/obj/machinery/wish_granter_dark/attack_hand(mob/living/carbon/human/user as mob)
	usr.set_machine(src)

	if(chargesa <= 0)
		to_chat(user, "The Wish Granter lies silent.")
		return

	else if(!ishuman(user))
		to_chat(user, "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's.")
		return

	else if(is_special_character(user))
		to_chat(user, "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away.")

	else if(!insistinga)
		to_chat(user, "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?")
		insistinga++

	else
		chargesa--
		insistinga = 0
		var/wish = input("You want...", "Wish") as null | anything in list("Power", "Wealth", "Immortality", "To Kill", "Peace")
		switch(wish)
			if("Power")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				if(!(LASER in user.mutations))
					user.mutations.Add(LASER)
					to_chat(user, SPAN_INFO("You feel pressure building behind your eyes."))
				if(!(COLD_RESISTANCE in user.mutations))
					user.mutations.Add(COLD_RESISTANCE)
					to_chat(user, SPAN_INFO("Your body feels warm."))
				if(!(XRAY in user.mutations))
					user.mutations.Add(XRAY)
					user.sight |= (SEE_MOBS | SEE_OBJS | SEE_TURFS)
					user.see_in_dark = 8
					user.see_invisible = SEE_INVISIBLE_LEVEL_TWO
					to_chat(user, SPAN_INFO("The walls suddenly disappear."))
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("Wealth")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				new /obj/structure/closet/syndicate/resources/everything(loc)
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("Immortality")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				user.verbs += /mob/living/carbon/proc/immortality
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("To Kill")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your wickedness, claiming your soul and warping your body to match the darkness in your heart.")
				global.CTgame_ticker.mode.traitors += user.mind
				user.mind.special_role = "traitor"
				var/datum/objective/hijack/hijack = new
				hijack.owner = user.mind
				user.mind.objectives += hijack
				to_chat(user, "<B>Your inhibitions are swept away, the bonds of loyalty broken, you are free to murder as you please!</B>")
				var/obj_count = 1
				for(var/datum/objective/OBJ in user.mind.objectives)
					to_chat(user, "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]")
					obj_count++
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("Peace")
				to_chat(user, "<B>Whatever alien sentience that the Wish Granter possesses is satisfied with your wish. There is a distant wailing as the last of the Faithless begin to die, then silence.</B>")
				to_chat(user, "You feel as if you just narrowly avoided a terrible fate...")
				for(var/mob/living/simple_animal/hostile/faithless/F in GLOBL.living_mob_list)
					F.health = -10
					F.stat = 2
					F.icon_state = "faithless_dead"


/*
 * Meat Grinder
 */
/obj/effect/meatgrinder
	name = "Meat Grinder"
	desc = "What is that thing?"
	density = TRUE
	anchored = TRUE
	layer = 3
	icon = 'icons/mob/critter.dmi'
	icon_state = "blob"
	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = 0

/obj/effect/meatgrinder/New()
	icon_state = "blob"

/obj/effect/meatgrinder/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/effect/meatgrinder/Bumped(mob/M as mob|obj)
	if(triggered)
		return

	if(ishuman(M) || ismonkey(M))
		for(var/mob/O in viewers(world.view, src.loc))
			to_chat(O, "<font color='red'>[M] triggered the \icon[src] [src]</font>")
		triggered = 1
		call(src, triggerproc)(M)

/obj/effect/meatgrinder/proc/triggerrad1(mob)
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	for(var/mob/O in viewers(world.view, src.loc))
		s.set_up(3, 1, src)
		s.start()
		explosion(mob, 1, 0, 0, 0)
		spawn(0)
			qdel(src)


/obj/effect/meatgrinder
	name = "Meat Grinder"
	icon_state = "blob"
	triggerproc = "triggerrad1"


/////For the Wishgranter///////////
/mob/living/carbon/proc/immortality()
	set category = "Immortality"
	set name = "Resurrection"

	var/mob/living/carbon/C = usr
	if(!C.stat)
		to_chat(C, SPAN_NOTICE("You're not dead yet!"))
		return
	to_chat(C, SPAN_NOTICE("Death is not your end!"))

	spawn(rand(800, 1200))
		if(C.stat == DEAD)
			GLOBL.dead_mob_list -= C
			GLOBL.living_mob_list += C
		C.stat = CONSCIOUS
		C.tod = null
		C.setToxLoss(0)
		C.setOxyLoss(0)
		C.setCloneLoss(0)
		C.SetParalysis(0)
		C.SetStunned(0)
		C.SetWeakened(0)
		C.radiation = 0
		C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
		C.reagents.clear_reagents()
		to_chat(C, SPAN_NOTICE("You have regenerated."))
		C.visible_message(SPAN_WARNING("[usr] appears to wake from the dead, having healed all wounds."))
		C.update_canmove()
	return 1