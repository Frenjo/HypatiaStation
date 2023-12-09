/*
	New methods:
	pulse - sends a pulse into a wire for hacking purposes
	cut - cuts a wire and makes any necessary state changes
	mend - mends a wire and makes any necessary state changes
	isWireColorCut - returns 1 if that color wire is cut, or 0 if not
	isWireCut - returns 1 if that wire (e.g. AIRLOCK_WIRE_DOOR_BOLTS) is cut, or 0 if not
	canAIControl - 1 if the AI can control the airlock, 0 if not (then check canAIHack to see if it can hack in)
	canAIHack - 1 if the AI can hack into the airlock to recover control, 0 if not. Also returns 0 if the AI does not *need* to hack it.
	arePowerSystemsOn - 1 if the main or backup power are functioning, 0 if not. Does not check whether the power grid is charged or an APC has equipment on or anything like that. (Check (stat & NOPOWER) for that)
	requiresIDs - 1 if the airlock is requiring IDs, 0 if not
	isAllPowerCut - 1 if the main and backup power both have cut wires.
	regainMainPower - handles the effect of main power coming back on.
	loseMainPower - handles the effect of main power going offline. Usually (if one isn't already running) spawn a thread to count down how long it will be offline - counting down won't happen if main power was completely cut along with backup power, though, the thread will just sleep.
	loseBackupPower - handles the effect of backup power going offline.
	regainBackupPower - handles the effect of main power coming back on.
	shock - has a chance of electrocuting its target.
*/
/obj/machinery/door/airlock
	name = "Airlock"
	icon = 'icons/obj/doors/interior.dmi'
	icon_state = "door_closed"

	power_channel = ENVIRON

	secondsElectrified = 0 //How many seconds remain until the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	autoclose = TRUE
	normalspeed = TRUE

	// See __airlock_defines.dm.
	var/aiControlDisabled = AIRLOCK_AI_CONTROL_ENABLED
	var/hackProof = FALSE // If TRUE, this door can't be hacked by the AI.
	var/aiHacking = FALSE
	var/aiDisabledIdScanner = FALSE

	var/secondsMainPowerLost = 0 //The number of seconds until power is restored.
	var/secondsBackupPowerLost = 0 //The number of seconds until power is restored.
	var/spawnPowerRestoreRunning = 0

	var/welded = null
	var/locked = FALSE
	var/lights = TRUE // bolt lights show by default
	var/wires = 4095

	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/list/signalers[12]
	var/lockdownbyai = 0

	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null
	var/justzap = FALSE
	var/safe = TRUE

	var/obj/item/airlock_electronics/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening

/obj/machinery/door/airlock/New()
	. = ..()
	GLOBL.airlocks_list.Add(src)

/obj/machinery/door/airlock/initialize()
	. = ..()
	if(isnotnull(closeOtherId))
		for(var/obj/machinery/door/airlock/A in GLOBL.airlocks_list)
			if(A.closeOtherId == closeOtherId && A != src)
				closeOther = A
				break

/obj/machinery/door/airlock/Destroy()
	GLOBL.airlocks_list.Remove(src)
	return ..()

/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(isElectrified())
			if(!justzap)
				if(shock(user, 100))
					justzap = TRUE
					spawn(10)
						justzap = FALSE
					return
			else /*if(justzap)*/
				return
		else if(user.hallucination > 50 && prob(10) && operating == 0)
			to_chat(user, SPAN_DANGER("You feel a powerful shock course through your body!"))
			user.halloss += 10
			user.stunned += 10
			return
		// If the door's bolted, then flash as if we're denied. -Frenjo
		if(locked)
			do_animate("deny")
	. = ..(user)

/obj/machinery/door/airlock/bumpopen(mob/living/simple_animal/user as mob)
	. = ..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(secondsElectrified != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/canAIControl()
	return (aiControlDisabled != AIRLOCK_AI_CONTROL_HACK_REQUIRED && !isAllPowerCut());

/obj/machinery/door/airlock/proc/canAIHack()
	return (aiControlDisabled == AIRLOCK_AI_CONTROL_HACK_REQUIRED && !hackProof && !isAllPowerCut());

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	return (secondsMainPowerLost == 0 || secondsBackupPowerLost == 0)

/obj/machinery/door/airlock/requiresID()
	return !(isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerCut()
	var/retval = FALSE
	if(isWireCut(AIRLOCK_WIRE_MAIN_POWER1) || isWireCut(AIRLOCK_WIRE_MAIN_POWER2))
		if(isWireCut(AIRLOCK_WIRE_BACKUP_POWER1) || isWireCut(AIRLOCK_WIRE_BACKUP_POWER2))
			retval = TRUE
	return retval

/obj/machinery/door/airlock/update_icon()
	if(isnotnull(overlays))
		overlays.Cut()
	if(density)
		if(locked && lights)
			icon_state = "door_locked"
		else
			icon_state = "door_closed"
		if(p_open || welded)
			overlays = list()
			if(p_open)
				overlays.Add(image(icon, "panel_open"))
			if(welded)
				overlays.Add(image(icon, "welded"))
	else
		icon_state = "door_open"

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			if(isnotnull(overlays))
				overlays.Cut()
			if(p_open)
				flick("o_door_opening", src)
			else
				flick("door_opening", src)
		if("closing")
			if(isnotnull(overlays))
				overlays.Cut()
			if(p_open)
				flick("o_door_closing", src)
			else
				flick("door_closing", src)
		if("spark")
			flick("door_spark", src)
		if("deny")
			flick("door_deny", src)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(isElectrified())
		if(isitem(mover))
			var/obj/item/i = mover
			if(i.matter_amounts[MATERIAL_METAL])
				var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread()
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/attackby(C as obj, mob/user as mob)
	//to_world("airlock attackby src [src] obj [C] mob [user]")
	if(!issilicon(usr))
		if(isElectrified())
			if(shock(user, 75))
				return
	if(istype(C, /obj/item/detective_scanner) || istype(C, /obj/item/taperoll))
		return

	add_fingerprint(user)
	if((istype(C, /obj/item/weldingtool) && !(operating > 0) && density))
		var/obj/item/weldingtool/W = C
		if(W.remove_fuel(0, user))
			if(!welded)
				welded = TRUE
			else
				welded = FALSE
			update_icon()
			return
		else
			return
	else if(istype(C, /obj/item/screwdriver))
		p_open = !p_open
		update_icon()
	else if(istype(C, /obj/item/wirecutters))
		return attack_hand(user)
	else if(istype(C, /obj/item/multitool))
		return attack_hand(user)
	else if(istype(C, /obj/item/assembly/signaler))
		return attack_hand(user)
	else if(istype(C, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = C
		cable.plugin(src, user)
	else if(istype(C, /obj/item/crowbar) || istype(C, /obj/item/twohanded/fireaxe))
		var/beingcrowbarred = FALSE
		if(istype(C, /obj/item/crowbar))
			beingcrowbarred = TRUE //derp, Agouri
		else
			beingcrowbarred = FALSE
		if(beingcrowbarred && (operating == -1 || density && welded && operating != 1 && p_open && (!arePowerSystemsOn() || stat & NOPOWER) && !locked))
			playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message(
				"[user] removes the electronics from the airlock assembly.",
				"You start to remove electronics from the airlock assembly."
			)
			if(do_after(user, 40))
				to_chat(user, SPAN_INFO("You removed the airlock electronics!"))

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
					ae.loc = loc
				if(operating == -1)
					ae.icon_state = "door_electronics_smoked"
					operating = 0

				qdel(src)
				return
		else if(arePowerSystemsOn() && !(stat & NOPOWER))
			to_chat(user, SPAN_INFO("The airlock's motors resist your efforts to force it."))
		else if(locked)
			to_chat(user, SPAN_INFO("The airlock's bolts prevent it from being forced."))
		else if(!welded && !operating)
			if(density)
				if(!beingcrowbarred) //being fireaxe'd
					var/obj/item/twohanded/fireaxe/F = C
					if(F.wielded)
						spawn(0)
							open(TRUE)
					else
						to_chat(user, SPAN_WARNING("You need to be wielding the Fire axe to do that."))
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
						to_chat(user, SPAN_WARNING("You need to be wielding the Fire axe to do that."))
				else
					spawn(0)
						close(TRUE)
	else
		. = ..()

/obj/machinery/door/airlock/plasma/attackby(C as obj, mob/user as mob)
	if(isnotnull(C))
		ignite(is_hot(C))
	. = ..()

/obj/machinery/door/airlock/open(forced = FALSE)
	if(operating || welded || locked)
		return 0
	if(!forced)
		if(!arePowerSystemsOn() || (stat & NOPOWER) || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return 0
	//use_power(50)
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	// Edited this so it actually works. -Frenjo
	if(istype(src, /obj/machinery/door/airlock/glass))
		playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	else if(istype(src, /obj/machinery/door/airlock/clown))
		playsound(src, 'sound/machines/airlock.ogg', 30, 1) //Play the airlock as well as clown noise, it's still an airlock. -Frenjo
		playsound(src, 'sound/items/bikehorn.ogg', 30, 1)
	else
		playsound(src, 'sound/machines/airlock.ogg', 30, 1)
	if(isnotnull(closeOther) && istype(closeOther, /obj/machinery/door/airlock) && !closeOther.density)
		closeOther.close()
	return ..()

/obj/machinery/door/airlock/close(forced = FALSE)
	if(operating || welded || locked)
		return
	if(!forced)
		if(!arePowerSystemsOn() || (stat & NOPOWER) || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
			return
	if(safe)
		for(var/turf/turf in locs)
			if(locate(/mob/living) in turf)
				// Uncommented sound to play when door is blocked. -Frenjo
				playsound(src, 'sound/machines/buzz-two.ogg', 25, 0)	//THE BUZZING IT NEVER STOPS	-Pete
				spawn(60)
					close()
				return

	for(var/turf/turf in locs)
		for(var/mob/living/M in turf)
			if(isrobot(M))
				M.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
			else
				M.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
				M.SetStunned(5)
				M.SetWeakened(5)
				var/obj/effect/stop/S = new /obj/effect/stop()
				S.victim = M
				S.loc = M.loc
				spawn(20)
					qdel(S)
				M.emote("scream")
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(M)

	//use_power(50)
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	// Edited this so it actually works. -Frenjo
	if(istype(src, /obj/machinery/door/airlock/glass))
		playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	else if(istype(src, /obj/machinery/door/airlock/clown))
		playsound(src, 'sound/machines/airlock.ogg', 30, 1) //Play the airlock as well as clown noise, it's still an airlock. -Frenjo
		playsound(src, 'sound/items/bikehorn.ogg', 30, 1)
	else
		playsound(src, 'sound/machines/airlock.ogg', 30, 1)
	for(var/turf/turf in locs)
		var/obj/structure/window/killthis = (locate(/obj/structure/window) in turf)
		if(isnotnull(killthis))
			killthis.ex_act(2)//Smashin windows
	. = ..()

/obj/machinery/door/airlock/proc/prison_open()
	locked = FALSE
	open()
	locked = TRUE