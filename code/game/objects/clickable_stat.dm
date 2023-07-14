/*
 * Clickable stat() panel buttons.
 *
 * This is very simple and specifically designed for debugging controllers and processes.
 * Idea stolen from Baystation12 and /tg/station13 which have significantly more complex implementations.
 */
/obj/clickable_stat
	name = "clickable"

	// The controller or process to debug when the button is clicked.
	var/datum/target = null

	// The target controller or process' name.
	var/target_name = null
	// Whether the target is a controller, if not, it's a process.
	var/is_controller = null

/obj/clickable_stat/New(loc, datum/target, name = null)
	. = ..()
	src.target = target
	if(isnotnull(name))
		src.name = name

	if(istype(target, /datum/controller))
		var/datum/controller/controller = target
		target_name = "[controller.name]"
		is_controller = TRUE
	else if(istype(target, /datum/process))
		var/datum/process/process = target
		target_name = "[process.name]"
		is_controller = FALSE
	else
		// If it's not attached to a controller or a process it just deletes itself.
		qdel(src)

/obj/clickable_stat/Click()
	if(isnull(usr.client.holder) || isnull(target))
		return

	usr.client.debug_variables(target)
	feedback_add_details("admin_verb", "D[target_name]")
	message_admins("Admin [key_name_admin(usr)] is debugging the [target_name] [is_controller ? "controller" : "process"].")