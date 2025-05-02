///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	required_reagents = alist("water" = 1, "potassium" = 1)
	result_amount = 2

/datum/chemical_reaction/explosion_potassium/on_reaction(datum/reagents/holder, created_volume)
	var/datum/effect/system/reagents_explosion/e = new /datum/effect/system/reagents_explosion()
	e.set_up(round(created_volume/10, 1), holder.my_atom, 0, 0)
	e.holder_damage(holder.my_atom)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	required_reagents = alist("uranium" = 1, "iron" = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(datum/reagents/holder, created_volume)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(GET_TURF(holder.my_atom), round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	required_reagents = alist("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )
	result_amount = null

/datum/chemical_reaction/flash_powder/on_reaction(datum/reagents/holder, created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	make_sparks(2, TRUE, location)
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 3)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				flick("e_flash", M.flash)
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				flick("e_flash", M.flash)
				M.Stun(5)

/datum/chemical_reaction/napalm
	name = "Napalm"
	required_reagents = alist("aluminum" = 1, "plasma" = 1, "sacid" = 1 )
	result_amount = 1

/datum/chemical_reaction/napalm/on_reaction(datum/reagents/holder, created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	for(var/turf/open/floor/target_tile in range(0, location))
		target_tile.assume_gas(/decl/xgm_gas/volatile_fuel, created_volume, 400 + T0C)
		spawn(0)
			target_tile.hotspot_expose(700, 400)
	// holder.del_reagent("napalm")
	// "napalm" isn't actually a reagent apparently.

/*
/datum/chemical_reaction/smoke
	name = "Smoke"
	required_reagents = alist("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = null
	secondary = 1

/datum/chemical_reaction/smoke/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	var/datum/effect/system/bad_smoke_spread/S = new /datum/effect/system/bad_smoke_spread()
	S.attach(location)
	S.set_up(10, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
			sleep(10)
		S.start()
		sleep(10)
		S.start()
		sleep(10)
		S.start()
		sleep(10)
		S.start()
	holder.clear_reagents()
*/

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	required_reagents = alist("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = 0.4
	secondary = 1

/datum/chemical_reaction/chemsmoke/on_reaction(datum/reagents/holder, created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	make_chem_smoke(created_volume, FALSE, location, holder, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	holder.clear_reagents()