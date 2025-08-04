/obj/machinery/bot/ed209
	name = "\improper ED-209 security robot"
	desc = "A security robot. He looks less than thrilled."
	icon = 'icons/mob/bot/ed209.dmi'
	icon_state = "ed2090"
	layer = 5.0
	density = TRUE
	anchored = FALSE
//	weight = 1.0E7
	req_one_access = list(ACCESS_SECURITY, ACCESS_FORENSICS_LOCKERS)
	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5

	var/lastfired = 0
	var/shot_delay = 3 //.3 seconds between shots
	var/lasercolor = ""
	var/disabled = FALSE //A holder for if it needs to be disabled, if true it will not seach for targets, shoot at targets, or move, currently only used for lasertag

	//var/lasers = 0

	var/mob/living/carbon/target
	var/oldtarget_name
	var/threatlevel = 0
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
	var/frustration = 0
//var/emagged = 0 //Emagged Secbots view everyone as a criminal
	var/idcheck = TRUE //If false, all station IDs are authorized for weapons.
	var/check_records = TRUE //Does it check security records?
	var/arrest_type = 0 //If true, don't handcuff
	var/projectile = null//Holder for projectile type, to avoid so many else if chains

	var/mode = 0

	var/auto_patrol = FALSE	// set to make bot automatically patrol

	var/beacon_freq = 1445		// navigation beacon frequency
	var/control_freq = 1447		// bot control frequency


	var/turf/patrol_target	// this is turf to navigate to (location of beacon)
	var/new_destination		// pending new destination (waiting for beacon response)
	var/destination			// destination description tag
	var/next_destination	// the next destination in the patrol route
	var/list/path = list()	// list of path turfs

	var/blockcount = 0		//number of times retried a blocked path
	var/awaiting_beacon	= 0	// count of pticks awaiting a beacon response

	var/nearest_beacon			// the nearest beacon's tag
	var/turf/nearest_beacon_loc	// the nearest beacon's location

/obj/machinery/bot/ed209/New(loc, created_name, created_lasercolor)
	. = ..()
	if(created_name)
		name = created_name
	if(created_lasercolor)
		lasercolor = created_lasercolor
	icon_state = "[lasercolor]ed209[on]"

/obj/machinery/bot/ed209/initialise()
	. = ..()

	botcard = new /obj/item/card/id(src)
	var/datum/job/detective/J = GLOBL.all_jobs["Detective"]
	botcard.access = J.get_access()

	register_radio(src, null, control_freq, RADIO_SECBOT)
	register_radio(src, null, beacon_freq, RADIO_NAVBEACONS)
	if(lasercolor)
		shot_delay = 6//Longer shot delay because JESUS CHRIST
		check_records = 0//Don't actively target people set to arrest
		arrest_type = 1//Don't even try to cuff
		req_access = list(ACCESS_MAINT_TUNNELS)
		arrest_type = 1
		if(lasercolor == "b" && name == "ED-209 Security Robot")//Picks a name if there isn't already a custome one
			name = pick("BLUE BALLER", "SANIC", "BLUE KILLDEATH MURDERBOT")
		if(lasercolor == "r" && name == "ED-209 Security Robot")
			name = pick("RED RAMPAGE", "RED ROVER", "RED KILLDEATH MURDERBOT")

/obj/machinery/bot/ed209/turn_on()
	. = ..()
	icon_state = "[lasercolor]ed209[on]"
	mode = SECBOT_IDLE
	updateUsrDialog()

/obj/machinery/bot/ed209/turn_off()
	. = ..()
	target = null
	oldtarget_name = null
	anchored = FALSE
	mode = SECBOT_IDLE
	walk_to(src, 0)
	icon_state = "[lasercolor]ed209[on]"
	updateUsrDialog()

/obj/machinery/bot/ed209/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	var/dat

	dat += {"
<TT><B>Automatic Security Unit v2.5</B></TT><BR><BR>
Status: ["<A href='byond://?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>"]<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel panel is [open ? "opened" : "closed"]"}

	if(!locked || issilicon(user))
		if(!lasercolor)
			dat += {"<BR>
Check for Weapon Authorisation: ["<A href='byond://?src=\ref[src];operation=idcheck'>[idcheck ? "Yes" : "No"]</A>"]<BR>
Check Security Records: ["<A href='byond://?src=\ref[src];operation=ignorerec'>[check_records ? "Yes" : "No"]</A>"]<BR>
Operating Mode: ["<A href='byond://?src=\ref[src];operation=switchmode'>[arrest_type ? "Detain" : "Arrest"]</A>"]<BR>
Auto Patrol: ["<A href='byond://?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>"]"}
		else
			dat += {"<BR>
Auto Patrol: ["<A href='byond://?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>"]"}

	SHOW_BROWSER(user, "<HEAD><TITLE>Securitron v2.5 controls</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")

/obj/machinery/bot/ed209/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(lasercolor && ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(lasercolor == "b" && istype(H.wear_suit, /obj/item/clothing/suit/laser_tag/red))//Opposing team cannot operate it
			return
		else if(lasercolor == "r" && istype(H.wear_suit, /obj/item/clothing/suit/laser_tag/blue))
			return
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

/obj/machinery/bot/ed209/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(allowed(user) && !open && !emagged)
			locked = !locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		else
			if(emagged)
				FEEDBACK_ERROR_GENERIC(user)
			if(open)
				to_chat(user, SPAN_WARNING("Please close the access panel before locking it."))
			else
				FEEDBACK_ACCESS_DENIED(user)
	else
		..()
		if(!isscrewdriver(W) && (!target))
			if(hasvar(W, "force") && W.force)//If force is defined and non-zero
				target = user
				if(lasercolor)//To make up for the fact that lasertag bots don't hunt
					shootAt(user)
				mode = SECBOT_HUNT

/obj/machinery/bot/ed209/Emag(mob/user)
	. = ..()
	if(open && !locked)
		if(isnotnull(user))
			to_chat(user, SPAN_WARNING("You short out \the [src]'s target assessment circuits."))
		spawn(0)
			for(var/mob/O in hearers(src, null))
				O.show_message(SPAN_DANGER("[src] buzzes oddly!"), 1)
		target = null
		if(user)
			oldtarget_name = user.name
		last_found = world.time
		anchored = FALSE
		emagged = 2
		on = TRUE
		icon_state = "[lasercolor]ed209[on]"
		projectile = null
		mode = SECBOT_IDLE

/obj/machinery/bot/ed209/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return

	var/list/targets = list()
	for(var/mob/living/carbon/C in view(12, src)) //Let's find us a target
		var/threatlevel = 0
		if(C.stat || C.lying)
			continue
		if(ishuman(C))
			threatlevel = assess_perp(C)
		else if(ismonkey(C) && isnotnull(C.client) && IS_GAME_MODE(/datum/game_mode/monkey))
			threatlevel = 4
		//speak(C.real_name + text(": threat: []", threatlevel))
		if(threatlevel < 4)
			continue

		var/dst = get_dist(src, C)
		if(dst <= 1 || dst > 12)
			continue

		targets.Add(C)
	if(length(targets))
		var/mob/t = pick(targets)
		if(isliving(t))
			if(t.stat != 2 && t.lying != 1)
				//speak("selected target: " + t.real_name)
				shootAt(t)
	switch(mode)

		if(SECBOT_IDLE)		// idle
			walk_to(src, 0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = SECBOT_START_PATROL	// switch to patrol mode

		if(SECBOT_HUNT)		// hunting for perp
			if(lasercolor)//Lasertag bots do not tase or arrest anyone, just patrol and shoot and whatnot
				mode = SECBOT_IDLE
				return
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
				if(get_dist(src, target) <= 1)		// if right next to perp
					playsound(src, 'sound/weapons/melee/egloves.ogg', 50, 1, -1)
					icon_state = "[lasercolor]ed209-c"
					spawn(2)
						icon_state = "[lasercolor]ed209[on]"
					var/mob/living/carbon/M = target
					var/maxstuns = 4
					if(ishuman(M))
						if(M.stuttering < 10 && (!(MUTATION_HULK in M.mutations))  /*&& (!istype(M:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
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

				else								// not next to perp
					var/turf/olddist = get_dist(src, target)
					walk_to(src, target, 1, 4)
					if(get_dist(src, target) >= olddist)
						frustration++
					else
						frustration = 0

		if(SECBOT_PREP_ARREST)		// preparing to arrest target
			if(lasercolor)
				mode = SECBOT_IDLE
				return
			if(!target)
				mode = SECBOT_IDLE
				anchored = FALSE
				return
			// see if he got away
			if((get_dist(src, target) > 1) || ((target:loc != target_lastloc) && target:weakened < 2))
				anchored = FALSE
				mode = SECBOT_HUNT
				return

			if(iscarbon(target))
				if(!target.handcuffed && !arrest_type)
					playsound(src, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					mode = SECBOT_ARREST
					visible_message(SPAN_DANGER("[src] is trying to put handcuffs on [target]!"))

					spawn(60)
						if(get_dist(src, target) <= 1)
							if(target.handcuffed)
								return

							if(iscarbon(target))
								target.handcuffed = new /obj/item/handcuffs(target)
								target.update_inv_handcuffed()	//update handcuff overlays

							mode = SECBOT_IDLE
							target = null
							anchored = FALSE
							last_found = world.time
							frustration = 0

		//					playsound(loc, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg'), 50, 0)
		//					var/arrest_message = pick("Have a secure day!","I AM THE LAW.", "God made tomorrow for the crooks we don't catch today.","You can't outrun a radio.")
		//					speak(arrest_message)
			else
				mode = SECBOT_IDLE
				target = null
				anchored = FALSE
				last_found = world.time
				frustration = 0

		if(SECBOT_ARREST)		// arresting
			if(lasercolor)
				mode = SECBOT_IDLE
				return
			if(!target || target.handcuffed)
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
/obj/machinery/bot/ed209/proc/patrol_step()
	if(loc == patrol_target)		// reached target
		at_patrol_target()
		return

	else if(length(path) && patrol_target)		// valid path
		var/turf/next = path[1]
		if(next == loc)
			path -= next
			return

		if(isopenturf(next))
			var/moved = step_towards(src, next)	// attempt to move
			if(moved)	// successful move
				blockcount = 0
				path -= loc

				look_for_perp()
				if(lasercolor)
					sleep(20)
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
/obj/machinery/bot/ed209/proc/find_patrol_target()
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
/obj/machinery/bot/ed209/proc/find_nearest_beacon()
	nearest_beacon = null
	new_destination = "__nearest__"
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1
	spawn(10)
		awaiting_beacon = 0
		if(nearest_beacon)
			set_destination(nearest_beacon)
		else
			auto_patrol = FALSE
			mode = SECBOT_IDLE
			speak("Disengaging patrol mode.")
			send_status()

/obj/machinery/bot/ed209/proc/at_patrol_target()
	find_patrol_target()
	return

// sets the current destination
// signals all beacons matching the patrol code
// beacons will return a signal giving their locations
/obj/machinery/bot/ed209/proc/set_destination(new_dest)
	new_destination = new_dest
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1

// receive a radio signal
// used for beacon reception
/obj/machinery/bot/ed209/receive_signal(datum/signal/signal)
	if(!..())
		return
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
				auto_patrol = FALSE
				return

			if("go")
				mode = SECBOT_IDLE
				auto_patrol = TRUE
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
		var/dist = get_dist(src,signal.source.loc)
		if(nearest_beacon)

			// note we ignore the beacon we are located at
			if(dist > 1 && dist<get_dist(src, nearest_beacon_loc))
				nearest_beacon = recv
				nearest_beacon_loc = signal.source.loc
				return
			else
				return
		else if(dist > 1)
			nearest_beacon = recv
			nearest_beacon_loc = signal.source.loc

// send a radio signal with a single data key/value pair
/obj/machinery/bot/ed209/proc/post_signal(freq, key, value)
	post_signal_multiple(freq, list("[key]" = value) )

// send a radio signal with multiple data key/values
/obj/machinery/bot/ed209/proc/post_signal_multiple(freq, list/keyval)
	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(freq)

	if(isnull(frequency))
		return

	var/datum/signal/signal = new /datum/signal()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	//for(var/key in keyval)
	//	signal.data[key] = keyval[key]
		//to_world("sent [key],[keyval[key]] on [freq]")
	signal.data = keyval
	if(signal.data["findbeacon"])
		frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
	else if(signal.data["type"] == "secbot")
		frequency.post_signal(src, signal, filter = RADIO_SECBOT)
	else
		frequency.post_signal(src, signal)

// signals bot status etc. to controller
/obj/machinery/bot/ed209/proc/send_status()
	var/list/kv = list(
		"type" = "secbot",
		"name" = name,
		"loca" = loc.loc,	// area
		"mode" = mode,
	)
	post_signal_multiple(control_freq, kv)

// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/ed209/proc/calc_path(turf/avoid = null)
	path = AStar(loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id = botcard, exclude = avoid)
	LAZYINITLIST(path)

// look for a criminal in view of the bot
/obj/machinery/bot/ed209/proc/look_for_perp()
	if(disabled)
		return
	anchored = FALSE
	threatlevel = 0
	for(var/mob/living/carbon/C in view(12, src)) //Let's find us a criminal
		if(C.stat || C.handcuffed)
			continue

		if(lasercolor && C.lying)
			continue//Does not shoot at people lyind down when in lasertag mode, because it's just annoying, and they can fire once they get up.

		if(C.name == oldtarget_name && (world.time < last_found + 100))
			continue

		if(ishuman(C))
			threatlevel = assess_perp(C)
		else if(ismonkey(C) && C.client && IS_GAME_MODE(/datum/game_mode/monkey))
			threatlevel = 4

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			speak("Level [threatlevel] infraction alert!")
			if(!lasercolor)
				playsound(src, pick('sound/voice/ed209_20sec.ogg', 'sound/voice/EDPlaceholder.ogg'), 50, 0)
			visible_message("<b>[src]</b> points at [C.name]!")
			mode = SECBOT_HUNT
			spawn(0)
				process()	// ensure bot quickly responds to a perp
			break
		else
			continue

//If the security records say to arrest them, arrest them
//Or if they have weapons and aren't security, arrest them.
/obj/machinery/bot/ed209/proc/assess_perp(mob/living/carbon/human/perp)
	var/threatcount = 0

	if(emagged == 2)
		return 10 //Everyone is a criminal!

	if(idcheck || isnull(perp.id_store) || istype(perp.id_store.get_id(), /obj/item/card/id/syndicate))
		if((istype(perp.l_hand, /obj/item/gun) && !istype(perp.l_hand, /obj/item/gun/projectile/shotgun)) || istype(perp.l_hand, /obj/item/melee/baton))
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

//Agent cards lower threatlevel when normal idchecking is off.
		if(istype(perp.id_store?.get_id(), /obj/item/card/id/syndicate) && idcheck)
			threatcount -= 2

	if(lasercolor == "b")//Lasertag turrets target the opposing team, how great is that? -Sieve
		threatcount = 0//They will not, however shoot at people who have guns, because it gets really fucking annoying
		if(istype(perp.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			threatcount += 4
		if((istype(perp:r_hand,/obj/item/gun/energy/laser/tag/red)) || (istype(perp:l_hand,/obj/item/gun/energy/laser/tag/red)))
			threatcount += 4
		if(istype(perp:belt, /obj/item/gun/energy/laser/tag/red))
			threatcount += 2

	if(lasercolor == "r")
		threatcount = 0
		if(istype(perp.wear_suit, /obj/item/clothing/suit/laser_tag/blue))
			threatcount += 4
		if((istype(perp:r_hand,/obj/item/gun/energy/laser/tag/blue)) || (istype(perp:l_hand,/obj/item/gun/energy/laser/tag/blue)))
			threatcount += 4
		if(istype(perp:belt, /obj/item/gun/energy/laser/tag/blue))
			threatcount += 2

	if(check_records)
		for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
			var/perpname = perp.name
			if(isnotnull(perp.id_store))
				var/obj/item/card/id/id = perp.id_store.get_id()
				if(isnotnull(id))
					perpname = id.registered_name

			if(E.fields["name"] == perpname)
				for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						threatcount = 4
						break

	if(idcheck && allowed(perp) && !lasercolor)
		threatcount = 0//Corrupt cops cannot exist beep boop

	return threatcount

/obj/machinery/bot/ed209/Bump(atom/M) //Leave no door unopened!
	if(istype(M, /obj/machinery/door) && isnotnull(botcard))
		var/obj/machinery/door/D = M
		if(!istype(D, /obj/machinery/door/firedoor) && D.check_access(botcard))
			D.open()
			frustration = 0
	else if(isliving(M) && !anchored)
		loc = M:loc
		frustration = 0

/* terrible
/obj/machinery/bot/ed209/Bumped(atom/movable/M)
	spawn(0)
		if(M)
			var/turf/T = GET_TURF(src)
			M:loc = T
*/

/obj/machinery/bot/ed209/proc/speak(message)
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"",2)

/obj/machinery/bot/ed209/explode()
	walk_to(src, 0)
	visible_message(SPAN_DANGER("[src] blows apart!"), 1)

	var/turf/T = GET_TURF(src)
	var/obj/item/ed209_assembly/Sa = new /obj/item/ed209_assembly(T)
	Sa.build_step = 1
	Sa.add_overlay("hs_hole")
	Sa.created_name = name
	new /obj/item/assembly/prox_sensor(T)

	if(!lasercolor)
		var/obj/item/gun/energy/taser/G = new /obj/item/gun/energy/taser(T)
		G.power_supply.charge = 0
	else if(lasercolor == "b")
		var/obj/item/gun/energy/laser/tag/blue/G = new /obj/item/gun/energy/laser/tag/blue(T)
		G.power_supply.charge = 0
	else if(lasercolor == "r")
		var/obj/item/gun/energy/laser/tag/red/G = new /obj/item/gun/energy/laser/tag/red(T)
		G.power_supply.charge = 0

	if(prob(50))
		new /obj/item/robot_part/l_leg(T)
		if(prob(25))
			new /obj/item/robot_part/r_leg(T)
	if(prob(25))//50% chance for a helmet OR vest
		if(prob(50))
			new /obj/item/clothing/head/helmet(T)
		else
			if(!lasercolor)
				new /obj/item/clothing/suit/armor/vest(T)
			if(lasercolor == "b")
				new /obj/item/clothing/suit/laser_tag/blue(T)
			if(lasercolor == "r")
				new /obj/item/clothing/suit/laser_tag/red(T)

	make_sparks(3, TRUE, src)

	new /obj/effect/decal/cleanable/blood/oil(loc)
	return ..()

/obj/machinery/bot/ed209/proc/shootAt(mob/target)
	if(lastfired && world.time - lastfired < shot_delay)
		return
	lastfired = world.time
	var/turf/T = loc
	var/atom/U = (ismovable(target) ? target.loc : target)
	if(!U || !T)
		return
	while(!isturf(U))
		U = U.loc
	if(!isturf(T))
		return

	//if(lastfired && world.time - lastfired < 100)
	//	playsound(loc, 'ed209_shoot.ogg', 50, 0)

	if(!projectile)
		if(!lasercolor)
			if(emagged == 2)
				projectile = /obj/item/projectile/energy/beam/laser
			else
				projectile = /obj/item/projectile/energy/electrode
		else if(lasercolor == "b")
			if(emagged == 2)
				projectile = /obj/item/projectile/energy/beam/laser/tag/omni
			else
				projectile = /obj/item/projectile/energy/beam/laser/tag/blue
		else if(lasercolor == "r")
			if(emagged == 2)
				projectile = /obj/item/projectile/energy/beam/laser/tag/omni
			else
				projectile = /obj/item/projectile/energy/beam/laser/tag/red

	if(!isturf(U))
		return
	var/obj/item/projectile/A = new projectile(loc)
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn(0)
		A.process()
		return

/obj/machinery/bot/ed209/emp_act(severity)
	if(severity == 2 && prob(70))
		..(severity - 1)
	else
		var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = TRUE
		pulse2.set_dir(pick(GLOBL.cardinal))
		spawn(10)
			qdel(pulse2)
		var/list/mob/living/carbon/targets = list()
		for(var/mob/living/carbon/C in view(12, src))
			if(C.stat == DEAD)
				continue
			targets.Add(C)
		if(length(targets))
			if(prob(50))
				var/mob/toshoot = pick(targets)
				if(toshoot)
					targets -= toshoot
					if(prob(50) && emagged < 2)
						emagged = 2
						shootAt(toshoot)
						emagged = 0
					else
						shootAt(toshoot)
			else if(prob(50))
				if(length(targets))
					var/mob/toarrest = pick(targets)
					if(toarrest)
						target = toarrest
						mode = SECBOT_HUNT

/obj/machinery/bot/ed209/bullet_act(obj/item/projectile/proj)
	if(lasercolor == "b" && !disabled)
		if(istype(proj, /obj/item/projectile/energy/beam/laser/tag/red))
			disabled = TRUE
			qdel(proj)
			sleep(100)
			disabled = FALSE
		else
			..()
	else if(lasercolor == "r" && !disabled)
		if(istype(proj, /obj/item/projectile/energy/beam/laser/tag/blue))
			disabled = TRUE
			qdel(proj)
			sleep(100)
			disabled = FALSE
		else
			..()
	else
		..()

/obj/machinery/bot/ed209/bluetag
	icon_state = "bed2090"

/obj/machinery/bot/ed209/bluetag/New()//If desired, you spawn red and bluetag bots easily
	SHOULD_CALL_PARENT(FALSE)

	new /obj/machinery/bot/ed209(GET_TURF(src), null, "b")
	qdel(src)

/obj/machinery/bot/ed209/redtag
	icon_state = "red2090"

/obj/machinery/bot/ed209/redtag/New()
	SHOULD_CALL_PARENT(FALSE)

	new /obj/machinery/bot/ed209(GET_TURF(src), null, "r")
	qdel(src)

// ED-209 Assembly
/obj/item/ed209_assembly
	name = "ED-209 assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/mob/bot/ed209.dmi'
	icon_state = "ed209_frame"
	item_state = "ed209_frame"

	var/build_step = 0
	var/created_name = "ED-209 Security Robot" //To preserve the name if it's a unique securitron I guess
	var/lasercolor = ""

/obj/item/ed209_assembly/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name), 1, MAX_NAME_LEN)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
		return

	switch(build_step)
		if(0)
			if(istype(W, /obj/item/robot_part/r_leg))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, SPAN_INFO("You add the robot right leg to the [src]."))
				name = "legs/frame assembly"
				item_state = "ed209_leg"
				icon_state = "ed209_leg"

		if(1)
			if(istype(W, /obj/item/robot_part/l_leg))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, SPAN_INFO("You add the robot left leg to [src]."))
				item_state = "ed209_legs"
				icon_state = "ed209_legs"

		if(2)
			if(istype(W, /obj/item/clothing/suit/laser_tag/red))
				lasercolor = "r"
			else if(istype(W, /obj/item/clothing/suit/laser_tag/blue))
				lasercolor = "b"
			if(lasercolor || istype(W, /obj/item/clothing/suit/armor/vest))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, SPAN_INFO("You add the armour to [src]."))
				name = "vest/legs/frame assembly"
				item_state = "[lasercolor]ed209_shell"
				icon_state = "[lasercolor]ed209_shell"

		if(3)
			if(iswelder(W))
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					build_step++
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					to_chat(user, SPAN_INFO("You weld the armour to [src]."))
					name = "shielded frame assembly"
		if(4)
			if(istype(W, /obj/item/clothing/head/helmet))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, SPAN_INFO("You add the helmet to [src]."))
				name = "covered and shielded frame assembly"
				item_state = "[lasercolor]ed209_hat"
				icon_state = "[lasercolor]ed209_hat"

		if(5)
			if(isprox(W))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, SPAN_INFO("You add the prox sensor to [src]."))
				name = "covered, shielded and sensored frame assembly"
				item_state = "[lasercolor]ed209_prox"
				icon_state = "[lasercolor]ed209_prox"

		if(6)
			if(iscable(W))
				var/obj/item/stack/cable_coil/coil = W
				to_chat(user, SPAN_INFO("You start to wire [src]..."))
				if(do_after(user, 40))
					coil.use(1)
					build_step++
					to_chat(user, SPAN_NOTICE("You wire the [src]."))
					name = "wired ED-209 assembly"
				else
					to_chat(user, SPAN_WARNING("You fail to wire the [src]."))

		if(7)
			switch(lasercolor)
				if("b")
					if(!istype(W, /obj/item/gun/energy/laser/tag/blue))
						return
					name = "bluetag ED-209 assembly"
				if("r")
					if(!istype(W, /obj/item/gun/energy/laser/tag/red))
						return
					name = "redtag ED-209 assembly"
				if("")
					if(!istype(W, /obj/item/gun/energy/taser))
						return
					name = "taser ED-209 assembly"
				else
					return
			build_step++
			to_chat(user, SPAN_INFO("You add [W] to [src]."))
			item_state = "[lasercolor]ed209_taser"
			icon_state = "[lasercolor]ed209_taser"
			user.drop_item()
			qdel(W)

		if(8)
			if(isscrewdriver(W))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				to_chat(user, SPAN_INFO("You start attaching the gun to [src]..."))
				if(do_after(user, 40))
					build_step++
					name = "armed [name]"
					to_chat(user, SPAN_NOTICE("You attach the gun to [src]."))
				else
					to_chat(user, SPAN_WARNING("You fail to attach the gun to [src]."))

		if(9)
			if(istype(W, /obj/item/cell))
				build_step++
				to_chat(user, SPAN_INFO("You complete the ED-209."))
				new /obj/machinery/bot/ed209(GET_TURF(src), created_name, lasercolor)
				user.drop_item()
				qdel(W)
				user.drop_from_inventory(src)
				qdel(src)