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
			if (prob(70))
				gets_dug()
		if(1)
			gets_dug()
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
				attackby(R.module_state_1, R)
			else if(istype(R.module_state_2, /obj/item/storage/bag/ore))
				attackby(R.module_state_2, R)
			else if(istype(R.module_state_3, /obj/item/storage/bag/ore))
				attackby(R.module_state_3, R)

/turf/open/floor/plating/asteroid/attackby(obj/item/W, mob/user)
	if(isnull(W) || isnull(user))
		return 0

	if(istype(W, /obj/item/shovel))
		var/turf/T = user.loc
		if(!isturf(T))
			return

		if(dug)
			to_chat(user, SPAN_WARNING("This area has already been dug."))
			return

		to_chat(user, SPAN_WARNING("You start digging."))
		playsound(loc, 'sound/effects/rustle1.ogg', 50, 1) //russle sounds sounded better

		sleep(40)
		if(user.loc == T && user.get_active_hand() == W)
			to_chat(user, SPAN_INFO("You dug a hole."))
			gets_dug()

	if(istype(W, /obj/item/pickaxe/drill))
		var/turf/T = user.loc
		if(!isturf(T))
			return

		if(dug)
			to_chat(user, SPAN_WARNING("This area has already been dug."))
			return

		to_chat(user, SPAN_WARNING("You start digging."))
		playsound(loc, 'sound/effects/rustle1.ogg', 50, 1) //russle sounds sounded better

		sleep(30)
		if(user.loc == T && user.get_active_hand() == W)
			to_chat(user, SPAN_INFO("You dug a hole."))
			gets_dug()

	if(istype(W, /obj/item/pickaxe/diamonddrill) || istype(W, /obj/item/pickaxe/borgdrill))
		var/turf/T = user.loc
		if(!isturf(T))
			return

		if(dug)
			to_chat(user, SPAN_WARNING("This area has already been dug."))
			return

		to_chat(user, SPAN_WARNING("You start digging."))
		playsound(loc, 'sound/effects/rustle1.ogg', 50, 1) //russle sounds sounded better

		sleep(0)
		if(user.loc == T && user.get_active_hand() == W)
			to_chat(user, SPAN_INFO("You dug a hole."))
			gets_dug()

	if(istype(W, /obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/S = W
		if(S.collection_mode)
			for(var/obj/item/ore/O in contents)
				O.attackby(W, user)
				return

	else
		..(W, user)

/turf/open/floor/plating/asteroid/proc/gets_dug()
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
		/mob/living/simple/hostile/asteroid/goliath = 5,
		/mob/living/simple/hostile/asteroid/basilisk = 1
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
	// Kill ourselves by replacing ourselves with a normal floor.
	spawn_floor(src)
	. = ..()

/turf/open/floor/plating/asteroid/airless/cave/proc/make_tunnel(target_dir)
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
				spawn_floor(edge)

		// Move our tunnel forward
		tunnel = get_step(tunnel, target_dir)

		if(istype(tunnel))
			// Small chance to have forks in our tunnel; otherwise dig our tunnel.
			if(i > 3 && prob(20))
				new type(tunnel, rand(10, 15), 0, target_dir)
			else
				spawn_floor(tunnel)
		else // We hit space/normal/wall, stop our tunnel.
			break

		// Chance to change our direction left or right.
		if(i > 2 && prob(33))
			// We can't go a full loop though
			next_angle = -next_angle
			target_dir = angle2dir(dir2angle(target_dir) + next_angle)

/turf/open/floor/plating/asteroid/airless/cave/proc/spawn_floor(turf/T)
	for(var/turf/S in range(1, T))
		if(isspace(S) || istype(S.loc, /area/external/asteroid/mine/explored))
			sanity = FALSE
			break
	if(!sanity)
		return

	spawn_monster(T)
	T.ChangeTurf(/turf/open/floor/plating/asteroid/airless)

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