//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
	The broadcaster sends processed messages to all radio devices in the game. They
	do not have to be headsets; intercoms and station-bounced radios suffice.

	They receive their message from a server after the message has been logged.
*/

/var/list/recentmessages = list() // global list of recent messages broadcasted : used to circumvent massive radio spam
/var/message_delay = 0 // To make sure restarting the recentmessages list is kept in sync

/obj/machinery/telecoms/broadcaster
	name = "subspace broadcaster"
	icon_state = "broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals."
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 25
	)

	machinetype = 5
	//heatgen = 0
	operating_temperature = null
	delay = 7
	circuitboard = /obj/item/circuitboard/telecoms/broadcaster

/obj/machinery/telecoms/broadcaster/receive_information(datum/signal/signal, obj/machinery/telecoms/machine_from)
	// Don't broadcast rejected signals
	if(signal.data["reject"])
		return

	if(signal.data["message"])
		// Prevents massive radio spam
		signal.data["done"] = 1 // mark the signal as being broadcasted
		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1
			original.data["compression"] = signal.data["compression"]
			original.data["level"] = signal.data["level"]

		var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
		if(signal_message in recentmessages)
			return
		recentmessages.Add(signal_message)

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary

		signal.data["level"] |= listening_level

	   /** #### - Normal Broadcast - #### **/
		if(signal.data["type"] == 0)
			/* ###### Broadcast a message using signal.data ###### */
			Broadcast_Message(
				signal.data["connection"], signal.data["mob"],
				signal.data["vmask"], signal.data["vmessage"],
				signal.data["radio"], signal.data["message"],
				signal.data["name"], signal.data["job"],
				signal.data["realname"], signal.data["vname"],,
				signal.data["compression"], signal.data["level"], signal.frequency,
				signal.data["verbage"], signal.data["language"]
			)

	   /** #### - Simple Broadcast - #### **/
		if(signal.data["type"] == 1)
			/* ###### Broadcast a message using signal.data ###### */
			Broadcast_SimpleMessage(
				signal.data["name"], signal.frequency,
				signal.data["message"], null, null,
				signal.data["compression"], listening_level
			)

	   /** #### - Artificial Broadcast - #### **/
	   			// (Imitates a mob)
		if(signal.data["type"] == 2)
			/* ###### Broadcast a message using signal.data ###### */
				// Parameter "data" as 4: AI can't track this person/mob
			Broadcast_Message(
				signal.data["connection"], signal.data["mob"],
				signal.data["vmask"], signal.data["vmessage"],
				signal.data["radio"], signal.data["message"],
				signal.data["name"], signal.data["job"],
				signal.data["realname"], signal.data["vname"], 4, signal.data["compression"], signal.data["level"], signal.frequency,
				signal.data["verbage"], signal.data["language"]
			)

		if(!message_delay)
			message_delay = 1
			spawn(10)
				message_delay = 0
				recentmessages = list()

		/* --- Do a snazzy animation! --- */
		flick("broadcaster_send", src)

/obj/machinery/telecoms/broadcaster/Destroy()
	// In case message_delay is left on 1, otherwise it won't reset the list and people can't say the same thing twice anymore.
	if(message_delay)
		message_delay = 0
	return ..()


/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/
/obj/machinery/telecoms/allinone
	name = "telecommunications mainframe"
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	density = TRUE
	anchored = TRUE

	power_state = USE_POWER_OFF

	machinetype = 6
	//heatgen = 0
	operating_temperature = null

	var/intercept = 0 // if nonzero, broadcasts all messages to syndicate channel

/obj/machinery/telecoms/allinone/receive_signal(datum/signal/signal)
	if(!..())
		return
	if(!on) // has to be on to receive messages
		return

	if(is_freq_listening(signal)) // detect subspace signals
		signal.data["done"] = 1 // mark the signal as being broadcasted
		signal.data["compression"] = 0

		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary

		/* ###### Broadcast a message using signal.data ###### */
		var/datum/radio_frequency/connection = signal.data["connection"]

		if(connection.frequency == FREQUENCY_SYNDICATE) // if syndicate broadcast, just
			Broadcast_Message(
				signal.data["connection"], signal.data["mob"],
				signal.data["vmask"], signal.data["vmessage"],
				signal.data["radio"], signal.data["message"],
				signal.data["name"], signal.data["job"],
				signal.data["realname"], signal.data["vname"],, signal.data["compression"], list(0), connection.frequency,
				signal.data["verbage"], signal.data["language"]
			)
		else
			if(intercept)
				Broadcast_Message(
					signal.data["connection"], signal.data["mob"],
					signal.data["vmask"], signal.data["vmessage"],
					signal.data["radio"], signal.data["message"],
					signal.data["name"], signal.data["job"],
					signal.data["realname"], signal.data["vname"], 3, signal.data["compression"], list(0), connection.frequency,
					signal.data["verbage"], signal.data["language"]
				)

/**

	Here is the big, bad function that broadcasts a message given the appropriate
	parameters.

	@param connection:
		The datum generated in radio.dm, stored in signal.data["connection"].

	@param M:
		Reference to the mob/speaker, stored in signal.data["mob"]

	@param vmask:
		Boolean value if the mob is "hiding" its identity via voice mask, stored in
		signal.data["vmask"]

	@param vmessage:
		If specified, will display this as the message; such as "chimpering"
		for monkies if the mob is not understood. Stored in signal.data["vmessage"].

	@param radio:
		Reference to the radio broadcasting the message, stored in signal.data["radio"]

	@param message:
		The actual string message to display to mobs who understood mob M. Stored in
		signal.data["message"]

	@param name:
		The name to display when a mob receives the message. signal.data["name"]

	@param job:
		The name job to display for the AI when it receives the message. signal.data["job"]

	@param realname:
		The "real" name associated with the mob. signal.data["realname"]

	@param vname:
		If specified, will use this name when mob M is not understood. signal.data["vname"]

	@param data:
		If specified:
				1 -- Will only broadcast to intercoms
				2 -- Will only broadcast to intercoms and station-bounced radios
				3 -- Broadcast to syndicate frequency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual mob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal may be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param freq
		The frequency of the signal

**/
/proc/Broadcast_Message(datum/radio_frequency/connection, mob/M, vmask, vmessage, obj/item/radio/radio,
						message, name, job, realname, vname, data, compression, list/level, freq,
						verbage = "says", datum/language/speaking = null)

  /* ###### Prepare the radio connection ###### */
	var/display_freq = freq
	var/list/obj/item/radio/radios = list()

	// --- Broadcast only to intercom devices ---
	if(data == 1)
		for(var/obj/item/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			if(R.receive_range(display_freq, level) > -1)
				radios.Add(R)

	// --- Broadcast only to intercoms and station-bounced radios ---
	else if(data == 2)
		for(var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])
			if(istype(R, /obj/item/radio/headset))
				continue

			if(R.receive_range(display_freq, level) > -1)
				radios.Add(R)

	// --- Broadcast to syndicate radio! ---
	else if(data == 3)
		var/datum/radio_frequency/syndicate_connection = global.CTradio.return_frequency(FREQUENCY_SYNDICATE)
		for(var/obj/item/radio/R in syndicate_connection.devices["[RADIO_CHAT]"])
			if(R.receive_range(FREQUENCY_SYNDICATE, level) > -1)
				radios.Add(R)

	// --- Broadcast to ALL radio devices ---
	else
		for(var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])
			if(R.receive_range(display_freq, level) > -1)
				radios.Add(R)

	// Get a list of mobs who can hear from the radios we collected.
	var/list/mob/receive = get_mobs_in_radio_ranges(radios)

  /* ###### Organize the receivers into categories for displaying the message ###### */

  	// Understood the message:
	var/list/mob/heard_masked = list() // masked name or no real name
	var/list/mob/heard_normal = list() // normal message

	// Did not understand the message:
	var/list/mob/heard_voice = list() // voice message	(ie "chimpers")
	var/list/mob/heard_garbled = list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/mob/heard_gibberish = list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	for_no_type_check(var/mob/R, receive)
	  /* --- Loop through the receivers and categorize them --- */
		if(R.client && !(R.client.prefs.toggles & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
			continue

		if(isnewplayer(R)) // we don't want new players to hear messages. rare but generates runtimes.
			continue

		// Ghosts hearing all radio chat don't want to hear syndicate intercepts, they're duplicates
		if(data == 3 && isghost(R) && (R.client?.prefs.toggles & CHAT_GHOSTRADIO))
			continue

		// --- Check for compression ---
		if(compression > 0)
			heard_gibberish.Add(R)
			continue

		// --- Can understand the speech ---
		if(isnull(M) || R.say_understands(M))
			// - Not human or wearing a voice mask -
			if(isnull(M) || !ishuman(M) || vmask)
				heard_masked.Add(R)
			// - Human and not wearing voice mask -
			else
				heard_normal.Add(R)

		// --- Can't understand the speech ---
		else
			// - The speaker has a prespecified "voice message" to display if not understood -
			if(vmessage)
				heard_voice.Add(R)
			// - Just display a garbled message -
			else
				heard_garbled.Add(R)

  /* ###### Begin formatting and sending the message ###### */
	if(length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled) || length(heard_gibberish))
	  /* --- Some miscellaneous variables to format the string output --- */
		var/part_a = "<span class='radio'><span class='name'>" // goes in the actual output
		var/freq_text // the name of the channel

		// --- Set the name of the channel ---
		switch(display_freq)
			if(FREQUENCY_SYNDICATE)
				freq_text = CHANNEL_SYNDICATE

			if(FREQUENCY_DEATHSQUAD)
				freq_text = CHANNEL_DEATHSQUAD
			if(FREQUENCY_RESPONSETEAM)
				freq_text = CHANNEL_RESPONSETEAM

			if(FREQUENCY_SUPPLY)
				freq_text = CHANNEL_SUPPLY
			if(FREQUENCY_SERVICE)
				freq_text = CHANNEL_SERVICE
			if(FREQUENCY_SCIENCE)
				freq_text = CHANNEL_SCIENCE
			if(FREQUENCY_COMMAND)
				freq_text = CHANNEL_COMMAND
			if(FREQUENCY_MEDICAL)
				freq_text = CHANNEL_MEDICAL
			if(FREQUENCY_ENGINEERING)
				freq_text = CHANNEL_ENGINEERING
			if(FREQUENCY_SECURITY)
				freq_text = CHANNEL_SECURITY
			if(FREQUENCY_MINING)
				freq_text = CHANNEL_MINING

			if(FREQUENCY_AI_PRIVATE)
				freq_text = CHANNEL_AI_PRIVATE
			if(FREQUENCY_COMMON)
				freq_text = CHANNEL_COMMON
		//There's probably a way to use the list var of channels in code\__DEFINES\radio.dm to make the dept channels non-hardcoded, but I wasn't in an experimentive mood. --NEO

		// --- If the frequency has not been assigned a name, just use the frequency as the name ---
		if(!freq_text)
			freq_text = format_frequency(display_freq)

		// --- Some more pre-message formatting ---
		var/part_b_extra = ""
		if(data == 3) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"
		var/part_b = "</span><b> [html_icon(radio)]\[[freq_text]\][part_b_extra]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"

		// department radio formatting (poorly optimized, ugh)
		// syndies!
		if(display_freq == FREQUENCY_SYNDICATE)
			part_a = "<span class='syndradio'><span class='name'>"
		// centcom channels (deathsquid and ert)
		else if(display_freq in GLOBL.cent_freqs)
			part_a = "<span class='centradio'><span class='name'>"
		// cargo channel
		else if(display_freq == FREQUENCY_SUPPLY)
			part_a = "<span class='supradio'><span class='name'>"
		// service channel
		else if(display_freq == FREQUENCY_SERVICE)
			part_a = "<span class='srvradio'><span class='name'>"
		// science channel
		else if(display_freq == FREQUENCY_SCIENCE)
			part_a = "<span class='sciradio'><span class='name'>"
		// command channel
		else if(display_freq == FREQUENCY_COMMAND)
			part_a = "<span class='comradio'><span class='name'>"
		// medical channel
		else if(display_freq == FREQUENCY_MEDICAL)
			part_a = "<span class='medradio'><span class='name'>"
		// engineering channel
		else if(display_freq == FREQUENCY_ENGINEERING)
			part_a = "<span class='engradio'><span class='name'>"
		// security channel
		else if(display_freq == FREQUENCY_SECURITY)
			part_a = "<span class='secradio'><span class='name'>"
		// mining channel
		else if(display_freq == FREQUENCY_MINING)
			part_a = "<span class='minradio'><span class='name'>"
		// AI private channel
		else if(display_freq == FREQUENCY_AI_PRIVATE)
			part_a = "<span class='airadio'><span class='name'>"
		// If all else fails and it's a dept_freq, color me purple!
		else if(display_freq in GLOBL.dept_freqs)
			part_a = "<span class='deptradio'><span class='name'>"

		// --- Filter the message; place it in quotes apply a verb ---
		var/quotedmsg = null
		if(isnotnull(M))
			quotedmsg = M.say_quote(message)
		else
			quotedmsg = "says, \"[message]\""

		// --- This following recording is intended for research and feedback in the use of department radio channels ---
		var/part_blackbox_b = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/blackbox_msg = "[part_a][name][part_blackbox_b][quotedmsg][part_c]"
		//var/blackbox_admin_msg = "[part_a][M.name] (Real name: [M.real_name])[part_blackbox_b][quotedmsg][part_c]"

		//BR.messages_admin += blackbox_admin_msg
		if(istype(blackbox))
			switch(display_freq)
				if(FREQUENCY_COMMON)
					blackbox.msg_common += blackbox_msg
				if(FREQUENCY_SCIENCE)
					blackbox.msg_science += blackbox_msg
				if(FREQUENCY_COMMAND)
					blackbox.msg_command += blackbox_msg
				if(FREQUENCY_MEDICAL)
					blackbox.msg_medical += blackbox_msg
				if(FREQUENCY_ENGINEERING)
					blackbox.msg_engineering += blackbox_msg
				if(FREQUENCY_SECURITY)
					blackbox.msg_security += blackbox_msg
				if(FREQUENCY_DEATHSQUAD)
					blackbox.msg_deathsquad += blackbox_msg
				if(FREQUENCY_SYNDICATE)
					blackbox.msg_syndicate += blackbox_msg
				if(FREQUENCY_SUPPLY)
					blackbox.msg_cargo += blackbox_msg
				if(FREQUENCY_MINING)
					blackbox.msg_mining += blackbox_msg
				else
					blackbox.messages += blackbox_msg

		//End of research and feedback code.

	 /* ###### Send the message ###### */
	  	/* --- Process all the mobs that heard a masked voice (understood) --- */
		if(length(heard_masked))
			for_no_type_check(var/mob/R, heard_masked)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, FALSE, name)

		/* --- Process all the mobs that heard the voice normally (understood) --- */
		if(length(heard_normal))
			for_no_type_check(var/mob/R, heard_normal)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, FALSE, realname)

		/* --- Process all the mobs that heard the voice normally (did not understand) --- */
		if(length(heard_voice))
			for_no_type_check(var/mob/R, heard_voice)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, FALSE, vname)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")
		if(length(heard_garbled))
			for_no_type_check(var/mob/R, heard_garbled)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, TRUE, vname)

		/* --- Complete gibberish. Usually happens when there's a compressed message --- */
		if(length(heard_gibberish))
			for_no_type_check(var/mob/R, heard_gibberish)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, TRUE)

/proc/Broadcast_SimpleMessage(source, frequency, text, data, mob/M, compression, level)
  /* ###### Prepare the radio connection ###### */
	if(isnull(M))
		var/mob/living/carbon/human/H = new /mob/living/carbon/human()
		M = H

	var/datum/radio_frequency/connection = global.CTradio.return_frequency(frequency)

	var/display_freq = connection.frequency

	var/list/mob/receive = list()

	// --- Broadcast only to intercom devices ---
	if(data == 1)
		for(var/obj/item/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			if(GET_TURF_Z(R) == level)
				receive |= R.send_hear(display_freq, level)

	// --- Broadcast only to intercoms and station-bounced radios ---
	else if(data == 2)
		for(var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])
			if(istype(R, /obj/item/radio/headset))
				continue
			if(GET_TURF_Z(R) == level)
				receive |= R.send_hear(display_freq)

	// --- Broadcast to syndicate radio! ---
	else if(data == 3)
		var/datum/radio_frequency/syndicate_connection = global.CTradio.return_frequency(FREQUENCY_SYNDICATE)
		for(var/obj/item/radio/R in syndicate_connection.devices["[RADIO_CHAT]"])
			if(GET_TURF_Z(R) == level)
				receive |= R.send_hear(FREQUENCY_SYNDICATE)

	// --- Broadcast to ALL radio devices ---
	else
		for(var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"])
			if(GET_TURF_Z(R) == level)
				receive |= R.send_hear(display_freq)

  /* ###### Organize the receivers into categories for displaying the message ###### */

	// Understood the message:
	var/list/mob/heard_normal = list() // normal message

	// Did not understand the message:
	var/list/mob/heard_garbled = list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/mob/heard_gibberish = list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	for_no_type_check(var/mob/R, receive)
	  /* --- Loop through the receivers and categorize them --- */
		if(R.client && !(R.client.prefs.toggles & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
			continue

		// --- Check for compression ---
		if(compression > 0)
			heard_gibberish.Add(R)
			continue

		// --- Can understand the speech ---
		if(R.say_understands(M))
			heard_normal.Add(R)

		// --- Can't understand the speech ---
		else
			// - Just display a garbled message -
			heard_garbled.Add(R)

  /* ###### Begin formatting and sending the message ###### */
	if(length(heard_normal) || length(heard_garbled) || length(heard_gibberish))

	  /* --- Some miscellaneous variables to format the string output --- */
		var/part_a = "<span class='radio'><span class='name'>" // goes in the actual output
		var/freq_text // the name of the channel

		// --- Set the name of the channel ---
		switch(display_freq)
			if(FREQUENCY_SYNDICATE)
				freq_text = "#unkn"
			if(FREQUENCY_COMMAND)
				freq_text = "Command"
			if(FREQUENCY_SCIENCE)
				freq_text = "Science"
			if(FREQUENCY_MEDICAL)
				freq_text = "Medical"
			if(FREQUENCY_ENGINEERING)
				freq_text = "Engineering"
			if(FREQUENCY_SECURITY)
				freq_text = "Security"
			if(FREQUENCY_SUPPLY)
				freq_text = "Supply"
			if(FREQUENCY_MINING)
				freq_text = "Mining"
		//There's probably a way to use the list var of channels in code\game\communications.dm to make the dept channels non-hardcoded, but I wasn't in an experimentive mood. --NEO

		// --- If the frequency has not been assigned a name, just use the frequency as the name ---
		if(!freq_text)
			freq_text = format_frequency(display_freq)

		// --- Some more pre-message formatting ---
		var/part_b_extra = ""
		if(data == 3) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"

		// Creates a dummy radio headset for the sole purpose of using its icon.
		var/static/obj/item/radio/headset/radio = new /obj/item/radio/headset()

		var/part_b = "</span><b> [html_icon(radio)]\[[freq_text]\][part_b_extra]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"

		if(display_freq == FREQUENCY_SYNDICATE)
			part_a = "<span class='syndradio'><span class='name'>"
		else if(display_freq == FREQUENCY_COMMAND)
			part_a = "<span class='comradio'><span class='name'>"
		else if(display_freq in GLOBL.dept_freqs)
			part_a = "<span class='deptradio'><span class='name'>"

		// --- This following recording is intended for research and feedback in the use of department radio channels ---
		var/part_blackbox_b = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/blackbox_msg = "[part_a][source][part_blackbox_b]\"[text]\"[part_c]"
		//var/blackbox_admin_msg = "[part_a][M.name] (Real name: [M.real_name])[part_blackbox_b][quotedmsg][part_c]"

		//BR.messages_admin += blackbox_admin_msg
		if(istype(blackbox))
			switch(display_freq)
				if(FREQUENCY_COMMON)
					blackbox.msg_common += blackbox_msg
				if(FREQUENCY_SCIENCE)
					blackbox.msg_science += blackbox_msg
				if(FREQUENCY_COMMAND)
					blackbox.msg_command += blackbox_msg
				if(FREQUENCY_MEDICAL)
					blackbox.msg_medical += blackbox_msg
				if(FREQUENCY_ENGINEERING)
					blackbox.msg_engineering += blackbox_msg
				if(FREQUENCY_SECURITY)
					blackbox.msg_security += blackbox_msg
				if(FREQUENCY_DEATHSQUAD)
					blackbox.msg_deathsquad += blackbox_msg
				if(FREQUENCY_SYNDICATE)
					blackbox.msg_syndicate += blackbox_msg
				if(FREQUENCY_SUPPLY)
					blackbox.msg_cargo += blackbox_msg
				if(FREQUENCY_MINING)
					blackbox.msg_mining += blackbox_msg
				else
					blackbox.messages += blackbox_msg
		//End of research and feedback code.

	 /* ###### Send the message ###### */
		/* --- Process all the mobs that heard the voice normally (understood) --- */
		if(length(heard_normal))
			var/rendered = "[part_a][source][part_b]\"[text]\"[part_c]"
			for_no_type_check(var/mob/R, heard_normal)
				R.show_message(rendered, 2)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")
		if(length(heard_garbled))
			var/quotedmsg = "\"[stars(text)]\""
			var/rendered = "[part_a][source][part_b][quotedmsg][part_c]"
			for_no_type_check(var/mob/R, heard_garbled)
				R.show_message(rendered, 2)

		/* --- Complete gibberish. Usually happens when there's a compressed message --- */
		if(length(heard_gibberish))
			var/quotedmsg = "\"[Gibberish(text, compression + 50)]\""
			var/rendered = "[part_a][Gibberish(source, compression + 50)][part_b][quotedmsg][part_c]"
			for_no_type_check(var/mob/R, heard_gibberish)
				R.show_message(rendered, 2)


//Use this to test if an obj can communicate with a Telecommunications Network
/atom/proc/test_telecoms()
	var/datum/signal/signal = src.telecoms_process()
	return (GET_TURF_Z(src) in signal.data["level"] && signal.data["done"])

/atom/proc/telecoms_process()
	// First, we want to generate a new radio signal
	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = 2 // 2 would be a subspace transmission.

	// --- Finally, tag the actual signal with the appropriate values ---
	signal.data = list(
		"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
		"message" = "TEST",
		"compression" = rand(45, 50), // If the signal is compressed, compress our message too.
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = 4, // determines what type of radio input it is: test broadcast
		"reject" = 0,
		"done" = 0,
		"level" = GET_TURF_Z(src) // The level it is being broadcasted at.
	)
	signal.frequency = FREQUENCY_COMMON// Common channel

  //#### Sending the signal to all subspace receivers ####//
	for(var/obj/machinery/telecoms/receiver/R in GLOBL.telecoms_list)
		R.receive_signal(signal)

	sleep(rand(1 SECOND, 2.5 SECONDS))

	//world.log << "Level: [signal.data["level"]] - Done: [signal.data["done"]]"
	return signal