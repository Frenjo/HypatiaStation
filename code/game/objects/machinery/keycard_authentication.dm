/obj/machinery/keycard_auth
	name = "keycard authentication device"
	desc = "This device is used to trigger station functions, which require more than one ID card to authenticate."
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "auth_off"
	anchored = TRUE

	power_channel = ENVIRON
	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 6
	)

	var/active = FALSE				// This gets set to TRUE on all devices except the one where the initial request was made.
	var/event = ""
	var/screen = 1
	var/confirmed = FALSE			// This variable is set by the device that confirms the request.
	var/confirm_delay = 4 SECONDS	// Was originally 2 seconds, doubled because it was a bit short. -Frenjo
	var/busy = FALSE				// Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/machinery/keycard_auth/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	//1 = select event
	//2 = authenticate

/obj/machinery/keycard_auth/attack_ai(mob/user)
	to_chat(user, "The station AI is not to interact with these devices.")

/obj/machinery/keycard_auth/attack_paw(mob/user)
	to_chat(user, "You are too primitive to use this device.")

/obj/machinery/keycard_auth/attack_by(obj/item/I, mob/user)
	if(stat & (NOPOWER | BROKEN))
		to_chat(user, "This device is not powered.")
		return TRUE

	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/card = I
		if(ACCESS_KEYCARD_AUTH in card.access)
			if(active == TRUE)
				// This is not the device that made the initial request. It is the device confirming the request.
				if(isnotnull(event_source))
					event_source.confirmed = TRUE
					event_source.event_confirmed_by = usr
			else if(screen == 2)
				event_triggered_by = usr
				broadcast_request() // This is the device making the initial event request. It needs to broadcast to other devices
		return TRUE

	return ..()

/obj/machinery/keycard_auth/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		icon_state = "auth_off"
	else
		stat |= NOPOWER

/obj/machinery/keycard_auth/attack_hand(mob/user)
	if(user.stat || stat & (NOPOWER | BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(busy)
		to_chat(user, "This device is busy.")
		return

	user.set_machine(src)

	ui_interact(user) // Added this to reflect NanoUI port. -Frenjo

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/keycard_auth/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/alist/data = alist(
		"screen" = screen,
		"event" = event
	)

	// Ported most of this by studying SMES code. -Frenjo
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "keycard_auth.tmpl", "Keycard Authentication Device", 460, 360)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()

/obj/machinery/keycard_auth/Topic(href, href_list)
	..()
	if(busy)
		to_chat(usr, "This device is busy.")
		return
	if(usr.stat || stat & (BROKEN | NOPOWER))
		to_chat(usr, "This device is without power.")
		return
	if(href_list["triggerevent"])
		event = href_list["triggerevent"]
		screen = 2
	if(href_list["reset"])
		reset()

	updateUsrDialog()
	add_fingerprint(usr)

/obj/machinery/keycard_auth/proc/reset()
	active = FALSE
	event = ""
	screen = 1
	confirmed = FALSE
	event_source = null
	icon_state = "auth_off"
	event_triggered_by = null
	event_confirmed_by = null

/obj/machinery/keycard_auth/proc/broadcast_request()
	icon_state = "auth_on"
	FOR_MACHINES_TYPED(auth, /obj/machinery/keycard_auth)
		if(auth == src)
			continue
		auth.reset()
		spawn()
			auth.receive_request(src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = FALSE
		trigger_event(event)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/machinery/keycard_auth/proc/receive_request(obj/machinery/keycard_auth/source)
	if(stat & (BROKEN | NOPOWER))
		return
	event_source = source
	busy = TRUE
	active = TRUE
	icon_state = "auth_on"

	sleep(confirm_delay)

	event_source = null
	icon_state = "auth_off"
	active = FALSE
	busy = FALSE

/obj/machinery/keycard_auth/proc/trigger_event()
	switch(event)
		if("Red Alert")
			set_security_level(/decl/security_level/red)
			feedback_inc("alert_keycard_auth_red", 1)
		if("Grant Emergency Maintenance Access")
			make_maint_all_access()
			feedback_inc("alert_keycard_auth_maintGrant", 1)
		if("Revoke Emergency Maintenance Access")
			revoke_maint_all_access()
			feedback_inc("alert_keycard_auth_maintRevoke", 1)
		if("Emergency Response Team")
			if(!CONFIG_GET(/decl/configuration_entry/ert_admin_call_only))
				trigger_armed_response_team(1)
				feedback_inc("alert_keycard_auth_ert", 1)

GLOBAL_GLOBL_INIT(maint_all_access, FALSE)

/proc/make_maint_all_access()
	GLOBL.maint_all_access = TRUE
	minor_announce("The maintenance access requirement has been revoked on all maintenance airlocks.", "Attention!")

	// Update all maintenance door icons so they start flashing immediately. -Frenjo
	for_no_type_check(var/obj/machinery/door/airlock/maintenance/M, GLOBL.maintenance_airlocks_list)
		if(isstationlevel(M.z))
			M.update_icon()

/proc/revoke_maint_all_access()
	GLOBL.maint_all_access = FALSE
	minor_announce("The maintenance access requirement has been readded on all maintenance airlocks.", "Attention!")

	// Update all maintenance door icons so they stop flashing immediately. -Frenjo
	for_no_type_check(var/obj/machinery/door/airlock/maintenance/M, GLOBL.maintenance_airlocks_list)
		if(isstationlevel(M.z))
			M.update_icon()