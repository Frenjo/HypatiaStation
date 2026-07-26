
//high frequency photon (laser beam)
/obj/projectile/energy/beam/ehf_beam

/obj/machinery/rust/gyrotron
	name = "gyrotron"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "emitter-off"
	anchored = TRUE
	density = FALSE
	layer = 4

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 300
	)

	req_access = list(ACCESS_ENGINE)

	var/frequency = 1
	var/emitting = 0
	var/rate = 10
	var/mega_energy = 0.001
	var/on = 1
	var/remoteenabled = 1

/obj/machinery/rust/gyrotron/initialise()
	. = ..()
	//pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
	//pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

/obj/machinery/rust/gyrotron/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	var/update_computers = FALSE
	if(topic.has("modifypower"))
		var/new_val = text2num(input(user, "Enter new emission power level (0.001 - 0.01)", "Modifying power level (MeV)", mega_energy))
		if(!new_val)
			to_chat(user, SPAN_WARNING("That's not a valid number."))
			return TRUE
		new_val = min(new_val, 0.01)
		new_val = max(new_val, 0.001)
		mega_energy = new_val
		update_computers = TRUE

	else if(topic.has("modifyrate"))
		var/new_val = text2num(input(user, "Enter new emission rate (1 - 10)", "Modifying emission rate (sec)", rate))
		if(!new_val)
			to_chat(user, SPAN_WARNING("That's not a valid number."))
			return TRUE
		new_val = min(new_val, 1)
		new_val = max(new_val, 10)
		rate = new_val
		update_computers = TRUE

	else if(topic.has("modifyfreq"))
		var/new_val = text2num(input(user, "Enter new emission frequency (1 - 50000)", "Modifying emission frequency (GHz)", frequency))
		if(!new_val)
			to_chat(user, SPAN_WARNING("That's not a valid number."))
			return TRUE
		new_val = min(new_val, 1)
		new_val = max(new_val, 50000)
		frequency = new_val
		update_computers = TRUE

	else if(topic.has("activate"))
		emitting = TRUE
		spawn(rate)
			Emit() // This is really icky and needs updating.
		update_computers = TRUE

	else if(topic.has("deactivate"))
		emitting = FALSE
		update_computers = TRUE

	else if(topic.has("enableremote"))
		remoteenabled = TRUE
		update_computers = TRUE

	else if(topic.has("disableremote"))
		remoteenabled = FALSE
		update_computers = TRUE

	if(update_computers)
		for(var/obj/machinery/computer/rust_gyrotron_controller/comp in range(25))
			comp.updateDialog()

/obj/machinery/rust/gyrotron/proc/Emit()
	var/obj/projectile/energy/beam/emitter/A = new /obj/projectile/energy/beam/emitter( src.loc )
	A.frequency = frequency
	A.damage = mega_energy * 500
	//
	A.icon_state = "emitter"
	playsound(src.loc, 'sound/weapons/gun/emitter.ogg', 25, 1)
	use_power(100 * mega_energy + 500)
	/*
	if(prob(35))
		make_sparks(5, TRUE, src)
	*/
	A.set_dir(src.dir)
	if(src.dir == 1)//Up
		A.yo = 20
		A.xo = 0
	else if(src.dir == 2)//Down
		A.yo = -20
		A.xo = 0
	else if(src.dir == 4)//Right
		A.yo = 0
		A.xo = 20
	else if(src.dir == 8)//Left
		A.yo = 0
		A.xo = -20
	else // Any other
		A.yo = -20
		A.xo = 0
	A.process()
	//
	flick("emitter-active", src)
	if(emitting)
		spawn(rate)
			Emit()

/obj/machinery/rust/gyrotron/proc/UpdateIcon()
	if(on)
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"


/obj/machinery/rust/gyrotron/control_panel
	name = "control panel"
	icon_state = "control_panel"

	var/obj/machinery/rust/gyrotron/owned_gyrotron

/obj/machinery/rust/gyrotron/control_panel/initialise()
	. = ..()
	pixel_x = -pixel_x
	pixel_y = -pixel_y

/obj/machinery/rust/gyrotron/control_panel/interact(mob/user)
	var/t = "<B>Free electron MASER (Gyrotron) Control Panel</B><BR>"
	if(owned_gyrotron && owned_gyrotron.on)
		t += "<font color=green>Gyrotron operational</font><br>"
		t += "Operational mode: <font color=blue>"
		if(owned_gyrotron.emitting)
			t += "Emitting</font> <a href='byond://?src=\ref[owned_gyrotron];deactivate=1'>\[Deactivate\]</a><br>"
		else
			t += "Not emitting</font> <a href='byond://?src=\ref[owned_gyrotron];activate=1'>\[Activate\]</a><br>"
		t += "Emission rate: [owned_gyrotron.rate] <a href='byond://?src=\ref[owned_gyrotron];modifyrate=1'>\[Modify\]</a><br>"
		t += "Beam frequency: [owned_gyrotron.frequency] <a href='byond://?src=\ref[owned_gyrotron];modifyfreq=1'>\[Modify\]</a><br>"
		t += "Beam power: [owned_gyrotron.mega_energy] <a href='byond://?src=\ref[owned_gyrotron];modifypower=1'>\[Modify\]</a><br>"
	else
		t += "<b><font color=red>Gyrotron unresponsive</font></b>"
	t += "<hr>"
	t += "<A href='byond://?src=\ref[src];close=1'>Close</A><BR>"
	SHOW_BROWSER(user, t, "window=\ref[src];size=500x800")
	user.machine = src