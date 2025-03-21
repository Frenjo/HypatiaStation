// Liquid fuel.
/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or plasma being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	layer = TURF_LAYER + 0.2
	anchored = TRUE

	var/amount = 1 //Basically moles.

/obj/effect/decal/cleanable/liquid_fuel/New(newLoc, amt = 1)
	src.amount = amt

	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in newLoc)
		if(other != src)
			other.amount += src.amount
			spawn other.Spread()
			qdel(src)

	Spread()
	. = ..()

/obj/effect/decal/cleanable/liquid_fuel/proc/Spread()
	//Allows liquid fuels to sometimes flow into other tiles.
	if(amount < 5.0)
		return
	var/turf/open/S = loc
	if(!istype(S))
		return
	for(var/d in GLOBL.cardinal)
		if(rand(25))
			var/turf/open/target = get_step(src,d)
			var/turf/open/origin = GET_TURF(src)
			if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
				if(!locate(/obj/effect/decal/cleanable/liquid_fuel) in target)
					new/obj/effect/decal/cleanable/liquid_fuel(target, amount * 0.25)
					amount *= 0.75

// Flamethrower fuel.
/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel
	icon_state = "mustard"
	anchored = FALSE

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/New(newLoc, amt = 1, d = 0)
	dir = d //Setting this direction means you won't get torched by your own flamethrower.
	. = ..()

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/Spread()
	//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
	if(amount < 0.1)
		return
	var/turf/open/S = loc
	if(!istype(S))
		return

	for(var/d in list(turn(dir, 90), turn(dir, -90), dir))
		var/turf/open/O = get_step(S,d)
		if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in O)
			continue
		if(O.CanPass(null, S, 0, 0) && S.CanPass(null, O, 0, 0))
			new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(O, amount * 0.25, d)
			O.hotspot_expose((T20C*2) + 380,500) //Light flamethrower fuel on fire immediately.

	amount *= 0.25