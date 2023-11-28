// DJ Station
/area/djstation
	name = "\improper Ruskie DJ Station"
	icon_state = "DJ"

/area/djstation/solars
	name = "\improper DJ Station Solars"
	icon_state = "DJ"

// Derelict
// THE Derelict, not derelict the adjective.
/area/derelict
	name = "\improper Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "\improper Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "\improper Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "\improper Derelict Arrival Centre"
	icon_state = "entry"

/area/derelict/bridge
	name = "\improper Derelict Control Room"
	icon_state = "bridge"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "\improper Derelict Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "\improper Derelict Solar Control"
	icon_state = "engine"

/area/derelict/medical
	name = "Derelict Medical Bay"
	icon_state = "medbay"

/area/derelict/medical/chapel
	name = "\improper Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "\improper Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/solar/starboard
	name = "\improper Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/derelict/solar/aft
	name = "\improper Derelict Aft Solar Array"
	icon_state = "panelsA"

/area/derelict/singularity_engine
	name = "\improper Derelict Singularity Engine"
	icon_state = "engine_sing"

// White Ship
/area/abandoned/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

// Old AI Satellite
/area/abandoned/ai_satellite_teleporter
	name = "\improper Abandoned AI Satellite Teleporter Room"
	icon_state = "teleporter"
	ambience = list(
		'sound/ambience/signal.ogg',
		'sound/ambience/ambimalf.ogg'
	)

 // Derelict Assembly Line
 // This was originally /area/assembly/assembly_line.
 // I'm not sure if THE Derelict ever had an assembly line, or this is just A derelict assembly line.
/area/abandoned/assembly_line
	name = "\improper Assembly Line"
	icon_state = "ass_line"
	power_equip = 0
	power_light = 0
	power_environ = 0