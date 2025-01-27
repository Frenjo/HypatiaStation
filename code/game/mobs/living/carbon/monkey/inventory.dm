/obj/effect/equip_e/monkey/process()
	if (item)
		item.add_fingerprint(source)
	if (!( item ))
		switch(place)
			if("head")
				if (!( target.wear_mask ))
					qdel(src)
					return
			if("l_hand")
				if (!( target.l_hand ))
					qdel(src)
					return
			if("r_hand")
				if (!( target.r_hand ))
					qdel(src)
					return
			if("back")
				if (!( target.back ))
					qdel(src)
					return
			if("handcuff")
				if (!( target.handcuffed ))
					qdel(src)
					return
			if("internal")
				if ((!( (istype(target.wear_mask, /obj/item/clothing/mask) && istype(target.back, /obj/item/tank) && !( target.internal )) ) && !( target.internal )))
					qdel(src)
					return

	if (item)
		if(isrobot(source) && place != "handcuff")
			var/list/L = list( "syringe", "pill", "drink", "dnainjector", "fuel")
			if(!(L.Find(place)))
				qdel(src)
				return
		target.visible_message(SPAN_DANGER("[source] is trying to put \a [item] on [target]!"))
	else
		var/message = null
		switch(place)
			if("mask")
				if(istype(target.wear_mask, /obj/item/clothing) && !target.wear_mask.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.wear_mask] from [target]'s body!")
				else
					message = SPAN_DANGER("[source] is trying to take off \a [target.wear_mask] from [target]'s head!")
			if("l_hand")
				message = SPAN_DANGER("[source] is trying to take off \a [target.l_hand] from [target]'s left hand!")
			if("r_hand")
				message = SPAN_DANGER("[source] is trying to take off \a [target.r_hand] from [target]'s right hand!")
			if("back")
				message = SPAN_DANGER("[source] is trying to take off \a [target.back] from [target]'s back!")
			if("handcuff")
				message = SPAN_DANGER("[source] is trying to unhandcuff [target]!")
			if("internal")
				if (target.internal)
					message = SPAN_DANGER("[source] is trying to remove [target]'s internals!")
				else
					message = SPAN_DANGER("[source] is trying to set on [target]'s internals.")
			if("pockets")
				message = SPAN_DANGER("[source] is trying to empty [target]'s pockets!")
			else
		target.visible_message(message)
	spawn(30)
		done()

/obj/effect/equip_e/monkey/done()
	if(!source || !target)						return
	if(source.loc != s_loc)						return
	if(target.loc != t_loc)						return
	if(LinkBlocked(s_loc,t_loc))				return
	if(item && source.get_active_hand() != item)	return
	if ((source.restrained() || source.stat))	return
	switch(place)
		if("mask")
			if (target.wear_mask)
				if(istype(target.wear_mask, /obj/item/clothing) && !target.wear_mask.can_remove)
					return
				var/obj/item/W = target.wear_mask
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.forceMove(target.loc)
					W.dropped(target)
					W.reset_plane_and_layer()
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/mask))
					source.drop_item()
					loc = target
					item.layer_to_hud()
					target.wear_mask = item
					item.forceMove(target)
		if("l_hand")
			if (target.l_hand)
				var/obj/item/W = target.l_hand
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.forceMove(target.loc)
					W.reset_plane_and_layer()
					W.dropped(target)
				W.add_fingerprint(source)
			else
				if(isitem(item))
					source.drop_item()
					loc = target
					target.l_hand = item
					item.dropped(source)
					item.equipped(target, target.l_hand)
		if("r_hand")
			if (target.r_hand)
				var/obj/item/W = target.r_hand
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.forceMove(target.loc)
					W.reset_plane_and_layer()
					W.dropped(target)
				W.add_fingerprint(source)
			else
				if(isitem(item))
					source.drop_item()
					loc = target
					target.r_hand = item
					item.dropped(source)
					item.equipped(target, target.r_hand)
		if("back")
			if (target.back)
				var/obj/item/W = target.back
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.forceMove(target.loc)
					W.dropped(target)
					W.reset_plane_and_layer()
				W.add_fingerprint(source)
			else
				if(isitem(item) && (item.slot_flags & SLOT_BACK))
					source.drop_item()
					loc = target
					item.layer_to_hud()
					target.back = item
					item.forceMove(target)
		if("handcuff")
			if (target.handcuffed)
				var/obj/item/W = target.handcuffed
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.forceMove(target.loc)
					W.dropped(target)
					W.reset_plane_and_layer()
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/handcuffs))
					source.drop_item()
					target.handcuffed = item
					item.forceMove(target)
		if("internal")
			if (target.internal)
				target.internal.add_fingerprint(source)
				target.internal = null
			else
				if (target.internal)
					target.internal = null
				if (!( istype(target.wear_mask, /obj/item/clothing/mask) ))
					return
				else
					if (istype(target.back, /obj/item/tank))
						target.internal = target.back
						target.internal.add_fingerprint(source)
						target.visible_message("[target] is now running on internals.")
		else
	source.regenerate_icons()
	target.regenerate_icons()
	qdel(src)
	return



//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
//set redraw_mob to 0 if you don't wish the hud to be updated - if you're doing it manually in your own proc.
/mob/living/carbon/monkey/equip_to_slot(obj/item/W, slot, redraw_mob = 1)
	if(!slot) return
	if(!istype(W)) return

	if(W == get_active_hand())
		u_equip(W)

	switch(slot)
		if(SLOT_ID_BACK)
			src.back = W
			W.equipped(src, slot)
			update_inv_back(redraw_mob)
		if(SLOT_ID_WEAR_MASK)
			src.wear_mask = W
			W.equipped(src, slot)
			update_inv_wear_mask(redraw_mob)
		if(SLOT_ID_HANDCUFFED)
			src.handcuffed = W
			update_inv_handcuffed(redraw_mob)
		if(SLOT_ID_LEGCUFFED)
			src.legcuffed = W
			W.equipped(src, slot)
			update_inv_legcuffed(redraw_mob)
		if(SLOT_ID_L_HAND)
			src.l_hand = W
			W.equipped(src, slot)
			update_inv_l_hand(redraw_mob)
		if(SLOT_ID_R_HAND)
			src.r_hand = W
			W.equipped(src, slot)
			update_inv_r_hand(redraw_mob)
		if(SLOT_ID_IN_BACKPACK)
			W.forceMove(back)
			W.layer_to_hud()
		else
			usr << "\red You are trying to eqip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..."
			return

	return
