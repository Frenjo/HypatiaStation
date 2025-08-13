/*
 * Asteroid Areas
 *
 * These are the actual mining asteroid itself, not the stations built into it.
 *
 * Some of this was originally in mine_areas.dm as part of the mining module.
 */
/area/external/asteroid // -- TLE
	name = "\improper Asteroid"
	icon_state = "asteroid"
	ambience = list(
		'sound/ambience/asteroid/song_game.ogg'
	)

/area/external/asteroid/cave // -- TLE
	name = "\improper Asteroid - Underground #"
	icon_state = "cave"

/area/external/asteroid/artefact_room
	name = "\improper Asteroid - Artefact Room #"
	icon_state = "cave"

// Mining
/area/external/asteroid/mine
	name = "Mine"
	icon_state = "mining"
	ambience = list(
		'sound/ambience/asteroid/ambimine.ogg',
		'sound/ambience/asteroid/song_game.ogg'
	)

/area/external/asteroid/mine/explored
	icon_state = "explored"

/area/external/asteroid/mine/unexplored
	icon_state = "unexplored"