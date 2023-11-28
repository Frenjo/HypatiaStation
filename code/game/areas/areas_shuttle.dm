//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.
/*
 * Base.
 */
/area/shuttle
	requires_power = FALSE

/*
 * Arrival.
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
 * Escape.
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
 * Escape Pods.
 */
// Escape Pod 1
/area/shuttle/escape_pod1
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod1/station
	name = "\improper Escape Pod One Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod1/centcom
	name = "\improper Escape Pod One CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod1/transit
	name = "\improper Escape Pod One Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/north

// Escape Pod 2
/area/shuttle/escape_pod2
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod2/station
	name = "\improper Escape Pod Two Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod2/centcom
	name = "\improper Escape Pod Two CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod2/transit
	name = "\improper Escape Pod Two Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/north

// Escape Pod 3
/area/shuttle/escape_pod3
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod3/station
	name = "\improper Escape Pod Three Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod3/centcom
	name = "\improper Escape Pod Three CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod3/transit
	name = "\improper Escape Pod Three Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/east

// Escape Pod 5
/area/shuttle/escape_pod5 // Pod 4 was lost to meteors.
	/*
	ambience = list(
		'sound/music/escape.ogg'
	)
	*/

/area/shuttle/escape_pod5/station
	name = "\improper Escape Pod Five Station"
	icon_state = "shuttle2"

/area/shuttle/escape_pod5/centcom
	name = "\improper Escape Pod Five CentCom"
	icon_state = "shuttle"

/area/shuttle/escape_pod5/transit
	name = "\improper Escape Pod Five Transit"
	icon_state = "shuttle"
	parallax_type = PARALLAX_BLUESPACE
	base_turf = /turf/space/transit/west

/*
 * Mining.
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
 * Transport.
 */
/area/shuttle/transport1/centcom
	name = "\improper Transport Shuttle CentCom"
	icon_state = "shuttle"
	base_turf = /turf/unsimulated/floor

/area/shuttle/transport1/station
	name = "\improper Transport Shuttle Station"
	icon_state = "shuttle"

/*
 * Alien.
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
 * Prison.
 */
/area/shuttle/prison/station
	name = "\improper Prison Shuttle Station"
	icon_state = "shuttle"

/area/shuttle/prison/prison
	name = "\improper Prison Shuttle Satellite"
	icon_state = "shuttle2"

/*
 * Special Ops.
 */
/area/shuttle/specops/centcom
	name = "\improper Special Ops Shuttle CentCom"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "\improper Special Ops Shuttle Station"
	icon_state = "shuttlered2"

/*
 * Syndicate Elite.
 */
/area/shuttle/syndicate_elite/mothership
	name = "\improper Syndicate Elite Shuttle Mothership"
	icon_state = "shuttlered"

/area/shuttle/syndicate_elite/station
	name = "\improper Syndicate Elite Shuttle Station"
	icon_state = "shuttlered2"

/*
 * Administration.
 */
/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle CentCom"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor

/area/shuttle/administration/station
	name = "\improper Administration Shuttle Station"
	icon_state = "shuttlered2"

/*
 * Research.
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

/*
 * Vox.
 */
/area/shuttle/vox/station
	name = "\improper Vox Skipjack Station"
	icon_state = "yellow"

// Engineering
// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
/area/shuttle/engineering/station
	name = "\improper Engineering Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/engineering/outpost
	name = "\improper Engineering Shuttle Outpost"
	icon_state = "shuttle"

/*
 * Supply.
 */
/area/shuttle/supply/centcom
	name = "\improper Supply Shuttle CentCom"
	icon_state = "shuttle3"

/area/shuttle/supply/station
	name = "\improper Supply Shuttle Station"
	icon_state = "shuttle3"