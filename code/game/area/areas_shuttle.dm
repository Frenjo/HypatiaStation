//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.

// Base
/area/shuttle
	requires_power = 0

// Arrival
/area/shuttle/arrival
	name = "\improper Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

// Added these for new stuff. -Frenjo
/area/shuttle/arrival/centcom
	icon_state = "shuttle2"

/area/shuttle/arrival/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/west
// End of new stuff.

// Escape
/area/shuttle/escape
	name = "\improper Emergency Shuttle"
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape/station
	name = "\improper Emergency Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle Centcom"
	icon_state = "shuttle"

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "\improper Emergency Shuttle Transit"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

// Escape Pod 1
/area/shuttle/escape_pod1
	name = "\improper Escape Pod One"
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

// Escape Pod 2
/area/shuttle/escape_pod2
	name = "\improper Escape Pod Two"
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

// Escape Pod 3
/area/shuttle/escape_pod3
	name = "\improper Escape Pod Three"
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/east

// Escape Pod 5
/area/shuttle/escape_pod5 //Pod 4 was lost to meteors
	name = "\improper Escape Pod Five"
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod5/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/west

// Mining
/area/shuttle/mining
	name = "\improper Mining Shuttle"
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/mining/station
	icon_state = "shuttle2"

/area/shuttle/mining/outpost
	icon_state = "shuttle"

// Transport
/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Centcom"

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "\improper Transport Shuttle"

// Alien
/area/shuttle/alien/base
	icon_state = "shuttle"
	name = "\improper Alien Shuttle Base"
	requires_power = 1

/area/shuttle/alien/mine
	icon_state = "shuttle"
	name = "\improper Alien Shuttle Mine"
	requires_power = 1

// Prison
/area/shuttle/prison
	name = "\improper Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

// Special Ops
/area/shuttle/specops/centcom
	name = "\improper Special Ops Shuttle"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "\improper Special Ops Shuttle"
	icon_state = "shuttlered2"

// Syndicate Elite
/area/shuttle/syndicate_elite/mothership
	name = "\improper Syndicate Elite Shuttle"
	icon_state = "shuttlered"

/area/shuttle/syndicate_elite/station
	name = "\improper Syndicate Elite Shuttle"
	icon_state = "shuttlered2"

// Administration
/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle Centcom"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor

/area/shuttle/administration/station
	name = "\improper Administration Shuttle"
	icon_state = "shuttlered2"

// Thunderdome
/area/shuttle/thunderdome
	name = "honk"

/area/shuttle/thunderdome/grnshuttle
	name = "\improper Thunderdome GRN Shuttle"
	icon_state = "green"

/area/shuttle/thunderdome/grnshuttle/dome
	name = "\improper GRN Shuttle"
	icon_state = "shuttlegrn"

/area/shuttle/thunderdome/grnshuttle/station
	name = "\improper GRN Station"
	icon_state = "shuttlegrn2"

/area/shuttle/thunderdome/redshuttle
	name = "\improper Thunderdome RED Shuttle"
	icon_state = "red"

/area/shuttle/thunderdome/redshuttle/dome
	name = "\improper RED Shuttle"
	icon_state = "shuttlered"

/area/shuttle/thunderdome/redshuttle/station
	name = "\improper RED Station"
	icon_state = "shuttlered2"

// Research
/area/shuttle/research
	name = "\improper Research Shuttle"
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/research/station
	icon_state = "shuttle2"

/area/shuttle/research/outpost
	icon_state = "shuttle"

// Vox
/area/shuttle/vox/station
	name = "\improper Vox Skipjack"
	icon_state = "yellow"
	requires_power = 0

// Engineering
// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
/area/shuttle/engineering
	name ="\improper Engineering Shuttle"

/area/shuttle/engineering/station
	icon_state = "shuttle2"

/area/shuttle/engineering/outpost
	icon_state = "shuttle"