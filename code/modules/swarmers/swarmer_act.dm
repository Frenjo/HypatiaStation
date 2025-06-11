/atom/proc/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	swarmer_disintegrate(sammy, src)
	return TRUE

/obj/item/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	sammy.integrate(src)
	return TRUE

/mob/living/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	swarmer_disperse_target(sammy, src)
	return TRUE

// ex_act() on turf calls it on its contents, this is to prevent attacking mobs by disintegrate()'ing the floor!
/turf/open/floor/swarmer_act()
	return FALSE

/obj/machinery/atmospherics/swarmer_act()
	return FALSE

/obj/structure/disposalpipe/swarmer_act()
	return FALSE

/*
 * Restrictions
 */
// Special
/mob/living/simple/slime/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(sammy, SPAN_WARNING("This biological resource is somehow resisting our bluespace transceiver. Aborting."))
	return FALSE

/obj/machinery/gateway/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(sammy, SPAN_WARNING("This bluespace source will be important to us later. Aborting."))
	return FALSE

/obj/item/stack/cable_coil/swarmer_act(mob/living/simple/hostile/swarmer/sammy) // Wiring would be too effective as a resource.
	to_chat(sammy, SPAN_WARNING("This object does not contain enough materials to work with."))
	return FALSE

/obj/machinery/porta_turret/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(sammy, SPAN_WARNING("Attempting to dismantle this machine would result in an immediate counterattack. Aborting."))
	return FALSE

// Hull breach causes
/turf/closed/wall/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	if(locate(/turf/space) in RANGE_TURFS(src, 1))
		to_chat(sammy, SPAN_WARNING("Destroying this object has the potential to cause a hull breach. Aborting."))
		return FALSE
	return ..()

/obj/structure/window/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	if(locate(/turf/space) in RANGE_TURFS(src, 1))
		to_chat(sammy, SPAN_WARNING("Destroying this object has the potential to cause a hull breach. Aborting."))
		return FALSE
	return ..()

// Explosions
/obj/structure/reagent_dispensers/fueltank/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(sammy, SPAN_WARNING("Destroying this object would create a chain reaction. Aborting."))
	return FALSE

// Bad atmos
/obj/machinery/portable_atmospherics/canister/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(src, SPAN_WARNING("Destroying this object has the potential to create an inhospitable area. Aborting."))
	return FALSE

// Power disruption
/obj/structure/cable/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(src, SPAN_WARNING("Disrupting the power grid would bring no benefit to us. Aborting."))
	return FALSE

/obj/machinery/power/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(src, SPAN_WARNING("Disrupting the power grid would bring no benefit to us. Aborting."))
	return FALSE

// Emitter dangers
// Stop trying to release the singularity you fuck.
/obj/machinery/power/emitter/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(src, SPAN_WARNING("Destroying this object is too dangerous. Aborting."))
	return FALSE

/obj/machinery/zero_point_emitter/swarmer_act(mob/living/simple/hostile/swarmer/sammy)
	to_chat(src, SPAN_WARNING("Destroying this object is too dangerous. Aborting."))
	return FALSE