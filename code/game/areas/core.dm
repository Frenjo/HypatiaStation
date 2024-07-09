/*
 * Core Areas
 *
 * These are required by basically everything.
 * Used to be under Space_Station_13_areas.dm.
 */
// Space
/area/space
	name = "Space"
	icon_state = "dark128"
	always_unpowered = TRUE
	dynamic_lighting = TRUE
	ambience = list(
		'sound/ambience/ambispace.ogg',
		'sound/music/title2.ogg',
		'sound/music/space.ogg',
		'sound/music/main.ogg',
		'sound/music/traitor.ogg'
	)

/area/space/updateicon()
	return

/area/space/power_alert()
	return

/area/space/atmos_alert()
	return

/area/space/fire_alert()
	return

/area/space/evac_alert()
	return

/area/space/party_alert()
	return

/area/space/destruct_alert()
	return

// Away Missions
/area/away_mission
	name = "\improper Strange Location"
	icon_state = "away"

// Preserved in case these ever get used later. -Frenjo
///area/airtunnel1		// referenced in airtunnel.dm:759
///area/dummy			// Referenced in engine.dm:261
//STATION13