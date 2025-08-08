// Ported 'shuttles' module from Heaven's Gate - NSS Eternal...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

/datum/shuttle/ferry/escape_pod
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/arming_controller

/datum/shuttle/ferry/escape_pod/can_launch()
	if(arming_controller && !arming_controller.armed)	//must be armed
		return 0
	if(location)
		return 0	//it's a one-way trip.
	return ..()

/datum/shuttle/ferry/escape_pod/can_force()
	if(arming_controller.eject_time && world.time < arming_controller.eject_time + 50)
		return 0	//dont allow force launching until 5 seconds after the arming controller has reached it's countdown
	return ..()

/datum/shuttle/ferry/escape_pod/can_cancel()
	return 0

//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	var/datum/shuttle/ferry/escape_pod/pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/alist/data = alist(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = docking_program.memory["door_status"]["state"],
		"door_lock" = docking_program.memory["door_status"]["lock"],
		"can_force" = pod.can_force() || (global.PCemergency.departed && pod.can_launch()),	//allow players to manually launch ahead of time if the shuttle leaves
		"is_armed" = pod.arming_controller.armed,
	)

	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "escape_pod_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/Topic(href, href_list)
	if(..())	//I hate this "return 1 to indicate they are not allowed to use the controller" crap, but not sure how else to do it without being able to call machinery/Topic() directly.
		return 1

	if(href_list["manual_arm"])
		pod.arming_controller.arm()
	if(href_list["force_launch"])
		if(pod.can_force())
			pod.force_launch(src)
		else if(global.PCemergency.departed && pod.can_launch())	//allow players to manually launch ahead of time if the shuttle leaves
			pod.launch(src)

	return 0

//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/initialise()
	. = ..()
	docking_program = new /datum/computer/file/embedded_program/docking/simple/escape_pod(src)
	program = docking_program

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/armed = null
	if(istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
		armed = P.armed

	var/alist/data = alist(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed,
	)

	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "escape_pod_berth_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		return FALSE
	emagged = TRUE
	to_chat(user, SPAN_INFO("You emag \the [src], arming the escape pod!"))
	if(istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
		if(!P.armed)
			P.arm()
	return TRUE


//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	var/armed = 0
	var/eject_delay = 10	//give latecomers some time to get out of the way if they don't make it onto the pod
	var/eject_time = null
	var/closing = 0

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/arm()
	armed = 1
	open_door()

/datum/computer/file/embedded_program/docking/simple/escape_pod/receive_user_command(command)
	if(!armed)
		return
	..(command)

/datum/computer/file/embedded_program/docking/simple/escape_pod/process()
	..()
	if(eject_time && world.time >= eject_time && !closing)
		close_door()
		closing = 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_docking()
	return

/datum/computer/file/embedded_program/docking/simple/escape_pod/ready_for_docking()
	return 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/finish_docking()
	return		//don't do anything - the doors only open when the pod is armed.

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_undocking()
	eject_time = world.time + eject_delay * 10