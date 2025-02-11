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