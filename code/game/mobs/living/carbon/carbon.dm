/mob/living/carbon/Life()
	. = ..()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(80))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != DEAD)
			src.nutrition -= HUNGER_FACTOR/10
			if(IS_RUNNING(src))
				src.nutrition -= HUNGER_FACTOR/10
		if((FAT in src.mutations) && IS_RUNNING(src) && src.bodytemperature <= 360)
			src.bodytemperature += 2

		// Moving around increases germ_level faster
		if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
			germ_level++

/mob/living/carbon/relaymove(mob/user, direction)
	if(user in src.stomach_contents)
		if(prob(40))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(SPAN_WARNING("You hear something rumbling inside [src]'s stomach..."), 2)
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
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
					src.take_organ_damage(d)
				for(var/mob/M in viewers(user, null))
					if(M.client)
						M.show_message(SPAN_DANGER("[user] attacks [src]'s stomach wall with the [I.name]!"), 2)
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()

/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(SPAN_DANGER("[M] bursts out of [src]!"), 2)
	. = ..(null, 1)

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!iscarbon(M))
		return

	if(hasorgans(M))
		var/datum/organ/external/temp = M:organs_by_name["r_hand"]
		if(M.hand)
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

	return

/mob/living/carbon/attack_paw(mob/M as mob)
	if(!iscarbon(M))
		return

	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

	return

/mob/living/carbon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0)
	if(status_flags & GODMODE)
		return 0	//godmode
	shock_damage *= siemens_coeff
	if(shock_damage < 1)
		return 0
	src.take_overall_damage(0, shock_damage, used_weapon = "Electrocution")
	//src.burn_skin(shock_damage)
	//src.adjustFireLoss(shock_damage) //burn_skin will do this for us
	//src.updatehealth()
	src.visible_message(
		SPAN_WARNING("[src] was shocked by the [source]!"), \
		SPAN_DANGER("You feel a powerful shock course through your body!"), \
		SPAN_WARNING("You hear a heavy electrical crack.") \
	)
//	if(src.stunned < shock_damage)	src.stunned = shock_damage
	Stun(10)//This should work for now, more is really silly and makes you lay there forever
//	if(src.weakened < 20*siemens_coeff)	src.weakened = 20*siemens_coeff
	Weaken(10)
	return shock_damage


/mob/living/carbon/proc/swap_hand()
	var/obj/item/item_in_hand = src.get_active_hand()
	if(item_in_hand) //this segment checks if the item in your hand is twohanded.
		if(istype(item_in_hand, /obj/item/weapon/twohanded))
			if(item_in_hand:wielded == 1)
				to_chat(usr, SPAN_WARNING("Your other hand is too busy holding the [item_in_hand.name]."))
				return
	src.hand = !src.hand
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
	if(src.health >= CONFIG_GET(health_threshold_crit))
		if(src == M && ishuman(src))
			var/mob/living/carbon/human/H = src
			src.visible_message(
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
				src.show_message("\t [status == "OK" ? "\blue " : "\red "]My [org.display_name] is [status].", 1)
			if((SKELETON in H.mutations) && !H.w_uniform && !H.wear_suit)
				H.play_xylophone()
		else
			var/t_him = "it"
			if(src.gender == MALE)
				t_him = "him"
			else if(src.gender == FEMALE)
				t_him = "her"
			if(ishuman(src) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)
			src.sleeping = max(0, src.sleeping - 5)
			if(src.sleeping == 0)
				src.resting = 0
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
		if(H.gloves)
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
	if(src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/living/carbon/proc/throw_mode_off()
	src.in_throw_mode = 0
	if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_off"

/mob/living/carbon/proc/throw_mode_on()
	src.in_throw_mode = 1
	if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"

/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	src.throw_mode_off()
	if(usr.stat || !target)
		return
	if(target.type == /obj/screen)
		return

	var/atom/movable/item = src.get_active_hand()

	if(!item)
		return

	if(istype(item, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = item
		item = G.thrown() //throw the person instead of the grab
		if(ismob(item))
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/mob/M = item
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been thrown by [usr.name] ([usr.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")
				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")
				msg_admin_attack("[usr.name] ([usr.ckey]) has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")

	if(!item)
		return //Grab processing has a chance of returning null

	item.reset_plane_and_layer()
	u_equip(item)
	update_icons()

	if(iscarbon(usr)) //Check if a carbon mob is throwing. Modify/remove this line as required.
		item.loc = src.loc
		if(src.client)
			src.client.screen -= item
		if(isitem(item))
			item:dropped(src) // let it know it's been dropped

	//actually throw it!
	if(item)
		src.visible_message(SPAN_WARNING("[src] has thrown [item]."))

		if(!src.lastarea)
			src.lastarea = get_area(src.loc)
		if(isspace(src.loc) || !src.lastarea.has_gravity)
			src.inertia_dir = get_dir(target, src)
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
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/stool/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if(handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)
		return 0

	else if(W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()

	else if(W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
		..()

	return

/mob/living/carbon/show_inv(mob/living/carbon/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(handcuffed ? text("<A href='?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(src.pulse)
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
	set name = "Sleep"
	set category = "IC"

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
		src.spread_disease_to(AM, "Contact")

//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()
	set category = "Alien"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.controlling)
		to_chat(src, SPAN_DANGER("You withdraw your probosci, releasing control of [B.host_brain]."))
		to_chat(B.host_brain, SPAN_DANGER("Your vision swims as the alien parasite releases control of your body."))
		B.ckey = ckey
		B.controlling = 0
	if(B.host_brain.ckey)
		ckey = B.host_brain.ckey
		B.host_brain.ckey = null
		B.host_brain.name = "host brain"
		B.host_brain.real_name = "host brain"

	verbs -= /mob/living/carbon/proc/release_control
	verbs -= /mob/living/carbon/proc/punish_host
	verbs -= /mob/living/carbon/proc/spawn_larvae

//Brain slug proc for tormenting the host.
/mob/living/carbon/proc/punish_host()
	set category = "Alien"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.host_brain.ckey)
		to_chat(src, SPAN_DANGER("You send a punishing spike of psychic agony lancing into your host's brain."))
		to_chat(B.host_brain, SPAN_DANGER("<FONT size=3>Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!</FONT>"))

//Check for brain worms in head.
/mob/proc/has_brain_worms()
	for(var/I in contents)
		if(istype(I, /mob/living/simple_animal/borer))
			return I

	return 0

/mob/living/carbon/proc/spawn_larvae()
	set category = "Alien"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.chemicals >= 100)
		to_chat(src, SPAN_DANGER("Your host twitches and quivers as you rapdly excrete several larvae from your sluglike body."))
		visible_message(SPAN_DANGER("[src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!"))
		B.chemicals -= 100

		new /obj/effect/decal/cleanable/vomit(get_turf(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(src))

	else
		to_chat(src, "You do not have enough chemicals stored to reproduce.")
		return

/mob/living/carbon/ui_toggle_internals()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
			if(C.internal)
				C.internal = null
				to_chat(C, SPAN_NOTICE("No longer running on internals."))
				if(C.internals)
					C.internals.icon_state = "internal0"
			else
				if(!istype(C.wear_mask, /obj/item/clothing/mask))
					to_chat(C, SPAN_NOTICE("You are not wearing a mask."))
					return 1
				else
					var/list/nicename = null
					var/list/tankcheck = null
					var/breathes = GAS_OXYGEN	//default, we'll check later
					var/list/contents = list()

					if(ishuman(C))
						var/mob/living/carbon/human/H = C
						breathes = H.species.breath_type
						nicename = list("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
						tankcheck = list(H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
					else
						nicename = list("Right Hand", "Left Hand", "Back")
						tankcheck = list(C.r_hand, C.l_hand, C.back)

					for(var/i = 1, i < length(tankcheck) + 1, ++i)
						if(istype(tankcheck[i], /obj/item/weapon/tank))
							var/obj/item/weapon/tank/t = tankcheck[i]
							if(!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc, breathes))
								contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
								continue					//in it, so we're going to believe the tank is what it says it is
							switch(breathes)
								//These tanks we're sure of their contents
								if(GAS_NITROGEN)							//So we're a bit more picky about them.
									if(t.air_contents.gas[GAS_NITROGEN] && !t.air_contents.gas[GAS_OXYGEN])
										contents.Add(t.air_contents.gas[GAS_NITROGEN])
									else
										contents.Add(0)

								if(GAS_OXYGEN)
									if(t.air_contents.gas[GAS_OXYGEN] && !t.air_contents.gas[GAS_PLASMA])
										contents.Add(t.air_contents.gas[GAS_OXYGEN])
									else
										contents.Add(0)

								// No races breath this, but never know about downstream servers.
								if(GAS_CARBON_DIOXIDE)
									if(t.air_contents.gas[GAS_CARBON_DIOXIDE] && !t.air_contents.gas[GAS_PLASMA])
										contents.Add(t.air_contents.gas[GAS_CARBON_DIOXIDE])
									else
										contents.Add(0)

								// Plasmalins breath this.
								if(GAS_PLASMA)
									if(t.air_contents.gas[GAS_PLASMA] && !t.air_contents.gas[GAS_OXYGEN])
										contents.Add(t.air_contents.gas[GAS_PLASMA])
									else
										contents.Add(0)
						else
							//no tank so we set contents to 0
							contents.Add(0)

					//Alright now we know the contents of the tanks so we have to pick the best one.
					var/best = 0
					var/bestcontents = 0
					for(var/i = 1, i < length(contents) + 1, ++i)
						if(!contents[i])
							continue
						if(contents[i] > bestcontents)
							best = i
							bestcontents = contents[i]

					//We've determined the best container now we set it as our internals
					if(best)
						to_chat(C, SPAN_NOTICE("You are now running on internals from [tankcheck[best]] on your [nicename[best]]."))
						C.internal = tankcheck[best]

					if(C.internal)
						if(C.internals)
							C.internals.icon_state = "internal1"
					else
						to_chat(C, SPAN_NOTICE("You don't have a[breathes == GAS_OXYGEN ? "n oxygen" : addtext(" ", breathes)] tank."))