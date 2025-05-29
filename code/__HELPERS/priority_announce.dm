/proc/priority_announce(text, title = "", sound = 'sound/AI/attention.ogg', type, auth_id)
	// The actual text of the announcement.
	var/announcement
	// Stores the author, message and channel name for the newscaster system.
	var/author = null
	var/message = null
	var/channel_name = null

	switch(type)
		if(ANNOUNCEMENT_TYPE_PRIORITY)
			announcement += "<h1 class='alert'>Priority Announcement</h1>"
		if(ANNOUNCEMENT_TYPE_CAPTAIN)
			announcement += "<h1 class='alert'>Captain's Announcement</h1>"
			author = auth_id
			message = text
			channel_name = /datum/feed_channel/station_announcements::channel_name
		else
			announcement += "<h1 class='alert'>[command_name()] Update</h1>"
			author = "Central Command"
			channel_name = /datum/feed_channel/command_updates::channel_name
			if(title && length(title) > 0)
				announcement += "<h2 class='alert'>[html_encode(title)]</h2>"
				message = title + "<br>" + text
			else
				message = text

	announcement += "[SPAN_ALERT("[html_encode(text)]")]<br>"

	// Actually does the announcement.
	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(!M.ear_deaf)
			to_chat(M, announcement)
			M << sound(sound)

	// Sends the announcement to the corresponding news channel.
	if(isnotnull(author) && isnotnull(message) && isnotnull(channel_name))
		global.CTeconomy.news_network.submit_message(author, message, channel_name)

/proc/minor_announce(message, title = "Attention:", silent = FALSE)
	if(isnull(message))
		return

	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(!M.ear_deaf)
			to_chat(M, "<b><font size=3><font color=red>[title]</font color><br>[message]</font size></b>")
			if(!silent)
				M << sound('sound/misc/minor_announce.ogg')

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