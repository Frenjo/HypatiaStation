// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire conection to power network through a terminal

//NOTE: STUFF STOLEN FROM AIRLOCK.DM thx

/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."
	icon_state = "apc0"
	anchored = 1
	use_power = 0
	req_access = list(ACCESS_ENGINE_EQUIP)
	powernet = 0		// set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(

	var/area/area
	var/areastring = null
	var/obj/item/weapon/cell/cell
	var/start_charge = 90				// initial cell charge %
	var/cell_type = /obj/item/weapon/cell/apc
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/lighting = POWERCHAN_ON_AUTO
	var/equipment = POWERCHAN_ON_AUTO
	var/environ = POWERCHAN_ON_AUTO
	var/operating = 1
	var/charging = 0
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/tdir = null
	var/obj/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_total = 0
	var/lastused_charging = 0
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
	var/global/status_overlays = 0
	var/updating_icon = 0

	var/standard_max_charge
	var/global/list/status_overlays_lock
	var/global/list/status_overlays_charging
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ
	var/is_critical = 0

/obj/machinery/power/apc/New(turf/loc, ndir, building = 0)
	..()
	wires = new(src)
	var/obj/item/weapon/cell/tmp_cell = new
	standard_max_charge = tmp_cell.maxcharge
	qdel(tmp_cell)

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
		area = get_area(src)
		area.apc = src
		opened = 1
		operating = 0
		name = "[area.name] APC"
		stat |= MAINT
		src.update_icon()

/obj/machinery/power/apc/initialize()
	..()
	src.update()

/obj/machinery/power/apc/Destroy()
	if(malfai && operating)
		if(ticker.mode.config_tag == "malfunction")
			if(src.z in config.station_levels) //if (is_type_in_list(get_area(src), the_station_areas))
				ticker.mode:apcs--

	area.apc -= src
	area.power_light = 0
	area.power_equip = 0
	area.power_environ = 0
	area.power_change()
	if(occupant)
		malfvacate(1)
	qdel(wires)
	wires = null
	if(cell)
		qdel(cell)
		cell = null
	if(terminal)
		qdel(terminal)
		terminal = null
	return ..()

/obj/machinery/power/apc/examine(mob/user)
	if(user /*&& !usr.stat*/)
		to_chat(user, "A control terminal for the area electrical systems.")
		..()
		if(stat & BROKEN)
			to_chat(user, "Looks broken.")
			return

		if(opened)
			if(has_electronics && terminal)
				to_chat(user, "The cover is [opened == 2 ? "removed" : "open"] and the power cell is [cell ? "installed" : "missing"].")
			else if(!has_electronics && terminal)
				to_chat(user, "There are some wires but no any electronics.")
			else if(has_electronics && !terminal)
				to_chat(user, "Electronics installed but not wired.")
			else /* if (!has_electronics && !terminal) */
				to_chat(user, "There is no electronics nor connected wires.")

		else
			if(stat & MAINT)
				to_chat(user, "The cover is closed. Something wrong with it: it doesn't work.")
			else if(malfhack)
				to_chat(user, "The cover is broken. It may be hard to force it open.")
			else
				to_chat(user, "The cover is closed.")

/obj/machinery/power/apc/Topic(href, href_list)
	if(..())
		return 0

	if(!can_use(usr, 1))
		return 0

	if(href_list["lock"])
		coverlocked = !coverlocked

	else if(href_list["breaker"])
		toggle_breaker()

	else if(href_list["cmode"])
		chargemode = !chargemode
		if(!chargemode)
			charging = 0
			update_icon()

	else if(href_list["eqp"])
		var/val = text2num(href_list["eqp"])

		equipment = setsubsystem(val)

		update_icon()
		update()

	else if(href_list["lgt"])
		var/val = text2num(href_list["lgt"])

		lighting = setsubsystem(val)

		update_icon()
		update()

	else if(href_list["env"])
		var/val = text2num(href_list["env"])

		environ = setsubsystem(val)

		update_icon()
		update()

	else if(href_list["overload"])
		if(issilicon(usr))
			src.overload_lighting()

	else if(href_list["malfhack"])
		var/mob/living/silicon/ai/malfai = usr
		if(get_malf_status(malfai) == 1)
			if(malfai.malfhacking)
				to_chat(malfai, "You are already hacking an APC.")
				return 1
			to_chat(malfai, "Beginning override of APC systems. This takes some time, and you cannot perform other actions during the process.")
			malfai.malfhack = src
			malfai.malfhacking = 1
			sleep(600)
			if(src)
				if(!src.aidisabled)
					malfai.malfhack = null
					malfai.malfhacking = 0
					locked = 1
					if(ticker.mode.config_tag == "malfunction")
						if(src.z in config.station_levels) //if (is_type_in_list(get_area(src), the_station_areas))
							ticker.mode:apcs++
					if(usr:parent)
						src.malfai = usr:parent
					else
						src.malfai = usr
					to_chat(malfai, "Hack complete. The APC is now under your exclusive control.")
					update_icon()

	else if(href_list["occupyapc"])
		if(get_malf_status(usr))
			malfoccupy(usr)

	else if(href_list["deoccupyapc"])
		if(get_malf_status(usr))
			malfvacate()

	else if(href_list["toggleaccess"])
		if(issilicon(usr))
			if(emagged || (stat & (BROKEN | MAINT)))
				to_chat(usr, "The APC does not respond to the command.")
			else
				locked = !locked
				update_icon()

	return 1

/obj/machinery/power/apc/updateDialog()
	if(stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip + lastused_light + lastused_environ]) : [cell ? cell.percent() : "N/C"] ([charging])"

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

/obj/machinery/power/apc/proc/can_use(mob/user as mob, loud = 0) //used by attack_hand() and Topic()
	if(user.stat)
		to_chat(user, SPAN_WARNING("You must be conscious to use [src]!"))
		return 0
	if(!user.client)
		return 0
	if(!(ishuman(user) || issilicon(user) || ismonkey(user) /*&& ticker && ticker.mode.name == "monkey"*/))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to use [src]!"))
		return 0
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