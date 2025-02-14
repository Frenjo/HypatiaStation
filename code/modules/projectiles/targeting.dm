/obj/item/gun/verb/toggle_firerate()
	set category = PANEL_OBJECT
	set name = "Toggle Firerate"

	firerate = !firerate
	if(!firerate)
		to_chat(loc, "You will now continue firing when your target moves.")
	else
		to_chat(loc, "You will now only fire once, then lower your aim, when your target moves.")

/obj/item/gun/verb/lower_aim()
	set category = PANEL_OBJECT
	set name = "Lower Aim"

	if(isnotnull(target))
		stop_aim()
		usr.visible_message(SPAN_INFO("\The [usr] lowers \the [src]..."))

//Clicking gun will still lower aim for guns that don't overwrite this
/obj/item/gun/attack_self()
	lower_aim()

//Removing the lock and the buttons.
/obj/item/gun/dropped(mob/user)
	stop_aim()
	user.client?.remove_gun_icons()
	return ..()

/obj/item/gun/equipped(mob/user, slot)
	if(slot != SLOT_ID_L_HAND && slot != SLOT_ID_R_HAND)
		stop_aim()
		user.client?.remove_gun_icons()
	return ..()

// Removes lock from all targets.
/obj/item/gun/proc/stop_aim()
	if(isnotnull(target))
		for(var/mob/living/M in target)
			M?.NotTargeted(src) //Untargeting people.
		qdel(target)

//Compute how to fire.....
//Return 1 if a target was found, 0 otherwise.
/obj/item/gun/proc/PreFire(atom/A, mob/living/user, params)
	//Lets not spam it.
	if(lock_time > world.time - 2)
		return

	user.set_dir(get_cardinal_dir(src, A))
	if(isliving(A) && !(A in target))
		Aim(A) 	//Clicked a mob, aim at them
		return 1

	//Didn't click someone, check if there is anyone along that guntrace
	var/mob/living/M = GunTrace(usr.x, usr.y, A.x, A.y, usr.z, usr)  //Find dat mob.
	if(isliving(M) && (M in view(user)) && !(M in target))
		Aim(M) //Aha!  Aim at them!
		return 1

	return 0

//Aiming at the target mob.
/obj/item/gun/proc/Aim(mob/living/M)
	if(isnull(target) || !(M in target))
		lock_time = world.time
		if(target && !automatic) //If they're targeting someone and they have a non automatic weapon.
			for(var/mob/living/L in target)
				L?.NotTargeted(src)
			qdel(target)
			usr.visible_message(SPAN_DANGER("[usr] turns \the [src] on [M]!"))
		else
			usr.visible_message(SPAN_DANGER("[usr] aims \a [src] at [M]!"))
		M.Targeted(src)

//HE MOVED, SHOOT HIM!
/obj/item/gun/proc/TargetActed(mob/living/T)
	var/mob/living/M = loc
	if(M == T)
		return
	if(!istype(M))
		return
	if(src != M.get_active_hand())
		stop_aim()
		return

	//reflex firing is disabled when help intent is set
	if(M.a_intent == "help")
		to_chat(M, SPAN_WARNING("You refrain from firing your [src] as your intent is set to help."))
		return

	M.last_move_intent = world.time
	if(can_fire())
		var/firing_check = can_hit(T, usr) //0 if it cannot hit them, 1 if it is capable of hitting, and 2 if a special check is preventing it from firing.
		if(firing_check > 0)
			if(firing_check == 1)
				Fire(T, usr, reflex = 1)
		else if(!told_cant_shoot)
			to_chat(M, SPAN_WARNING("They can't be hit from here!"))
			told_cant_shoot = TRUE
			spawn(30)
				told_cant_shoot = FALSE
	else
		click_empty(M)

	usr.set_dir(get_cardinal_dir(src, T))

	if(!firerate) // If firerate is set to lower aim after one shot, untarget the target
		T.NotTargeted(src)

//Yay, math!

/proc/GunTrace(X1, Y1, X2, Y2, Z = 1, exc_obj, PX1 = 16, PY1 = 16, PX2 = 16, PY2 = 16)
	//bluh << "Tracin' [X1],[Y1] to [X2],[Y2] on floor [Z]."
	var/turf/T
	var/mob/living/M
	if(X1 == X2)
		if(Y1 == Y2)
			return 0 //Light cannot be blocked on same tile
		else
			var/s = sign(Y2 - Y1)
			Y1 += s
			while(1)
				T = locate(X1, Y1, Z)
				if(isnull(T))
					return 0
				M = locate() in T
				if(isnotnull(M))
					return M
				M = locate() in orange(1, T) - exc_obj
				if(isnotnull(M))
					return M
				Y1 += s
	else
		var/m = (32 * (Y2 - Y1) + (PY2 - PY1)) / (32 * (X2 - X1) + (PX2 - PX1))
		var/b = (Y1 + PY1 / 32-0.015625) - m * (X1 + PX1 / 32 - 0.015625) //In tiles
		var/signX = sign(X2 - X1)
		var/signY = sign(Y2 - Y1)
		if(X1 < X2)
			b += m
		while(1)
			var/xvert = round(m * X1 + b - Y1)
			if(xvert)
				Y1 += signY //Line exits tile vertically
			else
				X1 += signX //Line exits tile horizontally
			T = locate(X1, Y1, Z)
			if(isnull(T))
				return 0
			M = locate() in T
			if(isnotnull(M))
				return M
			M = locate() in orange(1, T) - exc_obj
			if(isnotnull(M))
				return M
	return 0


//Targeting management procs
/mob
	var/list/targeted_by
	var/target_time = -100
	var/last_move_intent = -100
	var/last_target_click = -5
	var/target_locked = null

/mob/living/proc/Targeted(obj/item/gun/I) //Self explanitory.
	if(isnull(I.target))
		I.target = list(src)
	else if(I.automatic && length(I.target) < 5) //Automatic weapon, they can hold down a room.
		I.target.Add(src)
	else if(length(I.target) >= 5)
		if(ismob(I.loc))
			to_chat(I.loc, "You can only target 5 people at once!")
		return
	else
		return
	for(var/mob/living/K in viewers(usr))
		K << 'sound/weapons/TargetOn.ogg'

	LAZYADD(targeted_by, I)
	I.lock_time = world.time + 20 //Target has 2 second to realize they're targeted and stop (or target the opponent).
	to_chat(src, "((\red <b>Your character is being targeted. They have 2 seconds to stop any click or move actions.</b> \black While targeted, they may \
	drag and drop items in or into the map, speak, and click on interface buttons. Clicking on the map objects (floors and walls are fine), their items \
	 (other than a weapon to de-target), or moving will result in being fired upon. \red The aggressor may also fire manually, \
	 so try not to get on their bad side.\black ))")

	if(length(targeted_by) == 1)
		spawn(0)
			target_locked = image("icon" = 'icons/effects/Targeted.dmi', "icon_state" = "locking")
			overlays += target_locked
			spawn(0)
				sleep(20)
				if(target_locked)
					target_locked = image("icon" = 'icons/effects/Targeted.dmi', "icon_state" = "locked")
					update_targeted()

	//Adding the buttons to the controller person
	var/mob/living/T = I.loc
	if(isnotnull(T))
		if(isnotnull(T.client))
			T.client.add_gun_icons()
		else
			I.lower_aim()
			return
		if(IS_RUNNING(src) && T.client.target_can_move == 1 && T.client.target_can_run == 0)
			to_chat(src, SPAN_WARNING("Your move intent is now set to walk, as your targeter permits it."))	//Self explanitory.
			set_move_intent(/decl/move_intent/walk)

		//Processing the aiming. Should be probably in separate object with process() but lasy.
		while(targeted_by && T.client)
			if(last_move_intent > I.lock_time + 10 && !T.client.target_can_move) //If target moved when not allowed to
				I.TargetActed(src)
				if(I.last_moved_mob == src) //If they were the last ones to move, give them more of a grace period, so that an automatic weapon can hold down a room better.
					I.lock_time = world.time + 5
				I.lock_time = world.time + 5
				I.last_moved_mob = src
			else if(last_move_intent > I.lock_time + 10 && !T.client.target_can_run && IS_RUNNING(src)) //If the target ran while targeted
				I.TargetActed(src)
				if(I.last_moved_mob == src) //If they were the last ones to move, give them more of a grace period, so that an automatic weapon can hold down a room better.
					I.lock_time = world.time + 5
				I.lock_time = world.time + 5
				I.last_moved_mob = src
			if(last_target_click > I.lock_time + 10 && !T.client.target_can_click) //If the target clicked the map to pick something up/shoot/etc
				I.TargetActed(src)
				if(I.last_moved_mob == src) //If they were the last ones to move, give them more of a grace period, so that an automatic weapon can hold down a room better.
					I.lock_time = world.time + 5
				I.lock_time = world.time + 5
				I.last_moved_mob = src
			sleep(1)

/mob/living/proc/NotTargeted(obj/item/gun/I)
	if(!I.silenced)
		for(var/mob/living/M in viewers(src))
			M << 'sound/weapons/TargetOff.ogg'
	targeted_by -= I
	I.target.Remove(src) //De-target them
	if(!length(I.target))
		qdel(I.target)
	var/mob/living/T = I.loc //Remove the targeting icons
	if(isnotnull(T) && ismob(T) && !I.target)
		T.client.remove_gun_icons()
	if(!length(targeted_by))
		qdel(target_locked) //Remove the overlay
		qdel(targeted_by)
	spawn(1)
		update_targeted()

/mob/living/Move()
	. = ..()
	for(var/obj/item/gun/G in targeted_by) //Handle moving out of the gunner's view.
		var/mob/living/M = G.loc
		if(!(M in view(src)))
			NotTargeted(G)
	for(var/obj/item/gun/G in src) //Handle the gunner loosing sight of their target/s
		if(isnotnull(G.target))
			for(var/mob/living/M in G.target)
				if(isnotnull(M) && !(M in view(src)))
					M.NotTargeted(G)

// If you move out of range, it isn't going to still stay locked on you any more.
/client
	var/target_can_move = FALSE
	var/target_can_run = FALSE
	var/target_can_click = FALSE
	var/gun_mode = 0

//These are called by the on-screen buttons, adjusting what the victim can and cannot do.
/client/proc/add_gun_icons()
	if(isnull(usr.item_use_icon))
		usr.item_use_icon = new /atom/movable/screen/gun/item(null)
		usr.item_use_icon.icon_state = "no_item[target_can_click]"
		usr.item_use_icon.name = "[target_can_click ? "Disallow" : "Allow"] Item Use"

	if(isnull(usr.gun_move_icon))
		usr.gun_move_icon = new /atom/movable/screen/gun/move(null)
		usr.gun_move_icon.icon_state = "no_walk[target_can_move]"
		usr.gun_move_icon.name = "[target_can_move ? "Disallow" : "Allow"] Walking"

	if(target_can_move && isnull(usr.gun_run_icon))
		usr.gun_run_icon = new /atom/movable/screen/gun/run(null)
		usr.gun_run_icon.icon_state = "no_run[target_can_run]"
		usr.gun_run_icon.name = "[target_can_run ? "Disallow" : "Allow"] Running"

	screen.Add(usr.item_use_icon)
	screen.Add(usr.gun_move_icon)
	if(target_can_move)
		screen.Add(usr.gun_run_icon)

/client/proc/remove_gun_icons()
	if(isnull(usr))
		return 1 // Runtime prevention on N00k agents spawning with SMG
	screen.Remove(usr.item_use_icon)
	screen.Remove(usr.gun_move_icon)
	if(target_can_move)
		screen.Remove(usr.gun_run_icon)
	qdel(usr.gun_move_icon)
	qdel(usr.item_use_icon)
	qdel(usr.gun_run_icon)

/client/verb/ToggleGunMode()
	set hidden = TRUE

	gun_mode = !gun_mode
	if(gun_mode)
		to_chat(usr, "You will now take people captive.")
		add_gun_icons()
	else
		to_chat(usr, "You will now shoot where you target.")
		for(var/obj/item/gun/G in usr)
			G.stop_aim()
		remove_gun_icons()
	usr.gun_setting_icon?.icon_state = "gun[gun_mode]"

/client/verb/AllowTargetMove()
	set hidden = TRUE

	//Changing client's permissions
	target_can_move = !target_can_move
	if(target_can_move)
		to_chat(usr, "Target may now walk.")
		usr.gun_run_icon = new /atom/movable/screen/gun/run(null)	//adding icon for running permission
		screen.Add(usr.gun_run_icon)
	else
		to_chat(usr, "Target may no longer move.")
		target_can_run = FALSE
		qdel(usr.gun_run_icon)	//no need for icon for running permission

	//Updating walking permission button
	if(isnotnull(usr.gun_move_icon))
		usr.gun_move_icon.icon_state = "no_walk[target_can_move]"
		usr.gun_move_icon.name = "[target_can_move ? "Disallow" : "Allow"] Walking"

	//Handling change for all the guns on client
	for(var/obj/item/gun/G in usr)
		G.lock_time = world.time + 5
		if(isnotnull(G.target))
			for(var/mob/living/M in G.target)
				if(target_can_move)
					to_chat(M, "Your character may now <b>walk</b> at the discretion of their targeter.")
					if(!target_can_run)
						to_chat(M, SPAN_WARNING("Your move intent is now set to walk, as your targeter permits it."))
						M.set_move_intent(/decl/move_intent/walk)
				else
					to_chat(M, SPAN_DANGER("Your character will now be shot if they move."))

/client/verb/AllowTargetRun()
	set hidden = TRUE

	//Changing client's permissions
	target_can_run = !target_can_run
	if(target_can_run)
		to_chat(usr, "Target may now run.")
	else
		to_chat(usr, "Target may no longer run.")

	//Updating running permission button
	if(isnotnull(usr.gun_run_icon))
		usr.gun_run_icon.icon_state = "no_run[target_can_run]"
		usr.gun_run_icon.name = "[target_can_run ? "Disallow" : "Allow"] Running"

	//Handling change for all the guns on client
	for(var/obj/item/gun/G in usr)
		G.lock_time = world.time + 5
		if(isnotnull(G.target))
			for(var/mob/living/M in G.target)
				if(target_can_run)
					to_chat(M, "Your character may now <b>run</b> at the discretion of their targeter.")
				else
					to_chat(M, SPAN_DANGER("Your character will now be shot if they run."))

/client/verb/AllowTargetClick()
	set hidden = TRUE

	//Changing client's permissions
	target_can_click = !target_can_click
	if(target_can_click)
		to_chat(usr, "Target may now use items.")
	else
		to_chat(usr, "Target may no longer use items.")

	if(isnotnull(usr.item_use_icon))
		usr.item_use_icon.icon_state = "no_item[target_can_click]"
		usr.item_use_icon.name = "[target_can_click ? "Disallow" : "Allow"] Item Use"

	//Handling change for all the guns on client
	for(var/obj/item/gun/G in usr)
		G.lock_time = world.time + 5
		if(isnotnull(G.target))
			for(var/mob/living/M in G.target)
				if(target_can_click)
					to_chat(M, "Your character may now <b>use items</b> at the discretion of their targeter.")
				else
					to_chat(M, SPAN_DANGER("Your character will now be shot if they use items."))