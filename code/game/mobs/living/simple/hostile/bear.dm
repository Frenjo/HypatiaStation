//Space bears!
/mob/living/simple/hostile/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_holder/food/snacks/bearmeat
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "pokes the"
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 60
	health = 60
	melee_damage_lower = 20
	melee_damage_upper = 30

	//Space bears aren't affected by atmos.
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0

	faction = "russian"

	var/stance_step = 0

//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple/hostile/bear/Hudson
	name = "Hudson"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"

/mob/living/simple/hostile/bear/Life()
	. =..()
	if(!.)
		return

	if(loc && isspace(loc))
		icon_state = "bear"
	else
		icon_state = "bearfloor"

	switch(stance)

		if(HOSTILE_STANCE_TIRED)
			stop_automated_movement = TRUE
			stance_step++
			if(stance_step >= 10) //rests for 10 ticks
				if(isnotnull(target) && (target in list_targets()))
					stance = HOSTILE_STANCE_ATTACK //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					stance = HOSTILE_STANCE_IDLE

		if(HOSTILE_STANCE_ALERT)
			stop_automated_movement = TRUE
			var/found_mob = 0
			if(isnotnull(target) && (target in list_targets()))
				if(can_attack(target))
					stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
					stance_step++
					found_mob = 1
					set_dir(get_dir(src, target)) // Keep staring at the mob.

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "growls at [target]", "stares angrily at [target]", "prepares to attack [target]", "closely watches [target]" ) )
						if(action)
							custom_emote(1,action)
			if(!found_mob)
				stance_step--

			if(stance_step <= -20) //If we have not found a mob for 20-ish ticks, revert to idle mode
				stance = HOSTILE_STANCE_IDLE
			if(stance_step >= 7)   //If we have been staring at a mob for 7 ticks,
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACKING)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and needs to rest
				custom_emote(1, "is worn out and needs to rest" )
				stance = HOSTILE_STANCE_TIRED
				stance_step = 0
				walk(src, 0) //This stops the bear's walking
				return



/mob/living/simple/hostile/bear/attack_by(obj/item/I, mob/user)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target = user
		return TRUE
	return ..()

/mob/living/simple/hostile/bear/attack_hand(mob/living/carbon/human/M)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target = M
	..()

/mob/living/simple/hostile/bear/Process_Spacemove(var/check_drift = 0)
	return	//No drifting in space for space bears!

/mob/living/simple/hostile/bear/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"stares alertly at [.]")
		stance = HOSTILE_STANCE_ALERT

/mob/living/simple/hostile/bear/LoseTarget()
	..(5)

/mob/living/simple/hostile/bear/AttackingTarget()
	if(!Adjacent(target))
		return
	custom_emote(1, pick(list("slashes at [target]", "bites [target]")))

	var/damage = rand(20,30)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/datum/organ/external/affecting = H.get_organ(ran_zone(dam_zone))
		H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"), sharp = 1, edge = 1)
		return H
	else if(isliving(target))
		var/mob/living/L = target
		L.adjustBruteLoss(damage)
		return L
	else if(ismecha(target))
		var/obj/mecha/M = target
		M.attack_animal(src)
		return M
