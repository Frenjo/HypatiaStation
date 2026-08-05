// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire conection to power network through a terminal

//NOTE: STUFF STOLEN FROM AIRLOCK.DM thx

/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."
	icon_state = "apc0"
	anchored = TRUE

	req_access = list(ACCESS_ENGINE_EQUIP)
	powernet = 0		// set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(

	var/area/area
	var/areastring = null
	var/obj/item/cell/cell
	var/start_charge = 90				// initial cell charge %
	var/cell_type = /obj/item/cell/apc
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/lighting = POWERCHAN_ON_AUTO
	var/equipment = POWERCHAN_ON_AUTO
	var/environ = POWERCHAN_ON_AUTO
	var/operating = 1
	var/charging = FALSE
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/tdir = null
	var/obj/machinery/power/terminal/terminal = null
	var/list/last_used = list(EQUIP = 0, LIGHT = 0, ENVIRON = 0, TOTAL = 0, CHARGING = 0)
	var/main_status = 0
	var/wiresexposed = 0
	var/malfhack = 0 //New var for my changes to AI malf. --NeoFite
	var/mob/living/silicon/ai/malfai = null //See above --NeoFite
	var/autoflag = 0		// 0 = off, 1= eqp and lights off, 2 = eqp off, 3 = all on.

	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/overload = 1 //used for the Blackout malf module
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/mob/living/silicon/ai/occupant = null
	var/longtermpower = 10
	var/datum/wires/apc/wires = null
	var/update_state = -1
	var/update_overlay = -1
	var/static/status_overlays = 0
	var/updating_icon = 0

	var/static/list/status_overlays_lock
	var/static/list/status_overlays_charging
	var/static/list/status_overlays_equipment
	var/static/list/status_overlays_lighting
	var/static/list/status_overlays_environ
	var/is_critical = 0

/obj/machinery/power/apc/New(turf/loc, ndir, building = 0)
	. = ..()
	wires = new /datum/wires/apc(src)

	// offset 24 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if(building)
		dir = ndir
	src.tdir = dir		// to fix Vars bug
	dir = SOUTH

	pixel_x = (src.tdir & 3) ? 0 : (src.tdir == 4 ? 24 : -24)
	pixel_y = (src.tdir & 3) ? (src.tdir == 1 ? 24 : -24) : 0
	if(building == 0)
		init()
	else
		area = GET_AREA(src)
		area.apc = src
		opened = 1
		operating = 0
		name = "[area.name] APC"
		stat |= MAINT
		src.update_icon()

/obj/machinery/power/apc/initialise()
	. = ..()
	update()

/obj/machinery/power/apc/Destroy()
	if(malfai && operating)
		if(IS_GAME_MODE(/datum/game_mode/malfunction))
			if(isstationlevel(src.z))
				var/datum/game_mode/malfunction/malf = global.PCticker.mode
				malf.apcs--

	area.apc = null
	for(var/channel in area.power_channels)
		area.power_channels[channel] = FALSE
	area.power_change()
	if(occupant)
		malfvacate(1)
	QDEL_NULL(wires)
	QDEL_NULL(cell)
	QDEL_NULL(terminal)
	return ..()

/obj/machinery/power/apc/get_examine_text()
	. = ..()
	if(stat & BROKEN)
		. += SPAN_WARNING("It looks broken...")
		return

	if(opened)
		if(has_electronics && isnotnull(terminal))
			. += SPAN_INFO("The cover is <em>[opened == 2 ? "removed" : "open"]</em> and the power cell is <em>[isnotnull(cell) ? "installed" : "missing"]</em>.")
		else if(!has_electronics && isnotnull(terminal))
			. += SPAN_INFO("It is <em>wired</em> but has <em>no electronics</em> installed.")
		else if(has_electronics && isnull(terminal))
			. += SPAN_INFO("It <em>has electronics</em> installed but is not <em>wired</em>.")
		else
			. += SPAN_INFO("It has <em>no electronics or wires</em> installed.")
	else
		if(stat & MAINT)
			. += SPAN_WARNING("The cover is closed, but something is wrong with it.")
		else if(malfhack)
			. += SPAN_WARNING("The cover is broken, and it may be hard to force it open.")
		else
			. += SPAN_INFO("The cover is closed.")

/obj/machinery/power/apc/can_handle_topic(mob/user)
	. = ..()
	if(!.)
		return
	if(!can_use(user, TRUE))
		return FALSE

/obj/machinery/power/apc/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(topic.has("lock"))
		coverlocked = !coverlocked

	else if(topic.has("breaker"))
		toggle_breaker()

	else if(topic.has("cmode"))
		chargemode = !chargemode
		if(!chargemode)
			charging = FALSE
			update_icon()

	else if(topic.has("eqp"))
		var/val = topic.get_num("eqp")
		equipment = setsubsystem(val)
		update_icon()
		update()

	else if(topic.has("lgt"))
		var/val = topic.get_num("lgt")
		lighting = setsubsystem(val)
		update_icon()
		update()

	else if(topic.has("env"))
		var/val = topic.get_num("env")
		environ = setsubsystem(val)
		update_icon()
		update()

	else if(topic.has("overload") && issilicon(user))
		overload_lighting()

	else if(topic.has("malfhack") && (get_malf_status(user) == 1))
		var/mob/living/silicon/ai/malf_ai = user
		if(malf_ai.malfhacking)
			to_chat(malfai, SPAN_WARNING("You are already hacking an APC."))
			return TRUE
		to_chat(malf_ai, SPAN_INFO("Beginning override of APC systems. This takes some time, and you cannot perform other actions during the process."))
		malf_ai.malfhack = src
		malf_ai.malfhacking = TRUE
		spawn(1 MINUTE)
			if(isnotnull(src) && !aidisabled)
				malf_ai.malfhack = null
				malf_ai.malfhacking = FALSE
				locked = TRUE
				if(IS_GAME_MODE(/datum/game_mode/malfunction))
					if(isstationlevel(z))
						var/datum/game_mode/malfunction/malf = global.PCticker.mode
						malf.apcs++
				malfai = malf_ai
				to_chat(malf_ai, SPAN_INFO("Hack complete. The APC is now under your exclusive control."))
				update_icon()

	else if(topic.has("occupyapc") && get_malf_status(user))
		malfoccupy(user)

	else if(topic.has("deoccupyapc") && get_malf_status(user))
		malfvacate()

	else if(topic.has("toggleaccess") && issilicon(user))
		if(emagged || (stat & (BROKEN | MAINT)))
			to_chat(user, SPAN_WARNING("The APC does not respond to the command."))
		else
			locked = !locked
			update_icon()

/obj/machinery/power/apc/updateDialog()
	if(stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([last_used[EQUIP] + last_used[LIGHT] + last_used[ENVIRON]]) : [cell ? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/init()
	has_electronics = 2 //installed and secured
	// is starting with a power cell installed, create it and set its charge level
	if(cell_type)
		src.cell = new cell_type(src)
		cell.charge = start_charge * cell.maxcharge / 100.0 		// (convert percentage to actual value)

	var/area/A = src.loc.loc

	//if area isn't specified use current
	if(isarea(A) && src.areastring == null)
		src.area = A
		name = "\improper [area.name] APC"
	else
		src.area = get_area_name(areastring)
		name = "\improper [area.name] APC"
	area.apc = src
	update_icon()

	make_terminal()

/obj/machinery/power/apc/proc/can_use(mob/user, loud = 0) //used by attack_hand() and Topic()
	if(user.stat)
		to_chat(user, SPAN_WARNING("You must be conscious to use [src]!"))
		return 0
	if(!user.client)
		return 0
	if(ismonkey(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return 1
	else if(!ishuman(user) && !issilicon(user))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return 1
	if(user.restrained())
		to_chat(user, SPAN_WARNING("You must have free hands to use [src]."))
		return 0
	if(user.lying)
		to_chat(user, SPAN_WARNING("You must stand to use [src]!"))
		return 0
	autoflag = 5
	if(issilicon(user))
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if(																	\
			src.aidisabled ||												\
			malfhack && istype(malfai) &&									\
			(																\
				(istype(AI) && (malfai != AI && malfai != AI.parent)) ||	\
				(istype(robot) && (robot in malfai.connected_robots))		\
			)																\
		)
			if(!loud)
				to_chat(user, SPAN_DANGER("\The [src] have AI control disabled!"))
			return 0
	else
		if(!in_range(src, user) || !isturf(src.loc))
			return 0

	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.getBrainLoss() >= 60)
			for(var/mob/M in viewers(src, null))
				H.visible_message(SPAN_DANGER("[H] stares cluelessly at [src] and drools."))
			return 0
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_DANGER("You momentarily forget how to use [src]."))
			return 0
	return 1