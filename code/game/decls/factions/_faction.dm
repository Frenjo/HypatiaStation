// Normal factions:
/decl/faction
	var/name	// The name of the faction.
	var/desc	// Small paragraph explaining the traitor faction.

	var/list/restricted_species = list() // Only members of these species can be recruited.
	var/list/members = list() // A list of mind datums that belong to this faction.
	var/max_op = 0 // The maximum number of members a faction can have (0 for no max).