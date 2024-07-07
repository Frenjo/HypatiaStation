/*
 * Maintenance Areas
 */
/area/station/maintenance
	area_flags = AREA_FLAG_IS_SHIELDED

// Fore
/area/station/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/station/maintenance/fore/port
	name = "Fore Port Maintenance"
	icon_state = "fpmaint"

/area/station/maintenance/fore/port_central
	name = "Fore Port Central Maintenance"
	icon_state = "fpmaint"

/area/station/maintenance/fore/starboard
	name = "Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/station/maintenance/fore/starboard_central
	name = "Fore Starboard Central Maintenance"
	icon_state = "fsmaint"

// Central
/area/station/maintenance/central
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/station/maintenance/central/port
	name = "Central Port Maintenance"

/area/station/maintenance/central/starboard
	name = "Central Starboard Maintenance"

// Aft
/area/station/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/station/maintenance/aft/port
	name = "Aft Port Maintenance"
	icon_state = "apmaint"

/area/station/maintenance/aft/starboard
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/station/maintenance/aft/starboard_central
	name = "Aft Starboard Central Maintenance"
	icon_state = "asmaint"

// Incinerator
/area/station/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

/area/station/maintenance/incinerator/space
	name = "\improper Incinerator Space"
	requires_power = FALSE

// Waste Disposal
/area/station/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

// Solars
/area/station/maintenance/solar/fore_port
	name = "Fore Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/station/maintenance/solar/fore_starboard
	name = "Fore Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/station/maintenance/solar/aft_port
	name = "Aft Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/station/maintenance/solar/aft_starboard
	name = "Aft Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"