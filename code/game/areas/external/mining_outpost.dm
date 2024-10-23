/*
 * Mining Station Areas
 *
 * Some of this was originally in mine_areas.dm as part of the mining module.
 */
/area/external/mining_outpost
	icon_state = "mining"
	ambience = list(
		'sound/ambience/song_game.ogg'
	)

// Mining Station
/area/external/mining_outpost/starboard_wing
	name = "Mining Station Starboard Wing"
	icon_state = "mining_production"

/area/external/mining_outpost/eva
	name = "Mining Station EVA"
	icon_state = "mining_eva"

/area/external/mining_outpost/port_wing
	name = "Mining Station Port Wing"
	icon_state = "mining_living"

/area/external/mining_outpost/storage
	name = "Mining Station Storage"

/area/external/mining_outpost/communications
	name = "Mining Station Communications"

/area/external/mining_outpost/infirmary
	name = "Mining Station Infirmary"

// West Outpost
/area/external/mining_outpost/west_outpost
	name = "West Mining Outpost"

// Abandoned
/area/external/mining_outpost/abandoned
	name = "Abandoned Mining Station"