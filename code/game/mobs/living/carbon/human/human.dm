/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list[9]
	var/datum/species/species //Contains icon generation and language information, set during New().
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.

/mob/living/carbon/human/New(new_loc, new_species = null)
	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(!species)
		if(new_species)
			set_species(new_species)
		else
			set_species()

	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	hud_list[HEALTH_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudhealth100")
	hud_list[STATUS_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudhealthy")
	hud_list[ID_HUD]			= image('icons/mob/screen/hud.dmi', src, "hudunknown")
	hud_list[WANTED_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD]	= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD_OOC]	= image('icons/mob/screen/hud.dmi', src, "hudhealthy")

	..()

	if(dna)
		dna.real_name = real_name

	//prev_gender = gender // Debug for plural genders
	make_blood()

/mob/living/carbon/human/Destroy()
	for(var/organ in organs)
		qdel(organ)
	return ..()

/mob/living/carbon/human/Stat()
	..()
	statpanel(PANEL_STATUS)

	stat("Intent:", "[a_intent]")
	stat("Move Mode:", "[move_intent.name]")
	if(IS_GAME_MODE(/datum/game_mode/malfunction))
		var/datum/game_mode/malfunction/malf = global.PCticker.mode
		if(malf.malf_mode_declared)
			stat(null, "Time left: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)]")
	if(global.PCemergency)
		var/timeleft
		if(global.PCemergency.online())
			if(global.PCemergency.has_eta())
				timeleft = global.PCemergency.estimate_arrival_time()
				stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")
			else
				timeleft = global.PCemergency.estimate_launch_time()
				stat(null, "ETD-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

	if(client.statpanel == PANEL_STATUS)
		if(internal)
			if(!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		var/datum/organ/internal/xenos/plasmavessel/P = internal_organs_by_name["plasma vessel"]
		if(P)
			stat(null, "Plasma Stored: [P.stored_plasma]/[P.max_plasma]")

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)
		if(istype(wear_suit, /obj/item/clothing/suit/space/space_ninja) && wear_suit:s_initialized)
			stat("Energy Charge", round(wear_suit:cell:charge / 100))


/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	var/shielded = 0
	var/b_loss = null
	var/f_loss = null
	switch(severity)
		if(1.0)
			b_loss += 500
			if(!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if(2.0)
			if(!shielded)
				b_loss += 60

			f_loss += 60

			if(prob(getarmor(null, "bomb")))
				b_loss = b_loss / 1.5
				f_loss = f_loss / 1.5

			if(!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if(prob(70) && !shielded)
				Paralyse(10)

		if(3.0)
			b_loss += 30
			if(prob(getarmor(null, "bomb")))
				b_loss = b_loss/2
			if(!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if(prob(50) && !shielded)
				Paralyse(10)

	var/update = 0

	// focus most of the blast on one organ
	var/datum/organ/external/take_blast = pick(organs)
	update |= take_blast.take_damage(b_loss * 0.9, f_loss * 0.9, used_weapon = "Explosive blast")

	// distribute the remaining 10% on all limbs equally
	b_loss *= 0.1
	f_loss *= 0.1

	var/weapon_message = "Explosive Blast"

	for(var/datum/organ/external/temp in organs)
		switch(temp.name)
			if("head")
				update |= temp.take_damage(b_loss * 0.2, f_loss * 0.2, used_weapon = weapon_message)
			if("chest")
				update |= temp.take_damage(b_loss * 0.4, f_loss * 0.4, used_weapon = weapon_message)
			if("l_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("l_leg")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_leg")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_foot")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("l_foot")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("r_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if("l_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
	if(update)
		UpdateDamageIcon()


/mob/living/carbon/human/blob_act()
	if(stat == DEAD)
		return
	show_message(SPAN_WARNING("The blob attacks you!"))
	var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
	var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
	apply_damage(rand(30, 40), BRUTE, affecting, run_armor_check(affecting, "melee"))
	return

/mob/living/carbon/human/meteorhit(O as obj)
	visible_message(SPAN_WARNING("[src] has been hit by [O]!"))
	if(health > 0)
		var/datum/organ/external/affecting = get_organ(pick("chest", "chest", "chest", "head"))
		if(!affecting)
			return
		if(istype(O, /obj/effect/immovablerod))
			if(affecting.take_damage(101, 0))
				UpdateDamageIcon()
		else
			if(affecting.take_damage((istype(O, /obj/effect/meteor/small) ? 10 : 25), 30))
				UpdateDamageIcon()
		updatehealth()
	return


/mob/living/carbon/human/attack_animal(mob/living/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message(SPAN_WARNING("<B>[M]</B> [M.attacktext] [src]!"))
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
		var/armor = run_armor_check(affecting, "melee")
		apply_damage(damage, BRUTE, affecting, armor)
		if(armor >= 2)
			return


/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/implant/loyalty))
			for(var/datum/organ/external/O in M.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/attack_slime(mob/living/carbon/slime/M as mob)
	if(M.Victim)
		return // can't attack while eating!

	if(health > -100)
		visible_message(SPAN_DANGER("The [M.name] glomps [src]!"))

		var/damage = rand(1, 3)

		if(isslimeadult(M))
			damage = rand(10, 35)
		else
			damage = rand(5, 25)


		var/dam_zone = pick("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg", "groin")

		var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
		var/armor_block = run_armor_check(affecting, "melee")
		apply_damage(damage, BRUTE, affecting, armor_block)

		if(M.powerlevel > 0)
			var/stunprob = 10
			var/power = M.powerlevel + rand(0,3)

			switch(M.powerlevel)
				if(1 to 2)
					stunprob = 20
				if(3 to 4)
					stunprob = 30
				if(5 to 6)
					stunprob = 40
				if(7 to 8)
					stunprob = 60
				if(9)
					stunprob = 70
				if(10)
					stunprob = 95

			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				visible_message(SPAN_DANGER("The [M.name] has shocked [src]!"))

				Weaken(power)
				if(stuttering < power)
					stuttering = power
				Stun(power)

				var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()

				if(prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6, 10))

		updatehealth()

	return


/mob/living/carbon/human/restrained()
	if(handcuffed)
		return 1
	if(istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C + 75

/mob/living/carbon/human/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Gloves:</B> <A href='?src=\ref[src];item=gloves'>[(gloves ? gloves : "Nothing")]</A>
	<BR><B>Eyes:</B> <A href='?src=\ref[src];item=eyes'>[(glasses ? glasses : "Nothing")]</A>
	<BR><B>Left Ear:</B> <A href='?src=\ref[src];item=l_ear'>[(l_ear ? l_ear : "Nothing")]</A>
	<BR><B>Right Ear:</B> <A href='?src=\ref[src];item=r_ear'>[(r_ear ? r_ear : "Nothing")]</A>
	<BR><B>Head:</B> <A href='?src=\ref[src];item=head'>[(head ? head : "Nothing")]</A>
	<BR><B>Shoes:</B> <A href='?src=\ref[src];item=shoes'>[(shoes ? shoes : "Nothing")]</A>
	<BR><B>Belt:</B> <A href='?src=\ref[src];item=belt'>[(belt ? belt : "Nothing")]</A>
	<BR><B>Uniform:</B> <A href='?src=\ref[src];item=uniform'>[(w_uniform ? w_uniform : "Nothing")]</A>
	<BR><B>(Exo)Suit:</B> <A href='?src=\ref[src];item=suit'>[(wear_suit ? wear_suit : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR><B>ID:</B> <A href='?src=\ref[src];item=id'>[(wear_id ? wear_id : "Nothing")]</A>
	<BR><B>Suit Storage:</B> <A href='?src=\ref[src];item=s_store'>[(s_store ? s_store : "Nothing")]</A>
	<BR>[(handcuffed ? text("<A href='?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(legcuffed ? text("<A href='?src=\ref[src];item=legcuff'>Legcuffed</A>") : text(""))]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=splints'>Remove Splints</A>
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[name];size=340x480"))
	onclose(user, "mob[name]")
	return

// called when something steps onto a human
// this could be made more general, but for now just handle mulebot
/mob/living/carbon/human/Crossed(atom/movable/AM)
	var/obj/machinery/bot/mulebot/mulebot = AM
	if(istype(mulebot))
		mulebot.RunOver(src)

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(if_no_id = "No id", if_no_job = "No job")
	var/obj/item/pda/pda = wear_id
	var/obj/item/card/id/id = wear_id
	if(istype(pda))
		if(pda.id && istype(pda.id, /obj/item/card/id))
			. = pda.id.assignment
		else
			. = pda.ownjob
	else if(istype(id))
		. = id.assignment
	else
		return if_no_id
	if(!.)
		. = if_no_job
	return

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(if_no_id = "Unknown")
	var/obj/item/pda/pda = wear_id
	var/obj/item/card/id/id = wear_id
	if(istype(pda))
		if(pda.id)
			. = pda.id.registered_name
		else
			. = pda.owner
	else if(istype(id))
		. = id.registered_name
	else
		return if_no_id
	return

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if(wear_mask && HAS_INV_FLAGS(wear_mask, INV_FLAG_HIDE_FACE))	//Wearing a mask which hides our face, use id-name if possible
		return get_id_name("Unknown")
	if(head && HAS_INV_FLAGS(head, INV_FLAG_HIDE_FACE))
		return get_id_name("Unknown")		//Likewise for hats
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/datum/organ/external/head/head = get_organ("head")
	if(!head || head.disfigured || (head.status & ORGAN_DESTROYED) || !real_name || (HUSK in mutations))	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(if_no_id = "Unknown")
	. = if_no_id
	if(istype(wear_id, /obj/item/pda))
		var/obj/item/pda/P = wear_id
		return P.owner
	if(isnotnull(wear_id))
		var/obj/item/card/id/I = wear_id.get_id()
		if(isnotnull(I))
			return I.registered_name

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(isnotnull(wear_id))
		return wear_id.get_id()

//Added a safety check in case you want to shock a human mob directly through electrocute_act.
/mob/living/carbon/human/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0, safety = 0)
	if(!safety)
		if(gloves)
			var/obj/item/clothing/gloves/G = gloves
			siemens_coeff = G.siemens_coefficient
	return ..(shock_damage, source, siemens_coeff)


/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["refresh"])
		if(machine && in_range(src, usr))
			show_inv(machine)

	if(href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if(href_list["item"] && !usr.stat && usr.canmove && !usr.restrained() && in_range(src, usr) && global.PCticker) //if game hasn't started, can't make an equip_e
		var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
		O.source = usr
		O.target = src
		O.item = usr.get_active_hand()
		O.s_loc = usr.loc
		O.t_loc = loc
		O.place = href_list["item"]
		requests += O
		spawn(0)
			O.process()
			return

	if(href_list["criminal"])
		if(hasHUD(usr, "security"))
			var/modified = 0
			var/perpname = "wot"
			if(isnotnull(wear_id))
				var/obj/item/card/id/I = wear_id.get_id()
				perpname = isnotnull(I) ? I.registered_name : name
			else
				perpname = name

			if(perpname)
				for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
					if(E.fields["name"] == perpname)
						for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
							if(R.fields["id"] == E.fields["id"])

								var/setcriminal = input(usr, "Specify a new criminal status for this person.", "Security HUD", R.fields["criminal"]) in list("None", "*Arrest*", "Incarcerated", "Parolled", "Released", "Cancel")

								if(hasHUD(usr, "security"))
									if(setcriminal != "Cancel")
										R.fields["criminal"] = setcriminal
										modified = 1

										spawn()
											BITSET(hud_updateflag, WANTED_HUD)
											if(ishuman(usr))
												var/mob/living/carbon/human/U = usr
												U.handle_regular_hud_updates()
											if(isrobot(usr))
												var/mob/living/silicon/robot/U = usr
												U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if(href_list["secrecord"])
		if(hasHUD(usr, "security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id, /obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id, /obj/item/pda))
					var/obj/item/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr, "security"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Criminal Status:</b> [R.fields["criminal"]]")
								to_chat(usr, "<b>Minor Crimes:</b> [R.fields["mi_crim"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["mi_crim_d"]]")
								to_chat(usr, "<b>Major Crimes:</b> [R.fields["ma_crim"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["ma_crim_d"]]")
								to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
								to_chat(usr, "<a href='?src=\ref[src];secrecordComment=`'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if(href_list["secrecordComment"])
		if(hasHUD(usr, "security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id, /obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id, /obj/item/pda))
					var/obj/item/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr, "security"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, text("[]", R.fields[text("com_[]", counter)]))
									counter++
								if(counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if(href_list["secrecordadd"])
		if(hasHUD(usr, "security"))
			var/perpname = "wot"
			if(wear_id)
				if(istype(wear_id, /obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id, /obj/item/pda))
					var/obj/item/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr, "security"))
								var/t1 = copytext(sanitize(input("Add Comment:", "Sec. records", null, null) as message), 1, MAX_MESSAGE_LEN)
								if(!t1 || usr.stat || usr.restrained() || !hasHUD(usr, "security"))
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOBL.game_year]<BR>[t1]")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOBL.game_year]<BR>[t1]")

	if(href_list["medical"])
		if(hasHUD(usr, "medical"))
			var/perpname = "wot"
			var/modified = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/pda))
					var/obj/item/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name

			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.general)
						if(R.fields["id"] == E.fields["id"])

							var/setmedical = input(usr, "Specify a new medical status for this person.", "Medical HUD", R.fields["p_stat"]) in list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel")

							if(hasHUD(usr, "medical"))
								if(setmedical != "Cancel")
									R.fields["p_stat"] = setmedical
									modified = 1
									if(length(GLOBL.pda_manifest))
										GLOBL.pda_manifest.Cut()

									spawn()
										if(ishuman(usr))
											var/mob/living/carbon/human/U = usr
											U.handle_regular_hud_updates()
										if(isrobot(usr))
											var/mob/living/silicon/robot/U = usr
											U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if(href_list["medrecord"])
		if(hasHUD(usr, "medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/pda))
					var/obj/item/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr, "medical"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Blood Type:</b> [R.fields["b_type"]]")
								to_chat(usr, "<b>DNA:</b> [R.fields["b_dna"]]")
								to_chat(usr, "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["mi_dis_d"]]")
								to_chat(usr, "<b>Major Disabilities:</b> [R.fields["ma_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["ma_dis_d"]]")
								to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
								to_chat(usr, "<a href='?src=\ref[src];medrecordComment=`'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if(href_list["medrecordComment"])
		if(hasHUD(usr, "medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/pda))
					var/obj/item/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr, "medical"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, text("[]", R.fields[text("com_[]", counter)]))
									counter++
								if(counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if(href_list["medrecordadd"])
		if(hasHUD(usr, "medical"))
			var/perpname = "wot"
			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/pda))
					var/obj/item/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr, "medical"))
								var/t1 = copytext(sanitize(input("Add Comment:", "Med. records", null, null)  as message), 1, MAX_MESSAGE_LEN)
								if(!t1 || usr.stat || usr.restrained() || !hasHUD(usr, "medical"))
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(ishuman(usr))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOBL.game_year]<BR>[t1]")
								if(isrobot(usr))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOBL.game_year]<BR>[t1]")

	if(href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		I.examine()

	if(href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		M.examine()
	..()
	return


///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()
	var/number = 0

	if(!species.has_organ["eyes"]) //No eyes, can't hurt them.
		return 2

	if(internal_organs_by_name["eyes"]) // Eyes are fucked, not a 'weak point'.
		var/datum/organ/internal/I = internal_organs_by_name["eyes"]
		if(I.is_broken())
			return 2
	else
		return 2

	if(istype(src.head, /obj/item/clothing/head/welding))
		var/obj/item/clothing/head/welding/welding = src.head
		if(!welding.up)
			number += 2
	if(istype(src.head, /obj/item/clothing/head/helmet/space))
		number += 2
	if(istype(src.glasses, /obj/item/clothing/glasses/thermal))
		number -= 1
	if(istype(src.glasses, /obj/item/clothing/glasses/sunglasses))
		number += 1
	if(istype(src.glasses, /obj/item/clothing/glasses/welding))
		var/obj/item/clothing/glasses/welding/welding = src.glasses
		if(!welding.up)
			number += 2
	return number


/mob/living/carbon/human/IsAdvancedToolUser()
	return species.has_fine_manipulation


/mob/living/carbon/human/abiotic(full_body = 0)
	if(full_body && ((src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)))
		return 1

	if((src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract))
		return 1

	return 0


/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()

	if(dna && dna.mutantrace == "golem")
		return "Animated Construct"

	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message(
			SPAN_WARNING("[src] begins playing his ribcage like a xylophone. It's quite spooky."),
			SPAN_INFO("You begin to play a spooky refrain on your ribcage."),
			SPAN_WARNING("You hear a spooky xylophone melody.")
		)
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone = 0
	return

/mob/living/carbon/human/proc/vomit()
	if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_IS_SYNTHETIC))
		return //Machines don't throw up.

	if(!lastpuke)
		lastpuke = 1
		to_chat(src, SPAN_WARNING("You feel nauseous..."))
		spawn(150)	//15 seconds until second warning
			to_chat(src, SPAN_WARNING("You feel like you are about to throw up!"))
			spawn(100)	//and you have 10 more for mad dash to the bucket
				Stun(5)

				visible_message(
					SPAN_WARNING("[src] throws up!"),
					SPAN_WARNING("You throw up!")
				)
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

				var/turf/location = loc
				if(issimulated(location))
					location.add_vomit_floor(src, 1)

				nutrition -= 40
				adjustToxLoss(-3)
				spawn(350)	//wait 35 seconds before next volley
					lastpuke = 0

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(stat != CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mMorph in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation", rgb(r_facial, g_facial, b_facial)) as color
	if(new_facial)
		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation", rgb(r_hair, g_hair, b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext(new_hair, 2, 4))
		g_hair = hex2num(copytext(new_hair, 4, 6))
		b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation", rgb(r_eyes, g_eyes, b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", "[35-s_tone]") as text

	if(!new_tone)
		new_tone = 35
	s_tone = max(min(round(text2num(new_tone)), 220), 1)
	s_tone = -s_tone + 35

	// Hair.
	var/new_style = input("Please select hair style", "Character Generation", h_style) as null | anything in GLOBL.hair_styles_list
	// If new style selected (not cancel.)
	if(new_style)
		h_style = new_style

	// Facial hair.
	new_style = input("Please select facial style", "Character Generation", f_style) as null | anything in GLOBL.facial_hair_styles_list
	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if(new_gender)
		if(new_gender == "Male")
			gender = MALE
		else
			gender = FEMALE
	regenerate_icons()
	check_dna()

	visible_message(
		SPAN_INFO("\The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!"),
		SPAN_INFO("You change your appearance!"),
		SPAN_WARNING("Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!")
	)

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(stat != CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in GLOBL.mob_list)
		creatures += h
	var/mob/target = input ("Who do you want to project your mind to ?") as null|anything in creatures
	if(isnull(target))
		return

	var/say = input ("What do you wish to say")
	if(mRemotetalk in target.mutations)
		target.show_message(SPAN_INFO("You hear [src.real_name]'s voice: [say]"))
	else
		target.show_message(SPAN_INFO("You hear a voice that seems to echo around the room: [say]"))
	usr.show_message(SPAN_INFO("You project your mind into [target.real_name]: [say]"))
	for(var/mob/dead/observer/G in GLOBL.mob_list)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat != CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target = null
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in GLOBL.mob_list)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat != CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if(target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target = null
		reset_view(0)

/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_JUMPSUIT) && ((head && HAS_INV_FLAGS(head, INV_FLAG_HIDE_MASK)) || wear_mask))
		return NEUTER
	return gender

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()
	for(var/datum/organ/external/O in organs)
		O.status &= ~ORGAN_BROKEN
		O.status &= ~ORGAN_BLEEDING
		O.status &= ~ORGAN_SPLINTED
		O.status &= ~ORGAN_CUT_AWAY
		O.status &= ~ORGAN_ATTACHABLE
		if(!O.amputated)
			O.status &= ~ORGAN_DESTROYED
			O.destspawn = 0
		O.wounds.Cut()
		O.heal_damage(1000, 1000, 1, 1)

	var/datum/organ/external/head/h = organs_by_name["head"]
	h.disfigured = 0

	if(isnotnull(species) && !HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_BLOOD))
		vessel.add_reagent("blood", 560 - vessel.total_volume)
		fixblood()

	for(var/obj/item/organ/head/H in GLOBL.movable_atom_list)
		if(H.brainmob)
			if(H.brainmob.real_name == src.real_name)
				if(H.brainmob.mind)
					H.brainmob.mind.transfer_to(src)
					qdel(H)

	for(var/E in internal_organs)
		var/datum/organ/internal/I = internal_organs[E]
		I.damage = 0

	for(var/datum/disease/virus in viruses)
		virus.cure()
	for(var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/datum/organ/internal/lungs/L = internal_organs["lungs"]
	return L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/datum/organ/internal/lungs/L = internal_organs["lungs"]

	if(!L.is_bruised())
		src.custom_pain("You feel a stabbing pain in your chest!", 1)
		L.damage = L.min_bruised_damage

/*
/mob/living/carbon/human/verb/simulate()
	set name = "sim"
	set background = BACKGROUND_ENABLED

	var/damage = input("Wound damage","Wound damage") as num

	var/germs = 0
	var/tdamage = 0
	var/ticks = 0
	while (germs < 2501 && ticks < 100000 && round(damage/10)*20)
		log_misc("VIRUS TESTING: [ticks] : germs [germs] tdamage [tdamage] prob [round(damage/10)*20]")
		ticks++
		if (prob(round(damage/10)*20))
			germs++
		if (germs == 100)
			to_world("Reached stage 1 in [ticks] ticks")
		if (germs > 100)
			if (prob(10))
				damage++
				germs++
		if (germs == 1000)
			to_world("Reached stage 2 in [ticks] ticks")
		if (germs > 1000)
			damage++
			germs++
		if (germs == 2500)
			to_world("Reached stage 3 in [ticks] ticks")
	to_world("Mob took [tdamage] tox damage")
*/
//returns 1 if made bloody, returns 0 otherwise

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if(!..())
		return 0
	//if this blood isn't already in the list, add it
	if(blood_DNA[M.dna.unique_enzymes])
		return 0 //already bloodied with this blood. Cannot add more.
	blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/clean_blood(clean_feet)
	.=..()
	if(clean_feet && !shoes && length(feet_blood_DNA))
		feet_blood_color = null
		qdel(feet_blood_DNA)
		update_inv_shoes(1)
		return 1

/mob/living/carbon/human/get_visible_implants(class = 0)
	var/list/visible_implants = list()
	for(var/datum/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && O.w_class > class)
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/proc/handle_embedded_objects()
	for(var/datum/organ/external/organ in src.organs)
		if(organ.status & ORGAN_SPLINTED) //Splints prevent movement.
			continue
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/implant) && prob(5)) //Moving with things stuck in you could be bad.
				// All kinds of embedded objects cause bleeding.
				var/msg = null
				switch(rand(1, 3))
					if(1)
						msg = SPAN_WARNING("A spike of pain jolts your [organ.display_name] as you bump [O] inside.")
					if(2)
						msg = SPAN_WARNING("Your movement jostles [O] in your [organ.display_name] painfully.")
					if(3)
						msg = SPAN_WARNING("[O] in your [organ.display_name] twists painfully as you move.")
				to_chat(src, msg)

				organ.take_damage(rand(1, 3), 0, 0)
				if(!(organ.status & ORGAN_ROBOT)) //There is no blood in protheses.
					organ.status |= ORGAN_BLEEDING
					src.adjustToxLoss(rand(1, 3))

/mob/living/carbon/human/verb/check_pulse()
	set category = PANEL_OBJECT
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat == UNCONSCIOUS || usr.restrained() || !isliving(usr))
		return

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message(
			SPAN_INFO("[usr] kneels down, puts \his hand on [src]'s wrist and begins counting their pulse."),
			"You begin counting [src]'s pulse"
		)
	else
		usr.visible_message(
			SPAN_INFO("[usr] begins counting their pulse."),
			"You begin counting your pulse."
		)

	if(src.pulse)
		to_chat(usr, SPAN_INFO("[self ? "You have a" : "[src] has a"] pulse! Counting..."))
	else
		to_chat(usr, SPAN_WARNING("[src] has no pulse!"))	//it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	to_chat(usr, "Don't move until counting is finished.")
	var/time = world.time
	sleep(60)
	if(usr.l_move_time >= time)	//checks if our mob has moved during the sleep()
		to_chat(usr, "You moved while counting. Try again.")
	else
		to_chat(usr, SPAN_INFO("[self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)]."))

/mob/living/carbon/human/proc/set_species(new_species, force_organs)
	if(isnull(dna))
		if(isnull(new_species))
			new_species = SPECIES_HUMAN
	else
		if(isnull(new_species))
			new_species = dna.species
		else
			dna.species = new_species

	if(isnotnull(species))
		if(isnotnull(species.name) && species.name == new_species)
			return
		if(isnotnull(species.language))
			remove_language(species.language)

	species = GLOBL.all_species[new_species]

	if(force_organs || !length(organs))
		species.create_organs(src)

	if(isnotnull(species.language))
		add_language(species.language)

	spawn(0)
		update_icons()
		if(!HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_BLOOD))
			vessel.add_reagent("blood", 560 - vessel.total_volume)

	mob_bump_flag = species.bump_flag
	mob_swap_flags = species.swap_flags
	mob_push_flags = species.push_flags

	if(isnotnull(species))
		species.handle_post_spawn(src)
		return 1
	else
		return 0

/mob/living/carbon/human/proc/bloody_doodle()
	set category = PANEL_IC
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if(src.stat)
		return

	if(usr != src)
		return 0 //something is terribly wrong

	if(!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if(src.gloves)
		to_chat(src, SPAN_WARNING("Your [src.gloves] are getting in the way."))
		return

	var/turf/simulated/T = src.loc
	if(!istype(T)) //to prevent doodling out of mechs and lockers
		to_chat(src, SPAN_WARNING("You cannot reach the floor."))
		return

	var/direction = input(src, "Which way?", "Tile selection") as anything in list("Here", "North", "South", "East", "West")
	if(direction != "Here")
		T = get_step(T, text2dir(direction))
	if(!istype(T))
		to_chat(src, SPAN_WARNING("You cannot doodle there."))
		return

	var/num_doodles = 0
	for(var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if(num_doodles > 4)
		to_chat(src, SPAN_WARNING("There is no space to write on!"))
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = stripped_input(src, "Write a message. It cannot be longer than [max_length] characters.", "Blood writing", "")

	if(message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if(length(message) > max_length)
			message += "-"
			to_chat(src, SPAN_WARNING("You ran out of blood to write with!"))

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/getDNA()
	if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_SCAN))
		return null
	..()

/mob/living/carbon/human/setDNA()
	if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_SCAN))
		return
	..()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name["brain"])
		var/datum/organ/internal/brain = internal_organs_by_name["brain"]
		if(brain && istype(brain))
			return 1
	return 0