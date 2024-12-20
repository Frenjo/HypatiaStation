/////////////////////////
////////  Verbs  ////////
/////////////////////////
/obj/mecha/verb/connect_to_port()
	set category = "Exosuit Interface"
	set name = "Connect To Port"
	set popup_menu = 0
	set src = usr.loc

	if(isnull(occupant))
		return
	if(usr != occupant)
		return

	var/obj/machinery/atmospherics/unary/portables_connector/possible_port = locate(/obj/machinery/atmospherics/unary/portables_connector/) in loc
	if(isnull(possible_port))
		occupant_message(SPAN_WARNING("Nothing happens."))
		return
	if(connect(possible_port))
		occupant_message(SPAN_INFO("\The [src] connects to the port."))
		verbs.Add(/obj/mecha/verb/disconnect_from_port)
		verbs.Remove(/obj/mecha/verb/connect_to_port)
		return
	occupant_message(SPAN_WARNING("\The [src] fails to connect to the port."))

/obj/mecha/verb/disconnect_from_port()
	set category = "Exosuit Interface"
	set name = "Disconnect From Port"
	set popup_menu = 0
	set src = usr.loc

	if(isnull(occupant))
		return
	if(usr != occupant)
		return

	if(disconnect())
		occupant_message(SPAN_INFO("\The [src] disconnects from the port."))
		verbs.Remove(/obj/mecha/verb/disconnect_from_port)
		verbs.Remove(/obj/mecha/verb/connect_to_port)
	else
		occupant_message(SPAN_WARNING("\The [src] is not connected to a port at the moment."))

/obj/mecha/verb/toggle_lights()
	set category = "Exosuit Interface"
	set name = "Toggle Lights"
	set popup_menu = 0
	set src = usr.loc

	if(usr != occupant)
		return

	lights = !lights
	if(lights)
		set_light(luminosity + lights_power)
	else
		set_light(luminosity - lights_power)
	occupant_message(SPAN_INFO("Toggled lights [lights ? "on" : "off"]."))
	log_message("Toggled lights [lights ? "on" : "off"].")

/obj/mecha/verb/toggle_internal_tank()
	set category = "Exosuit Interface"
	set name = "Toggle Internal Airtank Usage"
	set src = usr.loc
	set popup_menu = 0

	if(usr != occupant)
		return

	use_internal_tank = !use_internal_tank
	occupant_message(SPAN_INFO("Now taking air from [use_internal_tank ? "internal airtank" : "environment"]."))
	log_message("Now taking air from [use_internal_tank ? "internal airtank" : "environment"].")

/obj/mecha/verb/move_inside()
	set category = PANEL_OBJECT
	set name = "Enter Exosuit"
	set src in oview(1)

	if(usr.stat || !ishuman(usr))
		return
	log_message("[usr] tries to move in.")
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			to_chat(usr, SPAN_WARNING("Kinda hard to climb in while handcuffed, don't you think?"))
			return
	if(isnotnull(occupant))
		to_chat(usr, SPAN_INFO_B("\The [src] is already occupied!"))
		log_append_to_last("Permission denied.")
		return
/*
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
*/
	var/passed = FALSE
	if(isnotnull(dna))
		if(usr.dna.unique_enzymes == dna)
			passed = TRUE
	else if(operation_allowed(usr))
		passed = TRUE
	if(!passed)
		FEEDBACK_ACCESS_DENIED(usr)
		log_append_to_last("Permission denied.")
		return
	for(var/mob/living/carbon/slime/M in range(1, usr))
		if(M.Victim == usr)
			to_chat(usr, SPAN_WARNING("You're too busy getting your life sucked out of you."))
			return

	usr.visible_message(
		SPAN_INFO("[usr] starts to climb into \the [src]."),
		SPAN_INFO("You start to climb into \the [src].")
	)

	if(enter_after(40, usr))
		if(isnull(occupant))
			moved_inside(usr)
		else if(occupant != usr)
			to_chat(usr, SPAN_WARNING("\The [occupant] was faster. Try better next time, loser."))
	else
		to_chat(usr, SPAN_INFO("You stop entering the exosuit."))

/obj/mecha/proc/moved_inside(mob/living/carbon/human/H)
	if(isnotnull(H) && isnotnull(H.client) && (H in range(1)))
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
		set_dir(SOUTH)
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		if(!hasInternalDamage())
			occupant << sound('sound/mecha/nominal.ogg', volume = 50)
		return TRUE
	return FALSE

/obj/mecha/proc/mmi_move_inside(obj/item/mmi/mmi_as_oc, mob/user)
	if(isnull(mmi_as_oc.brainmob) || isnull(mmi_as_oc.brainmob.client))
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

	if(enter_after(40, user))
		if(isnull(occupant))
			return mmi_moved_inside(mmi_as_oc, user)
		else
			to_chat(user, SPAN_WARNING("Occupant detected."))
	else
		to_chat(user, SPAN_INFO("You stop inserting the MMI."))
	return FALSE

/obj/mecha/proc/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	if(isnotnull(mmi_as_oc) && (user in range(1)))
		if(isnull(mmi_as_oc.brainmob) || isnull(mmi_as_oc.brainmob.client))
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
		brainmob.loc = src //should allow relaymove
		brainmob.canmove = TRUE
		mmi_as_oc.loc = src
		mmi_as_oc.mecha = src
		verbs.Remove(/obj/mecha/verb/eject)
		Entered(mmi_as_oc)
		Move(loc)
		icon_state = reset_icon()
		set_dir(SOUTH)
		log_message("[mmi_as_oc] moved in as pilot.")
		if(!hasInternalDamage())
			occupant << sound('sound/mecha/nominal.ogg', volume = 50)
		return TRUE
	return FALSE

/obj/mecha/verb/view_stats()
	set category = "Exosuit Interface"
	set name = "View Stats"
	set popup_menu = 0
	set src = usr.loc

	if(usr != occupant)
		return

	//pr_update_stats.start()
	occupant << browse(get_stats_html(), "window=exosuit")

/*
/obj/mecha/verb/force_eject()
	set category = PANEL_OBJECT
	set name = "Force Eject"
	set src in view(5)

	go_out()
*/

/obj/mecha/verb/eject()
	set category = "Exosuit Interface"
	set name = "Eject"
	set popup_menu = 0
	set src = usr.loc

	if(usr != occupant)
		return

	go_out()
	add_fingerprint(usr)

/obj/mecha/proc/go_out()
	if(isnull(occupant))
		return
	var/atom/movable/mob_container
	if(ishuman(occupant))
		mob_container = occupant
	else if(isbrain(occupant))
		var/mob/living/brain/brain = occupant
		mob_container = brain.container
	else
		return
	if(mob_container.forceMove(loc))//ejecting mob container
	/*
		if(ishuman(occupant) && (return_pressure() > HAZARD_HIGH_PRESSURE))
			use_internal_tank = 0
			var/datum/gas_mixture/environment = get_turf_air()
			if(environment)
				var/env_pressure = environment.return_pressure()
				var/pressure_delta = (cabin.return_pressure() - env_pressure)
		//Can not have a pressure delta that would cause environment pressure > tank pressure

				var/transfer_moles = 0
				if(pressure_delta > 0)
					transfer_moles = pressure_delta*environment.volume/(cabin.return_temperature() * R_IDEAL_GAS_EQUATION)

			//Actually transfer the gas
					var/datum/gas_mixture/removed = cabin.air_contents.remove(transfer_moles)
					loc.assume_air(removed)

			occupant.SetStunned(5)
			occupant.SetWeakened(5)
			occupant << "You were blown out of the mech!"
	*/
		log_message("[mob_container] moved out.")
		occupant.reset_view()
		/*
		if(isnotnull(occupant.client))
			occupant.client.eye = occupant.client.mob
			occupant.client.perspective = MOB_PERSPECTIVE
		*/
		occupant << browse(null, "window=exosuit")
		if(istype(mob_container, /obj/item/mmi)) // This should also cover /obj/item/mmi/posibrain.
			var/obj/item/mmi/mmi = mob_container
			if(isnotnull(mmi.brainmob))
				occupant.loc = mmi
			mmi.mecha = null
			occupant.canmove = FALSE
			verbs.Add(/obj/mecha/verb/eject)
		occupant = null
		icon_state = reset_icon() + "-open"
		set_dir(SOUTH)