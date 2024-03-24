/*
 * Mineral Deposit Prefabs
 */
// Re-added these because some away missions require them.
/turf/simulated/mineral/gold
	icon_state = "rock_gold"
	ore = /decl/ore/gold

/turf/simulated/mineral/silver
	icon_state = "rock_silver"
	ore = /decl/ore/silver

/turf/simulated/mineral/diamond
	icon_state = "rock_diamond"
	ore = /decl/ore/diamond

/turf/simulated/mineral/bananium
	icon_state = "rock_bananium"
	ore = /decl/ore/bananium

// End of away mission specific additions.

/turf/simulated/mineral/random
	name = "mineral deposit"

	var/ore_chance = 10 // Means 10% chance of this plot changing to an ore deposit.
	var/ore_spawn_chance_list = list(
		/decl/ore/uranium = 5,
		/decl/ore/iron = 40,
		/decl/ore/diamond = 1,
		/decl/ore/gold = 5,
		/decl/ore/silver = 5,
		/decl/ore/plasma = 25,
		/decl/ore/bananium = 1
	)

/turf/simulated/mineral/random/New()
	if(prob(ore_chance))
		ore = GET_DECL_INSTANCE(pickweight(ore_spawn_chance_list))
	. = ..()

/turf/simulated/mineral/random/high_chance
	ore_chance = 25
	ore_spawn_chance_list = list(
		/decl/ore/uranium = 10,
		/decl/ore/iron = 30,
		/decl/ore/diamond = 2,
		/decl/ore/gold = 10,
		/decl/ore/silver = 10,
		/decl/ore/plasma = 25,
		/decl/ore/bananium = 2
	)