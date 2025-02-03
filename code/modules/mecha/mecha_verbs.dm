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
	set name = "Toggle Internal Air Tank Usage"
	set src = usr.loc
	set popup_menu = 0

	if(usr != occupant)
		return

	use_internal_tank = !use_internal_tank
	occupant_message(SPAN_INFO("Now taking air from [use_internal_tank ? "internal air tank" : "environment"]."))
	log_message("Now taking air from [use_internal_tank ? "internal air tank" : "environment"].")

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
				occupant.forceMove(mmi)
			occupant.canmove = FALSE
			verbs.Add(/obj/mecha/verb/eject)
		occupant = null
		icon_state = reset_icon() + "-open"
		set_dir(entry_direction)
		can_move = TRUE // This ensures that slow mechs don't break due to their do_after() failing when the occupant exits.