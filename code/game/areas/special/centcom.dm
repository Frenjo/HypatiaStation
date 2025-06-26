/*
 * CentCom
 */
/area/centcom
	name = "\improper CentCom"
	icon_state = "centcom"
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/centcom/control
	name = "\improper CentCom Control"

/area/centcom/test
	name = "\improper CentCom Testing Facility"

/area/centcom/living
	name = "\improper CentCom Living Quarters"

/area/centcom/specops
	name = "\improper CentCom Special Ops"

/area/centcom/creed
	name = "CentCom Creed's Office"

/area/centcom/holding
	name = "\improper CentCom Holding Facility"

/area/centcom/solitary
	name = "CentCom Solitary Confinement"
	icon_state = "brig"

/*
 * Shuttle Docks
 */
/area/centcom/shuttle_dock
	name = "\improper CentCom Shuttle Dock"

/area/centcom/shuttle_dock/emergency
	name = "\improper CentCom Emergency Shuttle Dock"

/area/centcom/shuttle_dock/supply
	name = "\improper CentCom Supply Shuttle Dock"

/area/centcom/shuttle_dock/ferry
	name = "\improper CentCom Transport Shuttle Dock"

/area/centcom/shuttle_dock/administration
	name = "\improper CentCom Administration Shuttle Dock"

/area/centcom/shuttle_dock/arrival
	name = "\improper CentCom Arrival Shuttle Dock"

/*
 * Rescue Shuttle
 *	(That little white ship next to CentCom where the escape pods dock.)
 *
 * This used to use the same area as the old /area/centcom/evac (now /area/centcom/shuttle_dock/emergency)...
 * ... So was just labelled as "CentCom Emergency Shuttle". I think "Rescue Shuttle" makes more sense as it's for rescuing escape pods...
 * ... And is less confusing, otherwise we'd have "CentCom Emergency Shuttle", "CentCom Emergency Shuttle Dock" and "Emergency Shuttle CentCom".
 */
/area/centcom/rescue_shuttle/one
	name = "\improper CentCom Rescue Shuttle One"

// Now there's two of them!
/area/centcom/rescue_shuttle/two
	name = "\improper CentCom Rescue Shuttle Two"

/*
 * Thunderdome
 *
 * THUNDERDOME
 */
/area/centcom/tdome
	name = "\improper Thunderdome"
	icon_state = "thunder"
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/centcom/tdome/team_one
	name = "\improper Thunderdome (Team 1)"
	icon_state = "green"

/area/centcom/tdome/team_two
	name = "\improper Thunderdome (Team 2)"
	icon_state = "yellow"

/area/centcom/tdome/admin
	name = "\improper Thunderdome (Admin)"
	icon_state = "purple"

/area/centcom/tdome/observation
	name = "\improper Thunderdome (Observer)"
	icon_state = "purple"