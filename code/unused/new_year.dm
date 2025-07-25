
/obj/effect/new_year_tree
	name = "The fir"
	desc = "This is a fir. Real fir on dammit spess station. You smell pine-needles."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "new-year-tree"
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	layer = 5
	pixel_x = -64
	//pixel_y = -64

/obj/effect/new_year_tree/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/grab))
		return
	W.forceMove(src)
	if (user.client)
		user.client.screen -= W
	user.u_equip(W)
	var/const/bottom_right_x = 115.0
	var/const/bottom_right_y = 150.0
	var/const/top_left_x = 15.0
	var/const/top_left_y = 15.0
	var/const/bottom_med_x = top_left_x+(bottom_right_x-top_left_x)/2
	var/x = rand(top_left_x,bottom_med_x) //point in half of circumscribing rectangle
	var/y = rand(top_left_y,bottom_right_y)
	/*
	y1=a*x1+b
	y2=a*x2+b   	b = y2-a*x2

	y1=a*x1+ y2-a*x2
	a*(x1-x2)+y2-y1=0
	a = (y1-y2)/(x1-x2)
	*/
	var/a = (top_left_y-bottom_right_y)/(top_left_x-bottom_med_x)
	var/b = bottom_right_y-a*bottom_med_x

	if (a*x+b < y) //if point is above diagonal top_left -> bottom_median
		x = bottom_med_x + x - top_left_x
		y = bottom_right_y - y + top_left_y
	var/image/I = image(W.icon, W, icon_state = W.icon_state)
	I.pixel_x = x
	I.pixel_y = y
	add_overlay(I)
/*
/obj/item/firbang
	desc = "It is set to detonate in 10 seconds."
	name = "firbang"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "flashbang"
	var/state = null
	var/det_time = 100.0
	w_class = 2.0
	item_state = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT

/obj/item/firbang/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.get_active_hand() == src)
		if ((MUTATION_CLUMSY in usr.mutations) && prob(50))
			user << "\red Huh? How does this thing work?!"
			src.state = 1
			src.icon_state = "flashbang1"
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
			spawn( 5 )
				prime()
				return
		else if (!( src.state ))
			user << "\red You prime the [src]! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/firbang/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/firbang/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/firbang/proc/prime()
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/turf/T = GET_TURF(src)
	if(isnotnull(T))
		make_smoke(3, FALSE, loc, src)
		make_sparks(3, TRUE, src)
		new /obj/effect/new_year_tree(T)
	del(src)
	return

/obj/item/firbang/attack_self(mob/user as mob)
	if (!src.state)
		if (MUTATION_CLUMSY in user.mutations)
			user << "\red Huh? How does this thing work?!"
			spawn( 5 )
				prime()
				return
		else
			user << "\red You prime the [src]! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			add_fingerprint(user)
			spawn( src.det_time )
				prime()
				return
	return

/*
/datum/supply_packs/new_year
	name = "New Year Celebration Equipment"
	contains = list("/obj/item/firbang",
					"/obj/item/firbang",
					"/obj/item/firbang",
					"/obj/item/wrapping_paper",
					"/obj/item/wrapping_paper",
					"/obj/item/wrapping_paper")
	cost = 20
	containertype = "/obj/structure/closet/crate"
	containername = "new year celebration crate"
*/