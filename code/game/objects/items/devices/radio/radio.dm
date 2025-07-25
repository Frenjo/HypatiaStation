var/GLOBAL_RADIO_TYPE = 1 // radio type to use
	// 0 = old radios
	// 1 = new radios (subspace technology)

/obj/item/radio
	icon = 'icons/obj/items/devices/radio.dmi'
	name = "station bounced radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = 2
	matter_amounts = /datum/design/autolathe/bounced_radio::materials

	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = FREQUENCY_COMMON //common chat
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/obj/item/radio/patch_link = null
	var/datum/wires/radio/wires = null
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	var/freerange = 0 // 0 - Sanitize frequencies, 1 - Full range
	var/list/channels = list() //see __DEFINES/radio.dm for full list. First channes is a "default" for :h
	var/subspace_transmission = 0
	var/syndie = 0//Holder to see if it's a syndicate encrpyed radio
	var/maxf = 1499
//			"Example" = FREQ_LISTENING|FREQ_BROADCASTING

	var/const/TRANSMISSION_DELAY = 5 // only 2/second/radio
	var/const/FREQ_LISTENING = 1

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = new

/obj/item/radio/initialise()
	. = ..()
	wires = new /datum/wires/radio(src)

/obj/item/radio/Destroy()
	QDEL_NULL(wires)
	patch_link = null
	unregister_radio(src, frequency)
	for(var/ch_name in channels)
		unregister_radio(src, GLOBL.radio_channels[ch_name])
	radio_connection = null
	return ..()

/obj/item/radio/initialise()
	. = ..()
	if(freerange)
		if(frequency < 1200 || frequency > 1600)
			frequency = sanitize_frequency(frequency, maxf)
	// The max freq is higher than a regular headset to decrease the chance of people listening in, if you use the higher channels.
	else if (frequency < 1441 || frequency > maxf)
		//world.log << "[src] ([type]) has a frequency of [frequency], sanitizing."
		frequency = sanitize_frequency(frequency, maxf)

	radio_connection = register_radio(src, null, frequency, RADIO_CHAT)

	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = register_radio(src, null, GLOBL.radio_channels[ch_name], RADIO_CHAT)

/obj/item/radio/attack_self(mob/user)
	user.set_machine(src)
	interact(user)

/obj/item/radio/interact(mob/user)
	if(!on)
		return

	if(active_uplink_check(user))
		return

	var/dat = "<html><head><title>[src]</title></head><body><TT>"

	if(!istype(src, /obj/item/radio/headset)) //Headsets dont get a mic button
		dat += "Microphone: [broadcasting ? "<A href='byond://?src=\ref[src];talk=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];talk=1'>Disengaged</A>"]<BR>"

	dat += {"
				Speaker: [listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
				Frequency:
				<A href='byond://?src=\ref[src];freq=-10'>-</A>
				<A href='byond://?src=\ref[src];freq=-2'>-</A>
				[format_frequency(frequency)]
				<A href='byond://?src=\ref[src];freq=2'>+</A>
				<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
				"}

	for(var/ch_name in channels)
		dat += text_sec_channel(ch_name, channels[ch_name])
	dat += {"[text_wires()]</TT></body></html>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/radio/proc/text_wires()
	if(b_stat)
		return wires.GetInteractWindow()
	return

/obj/item/radio/proc/text_sec_channel(chan_name, chan_stat)
	var/list = !!(chan_stat & FREQ_LISTENING) != 0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
			"}

/obj/item/radio/Topic(href, href_list)
	//..()
	if(usr.stat || !on)
		return

	if(!(issilicon(usr) || (usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)))))
		usr << browse(null, "window=radio")
		return
	usr.set_machine(src)
	if(href_list["track"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		return

	else if(href_list["faketrack"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A:cameraFollow = target
			to_chat(A, "Now tracking [target.name] on camera.")
			if(usr.machine == null)
				usr.machine = usr

			while(usr:cameraFollow == target)
				to_chat(usr, "Target is not on or near any active cameras on the station. We'll check again in 5 seconds (unless you use the cancel-camera verb).")
				sleep(40)
				continue
		return

	else if(href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if(!freerange || (frequency < 1200 || frequency > 1600))
			new_frequency = sanitize_frequency(new_frequency, maxf)
		radio_connection = register_radio(src, new_frequency, new_frequency, RADIO_CHAT)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				usr << browse(null, "window=radio")
				return

	else if(href_list["talk"])
		broadcasting = text2num(href_list["talk"])
	else if(href_list["listen"])
		var/chan_name = href_list["ch_name"]
		if(!chan_name)
			listening = text2num(href_list["listen"])
		else
			if(channels[chan_name] & FREQ_LISTENING)
				channels[chan_name] &= ~FREQ_LISTENING
			else
				channels[chan_name] |= FREQ_LISTENING

	if(!(master))
		if(ismob(loc))
			interact(loc)
		else
			updateDialog()
	else
		if(ismob(master.loc))
			interact(master.loc)
		else
			updateDialog()
	add_fingerprint(usr)

/obj/item/radio/proc/autosay(message, from, channel) //BS12 EDIT
	var/datum/radio_frequency/connection = null
	if(channel && length(channels))
		if(channel == "department")
			//to_world("DEBUG: channel=\"[channel]\" switching to \"[channels[1]]\"")
			channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null
	if(!istype(connection))
		return
	if(!connection)
		return

	var/mob/living/silicon/ai/A = new /mob/living/silicon/ai(src, null, null, 1)
	Broadcast_Message(
		connection, A,
		0, "*garbled automated announcement*", src,
		message, from, "Automated Announcement", from, "synthesized voice",
		4, 0, list(1), FREQUENCY_COMMON
	)
	qdel(A)
	return

/obj/item/radio/talk_into(mob/living/M, message, channel, verbage = "says", datum/language/speaking = null)
	if(!on)
		return // the device has to be on
	// Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message)
		return

	// Uncommenting this. To the above comment:
	// The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just making radio wires useless. -Giacom
	if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return

	if(!radio_connection)
		radio_connection = register_radio(src, null, frequency, RADIO_CHAT)

	if(GLOBAL_RADIO_TYPE == 1) // NEW RADIO SYSTEMS: By Doohl

		/* Quick introduction:
			This new radio system uses a very robust FTL signaling technology unoriginally
			dubbed "subspace" which is somewhat similar to 'bluespace' but can't
			actually transmit large mass. Headsets are the only radio devices capable
			of sending subspace transmissions to the Communications Satellite.

			A headset sends a signal to a subspace listener/reciever elsewhere in space,
			the signal gets processed and logged, and an audible transmission gets sent
			to each individual headset.
		*/

	   //#### Grab the connection datum ####//
		var/datum/radio_frequency/connection = null
		if(channel == "headset")
			channel = null
		if(channel) // If a channel is specified, look for it.
			if(length(channels))
				if(channel == "department")
					//to_world("DEBUG: channel=\"[channel]\" switching to \"[channels[1]]\"")
					channel = channels[1]
				connection = secure_radio_connections[channel]
				if(!channels[channel]) // if the channel is turned off, don't broadcast
					return
			else
				// If we were to send to a channel we don't have, drop it.
		else // If a channel isn't specified, send to common.
			connection = radio_connection
			channel = null
		if(!istype(connection))
			return
		if(!connection)
			return

		var/turf/position = GET_TURF(src)

		//#### Tagging the signal with all appropriate identity values ####//

		// ||-- The mob's name identity --||
		var/displayname = M.name	// grab the display name (name you get when you hover over someone's icon)
		var/real_name = M.real_name // mob's real name
		var/mobkey = "none" // player key associated with mob
		var/voicemask = 0 // the speaker is wearing a voice mask
		if(M.client)
			mobkey = M.key // assign the mob's key


		var/jobname // the mob's "job"

		// --- Human: use their actual job ---
		if(ishuman(M))
			jobname = M:get_assignment()

		// --- Carbon Nonhuman ---
		else if(iscarbon(M)) // Nonhuman carbon mob
			jobname = "No id"

		// --- AI ---
		else if(isAI(M))
			jobname = "AI"

		// --- Cyborg ---
		else if(isrobot(M))
			jobname = "Cyborg"

		// --- Personal AI (pAI) ---
		else if(ispAI(M))
			jobname = "Personal AI"

		// --- Unidentifiable mob ---
		else
			jobname = "Unknown"

		// --- Modifications to the mob's identity ---

		// The mob is disguising their identity:
		if(ishuman(M) && M.GetVoice() != real_name)
			displayname = M.GetVoice()
			jobname = "Unknown"
			voicemask = 1

	  /* ###### Radio headsets can only broadcast through subspace ###### */

		if(subspace_transmission)
			// First, we want to generate a new radio signal
			var/datum/signal/signal = new /datum/signal()
			signal.transmission_method = TRANSMISSION_SUBSPACE

			// --- Finally, tag the actual signal with the appropriate values ---
			signal.data = list(
			  // Identity-associated tags:
				"mob" = M, // store a reference to the mob
				"mobtype" = M.type, 	// the mob's type
				"realname" = real_name, // the mob's real name
				"name" = displayname,	// the mob's display name
				"job" = jobname,		// the mob's job
				"key" = mobkey,			// the mob's key
				"vmessage" = pick(M.speak_emote), // the message to display if the voice wasn't understood
				"vname" = M.voice_name, // the name to display if the voice wasn't understood
				"vmask" = voicemask,	// 1 if the mob is using a voice gas mask

				// We store things that would otherwise be kept in the actual mob
				// so that they can be logged even AFTER the mob is deleted or something

			  // Other tags:
				"compression" = rand(45, 50), // compressed radio signal
				"message" = message, // the actual sent message
				"connection" = connection, // the radio connection to use
				"radio" = src, // stores the radio used for transmission
				"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
				"traffic" = 0, // dictates the total traffic sum that the signal went through
				"type" = 0, // determines what type of radio input it is: normal broadcast
				"server" = null, // the last server to log this signal
				"reject" = 0,	// if nonzero, the signal will not be accepted by any broadcasting machinery
				"level" = position.z, // The source's z level
				"language" = speaking,
				"verbage" = verbage
			)
			signal.frequency = connection.frequency // Quick frequency set

		  //#### Sending the signal to all subspace receivers ####//

			for(var/obj/machinery/telecoms/receiver/R in GLOBL.telecoms_list)
				R.receive_signal(signal)

			// Allinone can act as receivers.
			for(var/obj/machinery/telecoms/allinone/R in GLOBL.telecoms_list)
				R.receive_signal(signal)

			// Receiving code can be located in Telecommunications.dm
			return


	  /* ###### Intercoms and station-bounced radios ###### */

		var/filter_type = 2

		/* --- Intercoms can only broadcast to other intercoms, but bounced radios can broadcast to bounced radios and intercoms --- */
		if(istype(src, /obj/item/radio/intercom))
			filter_type = 1


		var/datum/signal/signal = new /datum/signal()
		signal.transmission_method = TRANSMISSION_SUBSPACE


		/* --- Try to send a normal subspace broadcast first */

		signal.data = list(
			"mob" = M, // store a reference to the mob
			"mobtype" = M.type, 	// the mob's type
			"realname" = real_name, // the mob's real name
			"name" = displayname,	// the mob's display name
			"job" = jobname,		// the mob's job
			"key" = mobkey,			// the mob's key
			"vmessage" = pick(M.speak_emote), // the message to display if the voice wasn't understood
			"vname" = M.voice_name, // the name to display if the voice wasn't understood
			"vmask" = voicemask,	// 1 if the mob is using a voice gas mas

			"compression" = 0, // uncompressed radio signal
			"message" = message, // the actual sent message
			"connection" = connection, // the radio connection to use
			"radio" = src, // stores the radio used for transmission
			"slow" = 0,
			"traffic" = 0,
			"type" = 0,
			"server" = null,
			"reject" = 0,
			"level" = position.z,
			"language" = speaking,
			"verbage" = verbage
		)
		signal.frequency = connection.frequency // Quick frequency set

		for(var/obj/machinery/telecoms/receiver/R in GLOBL.telecoms_list)
			R.receive_signal(signal)

		sleep(rand(10, 25)) // wait a little...

		if(signal.data["done"] && (position.z in signal.data["level"]))
			// we're done here.
			return

	  	// Oh my god; the comms are down or something because the signal hasn't been broadcasted yet in our level.
	  	// Send a mundane broadcast with limited targets:

		//THIS IS TEMPORARY.
		if(!connection)
			return	//~Carn

		Broadcast_Message(
			connection, M, voicemask, pick(M.speak_emote),
			src, message, displayname, jobname, real_name, M.voice_name,
			filter_type, signal.data["compression"], list(position.z), connection.frequency, verbage, speaking
		)


	else // OLD RADIO SYSTEMS: By Goons?

		var/datum/radio_frequency/connection = null
		if(channel && length(channels))
			if(channel == "department")
				//to_world("DEBUG: channel=\"[channel]\" switching to \"[channels[1]]\"")
				channel = channels[1]
			connection = secure_radio_connections[channel]
		else
			connection = radio_connection
			channel = null
		if(!istype(connection))
			return
		var/display_freq = connection.frequency

		//to_world("DEBUG: used channel=\"[channel]\" frequency= \"[display_freq]\" connection.devices.len = [length(connection.devices)]")

		var/eqjobname

		if(ishuman(M))
			eqjobname = M:get_assignment()
		else if(iscarbon(M))
			eqjobname = "No id" //only humans can wear ID
		else if(isAI(M))
			eqjobname = "AI"
		else if(isrobot(M))
			eqjobname = "Cyborg"//Androids don't really describe these too well, in my opinion.
		else if(ispAI(M))
			eqjobname = "Personal AI"
		else
			eqjobname = "Unknown"

		if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
			return

		var/list/receive = list()

		//for (var/obj/item/radio/R in radio_connection.devices)
		for(var/obj/item/radio/R in connection.devices["[RADIO_CHAT]"]) // Modified for security headset code -- TLE
			//if(R.accept_rad(src, message))
			receive |= R.send_hear(display_freq, 0)

		//to_world("DEBUG: receive.len=[length(receive)]")
		var/list/heard_masked = list() // masked name or no real name
		var/list/heard_normal = list() // normal message
		var/list/heard_voice = list() // voice message
		var/list/heard_garbled = list() // garbled message

		for(var/mob/R in receive)
			if(R.client && !(R.client.prefs.toggles & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
				continue
			if(R.say_understands(M))
				if(ishuman(M) && M.GetVoice() != M.real_name)
					heard_masked += R
				else
					heard_normal += R
			else
				heard_voice += R

		if(length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled))
			var/part_a = "<span class='radio'><span class='name'>"
			//var/part_b = "</span><b> \icon[src]\[[format_frequency(frequency)]\]</b> <span class='message'>"
			var/freq_text
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

			if(!freq_text)
				freq_text = format_frequency(display_freq)

			var/part_b = "</span><b> \icon[src]\[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
			var/part_c = "</span></span>"

			if(display_freq == FREQUENCY_SYNDICATE)
				part_a = "<span class='syndradio'><span class='name'>"
			else if(display_freq == FREQUENCY_COMMAND)
				part_a = "<span class='comradio'><span class='name'>"
			else if(display_freq in GLOBL.dept_freqs)
				part_a = "<span class='deptradio'><span class='name'>"

			var/quotedmsg = M.say_quote(message)

			//This following recording is intended for research and feedback in the use of department radio channels.

			var/part_blackbox_b = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
			var/blackbox_msg = "[part_a][M.name][part_blackbox_b][quotedmsg][part_c]"
			//var/blackbox_admin_msg = "[part_a][M.name] (Real name: [M.real_name])[part_blackbox_b][quotedmsg][part_c]"
			if(istype(blackbox))
				//BR.messages_admin += blackbox_admin_msg
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

			if(length(heard_masked))
				var/N = M.name
				var/J = eqjobname
				if(ishuman(M) && M.GetVoice() != M.real_name)
					N = M.GetVoice()
					J = "Unknown"
				var/rendered = "[part_a][N][part_b][quotedmsg][part_c]"
				for(var/mob/R in heard_masked)
					if(isAI(R))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[N] ([J]) </a>[part_b][quotedmsg][part_c]", 2)
					else
						R.show_message(rendered, 2)

			if(length(heard_normal))
				var/rendered = "[part_a][M.real_name][part_b][quotedmsg][part_c]"

				for(var/mob/R in heard_normal)
					if(isAI(R))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.real_name] ([eqjobname]) </a>[part_b][quotedmsg][part_c]", 2)
					else
						R.show_message(rendered, 2)

			if(length(heard_voice))
				var/rendered = "[part_a][M.voice_name][part_b][pick(M.speak_emote)][part_c]"

				for(var/mob/R in heard_voice)
					if(isAI(R))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.voice_name] ([eqjobname]) </a>[part_b][pick(M.speak_emote)][part_c]", 2)
					else
						R.show_message(rendered, 2)

			if(length(heard_garbled))
				quotedmsg = M.say_quote(stars(message))
				var/rendered = "[part_a][M.voice_name][part_b][quotedmsg][part_c]"

				for(var/mob/R in heard_voice)
					if(isAI(R))
						R.show_message("[part_a]<a href='byond://?src=\ref[src];track2=\ref[R];track=\ref[M]'>[M.voice_name]</a>[part_b][quotedmsg][part_c]", 2)
					else
						R.show_message(rendered, 2)

/obj/item/radio/hear_talk(mob/M, msg, verbage = "says", datum/language/speaking = null)
	if(broadcasting)
		if(get_dist(src, M) <= canhear_range)
			talk_into(M, msg, null, verbage, speaking)
/*
/obj/item/radio/proc/accept_rad(obj/item/radio/R, message)

	if ((R.frequency == frequency && message))
		return 1
	else if

	else
		return null
	return
*/

/obj/item/radio/proc/receive_range(freq, level)
	// check if this radio can receive on the given frequency, and if so,
	// what the range is in which mobs will hear the radio
	// returns: -1 if can't receive, range otherwise

	if(wires.IsIndexCut(WIRE_RECEIVE))
		return -1
	if(!listening)
		return -1

	if(!(0 in level))
		if(!(GET_TURF_Z(src) in level))
			return -1
	if(freq == FREQUENCY_SYNDICATE)
		if(!(src.syndie))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -1
	if(!on)
		return -1
	if(!freq) //recieved on main frequency
		if(!listening)
			return -1
	else
		var/accept = (freq == frequency && listening)
		if(!accept)
			for(var/ch_name in channels)
				var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
				if(RF.frequency == freq && (channels[ch_name] & FREQ_LISTENING))
					accept = 1
					break
		if(!accept)
			return -1
	return canhear_range

/obj/item/radio/proc/send_hear(freq, level)
	var/range = receive_range(freq, level)
	if(range > -1)
		return get_mobs_in_view(canhear_range, src)


/obj/item/radio/examine()
	set src in view()

	..()
	if((in_range(src, usr) || loc == usr))
		if(b_stat)
			usr.show_message(SPAN_INFO("\the [src] can be attached and modified!"))
		else
			usr.show_message(SPAN_INFO("\the [src] can not be modified or attached!"))
	return

/obj/item/radio/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		b_stat = !b_stat
		if(b_stat)
			to_chat(user, SPAN_NOTICE("The radio can now be attached and modified!"))
		else
			to_chat(user, SPAN_NOTICE("The radio can no longer be modified or attached!"))
		add_fingerprint(user)
		updateDialog()
		return TRUE

	return ..()

/obj/item/radio/emp_act(severity)
	broadcasting = 0
	listening = 0
	for (var/ch_name in channels)
		channels[ch_name] = 0
	..()

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/radio/borg
	var/obj/item/encryptionkey/keyslot = null//Borg radios can handle a single encryption key

/obj/item/radio/borg/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		if(isnotnull(keyslot))
			for(var/ch_name in channels)
				unregister_radio(src, GLOBL.radio_channels[ch_name])
				secure_radio_connections[ch_name] = null

			var/turf/T = GET_TURF(user)
			if(isnotnull(T))
				keyslot.forceMove(T)
				keyslot = null

			recalculateChannels()
			to_chat(user, SPAN_NOTICE("You pop out the encryption key from the radio!"))
		else
			to_chat(user, SPAN_WARNING("This radio doesn't have any encryption keys!"))
		return TRUE
	return ..()

/obj/item/radio/borg/attackby(obj/item/W, mob/user)
//	..()
	user.set_machine(src)
	if(!(isscrewdriver(W) || (istype(W, /obj/item/encryptionkey/))))
		return

	if(isscrewdriver(W))
		if(keyslot)
			for(var/ch_name in channels)
				unregister_radio(src, GLOBL.radio_channels[ch_name])
				secure_radio_connections[ch_name] = null

			if(keyslot)
				var/turf/T = GET_TURF(user)
				if(isnotnull(T))
					keyslot.forceMove(T)
					keyslot = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption key in the radio!")
		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(W, /obj/item/encryptionkey/))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			user.drop_item()
			W.forceMove(src)
			keyslot = W

		recalculateChannels()

	return

/obj/item/radio/borg/proc/recalculateChannels()
	src.channels = list()
	src.syndie = 0

	var/mob/living/silicon/robot/D = src.loc
	if(D.model)
		for(var/ch_name in D.model.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += D.model.channels[ch_name]
	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += keyslot.channels[ch_name]

		if(keyslot.syndie)
			src.syndie = 1

	for(var/ch_name in src.channels)
		if(!global.CTradio)
			sleep(30) // Waiting for the radio_controller to be created.
		if(!global.CTradio)
			src.name = "broken radio"
			return

		secure_radio_connections[ch_name] = register_radio(src, null, GLOBL.radio_channels[ch_name], RADIO_CHAT)

	return

/obj/item/radio/borg/Topic(href, href_list)
	if(usr.stat || !on)
		return
	if(href_list["mode"])
		if(subspace_transmission != 1)
			subspace_transmission = 1
			to_chat(usr, "Subspace Transmission is disabled.")
		else
			subspace_transmission = 0
			to_chat(usr, "Subspace Transmission is enabled.")
		if(subspace_transmission == 1)	//Simple as fuck, clears the channel list to prevent talking/listening over them if subspace transmission is disabled
			channels = list()
		else
			recalculateChannels()
	..()

/obj/item/radio/borg/interact(mob/user)
	if(!on)
		return

	var/dat = "<html><head><title>[src]</title></head><body><TT>"
	dat += {"
				Speaker: [listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
				Frequency:
				<A href='byond://?src=\ref[src];freq=-10'>-</A>
				<A href='byond://?src=\ref[src];freq=-2'>-</A>
				[format_frequency(frequency)]
				<A href='byond://?src=\ref[src];freq=2'>+</A>
				<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
				<A href='byond://?src=\ref[src];mode=1'>Toggle Broadcast Mode</A><BR>
				"}

	if(!subspace_transmission)//Don't even bother if subspace isn't turned on
		for(var/ch_name in channels)
			dat += text_sec_channel(ch_name, channels[ch_name])
	dat += {"[text_wires()]</TT></body></html>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/radio/proc/config(op)
	for(var/ch_name in channels)
		unregister_radio(src, GLOBL.radio_channels[ch_name])
	secure_radio_connections = new
	channels = op
	for(var/ch_name in op)
		secure_radio_connections[ch_name] = register_radio(src, null, GLOBL.radio_channels[ch_name], RADIO_CHAT)
	return

/obj/item/radio/off
	listening = 0