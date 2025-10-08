/obj/item/clipboard
	name = "clipboard"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 10
	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/toppaper	//The topmost piece of paper.
	slot_flags = SLOT_BELT

/obj/item/clipboard/initialise()
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
	cut_overlays()
	if(toppaper)
		add_overlay(toppaper.icon_state)
		add_overlay(toppaper.overlays)
	if(haspen)
		add_overlay("clipboard_pen")
	add_overlay("clipboard_over")
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

	SHOW_BROWSER(user, dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)
	return

/obj/item/clipboard/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE
	if((user.stat || user.restrained()))
		return FALSE
	if(!user.contents.Find(src))
		return FALSE

	if(topic.has("pen"))
		if(isnotnull(haspen))
			haspen.forceMove(user.loc)
			user.put_in_hands(haspen)
			haspen = null

	if(topic.has("addpen"))
		if(isnull(haspen))
			if(istype(user.get_active_hand(), /obj/item/pen))
				var/obj/item/pen/W = user.get_active_hand()
				user.drop_item()
				W.forceMove(src)
				haspen = W
				to_chat(user, SPAN_NOTICE("You slot the pen into \the [src]."))

	if(topic.has("write"))
		var/obj/item/P = topic.get_and_locate("write")
		if(isnotnull(P))
			if(user.get_active_hand())
				P.attackby(user.get_active_hand(), user)

	if(topic.has("remove"))
		var/obj/item/P = topic.get_and_locate("remove")
		if(isnotnull(P))
			P.forceMove(user.loc)
			user.put_in_hands(P)
			if(P == toppaper)
				toppaper = null
				var/obj/item/paper/newtop = locate(/obj/item/paper) in src
				if(newtop && (newtop != P))
					toppaper = newtop
				else
					toppaper = null

	if(topic.has("read"))
		var/obj/item/paper/P = topic.get_and_locate("read")
		if(isnotnull(P))
			if(!(ishuman(user) || isghost(user) || issilicon(user)))
				SHOW_BROWSER(user, "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>", "window=[P.name]")
				onclose(user, "[P.name]")
			else
				SHOW_BROWSER(user, "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>", "window=[P.name]")
				onclose(user, "[P.name]")

	if(topic.has("look"))
		var/obj/item/photo/P = topic.get_and_locate("look")
		P?.show(user)

	if(topic.has("top"))
		var/obj/item/P = topic.get_and_locate("top")
		if(isnotnull(P))
			toppaper = P
			to_chat(user, SPAN_NOTICE("You move [P.name] to the top."))

	//Update everything
	attack_self(user)
	update_icon()