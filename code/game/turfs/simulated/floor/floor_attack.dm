/turf/simulated/floor/attack_paw(mob/user as mob)
	return attack_hand(user)

/turf/simulated/floor/attack_hand(mob/user as mob)
	if(!user.canmove || user.restrained() || !user.pulling)
		return
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if(ismob(user.pulling))
		var/mob/M = user.pulling

//		if(M==user)					//temporary hack to stop runtimes. ~Carn
//			user.stop_pulling()		//but...fixed the root of the problem
//			return					//shoudn't be needed now, unless somebody fucks with pulling again.

		var/mob/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))

/turf/simulated/floor/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		if(broken || burnt)
			to_chat(user, SPAN_WARNING("You remove the broken plating."))
		else
			if(isnotnull(tile_path))
				var/obj/item/I = new tile_path(src)
				if(istype(src, /turf/simulated/floor/light))
					var/turf/simulated/floor/light/light_floor = src
					var/obj/item/stack/tile/light/light_stack = I
					light_stack.on = light_floor.get_on()
					light_stack.state = light_floor.get_state()
				to_chat(user, SPAN_WARNING("You remove \the [I]."))

		make_plating()
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
		return TRUE

	if(iswire(tool))
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return TRUE

	if(istype(tool, /obj/item/shovel))
		to_chat(user, SPAN_WARNING("You cannot shovel this."))
		return TRUE

	return ..()

/turf/simulated/floor/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return TRUE

	return ..()