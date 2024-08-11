/obj/structure/girder
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	layer = 2

	var/state = 0
	var/health = 200

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/energy))
		health -= Proj.damage
		..()
		if(health <= 0)
			new /obj/item/stack/sheet/steel(get_turf(src))
			qdel(src)

		return

/obj/structure/girder/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/wrench) && state == 0)
		if(anchored && !istype(src,/obj/structure/girder/displaced))
			playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
			user << "\blue Now disassembling the girder"
			if(do_after(user, 40))
				if(!src)
					return
				user << "\blue You dissasembled the girder!"
				new /obj/item/stack/sheet/steel(get_turf(src))
				qdel(src)
		else if(!anchored)
			playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
			user << "\blue Now securing the girder"
			if(get_turf(user, 40))
				user << "\blue You secured the girder!"
				new/obj/structure/girder(src.loc)
				qdel(src)

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		user << "\blue Now slicing apart the girder"
		if(do_after(user, 30))
			if(!src)
				return
			user << "\blue You slice apart the girder!"
			new /obj/item/stack/sheet/steel(get_turf(src))
			qdel(src)

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		user << "\blue You drill through the girder!"
		new /obj/item/stack/sheet/steel(get_turf(src))
		qdel(src)

	else if(istype(W, /obj/item/screwdriver) && state == 2 && istype(src,/obj/structure/girder/reinforced))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		user << "\blue Now unsecuring support struts"
		if(do_after(user, 40))
			if(!src)
				return
			user << "\blue You unsecured the support struts!"
			state = 1

	else if(istype(W, /obj/item/wirecutters) && istype(src,/obj/structure/girder/reinforced) && state == 1)
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		user << "\blue Now removing support struts"
		if(do_after(user, 40))
			if(!src)
				return
			user << "\blue You removed the support struts!"
			new/obj/structure/girder(src.loc)
			qdel(src)

	else if(istype(W, /obj/item/crowbar) && state == 0 && anchored )
		playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
		user << "\blue Now dislodging the girder"
		if(do_after(user, 40))
			if(!src)
				return
			user << "\blue You dislodged the girder!"
			new/obj/structure/girder/displaced(src.loc)
			qdel(src)

	else if(istype(W, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/S = W

		if(istype(S, /obj/item/stack/sheet/plasteel))
			if(S.amount < 1)
				return TRUE
			user << "\blue Now reinforcing girders"
			if(!do_after(user, 6 SECONDS))
				return TRUE
			S.use(1)
			user << "\blue Girders reinforced!"
			new /obj/structure/girder/reinforced(loc)
			qdel(src)
			return TRUE

		if(anchored && isnotnull(S.material.wall_path))
			if(S.amount < 2)
				to_chat(user, SPAN_WARNING("You require more [S.name] to do that!"))
				return TRUE
			user << "\blue Now adding plating..."
			if(!do_after(user, 4 SECONDS))
				return TRUE
			S.use(2)
			user << "\blue You added the plating!"
			var/turf/T = get_turf(src)
			T.ChangeTurf(S.material.wall_path)
			for(var/turf/closed/wall/X in T.loc)
				X?.add_hiddenprint(usr)
			qdel(src)
			return TRUE

		if(!anchored && isnotnull(S.material.wall_false_path))
			if(S.amount < 2)
				return TRUE
			S.use(2)
			user << "\blue You create a false wall! Push on it to open or close the passage."
			var/obj/structure/falsewall/fake = new S.material.wall_false_path(loc)
			fake.add_hiddenprint(usr)
			qdel(src)
			return TRUE

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if(P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			user.drop_item()
			P.loc = src.loc
			user << "\blue You fit the pipe into the [src]!"
	else
		..()


/obj/structure/girder/blob_act()
	if(prob(40))
		qdel(src)


/obj/structure/girder/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(30))
				var/remains = pick(/obj/item/stack/rods, /obj/item/stack/sheet/steel)
				new remains(loc)
				qdel(src)
			return
		if(3.0)
			if (prob(5))
				var/remains = pick(/obj/item/stack/rods, /obj/item/stack/sheet/steel)
				new remains(loc)
				qdel(src)
			return
		else
	return

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = FALSE
	health = 50

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	state = 2
	health = 500

/obj/structure/girder/reinforced/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/sheet/plasteel))
		var/obj/item/stack/sheet/plasteel/S = I
		if(S.amount < 1)
			return TRUE
		user << "\blue Now finalising reinforced wall."
		if(!do_after(user, 5 SECONDS))
			return TRUE
		S.use(1)
		user << "\blue Wall fully reinforced!"
		var/turf/T = get_turf(src)
		T.ChangeTurf(/turf/closed/wall/reinforced)
		for(var/turf/closed/wall/reinforced/X in T.loc)
			X?.add_hiddenprint(usr)
		qdel(src)
		return TRUE
	return ..()

/obj/structure/cultgirder
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"
	anchored = TRUE
	density = TRUE
	layer = 2
	var/health = 250

/obj/structure/cultgirder/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/wrench))
		playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
		user << "\blue Now disassembling the girder"
		if(do_after(user, 40))
			user << "\blue You dissasembled the girder!"
			new /obj/effect/decal/remains/human(get_turf(src))
			qdel(src)

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		user << "\blue Now slicing apart the girder"
		if(do_after(user, 30))
			user << "\blue You slice apart the girder!"
		new /obj/effect/decal/remains/human(get_turf(src))
		qdel(src)

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		user << "\blue You drill through the girder!"
		new /obj/effect/decal/remains/human(get_turf(src))
		qdel(src)

/obj/structure/cultgirder/blob_act()
	if(prob(40))
		qdel(src)

/obj/structure/cultgirder/bullet_act(var/obj/item/projectile/Proj) //No beam check- How else will you destroy the cult girder with silver bullets?????
	health -= Proj.damage
	..()
	if(health <= 0)
		new /obj/item/stack/sheet/steel(get_turf(src))
		qdel(src)

	return

/obj/structure/cultgirder/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(30))
				new /obj/effect/decal/remains/human(loc)
				qdel(src)
			return
		if(3.0)
			if(prob(5))
				new /obj/effect/decal/remains/human(loc)
				qdel(src)
			return
		else
	return