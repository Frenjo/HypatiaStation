/proc/priority_announce(text, title = "", sound = 'sound/AI/attention.ogg', type, auth_id)
	var/announcement

	if(type == "Priority")
		announcement += "<h1 class='alert'>Priority Announcement</h1>"
	else if(type == "Captain")
		announcement += "<h1 class='alert'>Captain Announces</h1>"
	else
		announcement += "<h1 class='alert'>[command_name()] Update</h1>"
		if(title && length(title) > 0)
			announcement += "<h2 class='alert'>[html_encode(title)]</h2>"

	announcement += "[SPAN_ALERT("[html_encode(text)]")]<br>"

	for_no_type_check(var/mob/M, GLOBL.player_list)
		to_chat(M, announcement)
		M << sound(sound)