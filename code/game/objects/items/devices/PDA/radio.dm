/obj/item/radio/integrated
	name = "\improper PDA radio module"
	desc = "An electronic radio system of NanoTrasen origin."
	icon = 'icons/obj/items/module.dmi'
	icon_state = "power_mod"

	var/obj/item/pda/hostpda = null

	on = FALSE //Are we currently active??
	var/menu_message = ""

/obj/item/radio/integrated/New()
	..()
	if(istype(loc.loc, /obj/item/pda))
		hostpda = loc.loc

/obj/item/radio/integrated/proc/post_signal(freq, key, value, key2, value2, key3, value3, s_filter)
	//to_world("Post: [freq]: [key]=[value], [key2]=[value2]")
	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(freq)

	if(!frequency)
		return

	var/datum/signal/signal = new /datum/signal()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	frequency.post_signal(src, signal, filter = s_filter)

	return

/obj/item/radio/integrated/proc/generate_menu()

/obj/item/radio/integrated/beepsky
	var/list/botlist = null		// list of bots
	var/obj/machinery/bot/secbot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot

	var/control_freq = 1447

// create a new QM cartridge, and register to receive bot control & beacon message
/obj/item/radio/integrated/beepsky/initialise()
	. = ..()
	register_radio(src, null, control_freq, RADIO_SECBOT)

/obj/item/radio/integrated/beepsky/Destroy()
	unregister_radio(src, control_freq)
	return ..()

	// receive radio signals
	// can detect bot status signals
	// create/populate list as they are recvd

/obj/item/radio/integrated/beepsky/receive_signal(datum/signal/signal)
	if(!..())
		return

//	var/obj/item/pda/P = src.loc

	/*
	to_world("recvd:[P] : [signal.source]")
	for(var/d in signal.data)
		to_world("- [d] = [signal.data[d]]")
	*/
	if(signal.data["type"] == "secbot")
		if(!botlist)
			botlist = list()

		if(!(signal.source in botlist))
			botlist += signal.source

		if(active == signal.source)
			var/list/b = signal.data
			botstatus = b.Copy()

//	if (istype(P)) P.updateSelfDialog()

/obj/item/radio/integrated/beepsky/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/pda/PDA = src.hostpda

	switch(topic.get_str("op"))
		if("control")
			active = topic.get_and_locate("bot")
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

		if("scanbots")		// find all bots
			botlist = null
			post_signal(control_freq, "command", "bot_status", s_filter = RADIO_SECBOT)

		if("botlist")
			active = null

		if("stop", "go")
			post_signal(control_freq, "command", topic.get_str("op"), "active", active, s_filter = RADIO_SECBOT)
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

		if("summon")
			post_signal(control_freq, "command", "summon", "active", active, "target", GET_TURF(PDA) , s_filter = RADIO_SECBOT)
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

/obj/item/radio/integrated/mule
	var/list/botlist = null		// list of bots
	var/obj/machinery/bot/mulebot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot
	var/list/beacons

	var/beacon_freq = 1400
	var/control_freq = 1447

// create a new QM cartridge, and register to receive bot control & beacon message
/obj/item/radio/integrated/mule/initialise()
	. = ..()
	register_radio(src, null, control_freq, RADIO_MULEBOT)
	register_radio(src, null, beacon_freq, RADIO_NAVBEACONS)
	spawn(10)
		post_signal(beacon_freq, "findbeacon", "delivery", s_filter = RADIO_NAVBEACONS)

// receive radio signals
// can detect bot status signals
// and beacon locations
// create/populate lists as they are recvd

/obj/item/radio/integrated/mule/receive_signal(datum/signal/signal)
	if(!..())
		return

//	var/obj/item/pda/P = src.loc

	/*
	to_world("recvd:[P] : [signal.source]")
	for(var/d in signal.data)
		to_world("- [d] = [signal.data[d]]")
	*/
	if(signal.data["type"] == "mulebot")
		if(!botlist)
			botlist = list()

		if(!(signal.source in botlist))
			botlist += signal.source

		if(active == signal.source)
			var/list/b = signal.data
			botstatus = b.Copy()

	else if(signal.data["beacon"])
		if(!beacons)
			beacons = list()

		beacons[signal.data["beacon"] ] = signal.source

//	if(istype(P)) P.updateSelfDialog()

/obj/item/radio/integrated/mule/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE

	var/cmd = "command"
	if(active)
		cmd = "command [active.suffix]"

	switch(topic.get_str("op"))
		if("control")
			active = topic.get_and_locate("bot")
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("scanbots")		// find all bots
			botlist = null
			post_signal(control_freq, "command", "bot_status", s_filter = RADIO_MULEBOT)

		if("botlist")
			active = null

		if("unload")
			post_signal(control_freq, cmd, "unload", s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
		if("setdest")
			if(beacons)
				var/dest = input("Select Bot Destination", "Mulebot [active.suffix] Interlink", active.destination) as null|anything in beacons
				if(dest)
					post_signal(control_freq, cmd, "target", "destination", dest, s_filter = RADIO_MULEBOT)
					post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("retoff")
			post_signal(control_freq, cmd, "autoret", "value", 0, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
		if("reton")
			post_signal(control_freq, cmd, "autoret", "value", 1, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("pickoff")
			post_signal(control_freq, cmd, "autopick", "value", 0, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
		if("pickon")
			post_signal(control_freq, cmd, "autopick", "value", 1, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("stop", "go", "home")
			post_signal(control_freq, cmd, topic.get_str("op"), s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)


/*
 *	Radio Cartridge, essentially a signaler.
 */
/obj/item/radio/integrated/signal
	frequency = 1457
	var/code = 30.0

/obj/item/radio/integrated/signal/initialise()
	. = ..()
	if(!global.CTradio)
		return

	if(src.frequency < 1441 || src.frequency > 1489)
		src.frequency = sanitize_frequency(src.frequency)

	radio_connection = register_radio(src, frequency, frequency, null)

/obj/item/radio/integrated/signal/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/item/radio/integrated/signal/proc/send_signal(message="ACTIVATE")
	if(last_transmission && world.time < (last_transmission + 5))
		return
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = GET_TURF(src)
	GLOBL.lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new /datum/signal()
	signal.source = src
	signal.encryption = code
	signal.data = list("message" = message)

	radio_connection.post_signal(src, signal)

	return