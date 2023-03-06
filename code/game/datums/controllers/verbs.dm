/*
 * Controller Verbs
 */
/client/proc/restart_controller(controller in list("Supply"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(isnull(holder))
		return
	switch(controller)
		if("Supply")
			global.CTsupply.process()
			feedback_add_details("admin_verb", "RSupply")
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	return

/client/proc/debug_configuration()
	set category = "Debug"
	set name = "Debug Configuration"
	set desc = "Debug the global configuration object for the game (be careful!)"

	if(isnull(holder))
		return
	
	debug_variables(CONFIG)
	feedback_add_details("admin_verb", "DConfiguration")
	message_admins("Admin [key_name_admin(usr)] is debugging the global game configuration.")

/*
 * Clickable stat() panel buttons.
 *
 * This is very simple and specifically designed for debugging controllers.
 * Idea stolen from Baystation12 and /tg/station13 which have significantly more complex implementations.
 */
/obj/clickable_stat
	name = "clickable"

	// The controller to debug when the button is clicked.
	var/datum/controller/target = null

/obj/clickable_stat/New(loc, text, datum/controller/target)
	. = ..()
	name = text
	src.target = target

/obj/clickable_stat/Click()
	if(isnull(usr.client.holder) || isnull(target))
		return
	
	usr.client.debug_variables(target)
	feedback_add_details("admin_verb", "D[target.name]")
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] controller.")