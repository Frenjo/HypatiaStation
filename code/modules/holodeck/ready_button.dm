// Contains: Ready Declaration Device
/obj/machinery/readybutton
	name = "ready declaration device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "auth_off"
	anchored = TRUE

	power_channel = ENVIRON
	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 6
	)

	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

/obj/machinery/readybutton/attack_ai(mob/user)
	to_chat(user, "The station AI is not to interact with these devices!")
	return

/obj/machinery/readybutton/attack_paw(mob/user)
	to_chat(user, "You are too primitive to use this device.")
	return

/obj/machinery/readybutton/attackby(obj/item/W, mob/user)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")

/obj/machinery/readybutton/attack_hand(mob/user)
	if(user.stat || stat & (NOPOWER | BROKEN))
		to_chat(user, "This device is not powered.")
		return

	currentarea = GET_AREA(src)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		to_chat(user, "The event has already begun!")
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if(button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()
	eventstarted = 1

	for(var/obj/structure/holowindow/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")