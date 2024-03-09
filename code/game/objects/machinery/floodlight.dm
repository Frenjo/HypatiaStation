//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE
	var/on = 0
	var/obj/item/cell/high/cell = null
	var/use = 5
	var/unlocked = 0
	var/open = 0
	var/brightness_on = 999		//can't remember what the maxed out value is

/obj/machinery/floodlight/New()
	src.cell = new(src)
	..()

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

/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = loc

		cell.add_fingerprint(user)
		cell.updateicon()

		src.cell = null
		to_chat(user, "You remove the power cell.")
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
				to_chat(user, SPAN_INFO("You remove the battery panel."))
			else
				to_chat(user, SPAN_INFO("You crowbar the battery panel into place."))
				overlays.Cut()
		return TRUE

	return ..()

/obj/machinery/floodlight/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "You insert the power cell.")
	updateicon()