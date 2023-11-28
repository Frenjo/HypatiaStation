/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = ""

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No.

	dynamic_lighting = FALSE
	luminosity = 1

	plane = SPACE_PLANE

	var/static/list/dust_cache
	var/static/list/speedspace_cache
	var/static/list/phase_shift_by_x
	var/static/list/phase_shift_by_y

/turf/space/New()
	if(isnull(dust_cache))
		build_dust_cache()
	toggle_transit() //add static dust

	update_starlight()

/turf/space/proc/update_starlight()
	if(!CONFIG_GET(starlight))
		return

	if(locate(/turf/simulated) in orange(src, 1))
		set_light(CONFIG_GET(starlight))
	else
		set_light(0)

/turf/space/proc/build_dust_cache()
	// Static.
	dust_cache = list()
	for(var/i in 0 to 25)
		var/image/im = image('icons/turf/space_dust.dmi', "[i]")
		im.plane = SPACE_DUST_PLANE
		im.alpha = 128 //80
		im.blend_mode = BLEND_ADD
		dust_cache["[i]"] = im

	// Moving.
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

/turf/space/proc/toggle_transit(direction)
	overlays.Cut()

	if(!direction)
		overlays |= dust_cache["[((x + y) ^ ~(x * y) + z) % 25]"]
		return

	if(direction & (NORTH|SOUTH))
		if(isnull(phase_shift_by_x))
			phase_shift_by_x = get_cross_shift_list(15)
		var/x_shift = phase_shift_by_x[x % (length(phase_shift_by_x) - 1) + 1]
		var/transit_state = ((direction & SOUTH ? world.maxy - y : y) + x_shift) % 15
		overlays |= speedspace_cache["NS_[transit_state]"]
	else if(direction & (EAST|WEST))
		if(isnull(phase_shift_by_y))
			phase_shift_by_y = get_cross_shift_list(15)
		var/y_shift = phase_shift_by_y[y % (length(phase_shift_by_y) - 1) + 1]
		var/transit_state = ((direction & WEST ? world.maxx - x : x) + y_shift) % 15
		overlays |= speedspace_cache["EW_[transit_state]"]

	for(var/atom/movable/mover in src)
		if(mover.simulated && !mover.anchored)
			mover.throw_at(get_step(src, reverse_direction(direction)), 5, 1)

//generates a list used to randomize transit animations so they aren't in lockstep
/turf/space/proc/get_cross_shift_list(size)
	var/list/result = list()
	result.Add(rand(0, 14))

	for(var/i in 2 to size)
		var/list/shifts = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
		shifts.Remove(result[i - 1]) //consecutive shifts should not be equal
		if(i == size)
			shifts.Remove(result[1]) //because shift list is a ring buffer
		result.Add(pick(shifts))

	return result

/turf/space/attack_paw(mob/user as mob)
	return attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if(user.restrained() || isnull(user.pulling))
		return
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return

	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))

/turf/space/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(isnotnull(L))
			return
		var/obj/item/stack/rods/R = C
		to_chat(user, SPAN_INFO("Constructing support lattice ..."))
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(isnotnull(L))
			var/obj/item/stack/tile/plasteel/S = C
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	if(movement_disabled)
		FEEDBACK_MOVEMENT_ADMIN_DISABLED(usr) // This is to identify lag problems.
		return
	. = ..()
	if(isnull(A) || src != A.loc)
		return

	inertial_drift(A)

	if(isnotnull(global.CTticker?.mode))
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

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(x <= 1)
		if(istype(A, /obj/effect/meteor) || istype(A, /obj/effect/space_dust))
			qdel(A)
			return

		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x || length(GLOBL.global_map))
		y_arr = GLOBL.global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn(0)
				A?.loc?.Entered(A)

	else if(x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > length(GLOBL.global_map) ? 1 : cur_x)
		y_arr = GLOBL.global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = 3
			spawn(0)
				A?.loc?.Entered(A)

	else if(y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOBL.global_map[cur_x]
		next_y = (--cur_y || length(y_arr))
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn(0)
				A?.loc?.Entered(A)

	else if(y >= world.maxy)
		if(istype(A, /obj/effect/meteor) || istype(A, /obj/effect/space_dust))
			qdel(A)
			return
		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOBL.global_map[cur_x]
		next_y = (++cur_y > length(y_arr) ? 1 : cur_y)
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = 3
			spawn(0)
				A?.loc?.Entered(A)