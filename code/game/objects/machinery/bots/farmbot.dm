//Farmbots by GauHelldragon - 12/30/2012
// A new type of buildable aiBot that helps out in hydroponics

// Made by using a robot arm on a water tank and then adding:
// A plant analyser, a bucket, a mini-hoe and then a proximity sensor (in that order)

// Will water, weed and fertilize plants that need it
// When emagged, it will "water", "weed" and "fertilize" humans instead
// Holds up to 10 fertilizers (only the type dispensed by the machines, not chemistry bottles)
// It will fill up it's water tank at a sink when low.

// The behavior panel can be unlocked with hydroponics access and be modified to disable certain behaviors
// By default, it will ignore weeds and mushrooms, but can be set to tend to these types of plants as well.

#define FARMBOT_MODE_NONE			0
#define FARMBOT_MODE_WATER			1
#define FARMBOT_MODE_FERTILIZE	 	2
#define FARMBOT_MODE_WEED			3
#define FARMBOT_MODE_REFILL			4
#define FARMBOT_MODE_WAITING		5

#define FARMBOT_ANIMATION_TIME		25 //How long it takes to use one of the action animations
#define FARMBOT_EMAG_DELAY			60 //How long of a delay after doing one of the emagged attack actions
#define FARMBOT_ACTION_DELAY		35 //How long of a delay after doing one of the normal actions

/obj/machinery/bot/farmbot
	name = "farmbot"
	desc = "A little farming robot. The botanist's best friend."
	icon = 'icons/mob/bot/farmbot.dmi'
	icon_state = "farmbot0"
	layer = 5
	density = TRUE
	anchored = FALSE
	health = 50
	maxhealth = 50
	req_access = list(ACCESS_HYDROPONICS)

	var/Max_Fertilizers = 10

	var/setting_water = TRUE
	var/setting_refill = TRUE
	var/setting_fertilize = TRUE
	var/setting_weed = TRUE
	var/setting_ignoreWeeds = TRUE
	var/setting_ignoreMushrooms = TRUE

	var/atom/target //Current target, can be a human, a hydroponics tray, or a sink
	var/mode //Which mode is being used, 0 means it is looking for work

	var/obj/structure/reagent_dispensers/watertank/tank // the water tank that was used to make it, remains inside the bot.

	var/list/path = list() // used for pathing
	var/frustration

/obj/machinery/bot/farmbot/New()
	. = ..()
	icon_state = "farmbot[on]"

/obj/machinery/bot/farmbot/initialise()
	. = ..()

	botcard = new /obj/item/card/id(src)
	botcard.access = req_access

	if(isnull(tank)) //Should be set as part of making it... but lets check anyway
		tank = locate(/obj/structure/reagent_dispensers/watertank) in contents
	if(isnull(tank)) //An admin must have spawned the farmbot! Better give it a tank.
		tank = new /obj/structure/reagent_dispensers/watertank(src)

/obj/machinery/bot/farmbot/Bump(atom/M) //Leave no door unopened!
	spawn(0)
		if(istype(M, /obj/machinery/door) && isnotnull(botcard))
			var/obj/machinery/door/D = M
			if(!istype(D, /obj/machinery/door/firedoor) && D.check_access(botcard))
				D.open()
				frustration = 0

/obj/machinery/bot/farmbot/turn_on()
	. = ..()
	icon_state = "farmbot[on]"
	updateUsrDialog()

/obj/machinery/bot/farmbot/turn_off()
	. = ..()
	path = list()
	icon_state = "farmbot[on]"
	updateUsrDialog()

/obj/machinery/bot/farmbot/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/bot/farmbot/proc/get_total_ferts()
	var/total_fert = 0
	for(var/obj/item/nutrient/fert in contents)
		total_fert++
	return total_fert

/obj/machinery/bot/farmbot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	var/dat
	dat += "<TT><B>Automatic Hyrdoponic Assisting Unit v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='byond://?src=\ref[src];power=1'>[on ? "On" : "Off"]</A><BR>"

	dat += "Water Tank: "
	if(isnotnull(tank))
		dat += "\[[tank.reagents.total_volume]/[tank.reagents.maximum_volume]\]"
	else
		dat += "Error: Water Tank not Found"

	dat += "<br>Fertilizer Storage: <A href='byond://?src=\ref[src];eject=1'>\[[get_total_ferts()]/[Max_Fertilizers]\]</a>"

	dat += "<br>Behaviour controls are [locked ? "locked" : "unlocked"]<hr>"
	if(!locked)
		dat += "<TT>Watering Controls:<br>"
		dat += " Water Plants : <A href='byond://?src=\ref[src];water=1'>[setting_water ? "Yes" : "No"]</A><BR>"
		dat += " Refill Watertank : <A href='byond://?src=\ref[src];refill=1'>[setting_refill ? "Yes" : "No"]</A><BR>"
		dat += "<br>Fertilizer Controls:<br>"
		dat += " Fertilize Plants : <A href='byond://?src=\ref[src];fertilize=1'>[setting_fertilize ? "Yes" : "No"]</A><BR>"
		dat += "<br>Weeding Controls:<br>"
		dat += " Weed Plants : <A href='byond://?src=\ref[src];weed=1'>[setting_weed ? "Yes" : "No"]</A><BR>"
		dat += "<br>Ignore Weeds : <A href='byond://?src=\ref[src];ignoreWeed=1'>[setting_ignoreWeeds ? "Yes" : "No"]</A><BR>"
		dat += "Ignore Mushrooms : <A href='byond://?src=\ref[src];ignoreMush=1'>[setting_ignoreMushrooms ? "Yes" : "No"]</A><BR>"
		dat += "</TT>"

	user << browse("<HEAD><TITLE>Farmbot v1.0 controls</TITLE></HEAD>[dat]", "window=autofarm")
	onclose(user, "autofarm")

/obj/machinery/bot/farmbot/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	add_fingerprint(usr)
	if(href_list["power"] && allowed(usr))
		if(on)
			turn_off()
		else
			turn_on()

	else if(href_list["water"] && !locked)
		setting_water = !setting_water
	else if(href_list["refill"] && !locked)
		setting_refill = !setting_refill
	else if(href_list["fertilize"] && !locked)
		setting_fertilize = !setting_fertilize
	else if(href_list["weed"] && !locked)
		setting_weed = !setting_weed
	else if(href_list["ignoreWeed"] && !locked)
		setting_ignoreWeeds = !setting_ignoreWeeds
	else if(href_list["ignoreMush"] && !locked)
		setting_ignoreMushrooms = !setting_ignoreMushrooms
	else if(href_list["eject"])
		flick("farmbot_hatch", src)
		for(var/obj/item/nutrient/fert in contents)
			fert.forceMove(GET_TURF(src))

	updateUsrDialog()

/obj/machinery/bot/farmbot/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(allowed(user))
			locked = !locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
			updateUsrDialog()
		else
			FEEDBACK_ACCESS_DENIED(user)

	else if(istype(W, /obj/item/nutrient))
		if(get_total_ferts() >= Max_Fertilizers)
			to_chat(user, SPAN_NOTICE("The fertilizer storage is full!"))
			return
		user.drop_item()
		W.forceMove(src)
		to_chat(user, "You insert [W].")
		flick("farmbot_hatch", src)
		updateUsrDialog()
		return

	else
		..()

/obj/machinery/bot/farmbot/Emag(mob/user)
	. = ..()
	if(user)
		to_chat(user, SPAN_WARNING("You short out \the [src]'s plant identifier circuits."))
	spawn(0)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_DANGER("[src] buzzes oddly!"), 1)
	flick("farmbot_broke", src)
	emagged = 1
	on = TRUE
	icon_state = "farmbot[on]"
	target = null
	mode = FARMBOT_MODE_WAITING //Give the emagger a chance to get away! 15 seconds should be good.
	spawn(150)
		mode = FARMBOT_MODE_NONE

/obj/machinery/bot/farmbot/explode()
	on = FALSE
	visible_message(SPAN_DANGER("[src] blows apart!"), 1)

	var/turf/T = GET_TURF(src)
	new /obj/item/minihoe(T)
	new /obj/item/reagent_holder/glass/bucket(T)
	new /obj/item/assembly/prox_sensor(T)
	new /obj/item/plant_analyser(T)

	if(isnotnull(tank))
		tank.forceMove(T)

	for(var/obj/item/nutrient/fert in contents)
		if(prob(50))
			fert.forceMove(T)

	if(prob(50))
		new /obj/item/robot_part/l_arm(T)

	make_sparks(3, TRUE, src)
	return ..()

/obj/machinery/bot/farmbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return

	if(emagged && prob(1))
		flick("farmbot_broke", src)

	if(mode == FARMBOT_MODE_WAITING)
		return

	if(!mode || isnull(target) || !(target in view(7, src))) //Don't bother chasing down targets out of view
		mode = FARMBOT_MODE_NONE
		target = null
		if(!find_target())
			// Couldn't find a target, wait a while before trying again.
			mode = FARMBOT_MODE_WAITING
			spawn(100)
				mode = FARMBOT_MODE_NONE
			return

	if(mode && target)
		if(get_dist(target, src) <= 1 || (emagged && mode == FARMBOT_MODE_FERTILIZE))
			// If we are in emagged fertilize mode, we throw the fertilizer, so distance doesn't matter
			frustration = 0
			use_farmbot_item()
		else
			move_to_target()

/obj/machinery/bot/farmbot/proc/use_farmbot_item()
	if(isnull(target))
		mode = FARMBOT_MODE_NONE
		return 0

	if(emagged && !ismob(target)) // Humans are plants!
		mode = FARMBOT_MODE_NONE
		target = null
		return 0

	if(!emagged && !istype(target, /obj/machinery/hydroponics) && !istype(target, /obj/structure/sink)) // Humans are not plants!
		mode = FARMBOT_MODE_NONE
		target = null
		return 0

	if(mode == FARMBOT_MODE_FERTILIZE)
		//Find which fertilizer to use
		var/obj/item/nutrient/fert
		for(var/obj/item/nutrient/nut in contents)
			fert = nut
			break
		if(!fert)
			target = null
			mode = FARMBOT_MODE_NONE
			return
		fertilize(fert)

	if(mode == FARMBOT_MODE_WEED)
		weed()

	if(mode == FARMBOT_MODE_WATER)
		water()

	if(mode == FARMBOT_MODE_REFILL)
		refill()

/obj/machinery/bot/farmbot/proc/find_target()
	if(emagged) //Find a human and help them!
		for(var/mob/living/carbon/human/human in view(7, src))
			if(human.stat == DEAD)
				continue

			var list/options = list(FARMBOT_MODE_WEED)
			if(get_total_ferts())
				options.Add(FARMBOT_MODE_FERTILIZE)
			if(tank && tank.reagents.total_volume >= 1)
				options.Add(FARMBOT_MODE_WATER)
			mode = pick(options)
			target = human
			return mode
		return 0
	else
		if(setting_refill && tank && tank.reagents.total_volume < 100 )
			for(var/obj/structure/sink/source in view(7, src))
				target = source
				mode = FARMBOT_MODE_REFILL
				return 1
		for(var/obj/machinery/hydroponics/tray in view(7, src))
			var/newMode = GetNeededMode(tray)
			if(newMode)
				mode = newMode
				target = tray
				return 1
		return 0

/obj/machinery/bot/farmbot/proc/GetNeededMode(obj/machinery/hydroponics/tray)
	if(!tray.planted || tray.dead)
		return 0
	if(tray.myseed.plant_type == 1 && setting_ignoreWeeds)
		return 0
	if(tray.myseed.plant_type == 2 && setting_ignoreMushrooms)
		return 0

	if(setting_water && tray.waterlevel <= 10 && tank && tank.reagents.total_volume >= 1)
		return FARMBOT_MODE_WATER

	if(setting_weed && tray.weedlevel >= 5)
		return FARMBOT_MODE_WEED

	if(setting_fertilize && tray.nutrilevel <= 2 && get_total_ferts())
		return FARMBOT_MODE_FERTILIZE

	return 0

/obj/machinery/bot/farmbot/proc/move_to_target()
	//Mostly copied from medibot code.
	if(frustration > 8)
		target = null
		mode = FARMBOT_MODE_NONE
		frustration = 0
		path = list()
	if(isnotnull(target) && length(path) && get_dist(target, path[length(path)]) > 2)
		path = list()
	if(isnotnull(target) && !length(path) && get_dist(src, target) > 1)
		spawn(0)
			var/turf/dest = get_step_towards(target, src)  //Can't pathfind to a tray, as it is dense, so pathfind to the spot next to the tray
			path = AStar(loc, dest, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
			if(!length(path))
				for(var/turf/spot in orange(1, target)) //The closest one is unpathable, try  the other spots
					if(spot == dest) //We already tried this spot
						continue
					if(spot.density)
						continue
					path = AStar(loc, spot, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
					path = reverselist(path)
					if(length(path))
						break

				if(!length(path))
					target = null
					mode = FARMBOT_MODE_NONE
		return

	if(length(path) && isnotnull(target))
		step_to(src, path[1])
		path.Remove(path[1])
		spawn(3)
			if(length(path))
				step_to(src, path[1])
				path.Remove(path[1])

	if(length(path) > 8 && target)
		frustration++

/obj/machinery/bot/farmbot/proc/fertilize(obj/item/nutrient/fert)
	if(!fert)
		target = null
		mode = FARMBOT_MODE_NONE
		return 0

	if(emagged) // Warning, hungry humans detected: throw fertilizer at them
		spawn(0)
			fert.forceMove(loc)
			fert.throw_at(target, 16, 3)
		visible_message(SPAN_DANGER("[src] launches [fert.name] at [target.name]!"))
		flick("farmbot_broke", src)
		spawn(FARMBOT_EMAG_DELAY)
			mode = FARMBOT_MODE_NONE
			target = null
		return 1

	else // feed them plants~
		var /obj/machinery/hydroponics/tray = target
		tray.nutrilevel = 10
		tray.yieldmod = fert.yieldmod
		tray.mutmod = fert.mutmod
		qdel(fert)
		tray.updateicon()
		icon_state = "farmbot_fertile"
		mode = FARMBOT_MODE_WAITING

		spawn(FARMBOT_ACTION_DELAY)
			mode = FARMBOT_MODE_NONE
			target = null
		spawn(FARMBOT_ANIMATION_TIME)
			icon_state = "farmbot[on]"
		return 1

/obj/machinery/bot/farmbot/proc/weed()
	icon_state = "farmbot_hoe"
	spawn(FARMBOT_ANIMATION_TIME)
		icon_state = "farmbot[on]"

	if(emagged) // Warning, humans infested with weeds!
		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_EMAG_DELAY)
			mode = FARMBOT_MODE_NONE

		if(prob(50)) // better luck next time little guy
			visible_message(SPAN_DANGER("[src] swings wildly at [target] with a minihoe, missing completely!"))

		else // yayyy take that weeds~
			var/attackVerb = pick("slashed", "sliced", "cut", "clawed")
			var/mob/living/carbon/human/human = target

			visible_message(SPAN_DANGER("[src] [attackVerb] [human]!"))
			var/damage = 5
			var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
			var/datum/organ/external/affecting = human.get_organ(ran_zone(dam_zone))
			var/armor = human.run_armor_check(affecting, "melee")
			human.apply_damage(damage, BRUTE, affecting, armor, sharp = 1, edge = 1)

	else // warning, plants infested with weeds!
		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_ACTION_DELAY)
			mode = FARMBOT_MODE_NONE

		var/obj/machinery/hydroponics/tray = target
		tray.weedlevel = 0
		tray.updateicon()

/obj/machinery/bot/farmbot/proc/water()
	if(!tank || tank.reagents.total_volume < 1)
		mode = FARMBOT_MODE_NONE
		target = null
		return 0

	icon_state = "farmbot_water"
	spawn(FARMBOT_ANIMATION_TIME)
		icon_state = "farmbot[on]"

	if(emagged) // warning, humans are thirsty!
		var/splashAmount = min(70, tank.reagents.total_volume)
		visible_message(SPAN_WARNING("[src] splashes [target] with a bucket of water!"))
		playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		if(prob(50))
			tank.reagents.reaction(target, TOUCH) //splash the human!
		else
			tank.reagents.reaction(target.loc, TOUCH) //splash the human's roots!
		spawn(5)
			tank.reagents.remove_any(splashAmount)

		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_EMAG_DELAY)
			mode = FARMBOT_MODE_NONE
	else
		var/obj/machinery/hydroponics/tray = target
		var/b_amount = tank.reagents.get_reagent_amount("water")
		if(b_amount > 0 && tray.waterlevel < 100)
			if(b_amount + tray.waterlevel > 100)
				b_amount = 100 - tray.waterlevel
			tank.reagents.remove_reagent("water", b_amount)
			tray.waterlevel += b_amount
			playsound(src, 'sound/effects/slosh.ogg', 25, 1)

	//		Toxicity dilutation code. The more water you put in, the lesser the toxin concentration.
			tray.toxic -= round(b_amount / 4)
			if(tray.toxic < 0) // Make sure it won't go overboard
				tray.toxic = 0

		tray.updateicon()
		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_ACTION_DELAY)
			mode = FARMBOT_MODE_NONE

/obj/machinery/bot/farmbot/proc/refill()
	if(!tank || !tank.reagents.total_volume > 600 || !istype(target, /obj/structure/sink))
		mode = FARMBOT_MODE_NONE
		target = null
		return

	mode = FARMBOT_MODE_WAITING
	playsound(src, 'sound/effects/slosh.ogg', 25, 1)
	visible_message(SPAN_INFO("[src] starts filling it's tank from [target]."))
	spawn(300)
		visible_message(SPAN_INFO("[src] finishes filling it's tank."))
		mode = FARMBOT_MODE_NONE
		tank.reagents.add_reagent("water", tank.reagents.maximum_volume - tank.reagents.total_volume )
		playsound(src, 'sound/effects/slosh.ogg', 25, 1)

// Farmbot Assembly
/obj/structure/reagent_dispensers/watertank/attack_by(obj/item/I, mob/user)
	if(!istype(I, /obj/item/robot_part/l_arm) && !istype(I, /obj/item/robot_part/r_arm))
		return ..()

	// Making a farmbot!
	var/obj/item/farmbot_assembly/assembly = new /obj/item/farmbot_assembly()
	assembly.forceMove(loc)
	to_chat(user, SPAN_INFO("You add the robot arm to \the [src]!"))
	loc = assembly //Place the water tank into the assembly, it will be needed for the finished bot
	qdel(I)
	return TRUE

/obj/item/farmbot_assembly
	name = "water tank/robot arm assembly"
	desc = "A water tank with a robot arm permanently grafted to it."
	icon = 'icons/mob/bot/farmbot.dmi'
	icon_state = "water_arm"
	w_class = 3.0

	var/build_step = 0
	var/created_name = "Farmbot" //To preserve the name if it's a unique farmbot I guess

/obj/item/farmbot_assembly/initialise()
	. = ..()
	// If an admin spawned it, it won't have a watertank in it, so lets make one for em!
	var/tank = locate(/obj/structure/reagent_dispensers/watertank) in contents
	if(isnull(tank))
		new /obj/structure/reagent_dispensers/watertank(src)

/obj/item/farmbot_assembly/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/pen))
		var/t = input(user, "Enter new robot name", name, created_name) as text
		t = copytext(sanitize(t), 1, MAX_NAME_LEN)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
		return TRUE

	if(istype(I, /obj/item/plant_analyser) && !build_step)
		build_step++
		to_chat(user, SPAN_INFO("You add the plant analyser to \the [src]!"))
		name = "farmbot assembly"
		qdel(I)
		return TRUE

	if(istype(I, /obj/item/reagent_holder/glass/bucket) && build_step == 1)
		build_step++
		to_chat(user, SPAN_INFO("You add a bucket to \the [src]!"))
		name = "farmbot assembly with bucket"
		qdel(I)
		return

	if(istype(I, /obj/item/minihoe) && build_step == 2)
		build_step++
		to_chat(user, SPAN_INFO("You add a minihoe to \the [src]!"))
		name = "farmbot assembly with bucket and minihoe"
		qdel(I)
		return TRUE

	if(isprox(I) && build_step == 3)
		build_step++
		to_chat(user, SPAN_INFO("You complete the Farmbot! Beep boop."))
		var/obj/machinery/bot/farmbot/S = new /obj/machinery/bot/farmbot(GET_TURF(src))
		for(var/obj/structure/reagent_dispensers/watertank/wTank in contents)
			wTank.forceMove(S)
			S.tank = wTank
		S.name = created_name
		qdel(I)
		qdel(src)
		return TRUE

	return ..()

#undef FARMBOT_MODE_NONE
#undef FARMBOT_MODE_WATER
#undef FARMBOT_MODE_FERTILIZE
#undef FARMBOT_MODE_WEED
#undef FARMBOT_MODE_REFILL
#undef FARMBOT_MODE_WAITING

#undef FARMBOT_ANIMATION_TIME
#undef FARMBOT_EMAG_DELAY
#undef FARMBOT_ACTION_DELAY