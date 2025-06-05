/*
 * Mineral Deposit Prefabs
 */
// Re-added these because some away missions require them.
/turf/closed/rock/gold_ore
	icon_state = "rock_gold"
	ore = /decl/ore/gold

/turf/closed/rock/silver_ore
	icon_state = "rock_silver"
	ore = /decl/ore/silver

/turf/closed/rock/diamond_ore
	icon_state = "rock_diamond"
	ore = /decl/ore/diamond

/turf/closed/rock/bananium_ore
	icon_state = "rock_bananium"
	ore = /decl/ore/bananium

/turf/closed/rock/tranquilite_ore
	icon_state = "rock_tranquilite"
	ore = /decl/ore/tranquilite

// End of away mission specific additions.

/turf/closed/rock/random_ore
	name = "mineral deposit"
	icon_state = "rock_low_chance"

	var/ore_chance = 10 // Means 10% chance of this plot changing to an ore deposit.
	var/ore_spawn_chance_list = list(
		/decl/ore/iron = 30,
		/decl/ore/coal = 30,
		/decl/ore/silver = 10,
		/decl/ore/gold = 10,
		/decl/ore/diamond = 5,
		/decl/ore/uranium = 10,
		/decl/ore/plasma = 15,
		/decl/ore/bananium = 1,
		/decl/ore/tranquilite = 1
	)

/turf/closed/rock/random_ore/New()
	if(prob(ore_chance))
		ore = GET_DECL_INSTANCE(pickweight(ore_spawn_chance_list))
	. = ..()

/turf/closed/rock/random_ore/high_chance
	icon_state = "rock_high_chance"

	ore_chance = 25
	ore_spawn_chance_list = list(
		/decl/ore/iron = 20,
		/decl/ore/coal = 20,
		/decl/ore/silver = 15,
		/decl/ore/gold = 15,
		/decl/ore/diamond = 10,
		/decl/ore/uranium = 15,
		/decl/ore/plasma = 15,
		/decl/ore/bananium = 2,
		/decl/ore/tranquilite = 2
	)