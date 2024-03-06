/decl/mineral
	// The mineral's name.
	var/name

	/*
	 * Ore
	 */
	// The path to the associated ore item.
	// Must be a subtype of /obj/item/ore!
	var/ore_path
	// How much ore a deposit of this mineral gives.
	var/ore_result_amount
	// Whether a deposit of this type spreads.
	var/ore_spread = TRUE
	// The chance a deposit of this type will spread.
	var/ore_spread_chance

	/*
	 * Xenoarchaeology
	 */
	// The minimum and maximum age ranges for each increment.
	var/list/xenoarch_age_range // This one is apparently special as it's only used by bananium.
	var/list/xenoarch_age_range_thousand
	var/list/xenoarch_age_range_million
	var/list/xenoarch_age_range_billion
	// The listed source mineral.
	var/xenoarch_source_mineral

/decl/mineral/iron
	name = "Iron"

	ore_path = /obj/item/ore/iron
	ore_result_amount = 5
	ore_spread_chance = 20

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_source_mineral = "iron"

/decl/mineral/gold
	name = "Gold"

	ore_path = /obj/item/ore/gold
	ore_result_amount = 5
	ore_spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_age_range_billion = list(3, 4)
	xenoarch_source_mineral = "iron"

/decl/mineral/silver
	name = "Silver"

	ore_path = /obj/item/ore/silver
	ore_result_amount = 5
	ore_spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_source_mineral = "iron"

/decl/mineral/diamond
	name = "Diamond"

	ore_path = /obj/item/ore/diamond
	ore_result_amount = 5
	ore_spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_source_mineral = "nitrogen"

/decl/mineral/plasma
	name = "Plasma"

	ore_path = /obj/item/ore/plasma
	ore_result_amount = 5
	ore_spread_chance = 20

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_age_range_billion = list(10, 13)
	xenoarch_source_mineral = "plasma"

/decl/mineral/uranium
	name = "Uranium"

	ore_path = /obj/item/ore/uranium
	ore_result_amount = 5
	ore_spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 704)
	xenoarch_source_mineral = "potassium"

/decl/mineral/bananium
	name = "Bananium"

	ore_path = /obj/item/ore/bananium
	ore_result_amount = 3
	ore_spread_chance = 1

	// This is the joke.
	xenoarch_age_range = list(-1, -999)
	xenoarch_age_range_thousand = list(-1, -999)
	xenoarch_source_mineral = "plasma"