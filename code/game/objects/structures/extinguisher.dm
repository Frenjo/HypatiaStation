/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/closets/closet.dmi'
	icon_state = "extinguisher_closed"
	anchored = TRUE
	density = FALSE
	var/obj/item/fire_extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/New()
	..()
	has_extinguisher = new /obj/item/fire_extinguisher(src)

/obj/structure/extinguisher_cabinet/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/fire_extinguisher))
		if(!has_extinguisher && opened)
			user.drop_item(O)
			contents += O
			has_extinguisher = O
			to_chat(user, SPAN_NOTICE("You place \the [O] in \the [src]."))
		else
			opened = !opened
	else
		opened = !opened
	update_icon()


/obj/structure/extinguisher_cabinet/attack_hand(mob/user)
	if(isrobot(user))
		return
	if(hasorgans(user))
		var/datum/organ/external/temp = user:organs_by_name["r_hand"]
		if(user.hand)
			temp = user:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.display_name], but cannot!"))
			return
	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, SPAN_NOTICE("You take \the [has_extinguisher] from \the [src]."))
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/attack_tk(mob/user)
	if(has_extinguisher)
		has_extinguisher.forceMove(loc)
		to_chat(user, SPAN_NOTICE("You telekinetically remove \the [has_extinguisher] from \the [src]."))
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/attack_paw(mob/user)
	attack_hand(user)
	return


/obj/structure/extinguisher_cabinet/update_icon()
	if(!opened)
		icon_state = "extinguisher_closed"
		return
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/fire_extinguisher/mini))
			icon_state = "extinguisher_mini"
		else
			icon_state = "extinguisher_full"
	else
		icon_state = "extinguisher_empty"
