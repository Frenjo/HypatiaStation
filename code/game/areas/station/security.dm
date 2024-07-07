/*
 * Security Areas
 */
/area/station/security
	icon_state = "security"

/area/station/security/main
	name = "\improper Security Office"

/area/station/security/lobby
	name = "\improper Security Lobby"

/area/station/security/brig
	name = "\improper Brig"
	icon_state = "brig"

/area/station/security/evidence_storage
	name = "\improper Evidence Storage"

/area/station/security/range
	name = "\improper Firing Range"
	icon_state = "firingrange"

/area/station/security/armoury
	name = "\improper Armoury"
	icon_state = "armoury"

/area/station/security/warden
	name = "\improper Warden's Office"
	icon_state = "Warden"

/area/station/security/detective
	name = "\improper Detective's Office"
	icon_state = "detective"

/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

// Posts
/area/station/security/post
	name = "\improper Security Post"

/area/station/security/post/arrivals
	name = "\improper Arrivals Security Post"

/area/station/security/post/starboard
	name = "\improper Starboard Security Post"

// Checkpoints
/area/station/security/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/station/security/checkpoint/supply
	name = "Security Checkpoint - Cargo Bay"

/area/station/security/checkpoint/engineering
	name = "Security Checkpoint - Engineering"

/area/station/security/checkpoint/medical
	name = "Security Checkpoint - Medbay"

/area/station/security/checkpoint/science
	name = "Security Checkpoint - Science"