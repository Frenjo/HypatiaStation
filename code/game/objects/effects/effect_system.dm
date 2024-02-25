/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/
/obj/effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = FALSE
	unacidable = TRUE	//So effect are not targeted by alien acid.

/obj/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = FALSE

	var/life = 15.0

/obj/effect/Destroy()
	loc = null
	if(reagents)
		qdel(reagents)
	return ..()

/obj/effect/water/Move(turf/newloc)
	//var/turf/T = src.loc
	//if (istype(T, /turf))
	//	T.firelevel = 0 //TODO: FIX
	if(--src.life < 1)
		//SN src = null
		qdel(src)
	if(newloc.density)
		return 0
	. = ..()

/obj/effect/water/Bump(atom/A)
	if(reagents)
		reagents.reaction(A)
	return ..()


/datum/effect/system
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/setup = FALSE

/datum/effect/system/proc/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc
	setup = TRUE

/datum/effect/system/proc/attach(atom/atom)
	holder = atom

/datum/effect/system/proc/start()


/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	density = FALSE

/datum/effect/system/steam_spread/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc

/datum/effect/system/steam_spread/start()
	var/i = 0
	for(i = 0, i < src.number, i++)
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/steam/steam = new /obj/effect/steam(location)
			var/direction
			if(src.cardinals)
				direction = pick(GLOBL.cardinal)
			else
				direction = pick(GLOBL.alldirs)
			for(i = 0, i < pick(1, 2, 3), i++)
				sleep(5)
				step(steam, direction)
			spawn(20)
				qdel(steam)


/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////
/obj/effect/sparks
	name = "sparks"
	icon_state = "sparks"
	anchored = TRUE
	mouse_opacity = FALSE

	var/amount = 6.0

/obj/effect/sparks/New()
	..()
	playsound(src, "sparks", 100, 1)
	var/turf/T = src.loc
	if(isturf(T))
		T.hotspot_expose(1000,100)

/obj/effect/sparks/initialise()
	. = ..()
	spawn(100)
		qdel(src)

/obj/effect/sparks/Destroy()
	var/turf/T = src.loc
	if(isturf(T))
		T.hotspot_expose(1000, 100)
	return ..()

/obj/effect/sparks/Move()
	..()
	var/turf/T = src.loc
	if(isturf(T))
		T.hotspot_expose(1000,100)

/datum/effect/system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!

/datum/effect/system/spark_spread/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)

/datum/effect/system/spark_spread/start()
	var/i = 0
	for(i = 0, i < src.number, i++)
		if(src.total_sparks > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/sparks/sparks = new /obj/effect/sparks(location)
			src.total_sparks++
			var/direction
			if(src.cardinals)
				direction = pick(GLOBL.cardinal)
			else
				direction = pick(GLOBL.alldirs)
			for(i = 0, i < pick(1, 2, 3), i++)
				sleep(5)
				step(sparks, direction)
			spawn(20)
				if(sparks)
					qdel(sparks)
				src.total_sparks--


/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////
/obj/effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = TRUE
	anchored = FALSE
	mouse_opacity = FALSE

	var/amount = 6.0
	var/time_to_live = 100

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/smoke/initialise()
	. = ..()
	spawn(time_to_live)
		qdel(src)

/obj/effect/smoke/Crossed(mob/living/carbon/M as mob)
	..()
	if(istype(M))
		affect(M)

/obj/effect/smoke/proc/affect(mob/living/carbon/M)
	if(istype(M))
		return 0
	if(M.internal != null && isnotnull(M.wear_mask) && HAS_ITEM_FLAGS(M.wear_mask, ITEM_FLAG_AIRTIGHT))
		return 0
	return 1


/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////
/obj/effect/smoke/bad
	time_to_live = 200

/obj/effect/smoke/bad/Move()
	..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/smoke/bad/affect(mob/living/carbon/M)
	if(!..())
		return 0
	M.drop_item()
	M.adjustOxyLoss(1)
	if(M.coughedtime != 1)
		M.coughedtime = 1
		M.emote("cough")
		spawn(20)
			M.coughedtime = 0

/obj/effect/smoke/bad/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return 1
	if(istype(mover, /obj/item/projectile/energy/beam))
		var/obj/item/projectile/energy/beam/B = mover
		B.damage = (B.damage / 2)
	return 1


/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////
/obj/effect/smoke/sleepy/Move()
	..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/smoke/sleepy/affect(mob/living/carbon/M as mob)
	if(!..())
		return 0

	M.drop_item()
	M:sleeping += 1
	if(M.coughedtime != 1)
		M.coughedtime = 1
		M.emote("cough")
		spawn(20)
			M.coughedtime = 0


/////////////////////////////////////////////
// Mustard Gas
/////////////////////////////////////////////
/obj/effect/smoke/mustard
	name = "mustard gas"
	icon_state = "mustard"

/obj/effect/smoke/mustard/Move()
	..()
	for(var/mob/living/carbon/human/R in get_turf(src))
		affect(R)

/obj/effect/smoke/mustard/affect(mob/living/carbon/human/R)
	if(!..())
		return 0
	if(R.wear_suit != null)
		return 0

	R.burn_skin(0.75)
	if(R.coughedtime != 1)
		R.coughedtime = 1
		R.emote("gasp")
		spawn(20)
			R.coughedtime = 0
	R.updatehealth()
	return


/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////
/datum/effect/system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/smoke

/datum/effect/system/smoke_spread/set_up(n = 5, c = 0, loca, direct)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect/system/smoke_spread/start()
	var/i = 0
	for(i = 0, i < src.number, i++)
		if(src.total_smoke > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/smoke/smoke = new smoke_type(location)
			src.total_smoke++
			var/direction = src.direction
			if(!direction)
				if(src.cardinals)
					direction = pick(GLOBL.cardinal)
				else
					direction = pick(GLOBL.alldirs)
			for(i = 0, i < pick(0, 1, 1, 1, 2, 2, 2, 3), i++)
				sleep(10)
				step(smoke, direction)
			spawn(smoke.time_to_live * 0.75 + rand(10, 30))
				if(smoke)
					qdel(smoke)
				src.total_smoke--

/datum/effect/system/smoke_spread/bad
	smoke_type = /obj/effect/smoke/bad

/datum/effect/system/smoke_spread/sleepy
	smoke_type = /obj/effect/smoke/sleepy

/datum/effect/system/smoke_spread/mustard
	smoke_type = /obj/effect/smoke/mustard


/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////
/obj/effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = TRUE

/datum/effect/system/ion_trail_follow
	var/turf/oldposition
	var/processing = TRUE
	var/on = TRUE

/datum/effect/system/ion_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect/system/ion_trail_follow/start()
	if(!src.on)
		src.on = TRUE
		src.processing = TRUE
	if(src.processing)
		src.processing = FALSE
		spawn(0)
			var/turf/T = get_turf(src.holder)
			if(T != src.oldposition)
				if(isspace(T))
					var/obj/effect/ion_trails/I = new /obj/effect/ion_trails(oldposition)
					src.oldposition = T
					I.set_dir(src.holder.dir)
					flick("ion_fade", I)
					I.icon_state = "blank"
					spawn(20)
						qdel(I)
				spawn(2)
					if(src.on)
						src.processing = TRUE
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = TRUE
						src.start()

/datum/effect/system/ion_trail_follow/proc/stop()
	src.processing = FALSE
	src.on = FALSE


/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////
/datum/effect/system/steam_trail_follow
	var/turf/oldposition
	var/processing = TRUE
	var/on = TRUE

/datum/effect/system/steam_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect/system/steam_trail_follow/start()
	if(!src.on)
		src.on = TRUE
		src.processing = TRUE
	if(src.processing)
		src.processing = FALSE
		spawn(0)
			if(src.number < 3)
				var/obj/effect/steam/I = new /obj/effect/steam(oldposition)
				src.number++
				src.oldposition = get_turf(holder)
				I.set_dir(src.holder.dir)
				spawn(10)
					qdel(I)
					src.number--
				spawn(2)
					if(src.on)
						src.processing = TRUE
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = TRUE
						src.start()

/datum/effect/system/steam_trail_follow/proc/stop()
	src.processing = FALSE
	src.on = FALSE


// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall
/obj/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = FALSE
	anchored = TRUE
	density = FALSE
	layer = OBJ_LAYER + 0.9
	mouse_opacity = FALSE
	animate_movement = FALSE

	var/amount = 3
	var/expand = 1
	var/metal = 0

/obj/effect/foam/New(loc, ismetal = 0)
	..(loc)
	icon_state = "[ismetal ? "m" : ""]foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	spawn(3 + metal * 3)
		process()
		checkReagents()
	spawn(120)
		GLOBL.processing_objects.Remove(src)
		sleep(30)

		if(metal)
			var/obj/structure/foamedmetal/M = new(src.loc)
			M.metal = metal
			M.updateicon()

		flick("[icon_state]-disolve", src)
		sleep(5)
		qdel(src)
	return

// transfer any reagents to the floor
/obj/effect/foam/proc/checkReagents()
	if(!metal && reagents)
		for(var/atom/A in src.loc.contents)
			if(A == src)
				continue
			reagents.reaction(A, 1, 1)

/obj/effect/foam/process()
	if(--amount < 0)
		return

	for(var/direction in GLOBL.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if(reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					F.reagents.add_reagent(R.id, 1, safety = 1)		//added safety check since reagents in the foam have already had a chance to react

// foam disolves when heated
// except metal foams
/obj/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)
		spawn(5)
			qdel(src)

/obj/effect/foam/Crossed(atom/movable/AM)
	if(metal)
		return

	if(iscarbon(AM))
		var/mob/M =	AM
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(istype(human.shoes, /obj/item/clothing/shoes) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP))
				return

		M.stop_pulling()
		to_chat(M, SPAN_INFO("You slipped on the foam!"))
		playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(5)
		M.Weaken(2)

/datum/effect/system/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was mixed
	var/metal = 0				// 0=foam, 1=metalfoam, 2=ironfoam

/datum/effect/system/foam_spread/set_up(amt = 5, loca, datum/reagents/carry = null, metalfoam = 0)
	amount = round(sqrt(amt / 3), 1)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed
	// with (defaults to water if none is present). Rather than actually transfer the reagents,
	// this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/datum/reagent/R in carry.reagent_list)
			carried_reagents += R.id

/datum/effect/system/foam_spread/start()
	spawn(0)
		var/obj/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = new(src.location, metal)
		F.amount = amount

		if(!metal)			// don't carry other chemicals if a metal foam
			F.create_reagents(10)

			if(carried_reagents)
				for(var/id in carried_reagents)
					F.reagents.add_reagent(id, 1, null, 1) //makes a safety call because all reagents should have already reacted anyway
			else
				F.reagents.add_reagent("water", 1, safety = 1)

// wall formed by metal foams
// dense and opaque, but easy to break
/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = TRUE	// changed in New()
	anchored = TRUE
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."

	var/metal = 1		// 1=aluminum, 2=iron

/obj/structure/foamedmetal/New()
	..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	density = FALSE
	update_nearby_tiles(1)
	return ..()

/obj/structure/foamedmetal/proc/updateicon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/ex_act(severity)
	qdel(src)

/obj/structure/foamedmetal/blob_act()
	qdel(src)

/obj/structure/foamedmetal/bullet_act()
	if(metal == 1 || prob(50))
		qdel(src)

/obj/structure/foamedmetal/attack_paw(mob/user)
	attack_hand(user)
	return

/obj/structure/foamedmetal/attack_hand(mob/user)
	if(HULK in user.mutations || prob(75 - metal * 25))
		to_chat(user, SPAN_INFO("You smash through the metal foam wall."))
		for(var/mob/O in oviewers(user))
			if(O.client && !O.blinded)
				to_chat(O, SPAN_WARNING("[user] smashes through the foamed metal."))

		qdel(src)
	else
		to_chat(user, SPAN_INFO("You hit the metal foam but bounce off it."))
	return

/obj/structure/foamedmetal/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		G.affecting.loc = src.loc
		for(var/mob/O in viewers(src))
			if(O.client)
				to_chat(O, SPAN_WARNING("[G.assailant] smashes [G.affecting] through the foamed metal wall."))
		qdel(I)
		qdel(src)
		return

	if(prob(I.force * 20 - metal * 25))
		to_chat(user, SPAN_INFO("You smash through the foamed metal with \the [I]."))
		for(var/mob/O in oviewers(user))
			if(O.client && !O.blinded)
				to_chat(O, SPAN_WARNING("[user] smashes through the foamed metal."))
		qdel(src)
	else
		to_chat(user, SPAN_INFO("You hit the metal foam to no effect."))

/obj/structure/foamedmetal/CanPass(atom/movable/mover, turf/target, height = 1.5, air_group = 0)
	if(air_group)
		return 0
	return !density

/obj/structure/foamedmetal/proc/update_nearby_tiles(need_rebuild)
	if(!global.PCair)
		return 0
	global.PCair.mark_for_update(get_turf(src))
	return 1


/datum/effect/system/reagents_explosion
	var/amount					// TNT equivalent
	var/flashing = 0			// does explosion creates flash effect?
	var/flashing_factor = 0		// factor of how powerful the flash effect relatively to the explosion

/datum/effect/system/reagents_explosion/set_up(amt, loc, flash = 0, flash_fact = 0)
	amount = amt
	if(isturf(loc))
		location = loc
	else
		location = get_turf(loc)

	flashing = flash
	flashing_factor = flash_fact

	return

/datum/effect/system/reagents_explosion/start()
	if(amount <= 2)
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(2, 1, location)
		s.start()

		for(var/mob/M in viewers(5, location))
			to_chat(M, SPAN_WARNING("The solution violently explodes."))
		for(var/mob/M in viewers(1, location))
			if(prob (50 * amount))
				to_chat(M, SPAN_WARNING("The explosion knocks you down."))
				M.Weaken(rand(1, 5))
		return
	else
		var/devastation = -1
		var/heavy = -1
		var/light = -1
		var/flash = -1

		// Clamp all values to MAX_EXPLOSION_RANGE
		if(round(amount / 12) > 0)
			devastation = min (GLOBL.max_explosion_range, devastation + round(amount / 12))

		if(round(amount / 6) > 0)
			heavy = min (GLOBL.max_explosion_range, heavy + round(amount / 6))

		if(round(amount / 3) > 0)
			light = min (GLOBL.max_explosion_range, light + round(amount / 3))

		if(flash && flashing_factor)
			flash += (round(amount / 4) * flashing_factor)

		for(var/mob/M in viewers(8, location))
			M << "\red The solution violently explodes."

		explosion(location, devastation, heavy, light, flash)

/datum/effect/system/reagents_explosion/proc/holder_damage(atom/holder)
	if(holder)
		var/dmglevel = 4

		if(round(amount / 8) > 0)
			dmglevel = 1
		else if(round(amount / 4) > 0)
			dmglevel = 2
		else if(round(amount / 2) > 0)
			dmglevel = 3

		if(dmglevel < 4)
			holder.ex_act(dmglevel)