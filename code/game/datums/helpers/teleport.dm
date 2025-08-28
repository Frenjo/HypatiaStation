//wrapper
/proc/do_teleport(ateleatom, adestination, aprecision = 0, afteleport = 1, aeffectin = null, aeffectout = null, asoundin = null, asoundout = null)
	new /datum/teleport/instant/science(arglist(args))
	return

/datum/teleport
	var/atom/movable/teleatom //atom to teleport
	var/atom/destination //destination to teleport to
	var/precision = 0 //teleport precision
	var/datum/effect/system/effectin //effect to show right before teleportation
	var/datum/effect/system/effectout //effect to show right after teleportation
	var/soundin //soundfile to play before teleportation
	var/soundout //soundfile to play after teleportation
	var/force_teleport = 1 //if false, teleport will use Move() proc (dense objects will prevent teleportation)

/datum/teleport/New(ateleatom, adestination, aprecision = 0, afteleport = 1, aeffectin = null, aeffectout = null, asoundin = null, asoundout = null)
	..()
	if(!Init(arglist(args)))
		return 0
	return 1

/datum/teleport/proc/Init(ateleatom, adestination, aprecision, afteleport, aeffectin, aeffectout, asoundin, asoundout)
	if(!setTeleatom(ateleatom))
		return 0
	if(!setDestination(adestination))
		return 0
	if(!setPrecision(aprecision))
		return 0
	setEffects(aeffectin, aeffectout)
	setForceTeleport(afteleport)
	setSounds(asoundin, asoundout)
	return 1

//must succeed
/datum/teleport/proc/setPrecision(aprecision)
	if(isnum(aprecision))
		precision = aprecision
		return 1
	return 0

//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	if(istype(adestination))
		destination = adestination
		return 1
	return 0

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return 0
	if(istype(ateleatom))
		teleatom = ateleatom
		return 1
	return 0

//custom effects must be properly set up first for instant-type teleports
//optional
/datum/teleport/proc/setEffects(datum/effect/system/aeffectin = null, datum/effect/system/aeffectout = null)
	effectin = istype(aeffectin) ? aeffectin : null
	effectout = istype(aeffectout) ? aeffectout : null
	return 1

//optional
/datum/teleport/proc/setForceTeleport(afteleport)
	force_teleport = afteleport
	return 1

//optional
/datum/teleport/proc/setSounds(asoundin = null, asoundout = null)
	soundin = isfile(asoundin) ? asoundin : null
	soundout = isfile(asoundout) ? asoundout : null
	return 1

//placeholder
/datum/teleport/proc/teleportChecks()
	return 1

/datum/teleport/proc/playSpecials(atom/location, datum/effect/system/effect, sound)
	if(location)
		if(effect)
			effect.attach(location)
			effect.start()
		if(sound)
			playsound(location, sound, 60, 1)
	return

//do the monkey dance
/datum/teleport/proc/doTeleport()
	var/turf/destturf
	var/turf/curturf = GET_TURF(teleatom)
	var/area/destarea = GET_AREA(destination)
	if(precision)
		var/list/posturfs = circlerangeturfs(destination, precision)
		destturf = safepick(posturfs)
	else
		destturf = GET_TURF(destination)

	if(isnull(destturf) || isnull(curturf))
		return 0

	playSpecials(curturf, effectin, soundin)

	if(force_teleport)
		teleatom.forceMove(destturf)
		playSpecials(destturf, effectout, soundout)
	else
		if(teleatom.Move(destturf))
			playSpecials(destturf, effectout, soundout)

	destarea.Entered(teleatom)

	return 1

/datum/teleport/proc/teleport()
	if(teleportChecks())
		return doTeleport()
	return 0

/datum/teleport/instant //teleports when datum is created

/datum/teleport/instant/New(ateleatom, adestination, aprecision = 0, afteleport = 1, aeffectin = null, aeffectout = null, asoundin = null, asoundout = null)
	if(..())
		teleport()
	return


/datum/teleport/instant/science/setEffects(datum/effect/system/aeffectin, datum/effect/system/aeffectout)
	if(!aeffectin || !aeffectout)
		var/datum/effect/system/spark_spread/aeffect = new
		aeffect.set_up(5, 1, teleatom)
		effectin = effectin || aeffect
		effectout = effectout || aeffect
		return 1
	else
		return ..()

/datum/teleport/instant/science/setPrecision(aprecision)
	..()
	if(istype(teleatom, /obj/item/storage/backpack/holding))
		precision = rand(1, 100)

	var/list/bagholding = teleatom.search_contents_for(/obj/item/storage/backpack/holding)
	if(length(bagholding))
		precision = max(rand(1, 100) * length(bagholding), 100)
		if(isliving(teleatom))
			var/mob/living/MM = teleatom
			to_chat(MM, SPAN_WARNING("The bluespace interface on your Bag of Holding interferes with the teleport!"))
	return 1

/datum/teleport/instant/science/teleportChecks()
	if(istype(teleatom, /obj/item/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		teleatom.visible_message(SPAN_DANGER("The [teleatom] bounces off of the portal!"))
		return 0

	if(!isemptylist(teleatom.search_contents_for(/obj/item/disk/nuclear)))
		if(isliving(teleatom))
			var/mob/living/MM = teleatom
			MM.visible_message(SPAN_DANGER("The [MM] bounces off of the portal!"), \
							SPAN_WARNING("Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through."))
		else
			teleatom.visible_message(SPAN_DANGER("The [teleatom] bounces off of the portal!"))
		return 0

	if(destination.z == 2) //centcom z-level
		if(ismecha(teleatom))
			var/obj/mecha/MM = teleatom
			to_chat(MM.occupant, SPAN_DANGER("The mech would not survive the jump to a location so far away!"))
			return 0
		if(!isemptylist(teleatom.search_contents_for(/obj/item/storage/backpack/holding)))
			teleatom.visible_message(SPAN_DANGER("The Bag of Holding bounces off of the portal!"))
			return 0

	if(destination.z > 7) //Away mission z-levels
		return 0
	return 1

/*
 * Finds a safe turf on a given Z level
 *
 * Finds a safe turf on a given Z level and has safety checks
 * Arguments:
 * * zlevel - Z-level to check for a safe turf
 * * zlevels - list of z-levels to check for a safe turf
 * * extended_safety_checks - check for lava
 */
/proc/find_safe_turf(zlevel, list/zlevels, dense_atoms = TRUE)
	if(!zlevels)
		if(zlevel)
			zlevels = list(zlevel)
		else
			return null

	var/cycles = 1000
	for(var/cycle in 1 to cycles)
		// DRUNK DIALLING WOOOOOOOOO
		var/x = rand(1, world.maxx)
		var/y = rand(1, world.maxy)
		var/z = pick(zlevels)
		var/turf/random_location = locate(x, y, z)

		if(!isfloorturf(random_location))
			continue
		var/turf/open/floor/F = random_location
		var/datum/gas_mixture/A = F.return_air()
		if(isnull(A))
			continue

		// Can most things breathe?
		if(A.gas[/decl/xgm_gas/oxygen] < 16)
			continue
		if(isnotnull(A.gas[/decl/xgm_gas/plasma]))
			continue
		if(A.gas[/decl/xgm_gas/carbon_dioxide] >= 10)
			continue

		// Aim for goldilocks temperatures and pressure
		if(A.temperature <= 270 || A.temperature >= 360)
			continue
		var/pressure = A.return_pressure()
		if(pressure <= 20 || pressure >= 550)
			continue

		// Check that we're not warping onto a table or window
		if(!dense_atoms)
			var/density_found = FALSE
			for_no_type_check(var/atom/movable/found_movable, F)
				if(found_movable.density)
					density_found = TRUE
					break
			if(density_found)
				continue

		// DING! You have passed the gauntlet, and are "probably" safe.
		return F