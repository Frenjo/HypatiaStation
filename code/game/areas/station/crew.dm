/*
 * Crew Areas
 */
/area/station/crew
	name = "\improper Crew Quarters"
	icon_state = "crew_quarters"

// Dormitories
/area/station/crew/dormitories
	name = "\improper Dormitories"
	icon_state = "Sleep"
	area_flags = AREA_FLAG_IS_SHIELDED

/area/station/crew/dormitories/bedroom
	name = "\improper Dormitory Bedroom"

/area/station/crew/dormitories/cabin1
	name = "\improper Dormitory Cabin 1"

/area/station/crew/dormitories/cabin2
	name = "\improper Dormitory Cabin 2"

/area/station/crew/dormitories/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "cryo"

/area/station/crew/dormitories/toilet
	name = "\improper Dormitory Toilets"
	icon_state = "toilet"

// Fitness Room
/area/station/crew/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

// Locker Room
/area/station/crew/locker_room
	name = "\improper Locker Room"
	icon_state = "locker"

/area/station/crew/locker_room/toilet
	name = "\improper Locker Room Toilets"
	icon_state = "toilet"

// Main
/area/station/crew/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/station/crew/kitchen/fridge
	name = "\improper Kitchen Fridge"

/area/station/crew/bar
	name = "\improper Bar"
	icon_state = "bar"

/area/station/crew/custodial
	name = "\improper Custodial Closet"
	icon_state = "janitor"

/area/station/crew/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/station/crew/library
 	name = "\improper Library"
 	icon_state = "library"

/area/station/crew/bunker
	name = "\improper Bunker"
	icon_state = "locker"
	area_flags = AREA_FLAG_IS_SURGE_PROTECTED

/area/station/crew/theatre
	name = "\improper Theatre"
	icon_state = "Theatre"

// Chapel
/area/station/crew/chapel
	icon_state = "chapel"

	ambience = list(
		'sound/ambience/ambicha1.ogg',
		'sound/ambience/ambicha2.ogg',
		'sound/ambience/ambicha3.ogg',
		'sound/ambience/ambicha4.ogg',
		'sound/music/traitor.ogg'
	)

/area/station/crew/chapel/main
	name = "\improper Chapel"

/area/station/crew/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"

// Offices
/area/station/crew/law_office
	name = "\improper Law Office"
	icon_state = "law"

/area/station/crew/vacant_office
	name = "\improper Vacant Office"