/mob/living/carbon/verb/give()
	set category = PANEL_IC
	set name = "Give"
	set src in view(1)

	if(src.stat == DEAD || usr.stat == DEAD || src.client == null)
		return
	if(src == usr)
		to_chat(usr, SPAN_WARNING("I feel stupider, suddenly."))
		return
	var/obj/item/I
	if(!usr.hand && usr.r_hand == null)
		to_chat(usr, SPAN_WARNING("You don't have anything in your right hand to give to [name]."))
		return
	if(usr.hand && usr.l_hand == null)
		to_chat(usr, SPAN_WARNING("You don't have anything in your left hand to give to [name]."))
		return
	if(usr.hand)
		I = usr.l_hand
	else if(!usr.hand)
		I = usr.r_hand
	if(!I)
		return
	if(src.r_hand == null || src.l_hand == null)
		switch(alert(src, "[usr] wants to give you \a [I]?", , "Yes", "No"))
			if("Yes")
				if(!I)
					return
				if(!Adjacent(usr))
					to_chat(usr, SPAN_WARNING("You need to stay in reaching distance while giving an object."))
					to_chat(src, SPAN_WARNING("[usr.name] moved too far away."))
					return
				if((usr.hand && usr.l_hand != I) || (!usr.hand && usr.r_hand != I))
					to_chat(usr, SPAN_WARNING("You need to keep the item in your active hand."))
					to_chat(src, SPAN_WARNING("[usr.name] seems to have given up on giving \the [I] to you."))
					return
				if(src.r_hand != null && src.l_hand != null)
					to_chat(usr, SPAN_WARNING("Their hands are full."))
					to_chat(src, SPAN_WARNING("Your hands are full."))
					return
				else
					usr.drop_item()
					if(src.r_hand == null)
						src.r_hand = I
					else
						src.l_hand = I
				I.forceMove(src)
				I.layer_to_hud()
				I.add_fingerprint(src)
				src.update_inv_l_hand()
				src.update_inv_r_hand()
				usr.update_inv_l_hand()
				usr.update_inv_r_hand()
				src.visible_message("\blue [usr.name] handed \the [I.name] to [src.name].")
			if("No")
				src.visible_message("\red [usr.name] tried to hand [I.name] to [src.name] but [src.name] didn't want it.")
	else
		to_chat(usr, SPAN_WARNING("[src.name]'s hands are full."))