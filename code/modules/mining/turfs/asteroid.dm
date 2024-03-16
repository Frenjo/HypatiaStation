/*
 * Asteroid
 */
/turf/simulated/floor/plating/airless/asteroid //floor piece
	name = "asteroid"
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	temperature = TCMB
	icon_plating = "asteroid"

	var/dug = FALSE

/turf/simulated/floor/plating/airless/asteroid/New()
	var/proper_name = name
	. = ..()
	name = proper_name
	//if (prob(50))
	//	seedName = pick(list("1","2","3","4"))
	//	seedAmt = rand(1,4)
	if(prob(20))
		icon_state = "asteroid[rand(0, 12)]"

/turf/simulated/floor/plating/airless/asteroid/initialise()
	. = ..()
	update_mineral_overlays()

/turf/simulated/floor/plating/airless/asteroid/ex_act(severity)
	switch(severity)
		if(3)
			return
		if(2)
			if (prob(70))
				gets_dug()
		if(1)
			gets_dug()
	return

/turf/simulated/floor/plating/airless/asteroid/burn_tile()
	return // Asteroid tiles don't burn.

/turf/simulated/floor/plating/airless/asteroid/Entered(atom/movable/M as mob|obj)
	. = ..()
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(istype(R.module, /obj/item/robot_module/miner))
			if(istype(R.module_state_1, /obj/item/storage/bag/ore))
				attackby(R.module_state_1, R)
			else if(istype(R.module_state_2, /obj/item/storage/bag/ore))
				attackby(R.module_state_2, R)
			else if(istype(R.module_state_3, /obj/item/storage/bag/ore))
				attackby(R.module_state_3, R)

/turf/simulated/floor/plating/airless/asteroid/attackby(obj/item/W as obj, mob/user as mob)
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

/turf/simulated/floor/plating/airless/asteroid/proc/gets_dug()
	if(dug)
		return
	for(var/i = 0; i < 5; i++)
		new /obj/item/ore/glass(src)
	dug = TRUE
	icon_plating = "asteroid_dug"
	icon_state = "asteroid_dug"

/turf/simulated/floor/plating/airless/asteroid/proc/update_mineral_overlays()
	overlays.Cut()
	if(istype(get_step(src, NORTH), /turf/simulated/mineral))
		overlays.Add(image('icons/turf/walls.dmi', "rock_side_n"))
	if(istype(get_step(src, SOUTH), /turf/simulated/mineral))
		overlays.Add(image('icons/turf/walls.dmi', "rock_side_s", layer = 6))
	if(istype(get_step(src, EAST), /turf/simulated/mineral))
		overlays.Add(image('icons/turf/walls.dmi', "rock_side_e", layer = 6))
	if(istype(get_step(src, WEST), /turf/simulated/mineral))
		overlays.Add(image('icons/turf/walls.dmi', "rock_side_w", layer = 6))

/turf/simulated/floor/plating/airless/asteroid/proc/full_update_mineral_overlays()
	var/turf/simulated/floor/plating/airless/asteroid/A
	for(var/direction in GLOBL.alldirs)
		if(istype(get_step(src, direction), /turf/simulated/floor/plating/airless/asteroid))
			A = get_step(src, direction)
			A.update_mineral_overlays()
	update_mineral_overlays()