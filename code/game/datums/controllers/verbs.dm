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

	debug_variables(global.config)
	feedback_add_details("admin_verb", "DConfiguration")
	message_admins("Admin [key_name_admin(usr)] is debugging the global game configuration.")