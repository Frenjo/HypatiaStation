//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.
/*
 * Base
 */
/area/shuttle
	requires_power = FALSE

/*
 * Arrival
 */
/area/shuttle/arrival/station
	name = "\improper Arrival Shuttle Station"
	icon_state = "shuttle"

// Added these for new stuff. -Frenjo
/area/shuttle/arrival/centcom
	name = "\improper Arrival Shuttle CentCom"
	icon_state = "shuttle2"

/area/shuttle/arrival/transit
	name = "\improper Arrival Shuttle Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/west
// End of new stuff.

/*
 * Escape
 */
/area/shuttle/escape
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape/station
	name = "\improper Emergency Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle CentCom"
	icon_state = "shuttle"

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "\improper Emergency Shuttle Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/north

/*
 * Escape Pods
 */
/area/shuttle/escape_pod
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

// Escape Pod 1
/area/shuttle/escape_pod/one/station
	name = "\improper Escape Pod One Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod/one/centcom
	name = "\improper Escape Pod One CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod/one/transit
	name = "\improper Escape Pod One Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/north

// Escape Pod 2
/area/shuttle/escape_pod/two/station
	name = "\improper Escape Pod Two Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod/two/centcom
	name = "\improper Escape Pod Two CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod/two/transit
	name = "\improper Escape Pod Two Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/north

// Escape Pod 3
/area/shuttle/escape_pod/three/station
	name = "\improper Escape Pod Three Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod/three/centcom
	name = "\improper Escape Pod Three CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod/three/transit
	name = "\improper Escape Pod Three Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/east

// Escape Pod 4 - Recovered from being lost to meteors and restored to working condition.
/area/shuttle/escape_pod/four/station
	name = "\improper Escape Pod Four Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod/four/centcom
	name = "\improper Escape Pod Four CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod/four/transit
	name = "\improper Escape Pod Four Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/south

// Escape Pod 5
/area/shuttle/escape_pod/five/station
	name = "\improper Escape Pod Five Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod/five/centcom
	name = "\improper Escape Pod Five CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod/five/transit
	name = "\improper Escape Pod Five Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/west

/*
 * Mining
 */
/area/shuttle/mining
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/mining/station
	name = "\improper Mining Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/mining/outpost
	name = "\improper Mining Shuttle Outpost"
	icon_state = "shuttle"

/*
 * Transport
 */
/area/shuttle/transport/centcom
	name = "\improper Transport Shuttle CentCom"
	icon_state = "shuttle"
	base_turf = /turf/open/floor/plating/metal

/area/shuttle/transport/station
	name = "\improper Transport Shuttle Station"
	icon_state = "shuttle"

/*
 * Alien
 */
/area/shuttle/alien/base
	icon_state = "shuttle"
	name = "\improper Alien Shuttle Base"
	requires_power = TRUE

/area/shuttle/alien/mine
	icon_state = "shuttle"
	name = "\improper Alien Shuttle Mine"
	requires_power = TRUE

/*
 * Prison
 */
/area/shuttle/prison/station
	name = "\improper Prison Shuttle Station"
	icon_state = "shuttle"

/area/shuttle/prison/prison
	name = "\improper Prison Shuttle Satellite"
	icon_state = "shuttle2"

/*
 * Special Ops
 */
/area/shuttle/specops/centcom
	name = "\improper Special Ops Shuttle CentCom"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "\improper Special Ops Shuttle Station"
	icon_state = "shuttlered2"

// Syndicate Mercenary
/area/shuttle/syndicate/mercenary
	name = "\improper Syndicate Mercenary Shuttle"
	icon_state = "shuttlered"

/area/shuttle/syndicate/mercenary/start
	name = "\improper Syndicate Forward Operating Base"
	base_turf = /turf/open/floor/plating/metal

/area/shuttle/syndicate/mercenary/southwest
	name = "\improper South-West of SS13"
	icon_state = "southwest"

/area/shuttle/syndicate/mercenary/northwest
	name = "\improper North-West of SS13"
	icon_state = "northwest"

/area/shuttle/syndicate/mercenary/northeast
	name = "\improper North-East of SS13"
	icon_state = "northeast"

/area/shuttle/syndicate/mercenary/southeast
	name = "\improper Nouth-East of SS13"
	icon_state = "southeast"

/area/shuttle/syndicate/mercenary/north
	name = "\improper North of SS13"
	icon_state = "north"

/area/shuttle/syndicate/mercenary/south
	name = "\improper South of SS13"
	icon_state = "south"

/area/shuttle/syndicate/mercenary/commssat
	name = "\improper South of the communication satellite"
	icon_state = "south"

/area/shuttle/syndicate/mercenary/mining
	name = "\improper North-East of the mining asteroid"
	icon_state = "north"

/area/shuttle/syndicate/mercenary/transit
	name = "\improper Hyperspace"
	base_turf = /turf/space/transit/north

// Syndicate Elite
/area/shuttle/syndicate/elite/mothership
	name = "\improper Syndicate Elite Shuttle Mothership"
	icon_state = "shuttlered"

/area/shuttle/syndicate/elite/station
	name = "\improper Syndicate Elite Shuttle Station"
	icon_state = "shuttlered2"

/*
 * Administration
 */
/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle CentCom"
	icon_state = "shuttlered"
	base_turf = /turf/open/floor/plating/metal

/area/shuttle/administration/station
	name = "\improper Administration Shuttle Station"
	icon_state = "shuttlered2"

/*
 * Research
 */
/area/shuttle/research
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/research/station
	name = "\improper Research Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/research/outpost
	name = "\improper Research Shuttle Outpost"
	icon_state = "shuttle"

// Vox
/area/shuttle/vox
	name = "\improper Vox Skipjack"

/area/shuttle/vox/start
	name = "\improper Vox Skipjack Start"
	icon_state = "shuttle"

/area/shuttle/vox/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

/area/shuttle/vox/southwest_solars
	name = "\improper Aft Port Solars"
	icon_state = "southwest"
	requires_power = FALSE

/area/shuttle/vox/northwest_solars
	name = "\improper Fore Port Solars"
	icon_state = "northwest"
	requires_power = FALSE

/area/shuttle/vox/northeast_solars
	name = "\improper Fore Starboard Solars"
	icon_state = "northeast"
	requires_power = FALSE

/area/shuttle/vox/southeast_solars
	name = "\improper Aft Starboard Solars"
	icon_state = "southeast"
	requires_power = FALSE

/area/shuttle/vox/mining
	name = "\improper Nearby mining asteroid"
	icon_state = "north"
	requires_power = FALSE

// Engineering
// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
/area/shuttle/engineering/station
	name = "\improper Engineering Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/engineering/outpost
	name = "\improper Engineering Shuttle Outpost"
	icon_state = "shuttle"

/*
 * Supply
 */
/area/shuttle/supply/centcom
	name = "\improper Supply Shuttle CentCom"
	icon_state = "shuttle3"
	base_turf = /turf/open/floor/plating/metal

/area/shuttle/supply/station
	name = "\improper Supply Shuttle Station"
	icon_state = "shuttle3"