//Engineering
/area/engine
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)

/area/engine/smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	requires_power = 0//This area only covers the batteries and they deal with their own power

/area/engine/smes/supermatter
	name = "\improper Supermatter Engine SMES"

/area/engine/smes/thermoelectric
	name = "\improper Thermoelectric Engine SMES"

/area/engine/smes/singularity
	name = "\improper Singularity Engine SMES"

/area/engine/engineering
	name = "Engineering"
	icon_state = "engine"

/area/engine/break_room
	name = "\improper Engineering Foyer"
	icon_state = "engine"

/area/engine/emerg_storage
	name = "\improper Emergency Materials Storage"
	icon_state = "engine_storage"

/area/engine/chiefs_office
	name = "\improper Chief Engineer's office"
	icon_state = "engine_control"

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
	icon_state = "engine_sing"
	requires_power = 0

/area/engine/thermoelectric_engine
	name = "\improper Thermoelectric Engine Room"
	icon_state = "engine_therm"

//Solars
/area/solar
	requires_power = 1
	always_unpowered = 1

/area/solar/auxport
	name = "\improper Fore Port Solar Array"
	icon_state = "panelsA"

/area/solar/auxstarboard
	name = "\improper Fore Starboard Solar Array"
	icon_state = "panelsA"

/area/solar/fore
	name = "\improper Fore Solar Array"
	icon_state = "yellow"

/area/solar/aft
	name = "\improper Aft Solar Array"
	icon_state = "aft"

/area/solar/starboard
	name = "\improper Aft Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/port
	name = "\improper Aft Port Solar Array"
	icon_state = "panelsP"

// Atmos
/area/atmos
	name = "Atmospherics"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambiatm1.ogg')

//Construction
/area/construction
	name = "\improper Construction Area"
	icon_state = "yellow"

/area/construction/checkpoint
	name = "\improper Construction Area"
	icon_state = "yellow"

/area/construction/supplyshuttle
	name = "\improper Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "\improper Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "\improper Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "\improper Solar Panels"
	icon_state = "yellow"

/area/construction/solarscontrol
	name = "\improper Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"