#define APC_WIRE_IDSCAN 1
#define APC_WIRE_MAIN_POWER1 2
#define APC_WIRE_MAIN_POWER2 3
#define APC_WIRE_AI_CONTROL 4

//update_state
#define UPSTATE_CELL_IN 1
#define UPSTATE_OPENED1 2
#define UPSTATE_OPENED2 4
#define UPSTATE_MAINT 8
#define UPSTATE_BROKE 16
#define UPSTATE_BLUESCREEN 32
#define UPSTATE_WIREEXP 64
#define UPSTATE_ALLGOOD 128

//update_overlay
#define APC_UPOVERLAY_CHARGEING0 1
#define APC_UPOVERLAY_CHARGEING1 2
#define APC_UPOVERLAY_CHARGEING2 4
#define APC_UPOVERLAY_EQUIPMENT0 8
#define APC_UPOVERLAY_EQUIPMENT1 16
#define APC_UPOVERLAY_EQUIPMENT2 32
#define APC_UPOVERLAY_LIGHTING0 64
#define APC_UPOVERLAY_LIGHTING1 128
#define APC_UPOVERLAY_LIGHTING2 256
#define APC_UPOVERLAY_ENVIRON0 512
#define APC_UPOVERLAY_ENVIRON1 1024
#define APC_UPOVERLAY_ENVIRON2 2048
#define APC_UPOVERLAY_LOCKED 4096
#define APC_UPOVERLAY_OPERATING 8192

#define APC_UPDATE_ICON_COOLDOWN 100 // 10 seconds

// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire conection to power network through a terminal

// controls power to devices in that area
// may be opened to change power cell
// three different channels (lighting/equipment/environ) - may each be set to on, off, or auto
#define POWERCHAN_OFF		0
#define POWERCHAN_OFF_AUTO	1
#define POWERCHAN_ON		2
#define POWERCHAN_ON_AUTO	3

//thresholds for channels going off automatically. ENVIRON channel stays on as long as possible, and doesn't have a threshold
#define AUTO_THRESHOLD_LIGHTING		30
#define AUTO_THRESHOLD_EQUIPMENT	15

//NOTE: STUFF STOLEN FROM AIRLOCK.DM thx

/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."
	icon_state = "apc0"
	anchored = 1
	use_power = 0
	req_access = list(access_engine_equip)
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
	powernet = 0		// set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
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

// Variants with different cell configurations for mapping.
/obj/machinery/power/apc/standard/none
	cell_type = null

/obj/machinery/power/apc/standard/potato
	cell_type = /obj/item/weapon/cell/potato

/obj/machinery/power/apc/standard/crap
	cell_type = /obj/item/weapon/cell/crap

/obj/machinery/power/apc/standard/cell
	cell_type = /obj/item/weapon/cell

/obj/machinery/power/apc/standard/apc
	cell_type = /obj/item/weapon/cell/apc

/obj/machinery/power/apc/standard/high
	cell_type = /obj/item/weapon/cell/high

/obj/machinery/power/apc/standard/super
	cell_type = /obj/item/weapon/cell/super

/obj/machinery/power/apc/standard/hyper
	cell_type = /obj/item/weapon/cell/hyper

// These are for disused on-station places, IE the old prison wing or old security dorms.
/obj/machinery/power/apc/disused
	icon_state = "apc1"
	opened = 1
	shorted = 1
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF
	operating = 0
	chargemode = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/disused/none
	cell_type = null

/obj/machinery/power/apc/disused/potato
	cell_type = /obj/item/weapon/cell/potato

/obj/machinery/power/apc/disused/crap
	cell_type = /obj/item/weapon/cell/crap

/obj/machinery/power/apc/disused/cell
	cell_type = /obj/item/weapon/cell

/obj/machinery/power/apc/disused/apc
	cell_type = /obj/item/weapon/cell/apc

/obj/machinery/power/apc/disused/high
	cell_type = /obj/item/weapon/cell/high

/obj/machinery/power/apc/disused/super
	cell_type = /obj/item/weapon/cell/super

/obj/machinery/power/apc/disused/hyper
	cell_type = /obj/item/weapon/cell/hyper

// These are for abandoned off-station places, IE the derelict or white ship.
/obj/machinery/power/apc/abandoned
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF
	operating = 0
	chargemode = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/abandoned/none
	cell_type = null

/obj/machinery/power/apc/abandoned/potato
	cell_type = /obj/item/weapon/cell/potato

/obj/machinery/power/apc/abandoned/crap
	cell_type = /obj/item/weapon/cell/crap

/obj/machinery/power/apc/abandoned/cell
	cell_type = /obj/item/weapon/cell

/obj/machinery/power/apc/abandoned/apc
	cell_type = /obj/item/weapon/cell/apc

/obj/machinery/power/apc/abandoned/high
	cell_type = /obj/item/weapon/cell/high

/obj/machinery/power/apc/abandoned/super
	cell_type = /obj/item/weapon/cell/super

/obj/machinery/power/apc/abandoned/hyper
	cell_type = /obj/item/weapon/cell/hyper

// These are for away mission locations, IE the Academy or Black Market Packers.
/obj/machinery/power/apc/away
	locked = 0

// These are switched fully on, but still unlocked.
/obj/machinery/power/apc/away/on
	lighting = POWERCHAN_ON_AUTO
	equipment = POWERCHAN_ON_AUTO
	environ = POWERCHAN_ON_AUTO

/obj/machinery/power/apc/away/on/none
	cell_type = null

/obj/machinery/power/apc/away/on/potato
	cell_type = /obj/item/weapon/cell/potato

/obj/machinery/power/apc/away/on/crap
	cell_type = /obj/item/weapon/cell/crap

/obj/machinery/power/apc/away/on/cell
	cell_type = /obj/item/weapon/cell

/obj/machinery/power/apc/away/on/apc
	cell_type = /obj/item/weapon/cell/apc

/obj/machinery/power/apc/away/on/high
	cell_type = /obj/item/weapon/cell/high

/obj/machinery/power/apc/away/on/super
	cell_type = /obj/item/weapon/cell/super

/obj/machinery/power/apc/away/on/hyper
	cell_type = /obj/item/weapon/cell/hyper

// These are switched fully off, but still unlocked.
/obj/machinery/power/apc/away/off
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF

/obj/machinery/power/apc/away/off/none
	cell_type = null

/obj/machinery/power/apc/away/off/potato
	cell_type = /obj/item/weapon/cell/potato

/obj/machinery/power/apc/away/off/crap
	cell_type = /obj/item/weapon/cell/crap

/obj/machinery/power/apc/away/off/cell
	cell_type = /obj/item/weapon/cell

/obj/machinery/power/apc/away/off/apc
	cell_type = /obj/item/weapon/cell/apc

/obj/machinery/power/apc/away/off/high
	cell_type = /obj/item/weapon/cell/high

/obj/machinery/power/apc/away/off/super
	cell_type = /obj/item/weapon/cell/super

/obj/machinery/power/apc/away/off/hyper
	cell_type = /obj/item/weapon/cell/hyper
// End variants.

/obj/machinery/power/apc/updateDialog()
	if(stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	if(!terminal)
		make_terminal()
	if(terminal)
		terminal.connect_to_network()

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
	if(cell)
		qdel(cell)
	if(terminal)
		qdel(terminal)
		terminal = null
	return ..()

/obj/machinery/power/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.set_dir(tdir)
	terminal.master = src

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

/obj/machinery/power/apc/examine()
	set src in oview(1)

	if(usr /*&& !usr.stat*/)
		usr << "A control terminal for the area electrical systems."
		..()
		if(stat & BROKEN)
			usr << "Looks broken."
			return

		if(opened)
			if(has_electronics && terminal)
				usr << "The cover is [opened==2?"removed":"open"] and the power cell is [ cell ? "installed" : "missing"]."
			else if (!has_electronics && terminal)
				usr << "There are some wires but no any electronics."
			else if (has_electronics && !terminal)
				usr << "Electronics installed but not wired."
			else /* if (!has_electronics && !terminal) */
				usr << "There is no electronics nor connected wires."

		else
			if (stat & MAINT)
				usr << "The cover is closed. Something wrong with it: it doesn't work."
			else if (malfhack)
				usr << "The cover is broken. It may be hard to force it open."
			else
				usr << "The cover is closed."

// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_icon()
	if (!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 2
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 4
		status_overlays_lighting.len = 4
		status_overlays_environ.len = 4

		status_overlays_lock[1] = image(icon, "apcox-0")    // 0=blue 1=red
		status_overlays_lock[2] = image(icon, "apcox-1")

		status_overlays_charging[1] = image(icon, "apco3-0")
		status_overlays_charging[2] = image(icon, "apco3-1")
		status_overlays_charging[3] = image(icon, "apco3-2")

		status_overlays_equipment[1] = image(icon, "apco0-0")
		status_overlays_equipment[2] = image(icon, "apco0-1")
		status_overlays_equipment[3] = image(icon, "apco0-2")
		status_overlays_equipment[4] = image(icon, "apco0-3")

		status_overlays_lighting[1] = image(icon, "apco1-0")
		status_overlays_lighting[2] = image(icon, "apco1-1")
		status_overlays_lighting[3] = image(icon, "apco1-2")
		status_overlays_lighting[4] = image(icon, "apco1-3")

		status_overlays_environ[1] = image(icon, "apco2-0")
		status_overlays_environ[2] = image(icon, "apco2-1")
		status_overlays_environ[3] = image(icon, "apco2-2")
		status_overlays_environ[4] = image(icon, "apco2-3")

	var/update = check_updates() 		//returns 0 if no need to update icons.
						// 1 if we need to update the icon_state
						// 2 if we need to update the overlays
	if(!update)
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPSTATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPSTATE_OPENED1|UPSTATE_OPENED2))
			var/basestate = "apc[ cell ? "2" : "1" ]"
			if(update_state & UPSTATE_OPENED1)
				if(update_state & (UPSTATE_MAINT|UPSTATE_BROKE))
					icon_state = "apcmaint" //disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPSTATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPSTATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPSTATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPSTATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPSTATE_ALLGOOD))
		if(overlays.len)
			overlays = 0
			return

	if(update & 2)
		if(overlays.len)
			overlays.len = 0

		if(!(stat & (BROKEN|MAINT)) && update_state & UPSTATE_ALLGOOD)
			overlays += status_overlays_lock[locked+1]
			overlays += status_overlays_charging[charging+1]
			if(operating)
				overlays += status_overlays_equipment[equipment+1]
				overlays += status_overlays_lighting[lighting+1]
				overlays += status_overlays_environ[environ+1]

	if(update & 3)
		if(update_state & UPSTATE_BLUESCREEN)
			set_light(l_range = 1, l_power = 1, l_color = "#0000FF")
		else if(!(stat & (BROKEN|MAINT)) && update_state & UPSTATE_ALLGOOD)
			var/color
			switch(charging)
				if(0)
					color = "#F86060"
				if(1)
					color = "#A8B0F8"
				if(2)
					color = "#82FF4C"
			set_light(l_range = 1, l_power = 1, l_color = color)
		else
			set_light(0)

/obj/machinery/power/apc/proc/check_updates()
	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	update_state = 0
	update_overlay = 0

	if(cell)
		update_state |= UPSTATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPSTATE_BROKE
	if(stat & MAINT)
		update_state |= UPSTATE_MAINT
	if(opened)
		if(opened==1)
			update_state |= UPSTATE_OPENED1
		if(opened==2)
			update_state |= UPSTATE_OPENED2
	else if(emagged || malfai)
		update_state |= UPSTATE_BLUESCREEN
	else if(wiresexposed)
		update_state |= UPSTATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPSTATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPSTATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(!charging)
			update_overlay |= APC_UPOVERLAY_CHARGEING0
		else if(charging == 1)
			update_overlay |= APC_UPOVERLAY_CHARGEING1
		else if(charging == 2)
			update_overlay |= APC_UPOVERLAY_CHARGEING2

		if (!equipment)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT0
		else if(equipment == 1)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT1
		else if(equipment == 2)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT2

		if(!lighting)
			update_overlay |= APC_UPOVERLAY_LIGHTING0
		else if(lighting == 1)
			update_overlay |= APC_UPOVERLAY_LIGHTING1
		else if(lighting == 2)
			update_overlay |= APC_UPOVERLAY_LIGHTING2

		if(!environ)
			update_overlay |= APC_UPOVERLAY_ENVIRON0
		else if(environ==1)
			update_overlay |= APC_UPOVERLAY_ENVIRON1
		else if(environ==2)
			update_overlay |= APC_UPOVERLAY_ENVIRON2

	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay)
		results += 2
	return results

// Used in process so it doesn't update the icon too much
/obj/machinery/power/apc/proc/queue_icon_update()
	if(!updating_icon)
		updating_icon = 1
		// Start the update
		spawn(APC_UPDATE_ICON_COOLDOWN)
			update_icon()
			updating_icon = 0

//attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/machinery/power/apc/attackby(obj/item/W, mob/user)
	if(issilicon(user) && get_dist(src, user) > 1)
		return src.attack_hand(user)
	src.add_fingerprint(user)
	if(istype(W, /obj/item/weapon/crowbar) && opened)
		if(has_electronics==1)
			if(terminal)
				user << "<span class='warning'>Disconnect wires first.</span>"
				return
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			user << "You are trying to remove the power control board..." //lpeters - fixed grammar issues
			if(do_after(user, 50))
				if(has_electronics == 1)
					has_electronics = 0
					if ((stat & BROKEN) || malfhack)
						user.visible_message(\
							"<span class='warning'>[user.name] has broken the power control board inside [src.name]!</span>",\
							"<span class='notice'>You broke the charred power control board and remove the remains.</span>",
							"You hear a crack!")
						//ticker.mode:apcs-- //XSI said no and I agreed. -rastaf0
					else
						user.visible_message(\
							"<span class='warning'>[user.name] has removed the power control board from [src.name]!</span>",\
							"<span class='notice'>You remove the power control board.</span>")
						new /obj/item/weapon/module/power_control(loc)
		else if(opened != 2) //cover isn't removed
			opened = 0
			update_icon()
	else if(istype(W, /obj/item/weapon/crowbar) && !((stat & BROKEN) || malfhack))
		if(coverlocked && !(stat & MAINT))
			user << "<span class='warning'>The cover is locked and cannot be opened.</span>"
			return
		else
			opened = 1
			update_icon()
	else if(istype(W, /obj/item/weapon/cell) && opened)	// trying to put a cell inside
		if(cell)
			user << "There is a power cell already installed."
			return
		else
			if(stat & MAINT)
				user << "\red There is no connector for your power cell."
				return
			user.drop_item()
			W.loc = src
			cell = W
			user.visible_message(\
				"<span class='warning'>[user.name] has inserted the power cell to [src.name]!</span>",\
				"<span class='notice'>You insert the power cell.</span>")
			chargecount = 0
			update_icon()
	else if(istype(W, /obj/item/weapon/screwdriver))	// haxing
		if(opened)
			if(cell)
				user << "<span class='warning'>Close the APC first.</span>" //Less hints more mystery!
				return
			else
				if(has_electronics == 1 && terminal)
					has_electronics = 2
					stat &= ~MAINT
					playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
					user << "You screw the circuit electronics into place."
				else if(has_electronics == 2)
					has_electronics = 1
					stat |= MAINT
					playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
					user << "You unfasten the electronics."
				else /* has_electronics==0 */
					user << "<span class='warning'>There is nothing to secure.</span>"
					return
				update_icon()
		else if(emagged)
			user << "The interface is broken."
		else
			wiresexposed = !wiresexposed
			user << "The wires have been [wiresexposed ? "exposed" : "unexposed"]"
			update_icon()

	else if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))			// trying to unlock the interface with an ID card
		if(emagged)
			user << "The interface is broken."
		else if(opened)
			user << "You must close the cover to swipe an ID card."
		else if(wiresexposed)
			user << "You must close the panel"
		else if(stat & (BROKEN|MAINT))
			user << "Nothing happens."
		else
			if(src.allowed(usr) && !isWireCut(APC_WIRE_IDSCAN))
				locked = !locked
				user << "You [ locked ? "lock" : "unlock"] the APC interface."
				update_icon()
			else
				user << "<span class='warning'>Access denied.</span>"
	else if(istype(W, /obj/item/weapon/card/emag) && !(emagged || malfhack))		// trying to unlock with an emag card
		if(opened)
			user << "You must close the cover to swipe an ID card."
		else if(wiresexposed)
			user << "You must close the panel first"
		else if(stat & (BROKEN|MAINT))
			user << "Nothing happens."
		else
			flick("apc-spark", src)
			if(do_after(user, 6))
				if(prob(50))
					emagged = 1
					locked = 0
					user << "You emag the APC interface."
					update_icon()
				else
					user << "<span class='warning'>You fail to [ locked ? "unlock" : "lock"] the APC interface.</span>"
	else if(istype(W, /obj/item/stack/cable_coil) && !terminal && opened && has_electronics != 2)
		if(src.loc:intact)
			user << "<span class='warning'>You must remove the floor plating in front of the APC first.</span>"
			return
		var/obj/item/stack/cable_coil/C = W
		if(C.amount < 10)
			user << "<span class='warning'>You need ten lengths of cable for APC.</span>"
			return
		user << "You start adding cables to the APC frame..."
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20))
			if (C.amount >= 10 && !terminal && opened && has_electronics != 2)
				var/turf/T = get_turf(src)
				var/obj/structure/cable/N = T.get_cable_node()
				if (prob(50) && electrocute_mob(usr, N, N))
					var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					return
				C.use(10)
			user.visible_message("<span class='warning'>[user.name] adds cables to the APC frame.</span>", \
							"You start adding cables to the APC frame...")
			make_terminal()
			terminal.connect_to_network()
	else if(istype(W, /obj/item/weapon/wirecutters) && terminal && opened && has_electronics != 2)
		if(src.loc:intact)
			user << "\red You must remove the floor plating in front of the APC first."
			return
		user << "You begin to cut the cables..."
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50))
			if(terminal && opened && has_electronics!=2)
				if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					return
				new /obj/item/stack/cable_coil(loc,10)
				user << "<span class='notice'>You cut the cables and dismantle the power terminal.</span>"
				qdel(terminal)
	else if (istype(W, /obj/item/weapon/module/power_control) && opened && has_electronics==0 && !((stat & BROKEN) || malfhack))
		user.visible_message("<span class='warning'>[user.name] inserts the power control board into [src].</span>", \
							"You start to insert the power control board into the frame...")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10))
			if(has_electronics == 0)
				has_electronics = 1
				user << "<span class='notice'>You place the power control board inside the frame.</span>"
				qdel(W)
	else if (istype(W, /obj/item/weapon/module/power_control) && opened && has_electronics==0 && ((stat & BROKEN) || malfhack))
		user << "<span class='warning'>You cannot put the board inside, the frame is damaged.</span>"
		return
	else if (istype(W, /obj/item/weapon/weldingtool) && opened && has_electronics==0 && !terminal)
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.get_fuel() < 3)
			user << "\blue You need more welding fuel to complete this task."
			return
		user.visible_message("<span class='warning'>[user.name] welds [src].</span>", \
							"You start welding the APC frame...", \
							"You hear welding.")
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50))
			if(!src || !WT.remove_fuel(3, user)) return
			if (emagged || malfhack || (stat & BROKEN) || opened==2)
				new /obj/item/stack/sheet/metal(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut apart by [user.name] with the weldingtool.</span>",\
					"<span class='notice'>You disassembled the broken APC frame.</span>",\
					"You hear welding.")
			else
				new /obj/item/apc_frame(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut from the wall by [user.name] with the weldingtool.</span>",\
					"<span class='notice'>You cut the APC frame from the wall.</span>",\
					"You hear welding.")
			qdel(src)
			return
	else if (istype(W, /obj/item/apc_frame) && opened && emagged)
		emagged = 0
		if (opened==2)
			opened = 1
		user.visible_message(\
			"<span class='warning'>[user.name] has replaced the damaged APC frontal panel with a new one.</span>",\
			"<span class='notice'>You replace the damaged APC frontal panel with a new one.</span>")
		qdel(W)
		update_icon()
	else if (istype(W, /obj/item/apc_frame) && opened && ((stat & BROKEN) || malfhack))
		if (has_electronics)
			user << "<span class='warning'>You cannot repair this APC until you remove the electronics still inside.</span>"
			return
		user.visible_message("<span class='warning'>[user.name] replaces the damaged APC frame with a new one.</span>",\
							"You begin to replace the damaged APC frame...")
		if(do_after(user, 50))
			user.visible_message(\
				"<span class='notice'>[user.name] has replaced the damaged APC frame with a new one.</span>",\
				"You replace the damaged APC frame with a new one.")
			qdel(W)
			stat &= ~BROKEN
			malfai = null
			malfhack = 0
			if (opened==2)
				opened = 1
			update_icon()
	else
		if (((stat & BROKEN) || malfhack) \
				&& !opened \
				&& W.force >= 5 \
				&& W.w_class >= 3.0 \
				&& prob(20) )
			opened = 2
			user.visible_message("<span class='danger'>The APC cover was knocked down with the [W.name] by [user.name]!</span>", \
				"<span class='danger'>You knock down the APC cover with your [W.name]!</span>", \
				"You hear a bang.")
			update_icon()
		else
			if (issilicon(user))
				return src.attack_hand(user)
			if (!opened && wiresexposed && \
				(istype(W, /obj/item/device/multitool) || \
				istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/device/assembly/signaler)))
				return src.attack_hand(user)
			user.visible_message("\red The [src.name] has been hit with the [W.name] by [user.name]!", \
				"\red You hit the [src.name] with your [W.name]!", \
				"You hear bang")

// attack with hand - remove cell (if cover open) or interact with the APC
/obj/machinery/power/apc/attack_hand(mob/user)
	if(!user)
		return
	src.add_fingerprint(user)

	//Synthetic human mob goes here.
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.flags & IS_SYNTHETIC && H.a_intent == "grab")
			if(emagged || stat & BROKEN)
				var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				H << "\red The APC power currents surge eratically, damaging your chassis!"
				H.adjustFireLoss(10,0)
			else if(src.cell && src.cell.charge > 0)
				if(H.nutrition < 450)

					if(src.cell.charge >= 500)
						H.nutrition += 50
						src.cell.charge -= 500
					else
						H.nutrition += src.cell.charge/10
						src.cell.charge = 0

					user << "\blue You slot your fingers into the APC interface and siphon off some of the stored charge for your own use."
					if(src.cell.charge < 0) src.cell.charge = 0
					if(H.nutrition > 500) H.nutrition = 500
					src.charging = 1

				else
					user << "\blue You are already fully charged."
			else
				user << "There is no charge to draw from that APC."
			return

	if(usr == user && opened && (!issilicon(user)))
		if(cell)
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.updateicon()

			src.cell = null
			user.visible_message("<span class='warning'>[user.name] removes the power cell from [src.name]!</span>",\
								 "<span class='notice'>You remove the power cell.</span>")
			charging = 0
			src.update_icon()
		return
	if(stat & (BROKEN|MAINT))
		return

	// do APC interaction
	src.interact(user)

/obj/machinery/power/apc/interact(mob/user)
	if(!user)
		return

	if(wiresexposed /*&& (!issilicon(user))*/) //Commented out the typecheck to allow engiborgs to repair damaged apcs.
		wires.Interact(user)

	// Open the APC NanoUI
	return ui_interact(user)

/obj/machinery/power/apc/proc/get_malf_status(mob/user)
	if(ticker && ticker.mode && (user.mind in ticker.mode.malf_ai) && istype(user, /mob/living/silicon/ai))
		if(src.malfai == (user:parent ? user:parent : user))
			if(src.occupant == user)
				return 3 // 3 = User is shunted in this APC
			else if(istype(user.loc, /obj/machinery/power/apc))
				return 4 // 4 = User is shunted in another APC
			else
				return 2 // 2 = APC hacked by user, and user is in its core.
		else
			return 1 // 1 = APC not hacked.
	else
		return 0 // 0 = User is not a Malf AI

/obj/machinery/power/apc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	if(!user)
		return

	var/list/data = list(
		"locked" = locked,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = round(lastused_total),
		"totalCharging" = round(lastused_charging),
		"coverLocked" = coverlocked,
		"malfStatus" = get_malf_status(user),

		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = lastused_equip,
				"status" = equipment,
				"topicParams" = list(
					"auto"	= list("eqp" = 3),
					"on"	= list("eqp" = 2),
					"off"	= list("eqp" = 1)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = lastused_light,
				"status" = lighting,
				"topicParams" = list(
					"auto"	= list("lgt" = 3),
					"on"	= list("lgt" = 2),
					"off"	= list("lgt" = 1)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = lastused_environ,
				"status" = environ,
				"topicParams" = list(
					"auto"	= list("env" = 3),
					"on"	= list("env" = 2),
					"off"	= list("env" = 1)
				)
			)
		)
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "apc.tmpl", "[area.name] - APC", 520, data["siliconUser"] ? 465 : 440)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip+lastused_light+lastused_environ]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/update()
	if(operating && !shorted)
		//prevent unnecessary updates to emergency lighting
		var/new_power_light = (lighting >= POWERCHAN_ON)
		if(area.power_light != new_power_light)
			area.power_light = new_power_light
			area.set_emergency_lighting(lighting == POWERCHAN_OFF_AUTO) //if lights go auto-off, emergency lights go on
		area.power_equip = (equipment >= POWERCHAN_ON)
		area.power_environ = (environ >= POWERCHAN_ON)
	else
		area.power_light = 0
		area.power_equip = 0
		area.power_environ = 0
	area.power_change()

/obj/machinery/power/apc/proc/isWireCut(wireIndex)
	return wires.IsIndexCut(wireIndex)

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
				(istype(AI) && (malfai!=AI && malfai != AI.parent)) ||		\
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

/obj/machinery/power/apc/proc/toggle_breaker()
	operating = !operating

	if(malfai)
		if(ticker.mode.config_tag == "malfunction")
			if(src.z in config.station_levels) //if (is_type_in_list(get_area(src), the_station_areas))
				operating ? ticker.mode:apcs++ : ticker.mode:apcs--

	src.update()
	update_icon()

/obj/machinery/power/apc/proc/malfoccupy(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		to_chat(malf, SPAN_WARNING("You must evacuate your current apc first."))
		return
	if(isNotStationLevel(src.z))
		return
	src.occupant = new /mob/living/silicon/ai(src, malf.laws, null, 1)
	src.occupant.adjustOxyLoss(malf.getOxyLoss())
	if(!findtext(src.occupant.name,"APC Copy"))
		src.occupant.name = "[malf.name] APC Copy"
	if(malf.parent)
		src.occupant.parent = malf.parent
	else
		src.occupant.parent = malf
	malf.mind.transfer_to(src.occupant)
	src.occupant.eyeobj.name = "[src.occupant.name] (AI Eye)"
	if(malf.parent)
		qdel(malf)
	src.occupant.verbs += /mob/living/silicon/ai/proc/corereturn
	src.occupant.verbs += /datum/game_mode/malfunction/proc/takeover
	src.occupant.cancel_camera()

/obj/machinery/power/apc/proc/malfvacate(forced)
	if(!src.occupant)
		return
	if(src.occupant.parent && src.occupant.parent.stat != DEAD)
		src.occupant.mind.transfer_to(src.occupant.parent)
		src.occupant.parent.adjustOxyLoss(src.occupant.getOxyLoss())
		src.occupant.parent.cancel_camera()
		qdel(src.occupant)
		if(seclevel2num(get_security_level()) == SEC_LEVEL_DELTA)
			for(var/obj/item/weapon/pinpointer/point in world)
				for(var/datum/mind/AI_mind in ticker.mode.malf_ai)
					var/mob/living/silicon/ai/A = AI_mind.current // the current mob the mind owns
					if(A.stat != DEAD)
						point.the_disk = A //The pinpointer tracks the AI back into its core.
	else
		to_chat(src.occupant, SPAN_WARNING("Primary core damaged, unable to return core processes."))
		if(forced)
			src.occupant.loc = src.loc
			src.occupant.death()
			src.occupant.gib()
			for(var/obj/item/weapon/pinpointer/point in world)
				point.the_disk = null //the pinpointer will go back to pointing at the nuke disc.


/obj/machinery/power/apc/proc/ion_act()
	//intended to be exactly the same as an AI malf attack
	if(!src.malfhack && src.z in config.station_levels)
		if(prob(3))
			src.locked = 1
			if(src.cell.charge > 0)
//				world << "\red blew APC in [src.loc.loc]"
				src.cell.charge = 0
				cell.corrupt()
				src.malfhack = 1
				update_icon()
				var/datum/effect/system/smoke_spread/smoke = new /datum/effect/system/smoke_spread()
				smoke.set_up(3, 0, src.loc)
				smoke.attach(src)
				smoke.start()
				var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				visible_message(
					SPAN_DANGER("The [src.name] suddenly lets out a blast of smoke and some sparks!"),
					SPAN_DANGER("You hear sizzling electronics.")
				)

/obj/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/machinery/power/apc/proc/last_surplus()
	if(terminal && terminal.powernet)
		return terminal.powernet.last_surplus()
	else
		return 0

//Returns 1 if the APC should attempt to charge
/obj/machinery/power/apc/proc/attempt_charging()
	return (chargemode && charging == 1 && operating)

/obj/machinery/power/apc/draw_power(amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/machinery/power/apc/avail()
	if(terminal)
		return terminal.avail()
	else
		return 0

/obj/machinery/power/apc/process()
	if(stat & (BROKEN | MAINT))
		return
	if(!area.requires_power)
		return

	lastused_light = area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_environ = area.usage(ENVIRON)
	lastused_total = lastused_light + lastused_equip + lastused_environ
	area.clear_usage()

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!src.avail())
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	if(cell && !shorted)
		// draw power from cell as before to power the area
		var/cellused = min(cell.charge, CELLRATE * lastused_total)	// clamp deduction to a max, amount left in cell
		cell.use(cellused)

		if(excess > lastused_total)		// if power excess recharge the cell
										// by the same amount just used
			var/draw = draw_power(cellused/CELLRATE) // draw the power needed to charge this cell
			cell.give(draw * CELLRATE)
		else		// no excess, and not enough per-apc
			if((cell.charge/CELLRATE + excess) >= lastused_total)		// can we draw enough from cell+grid to cover last usage?
				var/draw = draw_power(excess)
				cell.charge = min(cell.maxcharge, cell.charge + CELLRATE * draw)	//recharge with what we can
				charging = 0
			else	// not enough power available to run the last tick!
				charging = 0
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				autoflag = 0

		// Set channels depending on how much charge we have left

		// Allow the APC to operate as normal if the cell can charge
		if(charging && longtermpower < 10)
			longtermpower += 1
		else if(longtermpower > -10)
			longtermpower -= 2

		if(cell.percent() >= AUTO_THRESHOLD_LIGHTING || longtermpower > 0)			// Put most likely at the top so we don't check it last, effeciency 101
			if(autoflag != 3)
				equipment = autoset(equipment, 1)
				lighting = autoset(lighting, 1)
				environ = autoset(environ, 1)
				autoflag = 3
				area.poweralert(1, src)
				if(cell.percent() >= 80)
					area.poweralert(1, src)

		else if(cell.percent() < AUTO_THRESHOLD_LIGHTING && cell.percent() > AUTO_THRESHOLD_EQUIPMENT && longtermpower < 0)		// <30%, turn off lighting
			if(autoflag != 2)
				equipment = autoset(equipment, 1)
				lighting = autoset(lighting, 2)
				environ = autoset(environ, 1)
				area.poweralert(0, src)
				autoflag = 2

		else if(cell.percent() < AUTO_THRESHOLD_EQUIPMENT)	// <15%, turn off lighting & equipment
			if((autoflag > 1 && longtermpower < 0) || (autoflag > 1 && longtermpower >= 0))
				equipment = autoset(equipment, 2)
				lighting = autoset(lighting, 2)
				environ = autoset(environ, 1)
				area.poweralert(0, src)
				autoflag = 1

		else if(cell.charge <= 0)							// zero charge, turn all off
			if(autoflag != 0)
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				area.poweralert(0, src)
				autoflag = 0

		// now trickle-charge the cell
		lastused_charging = 0 // Clear the variable for new use.
		if(src.attempt_charging())
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is capped to % per second constant
				var/ch = min(excess * CELLRATE, cell.maxcharge * CHARGELEVEL)

				ch = draw_power(ch / CELLRATE) // Removes the power we're taking from the grid
				cell.give(ch * CELLRATE) // actually recharge the cell

				lastused_charging = ch
				lastused_total += ch // Sensors need this to stop reporting APC charging as "Other" load
			else
				charging = 0		// stop charging
				chargecount = 0

		// show cell as fully charged if so
		if(cell.charge >= cell.maxcharge)
			cell.charge = cell.maxcharge
			charging = 2

		//if we have excess power for long enough, think about re-enable charging.
		if(chargemode)
			if(!charging)
				if(excess > cell.maxcharge * CHARGELEVEL)
					chargecount++
				else
					chargecount = 0
					charging = 0

				if(chargecount >= 10)
					chargecount = 0
					charging = 1

		else // chargemode off
			charging = 0
			chargecount = 0

	else // no cell, switch everything off
		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		area.poweralert(0, src)
		autoflag = 0

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ)
		queue_icon_update()
		update()

	else if(last_ch != charging)
		queue_icon_update()

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff
// defines a state machine, returns the new state
/obj/machinery/power/apc/proc/autoset(cur_state, on)
	switch(cur_state)
		if(POWERCHAN_OFF) //autoset will never turn on a channel set to off
		if(POWERCHAN_OFF_AUTO)
			if(on == 1)
				return POWERCHAN_ON_AUTO
		if(POWERCHAN_ON)
			if(on == 0)
				return POWERCHAN_OFF
		if(POWERCHAN_ON_AUTO)
			if(on == 0 || on == 2)
				return POWERCHAN_OFF_AUTO

	return cur_state //leave unchanged

// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	if(cell)
		cell.emp_act(severity)
	if(occupant)
		occupant.emp_act(severity)
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF
	spawn(600)
		equipment = POWERCHAN_ON_AUTO
		environ = POWERCHAN_ON_AUTO
	..()

/obj/machinery/power/apc/ex_act(severity)
	switch(severity)
		if(1.0)
			if(cell)
				cell.ex_act(1.0) // more lags woohoo
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				set_broken()
				if(cell && prob(50))
					cell.ex_act(2.0)
		if(3.0)
			if(prob(25))
				set_broken()
				if(cell && prob(25))
					cell.ex_act(3.0)
	return

/obj/machinery/power/apc/blob_act()
	if(prob(75))
		set_broken()
		if(cell && prob(5))
			cell.blob_act()

/obj/machinery/power/apc/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/apc/proc/set_broken()
	if(malfai && operating)
		if(ticker.mode.config_tag == "malfunction")
			if(src.z in config.station_levels) //if (is_type_in_list(get_area(src), the_station_areas))
				ticker.mode:apcs--
	stat |= BROKEN
	operating = 0
	if(occupant)
		malfvacate(1)
	update_icon()
	update()

// overload all the lights in this APC area
/obj/machinery/power/apc/proc/overload_lighting()
	if(/* !get_connection() || */ !operating || shorted)
		return
	if(cell && cell.charge >= 20)
		cell.use(20);
		spawn(0)
			for(var/obj/machinery/light/L in area)
				L.on = 1
				L.broken()
				sleep(1)

/obj/machinery/power/apc/proc/setsubsystem(val)
	if(cell && cell.charge > 0)
		return (val == 1) ? 0 : val
	else if(val == 3)
		return 1
	else
		return 0

/obj/machinery/power/apc/proc/shock(mob/user, prb)
	if(!prob(prb))
		return 0
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, src, src))
		return 1
	else
		return 0

#undef APC_UPDATE_ICON_COOLDOWN