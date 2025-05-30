// Module used for fast interprocess communication between BYOND and other processes
/var/global/datum/socket_talk/socket_talk

/datum/socket_talk
	var/enabled = FALSE

/datum/socket_talk/New()
	..()
	src.enabled = CONFIG_GET(/decl/configuration_entry/socket_talk)

	if(enabled)
		LIBCALL("DLLSocket.so", "establish_connection")("127.0.0.1", "8019")

/datum/socket_talk/proc/send_raw(message)
	if(enabled)
		return LIBCALL("DLLSocket.so", "send_message")(message)

/datum/socket_talk/proc/receive_raw()
	if(enabled)
		return LIBCALL("DLLSocket.so", "recv_message")()

/datum/socket_talk/proc/send_log(log, message)
	return send_raw("type=log&log=[log]&message=[message]")

/datum/socket_talk/proc/send_keepalive()
	return send_raw("type=keepalive")