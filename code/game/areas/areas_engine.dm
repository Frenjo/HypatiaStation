//Engineering
/area/engineering
	name = "Engineering"
	icon_state = "engine"
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)

/area/engineering/hallway
	icon_state = "engine_hallway"

/area/engineering/hallway/main
	name = "\improper Engineering Main"

/area/engineering/hallway/auxiliary
	name = "\improper Engineering Auxiliary"

/area/engineering/foyer
	name = "\improper Engineering Foyer"

/area/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engine_storage"

/area/engineering/storage/emergency
	name = "\improper Emergency Materials Storage"

/area/engineering/storage/eva
	name = "\improper Engineering EVA Storage"

/area/engineering/storage/hard
	name = "\improper Engineering Hard Storage"

// SMES Rooms
/area/engineering/smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	requires_power = FALSE//This area only covers the batteries and they deal with their own power

/area/engineering/smes/supermatter
	name = "\improper Supermatter Engine SMES"

/area/engineering/smes/thermoelectric
	name = "\improper Thermoelectric Engine SMES"

/area/engineering/smes/singularity
	name = "\improper Singularity Engine SMES"

// Added separate engine rooms for the three engines I mapped...
// Just using instances of /area/engine makes the APCs break. -Frenjo
/area/engineering/engine/supermatter
	name = "\improper Supermatter Engine Room"
	icon_state = "engine_sm"

/area/engineering/engine/supermatter/monitoring
	name = "\improper Supermatter Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engine/singularity
	name = "\improper Singularity Engine Room"
	icon_state = "engine_sing"

/area/engineering/engine/singularity/space
	name = "\improper Singularity Engine Space"
	requires_power = FALSE

/area/engineering/engine/thermoelectric
	name = "\improper Thermoelectric Engine Room"
	icon_state = "engine_therm"

// Atmospherics
/area/engineering/atmospherics
	name = "Atmospherics"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambiatm1.ogg')

/area/engineering/atmospherics/control
	name = "Atmospherics Control"
	icon_state = "atmos"
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)

// Solars
/area/solar
	requires_power = TRUE
	always_unpowered = TRUE

/area/solar/fore/port
	name = "\improper Fore Port Solar Array"
	icon_state = "panelsP"

/area/solar/fore/starboard
	name = "\improper Fore Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/aft/port
	name = "\improper Aft Port Solar Array"
	icon_state = "panelsP"

/area/solar/aft/starboard
	name = "\improper Aft Starboard Solar Array"
	icon_state = "panelsS"

// Construction
/area/construction
	name = "\improper Construction Area"
	icon_state = "yellow"