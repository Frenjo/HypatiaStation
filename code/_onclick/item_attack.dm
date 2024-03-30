/*
 * attack_self()
 *
 * Called when the item is in the active hand, and clicked; alternatively, there is an 'activate held object' verb.
 */
/obj/item/proc/attack_self(mob/user)
	return

/*
 * attack_emag()
 *
 * Called by /obj/item/card/emag/handle_attack().
 * Returns TRUE if emagged successfully, FALSE if not.
 */
/atom/proc/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	return FALSE

/*
 * This proc is the hopeful foundation of a new interaction system.
 * Eventually, things will be split up into different procs for different interactions.
 * We might have attack_tool(), attack_emag(), attack_user(), etc.
 * Returns TRUE if the attack was handled successfully.
 */
/obj/item/proc/handle_attack(atom/thing, mob/source)
	// I think the general order of checks in this proc will be something like...
	// attack_tool() -> attack_by() -> old-style attackby() -> whack someone with it.
	. = thing.attack_tool(src, source) // First, checks for tool attacks.
	if(!.)
		. = thing.attack_by(src, source) // Secondly, checks the new-style attack_by().
	if(!.)
		. = thing.attackby(src, source) // Thirdly, checks the old-style attackby().

/*
 * attack_tool()
 *
 * Called as the first part of handle_attack()'s attack chain.
 * Overridden on subtypes which have interactions with various tool types.
 * Returns TRUE if the interaction was handled, FALSE if not.
 */
/atom/proc/attack_tool(obj/item/tool, mob/user)
	SHOULD_CALL_PARENT(TRUE)

	return FALSE

/mob/living/attack_tool(obj/item/tool, mob/user)
	if(can_operate(src) && do_surgery(src, user, tool))
		return TRUE
	return ..()

/*
 * attack_by()
 *
 * Called as the second part of handle_attack()'s attack chain.
 * This is basically the replacement for the old attackby().
 * Returns TRUE if the interaction was handled, FALSE if not.
 */
/atom/proc/attack_by(obj/item/I, mob/user)
	SHOULD_CALL_PARENT(TRUE)

	return FALSE

// No comment
/atom/proc/attackby(obj/item/W, mob/user)
	return FALSE

/atom/movable/attackby(obj/item/W, mob/user)
	if(!HAS_ITEM_FLAGS(W, ITEM_FLAG_NO_BLUDGEON))
		visible_message(SPAN_DANGER("[src] has been hit by [user] with [W]."))

/mob/living/attackby(obj/item/item, mob/user)
	if(!ismob(user))
		return FALSE
	if(istype(item))
		return item.attack(src, user)

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(!istype(M)) // not sure if this is the right thing...
		return

	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)
	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])" )

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////

	var/power = force
	if(HULK in user.mutations)
		power *= 2

	if(!ishuman(M))
		if(isslime(M))
			var/mob/living/carbon/slime/slime = M
			if(prob(25))
				to_chat(M, SPAN_WARNING("[src] passes right through [M]!"))
				return

			if(power > 0)
				slime.attacked += 10

			if(slime.Discipline && prob(50))	// wow, buddy, why am I getting attacked??
				slime.Discipline = 0

			if(power >= 3)
				if(isslimeadult(slime))
					if(prob(5 + round(power / 2)))

						if(slime.Victim)
							if(prob(80) && !slime.client)
								slime.Discipline++
						slime.Victim = null
						slime.anchored = FALSE

						spawn()
							if(slime)
								slime.SStun = 1
								sleep(rand(5, 20))
								if(slime)
									slime.SStun = 0

						spawn(0)
							if(slime)
								slime.canmove = FALSE
								step_away(slime, user)
								if(prob(25 + power))
									sleep(2)
									if(slime && user)
										step_away(slime, user)
								slime.canmove = TRUE

				else
					if(prob(10 + power * 2))
						if(slime)
							if(slime.Victim)
								if(prob(80) && !slime.client)
									slime.Discipline++

									if(slime.Discipline == 1)
										slime.attacked = 0

								spawn()
									if(slime)
										slime.SStun = 1
										sleep(rand(5, 20))
										if(slime)
											slime.SStun = 0

							slime.Victim = null
							slime.anchored = FALSE


						spawn(0)
							if(slime && user)
								step_away(slime, user)
								slime.canmove = FALSE
								if(prob(25 + power * 4))
									sleep(2)
									if(slime && user)
										step_away(slime, user)
								slime.canmove = TRUE

		var/showname = "."
		if(user)
			showname = " by [user]."
		if(!(user in viewers(M, null)))
			showname = "."

		if(length(attack_verb))
			M.visible_message(SPAN_DANGER("[M] has been [pick(attack_verb)] with [src][showname]."))
		else
			M.visible_message(SPAN_DANGER("[M] has been attacked with [src][showname]."))

		if(!showname)
			if(isnotnull(user?.client))
				to_chat(user, SPAN_DANGER("You attack [M] with [src]."))

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		return H.attacked_by(src, user, def_zone)
	else
		switch(damtype)
			if("brute")
				if(isslime(src))
					M.adjustBrainLoss(power)
				else
					M.take_organ_damage(power)
					if(prob(33)) // Added blood for whacking non-humans too
						if(issimulated(M.loc))
							var/turf/simulated/location = M.loc
							location.add_blood_floor(M)
			if("fire")
				if(!(COLD_RESISTANCE in M.mutations))
					M.take_organ_damage(0, power)
					to_chat(M, "Aargh it burns!")
		M.updatehealth()
	add_fingerprint(user)
	return 1