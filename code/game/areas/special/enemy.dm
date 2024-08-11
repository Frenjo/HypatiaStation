/*
 * Enemy Areas
 */
// Syndicate
// Names are used.
/area/enemy/syndicate_mothership
	name = "\improper Syndicate Mothership"
	icon_state = "syndie-ship"
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/enemy/syndicate_mothership/control
	name = "\improper Syndicate Control Room"
	icon_state = "syndie-control"
	dynamic_lighting = FALSE

/area/enemy/syndicate_mothership/elite_squad
	name = "\improper Syndicate Elite Squad"
	icon_state = "syndie-elite"
	dynamic_lighting = FALSE

// Shuttle
/area/enemy/syndicate_station
	name = "\improper Syndicate Station"
	icon_state = "yellow"
	requires_power = FALSE

/area/enemy/syndicate_station/start
	name = "\improper Syndicate Forward Operating Base"
	base_turf = /turf/open/floor/plating/metal

/area/enemy/syndicate_station/southwest
	name = "\improper South-West of SS13"
	icon_state = "southwest"

/area/enemy/syndicate_station/northwest
	name = "\improper North-West of SS13"
	icon_state = "northwest"

/area/enemy/syndicate_station/northeast
	name = "\improper North-East of SS13"
	icon_state = "northeast"

/area/enemy/syndicate_station/southeast
	name = "\improper Nouth-East of SS13"
	icon_state = "southeast"

/area/enemy/syndicate_station/north
	name = "\improper North of SS13"
	icon_state = "north"

/area/enemy/syndicate_station/south
	name = "\improper South of SS13"
	icon_state = "south"

/area/enemy/syndicate_station/commssat
	name = "\improper South of the communication satellite"
	icon_state = "south"

/area/enemy/syndicate_station/mining
	name = "\improper North-East of the mining asteroid"
	icon_state = "north"

/area/enemy/syndicate_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

// Wizard
/area/enemy/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = FALSE
	dynamic_lighting = FALSE

// Vox
/area/enemy/vox_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	requires_power = FALSE
	base_turf = /turf/space/transit/north

/area/enemy/vox_station/southwest_solars
	name = "\improper Aft Port Solars"
	icon_state = "southwest"
	requires_power = FALSE

/area/enemy/vox_station/northwest_solars
	name = "\improper Fore Port Solars"
	icon_state = "northwest"
	requires_power = FALSE

/area/enemy/vox_station/northeast_solars
	name = "\improper Fore Starboard Solars"
	icon_state = "northeast"
	requires_power = FALSE

/area/enemy/vox_station/southeast_solars
	name = "\improper Aft Starboard Solars"
	icon_state = "southeast"
	requires_power = FALSE

/area/enemy/vox_station/mining
	name = "\improper Nearby mining asteroid"
	icon_state = "north"
	requires_power = FALSE