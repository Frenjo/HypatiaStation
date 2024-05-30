/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'
	opacity = FALSE
	time_to_live = 300
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE	//PASS_FLAG_GLASS is fine here, it's just so the visual effect can "flow" around glass

/obj/effect/smoke/chem/New()
	. = ..()
	create_reagents(500)


/datum/effect/system/smoke_spread/chem
	smoke_type = /obj/effect/smoke/chem

	// A list of typepaths of reagents which affect walls.
	var/static/list/wall_affecting_reagents = list(/datum/reagent/thermite, /datum/reagent/toxin/plantbgone)
	// A list of typepaths of reagents which have a high (75%) chance to affect turfs.
	var/static/list/turf_applied_reagents_high = list(/datum/reagent/carbon)
	// A list of typepaths of reagents which have a low (25%) chance to affect turfs.
	var/static/list/turf_applied_reagents_low = list(/datum/reagent/blood, /datum/reagent/radium, /datum/reagent/uranium)

	var/obj/chemholder
	var/range
	var/list/targetTurfs
	var/list/wallList
	var/density

/datum/effect/system/smoke_spread/chem/New()
	. = ..()
	chemholder = new /obj()
	chemholder.create_reagents(500)

//------------------------------------------
//Sets up the chem smoke effect
//
// Calculates the max range smoke can travel, then gets all turfs in that view range.
// Culls the selected turfs to a (roughly) circle shape, then calls smokeFlow() to make
// sure the smoke can actually path to the turfs. This culls any turfs it can't reach.
//------------------------------------------
/datum/effect/system/smoke_spread/chem/set_up(datum/reagents/carry = null, n = 10, c = 0, loca, direct)
	range = n * 0.3
	cardinals = c
	carry.copy_to(chemholder, carry.total_volume)

	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)
	if(isnull(location))
		return

	targetTurfs = list()

	//build affected area list
	for(var/turf/T in view(range, location))
		//cull turfs to circle
		if(cheap_pythag(T.x - location.x, T.y - location.y) <= range)
			targetTurfs += T

	//make secondary list for reagents that affect walls
	if(chemholder.reagents.has_reagent("thermite") || chemholder.reagents.has_reagent("plantbgone"))
		wallList = list()

	//pathing check
	smokeFlow(location, targetTurfs, wallList)

	//set the density of the cloud - for diluting reagents
	density = max(1, length(targetTurfs) / 4)	//clamp the cloud density minimum to 1 so it cant multiply the reagents

	//Admin messaging
	var/contained = ""
	for(var/reagent in carry.reagent_list)
		contained += " [reagent] "
	if(contained)
		contained = "\[[contained]\]"
	var/area/A = get_area(location)

	var/where = "[A.name] | [location.x], [location.y]"
	var/whereLink = "<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>[where]</a>"

	if(carry.my_atom.last_fingerprints)
		var/mob/M = get_mob_by_key(carry.my_atom.last_fingerprints)
		var/more = ""
		if(isnotnull(M))
			more = "(<A href='byond://?_src_=holder;adminmoreinfo=\ref[M]'>?</a>)"
		message_admins("A chemical smoke reaction has taken place in ([whereLink])[contained]. Last associated key is [carry.my_atom.last_fingerprints][more].", 0, 1)
		log_game("A chemical smoke reaction has taken place in ([where])[contained]. Last associated key is [carry.my_atom.last_fingerprints].")
	else
		message_admins("A chemical smoke reaction has taken place in ([whereLink]). No associated key.", 0, 1)
		log_game("A chemical smoke reaction has taken place in ([where])[contained]. No associated key.")

//------------------------------------------
//Runs the chem smoke effect
//
// Spawns damage over time loop for each reagent held in the cloud.
// Applies reagents to walls that affect walls (only thermite and plant-b-gone at the moment).
// Also calculates target locations to spawn the visual smoke effect on, so the whole area
// is covered fairly evenly.
//------------------------------------------
/datum/effect/system/smoke_spread/chem/start()
	if(isnull(location))	//kill grenade if it somehow ends up in nullspace
		return

	//reagent application - only run if there are extra reagents in the smoke
	if(length(chemholder.reagents.reagent_list))
		for(var/datum/reagent/R in chemholder.reagents.reagent_list)
			var/proba = 100
			var/runs = 5

			//dilute the reagents according to cloud density
			R.volume /= density
			chemholder.reagents.update_total()

			//apply wall affecting reagents to walls
			if(R.type in wall_affecting_reagents)
				for(var/turf/T in wallList)
					R.reaction_turf(T, R.volume)

			//reagents that should be applied to turfs in a random pattern
			if(R.type in turf_applied_reagents_high)
				proba = 75
			else if(R.type in turf_applied_reagents_low)
				proba = 25

			spawn(0)
				for(var/i = 0, i < runs, i++)
					for(var/turf/T in targetTurfs)
						if(prob(proba))
							R.reaction_turf(T, R.volume)
						for(var/atom/A in T.contents)
							if(istype(A, /obj/effect/smoke/chem))	//skip the item if it is chem smoke
								continue
							else if(ismob(A))
								var/dist = cheap_pythag(T.x - location.x, T.y - location.y)
								if(!dist)
									dist = 1
								R.reaction_mob(A, volume = R.volume / dist)
							else if(isobj(A))
								R.reaction_obj(A, R.volume)
					sleep(30)

	//build smoke icon
	var/color = mix_colour_from_reagents(chemholder.reagents.reagent_list)
	var/icon/I
	if(color)
		I = icon('icons/effects/chemsmoke.dmi')
		I += color
	else
		I = icon('icons/effects/96x96.dmi', "smoke")

	//distance between each smoke cloud
	var/const/arcLength = 2.3559

	//calculate positions for smoke coverage - then spawn smoke
	for(var/i = 0, i < range, i++)
		var/radius = i * 1.5
		if(!radius)
			spawn(0)
				spawnSmoke(location, I, 1)
			continue

		var/offset = 0
		var/points = round((radius * 2 * PI) / arcLength)
		var/angle = round(ToDegrees(arcLength / radius), 1)

		if(!IsInteger(radius))
			offset = 45		//degrees

		for(var/j = 0, j < points, j++)
			var/a = (angle * j) + offset
			var/x = round(radius * cos(a) + location.x, 1)
			var/y = round(radius * sin(a) + location.y, 1)
			var/turf/T = locate(x,y,location.z)
			if(isnull(T))
				continue
			if(T in targetTurfs)
				spawn(0)
					spawnSmoke(T, I, range)

//------------------------------------------
// Randomizes and spawns the smoke effect.
// Also handles deleting the smoke once the effect is finished.
//------------------------------------------
/datum/effect/system/smoke_spread/chem/proc/spawnSmoke(turf/T, icon/I, dist = 1)
	var/obj/effect/smoke/chem/smoke = new(location)
	if(length(chemholder.reagents.reagent_list))
		chemholder.reagents.copy_to(smoke, chemholder.reagents.total_volume / dist, safety = 1)	//copy reagents to the smoke so mob/breathe() can handle inhaling the reagents
	smoke.icon = I
	smoke.layer = 6
	smoke.set_dir(pick(GLOBL.cardinal))
	smoke.pixel_x = -32 + rand(-8, 8)
	smoke.pixel_y = -32 + rand(-8, 8)
	walk_to(smoke, T)
	smoke.set_opacity(1)			//switching opacity on after the smoke has spawned, and then
	sleep(150 + rand(0, 20))	// turning it off before it is deleted results in cleaner
	smoke.set_opacity(0)			// lighting and view range updates
	fadeOut(smoke)
	qdel(smoke)

//------------------------------------------
// Fades out the smoke smoothly using it's alpha variable.
//------------------------------------------
/datum/effect/system/smoke_spread/chem/proc/fadeOut(atom/A, frames = 16)
	var/step = A.alpha / frames
	for(var/i = 0, i < frames, i++)
		A.alpha -= step
		sleep(world.tick_lag)

//------------------------------------------
// Smoke pathfinder. Uses a flood fill method based on zones to
// quickly check what turfs the smoke (airflow) can actually reach.
//------------------------------------------
/datum/effect/system/smoke_spread/chem/proc/smokeFlow()
	var/list/pending = list()
	var/list/complete = list()

	pending += location

	while(length(pending))
		for(var/turf/simulated/current in pending)
			for(var/D in GLOBL.cardinal)
				var/turf/simulated/target = get_step(current, D)
				if(wallList)
					if(istype(target, /turf/simulated/wall))
						if(!(target in wallList))
							wallList += target
						continue
				if(!target.zone)
					continue
				if(target in pending)
					continue
				if(target in complete)
					continue
				if(!(target in targetTurfs))
					continue

				pending += target

			pending -= current
			complete += current

	targetTurfs = complete