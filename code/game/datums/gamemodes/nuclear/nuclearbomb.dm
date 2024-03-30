var/bomb_set

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = TRUE

	power_state = USE_POWER_OFF

	var/deployable = 0.0
	var/extended = 0.0
	var/lighthack = 0
	var/opened = 0.0
	var/timeleft = 60.0
	var/timing = 0.0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0.0
	var/safety = 1.0
	var/obj/item/disk/nuclear/auth = null
	var/list/wires = list()
	var/light_wire
	var/safety_wire
	var/timing_wire
	var/removal_stage = 0	// 0 is no removal, 1 is covers removed, 2 is covers open,
							// 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.

/obj/machinery/nuclearbomb/New()
	..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.

	src.wires["Red"] = 0
	src.wires["Blue"] = 0
	src.wires["Green"] = 0
	src.wires["Marigold"] = 0
	src.wires["Fuschia"] = 0
	src.wires["Black"] = 0
	src.wires["Pearl"] = 0
	var/list/w = list(
		"Red",
		"Blue",
		"Green",
		"Marigold",
		"Black",
		"Fuschia",
		"Pearl"
	)
	src.light_wire = pick(w)
	w -= src.light_wire
	src.timing_wire = pick(w)
	w -= src.timing_wire
	src.safety_wire = pick(w)
	w -= src.safety_wire

/obj/machinery/nuclearbomb/process()
	if(src.timing)
		bomb_set = 1 //So long as there is one nuke timing, it means one nuke is armed.
		src.timeleft--
		if(src.timeleft <= 0)
			explode()
		for(var/mob/M in viewers(1, src))
			if((M.client && M.machine == src))
				src.attack_hand(M)
	return

/obj/machinery/nuclearbomb/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		add_fingerprint(user)
		if(auth)
			opened = !opened
			if(opened)
				overlays.Add(image(icon, "npanel_open"))
				to_chat(user, SPAN_NOTICE("You unscrew the control panel of \the [src]."))
			else
				overlays.Remove(image(icon, "npanel_open"))
				to_chat(user, SPAN_NOTICE("You screw the control panel of \the [src] back on."))
		else
			if(!opened)
				to_chat(user, SPAN_WARNING("\The [src] emits a buzzing noise and the panel stays locked in."))
			else
				opened = FALSE
				overlays.Remove(image(icon, "npanel_open"))
				to_chat(user, SPAN_NOTICE("You screw the control panel of \the [src] back on."))
			flick("nuclearbombc", src)
		return TRUE

	if(iswirecutter(tool) || ismultitool(tool))
		if(opened)
			nukehack_win(user)
			return TRUE

	if(anchored)
		switch(removal_stage)
			if(0)
				if(iswelder(tool))
					var/obj/item/weldingtool/welder = tool
					if(!welder.isOn())
						return TRUE
					if(welder.get_fuel() < 5) // uses up 5 fuel.
						FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
						return TRUE
					user.visible_message(
						SPAN_NOTICE("[user] starts cutting loose the anchoring bolt covers on \the [src]..."),
						SPAN_NOTICE("You start cutting loose the anchoring bolt covers with \the [welder]..."),
						SPAN_WARNING("You hear welding.")
					)
					if(do_after(user, 4 SECONDS))
						if(!welder.remove_fuel(5, user))
							return TRUE
						user.visible_message(
							SPAN_NOTICE("[user] cuts through the bolt covers on \the [src]."),
							SPAN_NOTICE("You cut through the bolt cover.")
						)
						removal_stage = 1
					return TRUE

			if(1)
				if(iscrowbar(tool))
					user.visible_message(
						SPAN_NOTICE("[user] starts forcing open the bolt covers on \the [src]..."),
						SPAN_NOTICE("You start forcing open the anchoring bolt covers with \the [tool]...")
					)
					if(do_after(user, 1.5 SECONDS))
						if(isnull(src) || isnull(user))
							return TRUE
						user.visible_message(
							SPAN_NOTICE("[user] forces open the bolt covers on \the [src]."),
							SPAN_NOTICE("You force open the bolt covers.")
						)
						removal_stage = 2
					return TRUE

			if(2)
				if(iswelder(tool))
					var/obj/item/weldingtool/welder = tool
					if(!welder.isOn())
						return TRUE
					if(welder.get_fuel() < 5) // uses up 5 fuel.
						FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
						return TRUE
					user.visible_message(
						SPAN_NOTICE("[user] starts cutting apart the anchoring system sealant on \the [src]..."),
						SPAN_NOTICE("You start cutting apart the anchoring system's sealant with \the [tool]...")
					)
					if(do_after(user, 40))
						if(isnull(src) || isnull(user) || !welder.remove_fuel(5, user))
							return TRUE
						user.visible_message(
							SPAN_NOTICE("[user] cuts apart the anchoring system sealant on \the [src]."),
							SPAN_NOTICE("You cut apart the anchoring system's sealant.")
						)
						removal_stage = 3
					return TRUE

			if(3)
				if(iswrench(tool))
					user.visible_message(
						SPAN_NOTICE("[user] begins unwrenching the anchoring bolts on \the [src]..."),
						SPAN_NOTICE("You begin unwrenching the anchoring bolts..."),
						SPAN_INFO("You hear a ratchet.")
					)
					if(do_after(user, 5 SECONDS))
						if(isnull(src) || isnull(user))
							return TRUE
						user.visible_message(
							SPAN_NOTICE("[user] unwrenches the anchoring bolts on \the [src]."),
							SPAN_NOTICE("You unwrench the anchoring bolts.")
						)
						removal_stage = 4
					return TRUE

			if(4)
				if(iscrowbar(tool))
					user.visible_message(
						SPAN_NOTICE("[user] begins lifting \the [src] off of the anchors..."),
						SPAN_NOTICE("You begin lifting the device off the anchors...")
					)

					if(do_after(user, 80))
						if(!src || !user)
							return TRUE
						user.visible_message(
							SPAN_NOTICE("[user] crowbars \the [src] off of the anchors. It can now be moved."),
							SPAN_NOTICE("You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!")
						)
						anchored = FALSE
						removal_stage = 5
					return TRUE

	return ..()

/obj/machinery/nuclearbomb/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/disk/nuclear))
		if(extended)
			user.drop_item()
			I.loc = src
			auth = I
			add_fingerprint(user)
		return TRUE
	return ..()

/obj/machinery/nuclearbomb/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(src.extended)
		if(!ishuman(user))
			FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
			return 1

		user.set_machine(src)
		var/dat = "<TT><B>Nuclear Fission Explosive</B><BR>\nAuth. Disk: <A href='?src=\ref[src];auth=1'>[(src.auth ? "++++++++++" : "----------")]</A><HR>"
		if(src.auth)
			if(src.yes_code)
				dat += "\n<B>Status</B>: [(src.timing ? "Func/Set" : "Functional")]-[(src.safety ? "Safe" : "Engaged")]<BR>\n<B>Timer</B>: [src.timeleft]<BR>\n<BR>\nTimer: [(src.timing ? "On" : "Off")] <A href='?src=\ref[src];timer=1'>Toggle</A><BR>\nTime: <A href='?src=\ref[src];time=-10'>-</A> <A href='?src=\ref[src];time=-1'>-</A> [src.timeleft] <A href='?src=\ref[src];time=1'>+</A> <A href='?src=\ref[src];time=10'>+</A><BR>\n<BR>\nSafety: [(src.safety ? "On" : "Off")] <A href='?src=\ref[src];safety=1'>Toggle</A><BR>\nAnchor: [(src.anchored ? "Engaged" : "Off")] <A href='?src=\ref[src];anchor=1'>Toggle</A><BR>\n"
			else
				dat += "\n<B>Status</B>: Auth. S2-[(src.safety ? "Safe" : "Engaged")]<BR>\n<B>Timer</B>: [src.timeleft]<BR>\n<BR>\nTimer: [(src.timing ? "On" : "Off")] Toggle<BR>\nTime: - - [src.timeleft] + +<BR>\n<BR>\nSafety: [(src.safety ? "On" : "Off")] Toggle<BR>\nAnchor: [(src.anchored ? "Engaged" : "Off")] Toggle<BR>\n"
		else
			if(src.timing)
				dat += "\n<B>Status</B>: Set-[(src.safety ? "Safe" : "Engaged")]<BR>\n<B>Timer</B>: [src.timeleft]<BR>\n<BR>\nTimer: [(src.timing ? "On" : "Off")] Toggle<BR>\nTime: - - [src.timeleft] + +<BR>\n<BR>\nSafety: [(src.safety ? "On" : "Off")] Toggle<BR>\nAnchor: [(src.anchored ? "Engaged" : "Off")] Toggle<BR>\n"
			else
				dat += "\n<B>Status</B>: Auth. S1-[(src.safety ? "Safe" : "Engaged")]<BR>\n<B>Timer</B>: [src.timeleft]<BR>\n<BR>\nTimer: [(src.timing ? "On" : "Off")] Toggle<BR>\nTime: - - [src.timeleft] + +<BR>\n<BR>\nSafety: [(src.safety ? "On" : "Off")] Toggle<BR>\nAnchor: [(src.anchored ? "Engaged" : "Off")] Toggle<BR>\n"
		var/message = "AUTH"
		if(src.auth)
			message = "[src.code]"
			if(src.yes_code)
				message = "*****"
		dat += "<HR>\n>[message]<BR>\n<A href='?src=\ref[src];type=1'>1</A>-<A href='?src=\ref[src];type=2'>2</A>-<A href='?src=\ref[src];type=3'>3</A><BR>\n<A href='?src=\ref[src];type=4'>4</A>-<A href='?src=\ref[src];type=5'>5</A>-<A href='?src=\ref[src];type=6'>6</A><BR>\n<A href='?src=\ref[src];type=7'>7</A>-<A href='?src=\ref[src];type=8'>8</A>-<A href='?src=\ref[src];type=9'>9</A><BR>\n<A href='?src=\ref[src];type=R'>R</A>-<A href='?src=\ref[src];type=0'>0</A>-<A href='?src=\ref[src];type=E'>E</A><BR>\n</TT>"
		user << browse(dat, "window=nuclearbomb;size=300x400")
		onclose(user, "nuclearbomb")
	else if(src.deployable)
		if(removal_stage < 5)
			src.anchored = TRUE
			visible_message(SPAN_WARNING("With a steely snap, bolts slide out of [src] and anchor it to the flooring!"))
		else
			visible_message(SPAN_WARNING("\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut."))
		if(!src.lighthack)
			flick("nuclearbombc", src)
			src.icon_state = "nuclearbomb1"
		src.extended = 1
	return

/obj/machinery/nuclearbomb/proc/nukehack_win(mob/user as mob)
	var/dat
	dat += "<TT><B>Nuclear Fission Explosive</B><BR>\nNuclear Device Wires:</A><HR>"
	for(var/wire in src.wires)
		dat += "[wire] Wire: <A href='?src=\ref[src];wire=[wire];act=wire'>[src.wires[wire] ? "Mend" : "Cut"]</A> <A href='?src=\ref[src];wire=[wire];act=pulse'>Pulse</A><BR>"
	dat += "<HR>The device is [src.timing ? "shaking!" : "still"]<BR>"
	dat += "The device is [src.safety ? "quiet" : "whirring"].<BR>"
	dat += "The lights are [src.lighthack ? "static" : "functional"].<BR>"
	user << browse("<HTML><HEAD><TITLE>Bomb Defusion</TITLE></HEAD><BODY>[dat]</BODY></HTML>","window=nukebomb_hack")
	onclose(user, "nukebomb_hack")

/obj/machinery/nuclearbomb/verb/make_deployable()
	set category = PANEL_OBJECT
	set name = "Make Deployable"
	set src in oview(1)

	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(!ishuman(usr))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return 1

	if(src.deployable)
		to_chat(usr, SPAN_WARNING("You close several panels to make [src] undeployable."))
		src.deployable = 0
	else
		to_chat(usr, SPAN_WARNING("You adjust some panels to make [src] deployable."))
		src.deployable = 1
	return


/obj/machinery/nuclearbomb/Topic(href, href_list)
	..()
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(src.loc)))
		usr.set_machine(src)
		if(href_list["act"])
			var/temp_wire = href_list["wire"]
			if(href_list["act"] == "pulse")
				if(!istype(usr.get_active_hand(), /obj/item/multitool))
					to_chat(usr, "You need a multitool!")
				else
					if(src.wires[temp_wire])
						to_chat(usr, "You can't pulse a cut wire.")
					else
						if(src.light_wire == temp_wire)
							src.lighthack = !src.lighthack
							spawn(100) src.lighthack = !src.lighthack
						if(src.timing_wire == temp_wire)
							if(src.timing)
								explode()
						if(src.safety_wire == temp_wire)
							src.safety = !src.safety
							spawn(100) src.safety = !src.safety
							if(src.safety == 1)
								visible_message(SPAN_INFO("The [src] quiets down."))
								if(!src.lighthack)
									if(src.icon_state == "nuclearbomb2")
										src.icon_state = "nuclearbomb1"
							else
								visible_message(SPAN_INFO("The [src] emits a quiet whirling noise!"))
			if(href_list["act"] == "wire")
				if(!istype(usr.get_active_hand(), /obj/item/wirecutters))
					to_chat(usr, "You need wirecutters!")
				else
					wires[temp_wire] = !wires[temp_wire]
					if(src.safety_wire == temp_wire)
						if(src.timing)
							explode()
					if(src.timing_wire == temp_wire)
						if(!src.lighthack)
							if(src.icon_state == "nuclearbomb2")
								src.icon_state = "nuclearbomb1"
						src.timing = 0
						bomb_set = 0
					if(src.light_wire == temp_wire)
						src.lighthack = !src.lighthack

		if(href_list["auth"])
			if(src.auth)
				src.auth.loc = src.loc
				src.yes_code = 0
				src.auth = null
			else
				var/obj/item/I = usr.get_active_hand()
				if(istype(I, /obj/item/disk/nuclear))
					usr.drop_item()
					I.loc = src
					src.auth = I
		if(src.auth)
			if(href_list["type"])
				if(href_list["type"] == "E")
					if(src.code == src.r_code)
						src.yes_code = 1
						src.code = null
					else
						src.code = "ERROR"
				else
					if(href_list["type"] == "R")
						src.yes_code = 0
						src.code = null
					else
						src.code += "[href_list["type"]]"
						if(length(src.code) > 5)
							src.code = "ERROR"
			if(src.yes_code)
				if(href_list["time"])
					var/time = text2num(href_list["time"])
					src.timeleft += time
					src.timeleft = min(max(round(src.timeleft), 60), 600)
				if(href_list["timer"])
					if(src.timing == -1.0)
						return
					if(src.safety)
						to_chat(usr, SPAN_WARNING("The safety is still on."))
						return
					src.timing = !src.timing
					if(src.timing)
						if(!src.lighthack)
							src.icon_state = "nuclearbomb2"
						if(!src.safety)
							bomb_set = 1//There can still be issues with this reseting when there are multiple bombs. Not a big deal tho for Nuke/N
							set_security_level(/decl/security_level/delta) // Trigger alert level delta when the bomb is activated. -Frenjo
						else
							bomb_set = 0
					else
						bomb_set = 0
						set_security_level(/decl/security_level/red) // Lower to level red when the timer's stopped. -Frenjo
						if(!src.lighthack)
							src.icon_state = "nuclearbomb1"
				if(href_list["safety"])
					src.safety = !src.safety
					if(safety)
						src.timing = 0
						bomb_set = 0
						set_security_level(/decl/security_level/red) // Lower to level red when the safety's put back on. -Frenjo
				if(href_list["anchor"])
					if(removal_stage == 5)
						src.anchored = FALSE
						visible_message(SPAN_WARNING("\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut."))
						return

					src.anchored = !src.anchored
					if(src.anchored)
						visible_message(SPAN_WARNING("With a steely snap, bolts slide out of [src] and anchor it to the flooring."))
					else
						visible_message(SPAN_WARNING("The anchoring bolts slide back into the depths of [src]."))

		src.add_fingerprint(usr)
		for(var/mob/M in viewers(1, src))
			if((M.client && M.machine == src))
				src.attack_hand(M)
	else
		usr << browse(null, "window=nuclearbomb")
		return
	return


/obj/machinery/nuclearbomb/ex_act(severity)
	return

/obj/machinery/nuclearbomb/blob_act()
	if(src.timing == -1.0)
		return
	else
		return ..()

#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/explode()
	if(src.safety)
		src.timing = 0
		return
	src.timing = -1.0
	src.yes_code = 0
	src.safety = 1
	if(!src.lighthack)
		src.icon_state = "nuclearbomb3"
	playsound(src,'sound/machines/Alarm.ogg', 100, 0, 5)
	global.PCticker?.mode?.explosion_in_progress = 1
	sleep(100)

	GLOBL.enter_allowed = FALSE

	var/off_station = 0
	var/turf/bomb_location = get_turf(src)
	if(bomb_location && isstationlevel(bomb_location.z))
		if(bomb_location.x < (128 - NUKERANGE) || bomb_location.x > (128 + NUKERANGE) || bomb_location.y < (128 - NUKERANGE) || bomb_location.y > (128 + NUKERANGE))
			off_station = 1
	else
		off_station = 2

	if(global.PCticker)
		if(IS_GAME_MODE(/datum/game_mode/nuclear))
			var/datum/game_mode/nuclear/nuclear = global.PCticker.mode
			var/obj/machinery/computer/shuttle_control/multi/syndicate/syndie_location = locate(/obj/machinery/computer/shuttle_control/multi/syndicate)
			if(syndie_location)
				nuclear.syndies_didnt_escape = (syndie_location.z > 1 ? 0 : 1)	//muskets will make me change this, but it will do for now
			nuclear.nuke_off_station = off_station
		global.PCticker.station_explosion_cinematic(off_station, null)
		if(isnotnull(global.PCticker.mode))
			global.PCticker.mode.explosion_in_progress = 0
			if(IS_GAME_MODE(/datum/game_mode/nuclear))
				var/datum/game_mode/nuclear/nuclear = global.PCticker.mode
				nuclear.nukes_left --
			else
				to_world("<B>The station was destoyed by the nuclear blast!</B>")

			global.PCticker.mode.station_was_nuked = (off_station < 2)	//offstation == 1 is a draw. the station becomes irradiated and needs to be evacuated.
																//kinda shit but I couldn't  get permission to do what I wanted to do.

			if(!global.PCticker.mode.check_finished())//If the mode does not deal with the nuke going off so just reboot because everyone is stuck as is
				to_world("<B>Resetting in 30 seconds!</B>")

				feedback_set_details("end_error", "nuke - unhandled ending")

				if(blackbox)
					blackbox.save_all_data_to_sql()
				sleep(300)
				log_game("Rebooting due to nuclear detonation")
				world.Reboot()
				return
	return
#undef NUKERANGE

/obj/item/disk/nuclear/Destroy()
	if(length(GLOBL.blobstart))
		var/obj/D = new /obj/item/disk/nuclear(pick(GLOBL.blobstart))
		message_admins("[src] has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
		log_game("[src] has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).")
	return ..()