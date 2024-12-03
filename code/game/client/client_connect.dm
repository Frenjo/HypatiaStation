/*
 * Connect
 */
#define MIN_CLIENT_VERSION	0		// Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									// I would just like the code ready should it ever need to be used.

/client/New(TopicData)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker")					//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

	if(IsGuestKey(key))
		alert(src, "This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.", "Guest", "OK")
		del(src)
		return

	// Change the way they should download resources.
	if(isnotnull(CONFIG_GET(/decl/configuration_entry/resource_urls)))
		preload_rsc = pick(CONFIG_GET(/decl/configuration_entry/resource_urls))
	else
		preload_rsc = 1 // If CONFIG_GET(/decl/configuration_entry/resource_urls) is not set, preload like normal.

	to_chat(src, SPAN_WARNING("If the title screen is black, resources are still downloading. Please be patient until the title screen appears."))

	GLOBL.clients.Add(src)
	GLOBL.directory[ckey] = src

	//Admin Authorisation
	holder = GLOBL.admin_datums[ckey]
	if(isnotnull(holder))
		GLOBL.admins.Add(src)
		holder.owner = src

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = GLOBL.preferences_datums[ckey]
	if(isnull(prefs))
		prefs = new /datum/preferences(src)
		GLOBL.preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls mob.Login()

	if(isnotnull(GLOBL.custom_event_msg) && GLOBL.custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, SPAN_ALERT("[html_encode(GLOBL.custom_event_msg)]"))
		to_chat(src, "<br>")

	if((world.address == address || !address) && !GLOBL.host)
		GLOBL.host = key
		world.update_status()

	if(isnotnull(holder))
		add_admin_verbs()
		admin_memo_show()

	log_client_to_db()

	send_resources()

	if(prefs.lastchangelog != GLOBL.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		winset(src, "rpane.changelog", "background-color=#eaeaea;font-style=bold")

#undef MIN_CLIENT_VERSION