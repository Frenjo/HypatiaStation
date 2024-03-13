/*
 * Hallway
 */
/area/hallway/New()
	. = ..()
	if(iscontactlevel(z))
		GLOBL.contactable_hallway_areas.Add(src)

/area/hallway/Destroy()
	if(iscontactlevel(z))
		GLOBL.contactable_hallway_areas.Remove(src)
	return ..()

/*
 * Primary
 */
/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"
	ambience = list('sound/ambience/ambiruntime.ogg')

/area/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "\improper Central Primary Hallway"
	icon_state = "hallC"
	ambience = list('sound/ambience/ambiruntime.ogg')

/*
 * Secondary
 */
/area/hallway/secondary/arrivals
	name = "\improper Arrival Shuttle Hallway"
	icon_state = "entry"
	ambience = list(
		'sound/ambience/ambiruntime.ogg',
		'sound/music/title2.ogg'
	)

/area/hallway/secondary/escape
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"