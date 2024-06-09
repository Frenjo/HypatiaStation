/obj/item/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	matter_amounts = list(MATERIAL_METAL = 500, MATERIAL_GLASS = 50, "waste" = 10)
	origin_tech = list(/datum/tech/magnets = 1)

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
		GLOBL.processing_objects.Add(src)
	else
		timing = 0
		GLOBL.processing_objects.Remove(src)
	update_icon()
	return secured

/obj/item/assembly/timer/proc/timer_end()
	if(!secured)
		return 0
	pulse(0)
	if(!holder)
		visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
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
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "timer_timing"
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()
	return

/obj/item/assembly/timer/interact(mob/user) //TODO: Have this use the wires
	if(!secured)
		user.show_message(SPAN_WARNING("The [name] is unsecured!"))
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