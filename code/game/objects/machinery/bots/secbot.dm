/obj/machinery/bot/secbot
	name = "Securitron"
	desc = "A little security robot. He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "secbot0"
	layer = 5.0
	density = FALSE
	anchored = FALSE
	health = 25
	maxhealth = 25
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
//	weight = 1.0E7
	req_one_access = list(ACCESS_SECURITY, ACCESS_FORENSICS_LOCKERS)

	var/mob/target
	var/oldtarget_name
	var/threatlevel = 0
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
	var/frustration = 0
//	var/emagged = 0 //Emagged Secbots view everyone as a criminal
	var/idcheck = 0 //If false, all station IDs are authorized for weapons.
	var/check_records = 1 //Does it check security records?
	var/arrest_type = 0 //If true, don't handcuff
	var/next_harm_time = 0

	var/mode = 0

	var/auto_patrol = 0		// set to make bot automatically patrol

	var/beacon_freq = 1445		// navigation beacon frequency
	var/control_freq = 1447		// bot control frequency

	var/turf/patrol_target	// this is turf to navigate to (location of beacon)
	var/new_destination		// pending new destination (waiting for beacon response)
	var/destination			// destination description tag
	var/next_destination	// the next destination in the patrol route
	var/list/path = new				// list of path turfs

	var/blockcount = 0		//number of times retried a blocked path
	var/awaiting_beacon	= 0	// count of pticks awaiting a beacon response

	var/nearest_beacon			// the nearest beacon's tag
	var/turf/nearest_beacon_loc	// the nearest beacon's location

/obj/machinery/bot/secbot/beepsky
	name = "Officer Beep O'sky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	idcheck = 0
	auto_patrol = 1

/obj/machinery/bot/secbot/armsky
	name = "Sergeant-at-Armsky"
	desc = "It's Sergeant-at-Armsky! Powered by a potato and a shot of whiskey, protecting the armoury 'til the end of time."
	idcheck = 1
	arrest_type = 1

/obj/machinery/bot/secbot/pingsky
	name = "Officer Pingsky"
	desc = "It's Officer Pingsky! Powered by a potato and a shot of whiskey, protecting the home of its robotic kin."
	idcheck = 1

/obj/machinery/bot/secbot/New()
	. = ..()
	icon_state = "secbot[on]"

/obj/machinery/bot/secbot/initialise()
	. = ..()

	botcard = new /obj/item/card/id(src)
	var/datum/job/detective/J = GLOBL.all_jobs["Detective"]
	botcard.access = J.get_access()

	register_radio(src, null, control_freq, RADIO_SECBOT)
	register_radio(src, null, beacon_freq, RADIO_NAVBEACONS)

/obj/machinery/bot/secbot/Destroy()
	unregister_radio(src, beacon_freq)
	unregister_radio(src, control_freq)
	return ..()

/obj/machinery/bot/secbot/turn_on()
	. = ..()
	icon_state = "secbot[on]"
	updateUsrDialog()

/obj/machinery/bot/secbot/turn_off()
	. = ..()
	target = null
	oldtarget_name = null
	anchored = FALSE
	mode = SECBOT_IDLE
	walk_to(src, 0)
	icon_state = "secbot[on]"
	updateUsrDialog()

/obj/machinery/bot/secbot/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	interact(user)

/obj/machinery/bot/secbot/interact(mob/user as mob)
	var/dat

	dat += {"
<TT><B>Automatic Security Unit v1.3</B></TT><BR><BR>
Status: ["<A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>"]<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel panel is [open ? "opened" : "closed"]"}

	if(!locked || issilicon(user))
		dat += {"<BR>
Check for Weapon Authorisation: ["<A href='?src=\ref[src];operation=idcheck'>[idcheck ? "Yes" : "No"]</A>"]<BR>
Check Security Records: ["<A href='?src=\ref[src];operation=ignorerec'>[check_records ? "Yes" : "No"]</A>"]<BR>
Operating Mode: ["<A href='?src=\ref[src];operation=switchmode'>[arrest_type ? "Detain" : "Arrest"]</A>"]<BR>
Auto Patrol: ["<A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>"]"}

	user << browse("<HEAD><TITLE>Securitron v1.3 controls</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")

/obj/machinery/bot/secbot/Topic(href, href_list)
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["power"] && allowed(usr))
		if(on)
			turn_off()
		else
			turn_on()
		return

	switch(href_list["operation"])
		if("idcheck")
			idcheck = !idcheck
			updateUsrDialog()
		if("ignorerec")
			check_records = !check_records
			updateUsrDialog()
		if("switchmode")
			arrest_type = !arrest_type
			updateUsrDialog()
		if("patrol")
			auto_patrol = !auto_patrol
			mode = SECBOT_IDLE
			updateUsrDialog()

/obj/machinery/bot/secbot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(allowed(user) && !open && !emagged)
			locked = !locked
			to_chat(user, "Controls are now [locked ? "locked" : "unlocked"].")
		else
			if(emagged)
				FEEDBACK_ERROR_GENERIC(user)
			if(open)
				to_chat(user, SPAN_WARNING("Please close the access panel before locking it."))
			else
				FEEDBACK_ACCESS_DENIED(user)
	else
		..()
		if(!istype(W, /obj/item/screwdriver) && W.force && !target)
			target = user
			mode = SECBOT_HUNT

/obj/machinery/bot/secbot/Emag(mob/user as mob)
	..()
	if(open && !locked)
		if(isnotnull(user))
			to_chat(user, SPAN_WARNING("You short out [src]'s target assessment circuits."))
		spawn(0)
			for(var/mob/O in hearers(src, null))
				O.show_message(SPAN_DANGER("[src] buzzes oddly!"), 1)
		target = null
		if(isnotnull(user))
			oldtarget_name = user.name
		last_found = world.time
		anchored = FALSE
		emagged = 2
		on = TRUE
		icon_state = "secbot[on]"
		mode = SECBOT_IDLE

/obj/machinery/bot/secbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return

	switch(mode)
		if(SECBOT_IDLE)		// idle
			walk_to(src, 0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = SECBOT_START_PATROL	// switch to patrol mode

		if(SECBOT_HUNT)		// hunting for perp
			// if can't reach perp for long enough, go idle
			if(frustration >= 8)
		//		for(var/mob/O in hearers(src, null))
		//			O << "<span class='game say'><span class='name'>[src]</span> beeps, \"Backup requested! Suspect has evaded arrest.\""
				target = null
				last_found = world.time
				frustration = 0
				mode = 0
				walk_to(src, 0)

			if(target)		// make sure target exists
				if(get_dist(src, target) <= 1 && isturf(target.loc))		// if right next to perp
					if(iscarbon(target))
						playsound(src, 'sound/weapons/Egloves.ogg', 50, 1, -1)
						icon_state = "secbot-c"
						spawn(2)
							icon_state = "secbot[on]"
						var/mob/living/carbon/M = target
						var/maxstuns = 4
						if(ishuman(M))
							if(M.stuttering < 10 && (!(HULK in M.mutations)))
								M.stuttering = 10
							M.Stun(10)
							M.Weaken(10)
						else
							M.Weaken(10)
							M.stuttering = 10
							M.Stun(10)
						maxstuns--
						if(maxstuns <= 0)
							target = null
						visible_message(SPAN_DANGER("[target] has been stunned by [src]!"))

						mode = SECBOT_PREP_ARREST
						anchored = TRUE
						target_lastloc = M.loc
						return

					else if(isanimal(target))
						//just harmbaton them until dead
						if(world.time > next_harm_time)
							next_harm_time = world.time + 15
							playsound(src, 'sound/weapons/Egloves.ogg', 50, 1, -1)
							visible_message(SPAN_DANGER("[src] beats [target] with the stun baton!"))
							icon_state = "secbot-c"
							spawn(2)
								icon_state = "secbot[on]"

							var/mob/living/simple_animal/S = target
							S.AdjustStunned(10)
							S.adjustBruteLoss(15)
							if(S.stat)
								frustration = 8
								playsound(src, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/bcreep.ogg'), 50, 0)

				else								// not next to perp
					var/turf/olddist = get_dist(src, target)
					walk_to(src, target, 1, 4)
					if((get_dist(src, target)) >= (olddist))
						frustration++
					else
						frustration = 0
			else
				frustration = 8

		if(SECBOT_PREP_ARREST)		// preparing to arrest target
			// see if he got away
			if((get_dist(src, target) > 1) || ((target:loc != target_lastloc) && target:weakened < 2))
				anchored = FALSE
				mode = SECBOT_HUNT
				return

			if(iscarbon(target))
				var/mob/living/carbon/C = target
				if(!C.handcuffed && !arrest_type)
					playsound(src, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					mode = SECBOT_ARREST
					visible_message(SPAN_DANGER("[src] is trying to put handcuffs on [target]!"))

					spawn(60)
						if(get_dist(src, target) <= 1)
							/*if(target.handcuffed)
								return*/

							if(iscarbon(target))
								C = target
								if(!C.handcuffed)
									C.handcuffed = new /obj/item/handcuffs(target)
									C.update_inv_handcuffed()	//update the handcuffs overlay

							mode = SECBOT_IDLE
							target = null
							anchored = FALSE
							last_found = world.time
							frustration = 0

							// No expletive laden voice line please and thank you. -Frenjo
							playsound(src, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg'/*, 'sound/voice/binsult.ogg'*/, 'sound/voice/bcreep.ogg'), 50, 0)
		//					var/arrest_message = pick("Have a secure day!","I AM THE LAW.", "God made tomorrow for the crooks we don't catch today.","You can't outrun a radio.")
		//					speak(arrest_message)

			else
				mode = SECBOT_IDLE
				target = null
				anchored = FALSE
				last_found = world.time
				frustration = 0

		if(SECBOT_ARREST)		// arresting
			if(!target || !iscarbon(target))
				anchored = FALSE
				mode = SECBOT_IDLE
				return
			else
				var/mob/living/carbon/C = target
				if(!C.handcuffed)
					anchored = FALSE
					mode = SECBOT_IDLE
					return

		if(SECBOT_START_PATROL)	// start a patrol
			if(length(path) && patrol_target)	// have a valid path, so just resume
				mode = SECBOT_PATROL
				return

			else if(patrol_target)		// has patrol target already
				spawn(0)
					calc_path()		// so just find a route to it
					if(!length(path))
						patrol_target = 0
						return
					mode = SECBOT_PATROL

			else					// no patrol target, so need a new one
				find_patrol_target()
				speak("Engaging patrol mode.")

		if(SECBOT_PATROL)		// patrol mode
			patrol_step()
			spawn(5)
				if(mode == SECBOT_PATROL)
					patrol_step()

		if(SECBOT_SUMMON)		// summoned to PDA
			patrol_step()
			spawn(4)
				if(mode == SECBOT_SUMMON)
					patrol_step()
					sleep(4)
					patrol_step()


// perform a single patrol step
/obj/machinery/bot/secbot/proc/patrol_step()
	if(loc == patrol_target)		// reached target
		at_patrol_target()
		return

	else if(length(path) && patrol_target)		// valid path
		var/turf/next = path[1]
		if(next == loc)
			path -= next
			return

		if(issimulated(next))
			var/moved = step_towards(src, next)	// attempt to move
			if(moved)	// successful move
				blockcount = 0
				path -= loc

				look_for_perp()
			else		// failed to move

				blockcount++

				if(blockcount > 5)	// attempt 5 times before recomputing
					// find new path excluding blocked turf

					spawn(2)
						calc_path(next)
						if(!length(path))
							find_patrol_target()
						else
							blockcount = 0
					return
				return
		else	// not a valid turf
			mode = SECBOT_IDLE
			return
	else	// no path, so calculate new one
		mode = SECBOT_START_PATROL

// finds a new patrol target
/obj/machinery/bot/secbot/proc/find_patrol_target()
	send_status()
	if(awaiting_beacon)			// awaiting beacon response
		awaiting_beacon++
		if(awaiting_beacon > 5)	// wait 5 secs for beacon response
			find_nearest_beacon()	// then go to nearest instead
		return

	if(next_destination)
		set_destination(next_destination)
	else
		find_nearest_beacon()

// finds the nearest beacon to self
// signals all beacons matching the patrol code
/obj/machinery/bot/secbot/proc/find_nearest_beacon()
	nearest_beacon = null
	new_destination = "__nearest__"
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1
	spawn(10)
		awaiting_beacon = 0
		if(nearest_beacon)
			set_destination(nearest_beacon)
		else
			auto_patrol = 0
			mode = SECBOT_IDLE
			speak("Disengaging patrol mode.")
			send_status()

/obj/machinery/bot/secbot/proc/at_patrol_target()
	find_patrol_target()
	return

// sets the current destination
// signals all beacons matching the patrol code
// beacons will return a signal giving their locations
/obj/machinery/bot/secbot/proc/set_destination(new_dest)
	new_destination = new_dest
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1

// receive a radio signal
// used for beacon reception
/obj/machinery/bot/secbot/receive_signal(datum/signal/signal)
	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/bot/secbot/receive_signal([signal.debug_print()])")
	if(!on)
		return

	/*
	to_world("rec signal: [signal.source]")
	for(var/x in signal.data)
		to_world("* [x] = [signal.data[x]]")
	*/

	var/recv = signal.data["command"]
	// process all-bot input
	if(recv == "bot_status")
		send_status()

	// check to see if we are the commanded bot
	if(signal.data["active"] == src)
	// process control input
		switch(recv)
			if("stop")
				mode = SECBOT_IDLE
				auto_patrol = 0
				return

			if("go")
				mode = SECBOT_IDLE
				auto_patrol = 1
				return

			if("summon")
				patrol_target = signal.data["target"]
				next_destination = destination
				destination = null
				awaiting_beacon = 0
				mode = SECBOT_SUMMON
				calc_path()
				speak("Responding.")
				return

	// receive response from beacon
	recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid)
		return

	if(recv == new_destination)	// if the recvd beacon location matches the set destination
								// the we will navigate there
		destination = new_destination
		patrol_target = signal.source.loc
		next_destination = signal.data["next_patrol"]
		awaiting_beacon = 0

	// if looking for nearest beacon
	else if(new_destination == "__nearest__")
		var/dist = get_dist(src, signal.source.loc)
		if(nearest_beacon)

			// note we ignore the beacon we are located at
			if(dist > 1 && dist < get_dist(src, nearest_beacon_loc))
				nearest_beacon = recv
				nearest_beacon_loc = signal.source.loc
				return
			else
				return
		else if(dist > 1)
			nearest_beacon = recv
			nearest_beacon_loc = signal.source.loc

// send a radio signal with a single data key/value pair
/obj/machinery/bot/secbot/proc/post_signal(freq, key, value)
	post_signal_multiple(freq, list("[key]" = value))

// send a radio signal with multiple data key/values
/obj/machinery/bot/secbot/proc/post_signal_multiple(freq, list/keyval)
	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(freq)

	if(!frequency)
		return

	var/datum/signal/signal = new /datum/signal()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	//for(var/key in keyval)
	//	signal.data[key] = keyval[key]
	signal.data = keyval
		//to_world("sent [key],[keyval[key]] on [freq]")
	if(signal.data["findbeacon"])
		frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
	else if(signal.data["type"] == "secbot")
		frequency.post_signal(src, signal, filter = RADIO_SECBOT)
	else
		frequency.post_signal(src, signal)

// signals bot status etc. to controller
/obj/machinery/bot/secbot/proc/send_status()
	var/list/kv = list(
		"type" = "secbot",
		"name" = name,
		"loca" = loc.loc,	// area
		"mode" = mode
	)
	post_signal_multiple(control_freq, kv)

// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/secbot/proc/calc_path(turf/avoid = null)
	path = AStar(loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id = botcard, exclude = avoid)
	if(!path)
		path = list()

// look for a criminal in view of the bot
/obj/machinery/bot/secbot/proc/look_for_perp()
	anchored = FALSE
	for(var/mob/living/M in view(7, src)) //Let's find us a criminal
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.stat || C.handcuffed)
				continue

			if(C.name == oldtarget_name && (world.time < last_found + 100))
				continue

			if(ishuman(C))
				threatlevel = assess_perp(C)
			else if(idcheck && ismonkey(C))
				threatlevel = 4

		else if(istype(M, /mob/living/simple_animal/hostile))
			if(M.stat == DEAD)
				continue
			else
				threatlevel = 4

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = M
			oldtarget_name = M.name
			speak("Level [threatlevel] infraction alert!")
			playsound(src, pick('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg'), 50, 0)
			visible_message("<b>[src]</b> points at [M.name]!")
			mode = SECBOT_HUNT
			spawn(0)
				process()	// ensure bot quickly responds to a perp
			break
		else
			continue

//If the security records say to arrest them, arrest them
//Or if they have weapons and aren't security, arrest them.
/obj/machinery/bot/secbot/proc/assess_perp(mob/living/carbon/human/perp as mob)
	var/threatcount = 0

	if(emagged == 2)
		return 10 //Everyone is a criminal!

	if(idcheck && !allowed(perp))
		if(istype(perp.l_hand, /obj/item/gun) || istype(perp.l_hand, /obj/item/melee))
			if(!istype(perp.l_hand, /obj/item/gun/energy/laser/tag/blue) \
			&& !istype(perp.l_hand, /obj/item/gun/energy/laser/tag/red) \
			&& !istype(perp.l_hand, /obj/item/gun/energy/laser/practice))
				threatcount += 4

		if(istype(perp.r_hand, /obj/item/gun) || istype(perp.r_hand, /obj/item/melee))
			if(!istype(perp.r_hand, /obj/item/gun/energy/laser/tag/blue) \
			&& !istype(perp.r_hand, /obj/item/gun/energy/laser/tag/red) \
			&& !istype(perp.r_hand, /obj/item/gun/energy/laser/practice))
				threatcount += 4

		if(istype(perp:belt, /obj/item/gun) || istype(perp:belt, /obj/item/melee))
			if(!istype(perp:belt, /obj/item/gun/energy/laser/tag/blue) \
			&& !istype(perp:belt, /obj/item/gun/energy/laser/tag/red) \
			&& !istype(perp:belt, /obj/item/gun/energy/laser/practice))
				threatcount += 2

		if(istype(perp:wear_suit, /obj/item/clothing/suit/wizrobe))
			threatcount += 2

		if(perp.dna && perp.dna.mutantrace && perp.dna.mutantrace != "none")
			threatcount += 2

		//Agent cards lower threatlevel.
		if(istype(perp.wear_id?.get_id(), /obj/item/card/id/syndicate))
			threatcount -= 2

	if(check_records)
		for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
			var/perpname = perp.name
			if(isnotnull(perp.wear_id))
				var/obj/item/card/id/id = perp.wear_id.get_id()
				if(isnotnull(id))
					perpname = id.registered_name

			if(E.fields["name"] == perpname)
				for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						threatcount = 4
						break

	return threatcount

/obj/machinery/bot/secbot/Bump(M as mob|obj) //Leave no door unopened!
	if((istype(M, /obj/machinery/door)) && (isnotnull(botcard)))
		var/obj/machinery/door/D = M
		if(!istype(D, /obj/machinery/door/firedoor) && D.check_access(botcard))
			D.open()
			frustration = 0
	else if(isliving(M) && !anchored)
		loc = M:loc
		frustration = 0

/* terrible
/obj/machinery/bot/secbot/Bumped(atom/movable/M as mob|obj)
	spawn(0)
		if(M)
			var/turf/T = get_turf(src)
			M:loc = T
*/

/obj/machinery/bot/secbot/proc/speak(message)
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"",2)

/obj/machinery/bot/secbot/explode()
	walk_to(src, 0)
	visible_message(SPAN_DANGER("[src] blows apart!"), 1)
	var/turf/T = get_turf(src)

	var/obj/item/secbot_assembly/Sa = new /obj/item/secbot_assembly(T)
	Sa.build_step = 1
	Sa.overlays.Add(image('icons/obj/aibots.dmi', "hs_hole"))
	Sa.created_name = name
	new /obj/item/assembly/prox_sensor(T)

	//var/obj/item/melee/baton/B = new /obj/item/melee/baton(T)
	//B.charges = 0
	new /obj/item/melee/baton(T)

	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)

	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(loc)
	return ..()

// Secbot Assembly
/obj/item/clothing/head/helmet/attackby(obj/item/assembly/signaler/S, mob/user as mob)
	. = ..()
	if(!issignaler(S))
		return .

	if(type != /obj/item/clothing/head/helmet) //Eh, but we don't want people making secbots out of space helmets.
		return

	if(S.secured)
		qdel(S)
		var/obj/item/secbot_assembly/assembly = new /obj/item/secbot_assembly()
		user.put_in_hands(assembly)
		to_chat(user, SPAN_INFO("You add the signaler to the helmet."))
		user.drop_from_inventory(src)
		qdel(src)
		return

/obj/item/secbot_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"

	var/build_step = 0
	var/created_name = "Securitron" // To preserve the name if it's a unique securitron I guess

/obj/item/secbot_assembly/attackby(obj/item/W as obj, mob/user as mob)
	. = ..()
	if(istype(W, /obj/item/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name), 1, MAX_NAME_LEN)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
		return

	if(istype(W, /obj/item/weldingtool) && !build_step)
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			build_step++
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			overlays.Add(image('icons/obj/aibots.dmi', "hs_hole"))
			to_chat(user, SPAN_INFO("You weld a hole in [src]!"))
		return

	if(isprox(W) && build_step == 1)
		user.drop_item()
		build_step++
		name = "helmet/signaler/prox sensor assembly"
		overlays.Add(image('icons/obj/aibots.dmi', "hs_eye"))
		to_chat(user, SPAN_INFO("You add the prox sensor to [src]!"))
		qdel(W)
		return

	if((istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm)) && build_step == 2)
		user.drop_item()
		build_step++
		name = "helmet/signaler/prox sensor/robot arm assembly"
		overlays.Add(image('icons/obj/aibots.dmi', "hs_arm"))
		to_chat(user, SPAN_INFO("You add the robot arm to [src]!"))
		qdel(W)
		return

	if(istype(W, /obj/item/melee/baton) && build_step >= 3)
		user.drop_item()
		build_step++
		var/obj/machinery/bot/secbot/bot = new /obj/machinery/bot/secbot(get_turf(src))
		bot.name = created_name
		to_chat(user, SPAN_INFO("You complete the Securitron! Beep boop."))
		qdel(W)
		qdel(src)
		return