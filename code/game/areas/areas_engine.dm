//Engineering
/area/engine
	icon_state = "engine"
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)

/area/engine/smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	requires_power = FALSE//This area only covers the batteries and they deal with their own power

/area/engine/smes/supermatter
	name = "\improper Supermatter Engine SMES"

/area/engine/smes/thermoelectric
	name = "\improper Thermoelectric Engine SMES"

/area/engine/smes/singularity
	name = "\improper Singularity Engine SMES"

/area/engine/engineering
	name = "Engineering"

/area/engine/break_room
	name = "\improper Engineering Foyer"

/area/engine/emerg_storage
	name = "\improper Emergency Materials Storage"
	icon_state = "engine_storage"

/area/engine/engineering_eva
	name = "\improper Engineering EVA Storage"
	icon_state = "engine_storage"

// Added separate engine rooms for the three engines I mapped...
// Just using instances of /area/engine makes the APCs break. -Frenjo
/area/engine/supermatter_engine
	name = "\improper Supermatter Engine Room"
	icon_state = "engine_sm"

/area/engine/supermatter_engine/monitoring
	name = "\improper Supermatter Monitoring Room"
	icon_state = "engine_control"

/area/engine/singularity_engine
	name = "\improper Singularity Engine Room"
	icon_state = "engine_sing"

/area/engine/singularity_engine/space
	name = "\improper Singularity Engine Space"
	requires_power = FALSE

/area/engine/thermoelectric_engine
	name = "\improper Thermoelectric Engine Room"
	icon_state = "engine_therm"

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

// Atmos
/area/atmos
	name = "Atmospherics"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambiatm1.ogg')

//Construction
/area/construction
	name = "\improper Construction Area"
	icon_state = "yellow"