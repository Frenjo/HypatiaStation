/*
 * Asteroid Areas
 *
 * These are the actual mining asteroid itself, not the stations built into it.
 *
 * Some of this was originally in mine_areas.dm as part of the mining module.
 */
/area/asteroid // -- TLE
	name = "\improper Asteroid"
	icon_state = "asteroid"
	ambience = list(
		'sound/ambience/song_game.ogg'
	)

/area/asteroid/cave // -- TLE
	name = "\improper Asteroid - Underground"
	icon_state = "cave"

/area/asteroid/artifact_room
	name = "\improper Asteroid - Artifact"
	icon_state = "cave"

// Mining
/area/asteroid/mine
	name = "Mine"
	icon_state = "mining"
	ambience = list(
		'sound/ambience/ambimine.ogg',
		'sound/ambience/song_game.ogg'
	)

/area/asteroid/mine/explored
	icon_state = "explored"

/area/asteroid/mine/unexplored
	icon_state = "unexplored"