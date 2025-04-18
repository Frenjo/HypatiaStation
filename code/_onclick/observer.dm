/client
	var/inquisitive_ghost = TRUE

/mob/dead/ghost/verb/toggle_inquisition() // warning: unexpected inquisition
	set category = PANEL_GHOST
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"

	if(isnull(client))
		return

	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, SPAN_INFO("You will now examine everything you click on."))
	else
		to_chat(src, SPAN_INFO("You will no longer examine things you click on."))

/mob/dead/ghost/DblClickOn(atom/A, params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(can_reenter_corpse && isnotnull(mind?.current))
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return									// seems legit.

	// Things you might plausibly want to follow
	if((ismob(A) && A != src) || istype(A, /obj/machinery/bot) || istype(A, /obj/singularity))
		ManualFollow(A)

	// Otherwise jump
	else
		loc = GET_TURF(A)

/mob/dead/ghost/ClickOn(atom/A, params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(world.time <= next_move)
		return

	next_move = world.time + 8
	// You are responsible for checking CONFIG_GET(/decl/configuration_entry/ghost_interaction) when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/ghost/user)
	if(user?.client?.inquisitive_ghost)
		examine(user)

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/machinery/teleport/hub/attack_ghost(mob/user)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(isnotnull(com.locked))
		user.forceMove(GET_TURF(com.locked))

/obj/effect/portal/attack_ghost(mob/user)
	if(isnotnull(target))
		user.forceMove(GET_TURF(target))

/obj/machinery/gateway/centerstation/attack_ghost(mob/user)
	if(isnotnull(awaygate))
		user.forceMove(awaygate.loc)
	else
		to_chat(user, "[src] has no destination.")

/obj/machinery/gateway/centeraway/attack_ghost(mob/user)
	if(isnotnull(stationgate))
		user.forceMove(stationgate.loc)
	else
		to_chat(user, "[src] has no destination.")

// -------------------------------------------
// This was supposed to be used by adminghosts
// I think it is a *terrible* idea
// but I'm leaving it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user)
	if(!user || !user.client || !user.client.holder)
		return
	attack_hand(user)

*/