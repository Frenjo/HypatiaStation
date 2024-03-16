/turf/simulated/floor/attack_paw(mob/user as mob)
	return attack_hand(user)

/turf/simulated/floor/attack_hand(mob/user as mob)
	if(is_light_floor())
		toggle_lightfloor_on()
		update_icon()
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

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)
	if(isnull(C) || isnull(user))
		return 0

	if(istype(C, /obj/item/light/bulb)) //only for light tiles
		if(is_light_floor())
			if(get_lightfloor_state())
				user.drop_item(C)
				qdel(C)
				set_lightfloor_state(0) //fixing it by bashing it with a light bulb, fun eh?
				update_icon()
				to_chat(user, SPAN_INFO("You replace the light bulb."))
			else
				to_chat(user, SPAN_INFO("The lightbulb seems fine, no need to replace it."))

	if(istype(C, /obj/item/crowbar) && (!(is_plating())))
		if(broken || burnt)
			to_chat(user, SPAN_WARNING("You remove the broken plating."))
		else
			var/obj/item/I = new floor_type(src)
			if(is_light_floor())
				var/obj/item/stack/tile/light/L = I
				L.on = get_lightfloor_on()
				L.state = get_lightfloor_state()
			to_chat(user, SPAN_WARNING("You remove the [I.name]."))

		make_plating()
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(is_plating())
			if(R.amount >= 2)
				to_chat(user, SPAN_INFO("Reinforcing the floor..."))
				if(do_after(user, 30) && R && R.amount >= 2 && is_plating())
					ChangeTurf(/turf/simulated/floor/reinforced)
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
					R.use(2)
					return
			else
				to_chat(user, SPAN_WARNING("You need more rods."))
		else
			to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return

	if(istype(C, /obj/item/stack/tile))
		if(is_plating())
			if(!broken && !burnt)
				var/obj/item/stack/tile/T = C
				floor_type = T.type
				intact = 1
				if(istype(T, /obj/item/stack/tile/light))
					var/obj/item/stack/tile/light/L = T
					set_lightfloor_state(L.state)
					set_lightfloor_on(L.on)
				if(istype(T, /obj/item/stack/tile/grass))
					for(var/direction in GLOBL.cardinal)
						if(istype(get_step(src, direction), /turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src, direction)
							FF.update_icon() //so siding gets updated properly
				else if(istype(T, /obj/item/stack/tile/carpet))
					for(var/direction in GLOBL.alldirs)
						if(istype(get_step(src, direction), /turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src, direction)
							FF.update_icon() //so siding gets updated properly
				T.use(1)
				update_icon()
				levelupdate()
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			else
				to_chat(user, SPAN_INFO("This section is too damaged to support a tile. Use a welder to fix the damage."))

	if(istype(C, /obj/item/stack/cable_coil))
		if(is_plating())
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			to_chat(user, SPAN_WARNING("You must remove the plating first."))

	if(istype(C, /obj/item/shovel))
		to_chat(user, SPAN_WARNING("You cannot shovel this."))

	if(istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/welder = C
		if(welder.isOn() && (is_plating()))
			if(broken || burnt)
				if(welder.remove_fuel(0, user))
					to_chat(user, SPAN_WARNING("You fix some dents on the broken plating."))
					playsound(src, 'sound/items/Welder.ogg', 80, 1)
					icon_state = "plating"
					burnt = 0
					broken = 0
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)