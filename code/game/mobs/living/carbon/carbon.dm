/mob/living/carbon/Life()
	. = ..()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(80))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(nutrition && stat != DEAD)
			nutrition -= HUNGER_FACTOR/10
			if(IS_RUNNING(src))
				nutrition -= HUNGER_FACTOR / 10
		if((MUTATION_FAT in mutations) && IS_RUNNING(src) && bodytemperature <= 360)
			bodytemperature += 2

		// Moving around increases germ_level faster
		if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
			germ_level++

/mob/living/carbon/relaymove(mob/user, direction)
	if(user in src.stomach_contents)
		if(prob(40))
			for(var/mob/M in hearers(4, src))
				if(isnotnull(M.client))
					M.show_message(SPAN_WARNING("You hear something rumbling inside [src]'s stomach..."), 2)
			var/obj/item/I = user.get_active_hand()
			if(I?.force)
				var/d = rand(round(I.force / 4), I.force)
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					var/organ = H.get_organ("chest")
					if(isorgan(organ))
						var/datum/organ/external/temp = organ
						if(temp.take_damage(d, 0))
							H.UpdateDamageIcon()
					H.updatehealth()
				else
					take_organ_damage(d)
				user.visible_message(SPAN_DANGER("[user] attacks [src]'s stomach wall with the [I.name]!"))
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.forceMove(loc)
						stomach_contents.Remove(A)
					gib()

/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in stomach_contents)
			stomach_contents.Remove(M)
		M.forceMove(loc)
		visible_message(SPAN_DANGER("[M] bursts out of [src]!"))
	. = ..(null, 1)

/mob/living/carbon/attack_hand(mob/M)
	if(!iscarbon(M))
		return

	if(hasorgans(M))
		var/datum/organ/external/temp = M:organs_by_name["r_hand"]
		if(isnotnull(M.hand))
			temp = M:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(M, SPAN_WARNING("You can't use your [temp.display_name]!"))
			return

	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

/mob/living/carbon/attack_paw(mob/M)
	if(!iscarbon(M))
		return

	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

/mob/living/carbon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0)
	if(status_flags & GODMODE)
		return 0	//godmode
	shock_damage *= siemens_coeff
	if(shock_damage < 1)
		return 0
	take_overall_damage(0, shock_damage, used_weapon = "Electrocution")
	//src.burn_skin(shock_damage)
	//src.adjustFireLoss(shock_damage) //burn_skin will do this for us
	//src.updatehealth()
	visible_message(
		SPAN_WARNING("[src] was shocked by the [source]!"), \
		SPAN_DANGER("You feel a powerful shock course through your body!"), \
		SPAN_WARNING("You hear a heavy electrical crack.") \
	)
//	if(src.stunned < shock_damage)	src.stunned = shock_damage
	Stun(10)//This should work for now, more is really silly and makes you lay there forever
//	if(src.weakened < 20*siemens_coeff)	src.weakened = 20*siemens_coeff
	Weaken(10)
	return shock_damage

/mob/living/carbon/rejuvenate()
	. = ..()
	nutrition = 400

/mob/living/carbon/proc/swap_hand()
	var/obj/item/item_in_hand = get_active_hand()
	if(isnotnull(item_in_hand)) //this segment checks if the item in your hand is twohanded.
		if(istype(item_in_hand, /obj/item/twohanded))
			var/obj/item/twohanded/twohanded = item_in_hand
			if(twohanded.wielded)
				to_chat(usr, SPAN_WARNING("Your other hand is too busy holding the [twohanded.name]."))
				return
	hand = !hand
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_active"
			hud_used.r_hand_hud_object.icon_state = "hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_active"
	/*if (!( src.hand ))
		src.hands.dir = NORTH
	else
		src.hands.dir = SOUTH*/
	return

/mob/living/carbon/proc/activate_hand(selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.
	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(health >= CONFIG_GET(/decl/configuration_entry/health_threshold_crit))
		if(src == M && ishuman(src))
			var/mob/living/carbon/human/H = src
			visible_message(
				SPAN_INFO("[src] examines [src.gender == MALE ? "himself" : "herself"]."), \
				SPAN_INFO("You check yourself for injuries.") \
			)

			for(var/datum/organ/external/org in H.organs)
				var/status = ""
				var/brutedamage = org.brute_dam
				var/burndamage = org.burn_dam
				if(halloss > 0)
					if(prob(30))
						brutedamage += halloss
					if(prob(30))
						burndamage += halloss

				if(brutedamage > 0)
					status = "bruised"
				if(brutedamage > 20)
					status = "bleeding"
				if(brutedamage > 40)
					status = "mangled"
				if(brutedamage > 0 && burndamage > 0)
					status += " and "
				if(burndamage > 40)
					status += "peeling away"

				else if(burndamage > 10)
					status += "blistered"
				else if(burndamage > 0)
					status += "numb"
				if(org.status & ORGAN_DESTROYED)
					status = "MISSING!"
				if(org.status & ORGAN_MUTATED)
					status = "weirdly shapen."
				if(status == "")
					status = "OK"
				show_message("\t [status == "OK" ? "\blue " : "\red "]My [org.display_name] is [status].", 1)
			if((MUTATION_SKELETON in H.mutations) && isnull(H.wear_uniform) && isnull(H.wear_suit))
				H.play_xylophone()
		else
			var/t_him = "it"
			if(gender == MALE)
				t_him = "him"
			else if(gender == FEMALE)
				t_him = "her"
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				H.wear_uniform?.add_fingerprint(M)
			sleeping = max(0, src.sleeping - 5)
			if(!sleeping)
				resting = 0
			AdjustParalysis(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)
			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			M.visible_message(
				SPAN_INFO("[M] shakes [src] trying to wake [t_him] up!"), \
				SPAN_INFO("You shake [src] trying to wake [t_him] up!"), \
			)

/mob/living/carbon/proc/eyecheck()
	return 0

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/living/carbon/clean_blood()
	. = ..()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(isnotnull(H.gloves))
			if(H.gloves.clean_blood())
				H.update_inv_gloves(0)
			H.gloves.germ_level = 0
		else
			if(H.bloody_hands)
				H.bloody_hands = 0
				H.update_inv_gloves(0)
			H.germ_level = 0
	update_icons()	//apply the now updated overlays to the mob


//Throwing stuff

/mob/living/carbon/proc/toggle_throw_mode()
	if(in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/living/carbon/proc/throw_mode_off()
	in_throw_mode = FALSE
	if(isnotnull(throw_icon))
		src.throw_icon.icon_state = "act_throw_off"

/mob/living/carbon/proc/throw_mode_on()
	in_throw_mode = TRUE
	if(isnotnull(throw_icon))
		throw_icon.icon_state = "act_throw_on"

/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	throw_mode_off()
	if(usr.stat || isnull(target))
		return
	if(target.type == /atom/movable/screen)
		return

	var/atom/movable/item = get_active_hand()
	if(isnull(item))
		return

	if(istype(item, /obj/item/grab))
		var/obj/item/grab/G = item
		item = G.thrown() //throw the person instead of the grab
		if(ismob(item))
			var/turf/start_T = GET_TURF(src) //Get the start and target tile for the descriptors
			var/turf/end_T = GET_TURF(target)
			if(isnotnull(start_T) && isnotnull(end_T))
				var/mob/M = item
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [GET_AREA(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [GET_AREA(end_T)]</font>"

				M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been thrown by [usr.name] ([usr.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>"
				usr.attack_log += "\[[time_stamp()]\] <font color='red'>Has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>"
				msg_admin_attack("[usr.name] ([usr.ckey]) has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")

	if(isnull(item))
		return // Grab processing has a chance of returning null.

	item.reset_plane_and_layer()
	u_equip(item)
	update_icons()

	if(iscarbon(usr)) //Check if a carbon mob is throwing. Modify/remove this line as required.
		item.forceMove(loc)
		client?.screen.Remove(item)
		if(isitem(item))
			var/obj/item/I = item
			I.dropped(src) // let it know it's been dropped

	//actually throw it!
	if(isnotnull(item))
		visible_message(SPAN_WARNING("[src] has thrown [item]."))

		if(isnull(lastarea))
			lastarea = GET_AREA(src)
		if(isspace(loc) || !lastarea.has_gravity)
			inertia_dir = get_dir(target, src)
			step(src, inertia_dir)

/*
		if(isspace(src.loc) || (src.flags & NOGRAV)) //they're in space, move em one space in the opposite direction
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)
*/

		item.throw_at(target, item.throw_range, item.throw_speed)

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	bodytemperature = max(bodytemperature, BODYTEMP_HEAT_DAMAGE_LIMIT + 10)

/mob/living/carbon/can_use_hands()
	if(isnotnull(handcuffed))
		return FALSE
	if(isnotnull(buckled) && !istype(buckled, /obj/structure/stool/bed/chair)) // buckling does not restrict hands
		return FALSE
	return TRUE

/mob/living/carbon/restrained()
	if(isnotnull(handcuffed))
		return TRUE
	return ..()

/mob/living/carbon/u_equip(obj/item/W)
	if(isnull(W))
		return 0

	else if(W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()

	else if(W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
		..()

/mob/living/carbon/show_inv(mob/living/carbon/user)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='byond://?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='byond://?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='byond://?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='byond://?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [(istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !internal) ? " <A href='byond://?src=\ref[src];item=internal'>Set Internal</A>" : ""]
	<BR>[handcuffed ? "<A href='byond://?src=\ref[src];item=handcuff'>Handcuffed</A>" : "<A href='byond://?src=\ref[src];item=handcuff'>Not Handcuffed</A>"]
	<BR>[internal ? "<A href='byond://?src=\ref[src];item=internal'>Remove Internal</A>" : ""]
	<BR><A href='byond://?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='byond://?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='byond://?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, "window=mob[name];size=325x500")
	onclose(user, "mob[name]")

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set category = PANEL_IC
	set name = "Sleep"

	if(usr.sleeping)
		to_chat(usr, SPAN_WARNING("You are already sleeping."))
		return
	if(alert(src, "You sure you want to sleep for a while?", "Sleep", "Yes", "No") == "Yes")
		usr.sleeping = 20 //Short nap

/mob/living/carbon/Bump(atom/movable/AM, yes)
	if(now_pushing || !yes)
		return
	..()
	if(iscarbon(AM) && prob(10))
		spread_disease_to(AM, "Contact")

//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()
	set category = "Alien"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple/borer/B = has_brain_worms()
	if(isnull(B))
		return

	if(B.controlling)
		to_chat(src, SPAN_DANGER("You withdraw your probosci, releasing control of [B.host_brain]."))
		to_chat(B.host_brain, SPAN_DANGER("Your vision swims as the alien parasite releases control of your body."))
		B.ckey = ckey
		B.controlling = FALSE
	if(isnotnull(B.host_brain.ckey))
		ckey = B.host_brain.ckey
		B.host_brain.ckey = null
		B.host_brain.name = "host brain"
		B.host_brain.real_name = "host brain"

	verbs.Remove(/mob/living/carbon/proc/release_control)
	verbs.Remove(/mob/living/carbon/proc/punish_host)
	verbs.Remove(/mob/living/carbon/proc/spawn_larvae)

//Brain slug proc for tormenting the host.
/mob/living/carbon/proc/punish_host()
	set category = "Alien"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple/borer/B = has_brain_worms()
	if(isnull(B))
		return

	if(B.host_brain.ckey)
		to_chat(src, SPAN_DANGER("You send a punishing spike of psychic agony lancing into your host's brain."))
		to_chat(B.host_brain, SPAN_DANGER("<FONT size=3>Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!</FONT>"))

//Check for brain worms in head.
/mob/proc/has_brain_worms()
	for(var/I in contents)
		if(istype(I, /mob/living/simple/borer))
			return I

	return 0

/mob/living/carbon/proc/spawn_larvae()
	set category = "Alien"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple/borer/B = has_brain_worms()
	if(isnull(B))
		return

	if(B.chemicals >= 100)
		to_chat(src, SPAN_DANGER("Your host twitches and quivers as you rapdly excrete several larvae from your sluglike body."))
		visible_message(SPAN_DANGER("[src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!"))
		B.chemicals -= 100

		new /obj/effect/decal/cleanable/vomit(GET_TURF(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple/borer(GET_TURF(src))
	else
		to_chat(src, "You do not have enough chemicals stored to reproduce.")