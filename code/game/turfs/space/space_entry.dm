// Ported from unstable r355
/turf/space/Entered(atom/movable/A)
	if(movement_disabled)
		FEEDBACK_MOVEMENT_ADMIN_DISABLED(usr) // This is to identify lag problems.
		return
	. = ..()
	if(isnull(A) || src != A.loc)
		return

	inertial_drift(A)

	if(isnotnull(global.PCticker?.mode))
		// Okay, so let's make it so that people can travel z levels but not nuke disks!
		// if(IS_GAME_MODE(/datum/game_mode/nuclear))
		//	return
		if(A.z > 6)
			return
		if(A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE - 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE - 1))
			if(istype(A, /obj/effect/meteor) || istype(A, /obj/effect/space_dust))
				qdel(A)
				return

			if(istype(A, /obj/item/disk/nuclear)) // Don't let nuke disks travel Z levels  ... And moving this shit down here so it only fires when they're actually trying to change z-level.
				qdel(A) //The disk's Del() proc ensures a new one is created
				return

			var/list/disk_search = A.search_contents_for(/obj/item/disk/nuclear)
			if(!isemptylist(disk_search))
				if(isliving(A))
					var/mob/living/living = A
					if(isnotnull(living.client) && !living.stat)
						to_chat(living, SPAN_WARNING("Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is."))
						if(living.x <= TRANSITIONEDGE)
							living.inertia_dir = 4
						else if(living.x >= world.maxx -TRANSITIONEDGE)
							living.inertia_dir = 8
						else if(living.y <= TRANSITIONEDGE)
							living.inertia_dir = 1
						else if(living.y >= world.maxy -TRANSITIONEDGE)
							living.inertia_dir = 2
					else
						for(var/obj/item/disk/nuclear/N in disk_search)
							qdel(N)//Make the disk respawn it is on a clientless mob or corpse
				else
					for(var/obj/item/disk/nuclear/N in disk_search)
						qdel(N)//Make the disk respawn if it is floating on its own
				return

			var/move_to_z = z
			var/safety = 1

			while(move_to_z == z)
				var/move_to_z_str = pickweight(GLOBL.accessible_z_levels)
				move_to_z = text2num(move_to_z_str)
				safety++
				if(safety > 10)
					break

			if(!move_to_z)
				return

			A.z = move_to_z

			if(x <= TRANSITIONEDGE)
				A.x = world.maxx - TRANSITIONEDGE - 2
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if(A.x >= (world.maxx - TRANSITIONEDGE - 1))
				A.x = TRANSITIONEDGE + 1
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if(y <= TRANSITIONEDGE)
				A.y = world.maxy - TRANSITIONEDGE -2
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			else if(A.y >= (world.maxy - TRANSITIONEDGE - 1))
				A.y = TRANSITIONEDGE + 1
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			spawn(0)
				A?.loc?.Entered(A)