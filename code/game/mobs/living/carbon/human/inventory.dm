/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			to_chat(H, SPAN_NOTICE("You are not holding anything to equip."))
			return
		if(H.equip_to_appropriate_slot(I))
			if(hand)
				update_inv_l_hand(0)
			else
				update_inv_r_hand(0)
		else
			to_chat(H, SPAN_WARNING("You are unable to equip that."))

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for(var/slot in slots)
		if(equip_to_slot_if_possible(W, slots[slot], del_on_fail = 0))
			return slot
	if(del_on_fail)
		qdel(W)
	return null


/mob/living/carbon/human/proc/has_organ(name)
	var/datum/organ/external/O = organs_by_name[name]

	return (O && !(O.status & ORGAN_DESTROYED))

/mob/living/carbon/human/proc/has_organ_for_slot(slot)
	switch(slot)
		if(SLOT_ID_BACK)
			return has_organ("chest")
		if(SLOT_ID_WEAR_MASK)
			return has_organ("head")
		if(SLOT_ID_HANDCUFFED)
			return has_organ("l_hand") && has_organ("r_hand")
		if(SLOT_ID_LEGCUFFED)
			return has_organ("l_leg") && has_organ("r_leg")
		if(SLOT_ID_L_HAND)
			return has_organ("l_hand")
		if(SLOT_ID_R_HAND)
			return has_organ("r_hand")
		if(SLOT_ID_BELT)
			return has_organ("chest")
		if(SLOT_ID_ID_STORE)
			// the only relevant check for this is the uniform check
			return 1
		if(SLOT_ID_L_EAR)
			return has_organ("head")
		if(SLOT_ID_R_EAR)
			return has_organ("head")
		if(SLOT_ID_GLASSES)
			return has_organ("head")
		if(SLOT_ID_GLOVES)
			return has_organ("l_hand") && has_organ("r_hand")
		if(SLOT_ID_HEAD)
			return has_organ("head")
		if(SLOT_ID_SHOES)
			return has_organ("r_foot") && has_organ("l_foot")
		if(SLOT_ID_WEAR_SUIT)
			return has_organ("chest")
		if(SLOT_ID_WEAR_UNIFORM)
			return has_organ("chest")
		if(SLOT_ID_L_POCKET)
			return has_organ("chest")
		if(SLOT_ID_R_POCKET)
			return has_organ("chest")
		if(SLOT_ID_SUIT_STORE)
			return has_organ("chest")
		if(SLOT_ID_IN_BACKPACK)
			return 1

/mob/living/carbon/human/u_equip(obj/item/W)
	if(!W)
		return 0

	var/success

	if(W == wear_suit)
		if(suit_store)
			drop_from_inventory(suit_store)
		if(W)
			success = 1
		wear_suit = null
		if(HAS_INV_FLAGS(W, INV_FLAG_HIDE_SHOES))
			update_inv_shoes(0)
		update_inv_wear_suit()
	else if(W == wear_uniform)
		if(r_pocket)
			drop_from_inventory(r_pocket)
		if(l_pocket)
			drop_from_inventory(l_pocket)
		if(id_store)
			drop_from_inventory(id_store)
		if(belt)
			drop_from_inventory(belt)
		wear_uniform = null
		success = 1
		update_inv_wear_uniform()
	else if(W == gloves)
		gloves = null
		success = 1
		update_inv_gloves()
	else if(W == glasses)
		glasses = null
		success = 1
		update_inv_glasses()
	else if(W == head)
		head = null
		if(HAS_INV_FLAGS(W, INV_FLAG_BLOCK_HAIR) || HAS_INV_FLAGS(W, INV_FLAG_BLOCK_HEAD_HAIR) || HAS_INV_FLAGS(W, INV_FLAG_HIDE_MASK))
			update_hair(0)	//rebuild hair
			update_inv_ears(0)
			update_inv_wear_mask(0)
		success = 1
		update_inv_head()
	else if (W == l_ear)
		l_ear = null
		success = 1
		update_inv_ears()
	else if (W == r_ear)
		r_ear = null
		success = 1
		update_inv_ears()
	else if (W == shoes)
		shoes = null
		success = 1
		update_inv_shoes()
	else if (W == belt)
		belt = null
		success = 1
		update_inv_belt()
	else if (W == wear_mask)
		wear_mask = null
		success = 1
		if(HAS_ATOM_FLAGS(W, INV_FLAG_BLOCK_HAIR) || HAS_ATOM_FLAGS(W, INV_FLAG_BLOCK_HEAD_HAIR))
			update_hair(0)	//rebuild hair
			update_inv_ears(0)
		if(internal)
			if(internals)
				internals.icon_state = "internal0"
			internal = null
		update_inv_wear_mask()
	else if(W == id_store)
		id_store = null
		success = 1
		update_inv_id_store()
	else if (W == r_pocket)
		r_pocket = null
		success = 1
		update_inv_pockets()
	else if (W == l_pocket)
		l_pocket = null
		success = 1
		update_inv_pockets()
	else if (W == suit_store)
		suit_store = null
		success = 1
		update_inv_suit_store()
	else if (W == back)
		back = null
		success = 1
		update_inv_back()
	else if (W == handcuffed)
		handcuffed = null
		success = 1
		update_inv_handcuffed()
	else if (W == legcuffed)
		legcuffed = null
		success = 1
		update_inv_legcuffed()
	else if (W == r_hand)
		r_hand = null
		success = 1
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		success = 1
		update_inv_l_hand()
	else
		return 0

	if(success)
		if(W)
			if(client)
				client.screen -= W
			W.forceMove(loc)
			W.dropped(src)
			//if(W)
				//W.reset_plane_and_layer()
	update_action_buttons()
	return 1

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
//set redraw_mob to 0 if you don't wish the hud to be updated - if you're doing it manually in your own proc.
/mob/living/carbon/human/equip_to_slot(obj/item/W, slot, redraw_mob = 1)
	if(!slot)
		return
	if(!istype(W))
		return
	if(!has_organ_for_slot(slot))
		return

	if(W == src.l_hand)
		src.l_hand = null
		update_inv_l_hand() //So items actually disappear from hands.
	else if(W == src.r_hand)
		src.r_hand = null
		update_inv_r_hand()

	W.forceMove(src)
	switch(slot)
		if(SLOT_ID_BACK)
			src.back = W
			W.equipped(src, slot)
			update_inv_back(redraw_mob)
		if(SLOT_ID_WEAR_MASK)
			src.wear_mask = W
			if(HAS_ATOM_FLAGS(wear_mask, INV_FLAG_BLOCK_HAIR) || HAS_ATOM_FLAGS(wear_mask, INV_FLAG_BLOCK_HEAD_HAIR))
				update_hair(redraw_mob)	//rebuild hair
				update_inv_ears(0)
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
		if(SLOT_ID_BELT)
			src.belt = W
			W.equipped(src, slot)
			update_inv_belt(redraw_mob)
		if(SLOT_ID_ID_STORE)
			src.id_store = W
			W.equipped(src, slot)
			update_inv_id_store(redraw_mob)
		if(SLOT_ID_L_EAR)
			src.l_ear = W
			if(l_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.forceMove(src)
				src.r_ear = O
				O.layer_to_hud()
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(SLOT_ID_R_EAR)
			src.r_ear = W
			if(r_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.forceMove(src)
				src.l_ear = O
				O.layer_to_hud()
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(SLOT_ID_GLASSES)
			src.glasses = W
			W.equipped(src, slot)
			update_inv_glasses(redraw_mob)
		if(SLOT_ID_GLOVES)
			src.gloves = W
			W.equipped(src, slot)
			update_inv_gloves(redraw_mob)
		if(SLOT_ID_HEAD)
			src.head = W
			if(HAS_ATOM_FLAGS(head, INV_FLAG_BLOCK_HAIR) || HAS_ATOM_FLAGS(head, INV_FLAG_BLOCK_HEAD_HAIR) || HAS_INV_FLAGS(head, INV_FLAG_HIDE_MASK))
				update_hair(redraw_mob)	//rebuild hair
				update_inv_ears(0)
				update_inv_wear_mask(0)
			if(istype(W, /obj/item/clothing/head/kitty))
				W.update_icon(src)
			W.equipped(src, slot)
			update_inv_head(redraw_mob)
		if(SLOT_ID_SHOES)
			src.shoes = W
			W.equipped(src, slot)
			update_inv_shoes(redraw_mob)
		if(SLOT_ID_WEAR_SUIT)
			src.wear_suit = W
			if(HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_SHOES))
				update_inv_shoes(0)
			W.equipped(src, slot)
			update_inv_wear_suit(redraw_mob)
		if(SLOT_ID_WEAR_UNIFORM)
			src.wear_uniform = W
			W.equipped(src, slot)
			update_inv_wear_uniform(redraw_mob)
		if(SLOT_ID_L_POCKET)
			src.l_pocket = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(SLOT_ID_R_POCKET)
			src.r_pocket = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(SLOT_ID_SUIT_STORE)
			src.suit_store = W
			W.equipped(src, slot)
			update_inv_suit_store(redraw_mob)
		if(SLOT_ID_IN_BACKPACK)
			if(src.get_active_hand() == W)
				src.u_equip(W)
			W.forceMove(back)
			W.layer_to_hud()
		else
			to_chat(src, SPAN_WARNING("You are trying to eqiip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..."))
			return

	return

/obj/effect/equip_e
	name = "equip e"
	var/mob/source = null
	var/s_loc = null	//source location
	var/t_loc = null	//target location
	var/obj/item/item = null
	var/place = null

/obj/effect/equip_e/human
	name = "human"
	var/mob/living/carbon/human/target = null

/obj/effect/equip_e/monkey
	name = "monkey"
	var/mob/living/carbon/monkey/target = null

/obj/effect/equip_e/process()
	return

/obj/effect/equip_e/proc/done()
	return

/obj/effect/equip_e/New()
	if(!global.PCticker)
		qdel(src)
	spawn(100)
		qdel(src)
	..()
	return

/obj/effect/equip_e/human/process()
	if(item)
		item.add_fingerprint(source)
	else
		switch(place)
			if("mask")
				if(!(target.wear_mask))
					qdel(src)
			if("l_hand")
				if(!(target.l_hand))
					qdel(src)
			if("r_hand")
				if(!(target.r_hand))
					qdel(src)
			if("suit")
				if(!(target.wear_suit))
					qdel(src)
			if("uniform")
				if(!(target.wear_uniform))
					qdel(src)
			if("back")
				if(!(target.back))
					qdel(src)
			if("syringe")
				return
			if("pill")
				return
			if("fuel")
				return
			if("drink")
				return
			if("dnainjector")
				return
			if("handcuff")
				if(!(target.handcuffed))
					qdel(src)
			if("id")
				if((!(target.id_store) || !(target.wear_uniform)))
					qdel(src)
			if("splints")
				var/count = 0
				for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
					var/datum/organ/external/o = target.organs_by_name[organ]
					if(o.status & ORGAN_SPLINTED)
						count = 1
						break
				if(count == 0)
					qdel(src)
					return
			if("internal")
				if ((!((istype(target.wear_mask, /obj/item/clothing/mask) && istype(target.back, /obj/item/tank) && !(target.internal))) && !(target.internal)))
					qdel(src)

	var/list/L = list( "syringe", "pill", "drink", "dnainjector", "fuel")
	if((item && !(L.Find(place))))
		if(isrobot(source) && place != "handcuff")
			qdel(src)
		target.visible_message(SPAN_DANGER("[source] is trying to put \a [item] on [target]!"))
	else
		var/message = null
		switch(place)
			if("syringe")
				message = SPAN_DANGER("[source] is trying to inject [target]!")
			if("pill")
				message = SPAN_DANGER("[source] is trying to force [target] to swallow [item]!")
			if("drink")
				message = SPAN_DANGER("[source] is trying to force [target] to swallow a gulp of [item]!")
			if("dnainjector")
				message = SPAN_DANGER("[source] is trying to inject [target] with the [item]!")
			if("mask")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Had their mask removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) mask</font>"
				if(isnotnull(target.wear_mask) && !target.wear_mask.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.wear_mask] from [target]'s head!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off \a [target.wear_mask] from [target]'s head!")
			if("l_hand")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their left hand item ([target.l_hand]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) left hand item ([target.l_hand])</font>"
				message = SPAN_DANGER("[source] is trying to take off \a [target.l_hand] from [target]'s left hand!")
			if("r_hand")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their right hand item ([target.r_hand]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) right hand item ([target.r_hand])</font>"
				message = SPAN_DANGER("[source] is trying to take off \a [target.r_hand] from [target]'s right hand!")
			if("gloves")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their gloves ([target.gloves]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) gloves ([target.gloves])</font>"
				if(isnotnull(target.gloves) && !target.gloves.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.gloves] from [target]'s hands!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off the [target.gloves] from [target]'s hands!")
			if("eyes")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their eyewear ([target.glasses]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) eyewear ([target.glasses])</font>"
				if(isnotnull(target.glasses) && !target.glasses.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.glasses] from [target]'s eyes!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off the [target.glasses] from [target]'s eyes!")
			if("l_ear")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their left ear item ([target.l_ear]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) left ear item ([target.l_ear])</font>"
				if(isnotnull(target.l_ear) && !target.l_ear.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.l_ear] from [target]'s left ear!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off the [target.l_ear] from [target]'s left ear!")
			if("r_ear")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their right ear item ([target.r_ear]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) right ear item ([target.r_ear])</font>"
				if(isnotnull(target.r_ear) && !target.r_ear.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.r_ear] from [target]'s right ear!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off the [target.r_ear] from [target]'s right ear!")
			if("head")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their hat ([target.head]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) hat ([target.head])</font>"
				if(isnotnull(target.head) && !target.head.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.head] from [target]'s head!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off the [target.head] from [target]'s head!")
			if("shoes")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their shoes ([target.shoes]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) shoes ([target.shoes])</font>"
				if(isnotnull(target.shoes) && !target.shoes.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.shoes] from [target]'s feet!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off the [target.shoes] from [target]'s feet!")
			if("belt")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their belt item ([target.belt]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) belt item ([target.belt])</font>"
				message = SPAN_DANGER("[source] is trying to take off the [target.belt] from [target]'s belt!")
			if("suit")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their suit ([target.wear_suit]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) suit ([target.wear_suit])</font>"
				if(isnotnull(target.wear_suit) && !target.wear_suit.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.wear_suit] from [target]'s body!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off \a [target.wear_suit] from [target]'s body!")
			if("back")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their back item ([target.back]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) back item ([target.back])</font>"
				message = SPAN_DANGER("[source] is trying to take off \a [target.back] from [target]'s back!")
			if("handcuff")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Was unhandcuffed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to unhandcuff [target.name]'s ([target.ckey])</font>"
				message = SPAN_DANGER("[source] is trying to unhandcuff [target]!")
			if("legcuff")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Was unlegcuffed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to unlegcuff [target.name]'s ([target.ckey])</font>"
				message = SPAN_DANGER("[source] is trying to unlegcuff [target]!")
			if("uniform")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their uniform ([target.wear_uniform]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) uniform ([target.wear_uniform])</font>"
				for(var/obj/item/I in list(target.l_pocket, target.r_pocket))
					if(I.on_found(source))
						return
				if(isnotnull(target.wear_uniform) && !target.wear_uniform.can_remove)
					message = SPAN_DANGER("[source] fails to take off \a [target.wear_uniform] from [target]'s body!")
					return
				else
					message = SPAN_DANGER("[source] is trying to take off \a [target.wear_uniform] from [target]'s body!")
			if("suit_store")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their suit storage item ([target.suit_store]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) suit storage item ([target.suit_store])</font>"
				message = SPAN_DANGER("[source] is trying to take off \a [target.suit_store] from [target]'s suit!")
			if("pockets")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their pockets emptied by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to empty [target.name]'s ([target.ckey]) pockets</font>"
				for(var/obj/item/I in list(target.l_pocket, target.r_pocket))
					if(I.on_found(source))
						return
				message = SPAN_DANGER("[source] is trying to empty [target]'s pockets!")
			if("CPR")
				if(!target.cpr_time)
					qdel(src)
				target.cpr_time = FALSE
				message = SPAN_DANGER("[source] is trying perform CPR on [target]!")
			if("id")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their ID ([target.id_store]) removed by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) ID ([target.id_store])</font>"
				message = SPAN_DANGER("[source] is trying to take off [target.id_store] from [target]'s uniform!")
			if("internal")
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their internals toggled by [source.name] ([source.ckey])</font>"
				source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to toggle [target.name]'s ([target.ckey]) internals</font>"
				if (target.internal)
					message = SPAN_DANGER("[source] is trying to remove [target]'s internals!")
				else
					message = SPAN_DANGER("[source] is trying to set on [target]'s internals.")
			if("splints")
				message = SPAN_DANGER("[source] is trying to remove [target]'s splints!")

		target.visible_message(message)
	spawn(HUMAN_STRIP_DELAY)
		done()

/*
This proc equips stuff (or does something else) when removing stuff manually from the character window when you click and drag.
It works in conjuction with the process() above.
This proc works for humans only. Aliens stripping humans and the like will all use this proc. Stripping monkeys or somesuch will use their version of this proc.
The first if statement for "mask" and such refers to items that are already equipped and un-equipping them.
The else statement is for equipping stuff to empty slots.
!canremove refers to variable of /obj/item/clothing which either allows or disallows that item to be removed.
It can still be worn/put on as normal.
*/
/obj/effect/equip_e/human/done()	//TODO: And rewrite this :< ~Carn
	target.cpr_time = TRUE
	if(issimple(source)) return //animals cannot strip people
	if(!source || !target) return		//Target or source no longer exist
	if(source.loc != s_loc) return		//source has moved
	if(target.loc != t_loc) return		//target has moved
	if(LinkBlocked(s_loc,t_loc)) return	//Use a proxi!
	if(item && source.get_active_hand() != item) return	//Swapped hands / removed item from the active one
	if ((source.restrained() || source.stat)) return //Source restrained or unconscious / dead

	var/slot_to_process
	var/strip_item //this will tell us which item we will be stripping - if any.

	switch(place)	//here we go again...
		if("mask")
			slot_to_process = SLOT_ID_WEAR_MASK
			if (target.wear_mask && target.wear_mask.can_remove)
				strip_item = target.wear_mask
		if("gloves")
			slot_to_process = SLOT_ID_GLOVES
			if (target.gloves && target.gloves.can_remove)
				strip_item = target.gloves
		if("eyes")
			slot_to_process = SLOT_ID_GLASSES
			if (target.glasses)
				strip_item = target.glasses
		if("belt")
			slot_to_process = SLOT_ID_BELT
			if (target.belt)
				strip_item = target.belt
		if("suit_store")
			slot_to_process = SLOT_ID_SUIT_STORE
			if (target.suit_store)
				strip_item = target.suit_store
		if("head")
			slot_to_process = SLOT_ID_HEAD
			if (target.head && target.head.can_remove)
				strip_item = target.head
		if("l_ear")
			slot_to_process = SLOT_ID_L_EAR
			if (target.l_ear)
				strip_item = target.l_ear
		if("r_ear")
			slot_to_process = SLOT_ID_R_EAR
			if (target.r_ear)
				strip_item = target.r_ear
		if("shoes")
			slot_to_process = SLOT_ID_SHOES
			if (target.shoes && target.shoes.can_remove)
				strip_item = target.shoes
		if("l_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				qdel(src)
			slot_to_process = SLOT_ID_L_HAND
			if (target.l_hand)
				strip_item = target.l_hand
		if("r_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				qdel(src)
			slot_to_process = SLOT_ID_R_HAND
			if (target.r_hand)
				strip_item = target.r_hand
		if("uniform")
			slot_to_process = SLOT_ID_WEAR_UNIFORM
			if(target.wear_uniform && target.wear_uniform.can_remove)
				strip_item = target.wear_uniform
		if("suit")
			slot_to_process = SLOT_ID_WEAR_SUIT
			if (target.wear_suit && target.wear_suit.can_remove)
				strip_item = target.wear_suit
		if("id")
			slot_to_process = SLOT_ID_ID_STORE
			if (target.id_store)
				strip_item = target.id_store
		if("back")
			slot_to_process = SLOT_ID_BACK
			if (target.back)
				strip_item = target.back
		if("handcuff")
			slot_to_process = SLOT_ID_HANDCUFFED
			if (target.handcuffed)
				strip_item = target.handcuffed
		if("legcuff")
			slot_to_process = SLOT_ID_LEGCUFFED
			if (target.legcuffed)
				strip_item = target.legcuffed
		if("splints")
			for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
				var/datum/organ/external/o = target.get_organ(organ)
				if (o && o.status & ORGAN_SPLINTED)
					var/obj/item/W = new /obj/item/stack/medical/splint(amount=1)
					o.status &= ~ORGAN_SPLINTED
					if (W)
						W.forceMove(target.loc)
						W.reset_plane_and_layer()
						W.add_fingerprint(source)
		if("CPR")
			if(target.health > CONFIG_GET(/decl/configuration_entry/health_threshold_dead) && target.health < CONFIG_GET(/decl/configuration_entry/health_threshold_crit))
				var/suff = min(target.getOxyLoss(), 5) //Pre-merge level, less healing, more prevention of dieing.
				target.adjustOxyLoss(-suff)
				target.updatehealth()
				source.visible_message(
					SPAN_WARNING("[source] performs CPR on [target]!"),
					SPAN_INFO("You perform CPR on [target]!")
				)
				to_chat(target, SPAN_INFO_B("You feel a breath of fresh air enter your lungs. It feels good."))
				to_chat(source, SPAN_WARNING("Repeat at least every 7 seconds."))
		if("dnainjector")
			var/obj/item/dnainjector/S = item
			if(S)
				S.add_fingerprint(source)
				if(!istype(S, /obj/item/dnainjector))
					S.inuse = 0
					qdel(src)
				S.inject(target, source)
				if(S.s_time >= world.time + 30)
					S.inuse = 0
					qdel(src)
				S.s_time = world.time
				source.visible_message(SPAN_WARNING("[source] injects [target] with the [S]!"))
				S.inuse = 0
		if("pockets")
			slot_to_process = SLOT_ID_L_POCKET
			strip_item = target.l_pocket		//We'll do both
		if("internal")
			if (target.internal)
				target.internal.add_fingerprint(source)
				target.internal = null
				if (target.internals)
					target.internals.icon_state = "internal0"
			else
				if(!istype(target.wear_mask, /obj/item/clothing/mask))
					return
				else
					if(istype(target.back, /obj/item/tank))
						target.internal = target.back
					else if(istype(target.suit_store, /obj/item/tank))
						target.internal = target.suit_store
					else if(istype(target.belt, /obj/item/tank))
						target.internal = target.belt
					if(target.internal)
						target.visible_message("[target] is now running on internals.")
						target.internal.add_fingerprint(source)
						if(target.internals)
							target.internals.icon_state = "internal1"
	if(slot_to_process)
		if(strip_item) //Stripping an item from the mob
			var/obj/item/W = strip_item
			target.u_equip(W)
			if (target.client)
				target.client.screen -= W
			if (W)
				W.forceMove(target.loc)
				W.reset_plane_and_layer()
				W.dropped(target)
			W.add_fingerprint(source)
			if(slot_to_process == SLOT_ID_L_POCKET) //pockets! Needs to process the other one too. Snowflake code, wooo! It's not like anyone will rewrite this anytime soon. If I'm wrong then... CONGRATULATIONS! ;)
				if(target.r_pocket)
					target.u_equip(target.r_pocket) //At this stage l_pocket is already processed by the code above, we only need to process r_pocket.
		else
			if(item && target.has_organ_for_slot(slot_to_process)) //Placing an item on the mob
				if(item.mob_can_equip(target, slot_to_process, FALSE))
					source.u_equip(item)
					target.equip_to_slot_if_possible(item, slot_to_process, 0, 1, 1)
					item.dropped(source)
					source.update_icons()
					target.update_icons()

	if(source && target)
		if(source.machine == target)
			target.show_inv(source)
	qdel(src)
