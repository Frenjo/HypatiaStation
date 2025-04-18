GLOBAL_GLOBL_INIT(datum/map/current_map, new CURRENT_MAP_DATUM())

/datum/map
	var/name = "Default Map"
	var/station_name = "Default Station"
	var/short_name = "Station"

	var/list/station_levels = list()	// Defines which Z-levels the station exists on.
	var/list/admin_levels = list()		// Defines which Z-levels which are for admin functionality (IE Central Command and the Syndicate Shuttle).
	var/list/contact_levels = list()	// Defines which Z-levels which, for example, a Code Red announcement may affect.
	var/list/player_levels = list()		// Defines all Z-levels a character can typically reach.

	var/list/base_turf_by_z = list()	// Defines the base turf for each Z-level. Unlisted Z-levels default to world.turf.

	// This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	// (Exceptions: extended, sandbox and nuke) -Errorage
	var/list/accessible_z_levels = list()