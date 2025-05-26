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

/proc/minor_announce(department, message)
	if(isnull(department) || isnull(message))
		return

	for_no_type_check(var/mob/M, GLOBL.player_list)
		to_chat(M, "<b><font size=3><font color=red>[department] Announcement:</font color><br>[message]</font size></b>")

/proc/print_command_report(text = "", title = "CentCom Status Summary", silent = FALSE)
	for_no_type_check(var/obj/machinery/computer/communications/console, GLOBL.communications_consoles)
		if(!(console.stat & (BROKEN | NOPOWER)) && console.prints_intercept)
			var/obj/item/paper/intercept = new /obj/item/paper(console.loc)
			intercept.name = "paper - '[title]'"
			intercept.info = text
			console.messagetitle.Add(title)
			console.messagetext.Add(text)
	if(!silent)
		priority_announce("Summary downloaded and printed out at all communications consoles.", "Incoming Classified Message", 'sound/AI/commandreport.ogg')