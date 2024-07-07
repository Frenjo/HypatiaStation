//Engineering
/area/station/engineering
	name = "Engineering"
	icon_state = "engine"
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)

/area/station/engineering/hallway
	icon_state = "engine_hallway"

/area/station/engineering/hallway/main
	name = "\improper Engineering Main"

/area/station/engineering/hallway/auxiliary
	name = "\improper Engineering Auxiliary"

/area/station/engineering/foyer
	name = "\improper Engineering Foyer"

/area/station/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engine_storage"

/area/station/engineering/storage/emergency
	name = "\improper Emergency Materials Storage"

/area/station/engineering/storage/eva
	name = "\improper Engineering EVA Storage"

/area/station/engineering/storage/hard
	name = "\improper Engineering Hard Storage"

// SMES Rooms
/area/station/engineering/smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	requires_power = FALSE//This area only covers the batteries and they deal with their own power

/area/station/engineering/smes/supermatter
	name = "\improper Supermatter Engine SMES"

/area/station/engineering/smes/thermoelectric
	name = "\improper Thermoelectric Engine SMES"

/area/station/engineering/smes/singularity
	name = "\improper Singularity Engine SMES"

// Added separate engine rooms for the three engines I mapped...
// Just using instances of /area/engine makes the APCs break. -Frenjo
/area/station/engineering/engine
	area_flags = AREA_FLAG_IS_SURGE_PROTECTED

/area/station/engineering/engine/supermatter
	name = "\improper Supermatter Engine Room"
	icon_state = "engine_sm"

/area/station/engineering/engine/supermatter/monitoring
	name = "\improper Supermatter Monitoring Room"
	icon_state = "engine_monitoring"

/area/station/engineering/engine/singularity
	name = "\improper Singularity Engine Room"
	icon_state = "engine_sing"

/area/station/engineering/engine/singularity/space
	name = "\improper Singularity Engine Space"
	requires_power = FALSE

/area/station/engineering/engine/thermoelectric
	name = "\improper Thermoelectric Engine Room"
	icon_state = "engine_therm"

// Atmospherics
/area/station/engineering/atmospherics
	name = "Atmospherics"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambiatm1.ogg')

/area/station/engineering/atmospherics/control
	name = "Atmospherics Control"
	icon_state = "atmos"
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)