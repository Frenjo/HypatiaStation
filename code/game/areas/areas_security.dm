/*
 * Security
 */
/area/security
	icon_state = "security"

/area/security/main
	name = "\improper Security Office"

/area/security/lobby
	name = "\improper Security Lobby"

/area/security/brig
	name = "\improper Brig"
	icon_state = "brig"

/area/security/evidence_storage
	name = "\improper Evidence Storage"

/area/security/range
	name = "\improper Firing Range"
	icon_state = "firingrange"

/area/security/armoury
	name = "\improper Armoury"
	icon_state = "armoury"

/area/security/warden
	name = "\improper Warden's Office"
	icon_state = "Warden"

/area/security/detective
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

/*
 * Security Posts
 */
/area/security/post
	name = "\improper Security Post"

/area/security/post/arrivals
	name = "\improper Arrivals Security Post"

/area/security/post/starboard
	name = "\improper Starboard Security Post"

/*
 * Security Checkpoints
 */
/area/security/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint/supply
	name = "Security Checkpoint - Cargo Bay"

/area/security/checkpoint/engineering
	name = "Security Checkpoint - Engineering"

/area/security/checkpoint/medical
	name = "Security Checkpoint - Medbay"

/area/security/checkpoint/science
	name = "Security Checkpoint - Science"