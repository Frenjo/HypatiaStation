/*
 * Security
 */
#define TOPIC_SPAM_DELAY	2			// 2 ticks is about 2/10ths of a second; it was 4 ticks, but that caused too many clicks to be lost due to lag.
#define UPLOAD_LIMIT		10485760	// Restricts client uploads to the server to 10MB. // Boosted this thing. What's the worst that can happen?

/*
 *	When somebody clicks a link in game, this Topic is called first.
 *	It does the stuff in this proc and then is redirected to the Topic() proc for the src=[0xWhatever]
 *	(if specified in the link). ie locate(hsrc).Topic()

 *	Such links can be spoofed.

 *	Because of this certain things MUST be considered whenever adding a Topic() for something:
 *		- Can it be fed harmful values which could cause runtimes?
 *		- Is the Topic call an admin-only thing?
 *		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
 *		- Are the processes being called by Topic() particularly laggy?
 *		- If so, is there any protection against somebody spam-clicking a link?
 *	If you have any questions about this stuff feel free to ask. ~Carn
 */
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	//Reduces spamming of links by dropping calls that happen during the delay period
	if(next_allowed_topic_time > world.time)
		return
	next_allowed_topic_time = world.time + TOPIC_SPAM_DELAY

	//search the href for script injection
	if(findtext(href, "<script", 1, 0))
		world.log << "Attempted use of scripts within a topic call, by [src]."
		message_admins("Attempted use of scripts within a topic call, by [src].")
		//del(usr)
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C))		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C, null)
		return

	//Logs all hrefs
	if(CONFIG_GET(log_hrefs) && isnotnull(GLOBL.href_logfile))
		GLOBL.href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("prefs")
			return prefs.process_link(usr, href_list)
		if("vars")
			return view_var_Topic(href, href_list, hsrc)

	..()	//redirect to hsrc.Topic()

/client/proc/handle_spam_prevention(message, mute_type)
	if(CONFIG_GET(automute_on) && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, SPAN_WARNING("You have exceeded the spam filter limit for identical messages. An auto-mute was applied."))
			cmd_admin_mute(src.mob, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, SPAN_WARNING("You are nearing the spam filter limit for identical messages."))
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

// This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT / 1024]KiB.</font>")
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1

#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT