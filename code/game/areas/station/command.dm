/*
 * Command Areas
 */
/area/station/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	ambience = list(
		'sound/ambience/signal.ogg',
		'sound/music/title2.ogg'
	)

/area/station/command/bridge/meeting_room
	name = "\improper Heads of Staff Meeting Room"
	icon_state = "conference"
	ambience = list()

// Head of Staff Offices
/area/station/command/office/captain
	name = "\improper Captain's Office"
	icon_state = "captain"

/area/station/command/office/hop
	name = "\improper Head of Personnel's Office"
	icon_state = "head_quarters"

/area/station/command/office/rd
	name = "\improper Research Director's Office"
	icon_state = "head_quarters"

/area/station/command/office/hos
	name = "\improper Head of Security's Office"
	icon_state = "sec_hos"

/area/station/command/office/ce
	name = "\improper Chief Engineer's Office"
	icon_state = "head_quarters"

/area/station/command/office/cmo
	name = "\improper Chief Medical Officer's Office"
	icon_state = "CMO"

// Teleporter
/area/station/command/teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

// Gateway
/area/station/command/gateway
	name = "\improper Gateway"
	icon_state = "teleporter"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

// Vault
/area/station/command/vault
	name = "\improper Vault"
	icon_state = "nuke_storage"