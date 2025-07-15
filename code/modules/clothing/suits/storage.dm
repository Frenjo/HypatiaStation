/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets

/obj/item/clothing/suit/storage/initialise()
	. = ..()
	pockets = new /obj/item/storage/internal(src)
	pockets.storage_slots = 2	//two slots
	pockets.max_w_class = 2		//fit only pocket sized items
	pockets.max_combined_w_class = 4

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	if(pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object)
	if(pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	..()
	pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

/obj/item/clothing/suit/storage/hear_talk(mob/M, msg)
	pockets.hear_talk(M, msg)
	..()