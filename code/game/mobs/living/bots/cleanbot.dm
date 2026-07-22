// Cleanbot
/mob/living/bot/cleanbot
	name = "cleanbot"
	desc = "A little cleaning robot. He looks so excited!"
	icon = 'icons/mob/bot/cleanbot.dmi'
	icon_state = "cleanbot0"
	layer = 5
	density = FALSE
	//weight = 1.0E7
	health = 25
	maxHealth = 25

	req_access = list(ACCESS_JANITOR)

	/// If we are actively cleaning
	var/cleaning = FALSE
	/// If our screw's been... twiddled. It makes us leaky
	var/screwloose = FALSE
	/// If our odd button (?) has been pressed. It makes us eject gibs
	var/oddbutton = FALSE
	/// Whether we clean blood
	var/blood = TRUE
	/// The types of things we're allowed to clean. Why isn't blood part of this? fuck if I know
	var/list/target_types = list()
	/// Currently pathfinding towards this one
	var/obj/effect/decal/cleanable/target
	/// Exists to avoid trying and failing the same target multiple times in a row
	var/obj/effect/decal/cleanable/oldtarget
	/// Exists to reset oldtarget when we move
	var/oldloc = null
	/// The actual path we've gotten from pathfinding
	var/list/path = list()
	/// This is also just an actual path
	var/list/patrol_path = null
	/// Frequency of navigation beacons
	var/beacon_freq = 1445	
	/// We go to the closest signal, so this is the closest we've been to a signal. It doesn't reset. Won't that mean if you get signaled while really close, far signals won't work again? probably, who knows.
	var/closest_dist
	/// The loc that won the closest_dist competition
	var/closest_loc
	/// If we fail to move four times, we give up
	var/failed_steps
	/// Patrolling toggle
	var/should_patrol
	/// Next destination while we're patrolling. Only exists to avoid repeatedly resetting the next destination, next_dest_loc is the important part
	var/next_dest
	/// The actual place we're going, while patrolling
	var/next_dest_loc

/mob/living/bot/cleanbot/New()
	. = ..()
	get_targets()
	icon_state = "cleanbot[on]"

	should_patrol = TRUE

	botcard = new /obj/item/card/id(src)
	var/datum/job/janitor/J = GLOBL.all_jobs["Janitor"]
	botcard.access = J.get_access()

	locked = FALSE // Start unlocked so roboticist can set them to patrol.

	register_radio(src, null, beacon_freq, RADIO_NAVBEACONS)

/mob/living/bot/cleanbot/Destroy()
	unregister_radio(src, beacon_freq)
	return ..()

/mob/living/bot/cleanbot/turn_on()
	. = ..()
	icon_state = "cleanbot[on]"
	updateUsrDialog()

/mob/living/bot/cleanbot/turn_off()
	. = ..()
	if(isnotnull(target))
		target.targeted_by = null
	target = null
	oldtarget = null
	oldloc = null
	icon_state = "cleanbot[on]"
	path = list()
	updateUsrDialog()

/mob/living/bot/cleanbot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	interact(user)

/mob/living/bot/cleanbot/interact(mob/user)
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

	SHOW_BROWSER(user, "<HEAD><TITLE>Cleaner v1.0 controls</TITLE></HEAD>[dat]", "window=autocleaner")
	onclose(user, "autocleaner")

/mob/living/bot/cleanbot/Topic(href, href_list)
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

/mob/living/bot/cleanbot/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/card/id) && istype(attacking_item, /obj/item/pda))
		return ..()
	if(allowed(usr) && !open && !emagged)
		locked = !locked
		FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		return

	if(emagged)
		FEEDBACK_ERROR_GENERIC(user)
		return

	if(!open)
		FEEDBACK_ACCESS_DENIED(user)
		return

	to_chat(user, SPAN_WARNING("Please close the access panel before locking it."))

/mob/living/bot/cleanbot/UnarmedAttack(atom/to_attack)
	if(!istype(to_attack, /turf)) // we can't click on decals. for some reason.
		return ..()
	var/decal = locate(/obj/effect/decal/cleanable) in to_attack
	if(!decal)
		return ..()
	clean(decal)

/mob/living/bot/cleanbot/Emag(mob/user)
	. = ..()
	if(open && !locked)
		if(isnotnull(user))
			to_chat(user, SPAN_NOTICE("\The [src] buzzes and beeps."))
		oddbutton = TRUE
		screwloose = TRUE

/mob/living/bot/cleanbot/Life()
	. = ..()

	if(!on)
		return
	if(cleaning)
		return

	if(!screwloose && !oddbutton && prob(5))
		visible_message("[src] makes an excited beeping booping sound!")

	if(screwloose && prob(5) && isopenturf(loc))
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

	if(client)
		return // No ai if we're occupied

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

/mob/living/bot/cleanbot/proc/patrol_move()
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

/mob/living/bot/cleanbot/receive_signal(datum/signal/signal)
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

/mob/living/bot/cleanbot/proc/get_targets()
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

/mob/living/bot/cleanbot/proc/clean(obj/effect/decal/cleanable/to_clean)
	anchored = TRUE
	icon_state = "cleanbot-c"
	visible_message(SPAN_WARNING("[src] begins to clean up the [to_clean]."))
	cleaning = TRUE
	var/cleantime = 50
	if(istype(to_clean, /obj/effect/decal/cleanable/dirt))		// Clean Dirt much faster
		cleantime = 10
	if(!do_after(src, cleantime, to_clean))
		return
	if(isopenturf(loc))
		var/turf/open/f = loc
		f.dirt = 0
	cleaning = FALSE
	qdel(to_clean)
	icon_state = "cleanbot[on]"
	anchored = FALSE
	target = null

/mob/living/bot/cleanbot/explode()
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
		var/mob/living/bot/cleanbot/bot = new /mob/living/bot/cleanbot(GET_TURF(src))
		bot.name = created_name
		to_chat(user, SPAN_INFO("You add the robot arm to the bucket and sensor assembly. Beep boop!"))
		user.drop_from_inventory(src)
		qdel(src)
		return TRUE

	return ..()