/mob/living/carbon/slime
	name = "baby slime"
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "grey baby slime"
	pass_flags = PASS_FLAG_TABLE
	speak_emote = list("hums")

	layer = 5

	maxHealth = 150
	health = 150
	gender = NEUTER

	update_icon = 0
	nutrition = 700 // 1000 = max

	see_in_dark = 8
	update_slimes = 0

	// canstun and canweaken don't affect slimes because they ignore stun and weakened variables
	// for the sake of cleanliness, though, here they are.
	status_flags = CANPARALYSE | CANPUSH

	mob_swap_flags = MONKEY | SLIME | SIMPLE_ANIMAL
	mob_push_flags = MONKEY | SLIME | SIMPLE_ANIMAL

	var/cores = 1 // the number of /obj/item/slime_extract's the slime has left inside

	var/powerlevel = 0 	// 1-10 controls how much electricity they are generating
	var/amount_grown = 0 // controls how long the slime has been overfed, if 10, grows into an adult
						 // if adult: if 10: reproduces

	var/mob/living/Victim = null // the person the slime is currently feeding on
	var/mob/living/Target = null // AI variable - tells the slime to hunt this down

	var/attacked = 0 // determines if it's been attacked recently. Can be any number, is a cooloff-ish variable
	var/tame = 0 // if set to 1, the slime will not eat humans ever, or attack them
	var/rabid = 0 // if set to 1, the slime will attack and eat anything it comes in contact with

	var/list/Friends = list() // A list of potential friends
	var/list/FriendsWeight = list() // A list containing values respective to Friends. This determines how many times a slime "likes" something. If the slime likes it more than 2 times, it becomes a friend

	// slimes pass on genetic data, so all their offspring have the same "Friends",

	///////////TIME FOR SUBSPECIES

	var/colour = "grey"
	var/primarytype = /mob/living/carbon/slime
	var/mutationone = /mob/living/carbon/slime/orange
	var/mutationtwo = /mob/living/carbon/slime/metal
	var/mutationthree = /mob/living/carbon/slime/blue
	var/mutationfour = /mob/living/carbon/slime/purple
	var/adulttype = /mob/living/carbon/slime/adult
	var/coretype = /obj/item/slime_extract/grey

/mob/living/carbon/slime/New()
	create_reagents(100)
	if(name == "baby slime")
		name = "[colour] baby slime ([rand(1, 1000)])"
	else
		name = "[colour] adult slime ([rand(1,1000)])"
	real_name = name
	spawn(1)
		regenerate_icons()
		to_chat(src, SPAN_INFO("Your icons have been generated!"))
	. = ..()

/mob/living/carbon/slime/movement_delay()
	. = ..()

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45)
		. += (health_deficiency / 25)

	if(bodytemperature < 183.222)
		. += (283.222 - bodytemperature) / 10 * 1.75

	if(isnotnull(reagents))
		if(reagents.has_reagent("hyperzine")) // hyperzine slows slimes down
			. *= 2 // moves twice as slow
		if(reagents.has_reagent("frostoil")) // frostoil also makes them move VEEERRYYYYY slow
			. *= 5

	if(health <= 0) // if damaged, the slime moves twice as slow
		. *= 2

	if(bodytemperature >= 330.23) // 135 F
		return -1	// slimes become supercharged at high temperatures

	. += CONFIG_GET(/decl/configuration_entry/slime_delay)

/mob/living/carbon/slime/Process_Spacemove()
	return 2

/mob/living/carbon/slime/Stat()
	. = ..()
	statpanel(PANEL_STATUS)
	stat(null, "Health: [round((health / maxHealth) * 100)]%")
	if(client.statpanel == PANEL_STATUS)
		stat(null, "Nutrition: [nutrition]/[isslimeadult(src) ? "1200" : "1000"]")
		if(amount_grown >= 10)
			stat(null, "You can [isslimeadult(src) ? "reproduce" : "evolve"]!")
		stat(null,"Power Level: [powerlevel]")

/mob/living/carbon/slime/adjustFireLoss(amount)
	..(-abs(amount)) // Heals them
	return

/mob/living/carbon/slime/bullet_act(obj/item/projectile/Proj)
	attacked += 10
	..(Proj)
	return 0


/mob/living/carbon/slime/emp_act(severity)
	powerlevel = 0 // oh no, the power!
	..()

/mob/living/carbon/slime/ex_act(severity)
	if(stat == DEAD && client)
		return

	else if(stat == DEAD && !client)
		qdel(src)
		return

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if(1.0)
			b_loss += 500
			return

		if(2.0)

			b_loss += 60
			f_loss += 60


		if(3.0)
			b_loss += 30

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()


/mob/living/carbon/slime/blob_act()
	if(stat == DEAD)
		return
	var/shielded = 0

	var/damage = null
	if(stat != DEAD)
		damage = rand(10, 30)

	if(shielded)
		damage /= 4

		//paralysis += 1

	to_chat(src, SPAN_DANGER("The blob attacks you!"))

	adjustFireLoss(damage)

	updatehealth()
	return


/mob/living/carbon/slime/u_equip(obj/item/W)
	return


/mob/living/carbon/slime/attack_ui(slot)
	return

/mob/living/carbon/slime/meteorhit(obj/O)
	visible_message(SPAN_DANGER("[src] has been hit by [O]!"))
	if(health > 0)
		adjustBruteLoss((istype(O, /obj/effect/meteor/small) ? 10 : 25))
		adjustFireLoss(30)

		updatehealth()
	return


/mob/living/carbon/slime/attack_slime(mob/living/carbon/slime/M)
	if(!global.PCticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if(Victim)
		return // can't attack while eating!

	if(health > -100)
		visible_message(SPAN_DANGER("\The [M] has glomped [src]!"))

		var/damage = rand(1, 3)
		attacked += 5

		damage = rand(1, isslimeadult(src) ? 6 : 3)

		adjustBruteLoss(damage)


		updatehealth()

	return


/mob/living/carbon/slime/attack_animal(mob/living/M)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message(SPAN_WARNING("<B>[M]</B> [M.attacktext] [src]!"))
		M.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>"
		attack_log += "\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>"
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		switch(M.melee_damage_type)
			if(BRUTE)
				adjustBruteLoss(damage)
			if(BURN)
				adjustFireLoss(damage)
			if(TOX)
				adjustToxLoss(damage)
			if(OXY)
				adjustOxyLoss(damage)
			if(CLONE)
				adjustCloneLoss(damage)
			if(HALLOSS)
				adjustHalLoss(damage)
		updatehealth()

/mob/living/carbon/slime/attack_paw(mob/living/carbon/monkey/M)
	if(!ismonkey(M))
		return//Fix for aliens receiving double messages when attacking other aliens.

	if(!global.PCticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	..()

	switch(M.a_intent)

		if("help")
			help_shake_act(M)
		else
			if(istype(wear_mask, /obj/item/clothing/mask/muzzle))
				return
			if(health > 0)
				attacked += 10
				//playsound(loc, 'sound/weapons/melee/bite.ogg', 50, 1, -1)
				visible_message(SPAN_DANGER("[M] has attacked [src]!"))
				adjustBruteLoss(rand(1, 3))
				updatehealth()
	return


/mob/living/carbon/slime/attack_hand(mob/living/carbon/human/M)
	if(!global.PCticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	..()

	if(Victim)
		if(Victim == M)
			if(prob(60))
				visible_message(SPAN_WARNING("[M] attempts to wrestle \the [src] off!"))
				playsound(loc, 'sound/weapons/melee/punchmiss.ogg', 25, 1, -1)

			else
				visible_message(SPAN_WARNING("[M] manages to wrestle \the [src] off!"))
				playsound(loc, 'sound/weapons/melee/thudswoosh.ogg', 50, 1, -1)

				if(prob(90) && !client)
					Discipline++

				spawn()
					SStun = 1
					sleep(rand(45, 60))
					if(src)
						SStun = 0

				Victim = null
				anchored = FALSE
				step_away(src,M)

			return

		else
			if(prob(30))
				visible_message(SPAN_WARNING("[M] attempts to wrestle \the [src] off of [Victim]!"))
				playsound(loc, 'sound/weapons/melee/punchmiss.ogg', 25, 1, -1)

			else
				visible_message(SPAN_WARNING("[M] manages to wrestle \the [src] off of [Victim]!"))
				playsound(loc, 'sound/weapons/melee/thudswoosh.ogg', 50, 1, -1)

				if(prob(80) && !client)
					Discipline++

					if(!isslimeadult(src))
						if(Discipline == 1)
							attacked = 0

				spawn()
					SStun = 1
					sleep(rand(55, 65))
					if(src)
						SStun = 0

				Victim = null
				anchored = FALSE
				step_away(src, M)

			return




	if(M.gloves && istype(M.gloves, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)
					visible_message(
						SPAN_DANGER("[src] has been touched with the stun gloves by [M]!"),
						SPAN_WARNING("You hear someone fall.")
					)
					return
				else
					to_chat(M, SPAN_WARNING("Not enough charge!"))
					return

	switch(M.a_intent)
		if("help")
			help_shake_act(M)

		if("grab")
			if(M == src)
				return
			var/obj/item/grab/G = new /obj/item/grab(M, src)

			M.put_in_active_hand(G)

			grabbed_by += G
			G.synch()

			LAssailant = M

			playsound(loc, 'sound/weapons/melee/thudswoosh.ogg', 50, 1, -1)
			visible_message(SPAN_WARNING("[M] has grabbed [src] passively!"))

		else

			var/damage = rand(1, 9)

			attacked += 10
			if(prob(90))
				if(MUTATION_HULK in M.mutations)
					damage += 5
					if(Victim)
						Victim = null
						anchored = FALSE
						if(prob(80) && !client)
							Discipline++
					spawn(0)

						step_away(src, M, 15)
						sleep(3)
						step_away(src, M, 15)

				playsound(loc, "punch", 25, 1, -1)
				visible_message(SPAN_DANGER("[M] has punched [src]!"))

				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/melee/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("[M] has attempted to punch [src]!"))
	return

/mob/living/carbon/slime/restrained()
	return FALSE


/mob/living/carbon/slime/var/co2overloadtime = null
/mob/living/carbon/slime/var/temperature_resistance = T0C+75


/mob/living/carbon/slime/show_inv(mob/user)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR><BR>
	<BR><A href='byond://?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, "window=mob[name];size=340x480")
	onclose(user, "mob[name]")
	return

/mob/living/carbon/slime/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		// slimes can't suffocate unless they suicide. They are also not harmed by fire
		health = maxHealth - (getOxyLoss() + getToxLoss() + getFireLoss() + getBruteLoss() + getCloneLoss())

/mob/living/carbon/slime/can_use_vents()
	if(Victim)
		return "You cannot ventcrawl while feeding."
	..()

//////////////////////////////Old shit from metroids/RoRos, and the old cores, would not take much work to re-add them////////////////////////

/*
// Basically this slime Core catalyzes reactions that normally wouldn't happen anywhere
/obj/item/slime_core
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "slime extract"
	flags = TABLEPASS
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 6
	origin_tech = alist(/decl/tech/biotech = 4)
	var/POWERFLAG = 0 // sshhhhhhh
	var/Flush = 30
	var/Uses = 5 // uses before it goes inert

/obj/item/slime_core/New()
		. = ..()
		create_reagents(100)
		POWERFLAG = rand(1,10)
		Uses = rand(7, 25)
		//flags |= NOREACT
/*
		spawn()
			Life()

	proc/Life()
		while(src)
			sleep(25)
			Flush--
			if(Flush <= 0)
				reagents.clear_reagents()
				Flush = 30
*/



/obj/item/reagent_holder/food/snacks/egg/slime
	name = "slime egg"
	desc = "A small, gelatinous egg."
	icon = 'icons/mob/mob.dmi'
	icon_state = "slime egg-growing"
	bitesize = 12
	origin_tech = alist(/decl/tech/biotech = 4)
	var/grown = 0

/obj/item/reagent_holder/food/snacks/egg/slime/New()
	..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("slimejelly", 1)
	spawn(rand(1200,1500))//the egg takes a while to "ripen"
		Grow()

/obj/item/reagent_holder/food/snacks/egg/slime/proc/Grow()
	grown = 1
	icon_state = "slime egg-grown"
	processing_objects.Add(src)
	return

/obj/item/reagent_holder/food/snacks/egg/slime/proc/Hatch()
	processing_objects.Remove(src)
	var/turf/T = GET_TURF(src)
	src.visible_message("\blue The [name] pulsates and quivers!")
	spawn(rand(50,100))
		src.visible_message("\blue The [name] bursts open!")
		new/mob/living/carbon/slime(T)
		del(src)


/obj/item/reagent_holder/food/snacks/egg/slime/process()
	var/turf/location = GET_TURF(src)
	var/datum/gas_mixture/environment = location.return_air()
	if (environment.toxins > MOLES_PLASMA_VISIBLE)//plasma exposure causes the egg to hatch
		src.Hatch()

/obj/item/reagent_holder/food/snacks/egg/slime/attackby(obj/item/W, mob/user)
	if(istype( W, /obj/item/toy/crayon ))
		return
	else
		..()
*/