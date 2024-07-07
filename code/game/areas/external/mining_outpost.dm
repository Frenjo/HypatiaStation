/*
 * Mining Station Areas
 *
 * Some of this was originally in mine_areas.dm as part of the mining module.
 */
/area/external/mining
	icon_state = "mining"
	ambience = list(
		'sound/ambience/song_game.ogg'
	)

// Mining Station
/area/external/mining/starboard_wing
	name = "Mining Station Starboard Wing"
	icon_state = "mining_production"

/area/external/mining/eva
	name = "Mining Station EVA"
	icon_state = "mining_eva"

/area/external/mining/port_wing
	name = "Mining Station Port Wing"
	icon_state = "mining_living"

/area/external/mining/storage
	name = "Mining Station Storage"

/area/external/mining/communications
	name = "Mining Station Communications"

/area/external/mining/infirmary
	name = "Mining Station Infirmary"

// West Outpost
/area/external/mining/west_outpost
	name = "West Mining Outpost"

// Abandoned
/area/external/mining/abandoned
	name = "Abandoned Mining Station"