//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = 2.0

/obj/item/bodybag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
	R.add_fingerprint(user)
	qdel(src)


/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	icon_state = "bodybags"

	starts_with = list(
		/obj/item/bodybag = 7
	)


/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	var/item_path = /obj/item/bodybag
	density = FALSE

/obj/structure/closet/body_bag/attack_tool(obj/item/tool, mob/user)
	if(iswirecutter(tool) && name != "body bag")
		to_chat(user, SPAN_NOTICE("You cut the tag off the body bag."))
		name = "body bag"
		overlays.Cut()
		return TRUE

	return ..()

/obj/structure/closet/body_bag/attackby(W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", name, null) as text
		if(user.get_active_hand() != W)
			return
		if(!in_range(src, user) && loc != user)
			return
		t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
		if(isnotnull(t))
			name = "body bag - [t]"
			overlays.Add(image(icon, "bodybag_label"))
		else
			name = "body bag"
	//..() //Doesn't need to run the parent. Since when can fucking bodybags be welded shut? -Agouri
		return

/obj/structure/closet/body_bag/close()
	if(..())
		density = FALSE
		return 1
	return 0

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))
			return
		if(opened)
			return 0
		if(length(contents))
			return 0
		visible_message("[usr] folds up the [src.name]")
		new item_path(get_turf(src))
		spawn(0)
			qdel(src)
		return

/obj/structure/closet/bodybag/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened


/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A folded, non-reusable bag designed to prevent additional damage to an occupant at the cost of genetic damage."
	icon = 'icons/obj/cryobag.dmi'
	icon_state = "bodybag_folded"

/obj/item/bodybag/cryobag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/R = new /obj/structure/closet/body_bag/cryobag(user.loc)
	R.add_fingerprint(user)
	qdel(src)


/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A non-reusable plastic bag designed to prevent additional damage to an occupant at the cost of genetic damage."
	icon = 'icons/obj/cryobag.dmi'
	item_path = /obj/item/bodybag/cryobag
	var/used = 0

/obj/structure/closet/body_bag/cryobag/open()
	. = ..()
	if(used)
		var/obj/item/O = new/obj/item(src.loc)
		O.name = "used stasis bag"
		O.icon = src.icon
		O.icon_state = "bodybag_used"
		O.desc = "Pretty useless now.."
		qdel(src)

/obj/structure/closet/body_bag/cryobag/MouseDrop(over_object, src_location, over_location)
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))
			return
		to_chat(usr, SPAN_WARNING("You can't fold that up anymore..."))
	..()