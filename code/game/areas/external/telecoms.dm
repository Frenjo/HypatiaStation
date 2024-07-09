// Telecommunications Satellite
/area/external/tcomsat
	name = "\improper Telecommunications Satellite"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/external/tcomsat/exterior
	name = "\improper Telecommunications Satellite Exterior"
	icon_state = "tcomsatcham"
	requires_power = FALSE

/area/external/tcomsat/entrance
	name = "\improper Telecommunications Satellite Teleporter"
	icon_state = "tcomsatentrance"

/area/external/tcomsat/chamber
	name = "\improper Telecommunications Satellite Central Compartment"
	icon_state = "tcomsatcham"

/area/external/tcomsat/computer
	name = "\improper Telecommunications Satellite Control Room"
	icon_state = "tcomsatcomp"

/area/external/tcomsat/lounge
	name = "\improper Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"

/area/turret_protected/tcomsat
	name = "\improper Telecommunications Satellite"
	icon_state = "tcomsatlob"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/turret_protected/tcomsat/foyer
	name = "\improper Telecommunications Satellite Foyer"
	icon_state = "tcomsatentrance"

/*
/area/turret_protected/tcomwest
	name = "\improper Telecommunications Satellite West Wing"
	icon_state = "tcomsatwest"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/turret_protected/tcomeast
	name = "\improper Telecommunications Satellite East Wing"
	icon_state = "tcomsateast"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)
*/

// Added these due to map editing. -Frenjo
/area/external/tcomsat/solar
	always_unpowered = TRUE
	icon_state = "tcomsatlounge"

/area/external/tcomsat/solar/port
	name = "\improper Telecommunications Satellite Port Solar Array"

/area/external/tcomsat/solar/fore
	name = "\improper Telecommunications Satellite Fore Solar Array"

/area/external/tcomsat/solar/starboard
	name = "\improper Telecommunications Satellite Starboard Solar Array"

/area/external/tcomsat/solar/aft
	name = "\improper Telecommunications Satellite Aft Solar Array"