/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = ""

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No.

	dynamic_lighting = 0
	luminosity = 1

	plane = SPACE_PLANE
	var/static/list/dust_cache
	var/static/list/speedspace_cache
	var/static/list/phase_shift_by_x
	var/static/list/phase_shift_by_y

/turf/space/New()
	if(!dust_cache)
		build_dust_cache()
	toggle_transit() //add static dust

	if(config)
		update_starlight()

/turf/space/proc/update_starlight()
	if(!config.starlight)
		return

	if(locate(/turf/simulated) in orange(src, 1))
		set_light(config.starlight)
	else
		set_light(0)

/turf/space/proc/build_dust_cache()
	//Static
	dust_cache = list()
	for(var/i in 0 to 25)
		var/image/im = image('icons/turf/space_dust.dmi', "[i]")
		im.plane = SPACE_DUST_PLANE
		im.alpha = 128 //80
		im.blend_mode = BLEND_ADD
		dust_cache["[i]"] = im

	//Moving
	speedspace_cache = list()
	for(var/i in 0 to 14)
		// NORTH/SOUTH
		var/image/im = image('icons/turf/space_transit.dmi', "speedspace_ns_[i]")
		im.plane = SPACE_PARALLAX_PLANE
		im.blend_mode = BLEND_ADD
		speedspace_cache["NS_[i]"] = im
		// EAST/WEST
		im = image('icons/turf/space_transit.dmi', "speedspace_ew_[i]")
		im.plane = SPACE_PARALLAX_PLANE
		im.blend_mode = BLEND_ADD
		speedspace_cache["EW_[i]"] = im

/turf/space/proc/toggle_transit(var/direction)
	overlays.Cut()

	if(!direction)
		overlays |= dust_cache["[((x + y) ^ ~(x * y) + z) % 25]"]
		return

	if(direction & (NORTH|SOUTH))
		if(!phase_shift_by_x)
			phase_shift_by_x = get_cross_shift_list(15)
		var/x_shift = phase_shift_by_x[src.x % (phase_shift_by_x.len - 1) + 1]
		var/transit_state = ((direction & SOUTH ? world.maxy - src.y : src.y) + x_shift)%15
		overlays |= speedspace_cache["NS_[transit_state]"]
	else if(direction & (EAST|WEST))
		if(!phase_shift_by_y)
			phase_shift_by_y = get_cross_shift_list(15)
		var/y_shift = phase_shift_by_y[src.y % (phase_shift_by_y.len - 1) + 1]
		var/transit_state = ((direction & WEST ? world.maxx - src.x : src.x) + y_shift)%15
		overlays |= speedspace_cache["EW_[transit_state]"]

	for(var/atom/movable/AM in src)
		if(AM.simulated && !AM.anchored)
			AM.throw_at(get_step(src, reverse_direction(direction)), 5, 1)

//generates a list used to randomize transit animations so they aren't in lockstep
/turf/space/proc/get_cross_shift_list(var/size)
	var/list/result = list()

	result += rand(0, 14)
	for(var/i in 2 to size)
		var/shifts = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
		shifts -= result[i - 1] //consecutive shifts should not be equal
		if(i == size)
			shifts -= result[1] //because shift list is a ring buffer
		result += pick(shifts)

	return result

/turf/space/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if((user.restrained() || !( user.pulling )))
		return
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		user << "\blue Constructing support lattice ..."
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if (istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	if(movement_disabled)
		usr << "\red Movement is admin-disabled." //This is to identify lag problems
		return
	..()
	if ((!(A) || src != A.loc))	return

	inertial_drift(A)

	if(ticker && ticker.mode)
		// Okay, so let's make it so that people can travel z levels but not nuke disks!
		// if(ticker.mode.name == "nuclear emergency")	return
		if(A.z > 6) return
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE - 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE - 1))
			if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
				qdel(A)
				return

			if(istype(A, /obj/item/weapon/disk/nuclear)) // Don't let nuke disks travel Z levels  ... And moving this shit down here so it only fires when they're actually trying to change z-level.
				qdel(A) //The disk's Del() proc ensures a new one is created
				return

			var/list/disk_search = A.search_contents_for(/obj/item/weapon/disk/nuclear)
			if(!isemptylist(disk_search))
				if(istype(A, /mob/living))
					var/mob/living/MM = A
					if(MM.client && !MM.stat)
						MM << "\red Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is."
						if(MM.x <= TRANSITIONEDGE)
							MM.inertia_dir = 4
						else if(MM.x >= world.maxx -TRANSITIONEDGE)
							MM.inertia_dir = 8
						else if(MM.y <= TRANSITIONEDGE)
							MM.inertia_dir = 1
						else if(MM.y >= world.maxy -TRANSITIONEDGE)
							MM.inertia_dir = 2
					else
						for(var/obj/item/weapon/disk/nuclear/N in disk_search)
							qdel(N)//Make the disk respawn it is on a clientless mob or corpse
				else
					for(var/obj/item/weapon/disk/nuclear/N in disk_search)
						qdel(N)//Make the disk respawn if it is floating on its own
				return

			var/move_to_z = src.z
			var/safety = 1

			while(move_to_z == src.z)
				var/move_to_z_str = pickweight(accessable_z_levels)
				move_to_z = text2num(move_to_z_str)
				safety++
				if(safety > 10)
					break

			if(!move_to_z)
				return

			A.z = move_to_z

			if(src.x <= TRANSITIONEDGE)
				A.x = world.maxx - TRANSITIONEDGE - 2
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if(A.x >= (world.maxx - TRANSITIONEDGE - 1))
				A.x = TRANSITIONEDGE + 1
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if(src.y <= TRANSITIONEDGE)
				A.y = world.maxy - TRANSITIONEDGE -2
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			else if(A.y >= (world.maxy - TRANSITIONEDGE - 1))
				A.y = TRANSITIONEDGE + 1
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			spawn(0)
				if((A && A.loc))
					A.loc.Entered(A)

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||global_map.len)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > global_map.len ? 1 : cur_x)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return