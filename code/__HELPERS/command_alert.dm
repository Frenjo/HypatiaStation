/proc/command_alert(text, title = "")
	var/command
	command += "<h1 class='alert'>[command_name()] Update</h1>"
	if(title && length(title) > 0)
		command += "<br><h2 class='alert'>[html_encode(title)]</h2>"

	command += "<br>[SPAN_ALERT(html_encode(text))]<br>"
	command += "<br>"
	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(!isnewplayer(M))
			to_chat(M, command)