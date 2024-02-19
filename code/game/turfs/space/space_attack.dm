/turf/space/attack_paw(mob/user as mob)
	return attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if(user.restrained() || isnull(user.pulling))
		return
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return

	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))

/turf/space/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(isnotnull(L))
			return
		var/obj/item/stack/rods/R = C
		to_chat(user, SPAN_INFO("Constructing support lattice ..."))
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(isnotnull(L))
			var/obj/item/stack/tile/plasteel/S = C
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))