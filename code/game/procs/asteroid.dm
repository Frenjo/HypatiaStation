GLOBAL_GLOBL_ALIST_INIT(space_surprises, alist(
	/obj/item/clothing/mask/facehugger = 4,
	/obj/item/pickaxe/silver = 4,
	/obj/item/pickaxe/drill = 4,
	/obj/item/pickaxe/jackhammer = 4,
	//mob/living/simple/hostile/carp = 3,
	/obj/item/pickaxe/diamond = 3,
	/obj/item/pickaxe/diamonddrill = 3,
	/obj/item/pickaxe/gold = 3,
	/obj/item/pickaxe/plasmacutter = 2,
	/obj/structure/closet/syndicate/resources/random = 2,
	/obj/item/melee/energy/sword/pirate = 1,
	/obj/mecha/working/ripley/mining = 1
))
GLOBAL_GLOBL_LIST_NEW(spawned_surprises)
GLOBAL_GLOBL_INIT(max_asteroid_secret_rooms, 3)
GLOBAL_GLOBL_INIT(max_asteroid_caves, 12)

/proc/make_mining_asteroid_cave()
	var/valid = FALSE
	var/turf/T = null
	var/sanity = 0

	var/list/turfs = get_area_turfs(/area/external/asteroid/mine/unexplored)

	if(!length(turfs))
		return FALSE

	while(!valid)
		valid = TRUE
		sanity++
		if(sanity > 100)
			return FALSE

		T = pick(turfs)
		if(isnull(T))
			return FALSE

		var/list/surroundings = range(1, T)

		if(locate(/area/external/asteroid/mine/explored) in surroundings) // +5s are for view range
			valid = FALSE
			continue

		if(locate(/turf/space) in surroundings)
			valid = FALSE
			continue

		if(locate(/turf/open/floor/plating/asteroid/airless) in surroundings)
			valid = FALSE
			continue

		if(locate(/turf/open/floor/plating/asteroid/airless/cave) in surroundings)
			valid = FALSE
			continue

	if(isnull(T))
		return FALSE

	T.ChangeTurf(/turf/open/floor/plating/asteroid/airless/cave)
	return TRUE

/proc/make_mining_asteroid_secret(size = 5)
	var/valid = FALSE
	var/turf/T = null
	var/sanity = 0

	var/list/turfs = get_area_turfs(/area/external/asteroid/mine/unexplored)

	if(!length(turfs))
		return FALSE

	while(!valid)
		valid = TRUE
		sanity++
		if(sanity > 100)
			return FALSE

		T = pick(turfs)
		if(isnull(T))
			return FALSE

		var/list/surroundings = list()

		surroundings.Add(range(7, locate(T.x, T.y, T.z)))
		surroundings.Add(range(7, locate(T.x + size, T.y, T.z)))
		surroundings.Add(range(7, locate(T.x, T.y + size, T.z)))
		surroundings.Add(range(7, locate(T.x + size, T.y + size, T.z)))

		if(locate(/area/external/asteroid/mine/explored) in surroundings)			// +5s are for view range
			valid = FALSE
			continue

		if(locate(/turf/space) in surroundings)
			valid = FALSE
			continue

		if(locate(/area/external/asteroid/artefact_room) in surroundings)
			valid = FALSE
			continue

		if(locate(/turf/open/floor/plating/asteroid/airless) in surroundings)
			valid = FALSE
			continue

	if(isnull(T))
		return FALSE

	var/list/room = spawn_room(start_loc = T, x_size = size, y_size = size, clean = TRUE)

	if(isnotnull(room))
		T = pick(room["floors"])
		if(isnotnull(T))
			var/surprise = null
			valid = FALSE
			while(!valid)
				surprise = pickweight(GLOBL.space_surprises)
				if(surprise in GLOBL.spawned_surprises)
					if(prob(20))
						valid++
					else
						continue
				else
					valid++

			GLOBL.spawned_surprises.Add(surprise)
			new surprise(T)

	return TRUE

/proc/admin_spawn_room_at_pos()
	var/wall
	var/floor
	var/x = input("X position", "X pos", usr.x)
	var/y = input("Y position", "Y pos", usr.y)
	var/z = input("Z position", "Z pos", usr.z)
	var/x_len = input("Desired length.", "Length", 5)
	var/y_len = input("Desired width.", "Width", 5)
	var/clean = input("Delete existing items in area?", "Clean area?", 0)
	switch(alert("Wall type", null, "Reinforced wall", "Regular wall", "Resin wall"))
		if("Reinforced wall")
			wall = /turf/closed/wall/reinforced
		if("Regular wall")
			wall = /turf/closed/wall
		if("Resin wall")
			wall = /obj/effect/alien/resin
	switch(alert("Floor type", null, "Regular floor", "Reinforced floor"))
		if("Regular floor")
			floor = /turf/open/floor/tiled
		if("Reinforced floor")
			floor = /turf/open/floor/reinforced
	if(isnotnull(x) && isnotnull(y) && isnotnull(z) && isnotnull(wall) && isnotnull(floor) && isnotnull(x_len) && isnotnull(y_len))
		spawn_room(locate(x, y, z), x_len, y_len, wall, floor, clean)

/proc/spawn_room(atom/start_loc, x_size, y_size, wall, floor, clean = FALSE, name)
	var/list/room_turfs = list("walls" = list(), "floors" = list())

	//to_world("Room spawned at [start_loc.x],[start_loc.y],[start_loc.z]")
	if(isnull(wall))
		wall = pick(/turf/closed/wall/reinforced, /turf/closed/wall/steel, /obj/effect/alien/resin)
	if(isnull(floor))
		floor = pick(/turf/open/floor/tiled/grey, /turf/open/floor/reinforced)

	for(var/x = 0, x < x_size, x++)
		for(var/y = 0, y < y_size, y++)
			var/turf/T = null
			var/cur_loc = locate(start_loc.x + x, start_loc.y + y, start_loc.z)
			if(clean)
				for(var/O in cur_loc)
					qdel(O)

			var/area/external/asteroid/artefact_room/room_area = new /area/external/asteroid/artefact_room()
			if(isnotnull(name))
				room_area.name = name
			else
				room_area.name += "[start_loc.x]:[start_loc.y]:[start_loc.z]"

			if(x == 0 || x == (x_size - 1) || y == 0 || y == (y_size - 1))
				if(wall == /obj/effect/alien/resin)
					T = cur_loc
					T.ChangeTurf(floor)
					new /obj/effect/alien/resin(T)
				else
					T = cur_loc
					T.ChangeTurf(wall)
					var/list/walls = room_turfs["walls"]
					walls.Add(T)
			else
				T = cur_loc
				T.ChangeTurf(floor)
				var/list/floors = room_turfs["floors"]
				floors.Add(T)

			room_area.contents.Add(T)
			room_area.turf_list.Add(T)

	return room_turfs