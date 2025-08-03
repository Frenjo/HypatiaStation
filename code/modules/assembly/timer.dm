/obj/item/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	matter_amounts = /datum/design/autolathe/timer::materials
	origin_tech = /datum/design/autolathe/timer::req_tech

	wires = WIRE_PULSE

	secured = 0

	var/timing = 0
	var/time = 10

/obj/item/assembly/timer/activate()
	if(!..())
		return 0 //Cooldown check

	timing = !timing

	update_icon()
	return 0

/obj/item/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(PCobj, src)
	else
		timing = 0
		STOP_PROCESSING(PCobj, src)
	update_icon()
	return secured

/obj/item/assembly/timer/proc/timer_end()
	if(!secured)
		return 0
	pulse(0)
	if(!holder)
		visible_message("[html_icon(src)] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()
	return

/obj/item/assembly/timer/process()
	if(timing && time > 0)
		time--
	if(timing && time <= 0)
		timing = 0
		timer_end()
		time = 10
	return

/obj/item/assembly/timer/update_icon()
	cut_overlays()
	attached_overlays = list()
	if(timing)
		add_overlay("timer_timing")
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()
	return

/obj/item/assembly/timer/interact(mob/user) //TODO: Have this use the wires
	if(!secured)
		to_chat(user, SPAN_WARNING("The [name] is unsecured!"))
		return 0
	var/second = time % 60
	var/minute = (time - second) / 60
	var/dat = text("<TT><B>Timing Unit</B>\n[] []:[]\n<A href='byond://?src=\ref[];tp=-30'>-</A> <A href='byond://?src=\ref[];tp=-1'>-</A> <A href='byond://?src=\ref[];tp=1'>+</A> <A href='byond://?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='byond://?src=\ref[];time=0'>Timing</A>", src) : text("<A href='byond://?src=\ref[];time=1'>Not Timing</A>", src)), minute, second, src, src, src, src)
	dat += "<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><BR><A href='byond://?src=\ref[src];close=1'>Close</A>"
	user << browse(dat, "window=timer")
	onclose(user, "timer")
	return

/obj/item/assembly/timer/Topic(href, href_list)
	..()
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=timer")
		onclose(usr, "timer")
		return

	if(href_list["time"])
		timing = text2num(href_list["time"])
		update_icon()

	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = min(max(round(time), 0), 600)

	if(href_list["close"])
		usr << browse(null, "window=timer")
		return

	if(usr)
		attack_self(usr)

	return