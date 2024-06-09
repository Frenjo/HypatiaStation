// Ported 'shuttles' module from Heaven's Gate - NSS Eternal...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon_state = "shuttle"
	circuit = null

	var/shuttle_tag		// Used to coordinate data in shuttle controller.
	var/hacked = FALSE	// Has been emagged, no access restrictions.

/obj/machinery/computer/shuttle_control/attack_hand(mob/user)
	if(..(user))
		return
	//src.add_fingerprint(user)	//shouldn't need fingerprints just for looking at it.
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return 1

	ui_interact(user)

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/list/data
	var/datum/shuttle/ferry/shuttle = global.PCshuttle.shuttles[shuttle_tag]
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
				shuttle_status = "Standing-by at station."
			else
				shuttle_status = "Standing-by at offsite location."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	data = list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.docking_controller ? 1 : 0,
		"docking_status" = shuttle.docking_controller ? shuttle.docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.docking_controller ? shuttle.docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
	)

	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(isnull(ui))
		ui = new(user, src, ui_key, "shuttle_control_console.tmpl", "[shuttle_tag] Shuttle Control", 470, 310)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()

/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	var/datum/shuttle/ferry/shuttle = global.PCshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		return

	if(href_list["move"])
		shuttle.launch(src)
	if(href_list["force"])
		shuttle.force_launch(src)
	else if(href_list["cancel"])
		shuttle.cancel_launch(src)

/obj/machinery/computer/shuttle_control/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(hacked)
		to_chat(user, SPAN_WARNING("\The [src]'s ID checking system has already been shorted!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You short out \the [src]'s ID checking system. It's now available to everyone!"))
	hacked = TRUE
	req_access = list()
	req_one_access = list()
	return TRUE

/obj/machinery/computer/shuttle_control/bullet_act(obj/item/projectile/Proj)
	visible_message("[Proj] ricochets off [src]!")