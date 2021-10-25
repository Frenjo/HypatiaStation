// Telecommunications Satellite
/area/tcommsat
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/tcommsat/entrance
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatentrance"

/area/tcommsat/chamber
	name = "\improper Telecomms Central Compartment"
	icon_state = "tcomsatcham"

/area/turret_protected/tcomsat
	name = "\improper Telecomms Satellite"
	icon_state = "tcomsatlob"
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg'
	)

/area/turret_protected/tcomfoyer
	name = "\improper Telecomms Foyer"
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

/area/tcommsat/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/lounge
	name = "\improper Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"

// Added these due to map editing. -Frenjo
/area/tcommsat/solar
	requires_power = 1
	always_unpowered = 1

/area/tcommsat/solar/port
	name = "\improper Telecommunications Port Solar Array"
	icon_state = "tcomsatlounge"

/area/tcommsat/solar/fore
	name = "\improper Telecommunications Fore Solar Array"
	icon_state = "tcomsatlounge"

/area/tcommsat/solar/starboard
	name = "\improper Telecommunications Starboard Solar Array"
	icon_state = "tcomsatlounge"

/area/tcommsat/solar/aft
	name = "\improper Telecommunications Aft Solar Array"
	icon_state = "tcomsatlounge"