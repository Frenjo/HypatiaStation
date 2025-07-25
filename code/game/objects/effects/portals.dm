/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = TRUE
	anchored = TRUE

	var/delete_time = 30 SECONDS

	var/failchance = 5
	var/obj/item/target = null
	var/creator = null

/obj/effect/portal/initialise()
	. = ..()
	spawn(delete_time)
		qdel(src)

/obj/effect/portal/Bumped(mob/M)
	spawn(0)
		teleport(M)

/obj/effect/portal/Crossed(atom/movable/AM)
	spawn(0)
		teleport(AM)

/obj/effect/portal/proc/teleport(atom/movable/M)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if(M.anchored && ismecha(M))
		return
	if(icon_state == "portal1")
		return
	if(!target)
		qdel(src)
		return
	if(ismovable(M))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			icon_state = "portal1"
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon