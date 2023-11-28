// Telecommunications Satellite
/area/tcomsat
	name = "\improper Telecommunications Satellite"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/tcomsat/entrance
	name = "\improper Telecommunications Satellite Teleporter"
	icon_state = "tcomsatentrance"

/area/tcomsat/chamber
	name = "\improper Telecommunications Satellite Central Compartment"
	icon_state = "tcomsatcham"

/area/tcomsat/computer
	name = "\improper Telecommunications Satellite Control Room"
	icon_state = "tcomsatcomp"

/area/tcomsat/lounge
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
/area/tcomsat/solar
	requires_power = TRUE
	always_unpowered = TRUE
	icon_state = "tcomsatlounge"

/area/tcomsat/solar/port
	name = "\improper Telecommunications Satellite Port Solar Array"

/area/tcomsat/solar/fore
	name = "\improper Telecommunications Satellite Fore Solar Array"

/area/tcomsat/solar/starboard
	name = "\improper Telecommunications Satellite Starboard Solar Array"

/area/tcomsat/solar/aft
	name = "\improper Telecommunications Satellite Aft Solar Array"