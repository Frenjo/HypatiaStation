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
	var/turf/open/floor/plating/asteroid/A
	for(var/direction in GLOBL.alldirs)
		if(istype(get_step(src, direction), /turf/open/floor/plating/asteroid))
			A = get_step(src, direction)
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