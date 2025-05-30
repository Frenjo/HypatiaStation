// White Ship
/area/external/abandoned/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

// Old AI Satellite
/area/external/abandoned/ai_satellite_teleporter
	name = "\improper Abandoned AI Satellite Teleporter Room"
	icon_state = "teleporter"
	ambience = list(
		'sound/ambience/signal.ogg',
		'sound/ambience/ambimalf.ogg'
	)

 // Derelict Assembly Line
 // This was originally /area/assembly/assembly_line.
 // I'm not sure if THE Derelict ever had an assembly line, or this is just A derelict assembly line.
/area/external/abandoned/assembly_line
	name = "\improper Assembly Line"
	icon_state = "ass_line"
	power_channels = alist(EQUIP = FALSE, LIGHT = FALSE, ENVIRON = FALSE)

// Abandoned Mining Station
// This one was originally grouped with the non-abandoned mining outpost but I moved it for clarity.
/area/external/abandoned/mining_outpost
	name = "Abandoned Mining Station"
	ambience = list(
		'sound/ambience/song_game.ogg'
	)

// Bananium Shuttle
// This one originally didn't have an area and was just classed as space.
/area/external/abandoned/bananium_shuttle
	name = "Abandoned Bananium Shuttle"
	ambience = list(
		'sound/ambience/ambispace.ogg',
		'sound/music/title2.ogg',
		'sound/music/space.ogg',
		'sound/music/main.ogg',
		'sound/music/traitor.ogg'
	)