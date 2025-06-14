/obj/structure/coatrack
	name = "coat rack"
	desc = "Rack that holds coats."
	icon = 'icons/obj/coatrack.dmi'
	icon_state = "coatrack0"
	var/obj/item/clothing/suit/coat
	var/list/allowed = list(/obj/item/clothing/suit/storage/labcoat, /obj/item/clothing/suit/storage/det_suit)

/obj/structure/coatrack/attack_hand(mob/user)
	user.visible_message("[user] takes [coat] off \the [src].", "You take [coat] off the \the [src]")
	if(!user.put_in_active_hand(coat))
		coat.forceMove(GET_TURF(user))
	coat = null
	update_icon()

/obj/structure/coatrack/attackby(obj/item/W, mob/user)
	var/can_hang = 0
	for (var/T in allowed)
		if(istype(W,T))
			can_hang = 1
	if (can_hang && !coat)
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		coat = W
		user.drop_item(src)
		coat.forceMove(src)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("You cannot hang [W] on [src]"))
		return ..()

/obj/structure/coatrack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	var/can_hang = 0
	for(var/T in allowed)
		if(istype(mover, T))
			can_hang = 1

	if(can_hang && !coat)
		visible_message("[mover] lands on \the [src].")
		coat = mover
		coat.forceMove(src)
		update_icon()
		return FALSE
	else
		return TRUE

/obj/structure/coatrack/update_icon()
	cut_overlays()
	if(istype(coat, /obj/item/clothing/suit/storage/labcoat))
		add_overlay(image(icon, icon_state = "coat_lab"))
	if(istype(coat, /obj/item/clothing/suit/storage/labcoat/cmo))
		add_overlay(image(icon, icon_state = "coat_cmo"))
	if(istype(coat, /obj/item/clothing/suit/storage/det_suit))
		add_overlay(image(icon, icon_state = "coat_det"))