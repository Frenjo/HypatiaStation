// Clickable stat() panel buttons.
// This one's a lot simpler and is specifically used for debugging controllers.
// Idea stolen from Baystation12 and /tg/station13 which have significantly more complex implementations.
/obj/clickable_stat
	name = "clickable"

	// The controller to debug when the button is clicked.
	var/controller

/obj/clickable_stat/New(loc, text, controller)
	..()
	name = text
	src.controller = controller

/obj/clickable_stat/Click()
	if(!usr.client.holder || !controller)
		return
	
	usr.client.debug_variables(controller)
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")