/*
 * FIRE ALARM CIRCUIT
 * Just an object used in constructing fire alarms.
*/
/obj/item/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""
	w_class = 2.0
	matter_amounts = list(MATERIAL_METAL = 50, /decl/material/glass = 50)

/*
 * Fire Alarm
 */
/obj/machinery/fire_alarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "fire0"
	anchored = TRUE

	power_channel = ENVIRON
	power_usage = list(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 6
	)

	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0

	var/last_process = 0
	var/wiresexposed = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone

/obj/machinery/fire_alarm/New(loc, dir, building)
	name = "fire alarm"
	. = ..()
	if(isnotnull(loc))
		src.loc = loc

	if(isnotnull(dir))
		set_dir(dir)

	if(building)
		buildstage = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

/obj/machinery/fire_alarm/initialise()
	. = ..()
	if(iscontactlevel(z))
		if(isnotnull(GLOBL.security_level))
			overlays.Add(image('icons/obj/machines/monitors.dmi', "overlay_[GLOBL.security_level.name]"))
		else
			overlays.Add(image('icons/obj/machines/monitors.dmi', "overlay_green"))
	update_icon()

/obj/machinery/fire_alarm/update_icon()
	if(wiresexposed)
		switch(buildstage)
			if(2)
				icon_state = "fire_b2"
			if(1)
				icon_state = "fire_b1"
			if(0)
				icon_state = "fire_b0"

		return

	if(stat & BROKEN)
		icon_state = "firex"
	else if(stat & NOPOWER)
		icon_state = "firep"
	else if(!detecting)
		icon_state = "fire1"
	else
		icon_state = "fire0"

/obj/machinery/fire_alarm/fire_act(datum/gas_mixture/air, temperature, volume)
	if(detecting)
		if(temperature > T0C + 200)
			alarm()			// added check of detector status here

/obj/machinery/fire_alarm/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/fire_alarm/bullet_act(BLAH)
	return alarm()

/obj/machinery/fire_alarm/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/fire_alarm/emp_act(severity)
	if(prob(50 / severity))
		alarm()
	..()

/obj/machinery/fire_alarm/attackby(obj/item/W, mob/user)
	add_fingerprint(user)

	if(isscrewdriver(W) && buildstage == 2)
		wiresexposed = !wiresexposed
		update_icon()
		return

	if(wiresexposed)
		switch(buildstage)
			if(2)
				if(ismultitool(W))
					detecting = !detecting
					if(detecting)
						user.visible_message(
							SPAN_WARNING("[user] has reconnected [src]'s detecting unit!"),
							"You have reconnected [src]'s detecting unit."
						)
					else
						user.visible_message(
							SPAN_WARNING("[user] has disconnected [src]'s detecting unit!"),
							"You have disconnected [src]'s detecting unit."
						)
			if(1)
				if(iscable(W))
					var/obj/item/stack/cable_coil/coil = W
					if(coil.amount < 5)
						to_chat(user, "You need more cable for this!")
						return

					coil.use(5)

					buildstage = 2
					to_chat(user, "You wire \the [src]!")
					update_icon()

				else if(iscrowbar(W))
					to_chat(user, "You pry out the circuit!")
					playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
					spawn(20)
						var/obj/item/firealarm_electronics/circuit = new /obj/item/firealarm_electronics()
						circuit.loc = user.loc
						buildstage = 0
						update_icon()
			if(0)
				if(istype(W, /obj/item/firealarm_electronics))
					to_chat(user, "You insert the circuit!")
					qdel(W)
					buildstage = 1
					update_icon()

				else if(iswrench(W))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					var/obj/item/frame/firealarm/frame = new /obj/item/frame/firealarm()
					frame.loc = user.loc
					playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
					qdel(src)
		return

	alarm()

/obj/machinery/fire_alarm/process()//Note: this processing was mostly phased out due to other code, and only runs when needed
	if(stat & (NOPOWER|BROKEN))
		return

	if(timing)
		if(time > 0)
			time = time - ((world.timeofday - last_process)/10)
		else
			alarm()
			time = 0
			timing = 0
			GLOBL.processing_objects.Remove(src)
		updateDialog()
	last_process = world.timeofday

	if(locate(/obj/fire) in loc)
		alarm()

/obj/machinery/fire_alarm/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()

/obj/machinery/fire_alarm/attack_hand(mob/user)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	if(buildstage != 2)
		return

	user.set_machine(src)
	var/area/A = loc
	var/d1
	var/d2
	if(ishuman(user) || issilicon(user))
		A = A.loc
		if(A.fire_alarm)
			d1 = "<A href='byond://?src=\ref[src];reset=1'>Reset - Lockdown</A>"
		else
			d1 = "<A href='byond://?src=\ref[src];alarm=1'>Alarm - Lockdown</A>"
		if(timing)
			d2 = "<A href='byond://?src=\ref[src];time=0'>Stop Time Lock</A>"
		else
			d2 = "<A href='byond://?src=\ref[src];time=1'>Initiate Time Lock</A>"
		var/second = round(time) % 60
		var/minute = (round(time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>Fire alarm</B> [d1]\n<HR>The current alert level is: [GLOBL.security_level.name]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='byond://?src=\ref[src];tp=-30'>-</A> <A href='byond://?src=\ref[src];tp=-1'>-</A> <A href='byond://?src=\ref[src];tp=1'>+</A> <A href='byond://?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")
	else
		A = A.loc
		if(A.fire_alarm)
			d1 = "<A href='byond://?src=\ref[src];reset=1'>[stars("Reset - Lockdown")]</A>"
		else
			d1 = "<A href='byond://?src=\ref[src];alarm=1'>[stars("Alarm - Lockdown")]</A>"
		if(timing)
			d2 = "<A href='byond://?src=\ref[src];time=0'>[stars("Stop Time Lock")]</A>"
		else
			d2 = "<A href='byond://?src=\ref[src];time=1'>[stars("Initiate Time Lock")]</A>"
		var/second = round(time) % 60
		var/minute = (round(time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>[stars("Fire alarm")]</B> [d1]\n<HR><b>The current alert level is: [stars(GLOBL.security_level.name)]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='byond://?src=\ref[src];tp=-30'>-</A> <A href='byond://?src=\ref[src];tp=-1'>-</A> <A href='byond://?src=\ref[src];tp=1'>+</A> <A href='byond://?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")

/obj/machinery/fire_alarm/Topic(href, href_list)
	..()
	if(usr.stat || stat & (BROKEN|NOPOWER))
		return

	if(buildstage != 2)
		return

	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || issilicon(usr))
		usr.set_machine(src)
		if(href_list["reset"])
			reset()
		else if(href_list["alarm"])
			alarm()
		else if(href_list["time"])
			timing = text2num(href_list["time"])
			last_process = world.timeofday
			GLOBL.processing_objects.Add(src)
		else if(href_list["tp"])
			var/tp = text2num(href_list["tp"])
			time += tp
			time = min(max(round(time), 0), 120)

		updateUsrDialog()

		add_fingerprint(usr)
	else
		usr << browse(null, "window=firealarm")
		return

/obj/machinery/fire_alarm/proc/reset()
	if(!working)
		return
	var/area/A = loc
	A = A.loc
	if(!isarea(A))
		return
	A.fire_reset()
	update_icon()

/obj/machinery/fire_alarm/proc/alarm()
	if(!working)
		return
	var/area/A = loc
	A = A.loc
	if(!isarea(A))
		return
	A.fire_alert()
	update_icon()
	//playsound(src, 'sound/ambience/signal.ogg', 75, 0)