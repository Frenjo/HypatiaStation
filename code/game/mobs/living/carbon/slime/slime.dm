/mob/living/carbon/slime
	name = "baby slime"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey baby slime"
	pass_flags = PASSTABLE
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

/mob/living/carbon/slime/adult
	name = "adult slime"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey adult slime"
	speak_emote = list("telepathically chirps")

	health = 200
	gender = NEUTER

	update_icon = 0
	nutrition = 800 // 1200 = max

/mob/living/carbon/slime/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	if(name == "baby slime")
		name = text("[colour] baby slime ([rand(1, 1000)])")
	else
		name = text("[colour] adult slime ([rand(1,1000)])")
	real_name = name
	spawn(1)
		regenerate_icons()
		to_chat(src, SPAN_INFO("Your icons have been generated!"))
	..()

/mob/living/carbon/slime/adult/New()
	//verbs.Remove(/mob/living/carbon/slime/verb/ventcrawl)
	..()

/mob/living/carbon/slime/movement_delay()
	var/tally = 0

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45)
		tally += (health_deficiency / 25)

	if(bodytemperature < 183.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	if(reagents)
		if(reagents.has_reagent("hyperzine")) // hyperzine slows slimes down
			tally *= 2 // moves twice as slow

		if(reagents.has_reagent("frostoil")) // frostoil also makes them move VEEERRYYYYY slow
			tally *= 5

	if(health <= 0) // if damaged, the slime moves twice as slow
		tally *= 2

	if(bodytemperature >= 330.23) // 135 F
		return -1	// slimes become supercharged at high temperatures

	return tally + CONFIG_GET(slime_delay)

/mob/living/carbon/slime/Process_Spacemove()
	return 2

/mob/living/carbon/slime/Stat()
	..()

	statpanel("Status")
	if(isslimeadult(src))
		stat(null, "Health: [round((health / 200) * 100)]%")
	else
		stat(null, "Health: [round((health / 150) * 100)]%")

	if(client.statpanel == "Status")
		if(isslimeadult(src))
			stat(null, "Nutrition: [nutrition]/1200")
			if(amount_grown >= 10)
				stat(null, "You can reproduce!")
		else
			stat(null, "Nutrition: [nutrition]/1000")
			if(amount_grown >= 10)
				stat(null, "You can evolve!")

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

	show_message(SPAN_WARNING("The blob attacks you!"))

	adjustFireLoss(damage)

	updatehealth()
	return


/mob/living/carbon/slime/u_equip(obj/item/W as obj)
	return


/mob/living/carbon/slime/attack_ui(slot)
	return

/mob/living/carbon/slime/meteorhit(O as obj)
	for(var/mob/M in viewers(src, null))
		if((M.client && !( M.blinded )))
			M.show_message(SPAN_WARNING("[src] has been hit by [O]!"), 1)
	if(health > 0)
		adjustBruteLoss((istype(O, /obj/effect/meteor/small) ? 10 : 25))
		adjustFireLoss(30)

		updatehealth()
	return


/mob/living/carbon/slime/attack_slime(mob/living/carbon/slime/M as mob)
	if(!global.CTticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if(Victim)
		return // can't attack while eating!

	if(health > -100)
		for(var/mob/O in viewers(src, null))
			if((O.client && !O.blinded))
				O.show_message(SPAN_DANGER("The [M.name] has glomped [src]!"), 1)

		var/damage = rand(1, 3)
		attacked += 5

		if(isslimeadult(src))
			damage = rand(1, 6)
		else
			damage = rand(1, 3)

		adjustBruteLoss(damage)


		updatehealth()

	return


/mob/living/carbon/slime/attack_animal(mob/living/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()

/mob/living/carbon/slime/attack_paw(mob/living/carbon/monkey/M as mob)
	if(!ismonkey(M))
		return//Fix for aliens receiving double messages when attacking other aliens.

	if(!global.CTticker)
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
				//playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					if((O.client && !O.blinded))
						O.show_message(SPAN_DANGER("[M.name] has attacked [src]!"), 1)
				adjustBruteLoss(rand(1, 3))
				updatehealth()
	return


/mob/living/carbon/slime/attack_hand(mob/living/carbon/human/M as mob)
	if(!global.CTticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	..()

	if(Victim)
		if(Victim == M)
			if(prob(60))
				for(var/mob/O in viewers(src, null))
					if((O.client && !O.blinded))
						O.show_message(SPAN_WARNING("[M] attempts to wrestle \the [name] off!"), 1)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

			else
				for(var/mob/O in viewers(src, null))
					if((O.client && !O.blinded))
						O.show_message(SPAN_WARNING("[M] manages to wrestle \the [name] off!"), 1)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

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
				for(var/mob/O in viewers(src, null))
					if((O.client && !O.blinded))
						O.show_message(SPAN_WARNING("[M] attempts to wrestle \the [name] off of [Victim]!"), 1)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

			else
				for(var/mob/O in viewers(src, null))
					if((O.client && !O.blinded))
						O.show_message(SPAN_WARNING("[M] manages to wrestle \the [name] off of [Victim]!"), 1)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

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
					for(var/mob/O in viewers(src, null))
						if((O.client && !O.blinded))
							O.show_message(SPAN_DANGER("[src] has been touched with the stun gloves by [M]!"), 1, SPAN_WARNING("You hear someone fall."), 2)
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

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				if((O.client && !O.blinded))
					O.show_message(SPAN_WARNING("[M] has grabbed [src] passively!"), 1)

		else

			var/damage = rand(1, 9)

			attacked += 10
			if(prob(90))
				if(HULK in M.mutations)
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
				for(var/mob/O in viewers(src, null))
					if((O.client && !O.blinded))
						O.show_message(SPAN_DANGER("[M] has punched [src]!"), 1)

				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if((O.client && !O.blinded))
						O.show_message(SPAN_DANGER("[M] has attempted to punch [src]!"), 1)
	return

/mob/living/carbon/slime/restrained()
	return 0


/mob/living/carbon/slime/var/co2overloadtime = null
/mob/living/carbon/slime/var/temperature_resistance = T0C+75


/mob/living/carbon/slime/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR><BR>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[name];size=340x480"))
	onclose(user, "mob[name]")
	return

/mob/living/carbon/slime/updatehealth()
	if(status_flags & GODMODE)
		if(isslimeadult(src))
			health = 200
		else
			health = 150
		stat = CONSCIOUS
	else
		// slimes can't suffocate unless they suicide. They are also not harmed by fire
		if(isslimeadult(src))
			health = 200 - (getOxyLoss() + getToxLoss() + getFireLoss() + getBruteLoss() + getCloneLoss())
		else
			health = 150 - (getOxyLoss() + getToxLoss() + getFireLoss() + getBruteLoss() + getCloneLoss())

/mob/living/carbon/slime/can_use_vents()
	if(Victim)
		return "You cannot ventcrawl while feeding."
	..()

/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(RESEARCH_TECH_BIOTECH = 4)
	var/Uses = 1 // uses before it goes inert

/obj/item/slime_extract/New()
	..()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src


/obj/item/slime_extract/grey
	name = "grey slime extract"
	icon_state = "grey slime extract"


/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold slime extract"


/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver slime extract"


/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal slime extract"


/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple slime extract"


/obj/item/slime_extract/darkpurple
	name = "dark purple slime extract"
	icon_state = "dark purple slime extract"


/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange slime extract"


/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow slime extract"


/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red slime extract"


/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue slime extract"


/obj/item/slime_extract/darkblue
	name = "dark blue slime extract"
	icon_state = "dark blue slime extract"


/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink slime extract"


/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green slime extract"


/obj/item/slime_extract/lightpink
	name = "light pink slime extract"
	icon_state = "light pink slime extract"


/obj/item/slime_extract/black
	name = "black slime extract"
	icon_state = "black slime extract"


/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil slime extract"


/obj/item/slime_extract/adamantine
	name = "adamantine slime extract"
	icon_state = "adamantine slime extract"


////Pet Slime Creation///
/obj/item/slimepotion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

/obj/item/slimepotion/attack(mob/living/carbon/slime/M as mob, mob/user as mob)
	if(!isslime(M))//If target is not a slime.
		to_chat(user, SPAN_WARNING("The potion only works on baby slimes!"))
		return ..()
	if(isslimeadult(M)) //Can't tame adults
		to_chat(user, SPAN_WARNING("Only baby slimes can be tamed!"))
		return..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
	pet.icon_state = "[M.colour] baby slime"
	pet.icon_living = "[M.colour] baby slime"
	pet.icon_dead = "[M.colour] baby slime dead"
	pet.colour = "[M.colour]"
	to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
	qdel(M)
	var/newname = copytext(sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null | text), 1, MAX_NAME_LEN)

	if(!newname)
		newname = "pet slime"
	pet.name = newname
	pet.real_name = newname
	qdel(src)


/obj/item/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

/obj/item/slimepotion2/attack(mob/living/carbon/slime/adult/M as mob, mob/user as mob)
	if(!isslimeadult(M))	//If target is not a slime.
		to_chat(user, SPAN_WARNING("The potion only works on adult slimes!"))
		return ..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/adultslime(M.loc)
	pet.icon_state = "[M.colour] adult slime"
	pet.icon_living = "[M.colour] adult slime"
	pet.icon_dead = "[M.colour] baby slime dead"
	pet.colour = "[M.colour]"
	to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
	qdel(M)
	var/newname = copytext(sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null | text), 1, MAX_NAME_LEN)

	if(!newname)
		newname = "pet slime"
	pet.name = newname
	pet.real_name = newname
	qdel(src)


/obj/item/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

/obj/item/slimesteroid/attack(mob/living/carbon/slime/M as mob, mob/user as mob)
	if(!isslime(M))	//If target is not a slime.
		to_chat(user, SPAN_WARNING("The steroid only works on baby slimes!"))
		return ..()
	if(isslimeadult(M)) //Can't tame adults
		to_chat(user, SPAN_WARNING("Only baby slimes can use the steroid!"))
		return..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return..()
	if(M.cores == 3)
		to_chat(user, SPAN_WARNING("The slime already has the maximum amount of extract!"))
		return..()

	to_chat(user, "You feed the slime the steroid. It now has triple the amount of extract.")
	M.cores = 3
	qdel(src)


////////Adamantine Golem stuff I dunno where else to put it
/obj/item/clothing/under/golem
	name = "adamantine skin"
	desc = "a golem's skin"
	icon_state = "golem"
	item_state = "golem"
	item_color = "golem"
	has_sensor = 0
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	canremove = 0


/obj/item/clothing/suit/golem
	name = "adamantine shell"
	desc = "a golem's thick outer shell"
	icon_state = "golem"
	item_state = "golem"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS | HEAD
	slowdown = 1.0
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	flags = ONESIZEFITSALL | STOPSPRESSUREDAMAGE
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS | HEAD
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS | HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	canremove = 0
	armor = list(melee = 80, bullet = 20, laser = 20, energy = 10, bomb = 0, bio = 0, rad = 0)


/obj/item/clothing/shoes/golem
	name = "golem's feet"
	desc = "sturdy adamantine feet"
	icon_state = "golem"
	item_state = null
	canremove = 0
	flags = NOSLIP
	slowdown = SHOES_SLOWDOWN + 1


/obj/item/clothing/mask/gas/golem
	name = "golem's face"
	desc = "the imposing face of an adamantine golem"
	icon_state = "golem"
	item_state = "golem"
	canremove = 0
	siemens_coefficient = 0
	unacidable = 1


/obj/item/clothing/gloves/golem
	name = "golem's hands"
	desc = "strong adamantine hands"
	icon_state = "golem"
	item_state = null
	siemens_coefficient = 0
	canremove = 0


/obj/item/clothing/head/space/golem
	icon_state = "golem"
	item_state = "dermal"
	item_color = "dermal"
	name = "golem's head"
	desc = "a golem's head"
	canremove = 0
	unacidable = 1
	flags = STOPSPRESSUREDAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 80, bullet = 20, laser = 20, energy = 10, bomb = 0, bio = 0, rad = 0)


/obj/effect/golemrune
	anchored = TRUE
	desc = "a strange rune used to create golems. It glows when spirits are nearby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = TURF_LAYER

/obj/effect/golemrune/New()
	..()
	GLOBL.processing_objects.Add(src)

/obj/effect/golemrune/process()
	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(ghost)
		icon_state = "golem2"
	else
		icon_state = "golem"

/obj/effect/golemrune/attack_hand(mob/living/user as mob)
	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(!ghost)
		to_chat(user, "The rune fizzles uselessly. There is no spirit nearby.")
		return
	var/mob/living/carbon/human/G = new /mob/living/carbon/human
	G.dna.mutantrace = "adamantine"
	G.real_name = text("Adamantine Golem ([rand(1, 1000)])")
	G.equip_to_slot_or_del(new /obj/item/clothing/under/golem(G), SLOT_ID_W_UNIFORM)
	G.equip_to_slot_or_del(new /obj/item/clothing/suit/golem(G), SLOT_ID_WEAR_SUIT)
	G.equip_to_slot_or_del(new /obj/item/clothing/shoes/golem(G), SLOT_ID_SHOES)
	G.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/golem(G), SLOT_ID_WEAR_MASK)
	G.equip_to_slot_or_del(new /obj/item/clothing/gloves/golem(G), SLOT_ID_GLOVES)
	//G.equip_to_slot_or_del(new /obj/item/clothing/head/space/golem(G), SLOT_ID_HEAD)
	G.loc = src.loc
	G.key = ghost.key
	to_chat(G, "You are an adamantine golem. You move slowly, but are highly resistant to heat and cold as well as blunt trauma. You are unable to wear clothes, but can still use most tools. Serve [user], and assist them in completing their goals at any cost.")
	qdel (src)

/obj/effect/golemrune/proc/announce_to_ghosts()
	for(var/mob/dead/observer/G in GLOBL.player_list)
		if(G.client)
			var/area/A = get_area(src)
			if(A)
				to_chat(G, "Golem rune created in [A.name].")

//////////////////////////////Old shit from metroids/RoRos, and the old cores, would not take much work to re-add them////////////////////////

/*
// Basically this slime Core catalyzes reactions that normally wouldn't happen anywhere
/obj/item/slime_core
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "slime extract"
	flags = TABLEPASS
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(RESEARCH_TECH_BIOTECH = 4)
	var/POWERFLAG = 0 // sshhhhhhh
	var/Flush = 30
	var/Uses = 5 // uses before it goes inert

/obj/item/slime_core/New()
		..()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
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



/obj/item/reagent_containers/food/snacks/egg/slime
	name = "slime egg"
	desc = "A small, gelatinous egg."
	icon = 'icons/mob/mob.dmi'
	icon_state = "slime egg-growing"
	bitesize = 12
	origin_tech = list(RESEARCH_TECH_BIOTECH = 4)
	var/grown = 0

/obj/item/reagent_containers/food/snacks/egg/slime/New()
	..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("slimejelly", 1)
	spawn(rand(1200,1500))//the egg takes a while to "ripen"
		Grow()

/obj/item/reagent_containers/food/snacks/egg/slime/proc/Grow()
	grown = 1
	icon_state = "slime egg-grown"
	processing_objects.Add(src)
	return

/obj/item/reagent_containers/food/snacks/egg/slime/proc/Hatch()
	processing_objects.Remove(src)
	var/turf/T = get_turf(src)
	src.visible_message("\blue The [name] pulsates and quivers!")
	spawn(rand(50,100))
		src.visible_message("\blue The [name] bursts open!")
		new/mob/living/carbon/slime(T)
		del(src)


/obj/item/reagent_containers/food/snacks/egg/slime/process()
	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	if (environment.toxins > MOLES_PLASMA_VISIBLE)//plasma exposure causes the egg to hatch
		src.Hatch()

/obj/item/reagent_containers/food/snacks/egg/slime/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/toy/crayon ))
		return
	else
		..()
*/