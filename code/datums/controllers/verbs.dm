//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/restart_controller(controller in list("Supply Shuttle"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	usr = null
	qdel(src)
	switch(controller)
		if("Supply Shuttle")
			global.supply_controller.process() // Edited this to reflect 'shuttles' port. -Frenjo
			feedback_add_details("admin_verb", "RSupply")
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	return

/client/proc/debug_controller(controller in list("Master", "Ticker", "Air", "Jobs", "Sun", "Radio", "Supply Shuttle", "Emergency Shuttle", "Configuration", "pAI", "Cameras", "Transfer Controller"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Master")
			debug_variables(global.master_controller)
			feedback_add_details("admin_verb", "DMC")
		if("Ticker")
			debug_variables(global.ticker)
			feedback_add_details("admin_verb", "DTicker")
		if("Air")
			debug_variables(global.air_master)
			feedback_add_details("admin_verb", "DAir")
		if("Jobs")
			debug_variables(global.job_master)
			feedback_add_details("admin_verb", "DJobs")
		if("Sun")
			debug_variables(global.sun)
			feedback_add_details("admin_verb", "DSun")
		if("Radio")
			debug_variables(global.radio_controller)
			feedback_add_details("admin_verb", "DRadio")
		if("Supply Shuttle")
			debug_variables(global.supply_controller) // Edited this to reflect 'shuttles' port. -Frenjo
			feedback_add_details("admin_verb", "DSupply")
		if("Emergency Shuttle")
			debug_variables(global.emergency_shuttle)
			feedback_add_details("admin_verb", "DEmergency")
		if("Configuration")
			debug_variables(global.config)
			feedback_add_details("admin_verb", "DConf")
		if("pAI")
			debug_variables(global.pAI_controller)
			feedback_add_details("admin_verb", "DpAI")
		if("Cameras")
			debug_variables(global.cameranet)
			feedback_add_details("admin_verb", "DCameras")
		if("Transfer Controller")
			debug_variables(global.transfer_controller)
			feedback_add_details("admin_verb", "DAutovoter")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return