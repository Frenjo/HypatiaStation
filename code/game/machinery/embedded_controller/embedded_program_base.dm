// Adds docking controllers to go alongside airlock controllers, I couldn't be bothered to write these...
// But couldn't port it from a newer distro either... It was good I then remembered/found an older one...
// Ported this from an old Heaven's Gate - Eternal github I found, 22/11/2019. -Frenjo

/datum/computer/file/embedded_program
	var/list/memory = list()
	var/obj/machinery/embedded_controller/master

	var/id_tag

/datum/computer/file/embedded_program/New(var/obj/machinery/embedded_controller/M)
	master = M
	if (istype(M, /obj/machinery/embedded_controller/radio))
		var/obj/machinery/embedded_controller/radio/R = M
		id_tag = R.id_tag

/datum/computer/file/embedded_program/proc/receive_user_command(command)
	return

/datum/computer/file/embedded_program/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return

/datum/computer/file/embedded_program/proc/process()
	return

/datum/computer/file/embedded_program/proc/post_signal(datum/signal/signal, comm_line)
	if(master)
		master.post_signal(signal, comm_line)
	else
		del(signal)
