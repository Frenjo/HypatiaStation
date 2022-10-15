GLOBAL_GLOBL_TYPED_INIT(current_map, /datum/map, new CURRENT_MAP_DATUM())

/datum/map
	var/name = "Default Map"
	var/station_name = "Default Station"

	var/list/station_levels = list()	// Defines which Z-levels the station exists on.
	var/list/admin_levels = list()		// Defines which Z-levels which are for admin functionality (IE Central Command and the Syndicate Shuttle).
	var/list/contact_levels = list()	// Defines which Z-levels which, for example, a Code Red announcement may affect.
	var/list/player_levels = list()		// Defines all Z-levels a character can typically reach.