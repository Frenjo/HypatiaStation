/obj/structure/closet/secure/personal
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	name = "personal closet"
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)

	var/registered_name = null

/obj/structure/closet/secure/personal/attackby(obj/item/W, mob/user)
	if(src.opened)
		if(istype(W, /obj/item/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if(W)
			W.loc = src.loc
	else if(istype(W, /obj/item/card/id))
		if(src.broken)
			to_chat(user, SPAN_WARNING("It appears to be broken."))
			return
		var/obj/item/card/id/I = W
		if(!I || !I.registered_name)
			return
		if(src.allowed(user) || !src.registered_name || (istype(I) && (src.registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !(src.locked)
			if(src.locked)
				src.icon_state = src.icon_locked
			else
				src.icon_state = src.icon_closed

			if(!src.registered_name)
				src.registered_name = I.registered_name
				src.desc = "Owned by [I.registered_name]."
		else
			FEEDBACK_ACCESS_DENIED(user)
	else if((istype(W, /obj/item/card/emag) || istype(W, /obj/item/melee/energy/blade)) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		if(istype(W, /obj/item/melee/energy/blade))
			make_sparks(5, FALSE, loc)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src, "sparks", 50, 1)
			for(var/mob/O in viewers(user, 3))
				O.show_message(SPAN_INFO("The locker has been sliced open by [user] with an energy blade!"), 1, SPAN_WARNING("You hear metal being sliced and sparks flying."), 2)
	else
		FEEDBACK_ACCESS_DENIED(user)
	return

/obj/structure/closet/secure/personal/standard
	starts_with = list(
		/obj/item/radio/headset
	)

/obj/structure/closet/secure/personal/standard/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack)
	else
		starts_with.Add(/obj/item/storage/satchel/norm)
	. = ..()

/obj/structure/closet/secure/personal/patient
	name = "patient's closet"

	starts_with = list(
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/shoes/white
	)

/obj/structure/closet/secure/personal/cabinet
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

	starts_with = list(
		/obj/item/storage/satchel/withwallet,
		/obj/item/radio/headset
	)

/obj/structure/closet/secure/personal/cabinet/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened