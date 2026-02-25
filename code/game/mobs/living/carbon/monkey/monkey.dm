/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	speak_emote = list("chimpers")
	icon_state = "monkey1"
	icon = 'icons/mob/monkey.dmi'
	gender = NEUTER
	pass_flags = PASS_FLAG_TABLE
	update_icon = 0		///no need to call regenerate_icon

	hud_type = /datum/hud/monkey

	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	var/obj/item/card/id/id_store = null	// Fix for station bounced radios -- Skie
	var/greaterform = SPECIES_HUMAN				// Used when humanizing a monkey.
	//var/uni_append = "12C4E2"					// Small appearance modifier for different species.
	var/list/uni_append = list(0x12C, 0x4E2)	// Same as above for DNA2.
	var/update_muts = 1							// Monkey gene must be set at start.
	var/alien = 0								//Used for reagent metabolism.

/mob/living/carbon/monkey/tajara
	name = "farwa"
	voice_name = "farwa"
	speak_emote = list("mews")
	icon_state = "tajkey1"
	uni_append = list(0x0A0, 0xE00) // 0A0E00

/mob/living/carbon/monkey/skrell
	name = "neaera"
	voice_name = "neaera"
	speak_emote = list("squicks")
	icon_state = "skrellkey1"
	uni_append = list(0x01C, 0xC92) // 01CC92

/mob/living/carbon/monkey/soghun
	name = "stok"
	voice_name = "stok"
	speak_emote = list("hisses")
	icon_state = "stokkey1"
	uni_append = list(0x044, 0xC5D) // 044C5D

/mob/living/carbon/monkey/New()
	create_reagents(1000)

	if(name == initial(name)) //To stop Pun-Pun becoming generic.
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	if(!(dna))
		if(gender == NEUTER)
			gender = pick(MALE, FEMALE)
		dna = new /datum/dna(null)
		dna.real_name = real_name
		dna.ResetSE()
		dna.ResetUI()
		//dna.uni_identity = "00600200A00E0110148FC01300B009"
		//dna.SetUI(list(0x006,0x002,0x00A,0x00E,0x011,0x014,0x8FC,0x013,0x00B,0x009))
		//dna.struc_enzymes = "43359156756131E13763334D1C369012032164D4FE4CD61544B6C03F251B6C60A42821D26BA3B0FD6"
		//dna.SetSE(list(0x433,0x591,0x567,0x561,0x31E,0x137,0x633,0x34D,0x1C3,0x690,0x120,0x321,0x64D,0x4FE,0x4CD,0x615,0x44B,0x6C0,0x3F2,0x51B,0x6C6,0x0A4,0x282,0x1D2,0x6BA,0x3B0,0xFD6))
		dna.unique_enzymes = md5(name)

		// We're a monkey
		dna.SetSEState(GLOBL.dna_data.monkey_block, 1)
		dna.SetSEValueRange(GLOBL.dna_data.monkey_block, 0xDAC, 0xFFF)
		// Fix gender
		dna.SetUIState(DNA_UI_GENDER, gender != MALE, 1)

		// Set the blocks to uni_append, if needed.
		if(length(uni_append))
			for(var/b in 1 to length(uni_append))
				dna.SetUIValue(DNA_UI_LENGTH - (length(uni_append) - b), uni_append[b], 1)
		dna.UpdateUI()

		update_muts=1

	. = ..()
	update_icons()

/mob/living/carbon/monkey/soghun/New()
	..()
	dna.mutantrace = "lizard"
	greaterform = SPECIES_SOGHUN
	add_language("Sinta'unathi")

/mob/living/carbon/monkey/skrell/New()
	..()
	dna.mutantrace = "skrell"
	greaterform = SPECIES_SKRELL
	add_language("Skrellian")

/mob/living/carbon/monkey/tajara/New()
	..()
	dna.mutantrace = "tajaran"
	greaterform = SPECIES_TAJARAN
	add_language("Siik'tajr")

/mob/living/carbon/monkey/diona/New()
	..()
	alien = 1
	gender = NEUTER
	dna.mutantrace = "plant"
	greaterform = SPECIES_DIONA
	add_language("Rootspeak")

/mob/living/carbon/monkey/movement_delay()
	. = ..()
	if(isnotnull(reagents))
		if(reagents.has_reagent("hyperzine") || reagents.has_reagent("nuka_cola"))
			return -1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45)
		. += (health_deficiency / 25)

	if(bodytemperature < 283.222)
		. += (283.222 - bodytemperature) / 10 * 1.75

	. += CONFIG_GET(/decl/configuration_entry/monkey_delay)

/mob/living/carbon/monkey/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("mach_close"))
		var/t1 = "window=[topic.get_str("mach_close")]"
		unset_machine()
		CLOSE_BROWSER(src, t1)
		return

	if(topic.has("item") && !user.stat && !user.restrained() && in_range(src, user))
		var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey()
		O.source = user
		O.target = src
		O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.t_loc = loc
		O.place = topic.get_str("item")
		requests += O
		spawn(0)
			O.process()
		return

/mob/living/carbon/monkey/meteorhit(obj/O as obj)
	visible_message(SPAN_WARNING("[src] has been hit by [O]!"))
	if(health > 0)
		var/shielded = 0
		adjustBruteLoss(30)
		if ((O.icon_state == "flaming" && !( shielded )))
			adjustFireLoss(40)
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
	return

//mob/living/carbon/monkey/bullet_act(var/obj/projectile/Proj)taken care of in living

/mob/living/carbon/monkey/attack_paw(mob/M as mob)
	..()

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if ((M.a_intent == "hurt" && !( istype(wear_mask, /obj/item/clothing/mask/muzzle) )))
			if ((prob(75) && health > 0))
				playsound(loc, 'sound/weapons/melee/bite.ogg', 50, 1, -1)
				visible_message(SPAN_DANGER("[M] bites [src]!")) // "bites" sounds much better than "has bit" or "has bitten"
				var/damage = rand(1, 5)
				adjustBruteLoss(damage)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
				for(var/datum/disease/D in M.viruses)
					if(istype(D, /datum/disease/jungle_fever))
						contract_disease(D,1,0)
			else
				visible_message(SPAN_DANGER("[M] attempted to bite [src]!"))
	return

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M as mob)
	if(!global.PCticker)
		to_chat(M, SPAN_WARNING("You cannot attack people before the game has started."))
		return

	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)
					Weaken(5)
					if (stuttering < 5)
						stuttering = 5
					Stun(5)

					visible_message(
						SPAN_DANGER("[M] touches [src] with [G]!"),
						SPAN_DANGER("You touch [src] with your [G]!"),
						SPAN_WARNING("You hear someone fall!")
					)
					return
				else
					to_chat(M, SPAN_WARNING("Not enough charge!"))
					return

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if (M.a_intent == "hurt")
			if ((prob(75) && health > 0))
				visible_message(SPAN_DANGER("[M] punches [src]!"))
				playsound(loc, "punch", 25, 1, -1)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if (paralysis < 5)
						Paralyse(rand(10, 15))
						spawn(0)
							visible_message(SPAN_DANGER("[M] knocks out [src]!"))
							return
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/melee/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("[M] attempts to punch [src], but misses!"))
		else
			if (M.a_intent == "grab")
				if (M == src || anchored)
					return

				var/obj/item/grab/G = new /obj/item/grab(M, src )

				M.put_in_active_hand(G)

				grabbed_by += G
				G.synch()

				LAssailant = M

				playsound(loc, 'sound/weapons/melee/thudswoosh.ogg', 50, 1, -1)
				visible_message(SPAN_WARNING("[M] grabs [src] passively."))
			else
				if (!( paralysis ))
					if (prob(25))
						Paralyse(2)
						playsound(loc, 'sound/weapons/melee/thudswoosh.ogg', 50, 1, -1)
						visible_message(SPAN_DANGER("[M] pushes down [src]!"))
					else
						drop_item()
						playsound(loc, 'sound/weapons/melee/thudswoosh.ogg', 50, 1, -1)
						visible_message(SPAN_DANGER("[M] disarms [src]!"))
	return

/mob/living/carbon/monkey/attack_animal(mob/living/M as mob)
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

/mob/living/carbon/monkey/attack_slime(mob/living/carbon/slime/M as mob)
	if(!global.PCticker)
		to_chat(M, SPAN_WARNING("You cannot attack people before the game has started."))
		return

	if(M.Victim) return // can't attack while eating!

	if (health > -100)
		visible_message(SPAN_DANGER("\The [M] glomps [src]!"))

		var/damage = rand(1, 3)

		if(isslimeadult(src))
			damage = rand(20, 40)
		else
			damage = rand(5, 35)

		adjustBruteLoss(damage)

		if(M.powerlevel > 0)
			var/stunprob = 10
			var/power = M.powerlevel + rand(0,3)

			switch(M.powerlevel)
				if(1 to 2) stunprob = 20
				if(3 to 4) stunprob = 30
				if(5 to 6) stunprob = 40
				if(7 to 8) stunprob = 60
				if(9) 	   stunprob = 70
				if(10) 	   stunprob = 95

			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				visible_message(SPAN_DANGER("\The [M] shocks [src]!"))

				Weaken(power)
				if(stuttering < power)
					stuttering = power
				Stun(power)

				make_sparks(5, TRUE, src)

				if(prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6, 10))


		updatehealth()

	return

/mob/living/carbon/monkey/Stat()
	..()
	statpanel(PANEL_STATUS)
	stat("Intent: ", "[a_intent]")
	stat("Move Mode: ", "[move_intent.name]")
	if(client && mind)
		if(client.statpanel == PANEL_STATUS)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)
	return

/mob/living/carbon/monkey/verb/removeinternal()
	set category = PANEL_IC
	set name = "Remove Internals"

	internal = null
	return

/mob/living/carbon/monkey/var/co2overloadtime = null
/mob/living/carbon/monkey/var/temperature_resistance = T0C + 75

/mob/living/carbon/monkey/emp_act(severity)
	if(id_store) id_store.emp_act(severity)
	..()

/mob/living/carbon/monkey/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	switch(severity)
		if(1.0)
			if(stat != DEAD)
				adjustBruteLoss(200)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		if(2.0)
			if(stat != DEAD)
				adjustBruteLoss(60)
				adjustFireLoss(60)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		if(3.0)
			if(stat != DEAD)
				adjustBruteLoss(30)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
			if(prob(50))
				Paralyse(10)
		else
	return

/mob/living/carbon/monkey/blob_act()
	if(stat != DEAD)
		adjustFireLoss(60)
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
	if(prob(50))
		Paralyse(10)
	if(stat == DEAD && client)
		gib()
		return
	if(stat == DEAD && !client)
		gibs(loc, viruses)
		qdel(src)
		return

/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys cant use advanced tools
	if(!global.PCticker)
		return 0
	if(!IS_GAME_MODE(/datum/game_mode/monkey))
		return 0
	return 1

/mob/living/carbon/monkey/say(message, datum/language/speaking = null, verbage = "says", alt_name = "", italics = 0, message_range = world.view, list/used_radios = list())
	if(stat)
		return

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	if(length(speak_emote))
		verbage = pick(speak_emote)

	message = capitalize(trim_left(message))

	..(message, speaking, verbage, alt_name, italics, message_range, used_radios)