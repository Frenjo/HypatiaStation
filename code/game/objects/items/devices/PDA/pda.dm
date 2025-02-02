//The advanced pea-green monochrome lcd of tomorrow.
/obj/item/pda
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/items/devices/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = 1.0
	slot_flags = SLOT_ID | SLOT_BELT

	//Main variables
	var/owner = null
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/cartridge/cartridge = null //current cartridge
	var/mode = 0 //Controls what menu the PDA will display. 0 is hub; the rest are either built in or based on cartridge.

	var/lastmode = 0
	var/ui_tick = 0

	//Secondary variables
	var/scanmode = 0	//1 is medical scanner, 2 is forensics, 3 is reagent scanner.
	var/fon = 0			//Is the flashlight function on?
	var/f_lum = 2		//Luminosity for the flashlight function
	var/silent = FALSE	//To beep or not to beep, that is the question
	var/toff = FALSE	//If 1, messenger disabled
	var/tnote[0]		//Current Texts
	var/last_text		//No text spamming
	var/last_honk		//Also no honk spamming that's bad too
	var/ttone = "beep"	//The ringtone!
	var/lock_code = ""	// Lockcode to unlock uplink
	var/honkamt = 0		//How many honks left when infected with honk.exe
	var/mimeamt = 0		//How many silence left when infected with mime.exe
	var/note = "Congratulations, your station has chosen the Thinktronic 5230 Personal Data Assistant!"	//Current note in the notepad function
	var/notehtml = ""
	var/cart = ""		//A place to stick cartridge menu information
	var/detonate = TRUE	// Can the PDA be blown up?
	var/hidden = FALSE	// Is the PDA hidden from the PDA list?
	var/active_conversation = null		// New variable that allows us to only view a single conversation.
	var/list/conversations = list()		// For keeping up with who we have PDA messsages from.
	var/newmessage = FALSE				//To remove hackish overlay check

	var/list/cartmodes = list(40, 42, 43, 433, 44, 441, 45, 451, 46, 48, 47, 49)	// If you add more cartridge modes add them to this list as well.
	var/list/no_auto_update = list(1, 40, 43, 44, 441, 45, 451)						// These modes we turn off autoupdate
	var/list/update_every_five = list(3, 41, 433, 46, 47, 48, 49)					// These we update every 5 ticks

	var/obj/item/card/id/id = null	//Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null						//related to above

	var/obj/item/paicard/pai = null	// A slot for a personal AI device

/*
 *	The Actual PDA
 */
/obj/item/pda/New()
	..()
	GLOBL.pda_list.Add(src)
	GLOBL.pda_list = sortAtom(GLOBL.pda_list)
	if(default_cartridge)
		cartridge = new default_cartridge(src)
	new /obj/item/pen(src)

/obj/item/pda/Destroy()
	GLOBL.pda_list.Remove(src)
	if(isnotnull(id) && prob(90)) //IDs are kept in 90% of the cases
		id.forceMove(GET_TURF(src))
	return ..()

/obj/item/pda/pickup(mob/user)
	if(fon)
		set_light(0)
		user.set_light(user.luminosity + f_lum)

/obj/item/pda/dropped(mob/user)
	if(fon)
		user.set_light(user.luminosity - f_lum)
		set_light(f_lum)

/obj/item/pda/proc/can_use()
	if(!ismob(loc))
		return 0

	var/mob/M = loc
	if(M.stat || M.restrained() || M.paralysis || M.stunned || M.weakened)
		return 0
	if((src in M.contents) || (isturf(loc) && in_range(src, M)))
		return 1
	else
		return 0

/obj/item/pda/get_access()
	return isnotnull(id) ? id.get_access() : ..()

/obj/item/pda/get_id()
	return id

/obj/item/pda/MouseDrop(obj/over_object, src_location, over_location)
	var/mob/M = usr
	if(!istype(over_object, /atom/movable/screen) && can_use())
		return attack_self(M)
	return

/obj/item/pda/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	ui_tick++
	var/datum/nanoui/old_ui = global.PCnanoui.get_open_ui(user, src, "main")
	var/auto_update = TRUE
	if(mode in no_auto_update)
		auto_update = FALSE
	if(old_ui && (mode == lastmode && ui_tick % 5 && (mode in update_every_five)))
		return

	lastmode = mode

	var/title = "Personal Data Assistant"

	var/list/data = list() // This is the data that will be sent to the PDA

	data["owner"] = owner					// Who is your daddy...
	data["ownjob"] = ownjob					// ...and what does he do?

	data["mode"] = mode					// The current view
	data["scanmode"] = scanmode				// Scanners
	data["fon"] = fon					// Flashlight on?
	data["pai"] = (isnull(pai) ? FALSE : TRUE)			// pAI inserted?
	data["note"] = note					// current pda notes
	data["silent"] = silent					// does the pda make noise when it receives a message?
	data["toff"] = toff					// is the messenger function turned off?
	data["active_conversation"] = active_conversation	// Which conversation are we following right now?

	data["idInserted"] = (id ? TRUE : FALSE)
	data["idLink"] = (id ? text("[id.registered_name], [id.assignment]") : "--------")

	data["cart_loaded"] = cartridge ? TRUE : FALSE
	if(cartridge)
		var/list/cartdata = list()

		if(mode in cartmodes)
			data["records"] = cartridge.create_NanoUI_values()

		if(mode == 0)
			cartdata["name"] = cartridge.name
			cartdata["access"] = list(
					"access_security" = cartridge.access_security,
					"access_engine" = cartridge.access_engine,
					"access_atmos" = cartridge.access_atmos,
					"access_medical" = cartridge.access_medical,
					"access_clown" = cartridge.access_clown,
					"access_mime" = cartridge.access_mime,
					"access_janitor" = cartridge.access_janitor,
					"access_quartermaster" = cartridge.access_quartermaster,
					"access_hydroponics" = cartridge.access_hydroponics,
					"access_reagent_scanner" = cartridge.access_reagent_scanner,
					"access_remote_door" = cartridge.access_remote_door,
					"access_status_display" = cartridge.access_status_display
			)
			if(isnull(cartridge.radio))
				cartdata["radio"] = 0
			else
				if(istype(cartridge.radio, /obj/item/radio/integrated/beepsky))
					cartdata["radio"] = 1
				if(istype(cartridge.radio, /obj/item/radio/integrated/signal))
					cartdata["radio"] = 2
				if(istype(cartridge.radio, /obj/item/radio/integrated/mule))
					cartdata["radio"] = 3

		if(mode == 2)
			cartdata["type"] = cartridge.type
			cartdata["charges"] = cartridge.charges ? cartridge.charges : 0
		data["cartridge"] = cartdata

	data["stationTime"] = worldtime2text()
	data["newMessage"] = newmessage

	if(mode == 2)
		var/list/convopdas = list()
		var/list/pdas = list()
		var/count = 0
		for_no_type_check(var/obj/item/pda/P, GLOBL.pda_list)
			if(!P.owner || P.toff || P == src || P.hidden)
				continue
			if(conversations.Find("\ref[P]"))
				convopdas.Add(list(list("Name" = "[P]", "Reference" = "\ref[P]", "Detonate" = "[P.detonate]", "inconvo" = "1")))
			else
				pdas.Add(list(list("Name" = "[P]", "Reference" = "\ref[P]", "Detonate" = "[P.detonate]", "inconvo" = "0")))
			count++

		data["convopdas"] = convopdas
		data["pdas"] = pdas
		data["pda_count"] = count

	if(mode == 21)
		data["messagescount"] = length(tnote)
		data["messages"] = tnote
	else
		data["messagescount"] = null
		data["messages"] = null

	if(active_conversation)
		for(var/c in tnote)
			if(c["target"] == active_conversation)
				data["convo_name"] = sanitize(c["owner"])
				data["convo_job"] = sanitize(c["job"])
				break
	if(mode == 41)
		data["manifest"] = GLOBL.data_core.get_manifest_json()

	if(mode == 3)
		var/turf/T = GET_TURF(user)
		if(isnotnull(T))
			var/datum/gas_mixture/environment = T.return_air()

			var/pressure = environment.return_pressure()
			var/total_moles = environment.total_moles

			if(total_moles)
				var/o2_level = environment.gas[/decl/xgm_gas/oxygen] / total_moles
				var/n2_level = environment.gas[/decl/xgm_gas/nitrogen] / total_moles
				var/co2_level = environment.gas[/decl/xgm_gas/carbon_dioxide] / total_moles
				var/plasma_level = environment.gas[/decl/xgm_gas/plasma] / total_moles
				var/unknown_level = 1 - (o2_level + n2_level + co2_level + plasma_level)
				data["aircontents"] = list(
					"pressure" = "[round(pressure, 0.1)]",
					"nitrogen" = "[round(n2_level * 100, 0.1)]",
					"oxygen" = "[round(o2_level * 100, 0.1)]",
					"carbon_dioxide" = "[round(co2_level*100, 0.1)]",
					"plasma" = "[round(plasma_level * 100, 0.01)]",
					"other" = "[round(unknown_level, 0.01)]",
					"temp" = "[round(environment.temperature - T0C, 0.1)]",
					"reading" = 1
				)
		if(isnull(data["aircontents"]))
			data["aircontents"] = list("reading" = 0)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "pda.tmpl", title, 520, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
	// auto update every Master Controller tick
	ui.set_auto_update(auto_update)

//NOTE: graphic resources are loaded on client login
/obj/item/pda/attack_self(mob/user)
	user.set_machine(src)

	if(active_uplink_check(user))
		return

	ui_interact(user) //NanoUI requires this proc
	return

/obj/item/pda/Topic(href, href_list)
	if(href_list["cartmenu"] && isnotnull(cartridge))
		cartridge.Topic(href, href_list)
		return 1
	if(href_list["radiomenu"] && isnotnull(cartridge) && isnotnull(cartridge.radio))
		cartridge.radio.Topic(href, href_list)
		return 1

	..()
	var/mob/user = usr
	var/datum/nanoui/ui = global.PCnanoui.get_open_ui(user, src, "main")
	var/mob/living/U = usr
	//Looking for master was kind of pointless since PDAs don't appear to have one.
	//if ((src in U.contents) || ( isturf(loc) && in_range(src, U) ) )
	if(usr.stat == DEAD)
		return 0
	if(!can_use()) //Why reinvent the wheel? There's a proc that does exactly that.
		U.unset_machine()
		if(ui)
			ui.close()
		return 0

	add_fingerprint(U)
	U.set_machine(src)

	switch(href_list["choice"])

//BASIC FUNCTIONS===================================

		if("Close")//Self explanatory
			U.unset_machine()
			ui.close()
			return 0
		if("Refresh")//Refresh, goes to the end of the proc.
		if("Return")//Return
			if(mode <= 9)
				mode = 0
			else
				mode = round(mode / 10)
				if(mode == 2)
					active_conversation = null
				if(mode == 4)//Fix for cartridges. Redirects to hub.
					mode = 0
				else if(mode >= 40 && mode <= 49)//Fix for cartridges. Redirects to refresh the menu.
					cartridge.mode = mode
		if("Authenticate")//Checks for ID
			id_check(U, 1)
		if("UpdateInfo")
			set_job(id.assignment)
		if("Eject")//Ejects the cart, only done from hub.
			if(isnotnull(cartridge))
				var/turf/T = loc
				if(ismob(T))
					T = T.loc
				cartridge.forceMove(T)
				mode = 0
				scanmode = 0
				if(cartridge.radio)
					cartridge.radio.hostpda = null
				cartridge = null

//MENU FUNCTIONS===================================

		if("0")//Hub
			mode = 0
		if("1")//Notes
			mode = 1
		if("2")//Messenger
			mode = 2
		if("21")//Read messeges
			mode = 21
		if("3")//Atmos scan
			mode = 3
		if("4")//Redirects to hub
			mode = 0
		if("chatroom") // chatroom hub
			mode = 5
		if("41") //Manifest
			mode = 41

//MAIN FUNCTIONS===================================

		if("Light")
			if(fon)
				fon = 0
				if(src in U.contents)
					U.set_light(U.luminosity - f_lum)
				else
					set_light(0)
			else
				fon = 1
				if(src in U.contents)
					U.set_light(U.luminosity + f_lum)
				else
					set_light(f_lum)
		if("Medical Scan")
			if(scanmode == 1)
				scanmode = 0
			else if((isnotnull(cartridge)) && (cartridge.access_medical))
				scanmode = 1
		if("Reagent Scan")
			if(scanmode == 3)
				scanmode = 0
			else if((isnotnull(cartridge)) && (cartridge.access_reagent_scanner))
				scanmode = 3
		if("Halogen Counter")
			if(scanmode == 4)
				scanmode = 0
			else if((isnotnull(cartridge)) && (cartridge.access_engine))
				scanmode = 4
		if("Honk")
			if(!(last_honk && world.time < last_honk + 20))
				playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
				last_honk = world.time
		if("Gas Scan")
			if(scanmode == 5)
				scanmode = 0
			else if((isnotnull(cartridge)) && (cartridge.access_atmos))
				scanmode = 5

//MESSENGER/NOTE FUNCTIONS===================================

		if("Edit")
			var/n = input(U, "Please enter message", name, notehtml) as message
			if(in_range(src, U) && loc == U)
				n = copytext(adminscrub(n), 1, MAX_MESSAGE_LEN)
				if (mode == 1)
					note = html_decode(n)
					notehtml = note
					note = replacetext(note, "\n", "<br>")
			else
				ui.close()
		if("Toggle Messenger")
			toff = !toff
		if("Toggle Ringer")//If viewing texts then erase them, if not then toggle silent status
			silent = !silent
		if("Clear")//Clears messages
			if(href_list["option"] == "All")
				tnote.Cut()
				conversations.Cut()
			if(href_list["option"] == "Convo")
				var/new_tnote[0]
				for(var/i in tnote)
					if(i["target"] != active_conversation)
						new_tnote[++new_tnote.len] = i
				tnote = new_tnote
				conversations.Remove(active_conversation)

			active_conversation = null
			if(mode == 21)
				mode = 2

		if("Ringtone")
			var/t = input(U, "Please enter new ringtone", name, ttone) as text
			if(in_range(src, U) && loc == U)
				if(t)
					if(src.hidden_uplink && hidden_uplink.check_trigger(U, lowertext(t), lowertext(lock_code)))
						to_chat(U, "The PDA softly beeps.")
						ui.close()
					else
						t = copytext(sanitize(t), 1, 20)
						ttone = t
			else
				ui.close()
				return 0

		if("Message")
			var/obj/item/pda/P = locate(href_list["target"])
			src.create_message(U, P)
			if(mode == 2)
				if(href_list["target"] in conversations)			// Need to make sure the message went through, if not welp.
					active_conversation = href_list["target"]
					mode = 21

		if("Select Conversation")
			var/P = href_list["convo"]
			for(var/n in conversations)
				if(P == n)
					active_conversation=P
					mode = 21

		if("Send Honk")//Honk virus
			if(istype(cartridge, /obj/item/cartridge/clown))//Cartridge checks are kind of unnecessary since everything is done through switch.
				var/obj/item/pda/P = locate(href_list["target"])//Leaving it alone in case it may do something useful, I guess.
				if(isnotnull(P))
					if(!P.toff && cartridge.charges > 0)
						cartridge.charges--
						U.show_message(SPAN_INFO("Virus sent!"), 1)
						P.honkamt = (rand(15, 20))
				else
					to_chat(U, "PDA not found.")
			else
				ui.close()
				return 0

		if("Send Silence")//Silent virus
			if(istype(cartridge, /obj/item/cartridge/mime))
				var/obj/item/pda/P = locate(href_list["target"])
				if(isnotnull(P))
					if(!P.toff && cartridge.charges > 0)
						cartridge.charges--
						U.show_message(SPAN_INFO("Virus sent!"), 1)
						P.silent = TRUE
						P.ttone = "silence"
				else
					to_chat(U, "PDA not found.")
			else
				ui.close()
				return 0

//SYNDICATE FUNCTIONS===================================

		if("Toggle Door")
			if(cartridge && cartridge.access_remote_door)
				for(var/obj/machinery/door/poddoor/M in GLOBL.machines)
					if(M.id == cartridge.remote_door_id)
						if(M.density)
							M.open()
						else
							M.close()

		if("Detonate")//Detonate PDA... maybe
			// check if telecoms I/O route FREQUENCY_COMMON (1459) is stable
			//var/telecoms_intact = telecoms_process(P.owner, owner, t)
			var/obj/machinery/message_server/useMS = null
			if(GLOBL.message_servers)
				for(var/obj/machinery/message_server/MS in GLOBL.message_servers)
				//PDAs are now dependant on the Message Server.
					if(MS.active)
						useMS = MS
						break

			var/datum/signal/signal = src.telecoms_process()

			var/useTC = 0
			if(signal)
				if(signal.data["done"])
					useTC = 1
					var/turf/pos = GET_TURF(src)
					if(pos?.z in signal.data["level"])
						useTC = 2

			if(istype(cartridge, /obj/item/cartridge/syndicate))
				if(!(useMS && useTC))
					U.show_message(SPAN_WARNING("An error flashes on your [src]: Connection unavailable."), 1)
					return
				if(useTC != 2) // Does our recepient have a broadcaster on their level?
					U.show_message(SPAN_WARNING("An error flashes on your [src]: Recipient unavailable."), 1)
					return
				var/obj/item/pda/P = locate(href_list["target"])
				if(isnotnull(P))
					if(!P.toff && cartridge.charges > 0)
						cartridge.charges--

						var/difficulty = 2
						if(P.cartridge)
							difficulty += P.cartridge.access_medical
							difficulty += P.cartridge.access_security
							difficulty += P.cartridge.access_engine
							difficulty += P.cartridge.access_clown
							difficulty += P.cartridge.access_janitor
							difficulty += 3 * P.hidden_uplink

						if(prob(difficulty))
							U.show_message(SPAN_WARNING("An error flashes on your [src]."), 1)
						else if(prob(difficulty * 7))
							U.show_message(SPAN_WARNING("Energy feeds back into your [src]!"), 1)
							ui.close()
							detonate_act(src)
							log_admin("[key_name(U)] just attempted to blow up [P] with the Detomatix cartridge but failed, blowing themselves up")
							message_admins("[key_name_admin(U)] just attempted to blow up [P] with the Detomatix cartridge but failed.", 1)
						else
							U.show_message(SPAN_INFO("Success!"), 1)
							log_admin("[key_name(U)] just attempted to blow up [P] with the Detomatix cartridge and succeeded")
							message_admins("[key_name_admin(U)] just attempted to blow up [P] with the Detomatix cartridge and succeeded.", 1)
							detonate_act(P)
					else
						to_chat(U, "No charges left.")
				else
					to_chat(U, "PDA not found.")
			else
				U.unset_machine()
				ui.close()
				return 0

//pAI FUNCTIONS===================================
		if("pai")
			switch(href_list["option"])
				if("1")		// Configure pAI device
					pai.attack_self(U)
				if("2")		// Eject pAI device
					var/turf/T = get_turf_or_move(src.loc)
					if(T)
						pai.forceMove(T)
						pai = null

		else
			mode = text2num(href_list["choice"])
			if(cartridge)
				cartridge.mode = mode

//EXTRA FUNCTIONS===================================

	if(mode == 2 || mode == 21)//To clear message overlays.
		overlays.Cut()
		newmessage = FALSE

	if(honkamt > 0 && prob(60))//For clown virus.
		honkamt--
		playsound(loc, 'sound/items/bikehorn.ogg', 30, 1)

	return 1 // return 1 tells it to refresh the UI in NanoUI

/obj/item/pda/proc/detonate_act(obj/item/pda/P)
	//TODO: sometimes these attacks show up on the message server
	var/i = rand(1, 100)
	var/j = rand(0, 1) //Possibility of losing the PDA after the detonation
	var/message = ""
	var/mob/living/M = null
	if(ismob(P.loc))
		M = P.loc

	//switch(i) //Yes, the overlapping cases are intended.
	if(i <= 10) //The traditional explosion
		P.explode()
		j = 1
		message += "Your [P] suddenly explodes!"
	if(i >= 10 && i<= 20) //The PDA burns a hole in the holder.
		j = 1
		if(M && isliving(M))
			M.apply_damage(rand(30, 60), BURN)
		message += "You feel a searing heat! Your [P] is burning!"
	if(i >= 20 && i <= 25) //EMP
		empulse(P.loc, 3, 6, 1)
		message += "Your [P] emits a wave of electromagnetic energy!"
	if(i >= 25 && i <= 40) //Smoke
		make_chem_smoke(10, FALSE, P.loc, P)
		playsound(P.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
		message += "Large clouds of smoke billow forth from your [P]!"
	if(i >= 40 && i <= 45) //Bad smoke
		make_bad_smoke(10, FALSE, P.loc, P)
		playsound(P.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
		message += "Large clouds of noxious smoke billow forth from your [P]!"
	if(i >= 65 && i <= 75) //Weaken
		if(M && isliving(M))
			M.apply_effects(0, 1)
		message += "Your [P] flashes with a blinding white light! You feel weaker."
	if(i >= 75 && i <= 85) //Stun and stutter
		if(M && isliving(M))
			M.apply_effects(1, 0, 0, 0, 1)
		message += "Your [P] flashes with a blinding white light! You feel weaker."
	if(i >= 85) //Sparks
		make_sparks(2, TRUE, P.loc)
		message += "Your [P] begins to spark violently!"
	if(i > 45 && i < 65 && prob(50)) //Nothing happens
		message += "Your [P] bleeps loudly."
		j = prob(10)

	if(j) //This kills the PDA
		qdel(P)
		if(message)
			message += "It melts in a puddle of plastic."
		else
			message += "Your [P] shatters in a thousand pieces!"

	if(M && isliving(M))
		M.show_message(SPAN_WARNING(message), 1)

/obj/item/pda/proc/remove_id()
	if(id)
		if(ismob(loc))
			var/mob/M = loc
			M.put_in_hands(id)
			to_chat(usr, SPAN_NOTICE("You remove the ID from the [name]."))
		else
			id.forceMove(GET_TURF(src))
		id = null

/obj/item/pda/proc/create_message(mob/living/U = usr, obj/item/pda/P)
	var/t = input(U, "Please enter message", name, null) as text
	t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
	if(!t || !istype(P))
		return
	if(!in_range(src, U) && loc != U)
		return

	if(isnull(P)||P.toff || toff)
		return

	if(last_text && world.time < last_text + 5)
		return

	if(!can_use())
		return

	last_text = world.time
	// check if telecoms I/O route FREQUENCY_COMMON (1459) is stable
	//var/telecoms_intact = telecoms_process(P.owner, owner, t)
	var/obj/machinery/message_server/useMS = null
	if(GLOBL.message_servers)
		for(var/obj/machinery/message_server/MS in GLOBL.message_servers)
		//PDAs are now dependant on the Message Server.
			if(MS.active)
				useMS = MS
				break

	var/datum/signal/signal = src.telecoms_process()

	var/useTC = 0
	if(signal)
		if(signal.data["done"])
			useTC = 1
			var/turf/pos = GET_TURF(P)
			if(pos?.z in signal.data["level"])
				useTC = 2
				//Let's make this barely readable
				if(signal.data["compression"] > 0)
					t = Gibberish(t, signal.data["compression"] + 50)

	if(useMS && useTC) // only send the message if it's stable
		if(useTC != 2) // Does our recepient have a broadcaster on their level?
			to_chat(U, "ERROR: Cannot reach recipient.")
			return
		useMS.send_pda_message("[P.owner]","[owner]","[t]")
		tnote.Add(list(list("sent" = 1, "owner" = "[P.owner]", "job" = "[P.ownjob]", "message" = "[t]", "target" = "\ref[P]")))
		P.tnote.Add(list(list("sent" = 0, "owner" = "[owner]", "job" = "[ownjob]", "message" = "[t]", "target" = "\ref[src]")))
		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS)) // src.client is so that ghosts don't have to listen to mice
				if(isnewplayer(M))
					continue
				M.show_message("<span class='game say'>PDA Message - <span class='name'>[owner]</span> -> <span class='name'>[P.owner]</span>: <span class='message'>[t]</span></span>")

		if(!conversations.Find("\ref[P]"))
			conversations.Add("\ref[P]")
		if(!P.conversations.Find("\ref[src]"))
			P.conversations.Add("\ref[src]")

		if(prob(15)) //Give the AI a chance of intercepting the message
			var/who = src.owner
			if(prob(50))
				who = P.owner
			for(var/mob/living/silicon/ai/ai in GLOBL.mob_list)
				// Allows other AIs to intercept the message but the AI won't intercept their own message.
				if(ai.aiPDA != P && ai.aiPDA != src)
					ai.show_message("<i>Intercepted message from <b>[who]</b>: [t]</i>")

		if(!P.silent)
			playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)
		for(var/mob/O in hearers(3, P.loc))
			if(!P.silent)
				O.show_message("\icon[P] *[P.ttone]*")
		//Search for holder of the PDA.
		var/mob/living/L = null
		if(P.loc && isliving(P.loc))
			L = P.loc
		//Maybe they are a pAI!
		else
			L = get(P, /mob/living/silicon)

		if(L)
			to_chat(L, "\icon[P] <b>Message from [src.owner] ([ownjob]), </b>\"[t]\" (<a href='byond://?src=\ref[P];choice=Message;skiprefresh=1;target=\ref[src]'>Reply</a>)")
			global.PCnanoui.update_user_uis(L, P) // Update the recieving user's PDA UI so that they can see the new message

		global.PCnanoui.update_user_uis(U, P) // Update the sending user's PDA UI so that they can see the new message

		log_pda("[usr] (PDA: [src.name]) sent \"[t]\" to [P.name]")
		P.overlays.Cut()
		P.overlays += image('icons/obj/items/devices/pda.dmi', "pda-r")
		P.newmessage = TRUE
	else
		to_chat(U, SPAN_NOTICE("ERROR: Messaging server is not responding."))

/obj/item/pda/verb/verb_remove_id()
	set category = PANEL_OBJECT
	set name = "Remove ID"
	set src in usr

	if(issilicon(usr))
		return

	if(can_use(usr))
		if(id)
			remove_id()
		else
			to_chat(usr, SPAN_NOTICE("This PDA does not have an ID in it."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while restrained."))

/obj/item/pda/verb/verb_remove_pen()
	set category = PANEL_OBJECT
	set name = "Remove Pen"
	set src in usr

	if(issilicon(usr))
		return

	if(can_use(usr))
		var/obj/item/pen/O = locate() in src
		if(O)
			if(ismob(loc))
				var/mob/M = loc
				if(M.get_active_hand() == null)
					M.put_in_hands(O)
					to_chat(usr, SPAN_NOTICE("You remove \the [O] from \the [src]."))
					return
			O.forceMove(GET_TURF(src))
		else
			to_chat(usr, SPAN_NOTICE("This PDA does not have a pen in it."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while restrained."))

/obj/item/pda/proc/id_check(mob/user, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if(id)
			remove_id()
		else
			var/obj/item/I = user.get_active_hand()
			if(istype(I, /obj/item/card/id))
				user.drop_item()
				I.forceMove(src)
				id = I
	else
		var/obj/item/card/I = user.get_active_hand()
		if(istype(I, /obj/item/card/id) && I:registered_name)
			var/obj/old_id = id
			user.drop_item()
			I.forceMove(src)
			id = I
			user.put_in_hands(old_id)
	return

// access to status display signals
/obj/item/pda/attackby(obj/item/C, mob/user)
	..()
	if(istype(C, /obj/item/cartridge) && !cartridge)
		cartridge = C
		user.drop_item()
		cartridge.forceMove(src)
		to_chat(user, SPAN_NOTICE("You insert [cartridge] into [src]."))
		global.PCnanoui.update_uis(src) // update all UIs attached to src
		if(cartridge.radio)
			cartridge.radio.hostpda = src

	else if(istype(C, /obj/item/card/id))
		var/obj/item/card/id/idcard = C
		if(!idcard.registered_name)
			to_chat(user, SPAN_NOTICE("\The [src] rejects the ID."))
			return
		if(!owner)
			set_owner_and_job(idcard.registered_name, idcard.assignment)
			to_chat(user, SPAN_NOTICE("Card scanned."))
		else
			//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.
			if(((src in user.contents) && (C in user.contents)) || (isturf(loc) && in_range(src, user) && (C in user.contents)))
				id_check(user, 2)
				to_chat(user, SPAN_NOTICE("You put the ID into \the [src]'s slot."))
				updateSelfDialog()//Update self dialog on success.
			return	//Return in case of failed check or when successful.
		updateSelfDialog()//For the non-input related code.
	else if(istype(C, /obj/item/paicard) && !src.pai)
		user.drop_item()
		C.forceMove(src)
		pai = C
		to_chat(user, SPAN_NOTICE("You slot \the [C] into [src]."))
		global.PCnanoui.update_uis(src) // update all UIs attached to src
	else if(istype(C, /obj/item/pen))
		var/obj/item/pen/O = locate() in src
		if(O)
			to_chat(user, SPAN_NOTICE("There is already a pen in \the [src]."))
		else
			user.drop_item()
			C.forceMove(src)
			to_chat(user, SPAN_NOTICE("You slide \the [C] into \the [src]."))
	return

/obj/item/pda/attack(mob/living/M, mob/living/user)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		switch(scanmode)
			if(1)
				for(var/mob/O in viewers(C, null))
					O.show_message(SPAN_WARNING("[user] has analysed [C]'s vitals!"), 1)

				user.show_message(SPAN_INFO("Analyzing Results for [C]:"))
				user.show_message("\blue \t Overall Status: [C.stat > 1 ? "dead" : "[C.health - C.halloss]% healthy"]", 1)
				user.show_message("\blue \t Damage Specifics: [C.getOxyLoss() > 50 ? "\red" : "\blue"][C.getOxyLoss()]-[C.getToxLoss() > 50 ? "\red" : "\blue"][C.getToxLoss()]-[C.getFireLoss() > 50 ? "\red" : "\blue"][C.getFireLoss()]-[C.getBruteLoss() > 50 ? "\red" : "\blue"][C.getBruteLoss()]", 1)
				user.show_message("\blue \t Key: Suffocation/Toxin/Burns/Brute", 1)
				user.show_message("\blue \t Body Temperature: [C.bodytemperature-T0C]&deg;C ([C.bodytemperature*1.8-459.67]&deg;F)", 1)
				if(C.tod && (C.stat == DEAD || (C.status_flags & FAKEDEATH)))
					user.show_message(SPAN_INFO("\t Time of Death: [C.tod]"))
				if(ishuman(C))
					var/mob/living/carbon/human/H = C
					var/list/damaged = H.get_damaged_organs(1, 1)
					user.show_message(SPAN_INFO("Localized Damage, Brute/Burn:"), 1)
					if(length(damaged) > 0)
						for(var/datum/organ/external/org in damaged)
							user.show_message("\blue \t [capitalize(org.display_name)]: [org.brute_dam > 0 ? "\red [org.brute_dam]" : 0]\blue-[org.burn_dam > 0 ? "\red [org.burn_dam]" : 0]", 1)
					else
						user.show_message(SPAN_INFO("\t Limbs are OK."), 1)

				for(var/datum/disease/D in C.viruses)
					if(!D.hidden[SCANNER])
						user.show_message(SPAN_WARNING("<b>Warning: [D.form] Detected</b>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]"))

			if(2)
				if(!istype(C.dna, /datum/dna))
					to_chat(user, SPAN_INFO("No fingerprints found on [C]."))
				else if(ishuman(C))
					var/mob/living/carbon/human/H = C
					if(isnotnull(H.gloves))
						to_chat(user, SPAN_INFO("No fingerprints found on [C]."))
				else
					to_chat(user, SPAN_INFO("[C]'s Fingerprints: [md5(C.dna.uni_identity)]"))
				if(!(C.blood_DNA))
					to_chat(user, SPAN_INFO("No blood found on [C]."))
					if(C.blood_DNA)
						qdel(C.blood_DNA)
				else
					to_chat(user, SPAN_INFO("Blood found on [C]. Analysing..."))
					spawn(15)
						for(var/blood in C.blood_DNA)
							to_chat(user, SPAN_INFO("Blood type: [C.blood_DNA[blood]]\nDNA: [blood]"))

			if(4)
				for(var/mob/O in viewers(C, null))
					O.show_message(SPAN_WARNING("[user] has analysed [C]'s radiation levels!"), 1)

				user.show_message(SPAN_INFO("Analyzing Results for [C]:"))
				if(C.radiation)
					user.show_message(SPAN_ALIUM("Radiation Level:") + "\black [C.radiation]")
				else
					user.show_message(SPAN_INFO("No radiation detected."))

/obj/item/pda/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	switch(scanmode)
		if(3)
			if(!isobj(A))
				return
			if(isnotnull(A.reagents))
				if(length(A.reagents.reagent_list))
					var/reagents_length = length(A.reagents.reagent_list)
					to_chat(user, SPAN_INFO("[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found."))
					for(var/re in A.reagents.reagent_list)
						to_chat(user, SPAN_INFO("\t [re]"))
				else
					to_chat(user, SPAN_INFO("No active chemical agents found in [A]."))
			else
				to_chat(user, SPAN_INFO("No significant chemical agents found in [A]."))

		if(5)
			if(istype(A, /obj/item/tank) || istype(A, /obj/machinery/portable_atmospherics) || istype(A, /obj/machinery/atmospherics/pipe/tank))
				var/obj/icon = A
				user.visible_message(SPAN_WARNING("[user] has used [src] on \icon[icon] [A]."))
				to_chat(user, SPAN_INFO("Results of analysis of \icon[icon]:"))

			if(istype(A, /obj/item/tank))
				var/obj/item/tank/T = A
				var/pressure = T.air_contents.return_pressure()
				var/total_moles = T.air_contents.total_moles

				if(total_moles > 0)
					to_chat(user, SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"))
					var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
					for(var/g in T.air_contents.gas)
						to_chat(user, SPAN_INFO("[gas_data.name[g]]: [round((T.air_contents.gas[g] / total_moles) * 100)]%"))
					to_chat(user, SPAN_INFO("Temperature: [round(T.air_contents.temperature-T0C)]&deg;C"))
				else
					to_chat(user, SPAN_INFO("Tank is empty!"))

			if(istype(A, /obj/machinery/portable_atmospherics))
				var/obj/machinery/portable_atmospherics/P = A
				var/pressure = P.air_contents.return_pressure()
				var/total_moles = P.air_contents.total_moles

				if(total_moles > 0)
					to_chat(user, SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"))
					var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
					for(var/g in P.air_contents.gas)
						to_chat(user, SPAN_INFO("[gas_data.name[g]]: [round((P.air_contents.gas[g] / total_moles) * 100)]%"))
					to_chat(user, SPAN_INFO("Temperature: [round(P.air_contents.temperature-T0C)]&deg;C"))
				else
					to_chat(user, SPAN_INFO("Tank is empty!"))

			if(istype(A, /obj/machinery/atmospherics/pipe/tank))
				var/obj/machinery/atmospherics/pipe/tank/T = A
				var/pressure = T.parent.air.return_pressure()
				var/total_moles = T.parent.air.total_moles

				if(total_moles > 0)
					to_chat(user, SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"))
					var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
					for(var/g in T.parent.air.gas)
						to_chat(user, SPAN_INFO("[gas_data.name[g]]: [round((T.parent.air.gas[g] / total_moles) * 100)]%"))
					to_chat(user, SPAN_INFO("Temperature: [round(T.parent.air.temperature-T0C)]&deg;C"))
				else
					to_chat(user, SPAN_INFO("Tank is empty!"))

	if(!scanmode && owner)
		if(istype(A, /obj/item/paper))
			var/obj/item/paper/P = A
			note = P.info
			to_chat(user, SPAN_INFO("Paper scanned.")) //concept of scanning paper copyright brainoblivion 2009

/obj/item/pda/proc/explode() //This needs tuning. //Sure did.
	if(!src.detonate)
		return
	var/turf/T = GET_TURF(src)
	if(isnotnull(T))
		T.hotspot_expose(700, 125)
		explosion(T, 0, 0, 1, rand(1, 2))
	return

/obj/item/pda/proc/available_pdas()
	var/list/names = list()
	var/list/plist = list()
	var/list/namecounts = list()

	if(toff)
		to_chat(usr, "Turn on your receiver in order to send messages.")
		return

	for_no_type_check(var/obj/item/pda/P, GLOBL.pda_list)
		if(!P.owner)
			continue
		else if(P.hidden)
			continue
		else if(P == src)
			continue
		else if(P.toff)
			continue

		var/name = P.owner
		if(name in names)
			namecounts[name]++
			name = text("[name] ([namecounts[name]])")
		else
			names.Add(name)
			namecounts[name] = 1

		plist[text("[name]")] = P
	return plist

// Access-related overrides.
// These just forward the calls to the inserted ID card if it exists.
/obj/item/pda/get_job_real_name()
	return isnotnull(id) ? id.get_job_real_name() : "Unknown"

/obj/item/pda/get_job_display_name()
	return isnotnull(id) ? id.get_job_display_name() : "Unknown"

/obj/item/pda/get_job_name()
	return isnotnull(id) ? id.get_job_name() : "Unknown"
// End access-related overrides.

// Owner and job helpers.
/obj/item/pda/proc/set_owner(owner)
	src.owner = owner
	update_label()

/obj/item/pda/proc/set_job(job)
	ownjob = job
	update_label()

/obj/item/pda/proc/set_owner_and_job(owner, job)
	set_owner(owner)
	set_job(job)
	update_label()

/obj/item/pda/proc/update_label()
	name = "PDA - [owner] ([ownjob])"
// End owner and job helpers.

//Some spare PDAs in a box
/obj/item/storage/box/PDAs
	name = "spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/items/devices/pda.dmi'
	icon_state = "pdabox"

	starts_with = list(
		/obj/item/pda = 4,
		/obj/item/cartridge/head
	)

/obj/item/storage/box/PDAs/New()
	var/list/cartridges = list(
		/obj/item/cartridge/engineering,
		/obj/item/cartridge/security,
		/obj/item/cartridge/medical,
		/obj/item/cartridge/signal/toxins,
		/obj/item/cartridge/quartermaster
	)
	starts_with.Add(pick(cartridges))
	return ..()

// Pass along the pulse to atoms in contents, largely added so pAIs are vulnerable to EMP
/obj/item/pda/emp_act(severity)
	for_no_type_check(var/atom/movable/mover, src)
		mover.emp_act(severity)