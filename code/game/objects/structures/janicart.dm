/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/obj/item/mop/mymop = null
	var/obj/item/reagent_holder/spray/myspray = null
	var/obj/item/lightreplacer/myreplacer = null
	var/signs = 0	//maximum capacity hardcoded below

/obj/structure/janitorialcart/initialise()
	. = ..()
	create_reagents(100)

/obj/structure/janitorialcart/get_examine_text()
	. = ..()
	. += SPAN_INFO("It contains <em>[reagents.total_volume]</em> unit\s of liquid!")
	//everything else is visible, so doesn't need to be mentioned

/obj/structure/janitorialcart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/storage/bag/trash) && isnull(mybag))
		user.drop_item()
		mybag = I
		I.forceMove(src)
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [I] into [src]."))

	else if(istype(I, /obj/item/mop))
		if(I.reagents.total_volume < I.reagents.maximum_volume)	//if it's not completely soaked we assume they want to wet it, otherwise store it
			if(reagents.total_volume < 1)
				to_chat(user, SPAN_WARNING("[src] is out of water!"))
			else
				reagents.trans_to(I, 5)
				to_chat(user, SPAN_NOTICE("You wet [I] in [src]."))
				playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
				return
		if(isnull(mymop))
			user.drop_item()
			mymop = I
			I.forceMove(src)
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put [I] into [src]."))

	else if(istype(I, /obj/item/reagent_holder/spray) && isnull(myspray))
		user.drop_item()
		myspray = I
		I.forceMove(src)
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [I] into [src]."))

	else if(istype(I, /obj/item/lightreplacer) && isnull(myreplacer))
		user.drop_item()
		myreplacer = I
		I.forceMove(src)
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [I] into [src]."))

	else if(istype(I, /obj/item/caution))
		if(signs < 4)
			user.drop_item()
			I.forceMove(src)
			signs++
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put [I] into [src]."))
		else
			to_chat(user, SPAN_NOTICE("[src] can't hold any more signs."))

	else if(isnotnull(mybag))
		mybag.attackby(I, user)

/obj/structure/janitorialcart/attack_hand(mob/user)
	user.set_machine(src)
	var/html
	if(isnotnull(mybag))
		html += "<a href='byond://?src=\ref[src];garbage=1'>[mybag.name]</a><br>"
	if(isnotnull(mymop))
		html += "<a href='byond://?src=\ref[src];mop=1'>[mymop.name]</a><br>"
	if(isnotnull(myspray))
		html += "<a href='byond://?src=\ref[src];spray=1'>[myspray.name]</a><br>"
	if(isnotnull(myreplacer))
		html += "<a href='byond://?src=\ref[src];replacer=1'>[myreplacer.name]</a><br>"
	if(signs)
		html += "<a href='byond://?src=\ref[src];sign=1'>[signs] sign\s</a><br>"

	var/datum/browser/popup = new /datum/browser(user, "janicart", name, 240, 160)
	popup.set_content(html)
	popup.open()

/obj/structure/janitorialcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	if(href_list["close"])
		usr << browse(null, "window=janicart")
		usr.unset_machine()
		return

	var/mob/living/user = usr
	if(href_list["garbage"])
		if(isnotnull(mybag))
			user.put_in_hands(mybag)
			to_chat(user, SPAN_NOTICE("You take [mybag] from [src]."))
			mybag = null
	if(href_list["mop"])
		if(isnotnull(mymop))
			user.put_in_hands(mymop)
			to_chat(user, SPAN_NOTICE("You take [mymop] from [src]."))
			mymop = null
	if(href_list["spray"])
		if(isnotnull(myspray))
			user.put_in_hands(myspray)
			to_chat(user, SPAN_NOTICE("You take [myspray] from [src]."))
			myspray = null
	if(href_list["replacer"])
		if(isnotnull(myreplacer))
			user.put_in_hands(myreplacer)
			to_chat(user, SPAN_NOTICE("You take [myreplacer] from [src]."))
			myreplacer = null
	if(href_list["sign"])
		if(signs)
			var/obj/item/caution/sign = locate() in src
			if(isnotnull(sign))
				user.put_in_hands(sign)
				to_chat(user, SPAN_NOTICE("You take \a [sign] from [src]."))
				signs--
			else
				warning("[src] signs ([signs]) didn't match contents")
				signs = 0

	update_icon()
	updateUsrDialog()

/obj/structure/janitorialcart/update_icon()
	cut_overlays()
	if(isnotnull(mybag))
		add_overlay("cart_garbage")
	if(isnotnull(mymop))
		add_overlay("cart_mop")
	if(isnotnull(myspray))
		add_overlay("cart_spray")
	if(isnotnull(myreplacer))
		add_overlay("cart_replacer")
	if(signs)
		add_overlay("cart_sign[signs]")


//old style retardo-cart
/obj/structure/stool/bed/chair/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/callme = "pimpin' ride"	//how do people refer to it?

/obj/structure/stool/bed/chair/janicart/initialise()
	. = ..()
	handle_rotation()
	create_reagents(100)

/obj/structure/stool/bed/chair/janicart/get_examine_text()
	. = ..()
	. += SPAN_INFO("It contains <em>[reagents.total_volume]</em> unit\s of water!")
	if(isnotnull(mybag))
		. += SPAN_INFO("\A [mybag] is hanging on the [callme].")

/obj/structure/stool/bed/chair/janicart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop))
		if(reagents.total_volume > 1)
			reagents.trans_to(I, 2)
			to_chat(user, SPAN_NOTICE("You wet [I] in the [callme]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_NOTICE("This [callme] is out of water!"))
	else if(istype(I, /obj/item/key))
		to_chat(user, "Hold [I] in one of your hands while you drive this [callme].")
	else if(istype(I, /obj/item/storage/bag/trash))
		to_chat(user, SPAN_NOTICE("You hook the trashbag onto the [callme]."))
		user.drop_item()
		I.forceMove(src)
		mybag = I

/obj/structure/stool/bed/chair/janicart/attack_hand(mob/user)
	if(isnotnull(mybag))
		mybag.forceMove(GET_TURF(user))
		user.put_in_hands(mybag)
		mybag = null
	else
		..()

/obj/structure/stool/bed/chair/janicart/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle()
	if(istype(user.l_hand, /obj/item/key) || istype(user.r_hand, /obj/item/key))
		step(src, direction)
		update_mob()
		handle_rotation()
	else
		to_chat(user, SPAN_NOTICE("You'll need the keys in one of your hands to drive this [callme]."))

/obj/structure/stool/bed/chair/janicart/Move()
	. = ..()
	if(buckled_mob?.buckled == src)
		buckled_mob.forceMove(loc)

/obj/structure/stool/bed/chair/janicart/buckle_mob(mob/M, mob/user)
	if(M != user || !ismob(M) || !in_range(src, user) || user.restrained() || user.lying || user.stat || M.buckled || issilicon(user))
		return

	unbuckle()

	M.visible_message(
		SPAN_NOTICE("[M] climbs onto the [callme]!"),
		SPAN_NOTICE("You climb onto the [callme]!")
	)
	M.buckled = src
	M.forceMove(loc)
	M.set_dir(dir)
	M.update_canmove()
	buckled_mob = M
	update_mob()
	add_fingerprint(user)

/obj/structure/stool/bed/chair/janicart/unbuckle()
	if(isnotnull(buckled_mob))
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
	..()

/obj/structure/stool/bed/chair/janicart/handle_rotation()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER

	if(buckled_mob?.loc != loc)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		buckled_mob.buckled = src //Restoring

	update_mob()

/obj/structure/stool/bed/chair/janicart/proc/update_mob()
	if(isnull(buckled_mob))
		return

	buckled_mob.set_dir(dir)
	switch(dir)
		if(SOUTH)
			buckled_mob.pixel_x = 0
			buckled_mob.pixel_y = 7
		if(WEST)
			buckled_mob.pixel_x = 13
			buckled_mob.pixel_y = 7
		if(NORTH)
			buckled_mob.pixel_x = 0
			buckled_mob.pixel_y = 4
		if(EAST)
			buckled_mob.pixel_x = -13
			buckled_mob.pixel_y = 7

/obj/structure/stool/bed/chair/janicart/bullet_act(obj/item/projectile/proj)
	if(isnotnull(buckled_mob))
		if(prob(85))
			return buckled_mob.bullet_act(proj)
	visible_message(SPAN_WARNING("[proj] ricochets off the [callme]!"))

/obj/item/key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = 1