//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

GLOBAL_GLOBL_LIST_INIT(uneatable, list(
	/turf/space,
	/obj/effect/overlay
))

/obj/singularity
	name = "gravitational singularity"
	desc = "A Gravitational Singularity."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"
	anchored = TRUE
	density = TRUE
	layer = 6
	light_range = 6
	obj_flags = OBJ_FLAG_UNACIDABLE //Don't comment this out.

	var/current_size = 1
	var/allowed_size = 1
	var/contained = 1 //Are we going to move around?
	var/energy = 100 //How strong are we?
	var/dissipate = 1 //Do we lose energy over time?
	var/dissipate_delay = 10
	var/dissipate_track = 0
	var/dissipate_strength = 1 //How much energy do we lose?
	var/move_self = 1 //Do we move on our own?
	var/grav_pull = 4 //How many tiles out do we pull?
	var/consume_range = 0 //How many tiles out do we eat
	var/event_chance = 15 //Prob for event each tick
	var/target = null //its target. moves towards the target if it has one
	var/last_failed_movement = 0//Will not move in the same dir if it couldnt before, will help with the getting stuck on fields thing
	var/teleport_del = 0
	var/last_warning

	var/has_eaten_supermatter_shard = 0 // Have we eaten a small supermatter shard? -Frenjo
	var/has_eaten_supermatter_crystal = 0 // Have we eaten a full size SM crystal? -Frenjo

/obj/singularity/New(loc, starting_energy = 50, temp = 0)
	//CARN: admin-alert for chuckle-fuckery.
	admin_investigate_setup()

	src.energy = starting_energy
	if(temp)
		spawn(temp)
			qdel(src)
	. = ..()

/obj/singularity/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)
	FOR_MACHINES_TYPED(beacon, /obj/machinery/singularity_beacon)
		if(beacon.active)
			target = beacon
			break

/obj/singularity/Destroy()
	target = null
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/singularity/attack_hand(mob/user)
	consume(user)
	return 1

/obj/singularity/blob_act(severity)
	return

/obj/singularity/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(25))
				qdel(src)
				return
			else
				energy += 50
		if(2.0 to 3.0)
			energy += round((rand(20, 60) / 2), 1)
			return
	return

/obj/singularity/Bump(atom/A)
	consume(A)
	return

/obj/singularity/Bumped(atom/A)
	consume(A)
	return

/obj/singularity/process()
	eat()
	dissipate()
	check_energy()

	if(current_size >= 3)
		move()
		pulse()
		if(prob(event_chance))//Chance for it to run a special event TODO:Come up with one or two more that fit
			event()
	return

/obj/singularity/attack_ai() //to prevent ais from gibbing themselves when they click on one.
	return

/obj/singularity/proc/admin_investigate_setup()
	last_warning = world.time
	var/count = locate(/obj/machinery/containment_field) in orange(30, src)
	if(!count)
		message_admins("A singulo has been created without containment fields active ([x], [y], [z])", 1)
	investigate_log("was created. [count ? "" : "<font color='red'>No containment fields were active</font>"]", "singulo")

/obj/singularity/proc/dissipate()
	if(!dissipate)
		return
	if(dissipate_track >= dissipate_delay)
		src.energy -= dissipate_strength
		dissipate_track = 0
	else
		dissipate_track++

/obj/singularity/proc/expand(force_size = 0)
	var/temp_allowed_size = src.allowed_size
	if(force_size)
		temp_allowed_size = force_size
	switch(temp_allowed_size)
		if(1)
			current_size = 1
			icon = 'icons/obj/singularity.dmi'
			icon_state = "singularity_s1"
			pixel_x = 0
			pixel_y = 0
			grav_pull = 4
			consume_range = 0
			dissipate_delay = 10
			dissipate_track = 0
			dissipate_strength = 1
		if(3)//1 to 3 does not check for the turfs if you put the gens right next to a 1x1 then its going to eat them
			current_size = 3
			icon = 'icons/effects/96x96.dmi'
			icon_state = "singularity_s3"
			pixel_x = -32
			pixel_y = -32
			grav_pull = 6
			consume_range = 1
			dissipate_delay = 5
			dissipate_track = 0
			dissipate_strength = 5
		if(5)
			if(check_turfs_in(1, 2) && check_turfs_in(2, 2) && check_turfs_in(4, 2) && check_turfs_in(8, 2))
				current_size = 5
				icon = 'icons/effects/160x160.dmi'
				icon_state = "singularity_s5"
				pixel_x = -64
				pixel_y = -64
				grav_pull = 8
				consume_range = 2
				dissipate_delay = 4
				dissipate_track = 0
				dissipate_strength = 20
		if(7)
			if(check_turfs_in(1, 3) && check_turfs_in(2, 3) && check_turfs_in(4, 3) && check_turfs_in(8, 3))
				current_size = 7
				icon = 'icons/effects/224x224.dmi'
				icon_state = "singularity_s7"
				pixel_x = -96
				pixel_y = -96
				grav_pull = 10
				consume_range = 3
				dissipate_delay = 10
				dissipate_track = 0
				dissipate_strength = 10
		if(9)//this one also lacks a check for gens because it eats everything
			current_size = 9
			icon = 'icons/effects/288x288.dmi'
			icon_state = "singularity_s9"
			pixel_x = -128
			pixel_y = -128
			grav_pull = 10
			consume_range = 4
			dissipate = 0 //It cant go smaller due to e loss
		if(10) // NOW YOU'VE FUCKIN DONE IT. -Frenjo
			current_size = 10
			icon = 'icons/effects/288x288.dmi'
			icon_state = "singularity_sm10"
			pixel_x = -128
			pixel_y = -128
			grav_pull = 12
			consume_range = 5
			dissipate = 0
		if(11) // NOW THE UNIVERSE IS PROBABLY ENDING. -Frenjo
			current_size = 11
			icon = 'icons/effects/288x288.dmi'
			icon_state = "singularity_sm11"
			pixel_x = -128
			pixel_y = -128
			grav_pull = 15
			consume_range = 6
			dissipate = 0
	if(current_size == allowed_size)
		investigate_log("<font color='red'>grew to size [current_size]</font>","singulo")
		return 1
	else if(current_size < --temp_allowed_size)
		expand(temp_allowed_size)
	else
		return 0

/obj/singularity/proc/check_energy()
	if(energy <= 0)
		qdel(src)
		return 0
	switch(energy)//Some of these numbers might need to be changed up later -Mport
		if(1 to 199)
			allowed_size = 1
		if(200 to 499)
			allowed_size = 3
		if(500 to 999)
			allowed_size = 5
		if(1000 to 1999)
			allowed_size = 7
		// Adjust for eating supermatter. -Frenjo
		if(2000 to INFINITY)
			if(energy < 5000 && (!has_eaten_supermatter_shard && !has_eaten_supermatter_crystal))
				allowed_size = 9
			else if(energy > 5000 && (has_eaten_supermatter_shard || has_eaten_supermatter_crystal))
				allowed_size = 10
			else if(energy > 10000 && has_eaten_supermatter_crystal)
				allowed_size = 11
	if(current_size != allowed_size)
		expand()
	return 1

/obj/singularity/proc/eat()
	set background = BACKGROUND_ENABLED
	if(GLOBL.defer_powernet_rebuild != 2)
		GLOBL.defer_powernet_rebuild = 1
	// Let's just make this one loop.
	for(var/atom/X in orange(grav_pull, src))
		var/dist = get_dist(X, src)
		// Movable atoms only
		if(dist > consume_range && ismovable(X))
			if(is_type_in_list(X, GLOBL.uneatable))
				continue
			if((X && !X:anchored && !ishuman(X)) || src.current_size >= 9)
				step_towards(X, src)
			else if(ishuman(X))
				var/mob/living/carbon/human/H = X
				if(istype(H.shoes, /obj/item/clothing/shoes/magboots))
					var/obj/item/clothing/shoes/magboots/M = H.shoes
					if(M.magpulse)
						continue
				step_towards(H, src)
		// Turf and movable atoms
		else if(dist <= consume_range && (isturf(X) || ismovable(X)))
			consume(X)

	if(GLOBL.defer_powernet_rebuild != 2)
		GLOBL.defer_powernet_rebuild = 0
	return

/obj/singularity/proc/consume(atom/A)
	var/gain = 0
	if(is_type_in_list(A, GLOBL.uneatable))
		return 0
	if(isliving(A))//Mobs get gibbed
		gain = 20
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.mind)
				if(H.mind.assigned_role == "Station Engineer" || H.mind.assigned_role == "Chief Engineer")
					gain = 100

				if(H.mind.assigned_role == "Clown")
					gain = rand(-300, 300) // HONK
		spawn()
			A:gib()
		sleep(1)
	else if(isobj(A))
		if(istype(A, /obj/item/storage/backpack/holding))
			var/dist = max((current_size - 2), 1)
			explosion(src.loc, (dist), (dist * 2), (dist * 4))
			return

		if(istype(A, /obj/singularity))//Welp now you did it
			var/obj/singularity/S = A
			src.energy += (S.energy/2)//Absorb most of it
			qdel(S)
			var/dist = max((current_size - 2), 1)
			explosion(src.loc, (dist), (dist * 2), (dist * 4))
			return//Quits here, the obj should be gone, hell we might be

		// If it eats supermatter... Oh dear. -Frenjo
		if(istype(A, /obj/machinery/power/supermatter/shard))
			gain = 10000
			has_eaten_supermatter_shard = 1
		else if(istype(A, /obj/machinery/power/supermatter))
			gain = 5000
			has_eaten_supermatter_crystal = 1

		if(teleport_del && !istype(A, /obj/machinery)) //Going to see if it does not lag less to tele items over to Z 2
			var/obj/O = A
			O.x = 2
			O.y = 2
			O.z = 2
		else
			A.ex_act(1.0)
			if(A)
				qdel(A)
		gain = 2
	else if(isturf(A))
		var/turf/T = A
		if(T.intact)
			for(var/obj/O in T.contents)
				if(O.level != 1)
					continue
				if(O.invisibility == 101)
					src.consume(O)
		T.ChangeTurf(/turf/space)
		gain = 2
	src.energy += gain
	return

/obj/singularity/proc/move(force_move = 0)
	if(!move_self)
		return 0

	var/movement_dir = pick(GLOBL.alldirs - last_failed_movement)

	if(force_move)
		movement_dir = force_move

	if(target && prob(60))
		movement_dir = get_dir(src, target) //moves to a singulo beacon, if there is one

	if(current_size >= 9)//The superlarge one does not care about things in its way
		spawn(0)
			step(src, movement_dir)
		spawn(1)
			step(src, movement_dir)
		return 1
	else if(check_turfs_in(movement_dir))
		last_failed_movement = 0//Reset this because we moved
		spawn(0)
			step(src, movement_dir)
		return 1
	else
		last_failed_movement = movement_dir
	return 0

/obj/singularity/proc/check_turfs_in(direction = 0, step = 0)
	if(!direction)
		return 0
	var/steps = 0
	if(!step)
		switch(current_size)
			if(1)
				steps = 1
			if(3)
				steps = 3//Yes this is right
			if(5)
				steps = 3
			if(7)
				steps = 4
			if(9)
				steps = 5
	else
		steps = step
	var/list/turfs = list()
	var/turf/T = src.loc
	for(var/i = 1 to steps)
		T = get_step(T,direction)
	if(!isturf(T))
		return 0
	turfs.Add(T)
	var/dir2 = 0
	var/dir3 = 0
	switch(direction)
		if(NORTH, SOUTH)
			dir2 = 4
			dir3 = 8
		if(EAST, WEST)
			dir2 = 1
			dir3 = 2
	var/turf/T2 = T
	for(var/j = 1 to steps)
		T2 = get_step(T2, dir2)
		if(!isturf(T2))
			return 0
		turfs.Add(T2)
	for(var/k = 1 to steps)
		T = get_step(T, dir3)
		if(!isturf(T))
			return 0
		turfs.Add(T)
	for_no_type_check(var/turf/T3, turfs)
		if(isnull(T3))
			continue
		if(!can_move(T3))
			return 0
	return 1

/obj/singularity/proc/can_move(turf/T)
	if(!T)
		return 0
	if((locate(/obj/machinery/containment_field) in T) || (locate(/obj/effect/shield_wall) in T))
		return 0
	else if(locate(/obj/machinery/field_generator) in T)
		var/obj/machinery/field_generator/G = locate(/obj/machinery/field_generator) in T
		if(G && G.active)
			return 0
	else if(locate(/obj/machinery/shieldwallgen) in T)
		var/obj/machinery/shieldwallgen/S = locate(/obj/machinery/shieldwallgen) in T
		if(S && S.active)
			return 0
	return 1

/obj/singularity/proc/event()
	var/numb = pick(1, 2, 3, 4, 5, 6)
	switch(numb)
		if(1)//EMP
			emp_area()
		if(2, 3)//tox damage all carbon mobs in area
			toxmob()
		if(4)//Stun mobs who lack optic scanners
			mezzer()
		else
			return 0
	return 1

/obj/singularity/proc/toxmob()
	var/toxrange = 10
	var/toxdamage = 4
	var/radiation = 15
	var/radiationmin = 3
	if(src.energy > 200)
		toxdamage = round(((src.energy - 150) / 50) * 4, 1)
		radiation = round(((src.energy - 150) / 50) * 5, 1)
		radiationmin = round((radiation / 5), 1)//
	for(var/mob/living/M in view(toxrange, src.loc))
		M.apply_effect(rand(radiationmin, radiation), IRRADIATE)
		toxdamage = (toxdamage - (toxdamage * M.getarmor(null, "rad")))
		M.apply_effect(toxdamage, TOX)
	return

/obj/singularity/proc/mezzer()
	for(var/mob/living/carbon/M in oviewers(8, src))
		if(isbrain(M)) //Ignore brains
			continue

		if(M.stat == CONSCIOUS)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(istype(H.glasses, /obj/item/clothing/glasses/meson))
					to_chat(H, SPAN_INFO("You look directly into The [src.name], good thing you had your protective eyewear on!"))
					return
		to_chat(M, SPAN_WARNING("You look directly into The [src.name] and feel weak."))
		M.apply_effect(3, STUN)
		for(var/mob/O in viewers(M, null))
			O.show_message(SPAN_DANGER("[M] stares blankly at the [src]!"), 1)
	return

/obj/singularity/proc/emp_area()
	empulse(src, 8, 10)
	return

/obj/singularity/proc/pulse()
	for(var/obj/machinery/power/rad_collector/R in GLOBL.rad_collectors)
		if(get_dist(R, src) <= 15) // Better than using orange() every process
			R.receive_pulse(energy)
	return


/obj/singularity/narsie //Moving narsie to a child object of the singularity so it can be made to function differently. --NEO
	name = "Nar-Sie"
	desc = "Your mind begins to bubble and ooze as it tries to comprehend what it sees."
	icon = 'icons/obj/magic_terror.dmi'
	pixel_x = -89
	pixel_y = -85
	current_size = 9 //It moves/eats like a max-size singulo, aside from range. --NEO
	contained = 0 //Are we going to move around?
	dissipate = 0 //Do we lose energy over time?
	move_self = 1 //Do we move on our own?
	grav_pull = 10 //How many tiles out do we pull?
	consume_range = 3 //How many tiles out do we eat
	var/last_boom = 0

	light_range = 1
	light_color = "#3e0000"

/obj/singularity/narsie/large
	name = "Nar-Sie"
	icon = 'icons/obj/narsie.dmi'
	// Pixel stuff centers Narsie.
	pixel_x = -236
	pixel_y = -256
	current_size = 12
	move_self = 1 //Do we move on our own?
	consume_range = 12 //How many tiles out do we eat

/obj/singularity/narsie/large/New()
	..()
	to_world("<font size='28' color='red'><b>NAR-SIE HAS RISEN</b></font>")
	if(global.PCemergency)
		global.PCemergency.call_evac()
		global.PCemergency.launch_time = 0 // Cannot recall

/obj/singularity/narsie/process()
	eat()
	if(!target || prob(5))
		pickcultist()
	move()
	if(prob(25))
		mezzer()

/obj/singularity/narsie/consume(atom/A) //Has its own consume proc because it doesn't need energy and I don't want BoHs to explode it. --NEO
	if(is_type_in_list(A, GLOBL.uneatable))
		return 0
	if(isliving(A))//Mobs get gibbed
		A:gib()
	else if(isobj(A))
		qdel(A)
	else if(isturf(A))
		var/turf/T = A
		if(T.intact)
			for(var/obj/O in T.contents)
				if(O.level != 1)
					continue
				if(O.invisibility == 101)
					src.consume(O)
		A:ChangeTurf(/turf/space)
	if(last_boom + 100 < world.time && prob(5))
		explosion(loc, -1, -1, -1, 1, 0) //Since we're not exploding everything in consume() toss out an explosion effect every now and again
		last_boom = world.time
	return

/obj/singularity/narsie/ex_act() //No throwing bombs at it either. --NEO
	return

/obj/singularity/narsie/proc/pickcultist() //Narsie rewards his cultists with being devoured first, then picks a ghost to follow. --NEO
	var/list/cultists = list()
	for(var/datum/mind/cult_nh_mind in global.PCticker.mode.cult)
		if(!cult_nh_mind.current)
			continue
		if(cult_nh_mind.current.stat)
			continue
		if(GET_TURF_Z(cult_nh_mind.current) != src.z)
			continue
		cultists += cult_nh_mind.current
	if(length(cultists))
		acquire(pick(cultists))
		return
		//If there was living cultists, it picks one to follow.
	for(var/mob/living/carbon/human/food in GLOBL.living_mob_list)
		if(food.stat)
			continue
		if(GET_TURF_Z(food) != src.z)
			continue
		cultists += food
	if(length(cultists))
		acquire(pick(cultists))
		return
		//no living cultists, pick a living human instead.
	for(var/mob/dead/ghost/ghost in GLOBL.player_list)
		if(!ghost.client)
			continue
		if(GET_TURF_Z(ghost) != src.z)
			continue
		cultists += ghost
	if(length(cultists))
		acquire(pick(cultists))
		return
		//no living humans, follow a ghost instead.

/obj/singularity/narsie/proc/acquire(mob/food)
	to_chat(target, SPAN_INFO_B("NAR-SIE HAS LOST INTEREST IN YOU"))
	target = food
	if(ishuman(target))
		to_chat(target, SPAN_DANGER("NAR-SIE HUNGERS FOR YOUR SOUL"))
	else
		to_chat(target, SPAN_DANGER("NAR-SIE HAS CHOSEN YOU TO LEAD HIM TO HIS NEXT MEAL"))

//Wizard narsie

/obj/singularity/narsie/wizard
	grav_pull = 0

/obj/singularity/narsie/wizard/eat()
	set background = BACKGROUND_ENABLED
	if(GLOBL.defer_powernet_rebuild != 2)
		GLOBL.defer_powernet_rebuild = 1
	for(var/atom/X in orange(consume_range, src))
		if(isturf(X) || ismovable(X))
			consume(X)
	if(GLOBL.defer_powernet_rebuild != 2)
		GLOBL.defer_powernet_rebuild = 0
	return