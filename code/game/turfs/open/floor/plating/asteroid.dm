/*
 * Asteroid
 */
/turf/open/floor/plating/asteroid //floor piece
	name = "asteroid"
	icon_state = "asteroid"
	icon_plating = "asteroid"

	var/dug = FALSE

/turf/open/floor/plating/asteroid/New()
	var/proper_name = name
	. = ..()
	name = proper_name
	//if (prob(50))
	//	seedName = pick(list("1","2","3","4"))
	//	seedAmt = rand(1,4)
	if(prob(20))
		icon_state = "asteroid[rand(0, 12)]"

/turf/open/floor/plating/asteroid/initialise()
	. = ..()
	update_mineral_overlays()

/turf/open/floor/plating/asteroid/ex_act(severity)
	switch(severity)
		if(3)
			return
		if(2)
			if(prob(70))
				get_dug()
		if(1)
			get_dug()
	return

/turf/open/floor/plating/asteroid/burn_tile()
	SHOULD_CALL_PARENT(FALSE)

	return FALSE // Asteroid tiles don't burn.

/turf/open/floor/plating/asteroid/Entered(atom/movable/M)
	. = ..()
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(istype(R.model, /obj/item/robot_model/miner))
			if(istype(R.module_state_1, /obj/item/storage/bag/ore))
				attack_by(R.module_state_1, R)
			else if(istype(R.module_state_2, /obj/item/storage/bag/ore))
				attack_by(R.module_state_2, R)
			else if(istype(R.module_state_3, /obj/item/storage/bag/ore))
				attack_by(R.module_state_3, R)

/turf/open/floor/plating/asteroid/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/shovel))
		return start_digging(user, "digging", 4 SECONDS)

	if(istype(tool, /obj/item/pickaxe/drill))
		var/obj/item/pickaxe/drill/drill = tool
		return start_digging(user, drill.drill_verb, drill.dig_time)

	return ..()

/turf/open/floor/plating/asteroid/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/S = I
		if(S.collection_mode)
			for(var/obj/item/ore/O in src)
				O.handle_attack(I, user)
		return TRUE

	return ..()

/turf/open/floor/plating/asteroid/proc/start_digging(mob/digger, drill_verb, time)
	if(dug)
		to_chat(digger, SPAN_WARNING("This area has already been dug!"))
		return FALSE

	to_chat(digger, SPAN_WARNING("You start [drill_verb] \the [src]."))
	playsound(loc, 'sound/effects/rustle1.ogg', 50, 1) // Rustling sounds sounded better.
	if(do_after(digger, time, src, TRUE))
		to_chat(digger, SPAN_INFO("You finish [drill_verb] \the [src]."))
		get_dug()
		return TRUE

	to_chat(digger, SPAN_WARNING("You must stand still to finish [drill_verb] \the [src]!"))
	return FALSE

/turf/open/floor/plating/asteroid/proc/get_dug()
	if(dug)
		return
	for(var/i = 0; i < 5; i++)
		new /obj/item/ore/glass(src)
	dug = TRUE
	icon_plating = "asteroid_dug"
	icon_state = "asteroid_dug"

/turf/open/floor/plating/asteroid/proc/update_mineral_overlays()
	overlays.Cut()
	if(istype(get_step(src, NORTH), /turf/closed/rock))
		overlays.Add(image('icons/turf/walls/rocks_ores.dmi', "rock_side_n"))
	if(istype(get_step(src, SOUTH), /turf/closed/rock))
		overlays.Add(image('icons/turf/walls/rocks_ores.dmi', "rock_side_s", layer = 6))
	if(istype(get_step(src, EAST), /turf/closed/rock))
		overlays.Add(image('icons/turf/walls/rocks_ores.dmi', "rock_side_e", layer = 6))
	if(istype(get_step(src, WEST), /turf/closed/rock))
		overlays.Add(image('icons/turf/walls/rocks_ores.dmi', "rock_side_w", layer = 6))

/turf/open/floor/plating/asteroid/proc/full_update_mineral_overlays()
	for(var/direction in GLOBL.alldirs)
		var/turf/open/floor/plating/asteroid/A = get_step(src, direction)
		if(istype(A))
			A.update_mineral_overlays()
	update_mineral_overlays()

// Airless
/turf/open/floor/plating/asteroid/airless
	name = "airless asteroid"
	initial_gases = null
	temperature = TCMB

/turf/open/floor/plating/asteroid/airless/New()
	. = ..()
	name = "asteroid"

// Cave
/turf/open/floor/plating/asteroid/airless/cave
	name = "asteroid cave"

	var/length = 100
	var/alist/mob_spawn_list = alist(
		/mob/living/simple/hostile/asteroid/goliath = 4,
		/mob/living/simple/hostile/asteroid/hivelord = 4,
		/mob/living/simple/hostile/asteroid/basilisk = 2,
		/mob/living/simple/hostile/asteroid/fugu = 1
	)
	var/sanity = TRUE

/turf/open/floor/plating/asteroid/airless/cave/New(loc, new_length = null, go_backwards = TRUE, exclude_dir = -1)
	// If new_length (arg2) isn't defined, get a random length; otherwise assign our length to the length arg.
	if(isnull(new_length))
		length = rand(25, 50)
	else
		length = new_length

	// Get our directions.
	var/forward_cave_dir = pick(GLOBL.alldirs - exclude_dir)
	// Get the opposite direction of our facing direction.
	var/backward_cave_dir = angle2dir(dir2angle(forward_cave_dir) + 180)

	// Make our tunnels.
	make_tunnel(forward_cave_dir)
	if(go_backwards)
		make_tunnel(backward_cave_dir)
	. = ..()

/turf/open/floor/plating/asteroid/airless/cave/initialise()
	. = ..()
	// Replace ourself with a normal floor.
	spawn_floor(loc, src)

/turf/open/floor/plating/asteroid/airless/cave/proc/make_tunnel(target_dir)
	// Changes our area to the cave type.
	var/area/external/asteroid/cave/cave_area = new /area/external/asteroid/cave()
	cave_area.name += "[x]:[y]:[z]"
	cave_area.contents.Add(src)
	cave_area.turf_list.Add(src)

	var/turf/closed/rock/tunnel = src
	var/next_angle = pick(45, -45)

	for(var/i = 0; i < length; i++)
		if(!sanity)
			break

		var/list/L = list(45)
		if(IsOdd(dir2angle(target_dir))) // We're going at an angle and we want thick angled tunnels.
			L += -45

		// Expand the edges of our tunnel
		for(var/edge_angle in L)
			var/turf/closed/rock/edge = get_step(tunnel, angle2dir(dir2angle(target_dir) + edge_angle))
			if(istype(edge))
				spawn_floor(cave_area, edge)

		// Move our tunnel forward
		tunnel = get_step(tunnel, target_dir)

		if(istype(tunnel))
			// Small chance to have forks in our tunnel; otherwise dig our tunnel.
			if(i > 3 && prob(20))
				new type(tunnel, rand(10, 15), 0, target_dir)
			else
				spawn_floor(cave_area, tunnel)
		else // We hit space/normal/wall, stop our tunnel.
			break

		// Chance to change our direction left or right.
		if(i > 2 && prob(33))
			// We can't go a full loop though
			next_angle = -next_angle
			target_dir = angle2dir(dir2angle(target_dir) + next_angle)

/turf/open/floor/plating/asteroid/airless/cave/proc/spawn_floor(area/external/asteroid/cave/cave_area, turf/T)
	for_no_type_check(var/turf/S, RANGE_TURFS(T, 1))
		if(isspace(S) || istype(S.loc, /area/external/asteroid/mine/explored))
			sanity = FALSE
			break
	if(!sanity)
		return

	spawn_monster(T)
	var/turf/open/floor/plating/asteroid/airless/new_turf = T.ChangeTurf(/turf/open/floor/plating/asteroid/airless)
	cave_area.contents.Add(new_turf)
	cave_area.turf_list.Add(new_turf)

/turf/open/floor/plating/asteroid/airless/cave/proc/spawn_monster(turf/T)
	if(!prob(2))
		return
	if(istype(loc, /area/external/asteroid/mine/explored))
		return
	for_no_type_check(var/atom/A, range(7, T)) // Lowers the chance of mob clumps.
		if(istype(A, /mob/living/simple/hostile/asteroid))
			return

	var/monster_type = pickweight(mob_spawn_list)
	new monster_type(T)