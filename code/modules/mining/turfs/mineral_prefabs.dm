/*
 * Mineral Deposit Prefabs
 */
// Re-added these because some away missions require them.
/turf/simulated/mineral/gold
	icon_state = "rock_gold"

/turf/simulated/mineral/gold/New()
	mineral = GET_DECL_INSTANCE(/decl/mineral/gold)
	. = ..()

/turf/simulated/mineral/silver
	icon_state = "rock_silver"

/turf/simulated/mineral/silver/New()
	mineral = GET_DECL_INSTANCE(/decl/mineral/silver)
	. = ..()

/turf/simulated/mineral/diamond
	icon_state = "rock_diamond"

/turf/simulated/mineral/diamond/New()
	mineral = GET_DECL_INSTANCE(/decl/mineral/diamond)
	. = ..()

/turf/simulated/mineral/bananium
	icon_state = "rock_bananium"

/turf/simulated/mineral/bananium/New()
	mineral = GET_DECL_INSTANCE(/decl/mineral/bananium)
	. = ..()
// End of away mission specific additions.

/turf/simulated/mineral/random
	name = "mineral deposit"

	var/mineral_chance = 10 // Means 10% chance of this plot changing to a mineral deposit.
	var/mineral_spawn_chance_list = list(
		/decl/mineral/uranium = 5,
		/decl/mineral/iron = 40,
		/decl/mineral/diamond = 1,
		/decl/mineral/gold = 5,
		/decl/mineral/silver = 5,
		/decl/mineral/plasma = 25,
		/decl/mineral/bananium = 1
	)

/turf/simulated/mineral/random/New()
	if(prob(mineral_chance))
		mineral = GET_DECL_INSTANCE(pickweight(mineral_spawn_chance_list))
	. = ..()

/turf/simulated/mineral/random/high_chance
	mineral_chance = 25
	mineral_spawn_chance_list = list(
		/decl/mineral/uranium = 10,
		/decl/mineral/iron = 30,
		/decl/mineral/diamond = 2,
		/decl/mineral/gold = 10,
		/decl/mineral/silver = 10,
		/decl/mineral/plasma = 25,
		/decl/mineral/bananium = 2
	)