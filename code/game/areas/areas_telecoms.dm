// Telecommunications Satellite
/area/tcomsat
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/tcomsat/entrance
	name = "\improper Telecommunications Teleporter"
	icon_state = "tcomsatentrance"

/area/tcomsat/chamber
	name = "\improper Telecommunications Central Compartment"
	icon_state = "tcomsatcham"

/area/turret_protected/tcomsat
	name = "\improper Telecommunications Satellite"
	icon_state = "tcomsatlob"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/turret_protected/tcomfoyer
	name = "\improper Telecommunications Foyer"
	icon_state = "tcomsatentrance"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

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

/area/tcomsat/computer
	name = "\improper Telecommunications Control Room"
	icon_state = "tcomsatcomp"

/area/tcomsat/lounge
	name = "\improper Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"

// Added these due to map editing. -Frenjo
/area/tcomsat/solar
	requires_power = TRUE
	always_unpowered = TRUE
	icon_state = "tcomsatlounge"

/area/tcomsat/solar/port
	name = "\improper Telecommunications Port Solar Array"

/area/tcomsat/solar/fore
	name = "\improper Telecommunications Fore Solar Array"

/area/tcomsat/solar/starboard
	name = "\improper Telecommunications Starboard Solar Array"

/area/tcomsat/solar/aft
	name = "\improper Telecommunications Aft Solar Array"