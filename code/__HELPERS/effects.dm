/*
 * Helper procs for making effect systems without copypaste code everywhere.
 * These also ensure they delete themselves afterwards.
 *
 * Generic parameters:
 *	number - number of effects to spawn.
 *	cardinal_only - whether the effects only move in cardinal directions.
 *	location - the location to spawn the effects from.
 *	attach_to - optional atom to attach the effect system to.
 */
// Sparks.
/proc/make_sparks(number, cardinal_only, location, atom/attach_to = null)
	var/datum/effect/system/spark_spread/sparks = new /datum/effect/system/spark_spread()
	sparks.set_up(number, cardinal_only, location)
	if(isnotnull(attach_to))
		sparks.attach(attach_to)
	sparks.start()
	spawn(2.5 SECONDS)
		qdel(sparks)

// Smoke.
/proc/make_smoke(number, cardinal_only, location, atom/attach_to = null, direction = null)
	var/datum/effect/system/smoke_spread/smoke = new /datum/effect/system/smoke_spread()
	smoke.set_up(number, cardinal_only, location, direction)
	if(isnotnull(attach_to))
		smoke.attach(attach_to)
	smoke.start()
	spawn(2.5 SECONDS)
		qdel(smoke)

// Chem Smoke.
// holder - reagent holder to use chemicals from.
/proc/make_chem_smoke(number, cardinal_only, location, datum/reagents/holder, atom/attach_to = null, direction = null)
	var/datum/effect/system/smoke_spread/chem/chem_smoke = new /datum/effect/system/smoke_spread/chem()
	chem_smoke.set_up(holder, number, cardinal_only, location, direction)
	if(isnotnull(attach_to))
		chem_smoke.attach(attach_to)
	chem_smoke.start()
	spawn(2.5 SECONDS)
		qdel(chem_smoke)

// "Bad" Smoke.
/proc/make_bad_smoke(number, cardinal_only, location, atom/attach_to = null, direction = null)
	var/datum/effect/system/smoke_spread/bad/bad_smoke = new /datum/effect/system/smoke_spread/bad()
	bad_smoke.set_up(number, cardinal_only, location, direction)
	if(isnotnull(attach_to))
		bad_smoke.attach(attach_to)
	bad_smoke.start()
	spawn(2.5 SECONDS)
		qdel(bad_smoke)

// Steam.
/proc/make_steam(number, cardinal_only, location, atom/attach_to = null, direction = null)
	var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread()
	steam.set_up(number, cardinal_only, location)
	if(isnotnull(attach_to))
		steam.attach(attach_to)
	steam.start()
	spawn(2.5 SECONDS)
		qdel(steam)