/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/New(obj/item/O)
	. = ..()
	owner = O

/obj/screen/item_action/Destroy()
	owner = null
	return ..()

/obj/screen/item_action/Click()
	if(isnull(usr) || isnull(owner))
		return 1
	if(usr.next_move >= world.time)
		return
	usr.next_move = world.time + 6

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click()
	return 1

//This is the proc used to update all the action buttons. It just returns for all mob types except humans.
/mob/proc/update_action_buttons()
	return