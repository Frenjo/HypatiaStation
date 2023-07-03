/client
	var/inquisitive_ghost = TRUE

/mob/dead/observer/verb/toggle_inquisition() // warning: unexpected inquisition
	set category = "Ghost"
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"

	if(isnull(client))
		return

	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, SPAN_INFO("You will now examine everything you click on."))
	else
		to_chat(src, SPAN_INFO("You will no longer examine things you click on."))

/mob/dead/observer/DblClickOn(atom/A, params)
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
		loc = get_turf(A)

/mob/dead/observer/ClickOn(atom/A, params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(world.time <= next_move)
		return

	next_move = world.time + 8
	// You are responsible for checking CONFIG_GET(ghost_interaction) when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/observer/user as mob)
	if(isnotnull(user?.client) && user.client.inquisitive_ghost)
		examine()

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/machinery/teleport/hub/attack_ghost(mob/user as mob)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(isnotnull(com.locked))
		user.loc = get_turf(com.locked)

/obj/effect/portal/attack_ghost(mob/user as mob)
	if(isnotnull(target))
		user.loc = get_turf(target)

/obj/machinery/gateway/centerstation/attack_ghost(mob/user as mob)
	if(isnotnull(awaygate))
		user.loc = awaygate.loc
	else
		to_chat(user, "[src] has no destination.")

/obj/machinery/gateway/centeraway/attack_ghost(mob/user as mob)
	if(isnotnull(stationgate))
		user.loc = stationgate.loc
	else
		to_chat(user, "[src] has no destination.")

// -------------------------------------------
// This was supposed to be used by adminghosts
// I think it is a *terrible* idea
// but I'm leaving it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user as mob)
	if(!user || !user.client || !user.client.holder)
		return
	attack_hand(user)

*/