/*
 * Party Alarm
 */
/obj/machinery/party_alarm
	name = "\improper PARTY BUTTON"
	desc = "Cuban Pete is in the house!"
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "fire0"
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 6
	)

	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0

/obj/machinery/party_alarm/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/party_alarm/attack_hand(mob/user)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	usr.set_machine(src)
	var/area/A = GET_AREA(src)
	ASSERT(isarea(A))
	//if(A.master)
		//A = A.master
	var/d1
	var/d2
	if(ishuman(user) || issilicon(user))
		if(A.party_alarm)
			d1 = "<A href='byond://?src=\ref[src];reset=1'>No Party :(</A>"
		else
			d1 = "<A href='byond://?src=\ref[src];alarm=1'>PARTY!!!</A>"
		if(timing)
			d2 = "<A href='byond://?src=\ref[src];time=0'>Stop Time Lock</A>"
		else
			d2 = "<A href='byond://?src=\ref[src];time=1'>Initiate Time Lock</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>Party Button</B> [d1]\n<HR>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='byond://?src=\ref[src];tp=-30'>-</A> <A href='byond://?src=\ref[src];tp=-1'>-</A> <A href='byond://?src=\ref[src];tp=1'>+</A> <A href='byond://?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	else
		if(A.fire_alarm)
			d1 = "<A href='byond://?src=\ref[src];reset=1'>[stars("No Party :(")]</A>"
		else
			d1 = "<A href='byond://?src=\ref[src];alarm=1'>[stars("PARTY!!!")]</A>"
		if(timing)
			d2 = "<A href='byond://?src=\ref[src];time=0'>[stars("Stop Time Lock")]</A>"
		else
			d2 = "<A href='byond://?src=\ref[src];time=1'>[stars("Initiate Time Lock")]</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>[stars("Party Button")]</B> [d1]\n<HR>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='byond://?src=\ref[src];tp=-30'>-</A> <A href='byond://?src=\ref[src];tp=-1'>-</A> <A href='byond://?src=\ref[src];tp=1'>+</A> <A href='byond://?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")

/obj/machinery/party_alarm/proc/reset()
	if(!working)
		return
	var/area/A = GET_AREA(src)
	ASSERT(isarea(A))
	//if(A.master)
		//A = A.master
	A.party_reset()

/obj/machinery/party_alarm/proc/alarm()
	if(!working)
		return
	var/area/A = GET_AREA(src)
	ASSERT(isarea(A))
	//if(A.master)
		//A = A.master
	A.party_alert()

/obj/machinery/party_alarm/Topic(href, href_list)
	..()
	if(usr.stat || stat & (BROKEN|NOPOWER))
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || issilicon(usr))
		usr.machine = src
		if(href_list["reset"])
			reset()
		else
			if(href_list["alarm"])
				alarm()
			else
				if(href_list["time"])
					timing = text2num(href_list["time"])
				else
					if(href_list["tp"])
						var/tp = text2num(href_list["tp"])
						time += tp
						time = min(max(round(time), 0), 120)
		updateUsrDialog()

		add_fingerprint(usr)
	else
		usr << browse(null, "window=partyalarm")
		return