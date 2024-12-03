/mob/living/simple
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	universal_speak = FALSE // No, just no.

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	var/list/speak = list()
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	var/turns_per_move = 1
	var/turns_since_move = 0

	var/meat_amount = 0
	var/meat_type
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1	// Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.

	//Interaction
	var/response_help	= "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm	= "tries to hurt"
	var/harm_intent_damage = 3

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp

	//Atmos effect - Yes, you can make creatures that require plasma or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/min_oxy = 5
	var/max_oxy = 0					//Leaving something at 0 means it's off - has no maximum
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above

	var/speed = 0 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster


	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "attacks"
	attack_sound = null
	friendly = "nuzzles" //If the mob does no damage with it's attack

/mob/living/simple/New()
	..()
	verbs.Remove(/mob/verb/observe)

/mob/living/simple/Login()
	client?.screen = null
	..()

/mob/living/simple/updatehealth()
	return

/mob/living/simple/Life()
	//Health
	if(stat == DEAD)
		if(health > 0)
			icon_state = icon_living
			GLOBL.dead_mob_list.Remove(src)
			GLOBL.living_mob_list.Add(src)
			stat = CONSCIOUS
			density = TRUE
		return 0

	if(health < 1)
		Die()

	if(health > maxHealth)
		health = maxHealth

	if(stunned)
		AdjustStunned(-1)
	if(weakened)
		AdjustWeakened(-1)
	if(paralysis)
		AdjustParalysis(-1)

	// Movement.
	if(isnull(client) && !stop_automated_movement && wander && !anchored)
		if(isturf(loc) && !resting && isnull(buckled) && canmove) // This is so it only moves if it's not inside a closet, genetics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && isnotnull(pulledby))) // Some animals don't move when pulled.
					Move(get_step(src, pick(GLOBL.cardinal)))
					turns_since_move = 0

	// Speaking.
	if(isnull(client) && speak_chance)
		if(rand(0, 200) < speak_chance)
			if(length(speak))
				if(length(emote_hear) || length(emote_see))
					var/length = length(speak)
					if(length(emote_hear))
						length += length(emote_hear)
					if(length(emote_see))
						length += length(emote_see)
					var/randomValue = rand(1, length)
					if(randomValue <= length(speak))
						say(pick(speak))
					else
						randomValue -= length(speak)
						if(emote_see && randomValue <= length(emote_see))
							emote(pick(emote_see), 1)
						else
							emote(pick(emote_hear), 2)
				else
					say(pick(speak))
			else
				if(!length(emote_hear) && length(emote_see))
					emote(pick(emote_see), 1)
				if(length(emote_hear) && !length(emote_see))
					emote(pick(emote_hear), 2)
				if(length(emote_hear) && length(emote_see))
					var/length = length(emote_hear) + length(emote_see)
					var/pick = rand(1, length)
					if(pick <= length(emote_see))
						emote(pick(emote_see), 1)
					else
						emote(pick(emote_hear), 2)

	// Atmos.
	var/atmos_suitable = TRUE

	var/atom/A = src.loc
	if(isturf(A))
		var/turf/T = A

		var/datum/gas_mixture/environment = T.return_air()

		if(isnotnull(environment))
			if(abs(environment.temperature - bodytemperature) > 40)
				var/diff = environment.temperature - bodytemperature
				diff = diff / 5
				bodytemperature += diff

			if(min_oxy)
				if(environment.gas[/decl/xgm_gas/oxygen] < min_oxy)
					atmos_suitable = FALSE
			if(max_oxy)
				if(environment.gas[/decl/xgm_gas/oxygen] > max_oxy)
					atmos_suitable = FALSE
			if(min_tox)
				if(environment.gas[/decl/xgm_gas/plasma] < min_tox)
					atmos_suitable = FALSE
			if(max_tox)
				if(environment.gas[/decl/xgm_gas/plasma] > max_tox)
					atmos_suitable = FALSE
			if(min_n2)
				if(environment.gas[/decl/xgm_gas/nitrogen] < min_n2)
					atmos_suitable = FALSE
			if(max_n2)
				if(environment.gas[/decl/xgm_gas/nitrogen] > max_n2)
					atmos_suitable = FALSE
			if(min_co2)
				if(environment.gas[/decl/xgm_gas/carbon_dioxide] < min_co2)
					atmos_suitable = FALSE
			if(max_co2)
				if(environment.gas[/decl/xgm_gas/carbon_dioxide] > max_co2)
					atmos_suitable = FALSE

	//Atmos effect
	if(bodytemperature < minbodytemp)
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		adjustBruteLoss(heat_damage_per_tick)

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atoms_damage)
	return 1

/mob/living/simple/gib()
	if(meat_amount && meat_type)
		for(var/i = 0; i < meat_amount; i++)
			new meat_type(src.loc)
	..(icon_gib, 1)

/mob/living/simple/emote(act, type, desc)
	if(act)
		if(act == "scream")
			act = "whimper" //ugly hack to stop animals screaming when crushed :P
		..(act, type, desc)

/mob/living/simple/attack_animal(mob/living/M)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message(SPAN_WARNING("<B>[M]</B> [M.attacktext] [src]!"))
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)

/mob/living/simple/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	adjustBruteLoss(Proj.damage)
	return 0

/mob/living/simple/attack_hand(mob/living/carbon/human/M)
	..()
	switch(M.a_intent)
		if("help")
			if(health > 0)
				visible_message(SPAN_INFO("[M] [response_help] [src]."))

		if("grab")
			if(M == src)
				return
			if(!(status_flags & CANPUSH))
				return

			var/obj/item/grab/G = new /obj/item/grab(M, M, src)

			M.put_in_active_hand(G)

			grabbed_by += G
			G.synch()
			G.affecting = src
			LAssailant = M

			visible_message(SPAN_WARNING("[M] has grabbed [src] passively!"))

		if("hurt", "disarm")
			adjustBruteLoss(harm_intent_damage)
			visible_message(SPAN_WARNING("[M] [response_harm] [src]."))

/mob/living/simple/attack_slime(mob/living/carbon/slime/M)
	if(isnull(global.PCticker))
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if(isnotnull(M.Victim))
		return // can't attack while eating!

	visible_message(SPAN_DANGER("The [M.name] glomps [src]!"))

	var/damage = rand(1, 3)

	if(isslimeadult(src))
		damage = rand(20, 40)
	else
		damage = rand(5, 35)

	adjustBruteLoss(damage)

/mob/living/simple/attackby(obj/item/O, mob/user)  //Marker -Agouri
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(health < maxHealth)
				if(MED.amount >= 1)
					adjustBruteLoss(-MED.heal_brute)
					MED.amount -= 1
					if(MED.amount <= 0)
						qdel(MED)
					visible_message(SPAN_INFO("[user] applies \the [MED] on [src]."))
		else
			to_chat(user, SPAN_INFO("This [src] is dead, medical items won't bring it back to life."))
	if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/kitchenknife) || istype(O, /obj/item/butch))
			new meat_type(GET_TURF(src))
			if(prob(95))
				qdel(src)
				return
			gib()
	else
		if(O.force)
			var/damage = O.force
			if(O.damtype == HALLOSS)
				damage = 0
			adjustBruteLoss(damage)
			visible_message(SPAN_DANGER("[src] has been attacked with \the [O] by [user]."))
		else
			to_chat(usr, SPAN_WARNING("This weapon is ineffective, it does no damage."))
			visible_message(SPAN_WARNING("[user] gently taps [src] with \the [O]."))

/mob/living/simple/movement_delay()
	. = ..() //Incase I need to add stuff other than "speed" later
	. += speed

	. += CONFIG_GET(/decl/configuration_entry/animal_delay)

/mob/living/simple/Stat()
	..()
	statpanel(PANEL_STATUS)
	stat("Health:", "[round((health / maxHealth) * 100)]%")

/mob/living/simple/proc/Die()
	GLOBL.living_mob_list.Remove(src)
	GLOBL.dead_mob_list.Add(src)
	icon_state = icon_dead
	stat = DEAD
	density = FALSE

/mob/living/simple/ex_act(severity)
	if(!blinded)
		flick("flash", flash)
	switch(severity)
		if(1.0)
			adjustBruteLoss(500)
			gib()
			return

		if(2.0)
			adjustBruteLoss(60)

		if(3.0)
			adjustBruteLoss(30)

/mob/living/simple/adjustBruteLoss(damage)
	health = clamp(health - damage, 0, maxHealth)

/mob/living/simple/proc/SA_attackable(target_mob)
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat && L.health >= 0)
			return FALSE
	if(ismecha(target_mob))
		var/obj/mecha/M = target_mob
		if(isnotnull(M.occupant))
			return FALSE
	if(istype(target_mob, /obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return FALSE
	return TRUE

//Call when target overlay should be added/removed
/mob/living/simple/update_targeted()
	if(isnull(targeted_by) && target_locked)
		qdel(target_locked)
	overlays.Cut()
	if(isnotnull(targeted_by) && target_locked)
		overlays.Add(target_locked)

/mob/living/simple/say(message)
	if(stat)
		return

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	var/verbage = "says"

	if(length(speak_emote))
		verbage = pick(speak_emote)

	message = capitalize(trim_left(message))

	..(message, null, verbage)