/mob/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE

	if(ismob(mover))
		var/mob/moving_mob = mover
		if(other_mobs && moving_mob.other_mobs)
			return TRUE
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)

/client/Northeast()
	swap_hand()

/client/Southeast()
	attack_self()

/client/Southwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode()
	else
		to_chat(usr, SPAN_WARNING("This mob type cannot throw items."))

/client/Northwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.get_active_hand())
			to_chat(usr, SPAN_WARNING("You have nothing to drop in your hand."))
			return
		drop_item()
	else
		to_chat(usr, SPAN_WARNING("This mob type cannot drop items."))

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = TRUE

	if(isnull(usr.pulling))
		to_chat(usr, SPAN_INFO("You are not pulling anything."))
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = TRUE

	if(iscarbon(mob))
		var/mob/living/carbon/C = mob
		C.swap_hand()
	if(isrobot(mob))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()

/client/verb/attack_self()
	set hidden = TRUE

	if(isnotnull(mob))
		mob.mode()

/client/verb/toggle_throw_mode()
	set hidden = TRUE

	if(!iscarbon(mob))
		return
	var/mob/living/carbon/C = mob

	if(!mob.stat && isturf(mob.loc) && !mob.restrained())
		C.toggle_throw_mode()

/client/verb/drop_item()
	set hidden = TRUE

	if(!isrobot(mob))
		mob.drop_item_v()

/client/Move(new_loc, direction)
	if(world.time < move_delay)
		return FALSE
	move_delay = world.time + world.tick_lag // This is here because Move() can now be called mutiple times per tick.
	if(!direction || !new_loc)
		return FALSE
	if(isnull(mob?.loc))
		return FALSE
	if(mob.monkeyizing)
		return FALSE // This is sorta the goto stop mobs from moving var.

	if(!isliving(mob))
		return mob.Move(new_loc, direction)

	if(mob.stat == DEAD)
		return FALSE

	var/mob/living/living_mover = mob
	if(living_mover.incorporeal_move) // Move though walls.
		process_incorporeal_movement(direction)
		return FALSE

	if(isnotnull(mob.control_object))
		move_control_object(direction)
		return FALSE

	if(locate(/obj/effect/stop, mob.loc))
		for(var/obj/effect/stop/S in mob.loc)
			if(S.victim == mob)
				return FALSE

	if(isAI(mob))
		var/mob/living/silicon/ai/moving_ai = mob
		return moving_ai.AIMove(new_loc, direction)

	if(isnotnull(mob.client) && mob.client.view != world.view)
		if(locate(/obj/item/gun/energy/sniperrifle, mob.contents)) // If mob moves while zoomed in with sniper rifle, unzoom them.
			var/obj/item/gun/energy/sniperrifle/s = locate() in mob
			if(s.zoom)
				s.zoom()

	if(process_grab())
		return FALSE

	if(isnotnull(mob.buckled)) // If we're buckled to something, tell it we moved.
		return mob.buckled.relaymove(mob, direction)

	if(!mob.canmove)
		return FALSE

	if(isnull(mob.lastarea))
		mob.lastarea = GET_AREA(mob)

	if(isspace(mob.loc) || !mob.lastarea.has_gravity)
		if(!mob.Process_Spacemove(0))
			return FALSE

	if(ismovable(mob.loc)) // Inside an object, tell it we moved.
		var/atom/movable/loc_atom = mob.loc
		return loc_atom.relaymove(mob, direction)

	if(!isturf(mob.loc))
		return FALSE

	if(mob.restrained()) // Why being pulled while cuffed prevents you from moving.
		for(var/mob/M in range(mob, 1))
			if(M.pulling != mob)
				continue
			if(!M.restrained() && M.stat == CONSCIOUS && M.canmove && mob.Adjacent(M))
				to_chat(src, SPAN_INFO("You're restrained! You can't move!"))
				return FALSE
			M.stop_pulling()

	if(length(mob.pinned))
		to_chat(src, SPAN_INFO("You're pinned to a wall by [mob.pinned[1]]!"))
		return FALSE

	// We are now going to move.
	var/new_delay = mob.move_intent.move_delay // Sets the initial move delay.
	mob.last_move_intent = world.time + 10
	new_delay += mob.movement_delay()
	mob.glide_size = DELAY_TO_GLIDE_SIZE(new_delay)

	// Something with pulling things.
	if(locate(/obj/item/grab, mob))
		process_pulling(mob, direction)

	if(mob.confused)
		step(mob, pick(GLOBL.cardinal))
	else
		. = ..()

	move_delay += new_delay

/*
 * move_control_object
 * Called by /client/Move()
 */
/client/proc/move_control_object(direct)
	if(isnull(mob?.control_object))
		return

	if(mob.control_object.density)
		step(mob.control_object, direct)
		if(isnull(mob.control_object))
			return
		mob.control_object.set_dir(direct)
	else
		mob.control_object.forceMove(get_step(mob.control_object, direct))

/*
 * Process_Grab()
 * Called by client/Move()
 * Checks to see if you are grabbing anything and if moving will affect your grab.
 */
/client/proc/process_grab()
	for(var/obj/item/grab/G in list(mob.l_hand, mob.r_hand))
		if(G.state == GRAB_KILL) //no wandering across the station/asteroid while choking someone
			mob.visible_message(SPAN_WARNING("[mob] lost \his tight grip on [G.affecting]'s neck!"))
			G.hud.icon_state = "disarm/kill"
			G.state = GRAB_NECK

/*
 * process_incorporeal_movement
 * Called by client/Move()
 * Allows mobs to run though walls.
 */
/client/proc/process_incorporeal_movement(direction)
	var/turf/mobloc = GET_TURF(mob)
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	switch(L.incorporeal_move)
		if(1)
			L.forceMove(get_step(L, direction))
			L.set_dir(direction)
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direction)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y + 2)
						if(locy > world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y - 2)
						if(locy < 1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x + 2)
						if(locx > world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x - 2)
						if(locx < 1)
							return
					else
						return
				L.forceMove(locate(locx, locy, mobloc.z))
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, L.loc))
						spawn(0)
							anim(T, L, 'icons/mob/mob.dmi', , "shadow", , L.dir)
						limit--
						if(limit <= 0)
							break
			else
				spawn(0)
					anim(mobloc, mob, 'icons/mob/mob.dmi', , "shadow", , L.dir)
				L.forceMove(get_step(L, direction))
			L.set_dir(direction)
	return 1

/*
 * process_pulling
 * Called by /client/Move()
 */
/client/proc/process_pulling(mob/puller, direction)
	move_delay = max(move_delay, world.time + 7)
	var/list/L = puller.ret_grab()
	if(!islist(L))
		return

	if(length(L) == 2)
		L.Remove(puller)
		var/mob/M = L[1]
		if(isnull(M))
			return

		if(get_dist(puller, M) <= 1 || M.loc == puller.loc)
			var/turf/T = puller.loc
			if(isturf(M.loc))
				var/diag = get_dir(puller, M)
				if((diag - 1) & diag)
				else
					diag = null
				if(get_dist(puller, M) > 1 || diag)
					step(M, get_dir(M.loc, T))
	else
		for(var/mob/M in L)
			M.other_mobs = 1
			if(puller != M)
				M.animate_movement = SLIDE_STEPS
		for(var/mob/M in L)
			spawn(0)
				step(M, direction)
				return
			spawn(1)
				M.other_mobs = null
				M.animate_movement = SLIDE_STEPS
				return

/*
 * Process_Spacemove
 * Called by /client/Move()
 * For moving in space.
 * Return TRUE for movement, FALSE for none.
 */
/mob/proc/Process_Spacemove(check_drift = 0)
	//First check to see if we can do things
	if(restrained())
		return FALSE

	/*
	if(iscarbon(src))
		if(src.l_hand && src.r_hand)
			return FALSE
	*/

	var/dense_object = 0
	for(var/turf/turf in oview(1, src))
		if(isspace(turf))
			continue

		if(ishuman(src))	// Only humans can wear magboots, so we give them a chance to.
			var/mob/living/carbon/human/H = src
			if(isfloorturf(turf) && !lastarea.has_gravity)
				if(!(istype(H.shoes, /obj/item/clothing/shoes/magboots) && HAS_ITEM_FLAGS(H.shoes, ITEM_FLAG_NO_SLIP)))
					continue

		else
			if(isfloorturf(turf) && !lastarea.has_gravity) // No one else gets a chance.
				continue
		/*
		if(isfloorturf(turf) && (src.flags & NOGRAV))
			continue
		*/

		dense_object++
		break

	if(!dense_object && (locate(/obj/structure/lattice) in oview(1, src)))
		dense_object++

	// Lastly attempt to locate any dense objects we could push off of.
	// TODO: If we implement objects drifing in space this needs to really push them
	// Due to a few issues only anchored and dense objects will now work.
	if(!dense_object)
		for(var/obj/O in oview(1, src))
			if(O && O.density && O.anchored)
				dense_object++
				break

	// Nothing to push off of so end here.
	if(!dense_object)
		return FALSE

	// Check to see if we slipped.
	if(prob(Process_Spaceslipping(5)))
		to_chat(src, SPAN_INFO_B("You slipped!"))
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return FALSE
	// If not then we can reset inertia and move.
	inertia_dir = 0
	return TRUE

/mob/proc/Process_Spaceslipping(prob_slip = 5)
	// Setup slippage.
	// If knocked out we might just hit it and stop. This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment.

	prob_slip = round(prob_slip)
	return(prob_slip)

// The real Move() proc is above, but touching that massive block just to put this in isn't worth it.
/mob/Move(new_loc, direction)
	. = ..(new_loc, direction)
	if(.)
		post_move(new_loc, direction)

// Called when a mob successfully moves.
// Would've been an /atom/movable proc but it caused issues.
/mob/proc/post_move(new_loc, direction)
	for(var/obj/O in contents)
		O.on_loc_moved(new_loc, direction)

// Received from post_move(), useful for items that need to know that their loc just moved.
/obj/proc/on_loc_moved(new_loc, direction)
	return

/obj/item/storage/on_loc_moved(new_loc, direction)
	for(var/obj/O in contents)
		O.on_loc_moved(new_loc, direction)

// /tg/ movement verbs
// The BYOND versions of these verbs wait for the next tick before acting.
// Instant verbs however can run mid tick or even during the time between ticks.
/client/verb/moveup()
	set name = ".moveup"
	set instant = TRUE
	Move(get_step(mob, NORTH), NORTH)

/client/verb/movedown()
	set name = ".movedown"
	set instant = TRUE
	Move(get_step(mob, SOUTH), SOUTH)

/client/verb/moveright()
	set name = ".moveright"
	set instant = TRUE
	Move(get_step(mob, EAST), EAST)

/client/verb/moveleft()
	set name = ".moveleft"
	set instant = TRUE
	Move(get_step(mob, WEST), WEST)