/obj/item/clipboard
	name = "clipboard"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throwforce = 0
	w_class = 2.0
	throw_speed = 3
	throw_range = 10
	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/toppaper	//The topmost piece of paper.
	slot_flags = SLOT_BELT

/obj/item/clipboard/New()
	. = ..()
	update_icon()

/obj/item/clipboard/MouseDrop(obj/over_object) //Quick clipboard fix. -Agouri
	if(ishuman(usr))
		var/mob/M = usr
		if(!(istype(over_object, /atom/movable/screen)))
			return ..()

		if(!M.restrained() && !M.stat)
			switch(over_object.name)
				if("r_hand")
					M.u_equip(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.u_equip(src)
					M.put_in_l_hand(src)

			add_fingerprint(usr)
			return

/obj/item/clipboard/update_icon()
	overlays.Cut()
	if(toppaper)
		overlays += toppaper.icon_state
		overlays += toppaper.overlays
	if(haspen)
		overlays += "clipboard_pen"
	overlays += "clipboard_over"
	return

/obj/item/clipboard/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		user.drop_item()
		W.forceMove(src)
		if(istype(W, /obj/item/paper))
			toppaper = W
		to_chat(user, SPAN_NOTICE("You clip the [W] onto \the [src]."))
		update_icon()
	else if(toppaper)
		toppaper.attackby(usr.get_active_hand(), usr)
		update_icon()
	return

/obj/item/clipboard/attack_self(mob/user)
	var/dat = "<title>Clipboard</title>"
	if(haspen)
		dat += "<A href='byond://?src=\ref[src];pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='byond://?src=\ref[src];addpen=1'>Add Pen</A><BR><HR>"

	//The topmost paper. I don't think there's any way to organise contents in byond, so this is what we're stuck with.	-Pete
	if(toppaper)
		var/obj/item/paper/P = toppaper
		dat += "<A href='byond://?src=\ref[src];write=\ref[P]'>Write</A> <A href='byond://?src=\ref[src];remove=\ref[P]'>Remove</A> - <A href='byond://?src=\ref[src];read=\ref[P]'>[P.name]</A><BR><HR>"

	for(var/obj/item/paper/P in src)
		if(P == toppaper)
			continue
		dat += "<A href='byond://?src=\ref[src];remove=\ref[P]'>Remove</A> - <A href='byond://?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='byond://?src=\ref[src];remove=\ref[Ph]'>Remove</A> - <A href='byond://?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"

	user << browse(dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)
	return

/obj/item/clipboard/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(usr.contents.Find(src))
		if(href_list["pen"])
			if(haspen)
				haspen.forceMove(usr.loc)
				usr.put_in_hands(haspen)
				haspen = null

		if(href_list["addpen"])
			if(!haspen)
				if(istype(usr.get_active_hand(), /obj/item/pen))
					var/obj/item/pen/W = usr.get_active_hand()
					usr.drop_item()
					W.forceMove(src)
					haspen = W
					to_chat(usr, SPAN_NOTICE("You slot the pen into \the [src]."))

		if(href_list["write"])
			var/obj/item/P = locate(href_list["write"])
			if(P)
				if(usr.get_active_hand())
					P.attackby(usr.get_active_hand(), usr)

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P)
				P.forceMove(usr.loc)
				usr.put_in_hands(P)
				if(P == toppaper)
					toppaper = null
					var/obj/item/paper/newtop = locate(/obj/item/paper) in src
					if(newtop && (newtop != P))
						toppaper = newtop
					else
						toppaper = null

		if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"])
			if(P)
				if(!(ishuman(usr) || isghost(usr) || issilicon(usr)))
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
				else
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")

		if(href_list["look"])
			var/obj/item/photo/P = locate(href_list["look"])
			if(P)
				P.show(usr)

		if(href_list["top"])
			var/obj/item/P = locate(href_list["top"])
			if(P)
				toppaper = P
				to_chat(usr, SPAN_NOTICE("You move [P.name] to the top."))

		//Update everything
		attack_self(usr)
		update_icon()
	return