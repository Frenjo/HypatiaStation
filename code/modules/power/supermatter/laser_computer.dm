// Originally from code/WorkInProgress/Cael_Aislinn/Supermatter/LaserComputer.dm.
// Moved on 13/06/2023. -Frenjo

//The laser control computer
//Used to control the lasers
/obj/machinery/computer/lasercon
	name = "laser control computer"
	icon_state = "atmos"

	var/list/lasers = list()
	var/id
	//var/advanced = 0

/obj/machinery/computer/lasercon/initialise()
	. = ..()
	for_no_type_check(var/obj/machinery/zero_point_emitter/laser, GET_MACHINES_TYPED(/obj/machinery/zero_point_emitter))
		if(laser.id == id)
			lasers.Add(laser)

/obj/machinery/computer/lasercon/process()
	..()
	updateDialog()

/*
// Edited/ported this code to work with the attack_hand verb. -Frenjo
/obj/machinery/computer/lasercon/interact(mob/user)
	if(!in_range(src, user) || (stat & (BROKEN|NOPOWER)))
		if(!issilicon(user))
			user.machine = null
			user << browse(null, "window=laser_control")
			return
	//var/t = "<TT><B>Laser status monitor</B><HR>"
	var/t = "<TT><B>Laser Status Monitor</B><HR>"
	for(var/obj/machinery/zero_point_emitter/laser in lasers)
		t += "Zero Point Laser<br>"
		t += "Power level: <A href='byond://?src=\ref[laser];input=-0.005'>-</A> <A href='byond://?src=\ref[laser];input=-0.001'>-</A> <A href='byond://?src=\ref[laser];input=-0.0005'>-</A> <A href='byond://?src=\ref[laser];input=-0.0001'>-</A> [laser.energy]MeV <A href='byond://?src=\ref[laser];input=0.0001'>+</A> <A href='byond://?src=\ref[laser];input=0.0005'>+</A> <A href='byond://?src=\ref[laser];input=0.001'>+</A> <A href='byond://?src=\ref[laser];input=0.005'>+</A><BR>"
		t += "Frequency: <A href='byond://?src=\ref[laser];freq=-10000'>-</A> <A href='byond://?src=\ref[laser];freq=-1000'>-</A> [laser.freq] <A href='byond://?src=\ref[laser];freq=1000'>+</A> <A href='byond://?src=\ref[laser];freq=10000'>+</A><BR>"
		t += "Output: [laser.active ? "<B>Online</B> <A href='byond://?src=\ref[laser];online=1'>Offline</A>" : "<A href='byond://?src=\ref[laser];online=1'>Online</A> <B>Offline</B> "]<BR>"
	t += "<hr>"
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"
	user << browse(t, "window=laser_control;size=500x800")
	user.machine = src
*/

// Ported and reformatted/edited above code to actually work, what is interact() anyway? -Frenjo
/obj/machinery/computer/lasercon/attack_hand(mob/user)
	if(!in_range(src, user) || (stat & (BROKEN|NOPOWER)))
		if(!issilicon(user))
			user.unset_machine()
			//user << browse(null, "window=laser_control")
			return

	/*
	var/t = "<TT><B>Laser Status Monitor</B><HR>" // Uppercased this. -Frenjo
	for(var/obj/machinery/zero_point_emitter/laser in lasers)
		t += "Zero Point Laser<br>"
		t += "Power level: <A href='byond://?src=\ref[laser];input=-0.005'>-</A> <A href='byond://?src=\ref[laser];input=-0.001'>-</A> <A href='byond://?src=\ref[laser];input=-0.0005'>-</A> <A href='byond://?src=\ref[laser];input=-0.0001'>-</A> [laser.energy]MeV <A href='byond://?src=\ref[laser];input=0.0001'>+</A> <A href='byond://?src=\ref[laser];input=0.0005'>+</A> <A href='byond://?src=\ref[laser];input=0.001'>+</A> <A href='byond://?src=\ref[laser];input=0.005'>+</A><BR>"
		t += "Frequency: <A href='byond://?src=\ref[laser];freq=-10000'>-</A> <A href='byond://?src=\ref[laser];freq=-1000'>-</A> [laser.freq] <A href='byond://?src=\ref[laser];freq=1000'>+</A> <A href='byond://?src=\ref[laser];freq=10000'>+</A><BR>"
		t += "Output: [laser.active ? "<B>Online</B> <A href='byond://?src=\ref[laser];online=1'>Offline</A>" : "<A href='byond://?src=\ref[laser];online=1'>Online</A> <B>Offline</B> "]<BR>"
	t += "<hr>"
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"
	user << browse(t, "window=laser_control")
	user.machine = src
	*/

	// Edited this a second time to reflect NanoUI port. -Frenjo
	usr.set_machine(src)
	ui_interact(user)

// Nobody added compatibility for AIs yet either... -Frenjo
/obj/machinery/computer/lasercon/attack_ai()
	attack_hand()

/*
/obj/machinery/computer/lasercon/proc/interact(mob/user)
	if(!in_range(src, user) || (stat & (BROKEN|NOPOWER)))
		if (!issilicon(user))
			user.machine = null
			user << browse(null, "window=powcomp")
			return


	user.machine = src
	var/t = "<TT><B>Laser status monitor</B><HR>"

	var/obj/machinery/engine/laser/laser = src.laser[1]

	if(!laser)
		t += "\red No laser found"
	else
		t += "Power level:  <A href='byond://?src=\ref[src];input=-4'>-</A> <A href='byond://?src=\ref[src];input=-3'>-</A> <A href='byond://?src=\ref[src];input=-2'>-</A> <A href='byond://?src=\ref[src];input=-1'>-</A> [add_lspace(laser.power,5)] <A href='byond://?src=\ref[src];input=1'>+</A> <A href='byond://?src=\ref[src];input=2'>+</A> <A href='byond://?src=\ref[src];input=3'>+</A> <A href='byond://?src=\ref[src];input=4'>+</A><BR>"
		if(advanced)
			t += "Frequency:  <A href='byond://?src=\ref[src];freq=-10000'>-</A> <A href='byond://?src=\ref[src];freq=-1000'>-</A> [add_lspace(laser.freq,5)] <A href='byond://?src=\ref[src];freq=1000'>+</A> <A href='byond://?src=\ref[src];freq=10000'>+</A><BR>"

		t += "Output: [laser.on ? "<B>Online</B> <A href='byond://?src=\ref[src];online=1'>Offline</A>" : "<A href='byond://?src=\ref[src];online=1'>Online</A> <B>Offline</B> "]<BR>"

		t += "<BR><HR><A href='byond://?src=\ref[src];close=1'>Close</A></TT>"

	user << browse(t, "window=lascomp;size=420x700")
	onclose(user, "lascomp")
*/

/obj/machinery/computer/lasercon/Topic(href, href_list)
	..()
	// Commented this out to reflect NanoUI port. -Frenjo
	/*if( href_list["close"] )
		usr << browse(null, "window=laser_control")
		usr.machine = null
		return

	if( href_list["input"] )
		var/i = text2num(href_list["input"])
		var/d = i
		for(var/obj/machinery/zero_point_emitter/laser in lasers)
			var/new_power = laser.energy + d
			new_power = max(new_power,0.0001)	//lowest possible value
			new_power = min(new_power,0.01)		//highest possible value
			laser.energy = new_power
			//
			src.updateDialog()
	else if( href_list["online"] )
		var/obj/machinery/zero_point_emitter/laser = href_list["online"]
		//laser.active = !laser.active
		// Do a check to see if the laser's wrenched + welded down. -Frenjo
		if(laser.state == 2)
			laser.active = !laser.active
		else
			usr << "\red NOTICE: Laser unsecured!"

		src.updateDialog()
	else if( href_list["freq"] )
		var/amt = text2num(href_list["freq"])
		for(var/obj/machinery/zero_point_emitter/laser in lasers)
			var/new_freq = laser.frequency + amt
			new_freq = max(new_freq,1)		//lowest possible value
			new_freq = min(new_freq,20000)	//highest possible value
			laser.frequency = new_freq
			//
			src.updateDialog()*/

	// Edited this to reflect NanoUI port. -Frenjo
	switch(href_list["power"])
		if("offline")
			for(var/obj/machinery/zero_point_emitter/laser in lasers)
				laser.active = FALSE
		if("online")
			for(var/obj/machinery/zero_point_emitter/laser in lasers)
				if(laser.state == 2)
					laser.active = TRUE

	if(href_list["input"])
		var/i = text2num(href_list["input"])
		for(var/obj/machinery/zero_point_emitter/laser in lasers)
			var/new_power = laser.energy + i
			new_power = max(new_power, 0.0001)
			new_power = min(new_power, 0.01)
			laser.energy = new_power

	if(href_list["freq"])
		var/amt = text2num(href_list["freq"])
		for(var/obj/machinery/zero_point_emitter/laser in lasers)
			var/new_freq = laser.frequency + amt
			new_freq = max(new_freq, 1)
			new_freq = min(new_freq, 20000)
			laser.frequency = new_freq

	updateUsrDialog()

/*
/obj/machinery/computer/lasercon/process()
	if(!(stat & (NOPOWER|BROKEN)))
		use_power(250)

	//src.updateDialog()
*/

/*
/obj/machinery/computer/lasercon/power_change()
	if(stat & BROKEN)
		icon_state = "broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "c_unpowered"
				stat |= NOPOWER
*/

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/computer/lasercon/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/obj/machinery/zero_point_emitter/laser = lasers[1]
	var/alist/data = alist(
		"laser_status" = laser.active,
		"laser_energy" = round(laser.energy, 0.0001),
		"laser_frequency" = laser.frequency,
		"laser_number" = lasers.len
	)

	// Ported most of this by studying SMES code. -Frenjo
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "laser_ctrl.tmpl", "Zero-Point Laser Status Monitor", 480, 360)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()