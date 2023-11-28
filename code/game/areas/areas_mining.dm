// Mining
// This was originally in mine_areas.dm as part of the mining module.
/area/mine
	icon_state = "mining"
	ambience = list(
		'sound/ambience/song_game.ogg'
	)

/area/mine/explored
	name = "Mine"
	icon_state = "explored"
	ambience = list(
		'sound/ambience/ambimine.ogg',
		'sound/ambience/song_game.ogg'
	)
	requires_power = TRUE
	always_unpowered = TRUE

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"
	ambience = list(
		'sound/ambience/ambimine.ogg',
		'sound/ambience/song_game.ogg'
	)

/area/mine/starboard_wing
	name = "Mining Station Starboard Wing"
	icon_state = "mining_production"

/area/mine/eva
	name = "Mining Station EVA"
	icon_state = "mining_eva"

/area/mine/port_wing
	name = "Mining Station Port Wing"
	icon_state = "mining_living"

/area/mine/storage
	name = "Mining Station Storage"

/area/mine/communications
	name = "Mining Station Communications"

/area/mine/infirmary
	name = "Mining Station Infirmary"

/area/mine/west_outpost
	name = "West Mining Outpost"

/area/mine/abandoned
	name = "Abandoned Mining Station"