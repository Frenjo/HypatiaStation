/*
 * Hallway Areas
 */
/area/station/hallway/New()
	. = ..()
	if(iscontactlevel(z))
		GLOBL.contactable_hallway_areas.Add(src)

/area/station/hallway/Destroy()
	if(iscontactlevel(z))
		GLOBL.contactable_hallway_areas.Remove(src)
	return ..()

/*
 * Primary
 */
/area/station/hallway/primary
	ambience = list(
		// Standard station ambience
		'sound/ambience/general/ambigen1.ogg',
		'sound/ambience/general/ambigen3.ogg',
		'sound/ambience/general/ambigen4.ogg',
		'sound/ambience/general/ambigen5.ogg',
		'sound/ambience/general/ambigen6.ogg',
		'sound/ambience/general/ambigen7.ogg',
		'sound/ambience/general/ambigen8.ogg',
		'sound/ambience/general/ambigen9.ogg',
		'sound/ambience/general/ambigen10.ogg',
		'sound/ambience/general/ambigen11.ogg',
		'sound/ambience/general/ambigen12.ogg',
		'sound/ambience/general/ambigen14.ogg',
		// Primary hallway specific
		'sound/ambience/general/ambiruntime.ogg'
	)

/area/station/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/station/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/station/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/station/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/station/hallway/primary/central
	name = "\improper Central Primary Hallway"
	icon_state = "hallC"

/*
 * Secondary
 */
/area/station/hallway/secondary/arrivals
	name = "\improper Arrival Shuttle Hallway"
	icon_state = "entry"
	ambience = list(
		// Standard station ambience
		'sound/ambience/general/ambigen1.ogg',
		'sound/ambience/general/ambigen3.ogg',
		'sound/ambience/general/ambigen4.ogg',
		'sound/ambience/general/ambigen5.ogg',
		'sound/ambience/general/ambigen6.ogg',
		'sound/ambience/general/ambigen7.ogg',
		'sound/ambience/general/ambigen8.ogg',
		'sound/ambience/general/ambigen9.ogg',
		'sound/ambience/general/ambigen10.ogg',
		'sound/ambience/general/ambigen11.ogg',
		'sound/ambience/general/ambigen12.ogg',
		'sound/ambience/general/ambigen14.ogg',
		// Some extras specific to arrivals/departures.
		'sound/ambience/general/ambiruntime.ogg',
		'sound/ambience/general/ambigen2.ogg',
		'sound/ambience/general/ambigen13.ogg'
	)

/area/station/hallway/secondary/escape
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"
	ambience = list(
		// Standard station ambience
		'sound/ambience/general/ambigen1.ogg',
		'sound/ambience/general/ambigen3.ogg',
		'sound/ambience/general/ambigen4.ogg',
		'sound/ambience/general/ambigen5.ogg',
		'sound/ambience/general/ambigen6.ogg',
		'sound/ambience/general/ambigen7.ogg',
		'sound/ambience/general/ambigen8.ogg',
		'sound/ambience/general/ambigen9.ogg',
		'sound/ambience/general/ambigen10.ogg',
		'sound/ambience/general/ambigen11.ogg',
		'sound/ambience/general/ambigen12.ogg',
		'sound/ambience/general/ambigen14.ogg',
		// Some extras specific to arrivals/departures.
		'sound/ambience/general/ambiruntime.ogg',
		'sound/ambience/general/ambigen2.ogg',
		'sound/ambience/general/ambigen13.ogg'
	)