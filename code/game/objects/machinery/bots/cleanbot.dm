// Cleanbot
/obj/machinery/bot/cleanbot
	name = "cleanbot"
	desc = "A little cleaning robot. He looks so excited!"
	icon = 'icons/mob/bot/cleanbot.dmi'
	icon_state = "cleanbot0"
	layer = 5
	density = FALSE
	anchored = FALSE
	//weight = 1.0E7
	health = 25
	maxhealth = 25

	req_access = list(ACCESS_JANITOR)

	var/cleaning = FALSE
	var/screwloose = FALSE
	var/oddbutton = FALSE
	var/blood = TRUE
	var/list/target_types = list()
	var/obj/effect/decal/cleanable/target
	var/obj/effect/decal/cleanable/oldtarget
	var/oldloc = null
	var/list/path = list()
	var/list/patrol_path = null
	var/beacon_freq = 1445		// navigation beacon frequency
	var/closest_dist
	var/closest_loc
	var/failed_steps
	var/should_patrol
	var/next_dest
	var/next_dest_loc

/obj/machinery/bot/cleanbot/New()
	. = ..()
	get_targets()
	icon_state = "cleanbot[on]"

	should_patrol = TRUE

	botcard = new /obj/item/card/id(src)
	var/datum/job/janitor/J = GLOBL.all_jobs["Janitor"]
	botcard.access = J.get_access()

	locked = FALSE // Start unlocked so roboticist can set them to patrol.

	register_radio(src, null, beacon_freq, RADIO_NAVBEACONS)

/obj/machinery/bot/cleanbot/Destroy()
	unregister_radio(src, beacon_freq)
	return ..()

/obj/machinery/bot/cleanbot/turn_on()
	. = ..()
	icon_state = "cleanbot[on]"
	updateUsrDialog()

/obj/machinery/bot/cleanbot/turn_off()
	. = ..()
	if(isnotnull(target))
		target.targeted_by = null
	target = null
	oldtarget = null
	oldloc = null
	icon_state = "cleanbot[on]"
	path = list()
	updateUsrDialog()

/obj/machinery/bot/cleanbot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	interact(user)

/obj/machinery/bot/cleanbot/interact(mob/user)
	var/dat
	dat += {"
<TT><B>Automatic Station Cleaner v1.0</B></TT><BR><BR>
Status: ["<A href='byond://?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A>"]<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel is [open ? "opened" : "closed"]"}
	if(!locked || issilicon(user))
		dat += {"<BR>Cleans Blood: ["<A href='byond://?src=\ref[src];operation=blood'>[blood ? "Yes" : "No"]</A>"]<BR>"}
		dat += {"<BR>Patrol station: ["<A href='byond://?src=\ref[src];operation=patrol'>[should_patrol ? "Yes" : "No"]</A>"]<BR>"}
	//	dat += {"<BR>Beacon frequency: ["<A href='byond://?src=\ref[src];operation=freq'>[beacon_freq]</A>"]<BR>"}
	if(open && !locked)
		dat += {"
Odd looking screw twiddled: ["<A href='byond://?src=\ref[src];operation=screw'>[screwloose ? "Yes" : "No"]</A>"]<BR>
Weird button pressed: ["<A href='byond://?src=\ref[src];operation=oddbutton'>[oddbutton ? "Yes" : "No"]</A>"]"}

	user << browse("<HEAD><TITLE>Cleaner v1.0 controls</TITLE></HEAD>[dat]", "window=autocleaner")
	onclose(user, "autocleaner")

/obj/machinery/bot/cleanbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
		if("blood")
			blood = !blood
			get_targets()
			updateUsrDialog()
		if("patrol")
			should_patrol =!should_patrol
			patrol_path = null
			updateUsrDialog()
		if("freq")
			var/freq = text2num(input("Select frequency for navigation beacons", "Frequency", num2text(beacon_freq / 10))) * 10
			if(freq > 0)
				beacon_freq = freq
			updateUsrDialog()
		if("screw")
			screwloose = !screwloose
			to_chat(usr, SPAN_NOTICE("You twiddle the screw."))
			updateUsrDialog()
		if("oddbutton")
			oddbutton = !oddbutton
			to_chat(usr, SPAN_NOTICE("You press the weird button."))
			updateUsrDialog()

/obj/machinery/bot/cleanbot/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(allowed(usr) && !open && !emagged)
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
		return ..()

/obj/machinery/bot/cleanbot/Emag(mob/user)
	. = ..()
	if(open && !locked)
		if(isnotnull(user))
			to_chat(user, SPAN_NOTICE("\The [src] buzzes and beeps."))
		oddbutton = TRUE
		screwloose = TRUE

/obj/machinery/bot/cleanbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return
	if(cleaning)
		return

	if(!screwloose && !oddbutton && prob(5))
		visible_message("[src] makes an excited beeping booping sound!")

	if(screwloose && prob(5))
		if(isopenturf(loc))
			var/turf/open/T = loc
			if(T.wet < 1)
				T.wet = TRUE
				if(T.wet_overlay)
					T.remove_overlay(T.wet_overlay)
					T.wet_overlay = null
				T.wet_overlay = image('icons/effects/water.dmi', T, "wet_floor")
				T.add_overlay(T.wet_overlay)
				spawn(800)
					if(istype(T) && T.wet < 2)
						T.wet = FALSE
						if(T.wet_overlay)
							T.remove_overlay(T.wet_overlay)
							T.wet_overlay = null
	if(oddbutton && prob(5))
		visible_message("Something flies out of [src]. He seems to be acting oddly.")
		var/obj/effect/decal/cleanable/blood/gibs/gib = new /obj/effect/decal/cleanable/blood/gibs(loc)
		//gib.streak(list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		oldtarget = gib
	if(!target)
		for(var/obj/effect/decal/cleanable/D in view(7, src))
			for(var/T in target_types)
				if(isnull(D.targeted_by) && (D.type == T || D.parent_type == T) && D != oldtarget)   // If the mess isn't targeted
					oldtarget = D								 // or if it is but the bot is gone.
					target = D									 // and it's stuff we clean?  Clean it.
					D.targeted_by = src	// Claim the mess we are targeting.
					return

	if(!target)
		if(loc != oldloc)
			oldtarget = null

		if(!should_patrol)
			return

		if(!length(patrol_path))
			var/datum/radio_frequency/frequency = global.CTradio.return_frequency(beacon_freq)

			if(!frequency)
				return

			closest_dist = 9999
			closest_loc = null
			next_dest_loc = null

			var/datum/signal/signal = new /datum/signal()
			signal.source = src
			signal.transmission_method = TRANSMISSION_RADIO
			signal.data = list("findbeacon" = "patrol")
			frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
			spawn(5)
				if(!next_dest_loc)
					next_dest_loc = closest_loc
				if(next_dest_loc)
					patrol_path = AStar(loc, next_dest_loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id = botcard, exclude = null)
		else
			patrol_move()
		return

	if(target && !length(path))
		spawn(0)
			if(isnull(src) || isnull(target))
				return
			path = AStar(loc, target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
			if(!path)
				path = list()
			if(!length(path))
				oldtarget = target
				target.targeted_by = null
				target = null
		return
	if(length(path) && target && (target != null))
		step_to(src, path[1])
		path -= path[1]
	else if(length(path) == 1)
		step_to(src, target)

	if(target && (target != null))
		patrol_path = null
		if(loc == target.loc)
			clean(target)
			path = list()
			target = null
			return

	oldloc = loc

/obj/machinery/bot/cleanbot/proc/patrol_move()
	if(!length(patrol_path))
		return

	var/next = patrol_path[1]
	patrol_path -= next
	if(next == loc)
		return

	var/moved = step_towards(src, next)
	if(!moved)
		failed_steps++
	if(failed_steps > 4)
		patrol_path = null
		next_dest = null
		failed_steps = 0
	else
		failed_steps = 0

/obj/machinery/bot/cleanbot/receive_signal(datum/signal/signal)
	if(!..())
		return

	var/recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid)
		return

	var/dist = get_dist(src, signal.source.loc)
	if(dist < closest_dist && signal.source.loc != loc)
		closest_dist = dist
		closest_loc = signal.source.loc
		next_dest = signal.data["next_patrol"]

	if(recv == next_dest)
		next_dest_loc = signal.source.loc
		next_dest = signal.data["next_patrol"]

/obj/machinery/bot/cleanbot/proc/get_targets()
	target_types = list(
		/obj/effect/decal/cleanable/blood/oil,
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/crayon,
		/obj/effect/decal/cleanable/liquid_fuel,
		/obj/effect/decal/cleanable/mucus,
		/obj/effect/decal/cleanable/dirt
	)

	if(blood)
		target_types.Add(/obj/effect/decal/cleanable/blood)

/obj/machinery/bot/cleanbot/proc/clean(obj/effect/decal/cleanable/target)
	anchored = TRUE
	icon_state = "cleanbot-c"
	visible_message(SPAN_WARNING("[src] begins to clean up the [target]."))
	cleaning = TRUE
	var/cleantime = 50
	if(istype(target, /obj/effect/decal/cleanable/dirt))		// Clean Dirt much faster
		cleantime = 10
	spawn(cleantime)
		if(isopenturf(loc))
			var/turf/open/f = loc
			f.dirt = 0
		cleaning = FALSE
		qdel(target)
		icon_state = "cleanbot[on]"
		anchored = FALSE
		target = null

/obj/machinery/bot/cleanbot/explode()
	on = FALSE
	visible_message(SPAN_DANGER("[src] blows apart!"), 1)

	var/turf/T = GET_TURF(src)
	new /obj/item/reagent_holder/glass/bucket(T)
	new /obj/item/assembly/prox_sensor(T)
	if(prob(50))
		new /obj/item/robot_part/l_arm(T)

	make_sparks(3, TRUE, src)
	return ..()

// Cleanbot Assembly
/obj/item/reagent_holder/glass/bucket/attack_by(obj/item/I, mob/user)
	if(isprox(I))
		to_chat(user, SPAN_INFO("You add \the [I] to \the [src]."))
		qdel(I)
		user.put_in_hands(new /obj/item/cleanbot_assembly())
		user.drop_from_inventory(src)
		qdel(src)
		return TRUE
	return ..()

/obj/item/cleanbot_assembly
	name = "proxy bucket"
	desc = "It's a bucket with a sensor attached."
	icon = 'icons/mob/bot/cleanbot.dmi'
	icon_state = "bucket_proxy"

	w_class = 3

	force = 3
	throwforce = 10
	throw_speed = 2
	throw_range = 5

	var/created_name = "Cleanbot"

/obj/item/cleanbot_assembly/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name), 1, MAX_NAME_LEN)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
		return TRUE

	if(istype(I, /obj/item/robot_part/l_arm) || istype(I, /obj/item/robot_part/r_arm))
		user.drop_item()
		qdel(I)
		var/obj/machinery/bot/cleanbot/bot = new /obj/machinery/bot/cleanbot(GET_TURF(src))
		bot.name = created_name
		to_chat(user, SPAN_INFO("You add the robot arm to the bucket and sensor assembly. Beep boop!"))
		user.drop_from_inventory(src)
		qdel(src)
		return TRUE

	return ..()