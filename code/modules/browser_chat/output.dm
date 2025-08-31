/atom
	var/last_chat_message
	var/last_chat_message_count = 0

/proc/to_chat(atom/target, message)
	if(!message)
		return
	if(isclient(target))
		var/client/C = target
		target = C.mob
	if(istype(target))
		var/func = "append"
		if(isnull(target.last_chat_message) || message != target.last_chat_message)
			target.last_chat_message_count = 0
		else
			func = "replace"
		target.last_chat_message_count++
		TO_OUTPUT(target, list2params(list(message, target.last_chat_message_count)), "outputwindow.output:[func]")
		target.last_chat_message = message

/proc/to_world(message)
	for_no_type_check(var/client/C, GLOBL.clients)
		to_chat(C, message)