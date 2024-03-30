// Ported 'shuttles' module from Heaven's Gate - NSS Eternal, 22/11/2019...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

/datum/shuttle/ferry/emergency
	//pass

/datum/shuttle/ferry/emergency/arrived()
	if(istype(in_use, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = in_use
		C.reset_authorisation()

	global.PCemergency.shuttle_arrived()

/datum/shuttle/ferry/emergency/long_jump(area/departing, area/destination, area/interim, travel_time, direction)
	//to_world("shuttle/ferry/emergency/long_jump: departing=[departing], destination=[destination], interim=[interim], travel_time=[travel_time]")
	if(!location)
		travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
	else
		travel_time = SHUTTLE_TRANSIT_DURATION

	//update move_time and launch_time so we get correct ETAs
	move_time = travel_time
	global.PCemergency.launch_time = world.time

	..()

/datum/shuttle/ferry/emergency/move(area/origin, area/destination)
	..(origin, destination)

	if(origin == area_station)	//leaving the station
		global.PCemergency.departed = TRUE

		if(global.PCemergency.evac)
			captain_announce("The emergency shuttle has left the station. Estimate [round(global.PCemergency.estimate_arrival_time() / 60, 1)] minutes until the shuttle docks at Central Command.")
		else
			captain_announce("The crew transfer shuttle has left the station. Estimate [round(global.PCemergency.estimate_arrival_time() / 60, 1)] minutes until the shuttle docks at Central Command.")

/datum/shuttle/ferry/emergency/can_launch(user)
	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if(!C.has_authorisation())
			return 0
	return ..()

/datum/shuttle/ferry/emergency/can_force(user)
	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user

		//initiating or cancelling a launch ALWAYS requires authorisation, but if we are already set to launch anyways than forcing does not.
		//this is so that people can force launch if the docking controller cannot safely undock without needing X heads to swipe.
		if(!(process_state == WAIT_LAUNCH || C.has_authorisation()))
			return 0
	return ..()

/datum/shuttle/ferry/emergency/can_cancel(user)
	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if(!C.has_authorisation())
			return 0
	return ..()

/datum/shuttle/ferry/emergency/launch(user)
	if(!can_launch(user))
		return

	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if(global.PCemergency.autopilot)
			global.PCemergency.autopilot = FALSE
			to_world(SPAN_INFO_B("Alert: The shuttle autopilot has been overridden. Launch sequence initiated!"))

	..(user)

/datum/shuttle/ferry/emergency/force_launch(user)
	if(!can_force(user))
		return

	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if(global.PCemergency.autopilot)
			global.PCemergency.autopilot = FALSE
			to_world(SPAN_INFO_B("Alert: The shuttle autopilot has been overridden. Bluespace drive engaged!"))

	..(user)

/datum/shuttle/ferry/emergency/cancel_launch(user)
	if(!can_cancel(user))
		return

	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if(global.PCemergency.autopilot)
			global.PCemergency.autopilot = FALSE
			to_world(SPAN_INFO_B("Alert: The shuttle autopilot has been overridden. Launch sequence aborted!"))

	..(user)


/obj/machinery/computer/shuttle_control/emergency
	shuttle_tag = "Escape"
	var/debug = 0
	var/req_authorisations = 2
	var/list/authorized = list()

/obj/machinery/computer/shuttle_control/emergency/proc/has_authorisation()
	return (length(authorized) >= req_authorisations || emagged)

/obj/machinery/computer/shuttle_control/emergency/proc/reset_authorisation()
	//no need to reset emagged status. If they really want to go back to the station they can.
	authorized = initial(authorized)

//returns 1 if the ID was accepted and a new authorisation was added, 0 otherwise
/obj/machinery/computer/shuttle_control/emergency/proc/read_authorisation(ident)
	if(!ident)
		return 0
	if(length(authorized) >= req_authorisations)
		return 0	//don't need any more

	var/list/access
	var/auth_name
	var/dna_hash

	if(istype(ident, /obj/item/card/id))
		var/obj/item/card/id/ID = ident
		access = ID.access
		auth_name = "[ID.registered_name] ([ID.assignment])"
		dna_hash = ID.dna_hash

	if(istype(ident, /obj/item/pda))
		var/obj/item/pda/PDA = ident
		access = PDA.id.access
		auth_name = "[PDA.id.registered_name] ([PDA.id.assignment])"
		dna_hash = PDA.id.dna_hash

	if(!access || !istype(access))
		return 0	//not an ID

	if(dna_hash in authorized)
		src.visible_message("[src] buzzes. That ID has already been scanned.")
		return 0

	if(!(ACCESS_BRIDGE in access))
		src.visible_message("[src] buzzes, rejecting [ident].")
		return 0

	src.visible_message("[src] beeps as it scans [ident].")
	authorized[dna_hash] = auth_name
	if(req_authorisations - length(authorized))
		to_world(SPAN_INFO_B("Alert: [req_authorisations - length(authorized)] authorisation\s needed to override the shuttle autopilot."))
	return 1

/obj/machinery/computer/shuttle_control/emergency/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src]'s authorisation protocols have already been shorted!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You short out \the [src]'s authorisation protocols."))
	emagged = TRUE
	return TRUE

/obj/machinery/computer/shuttle_control/emergency/attack_by(obj/item/I, mob/user)
	if(read_authorisation(I))
		return TRUE
	return ..()

/obj/machinery/computer/shuttle_control/emergency/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/list/data
	var/datum/shuttle/ferry/emergency/shuttle = global.PCshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		return

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE)
			shuttle_state = "idle"
		if(SHUTTLE_WARMUP)
			shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT)
			shuttle_state = "in_transit"

	var/shuttle_status
	switch(shuttle.process_state)
		if(IDLE_STATE)
			if(shuttle.in_use)
				shuttle_status = "Busy."
			else if(!shuttle.location)
				shuttle_status = "Standing-by at [GLOBL.current_map.station_name]."
			else
				shuttle_status = "Standing-by at Central Command."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	//build a list of authorisations
	var/list/auth_list[req_authorisations]

	if(!emagged)
		var/i = 1
		for(var/dna_hash in authorized)
			auth_list[i++] = list("auth_name" = authorized[dna_hash], "auth_hash" = dna_hash)

		while(i <= req_authorisations)	//fill up the rest of the list with blank entries
			auth_list[i++] = list("auth_name" = "", "auth_hash" = null)
	else
		for(var/i = 1; i <= req_authorisations; i++)
			auth_list[i] = list("auth_name" = "<font color=\"red\">ERROR</font>", "auth_hash" = null)

	var/has_auth = has_authorisation()

	data = list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = isnotnull(shuttle.docking_controller) ? TRUE : FALSE,
		"docking_status" = isnotnull(shuttle.docking_controller) ? shuttle.docking_controller.get_docking_status() : null,
		"docking_override" = isnotnull(shuttle.docking_controller) ? shuttle.docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(src),
		"can_cancel" = shuttle.can_cancel(src),
		"can_force" = shuttle.can_force(src),
		"auth_list" = auth_list,
		"has_auth" = has_auth,
		"user" = debug ? user : null,
	)

	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(isnull(ui))
		ui = new(user, src, ui_key, "escape_shuttle_control_console.tmpl", "Shuttle Control", 470, 420)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()

/obj/machinery/computer/shuttle_control/emergency/Topic(href, href_list)
	if(..())
		return

	if(href_list["removeid"])
		var/dna_hash = href_list["removeid"]
		authorized.Remove(dna_hash)

	if(!emagged && href_list["scanid"])
		//They selected an empty entry. Try to scan their id.
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(!read_authorisation(H.get_active_hand()))	//try to read what's in their hand first
				read_authorisation(H.wear_id)