/*
 * Clickable stat() panel buttons.
 *
 * This is very simple and specifically designed for debugging controllers and processes.
 * Idea stolen from Baystation12 and /tg/station13 which have significantly more complex implementations.
 */
/atom/movable/clickable_stat
	name = "clickable"

	atom_flags = ATOM_FLAG_NO_SCREENTIP

	// The controller or process to debug when the button is clicked.
	VAR_PRIVATE/datum/_target = null

	// The target controller or process' name.
	VAR_PRIVATE/_target_name = null
	// Whether the target is a controller, if not, it's a process.
	VAR_PRIVATE/_is_controller = null

/atom/movable/clickable_stat/New(loc, datum/target, name = null)
	SHOULD_CALL_PARENT(FALSE)

	_target = target
	if(isnotnull(name))
		src.name = name

	if(istype(target, /datum/controller))
		var/datum/controller/controller = target
		_target_name = "[controller.name]"
		_is_controller = TRUE
	else if(istype(target, /datum/process))
		var/datum/process/process = target
		_target_name = "[process.name]"
		_is_controller = FALSE
	else
		// If it's not attached to a controller or a process it just deletes itself.
		qdel(src)

/atom/movable/clickable_stat/Click()
	if(isnull(usr.client.holder) || isnull(_target))
		return

	usr.client.debug_variables(_target)
	feedback_add_details("admin_verb", "D[_target_name]")
	message_admins("Admin [key_name_admin(usr)] is debugging the [_target_name] [_is_controller ? "controller" : "process"].")