//these are probably broken

/obj/machinery/floodlight
	name = "emergency floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE

	var/on = 0
	var/obj/item/cell/cell = null
	var/use = 5
	var/unlocked = 0
	var/open = 0
	var/brightness_on = 999		//can't remember what the maxed out value is

/obj/machinery/floodlight/New()
	. = ..()
	cell = new /obj/item/cell/high(src)

/obj/machinery/floodlight/proc/updateicon()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if(on)
		if(cell.charge >= use)
			cell.use(use)
		else
			on = 0
			updateicon()
			//SetLuminosity(0)
			set_light(0)
			src.visible_message(SPAN_WARNING("[src] shuts down due to lack of power!"))
			return

/obj/machinery/floodlight/attack_hand(mob/user)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.forceMove(user.loc)
		else
			cell.forceMove(loc)

		cell.add_fingerprint(user)
		cell.updateicon()

		cell = null
		to_chat(user, SPAN_NOTICE("You remove the power cell."))
		updateicon()
		return

	if(on)
		on = 0
		to_chat(user, SPAN_INFO("You turn off the light."))
		set_light(0)
	else
		if(!cell)
			return
		if(cell.charge <= 0)
			return
		on = 1
		to_chat(user, SPAN_INFO("You turn on the light."))
		set_light(brightness_on)

	updateicon()

/obj/machinery/floodlight/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		if(!open)
			unlocked = !unlocked
			if(unlocked)
				to_chat(user, SPAN_NOTICE("You unscrew the battery panel."))
			else
				to_chat(user, SPAN_NOTICE("You screw the battery panel into place."))
		return TRUE

	if(iscrowbar(tool))
		if(unlocked)
			open = !open
			if(open)
				to_chat(user, SPAN_NOTICE("You remove the battery panel."))
			else
				to_chat(user, SPAN_NOTICE("You crowbar the battery panel into place."))
				overlays.Cut()
		return TRUE

	return ..()

/obj/machinery/floodlight/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(open)
			if(isnotnull(cell))
				to_chat(user, SPAN_WARNING("There is a [cell] already installed."))
				updateicon()
				return TRUE
			user.drop_item()
			I.forceMove(src)
			cell = I
			to_chat(user, SPAN_NOTICE("You insert the power cell."))
			updateicon()
			return TRUE
	return ..()