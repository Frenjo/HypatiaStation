/decl/ore
	// The ore's name.
	var/name

	/*
	 * Mining
	 */
	// The path to the associated ore item.
	// Must be a subtype of /obj/item/ore!
	var/item_path
	// How much ore a deposit gives.
	var/result_amount
	// Whether a deposit of this type spreads.
	var/does_spread = TRUE
	// The chance a deposit of this type will spread.
	var/spread_chance

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

/decl/ore/iron
	name = "Iron"

	item_path = /obj/item/ore/iron
	result_amount = 5
	spread_chance = 20

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_source_mineral = "iron"

/decl/ore/gold
	name = "Gold"

	item_path = /obj/item/ore/gold
	result_amount = 5
	spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_age_range_billion = list(3, 4)
	xenoarch_source_mineral = "iron"

/decl/ore/silver
	name = "Silver"

	item_path = /obj/item/ore/silver
	result_amount = 5
	spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_source_mineral = "iron"

/decl/ore/diamond
	name = "Diamond"

	item_path = /obj/item/ore/diamond
	result_amount = 5
	spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_source_mineral = "nitrogen"

/decl/ore/plasma
	name = "Plasma"

	item_path = /obj/item/ore/plasma
	result_amount = 5
	spread_chance = 20

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 999)
	xenoarch_age_range_billion = list(10, 13)
	xenoarch_source_mineral = "plasma"

/decl/ore/uranium
	name = "Uranium"

	item_path = /obj/item/ore/uranium
	result_amount = 5
	spread_chance = 10

	xenoarch_age_range_thousand = list(1, 999)
	xenoarch_age_range_million = list(1, 704)
	xenoarch_source_mineral = "potassium"

/decl/ore/bananium
	name = "Bananium"

	item_path = /obj/item/ore/bananium
	result_amount = 3
	spread_chance = 1

	// This is the joke.
	xenoarch_age_range = list(-1, -999)
	xenoarch_age_range_thousand = list(-1, -999)
	xenoarch_source_mineral = "plasma"