/*
 *	Absorbs /obj/item/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/storage/secure
	name = "secstorage"
	w_class = 3.0
	max_w_class = 2
	max_combined_w_class = 14

	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/emagged = 0
	var/open = 0

/obj/item/storage/secure/get_examine_text(mob/user)
	. = ..()
	if(in_range(src, user))
		. += "The service panel is [open ? "open" : "closed"]."

/obj/item/storage/secure/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/storage/secure/attackby(obj/item/W, mob/user)
	if(locked)
		if((istype(W, /obj/item/card/emag)||istype(W, /obj/item/melee/energy/blade)) && (!emagged))
			emagged = 1
			add_overlay(icon_sparking)
			sleep(6)
			cut_overlays()
			add_overlay(icon_locking)
			locked = 0
			if(istype(W, /obj/item/melee/energy/blade))
				make_sparks(5, FALSE, loc)
				playsound(src, 'sound/weapons/melee/blade1.ogg', 50, 1)
				playsound(src, "sparks", 50, 1)
				user << "You slice through the lock on [src]."
			else
				user << "You short out the lock on [src]."
			return

		if(isscrewdriver(W))
			if(do_after(user, 20))
				open = !open
				to_chat(user, SPAN_INFO("You [open ? "open" : "close"] the service panel."))
			return
		if(ismultitool(W) && open == 1 && !l_hacking)
			user.show_message(text("\red Now attempting to reset internal memory, please hold."), 1)
			l_hacking = 1
			if (do_after(usr, 100))
				if (prob(40))
					l_setshort = 1
					l_set = 0
					user.show_message(text("\red Internal memory reset.  Please give it a few seconds to reinitialize."), 1)
					sleep(80)
					l_setshort = 0
					l_hacking = 0
				else
					user.show_message(text("\red Unable to reset internal memory."), 1)
					l_hacking = 0
			else	l_hacking = 0
			return
		//At this point you have exhausted all the special things to do when locked
		// ... but it's still locked.
		return

	// -> storage/attackby() what with handle insertion, etc
	..()

/obj/item/storage/secure/MouseDrop(over_object, src_location, over_location)
	if (locked)
		add_fingerprint(usr)
		return
	..()

/obj/item/storage/secure/attack_self(mob/user)
	user.set_machine(src)
	var/dat = text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (locked ? "LOCKED" : "UNLOCKED"))
	var/message = "Code"
	if ((l_set == 0) && (!emagged) && (!l_setshort))
		dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>")
	if (emagged)
		dat += text("<p>\n<font color=red><b>LOCKING SYSTEM ERROR - 1701</b></font>")
	if (l_setshort)
		dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
	message = text("[]", code)
	if (!locked)
		message = "*****"
	dat += text("<HR>\n>[]<BR>\n<A href='byond://?src=\ref[];type=1'>1</A>-<A href='byond://?src=\ref[];type=2'>2</A>-<A href='byond://?src=\ref[];type=3'>3</A><BR>\n<A href='byond://?src=\ref[];type=4'>4</A>-<A href='byond://?src=\ref[];type=5'>5</A>-<A href='byond://?src=\ref[];type=6'>6</A><BR>\n<A href='byond://?src=\ref[];type=7'>7</A>-<A href='byond://?src=\ref[];type=8'>8</A>-<A href='byond://?src=\ref[];type=9'>9</A><BR>\n<A href='byond://?src=\ref[];type=R'>R</A>-<A href='byond://?src=\ref[];type=0'>0</A>-<A href='byond://?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
	user << browse(dat, "window=caselock;size=300x280")

/obj/item/storage/secure/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()) || !in_range(src, usr))
		return
	if (href_list["type"])
		if (href_list["type"] == "E")
			if ((l_set == 0) && (length(code) == 5) && (!l_setshort) && (code != "ERROR"))
				l_code = code
				l_set = 1
			else if ((code == l_code) && (emagged == 0) && (l_set == 1))
				locked = 0
				cut_overlays()
				add_overlay(icon_opened)
				code = null
			else
				code = "ERROR"
		else
			if ((href_list["type"] == "R") && (emagged == 0) && (!l_setshort))
				locked = 1
				cut_overlays()
				code = null
				close(usr)
			else
				code += text("[]", href_list["type"])
				if (length(code) > 5)
					code = "ERROR"
		add_fingerprint(usr)
		for(var/mob/M in viewers(1, loc))
			if ((M.client && M.machine == src))
				attack_self(M)
			return
	return

// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0

/obj/item/storage/secure/briefcase/New()
	..()
	new /obj/item/paper(src)
	new /obj/item/pen(src)

/obj/item/storage/secure/briefcase/attack_hand(mob/user)
	if((loc == user) && (locked == 1))
		usr << "\red [src] is locked and cannot be opened!"
	else if((loc == user) && (!locked))
		open(usr)
	else
		..()
		for(var/mob/M in range(1))
			if(M.s_active == src)
				close(M)
	add_fingerprint(user)
	return

	//I consider this worthless but it isn't my code so whatever.  Remove or uncomment.
	/*attack(mob/M, mob/living/user)
		if ((MUTATION_CLUMSY in user.mutations) && prob(50))
			user << "\red The [src] slips out of your hand and hits your head."
			user.take_organ_damage(10)
			user.Paralyse(2)
			return

		M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been attacked with [name] by [user.name] ([user.ckey])</font>"
		user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [name] to attack [M.name] ([M.ckey])</font>"

		log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)])</font>")

		var/t = user:zone_sel.selecting
		if (t == "head")
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if (H.stat < 2 && H.health < 50 && prob(90))
				// ******* Check
					if (istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80))
						H << "\red The helmet protects you from being hit hard in the head!"
						return
					var/time = rand(2, 6)
					if (prob(75))
						H.Paralyse(time)
					else
						H.Stun(time)
					if(H.stat != 2)	H.stat = 1
					for(var/mob/O in viewers(H, null))
						O.show_message(text("\red <B>[] has been knocked unconscious!</B>", H), 1, "\red You hear someone fall.", 2)
				else
					H << text("\red [] tried to knock you unconcious!",user)
					H.eye_blurry += 3

		return*/

// -----------------------------
//        Secure Safe
// -----------------------------
/obj/item/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/storage/safe.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	force = 8.0
	w_class = 8.0
	max_w_class = 8
	anchored = TRUE
	density = FALSE
	cant_hold = list("/obj/item/storage/secure/briefcase")

/obj/item/storage/secure/safe/New()
	..()
	new /obj/item/paper(src)
	new /obj/item/pen(src)

/obj/item/storage/secure/safe/attack_hand(mob/user)
	return attack_self(user)

/obj/item/storage/secure/safe/HoS/New()
	..()
	//new /obj/item/storage/lockbox/clusterbang(src) This item is currently broken... and probably shouldnt exist to begin with (even though it's cool)