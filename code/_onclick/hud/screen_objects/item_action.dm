/atom/movable/screen/item_action
	var/obj/item/owner

/atom/movable/screen/item_action/New(obj/item/O)
	. = ..()
	owner = O

/atom/movable/screen/item_action/Destroy()
	owner = null
	return ..()

/atom/movable/screen/item_action/Click()
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

// This is the proc used to update all the action buttons.
/mob/living/carbon/human/proc/update_action_buttons()
	var/num = 1
	if(isnull(client))
		return
	if(isnull(hud_used))
		return
	var/datum/hud/human/human_hud = hud_used
	if(!human_hud.hud_shown)	//Hud toggled to minimal
		return

	client.screen.Remove(human_hud.item_actions)

	human_hud.item_actions = list()
	for(var/obj/item/I in src)
		if(isnotnull(I.icon_action_button))
			var/atom/movable/screen/item_action/A = new /atom/movable/screen/item_action(I)
			//A.icon = 'icons/mob/screen/screen1_action.dmi'
			//A.icon_state = I.icon_action_button
			A.icon = ui_style2icon(client.prefs.UI_style)
			A.icon_state = "template"
			var/image/img = image(I.icon, A, I.icon_state)
			img.pixel_x = 0
			img.pixel_y = 0
			A.overlays.Add(img)

			if(isnotnull(I.action_button_name))
				A.name = I.action_button_name
			else
				A.name = "Use [I.name]"
			human_hud.item_actions.Add(A)
			switch(num)
				if(1)
					A.screen_loc = UI_ACTION_SLOT1
				if(2)
					A.screen_loc = UI_ACTION_SLOT2
				if(3)
					A.screen_loc = UI_ACTION_SLOT3
				if(4)
					A.screen_loc = UI_ACTION_SLOT4
				if(5)
					A.screen_loc = UI_ACTION_SLOT5
					break //5 slots available, so no more can be added.
			num++
	client.screen.Add(human_hud.item_actions)