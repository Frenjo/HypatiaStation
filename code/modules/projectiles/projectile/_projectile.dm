/*
#define BRUTE "brute"
#define BURN "burn"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define ADD "add"
#define SET "set"
*/

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/weapons/projectiles.dmi'
	icon_state = "bullet"

	density = TRUE
	anchored = TRUE // There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASS_FLAG_TABLE
	mouse_opacity = FALSE

	obj_flags = OBJ_FLAG_UNACIDABLE

	var/bumped = FALSE		// Prevents it from hitting more than one guy at once
	var/def_zone = ""		// Aiming at
	var/mob/firer = null	// Who shot it
	var/silenced = FALSE		// Attack message
	var/yo = null
	var/xo = null
	var/current = null
	var/obj/shot_from = null // the object which shot us
	var/atom/original = null // the original target clicked
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/nodamage = FALSE //Determines if the projectile will skip any damage inflictions
	var/flag = "bullet" //Defines what armor to use when it hits things. Must be set to bullet, laser, energy, or bomb	//Cael - bio and rad are also valid
	var/projectile_type = /obj/item/projectile
	var/kill_count = 50 //This will de-increment every process(). When 0, it will delete the projectile.

	// Effects
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/embed = 0 // whether or not the projectile can embed itself in the mob

/obj/item/projectile/proc/on_hit(atom/target, blocked = 0)
	if(blocked >= 2)
		return 0//Full block
	if(!isliving(target))
		return 0
	if(issimple(target))
		return 0

	var/mob/living/L = target
	L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, agony, blocked) // add in AGONY!
	return 1

// Called when the projectile stops flying because it hit something.
/obj/item/projectile/proc/on_impact(atom/A)
	return

// Returns TRUE if the projectile penetrates, FALSE if not.
/obj/item/projectile/proc/on_penetrate(atom/A)
	return FALSE

/obj/item/projectile/proc/check_fire(mob/living/target, mob/living/user) // Checks if you can hit them or not.
	if(!istype(target) || !istype(user))
		return 0

	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_step_to(user, target)) //Making the test....
	trace.target = target
	// Sets the flags to that of the real projectile.
	SET_ATOM_FLAGS(trace, atom_flags)
	SET_PASS_FLAGS(trace, pass_flags)
	trace.obj_flags = obj_flags
	SET_ITEM_FLAGS(trace, item_flags)
	trace.firer = user
	var/output = trace.process() // Test it!
	qdel(trace) // No need for it anymore
	return output // Send it back to the gun!

// Sets the click point of the projectile using mouse input params.
/obj/item/projectile/proc/set_clickpoint(params)
	var/list/mouse_control = params2list(params)
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])

/obj/item/projectile/proc/launch(atom/target, mob/user, obj/item/gun/launcher, target_zone, x_offset = 0, y_offset = 0)
	var/turf/curloc = GET_TURF(user)
	var/turf/targloc = GET_TURF(target)
	if(!istype(targloc) || !istype(curloc))
		return FALSE

	firer = user
	def_zone = user.zone_sel.selecting
	if(user == target) // Shooting yourself.
		user.bullet_act(src, target_zone)
		qdel(src)
		return FALSE
	if(targloc == curloc) // Shooting the ground.
		targloc.bullet_act(src, target_zone)
		qdel(src)
		return FALSE

	original = target
	forceMove(GET_TURF(user))
	starting = GET_TURF(user)
	shot_from = launcher

	silenced = silenced
	current = curloc
	xo = targloc.x - curloc.x
	yo = targloc.y - curloc.y

	spawn()
		process()

	return TRUE

// Called when the projectile intercepts a mob. Returns TRUE if hit, FALSE if missed.
/obj/item/projectile/proc/attack_mob(mob/living/target_mob, distance, miss_modifier = -30)
	// Accuracy modifier from aiming.
	if(istype(shot_from, /obj/item/gun)) // If you aim at someone beforehead, it'll hit more often.
		var/obj/item/gun/daddy = shot_from // Kinda balanced by fact you need like 2 seconds to aim.
		if(isnotnull(daddy.target) && (original in daddy.target)) // As opposed to no-delay pew pew.
			miss_modifier += -30

	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier + 15 * distance)
	if(!hit_zone)
		visible_message(SPAN_INFO("\The [src] misses \the [target_mob] narrowly!"))
		return FALSE

	// Set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part.
	def_zone = hit_zone

	// Hit messages.
	if(silenced)
		to_chat(target_mob, SPAN_WARNING("You've been shot in the [parse_zone(def_zone)] by \the [src]!"))
	else
		// X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter.
		visible_message(SPAN_WARNING("[target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!"))

	// Admin attack logging.
	if(ismob(firer))
		target_mob.attack_log += "\[[time_stamp()]\] <b>[firer]/[firer.ckey]</b> shot <b>[target_mob]/[target_mob.ckey]</b> with a <b>[type]</b>"
		firer.attack_log += "\[[time_stamp()]\] <b>[firer]/[firer.ckey]</b> shot <b>[target_mob]/[target_mob.ckey]</b> with a <b>[type]</b>"
		msg_admin_attack("[firer] ([firer.ckey]) shot [target_mob] ([target_mob.ckey]) with a [src] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[firer.x];Y=[firer.y];Z=[firer.z]'>JMP</a>)") //BS12 EDIT ALG
	else
		target_mob.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[target_mob]/[target_mob.ckey]</b> with a <b>[src]</b>"
		msg_admin_attack("UNKNOWN shot [target_mob] ([target_mob.ckey]) with a [src] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[firer.x];Y=[firer.y];Z=[firer.z]'>JMP</a>)") //BS12 EDIT ALG

	// Sometimes bullet_act() wants the projectile to keep flying.
	if(target_mob.bullet_act(src, def_zone) == -1)
		return FALSE

	return TRUE

/obj/item/projectile/Bump(atom/A)
	if(A == src)
		return FALSE
	if(A == firer)
		loc = A.loc
		return FALSE //cannot shoot yourself

	var/distance = get_dist(starting, loc)
	var/passthrough = FALSE // If the projectile should keep flying.

	bumped = TRUE
	if(ismob(A))
		var/mob/M = A
		if(isliving(A))
			passthrough = !attack_mob(M, distance)
		else
			passthrough = TRUE // So that ghosts don't stop bullets.
	else
		passthrough = (A.bullet_act(src, def_zone) == -1) // Backwards compatibility.
		if(isturf(A))
			for(var/obj/O in A)
				O.bullet_act(src)
			for(var/mob/M in A)
				attack_mob(M, distance)

	// Penetrating projectiles can pass through things outside of this.
	if(on_penetrate(A))
		passthrough = TRUE

	// If the bullet passes through a dense object...
	if(passthrough)
		bumped = FALSE
		loc = GET_TURF(A)
		permutated.Add(A)
		return FALSE

	// Stop flying.
	on_impact(A)

	density = FALSE
	invisibility = INVISIBILITY_MAXIMUM
	qdel(src)
	return TRUE

/obj/item/projectile/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE
	if(istype(mover, /obj/item/projectile))
		return prob(95)
	return TRUE

/obj/item/projectile/process()
	if(kill_count < 1)
		qdel(src)
	kill_count--

	spawn while(isnotnull(src) && isnotnull(loc))
		if(!current || loc == current)
			current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
		if(x == 1 || x == world.maxx || y == 1 || y == world.maxy)
			qdel(src)
			return
		step_towards(src, current)
		sleep(1)
		if(!bumped && !isturf(original))
			if(loc == GET_TURF(original))
				if(!(original in permutated))
					if(Bump(original))
						return
					sleep(1)

/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = INVISIBILITY_MAXIMUM //Nope! Can't see me!
	yo = null
	xo = null

	var/target = null
	var/result = 0 //To pass the message back to the gun.

/obj/item/projectile/test/Bump(atom/A)
	if(A == firer)
		loc = A.loc
		return //cannot shoot yourself
	if(istype(A, /obj/item/projectile))
		return
	if(isliving(A))
		result = 2 //We hit someone, return 1!
		return
	result = 1

/obj/item/projectile/test/process()
	var/turf/curloc = GET_TURF(src)
	var/turf/targloc = GET_TURF(target)
	if(isnull(curloc) || isnull(targloc))
		return 0

	yo = targloc.y - curloc.y
	xo = targloc.x - curloc.x
	target = targloc

	while(isnotnull(src)) //Loop on through!
		if(result)
			return (result - 1)

		if(!target || loc == target)
			target = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z) //Finding the target turf at map edge
		step_towards(src, target)
		var/mob/living/M = locate() in GET_TURF(src)

		if(istype(M)) //If there is someting living...
			return 1 //Return 1
		else
			M = locate() in get_step(src, target)
			if(istype(M))
				return 1