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

/area/security/warden
	name = "\improper Warden"
	icon_state = "Warden"

/area/security/armoury
	name = "\improper Armoury"
	icon_state = "Warden"

/area/security/hos
	name = "\improper Head of Security's Office"
	icon_state = "sec_hos"

/area/security/detectives_office
	name = "\improper Detective's Office"
	icon_state = "detective"

/area/security/range
	name = "\improper Firing Range"
	icon_state = "firingrange"

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

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"

/area/security/vacantoffice
	name = "\improper Vacant Office"

/area/security/headdorms
	name = "\improper Head Dormitories"

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
	name = "Security Post - Cargo Bay"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"

/area/security/checkpoint/science
	name = "Security Post - Science"