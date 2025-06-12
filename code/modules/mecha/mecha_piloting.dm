// Entering an exosuit via drag-and-drop.
/obj/mecha/MouseDrop_T(atom/dropping, mob/user)
	if(user.stat || !ishuman(user))
		return
	log_message("[user] tries to move in.")
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.handcuffed)
			to_chat(user, SPAN_WARNING("Kinda hard to climb in while handcuffed, don't you think?"))
			return
	if(isnotnull(occupant))
		to_chat(user, SPAN_WARNING("\The [src] is already occupied!"))
		log_append_to_last("Permission denied.")
		return

	var/passed = FALSE
	if(isnotnull(dna))
		if(user.dna.unique_enzymes == dna)
			passed = TRUE
	else if(operation_allowed(user))
		passed = TRUE
	if(!passed)
		FEEDBACK_ACCESS_DENIED(user)
		log_append_to_last("Permission denied.")
		return

	for(var/mob/living/carbon/slime/M in range(1, user))
		if(M.Victim == user)
			to_chat(user, SPAN_WARNING("You're too busy getting your life sucked out of you."))
			return

	user.visible_message(
		SPAN_INFO("[user] starts to climb into \the [src]."),
		SPAN_INFO("You start to climb into \the [src].")
	)

	if(do_after(user, 4 SECONDS, src))
		if(isnull(occupant))
			moved_inside(user)
		else if(occupant != user)
			to_chat(user, SPAN_WARNING("\The [occupant] was faster. Try better next time, loser."))
	else
		to_chat(user, SPAN_INFO("You stop entering the exosuit."))

/obj/mecha/proc/moved_inside(mob/living/carbon/human/H)
	if(isnotnull(H?.client) && (H in range(1)))
		H.reset_view(src)
		/*
		H.client.perspective = EYE_PERSPECTIVE
		H.client.eye = src
		*/
		H.stop_pulling()
		H.forceMove(src)
		occupant = H
		add_fingerprint(H)
		forceMove(loc)
		log_append_to_last("[H] moved in as pilot.")
		icon_state = reset_icon()
		set_dir(entry_direction)
		H.visible_message(
			SPAN_INFO("[H] climbs into \the [src]."),
			SPAN_INFO("You climb into \the [src].")
		)
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		if(!internal_damage)
			occupant << sound('sound/mecha/voice/nominal.ogg', volume = 50)
		return TRUE
	return FALSE

/obj/mecha/proc/mmi_move_inside(obj/item/mmi/mmi_as_oc, mob/user)
	if(isnull(mmi_as_oc.brainmob?.client))
		to_chat(user, SPAN_WARNING("Consciousness matrix not detected."))
		return FALSE
	else if(mmi_as_oc.brainmob.stat)
		to_chat(user, SPAN_WARNING("Beta-rhythm below acceptable level."))
		return FALSE
	else if(isnotnull(occupant))
		to_chat(user, SPAN_WARNING("Occupant detected."))
		return FALSE
	else if(isnotnull(dna) && dna != mmi_as_oc.brainmob.dna.unique_enzymes)
		to_chat(user, SPAN_WARNING("Stop it!"))
		return FALSE
	//Added a message here since people assume their first click failed or something./N
//	user << "Installing MMI, please stand by."

	user.visible_message(
		SPAN_INFO("[user] starts to insert an MMI into \the [src]."),
		SPAN_INFO("You start to insert an MMI into \the [src].")
	)

	if(do_after(user, 4 SECONDS))
		if(isnull(occupant))
			return mmi_moved_inside(mmi_as_oc, user)
		else
			to_chat(user, SPAN_WARNING("Occupant detected."))
	else
		to_chat(user, SPAN_INFO("You stop inserting the MMI."))
	return FALSE

/obj/mecha/proc/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	if(isnotnull(mmi_as_oc) && (user in range(1)))
		if(isnull(mmi_as_oc.brainmob?.client))
			to_chat(user, SPAN_WARNING("Consciousness matrix not detected."))
			return FALSE
		else if(mmi_as_oc.brainmob.stat)
			to_chat(user, SPAN_WARNING("Beta-rhythm below acceptable level."))
			return FALSE
		user.drop_from_inventory(mmi_as_oc)
		var/mob/living/brain/brainmob = mmi_as_oc.brainmob
		brainmob.reset_view(src)
	/*
		brainmob.client.eye = src
		brainmob.client.perspective = EYE_PERSPECTIVE
	*/
		occupant = brainmob
		brainmob.forceMove(src) //should allow relaymove
		brainmob.canmove = TRUE
		mmi_as_oc.forceMove(src)
		verbs.Remove(/obj/mecha/verb/eject)
		icon_state = reset_icon()
		set_dir(entry_direction)
		log_message("[mmi_as_oc] moved in as pilot.")
		if(!internal_damage)
			occupant << sound('sound/mecha/voice/nominal.ogg', volume = 50)
		return TRUE
	return FALSE