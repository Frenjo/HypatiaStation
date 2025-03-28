/*
CONTAINS:
TOILET

/obj/item/storage/toilet
	name = "toilet"
	w_class = 4.0
	anchored = TRUE
	density = FALSE.0
	var/status = 0.0
	var/clogged = 0.0
	anchored = TRUE
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "toilet"
	item_state = "syringe_kit"

/obj/item/storage/toilet/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (src.contents.len >= 7)
		user << "The toilet is clogged!"
		return
	if (istype(W, /obj/item/disk/nuclear))
		user << "This is far too important to flush!"
		return
	if (istype(W, /obj/item/storage/))
		return
	if (istype(W, /obj/item/grab))
		playsound(src.loc, 'sound/effects/slosh.ogg', 50, 1)
		for(var/mob/O in viewers(user, null))
			O << text("\blue [] gives [] a swirlie!", user, W)
		return
	var/t
	for(var/obj/item/O in src)
		t += O.w_class
	t += W.w_class
	if (t > 30)
		user << "You cannot fit the item inside."
		return
	user.u_equip(W)
	W.forceMove(src)
	if ((user.client && user.s_active != src))
		user.client.screen -= W
	src.orient2hud(user)
	W.dropped(user)
	add_fingerprint(user)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\blue [] has put [] in []!", user, W, src), 1)
	return

/obj/item/storage/toilet/MouseDrop_T(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't help relieve anyone before the game starts."
		return
	if((!ismob(M) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat))
		return
	if (M == usr)
		for(var/mob/O in viewers(user, null))
			if ((O.client && !( O.blinded )))
				O << text("\blue [] sits on the toilet.", user)
	else
		for(var/mob/O in viewers(user, null))
			if ((O.client && !( O.blinded )))
				O << text("\blue [] is seated on the toilet by []!", M, user)
	M.anchored = TRUE
	M.buckled = src
	M.forceMove(loc)
	src.add_fingerprint(user)
	return

/obj/item/storage/toilet/attack_hand(mob/user as mob)
	for(var/mob/M in src.loc)
		if (M.buckled)
			if (M != user)
				for(var/mob/O in viewers(user, null))
					if ((O.client && !( O.blinded )))
						O << text("\blue [] is zipped up by [].", M, user)
			else
				for(var/mob/O in viewers(user, null))
					if ((O.client && !( O.blinded )))
						O << text("\blue [] zips up.", M)
			//to_world("[M] is no longer buckled to [src]")
			M.anchored = FALSE
			M.buckled = null
			src.add_fingerprint(user)
	if((src.clogged < 1) || (src.contents.len < 7) || (user.loc != src.loc))
		for(var/mob/O in viewers(user, null))
			O << text("\blue [] flushes the toilet.", user)
			src.clogged = 0
			src.contents.len = 0
	else if((src.clogged >= 1) || (src.contents.len >= 7) || (user.buckled != src.loc))
		for(var/mob/O in viewers(user, null))
			O << text("\blue The toilet is clogged!")
	return


*/