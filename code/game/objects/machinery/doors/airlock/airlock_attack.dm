/obj/machinery/door/airlock/attack_hand(mob/user)
	if(!issilicon(usr))
		if(isElectrified())
			if(shock(user, 100))
				return
		// If the door's bolted closed, then flash as if we're denied. -Frenjo
		if(locked && p_open)
			do_animate("deny")

	// No. -- cib
	// Uncommented as of 30/10/2019...
	// Yes. -Frenjo
	if(ishuman(user) && prob(40) && density)
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 60)
			playsound(src, 'sound/effects/bang.ogg', 25, 1)
			if(!istype(H.head, /obj/item/clothing/head/helmet))
				visible_message(SPAN_WARNING("[user] headbutts the airlock."))
				var/datum/organ/external/affecting = H.get_organ("head")
				H.Stun(8)
				H.Weaken(5)
				if(affecting.take_damage(10, 0))
					H.UpdateDamageIcon()
			else
				visible_message(SPAN_WARNING("[user] headbutts the airlock. Good thing they're wearing a helmet."))
			return

	if(p_open)
		user.set_machine(src)
		var/t1 = "<B>Access Panel</B><br>\n"

		//t1 += text("[]: ", airlockFeatureNames[airlockWireColorToIndex[9]])
		var/list/wires = list(
			"Orange" = 1,
			"Dark red" = 2,
			"White" = 3,
			"Yellow" = 4,
			"Red" = 5,
			"Blue" = 6,
			"Green" = 7,
			"Grey" = 8,
			"Black" = 9,
			"Gold" = 10,
			"Aqua" = 11,
			"Pink" = 12
		)
		for(var/wiredesc in wires)
			var/is_uncut = wires & airlockWireColorToFlag[wires[wiredesc]]
			t1 += "[wiredesc] wire: "
			if(!is_uncut)
				t1 += "<a href='byond://?src=\ref[src];wires=[wires[wiredesc]]'>Mend</a>"
			else
				t1 += "<a href='byond://?src=\ref[src];wires=[wires[wiredesc]]'>Cut</a> "
				t1 += "<a href='byond://?src=\ref[src];pulse=[wires[wiredesc]]'>Pulse</a> "
				if(signalers[wires[wiredesc]])
					t1 += "<a href='byond://?src=\ref[src];remove-signaler=[wires[wiredesc]]'>Detach signaler</a>"
				else
					t1 += "<a href='byond://?src=\ref[src];signaler=[wires[wiredesc]]'>Attach signaler</a>"
			t1 += "<br>"

		t1 += "<br>\n[(locked ? "The door bolts have fallen!" : "The door bolts look up.")]<br>\n[(lights ? "The door bolt lights are on." : "The door bolt lights are off!")]<br>\n[((arePowerSystemsOn() && !(stat & NOPOWER)) ? "The test light is on." : "The test light is off!")]<br>\n[(!aiControlDisabled == AIRLOCK_AI_CONTROL_ENABLED ? "The 'AI control allowed' light is on." : "The 'AI control allowed' light is off.")]<br>\n[(!safe ? "The 'Check Wiring' light is on." : "The 'Check Wiring' light is off.")]<br>\n[(!normalspeed ? "The 'Check Timing Mechanism' light is on." : "The 'Check Timing Mechanism' light is off.")]"

		t1 += "<p><a href='byond://?src=\ref[src];close=1'>Close</a></p>\n"

		user << browse(t1, "window=airlock")
		onclose(user, "airlock")

	else
		..(user)

/obj/machinery/door/airlock/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/door/airlock/attack_ai(mob/user)
	if(!canAIControl())
		if(canAIHack())
			hack(user)
			return
		else
			to_chat(user, "Airlock AI control has been blocked with a firewall. Unable to hack.")

	//Separate interface for the AI.
	user.set_machine(src)
	var/t1 = "<B>Airlock Control</B><br>\n"
	if(secondsMainPowerLost > 0)
		if(!isWireCut(AIRLOCK_WIRE_MAIN_POWER1) && !isWireCut(AIRLOCK_WIRE_MAIN_POWER2))
			t1 += "Main power is offline for [secondsMainPowerLost] seconds.<br>\n"
		else
			t1 += "Main power is offline indefinitely.<br>\n"
	else
		t1 += "Main power is online."

	if(secondsBackupPowerLost > 0)
		if(!isWireCut(AIRLOCK_WIRE_BACKUP_POWER1) && !isWireCut(AIRLOCK_WIRE_BACKUP_POWER2))
			t1 += "Backup power is offline for [secondsBackupPowerLost] seconds.<br>\n"
		else
			t1 += "Backup power is offline indefinitely.<br>\n"
	else if(secondsMainPowerLost > 0)
		t1 += "Backup power is online."
	else
		t1 += "Backup power is offline, but will turn on if main power fails."
	t1 += "<br>\n"

	if(isWireCut(AIRLOCK_WIRE_IDSCAN))
		t1 += "IdScan wire is cut.<br>\n"
	else if(aiDisabledIdScanner)
		t1 += "IdScan disabled. <A href='byond://?src=\ref[src];aiEnable=1'>Enable?</a><br>\n"
	else
		t1 += "IdScan enabled. <A href='byond://?src=\ref[src];aiDisable=1'>Disable?</a><br>\n"

	if(isWireCut(AIRLOCK_WIRE_MAIN_POWER1))
		t1 += "Main Power Input wire is cut.<br>\n"
	if(isWireCut(AIRLOCK_WIRE_MAIN_POWER2))
		t1 += "Main Power Output wire is cut.<br>\n"
	if(secondsMainPowerLost == 0)
		t1 += "<A href='byond://?src=\ref[src];aiDisable=2'>Temporarily disrupt main power?</a>.<br>\n"
	if(secondsBackupPowerLost == 0)
		t1 += "<A href='byond://?src=\ref[src];aiDisable=3'>Temporarily disrupt backup power?</a>.<br>\n"

	if(isWireCut(AIRLOCK_WIRE_BACKUP_POWER1))
		t1 += "Backup Power Input wire is cut.<br>\n"
	if(isWireCut(AIRLOCK_WIRE_BACKUP_POWER2))
		t1 += "Backup Power Output wire is cut.<br>\n"

	if(isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
		t1 += "Door bolt drop wire is cut.<br>\n"
	else if(!locked)
		t1 += "Door bolts are up. <A href='byond://?src=\ref[src];aiDisable=4'>Drop them?</a><br>\n"
	else
		t1 += "Door bolts are down."
		if(arePowerSystemsOn())
			t1 += " <A href='byond://?src=\ref[src];aiEnable=4'>Raise?</a><br>\n"
		else
			t1 += " Cannot raise door bolts due to power failure.<br>\n"

	if(isWireCut(AIRLOCK_WIRE_LIGHT))
		t1 += "Door bolt lights wire is cut.<br>\n"
	else if(!lights)
		t1 += "Door lights are off. <A href='byond://?src=\ref[src];aiEnable=10'>Enable?</a><br>\n"
	else
		t1 += "Door lights are on. <A href='byond://?src=\ref[src];aiDisable=10'>Disable?</a><br>\n"

	if(isWireCut(AIRLOCK_WIRE_ELECTRIFY))
		t1 += "Electrification wire is cut.<br>\n"
	if(secondsElectrified == -1)
		t1 += "Door is electrified indefinitely. <A href='byond://?src=\ref[src];aiDisable=5'>Un-electrify it?</a><br>\n"
	else if(secondsElectrified > 0)
		t1 += "Door is electrified temporarily ([secondsElectrified] seconds). <A href='byond://?src=\ref[src];aiDisable=5'>Un-electrify it?</a><br>\n"
	else
		t1 += "Door is not electrified. <A href='byond://?src=\ref[src];aiEnable=5'>Electrify it for 30 seconds?</a> Or, <A href='byond://?src=\ref[src];aiEnable=6'>Electrify it indefinitely until someone cancels the electrification?</a><br>\n"

	if(isWireCut(AIRLOCK_WIRE_SAFETY))
		t1 += "Door force sensors not responding.</a><br>\n"
	else if(safe)
		t1 += "Door safeties operating normally. <A href='byond://?src=\ref[src];aiDisable=8'> Override?</a><br>\n"
	else
		t1 += "Danger. Door safeties disabled. <A href='byond://?src=\ref[src];aiEnable=8'> Restore?</a><br>\n"

	if(isWireCut(AIRLOCK_WIRE_SPEED))
		t1 += "Door timing circuitry not responding.</a><br>\n"
	else if(normalspeed)
		t1 += "Door timing circuitry operating normally. <A href='byond://?src=\ref[src];aiDisable=9'> Override?</a><br>\n"
	else
		t1 += "Warning.  Door timing circuitry operating abnormally. <A href='byond://?src=\ref[src];aiEnable=9'> Restore?</a><br>\n"

	if(welded)
		t1 += "Door appears to have been welded shut.<br>\n"
	else if(!locked)
		if(density)
			t1 += "<A href='byond://?src=\ref[src];aiEnable=7'>Open door</a><br>\n"
		else
			t1 += "<A href='byond://?src=\ref[src];aiDisable=7'>Close door</a><br>\n"

	t1 += "<p><a href='byond://?src=\ref[src];close=1'>Close</a></p>\n"
	user << browse(t1, "window=airlock")
	onclose(user, "airlock")

//aiDisable - 1 idscan, 2 disrupt main power, 3 disrupt backup power, 4 drop door bolts, 5 un-electrify door, 7 close door
//aiEnable - 1 idscan, 4 raise door bolts, 5 electrify door for 30 seconds, 6 electrify door indefinitely, 7 open door

/obj/machinery/door/airlock/proc/hack(mob/user)
	if(!aiHacking)
		aiHacking = TRUE
		spawn(20)
			//TODO: Make this take a minute
			to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
			sleep(50)
			if(canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				aiHacking = FALSE
				return
			else if(!canAIHack())
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				aiHacking = FALSE
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attempting to hack into airlock. This may take some time.")
			sleep(200)
			if(canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				aiHacking = FALSE
				return
			else if(!canAIHack())
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				aiHacking = FALSE
				return
			to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
			sleep(170)
			if(canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				aiHacking = FALSE
				return
			else if(!canAIHack())
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				aiHacking = FALSE
				return
			to_chat(user, "Transfer complete. Forcing airlock to execute program.")
			sleep(50)
			//disable blocked control
			aiControlDisabled = AIRLOCK_AI_CONTROL_HACKED
			to_chat(user, "Receiving control information from airlock.")
			sleep(10)
			//bring up airlock dialog
			aiHacking = FALSE
			if(isnotnull(user))
				attack_ai(user)

/obj/machinery/door/airlock/attack_tool(obj/item/tool, mob/user)
	add_fingerprint(user)
	if(!issilicon(usr)) // If there's ever a handler that's before attack_tool, move this there.
		if(isElectrified())
			if(shock(user, 75))
				return TRUE

	if(istype(tool, /obj/item/taperoll))
		return TRUE

	if(iswelder(tool) && !(operating > 0) && density)
		var/obj/item/weldingtool/welder = tool
		if(!welder.remove_fuel(0, user))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("[user] starts to [welded ? "un" : ""]weld \the [src][welded ? "" : " shut"]."),
			SPAN_NOTICE("You start to [welded ? "un" : ""]weld \the [src][welded ? "" : " shut"]."),
			SPAN_WARNING("You hear welding.")
		)
		playsound(src, 'sound/items/Welder2.ogg', 50, 1)
		if(do_after(user, 2 SECONDS))
			welded = !welded
			user.visible_message(
				SPAN_NOTICE("[user] [welded ? "" : "un"]welds \the [src][welded ? " shut" : ""]."),
				SPAN_NOTICE("You [welded ? "" : "un"]weld \the [src][welded ? " shut" : ""].")
			)
			update_icon()
		return TRUE

	if(isscrewdriver(tool))
		p_open = !p_open
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, p_open)
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		update_icon()
		return TRUE

	if(iswirecutter(tool) || ismultitool(tool) || istype(tool, /obj/item/assembly/signaler))
		return attack_hand(user)

	if(istype(tool, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = tool
		cable.plugin(src, user)
		return TRUE

	return ..()

/obj/machinery/door/airlock/attackby(obj/item/C, mob/user)
	if(iscrowbar(C) || istype(C, /obj/item/twohanded/fireaxe))
		var/beingcrowbarred = iscrowbar(C) //derp, Agouri
		if(beingcrowbarred && (operating == -1 || density && welded && operating != 1 && p_open && (!arePowerSystemsOn() || stat & NOPOWER) && !locked))
			playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message(
				SPAN_NOTICE("[user] starts to remove the electronics from the airlock assembly."),
				SPAN_NOTICE("You start to remove the electronics from the airlock assembly.")
			)
			if(do_after(user, 4 SECONDS))
				user.visible_message(
					SPAN_NOTICE("[user] removes the electronics from the airlock assembly."),
					SPAN_NOTICE("You remove the electronics from the airlock assembly.")
				)
				var/obj/structure/door_assembly/da = new assembly_type(loc)
				da.anchored = TRUE
				if(isnotnull(mineral))
					da.glass = mineral
				//else if(glass)
				else if(glass && !da.glass)
					da.glass = TRUE
				da.state = 1
				da.created_name = name
				da.update_state()

				var/obj/item/airlock_electronics/ae
				if(isnull(electronics))
					ae = new /obj/item/airlock_electronics(loc)
					if(isnull(req_access))
						check_access()
					if(length(req_access))
						ae.conf_access = req_access
					else if(length(req_one_access))
						ae.conf_access = req_one_access
						ae.one_access = TRUE
				else
					ae = electronics
					electronics = null
					ae.forceMove(loc)
				if(operating == -1)
					ae.icon_state = "door_electronics_smoked"
					operating = 0

				qdel(src)
			return TRUE

		if(arePowerSystemsOn() && !(stat & NOPOWER))
			to_chat(user, SPAN_WARNING("The airlock's motors resist your efforts to force it."))
			return TRUE
		else if(locked)
			to_chat(user, SPAN_WARNING("The airlock's bolts prevent it from being forced."))
			return TRUE
		else if(!welded && !operating)
			if(density)
				if(!beingcrowbarred) //being fireaxe'd
					var/obj/item/twohanded/fireaxe/F = C
					if(F.wielded)
						spawn(0)
							open(TRUE)
					else
						to_chat(user, SPAN_WARNING("You need to be wielding the fire axe to do that."))
				else
					spawn(0)
						open(TRUE)
			else
				if(!beingcrowbarred)
					var/obj/item/twohanded/fireaxe/F = C
					if(F.wielded)
						spawn(0)
							close(TRUE)
					else
						to_chat(user, SPAN_WARNING("You need to be wielding the fire axe to do that."))
				else
					spawn(0)
						close(TRUE)
			return TRUE

	return ..()

/obj/machinery/door/airlock/plasma/attackby(obj/item/C, mob/user)
	if(isnotnull(C))
		ignite(is_hot(C))
	. = ..()