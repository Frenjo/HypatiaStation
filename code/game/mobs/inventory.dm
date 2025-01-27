//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

// Returns the thing in our active hand.
/mob/proc/get_active_hand()
	return hand ? l_hand : r_hand

/mob/living/silicon/get_active_hand()
	return null

/mob/living/silicon/robot/get_active_hand()
	return module_active

// Returns the thing in our inactive hand.
/mob/proc/get_inactive_hand()
	return hand ? r_hand : l_hand

// Puts the item into your l_hand if possible and calls all necessary triggers/updates.
// Returns TRUE on success.
/mob/proc/put_in_l_hand(obj/item/W)
	if(lying)
		return FALSE
	if(!istype(W))
		return FALSE
	if(isnotnull(l_hand))
		return FALSE

	l_hand = W
//	l_hand.screen_loc = ui_lhand
	W.equipped(src, SLOT_ID_L_HAND)
	client?.screen |= W
	if(pulling == W)
		stop_pulling()
	update_inv_l_hand()
	return TRUE

// Puts the item into your r_hand if possible and calls all necessary triggers/updates.
// Returns TRUE on success.
/mob/proc/put_in_r_hand(obj/item/W)
	if(lying)
		return FALSE
	if(!istype(W))
		return FALSE
	if(isnotnull(r_hand))
		return FALSE

	r_hand = W
//	r_hand.screen_loc = ui_rhand
	W.equipped(src, SLOT_ID_R_HAND)
	client?.screen |= W
	if(pulling == W)
		stop_pulling()
	update_inv_r_hand()
	return TRUE

// Puts the item into our active hand if possible.
// Returns TRUE on success.
/mob/proc/put_in_active_hand(obj/item/W)
	return hand ? put_in_l_hand(W) : put_in_r_hand(W)

// Puts the item into our inactive hand if possible.
// Returns TRUE on success.
/mob/proc/put_in_inactive_hand(obj/item/W)
	return hand ? put_in_r_hand(W) : put_in_l_hand(W)

// Puts the item our active hand if possible. Failing that it tries our inactive hand. Returns TRUE on success.
// If both fail it drops it on the floor and returns FALSE.
// This is probably the main one you need to know :)
/mob/proc/put_in_hands(obj/item/W)
	if(isnull(W))
		return FALSE

	if(put_in_active_hand(W))
		update_inv_l_hand()
		update_inv_r_hand()
		return TRUE
	else if(put_in_inactive_hand(W))
		update_inv_l_hand()
		update_inv_r_hand()
		return TRUE
	else
		W.forceMove(GET_TURF(src))
		W.reset_plane_and_layer()
		W.dropped()
		return FALSE

/mob/proc/drop_item_v()		//this is dumb.
	if(stat == CONSCIOUS && isturf(loc))
		return drop_item()
	return FALSE

/mob/proc/drop_from_inventory(obj/item/W)
	if(isnotnull(W))
		client?.screen -= W
		u_equip(W)
		if(!(W && W.loc))
			return TRUE // self destroying objects (tk, grabs)
		W.reset_plane_and_layer()
		W.forceMove(loc)

		var/turf/T = GET_TURF(src)
		if(isturf(T))
			T.Entered(W)

		W.dropped(src)
		update_icons()
		return TRUE
	return FALSE

// Drops the item in our left hand.
/mob/proc/drop_l_hand(atom/target)
	if(isnull(l_hand))
		return FALSE

	client?.screen.Remove(l_hand)
	l_hand.reset_plane_and_layer()

	l_hand.forceMove(isnotnull(target) ? target.loc : loc)

	var/turf/T = GET_TURF(target)
	T?.Entered(l_hand)

	l_hand.dropped(src)
	l_hand = null
	update_inv_l_hand()
	return TRUE

// Drops the item in our right hand.
/mob/proc/drop_r_hand(atom/target)
	if(isnull(r_hand))
		return FALSE

	client?.screen.Remove(r_hand)
	r_hand.reset_plane_and_layer()

	r_hand.forceMove(isnotnull(target) ? target.loc : loc)

	var/turf/T = GET_TURF(target)
	T?.Entered(r_hand)

	r_hand.dropped(src)
	r_hand = null
	update_inv_r_hand()
	return TRUE

// Drops the item in our active hand.
/mob/proc/drop_item(atom/target)
	return hand ? drop_l_hand(target) : drop_r_hand(target)

//TODO: phase out this proc
/mob/proc/before_take_item(obj/item/W)	//TODO: what is this?
	W.loc = null
	W.reset_plane_and_layer()
	u_equip(W)
	update_icons()

/mob/proc/u_equip(obj/W)
	if(W == r_hand)
		r_hand = null
		update_inv_r_hand(0)
	else if(W == l_hand)
		l_hand = null
		update_inv_l_hand(0)
	else if(W == back)
		back = null
		update_inv_back(0)
	else if(W == wear_mask)
		wear_mask = null
		update_inv_wear_mask(0)

// Attempts to remove an object on a mob.
// Will not move it to another area or such, just removes from the mob.
/mob/proc/remove_from_mob(obj/O)
	u_equip(O)
	client?.screen -= O
	O.reset_plane_and_layer()
	O.screen_loc = null
	return TRUE

// This is very bad and definitely needs properly fixing later.
#define ADD_IF_SLOT_EXISTS(NAME) \
	if(hasvar(src, #NAME)) \
		if(isnotnull(src:NAME)) \
			items.Add(src:NAME)
// Outdated but still in use apparently.
// This should at least be a human proc.
/mob/proc/get_equipped_items()
	var/list/items = list()

	ADD_IF_SLOT_EXISTS(back)
	ADD_IF_SLOT_EXISTS(belt)
	ADD_IF_SLOT_EXISTS(l_ear)
	ADD_IF_SLOT_EXISTS(r_ear)
	ADD_IF_SLOT_EXISTS(glasses)
	ADD_IF_SLOT_EXISTS(gloves)
	ADD_IF_SLOT_EXISTS(head)
	ADD_IF_SLOT_EXISTS(shoes)
	ADD_IF_SLOT_EXISTS(id_store)
	ADD_IF_SLOT_EXISTS(wear_mask)
	ADD_IF_SLOT_EXISTS(wear_suit)
	//ADD_IF_SLOT_EXISTS(w_radio) commenting this out since headsets go on your ears now PLEASE DON'T BE MAD KEELIN
	ADD_IF_SLOT_EXISTS(wear_uniform)

	ADD_IF_SLOT_EXISTS(l_hand)
	ADD_IF_SLOT_EXISTS(r_hand)

	return items
#undef ADD_IF_SLOT_EXISTS

// I wish you could add the if-branches from the switch into the macro but that causes everything to break. :(
#define EQUIP_IF_POSSIBLE(SLOT) \
if(isnull(SLOT)) \
	SLOT = W; \
	. = TRUE;
/mob/living/carbon/human/proc/equip_if_possible(obj/item/W, slot, del_on_fail = TRUE) // since byond doesn't seem to have pointers, this seems like the best way to do this :/
	//warning: icky code
	. = FALSE
	switch(slot)
		if(SLOT_ID_BACK)
			EQUIP_IF_POSSIBLE(back)
		if(SLOT_ID_WEAR_MASK)
			EQUIP_IF_POSSIBLE(wear_mask)
		if(SLOT_ID_HANDCUFFED)
			EQUIP_IF_POSSIBLE(handcuffed)
		if(SLOT_ID_L_HAND)
			EQUIP_IF_POSSIBLE(l_hand)
		if(SLOT_ID_R_HAND)
			EQUIP_IF_POSSIBLE(r_hand)
		if(SLOT_ID_BELT)
			if(isnull(belt) && isnotnull(wear_uniform))
				belt = W
				. = TRUE
		if(SLOT_ID_ID_STORE)
			if(isnull(id_store) && isnotnull(wear_uniform))
				id_store = W
				. = TRUE
		if(SLOT_ID_L_EAR)
			EQUIP_IF_POSSIBLE(l_ear)
		if(SLOT_ID_R_EAR)
			EQUIP_IF_POSSIBLE(r_ear)
		if(SLOT_ID_GLASSES)
			EQUIP_IF_POSSIBLE(glasses)
		if(SLOT_ID_GLOVES)
			EQUIP_IF_POSSIBLE(gloves)
		if(SLOT_ID_HEAD)
			EQUIP_IF_POSSIBLE(head)
		if(SLOT_ID_SHOES)
			EQUIP_IF_POSSIBLE(shoes)
		if(SLOT_ID_WEAR_SUIT)
			EQUIP_IF_POSSIBLE(wear_suit)
		if(SLOT_ID_WEAR_UNIFORM)
			EQUIP_IF_POSSIBLE(wear_uniform)
		if(SLOT_ID_L_POCKET)
			if(isnull(l_pocket) && isnotnull(wear_uniform))
				l_pocket = W
				. = TRUE
		if(SLOT_ID_R_POCKET)
			if(isnull(r_pocket) && isnotnull(wear_uniform))
				r_pocket = W
				. = TRUE
		if(SLOT_ID_SUIT_STORE)
			if(isnull(suit_store) && isnotnull(wear_suit))
				suit_store = W
				. = TRUE
		if(SLOT_ID_IN_BACKPACK)
			if(isnotnull(back) && istype(back, /obj/item/storage/backpack))
				var/obj/item/storage/backpack/B = back
				if(length(B.contents) < B.storage_slots && W.w_class <= B.max_w_class)
					W.forceMove(B)
					. = TRUE

	if(.)
		W.layer_to_hud()
		if(isnotnull(back) && W.loc != back)
			W.forceMove(src)
	else
		if(del_on_fail)
			qdel(W)
#undef EQUIP_IF_POSSIBLE

/mob/living/carbon/human/proc/equip_outfit(decl/outfit_path)
	var/decl/hierarchy/outfit/outfit = GET_DECL_INSTANCE(outfit_path)
	if(isnull(outfit))
		return FALSE

	return outfit.equip(src)

/mob/proc/delete_inventory()
	for(var/entry in get_equipped_items())
		drop_from_inventory(entry)
		qdel(entry)