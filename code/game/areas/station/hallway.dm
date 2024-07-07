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
/area/station/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/station/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"
	ambience = list('sound/ambience/ambiruntime.ogg')

/area/station/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/station/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/station/hallway/primary/central
	name = "\improper Central Primary Hallway"
	icon_state = "hallC"
	ambience = list('sound/ambience/ambiruntime.ogg')

/*
 * Secondary
 */
/area/station/hallway/secondary/arrivals
	name = "\improper Arrival Shuttle Hallway"
	icon_state = "entry"
	ambience = list(
		'sound/ambience/ambiruntime.ogg',
		'sound/music/title2.ogg'
	)

/area/station/hallway/secondary/escape
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"