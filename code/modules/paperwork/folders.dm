/obj/item/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = WEIGHT_CLASS_SMALL
	pressure_resistance = 2

/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/folder/update_icon()
	cut_overlays()
	if(length(contents))
		add_overlay("folder_paper")
	return

/obj/item/folder/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		user.drop_item()
		W.forceMove(src)
		to_chat(user, SPAN_NOTICE("You put the [W] into \the [src]."))
		update_icon()
	else if(istype(W, /obj/item/pen))
		var/n_name = copytext(sanitize(input(usr, "What would you like to label the folder?", "Folder Labelling", null)  as text), 1, MAX_NAME_LEN)
		if((loc == usr && usr.stat == CONSCIOUS))
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"
	return

/obj/item/folder/attack_self(mob/user)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/paper/P in src)
		dat += "<A href='byond://?src=\ref[src];remove=\ref[P]'>Remove</A> - <A href='byond://?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='byond://?src=\ref[src];remove=\ref[Ph]'>Remove</A> - <A href='byond://?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	SHOW_BROWSER(user, dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE
	if((user.stat || user.restrained()))
		return FALSE
	if(!user.contents.Find(src))
		return FALSE

	if(topic.has("remove"))
		var/obj/item/P = topic.get_and_locate("remove")
		if(P?.loc == src)
			P.forceMove(user.loc)
			user.put_in_hands(P)

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

	//Update everything
	attack_self(user)
	update_icon()