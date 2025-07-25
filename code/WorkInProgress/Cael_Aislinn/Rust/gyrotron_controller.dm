
/obj/machinery/computer/rust_gyrotron_controller
	name = "gyrotron remote controller"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "engine"
	var/updating = 1

/obj/machinery/computer/rust_gyrotron_controller/Topic(href, href_list)
	..()
	if(href_list["close"])
		usr << browse(null, "window=gyrotron_controller")
		usr.machine = null
		return
	if(href_list["target"])
		var/obj/machinery/rust/gyrotron/gyro = locate(href_list["target"])
		gyro.Topic(href, href_list)
		return

/obj/machinery/computer/rust_gyrotron_controller/process()
	..()
	if(updating)
		src.updateDialog()

/obj/machinery/computer/rust_gyrotron_controller/interact(mob/user)
	if(!in_range(src, user) || (stat & (BROKEN|NOPOWER)))
		if(!issilicon(user))
			user.machine = null
			user << browse(null, "window=gyrotron_controller")
			return
	var/t = "<B>Gyrotron Remote Control Console</B><BR>"
	t += "<hr>"
	FOR_MACHINES_TYPED(gyro, /obj/machinery/rust/gyrotron)
		if(gyro.remoteenabled && gyro.on)
			t += "<font color=green>Gyrotron operational</font><br>"
			t += "Operational mode: <font color=blue>"
			if(gyro.emitting)
				t += "Emitting</font> <a href='byond://?src=\ref[gyro];deactivate=1'>\[Deactivate\]</a><br>"
			else
				t += "Not emitting</font> <a href='byond://?src=\ref[gyro];activate=1'>\[Activate\]</a><br>"
			t += "Emission rate: [gyro.rate] <a href='byond://?src=\ref[gyro];modifyrate=1'>\[Modify\]</a><br>"
			t += "Beam frequency: [gyro.frequency] <a href='byond://?src=\ref[gyro];modifyfreq=1'>\[Modify\]</a><br>"
			t += "Beam power: [gyro.mega_energy] <a href='byond://?src=\ref[gyro];modifypower=1'>\[Modify\]</a><br>"
		else
			t += "<b><font color=red>Gyrotron unresponsive</font></b>"
		t += "<hr>"
	/*
	var/t = "<B>Reactor Core Fuel Control</B><BR>"
	t += "Current fuel injection stage: [active_stage]<br>"
	if(active_stage == "Cooling")
		//t += "<a href='byond://?src=\ref[src];restart=1;'>Restart injection cycle</a><br>"
		t += "----<br>"
	else
		t += "<a href='byond://?src=\ref[src];cooldown=1;'>Enter cooldown phase</a><br>"
	t += "Fuel depletion announcement: "
	t += "[announce_fueldepletion ? 		"<a href='byond://?src=\ref[src];disable_fueldepletion=1'>Disable</a>" : "<b>Disabled</b>"] "
	t += "[announce_fueldepletion == 1 ? 	"<b>Announcing</b>" : "<a href='byond://?src=\ref[src];announce_fueldepletion=1'>Announce</a>"] "
	t += "[announce_fueldepletion == 2 ? 	"<b>Broadcasting</b>" : "<a href='byond://?src=\ref[src];broadcast_fueldepletion=1'>Broadcast</a>"]<br>"
	t += "Stage progression announcement: "
	t += "[announce_stageprogression ? 		"<a href='byond://?src=\ref[src];disable_stageprogression=1'>Disable</a>" : "<b>Disabled</b>"] "
	t += "[announce_stageprogression == 1 ? 	"<b>Announcing</b>" : "<a href='byond://?src=\ref[src];announce_stageprogression=1'>Announce</a>"] "
	t += "[announce_stageprogression == 2 ? 	"<b>Broadcasting</b>" : "<a href='byond://?src=\ref[src];broadcast_stageprogression=1'>Broadcast</a>"] "
	t += "<hr>"
	t += "<table border=1><tr>"
	t += "<td><b>Injector Status</b></td>"
	t += "<td><b>Injection interval (sec)</b></td>"
	t += "<td><b>Assembly consumption per injection</b></td>"
	t += "<td><b>Fuel Assembly Port</b></td>"
	t += "<td><b>Assembly depletion percentage</b></td>"
	t += "</tr>"
	for(var/stage in fuel_injectors)
		var/list/cur_stage = fuel_injectors[stage]
		t += "<tr><td colspan=5><b>Fuel Injection Stage:</b> <font color=blue>[stage]</font> [active_stage == stage ? "<font color=green> (Currently active)</font>" : "<a href='byond://?src=\ref[src];beginstage=[stage]'>Activate</a>"]</td></tr>"
		for(var/obj/machinery/rust/fuel_injector/Injector in cur_stage)
			t += "<tr>"
			t += "<td>[Injector.on && Injector.remote_enabled ? "<font color=green>Operational</font>" : "<font color=red>Unresponsive</font>"]</td>"
			t += "<td>[Injector.rate/10] <a href='byond://?src=\ref[Injector];cyclerate=1'>Modify</a></td>"
			t += "<td>[Injector.fuel_usage*100]% <a href='byond://?src=\ref[Injector];fuel_usage=1'>Modify</a></td>"
			t += "<td>[Injector.owned_assembly_port ? "[Injector.owned_assembly_port.cur_assembly ? "<font color=green>Loaded</font>": "<font color=blue>Empty</font>"]" : "<font color=red>Disconnected</font>" ]</td>"
			t += "<td>[Injector.owned_assembly_port && Injector.owned_assembly_port.cur_assembly ? "[Injector.owned_assembly_port.cur_assembly.amount_depleted*100]%" : ""]</td>"
			t += "</tr>"
	t += "</table>"
	*/
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"
	user << browse(t, "window=gyrotron_controller;size=500x400")
	user.machine = src